"user strict";

const child_process = require('child_process');  // Node原生的創建子進程模組;
const os = require('os');  // Node原生的操作系統信息模組;
const net = require('net');  // Node原生的網卡網絡操作模組;
const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
const cluster = require('cluster');  // Node原生的支持多進程模組;
// const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
const { AsyncResource } = require('async_hooks');  // 導入 Node.js 原生異步鈎子模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
const { EventEmitter } = require('events');  // 導入 Node.js 原生事件模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
// const kTaskInfo = Symbol('kTaskInfo');  // 用於構建子綫程池;
// const kWorkerFreedEvent = Symbol('kWorkerFreedEvent');  // 用於構建子綫程池;


// 多綫程結構子綫程池化技術 a Worker pool around it could use the following structure;
// http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource
// const { AsyncResource } = require('async_hooks');  // 導入 Node.js 原生異步鈎子模組，用於構建子綫程池;
// const { EventEmitter } = require('events');  // 導入 Node.js 原生事件模組，用於構建子綫程池;
const kTaskInfo = Symbol('kTaskInfo');
const kWorkerFreedEvent = Symbol('kWorkerFreedEvent');
class WorkerPoolTaskInfo extends AsyncResource {
    constructor(callback) {
        super('WorkerPoolTaskInfo');
        this.callback = callback;
    };

    done(err, result) {
        this.runInAsyncScope(this.callback, null, err, result);
        this.emitDestroy();  // `TaskInfo`s are used only once.
    };
};

class WorkerPool extends EventEmitter {
    constructor(numThreads, eval_value, Script_path) {
        super();
        if (numThreads !== null && numThreads !== "") {
            this.numThreads = parseInt(numThreads);
        } else {
            this.numThreads = parseInt(1);
        };        
        this.workers = [];
        this.freeWorkers = [];
        if (Script_path !== null && Script_path !== "") {
            this.Script_path = Script_path;  // require('path').resolve(__dirname, 'task_processor.js') 或者 process.argv[1] 當前運行脚本路徑全名;
        } else {
            this.Script_path = process.argv[1];  // require('path').resolve(__dirname, 'task_processor.js');
        };
        if (eval_value !== null && eval_value !== "") {
            this.eval_value = eval_value;  // false;
        } else {
            this.eval_value = false;
        };

        for (let i = 0; i < numThreads; i++) {
            this.addNewWorker();
        };

        this.help = `
            // 使用示例 This pool could be used as follows;
            // http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource
            // Without the explicit tracking added by the WorkerPoolTaskInfo objects, it would appear that the callbacks are associated with the individual Worker objects.However, the creation of the Workers is not associated with the creation of the tasks and does not provide information about when tasks were scheduled;
            const WorkerPool = require('./worker_pool.js');(numThreads, eval_value, Script_path)
            let numThreads = require('os').cpus().length;
            let eval_value = false;
            let Script_path = require('path').resolve(__dirname, 'task_processor.js');  // 或者 process.argv[1] 當前運行脚本路徑全名;
            const WorkerPool = new WorkerPool(numThreads, eval_value, Script_path);
            // WorkerPool.numThreads = require('os').cpus().length;
            // WorkerPool.eval_value = false;
            // WorkerPool.Script_path = require('path').resolve(__dirname, 'task_processor.js');  // 或者 process.argv[1] 當前運行脚本路徑全名;
            let finished = 0;
            for (let i = 0; i < 10; i++) {
                WorkerPool.runTask({ a: 42, b: 100 }, (error, result) => {
                    console.log(i, error, result);
                    if (++finished === 10) {
                        WorkerPool.close();
                    };
                });
            };
        `;
    };

    addNewWorker() {
    
        // 創建子綫程對象，需要事先導入子綫程模組 const { Worker } = require('worker_threads');
        let Script_code = `
            const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');
            const { AsyncResource } = require('async_hooks');
            const { EventEmitter } = require('events');
            const kTaskInfo = Symbol('kTaskInfo');
            const kWorkerFreedEvent = Symbol('kWorkerFreedEvent');
            class WorkerPoolTaskInfo extends AsyncResource {
                constructor(callback) {
                    super('WorkerPoolTaskInfo');
                    this.callback = callback;
                };
                
                done(err, result) {
                    this.runInAsyncScope(this.callback, null, err, result);
                    this.emitDestroy();  // <TaskInfo>'s are used only once.
                };
            };

            class WorkerPool extends EventEmitter {
                constructor(numThreads, eval_value, Script_path) {
                    super();
                    if (numThreads !== null && numThreads !== "") {
                        this.numThreads = parseInt(numThreads);
                    } else {
                        this.numThreads = parseInt(1);
                    };        
                    this.workers = [];
                    this.freeWorkers = [];
                    if (Script_path !== null && Script_path !== "") {
                        this.Script_path = Script_path;  // require('path').resolve(__dirname, 'task_processor.js') 或者 process.argv[1] 當前運行脚本路徑全名;
                    } else {
                        this.Script_path = process.argv[1];  // require('path').resolve(__dirname, 'task_processor.js');
                    };
                    if (eval_value !== null && eval_value !== "") {
                        this.eval_value = eval_value;  // false;
                    } else {
                        this.eval_value = false;
                    };
                    
                    for (let i = 0; i < numThreads; i++) {
                        this.addNewWorker();
                    };
                };
                
                addNewWorker() {

                    let Script_code = \`${Script_code}\`;

                    if (this.eval_value === null) {
                        this.eval_value = true;
                    };
                    if (this.Script_path === "") {
                        if (this.eval_value) {
                            this.Script_path = Script_code;
                        } else {
                            this.Script_path = process.argv[1];  // require('path').resolve(__dirname, 'task_processor.js');
                        };
                    };

                    // 創建子綫程對象，需要事先導入子綫程模組 const { Worker } = require('worker_threads');
                    const worker = new Worker(this.Script_path, {
                        // workerData: worker_Data,  // <any> 能被克隆並作為 require('worker_threads').workerData 的任何 JavaScript 值。 克隆將會按照 HTML 結構化克隆演算法中描述的進行，如果物件無法被克隆（例如，因為它包含 function），則會拋出錯誤;
                        eval: this.eval_value  // false <boolean> 如果為 true 且第一個參數是一個 string，則將構造函數的第一個參數解釋為工作執行緒連線後執行的腳本。
                    });

                    worker.on('message', (result) => {
                        // In case of success: Call the callback that was passed to <TaskInfo>,
                        // remove the <TaskInfo> associated with the Worker, and mark it as free
                        // again.
                        worker[kTaskInfo].done(null, result);
                        worker[kTaskInfo] = null;
                        this.freeWorkers.push(worker);
                        this.emit(kWorkerFreedEvent);
                    });
                    worker.on('error', (err) => {
                        // In case of an uncaught exception: Call the callback that was passed to
                        // <TaskInfo> with the error.
                        if (worker[kTaskInfo]) {
                            worker[kTaskInfo].done(err, null);
                        } else {
                            this.emit('error', err);
                        };
                        // Remove the worker from the list and start a new Worker to replace the
                        // current one.
                        this.workers.splice(this.workers.indexOf(worker), 1);
                        this.addNewWorker();
                    });
                    this.workers.push(worker);
                    this.freeWorkers.push(worker);
                    this.emit(kWorkerFreedEvent);
                };

                runTask(task, callback) {
                    if (this.freeWorkers.length === 0) {
                        // No free threads, wait until a worker thread becomes free.
                        this.once(kWorkerFreedEvent, () => this.runTask(task, callback));
                        return;
                    };

                    const worker = this.freeWorkers.pop();
                    worker[kTaskInfo] = new WorkerPoolTaskInfo(callback);
                    worker.postMessage(task);
                };

                close() {
                    for (const worker of this.workers) worker.terminate();
                };
            };
        `;

        if (this.Script_path === "") {
            if (this.eval_value) {
                this.Script_path = Script_code;
            } else {
                this.Script_path = process.argv[1];  // require('path').resolve(__dirname, 'task_processor.js');
            };
        };
        // 創建子綫程對象，需要事先導入子綫程模組 const { Worker } = require('worker_threads');
        const worker = new Worker(this.Script_path, {
            // workerData: worker_Data,  // <any> 能被克隆並作為 require('worker_threads').workerData 的任何 JavaScript 值。 克隆將會按照 HTML 結構化克隆演算法中描述的進行，如果物件無法被克隆（例如，因為它包含 function），則會拋出錯誤;
            eval: this.eval_value  // false <boolean> 如果為 true 且第一個參數是一個 string，則將構造函數的第一個參數解釋為工作執行緒連線後執行的腳本。
            // argv: process.argv,  // <any[]> 參數清單，其將會被字串化並附加到工作執行緒中的 process.argv。 這大部分與 workerData 相似，但是這些值將會在全域的 process.argv 中可用，就好像它們是作為 CLI 選項傳給腳本一樣;
            // env: process.env,  // <Object> 如果設置，則指定工作執行緒中 process.env 的初始值。 作為一個特殊值，worker.SHARE_ENV 可以用於指定父執行緒和子執行緒應該共用它們的環境變數。 在這種情況下，對一個執行緒的 process.env 對象的更改也會影響另一個執行緒。 預設值: process.env;
            // execArgv: process.execPath,  // <string[]> 傳遞給工作執行緒的 node CLI 選項的清單。 不支援 V8 選項（例如 --max-old-space-size）和影響進程的選項（例如 --title）。 如果設置，則它將會作為工作執行緒內部的 process.execArgv 提供。 預設情況下，選項將會從父執行緒繼承;
            // stdin: true,  // <boolean> 如果將其設置為 true，則 worker.stdin 將會提供一個可寫流，其內容將會在工作執行緒中以 process.stdin 出現。 預設情況下，不提供任何資料;
            // stdout: false,  // <boolean> 如果將其設置為 true，則 worker.stdout 將不會自動地通過管道傳遞到父執行緒中的 process.stdout;
            // stderr: false,  // <boolean> 如果將其設置為 true，則 worker.stderr 將不會自動地通過管道傳遞到父執行緒中的 process.stderr;
            // trackUnmanagedFds: false,  // <boolean> If this is set to true, then the Worker will track raw file descriptors managed through fs.open() and fs.close(), and close them when the Worker exits, similar to other resources like network sockets or file descriptors managed through the FileHandle API. This option is automatically inherited by all nested Workers. Default: false;
            // transferList: [],  // <Object[]> If one or more MessagePort-like objects are passed in workerData, a transferList is required for those items or ERR_MISSING_MESSAGE_PORT_IN_TRANSFER_LIST will be thrown. See port.postMessage() for more information;
            // resourceLimits: {
            // // 參數 resourceLimits: 值類型為 <Object> 新的 JS 引擎實例的一組可選的資源限制。 達到這些限制將會導致終止 Worker 實例。 這些限制僅影響 JS 引擎，並且不影響任何外部資料，包括 ArrayBuffers。 即使設置了這些限制，如果遇到全域記憶體不足的情況，該進程仍可能中止;
            //     maxOldGenerationSizeMb: 4,  // <number> 主堆的最大大小，以 MB 為單位;
            //     maxYoungGenerationSizeMb: 4,  // <number> 最近創建的對象的堆空間的最大大小;
            //     codeRangeSizeMb: 4,  // <number> 用於生成代碼的預分配的記憶體範圍的大小;
            //     stackSizeMb: 4  // <number> The default maximum stack size for the thread.Small values may lead to unusable Worker instances.Default: 4;
            // }
        });        

        worker.on('message', (result) => {
            // In case of success: Call the callback that was passed to `runTask`,
            // remove the `TaskInfo` associated with the Worker, and mark it as free
            // again.
            worker[kTaskInfo].done(null, result);
            worker[kTaskInfo] = null;
            this.freeWorkers.push(worker);
            this.emit(kWorkerFreedEvent);
        });
        worker.on('error', (err) => {
            // In case of an uncaught exception: Call the callback that was passed to
            // `runTask` with the error.
            if (worker[kTaskInfo]) {
                worker[kTaskInfo].done(err, null);
            } else {
                this.emit('error', err);
            };
            // Remove the worker from the list and start a new Worker to replace the
            // current one.
            this.workers.splice(this.workers.indexOf(worker), 1);
            this.addNewWorker();
        });
        this.workers.push(worker);
        this.freeWorkers.push(worker);
        this.emit(kWorkerFreedEvent);
    };

    runTask(task, callback) {
        if (this.freeWorkers.length === 0) {
            // No free threads, wait until a worker thread becomes free.
            this.once(kWorkerFreedEvent, () => this.runTask(task, callback));
            return;
        };

        const worker = this.freeWorkers.pop();
        worker[kTaskInfo] = new WorkerPoolTaskInfo(callback);
        worker.postMessage(task);
    };

    close() {
        for (const worker of this.workers) {
            worker.terminate();
        };
    };
};
module.exports.WorkerPool = WorkerPool;
// // 使用示例 This pool could be used as follows;
// // Without the explicit tracking added by the WorkerPoolTaskInfo objects, it would appear that the callbacks are associated with the individual Worker objects.However, the creation of the Workers is not associated with the creation of the tasks and does not provide information about when tasks were scheduled;
// const WorkerPool = require('./worker_pool.js');(numThreads, eval_value, Script_path)
// let numThreads = require('os').cpus().length;
// let eval_value = false;
// let Script_path = require('path').resolve(__dirname, 'task_processor.js');  // 或者 process.argv[1] 當前運行脚本路徑全名;
// const WorkerPool = new WorkerPool(numThreads, eval_value, Script_path);
// // WorkerPool.numThreads = require('os').cpus().length;
// // WorkerPool.eval_value = false;
// // WorkerPool.Script_path = require('path').resolve(__dirname, 'task_processor.js');  // 或者 process.argv[1] 當前運行脚本路徑全名;
// let finished = 0;
// for (let i = 0; i < 10; i++) {
//     WorkerPool.runTask({ a: 42, b: 100 }, (error, result) => {
//         console.log(i, error, result);
//         if (++finished === 10) {
//             WorkerPool.close();
//         };
//     });
// };


// 'utf8' 字符串轉二進制數組;
function CharStrToBytesArr(str) {
    let bytes = new Array();
    let c = "";
    for (let i = 0; i < str.length; i++) {
        c = str.charCodeAt(i);
        if (c >= 0x010000 && c <= 0x10FFFF) {
            bytes.push(((c >> 18) & 0x07) | 0xF0);
            bytes.push(((c >> 12) & 0x3F) | 0x80);
            bytes.push(((c >> 6) & 0x3F) | 0x80);
            bytes.push((c & 0x3F) | 0x80);
        } else if (c >= 0x000800 && c <= 0x00FFFF) {
            bytes.push(((c >> 12) & 0x0F) | 0xE0);
            bytes.push(((c >> 6) & 0x3F) | 0x80);
            bytes.push((c & 0x3F) | 0x80);
        } else if (c >= 0x000080 && c <= 0x0007FF) {
            bytes.push(((c >> 6) & 0x1F) | 0xC0);
            bytes.push((c & 0x3F) | 0x80);
        } else {
            bytes.push(c & 0xFF);
        };
    };
    return bytes;
};
module.exports.CharStrToBytesArr = CharStrToBytesArr; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 二進制數組轉 'utf8' 字符串;
function BytesArrToCharStr(arr) {
    if (typeof arr === 'string') {
        return arr;
    };
    let str = '';
    let _arr = arr;
    for (let i = 0; i < _arr.length; i++) {
        let one = _arr[i].toString(2);
        let v = one.match(/^1+?(?=0)/);
        if (v && one.length == 8) {
            let bytesLength = v[0].length;
            let store = _arr[i].toString(2).slice(7 - bytesLength);
            for (let st = 1; st < bytesLength; st++) {
                store += _arr[st + i].toString(2).slice(2);
            };
            str += String.fromCharCode(parseInt(store, 2));
            i += bytesLength - 1;
        } else {
            str += String.fromCharCode(_arr[i]);
        };
    };
    return str;
};
module.exports.BytesArrToCharStr = BytesArrToCharStr; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 自定義函數，檢測輸入的監聽主機 IP 地址類型，是否爲：IPv6，或是：IPv4;
function check_ip(address) {
    // IPv6 地址由八組四位十六進制數（0-9a-fA-F）構成，每組之間用冒號（:）分隔;
    let IPv6_regex = /^(::)?((([\da-f]{1,4}:){7}[\da-f]{1,4})|(([\da-f]{1,4}:){5}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){4}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){3}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){2}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:)(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})))$/;
    // IPv4 地址由四組數字（0-255）組成，每組之間用點號（.）分隔;
    let IPv4_regex = /^(\d{1,3}\.){3}(\d{1,3})$/;

    if (Object.prototype.toString.call(address).toLowerCase() === '[object string]' && IPv6_regex.test(address)) {
        return "IPv6";
    } else if (Object.prototype.toString.call(address).toLowerCase() === '[object string]' && IPv4_regex.test(address)) {
        return "IPv4";
    } else {
        return false;
    };
};
module.exports.check_ip = check_ip; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 自定義封裝的函數isStringJSON(str)判斷一個字符串是否爲 JSON 格式的字符串;
function isStringJSON(str) {
    // 首先判斷傳入參數 str 是否為一個字符串 typeof (str) === 'string'，如果不是字符串直接返回錯誤;
    if (Object.prototype.toString.call(str).toLowerCase() === '[object string]') {
        try {
            let Obj = JSON.parse(str);
            // 使用語句 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) 判斷 Obj 是否為一個 JSON 對象;
            if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) {
                return true;
            } else {
                return false;
            };
        } catch (error) {
            // console.log(error);
            return false;
        } finally {
            // ;
        };
    } else {
        // console.log("It is not a String!");
        return false;
    };
};
module.exports.isStringJSON = isStringJSON; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義函數，對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// https://www.npmjs.com/package/js-base64
class Base64 {

    constructor () {
        // private property
        let _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        // public method for encoding
        this.encode = function (input) {
            let output = "";
            let chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            let i = 0;
            input = this._utf8_encode(input);
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                };
                output = output + _keyStr.charAt(enc1) + _keyStr.charAt(enc2) + _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
            };
            return output;
        };

        // public method for decoding
        this.decode = function (input) {
            let output = "";
            let chr1, chr2, chr3;
            let enc1, enc2, enc3, enc4;
            let i = 0;
            if (typeof(input) !== "undefined" && input !== null) {
                input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
                while (i < input.length) {
                    enc1 = _keyStr.indexOf(input.charAt(i++));
                    enc2 = _keyStr.indexOf(input.charAt(i++));
                    enc3 = _keyStr.indexOf(input.charAt(i++));
                    enc4 = _keyStr.indexOf(input.charAt(i++));
                    chr1 = (enc1 << 2) | (enc2 >> 4);
                    chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                    chr3 = ((enc3 & 3) << 6) | enc4;
                    output = output + String.fromCharCode(chr1);
                    if (enc3 != 64) {
                        output = output + String.fromCharCode(chr2);
                    }
                    if (enc4 != 64) {
                        output = output + String.fromCharCode(chr3);
                    };
                };
                output = this._utf8_decode(output);
            };
            return output;
        };
    };

    // private method for UTF-8 encoding
    _utf8_encode = function (str) {
        str = String(str);
        str = str.replace(/\r\n/g, "\n");
        let utftext = "";
        for (let n = 0; n < str.length; n++) {
            let c = str.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            };

        };
        return utftext;
    };

    // private method for UTF-8 decoding
    _utf8_decode = function (utftext) {
        let string = "";
        let i = 0;
        let c = 0;
        let c1 = 0;
        let c2 = 0;
        let c3 = 0;
        while (i < utftext.length) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            };
        };
        return string;
    };
};
// let base64 = new Base64();
module.exports.Base64 = Base64; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 調用示例：
// const Base64 = Interface.Base64;  // 使用「Interface.js」模塊中的成員「Base64()」函數, 用於對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// 解碼：str = new Base64().decode(base64) ，編碼：base64 = new Base64().encode(str);

// 使用遞歸遍歷的方法深拷貝（複製傳值）對象類型變量（例如，數組和JSON對象等類型的數據），實現思路：拷貝的時候判斷屬性值的類型，如果是物件，繼續遞迴呼叫深拷貝函數;
function deepCopy(obj) {
    // 只拷貝對象;
    if (typeof (obj) !== 'object') return obj;
    // 根據 obj 的類型判斷是新建一個數組還是一個JSON對象;
    let newObj = obj instanceof Array ? [] : {};
    // 遍歷 obj，並且判斷是對象的屬性才拷貝;
    for (let key in obj) {
        if (obj.hasOwnProperty(key)) {
            // 判斷屬性值的類型，如果是對象，則遞歸調用該深拷貝函數;
            newObj[key] = typeof (obj[key]) === 'object' ? deepCopy(obj[key]) : obj[key];
        };
    };
    return newObj;
};
// let newArray = deepCopy(oldArray);
module.exports.deepCopy = deepCopy; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// // 使用遞歸遍歷的方法淺拷貝（引用傳址）對象類型變量（例如，數組和JSON對象等類型的數據），實現思路：遍歷物件，把屬性和屬性值都放在一個新的物件裡;
// function shallowCopy(obj) {
//     // 只拷貝對象;
//     if (typeof (obj) !== 'object') return obj;
//     // 根據 obj 的類型判斷是新建一個數組還是一個JSON對象;
//     let newObj = obj instanceof Array ? [] : {};
//     // 遍歷 obj，並且判斷是對象的屬性才拷貝;
//     for (let key in obj) {
//         if (obj.hasOwnProperty(key)) {
//             newObj[key] = obj[key];
//         };
//     };
//     return newObj;
// };
// // let newArray = shallowCopy(oldArray);
// module.exports.shallowCopy = shallowCopy; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 同步遞歸刪除非空文件夾，首先獲取到該資料夾裡面所有的資訊，遍歷裡面的資訊，判斷是文檔還是資料夾，如果是文檔直接刪除，如果是資料夾，進入資料夾，遞歸重複上述過程;
function deleteDirSync(absolute_path_String) {

    // const path = require('path'); // 導入Node.js原生的路徑處理模塊;
    // const fs = require('fs'); // 導入Node.js原生的文檔處理模塊;

    let absolute_path = require('path').normalize(absolute_path_String); // 規範化路徑;

    let stat = require('fs').statSync(absolute_path); // 同步查詢文檔;
    if (stat.isFile()) {

        // try {
        //     // 同步判斷判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     fs.accessSync(absolute_path, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("文檔: " + absolute_path + " 可以讀寫.");
        //     // 判斷查看的是否為文檔;

        //     require('fs').unlinkSync(absolute_path); // 同步刪除文檔;
        //     console.log("文檔: " + absolute_path + " 已刪除.");
        // } catch (error) {
        //     try {
        //         // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(absolute_path, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("文檔: " + absolute_path + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

        //         // 判斷查看的是否為文檔;
        //         require('fs').unlinkSync(absolute_path); // 同步刪除文檔;
        //         console.log("文檔: " + absolute_path + " 已刪除.");
        //     } catch (error) {
        //         console.log("文檔 [ " + absolute_path + " ] 無操作權限.");
        //         console.error(error);
        //     };
        // };

        // 判斷查看的是否為文檔;
        require('fs').unlinkSync(absolute_path); // 同步刪除文檔;
        console.log("文檔: " + absolute_path + " 已刪除.");
    } else if (stat.isDirectory()) {
        let files = require('fs').readdirSync(absolute_path); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;

        if (files.length > 0) {

            let typeRecognition = true;

            for (let i = 0; i < files.length; i++) {
                let fileName = require('path').join(absolute_path, files[i]); // 使用Node.js原生的路徑處理模塊「path」模塊中的路徑拼接函數獲取文檔全名，與 pathString.concat("/", files[i]) 作用類似;
                // console.log(fileName);
                let stats = require('fs').statSync(fileName); // 同步查詢文檔;
                if (stats.isFile()) {

                    // try {
                    //     // 同步判斷判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    //     fs.accessSync(fileName, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    //     // console.log("目錄: " + fileName + " 可以讀寫.");
                    //     // 判斷查看的是否為文檔;

                    //     require('fs').unlinkSync(fileName); // 同步刪除文檔;
                    //     console.log("文檔: " + fileName + " 已刪除.");
                    // } catch (error) {
                    //     try {
                    //         // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                    //         fs.fchmodSync(fileName, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
                    //         // console.log("目錄: " + fileName + " 操作權限修改為可以讀寫.");
                    //         // 常量                    八進制值    說明
                    //         // fs.constants.S_IRUSR    0o400      所有者可讀
                    //         // fs.constants.S_IWUSR    0o200      所有者可寫
                    //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                    //         // fs.constants.S_IRGRP    0o40       群組可讀
                    //         // fs.constants.S_IWGRP    0o20       群組可寫
                    //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                    //         // fs.constants.S_IROTH    0o4        其他人可讀
                    //         // fs.constants.S_IWOTH    0o2        其他人可寫
                    //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                    //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    //         // 數字	說明
                    //         // 7	可讀、可寫、可執行
                    //         // 6	可讀、可寫
                    //         // 5	可讀、可執行
                    //         // 4	唯讀
                    //         // 3	可寫、可執行
                    //         // 2	只寫
                    //         // 1	只可執行
                    //         // 0	沒有許可權
                    //         // 例如，八進制值 0o765 表示：
                    //         // 1) 、所有者可以讀取、寫入和執行該文檔；
                    //         // 2) 、群組可以讀和寫入該文檔；
                    //         // 3) 、其他人可以讀取和執行該文檔；
                    //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                    //         // 判斷查看的是否為文檔;
                    //         require('fs').unlinkSync(fileName); // 同步刪除文檔;
                    //         console.log("文檔: " + fileName + " 已刪除.");
                    //     } catch (error) {
                    //         console.log("文檔 [ " + fileName + " ] 無操作權限.");
                    //         console.error(error);
                    //     };
                    // };

                    // 判斷查看的是否為文檔;
                    require('fs').unlinkSync(fileName); // 同步刪除文檔;
                    console.log("文檔: " + fileName + " 已刪除.");
                } else if (stats.isDirectory()) {
                    // 判斷查看的是否為文件夾（路徑）;
                    deleteDirSync(fileName);
                    // require('fs').rmdirSync(fileName); // 同步刪除空文件夾;
                } else {
                    console.log("文檔: " + fileName + " 類型無法識別.");
                    typeRecognition = false;
                };
            };

            if (typeRecognition) {
                require('fs').rmdirSync(absolute_path); // 同步刪除空文件夾;
                console.log("文件夾: " + absolute_path + " 已刪除.");
            };

        } else {

            require('fs').rmdirSync(absolute_path); // 同步刪除空文件夾;
            console.log("文件夾: " + absolute_path + " 已刪除.");
        };
    } else {
        console.log("文檔: " + absolute_path + " 類型無法識別.");
    };
};
module.exports.deleteDirSync = deleteDirSync; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 異步遞歸清空非空文件夾，首先獲取到該資料夾裡面所有的資訊，遍歷裡面的資訊，判斷是文檔還是資料夾，如果是文檔直接刪除，如果是資料夾，進入資料夾，遞歸重複上述過程;
function deleteDir(absolute_path_String, callback) {

    // const path = require('path'); // 導入Node.js原生的路徑處理模塊;
    // const fs = require('fs'); // 導入Node.js原生的文檔處理模塊;

    let absolute_path = require('path').normalize(absolute_path_String); // 規範化路徑;
    // 異步查詢文檔;
    require('fs').stat(absolute_path, { bigint: false }, (error, stats) => {
        if (error) {
            console.log("文檔 " + absolute_path + " 無法判斷類別碼.");
            if (callback) { callback(error, null); };
            throw error;
        };

        // 判斷查看的是否為文檔或文件夾（路徑）;
        if (stats.isFile()) {
            // 異步判斷文檔權限，是否可讀require('fs').constants.R_OK、可寫require('fs').constants.W_OK、可執行require('fs').constants.X_OK;
            require('fs').access(absolute_path, 0o777, (error) => {
                if (error) {
                    console.log("無權限操作文檔 " + absolute_path);
                    require('fs').chmod(absolute_path, 0o777, (error) => {
                        if (error) {
                            console.log("文檔 " + absolute_path + " 無法修改操作權限.");
                            throw error;
                        };
                        console.log("文檔 " + absolute_path + " 操作權限已被修改為 0o777");
                        // 異步刪除文檔;
                        require('fs').unlink(absolute_path, (error) => {
                            if (error) {
                                console.log("文檔 " + absolute_path + " 無法刪除.");
                                if (callback) { callback(error, null); };
                                throw error;
                            };
                            console.log("文檔 " + absolute_path + " 已被刪除.");
                            // console.log("目錄: " + absolute_path + " 已清空.");
                            // // 異步刪除空文件夾;
                            // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                            //     if (error) {
                            //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                            //         typeRecognition = false;
                            //         throw error;
                            //     };
                            // });
                            if (callback) { callback(null, absolute_path); };
                        });
                    });

                } else {

                    // 異步刪除文檔;
                    require('fs').unlink(absolute_path, (error) => {
                        if (error) {
                            console.log("文檔 " + absolute_path + " 無法刪除.");
                            if (callback) { callback(error, null); };
                            throw error;
                        };
                        console.log("文檔 " + absolute_path + " 已被刪除.");
                        // console.log("目錄: " + absolute_path + " 已清空.");
                        // // 異步刪除空文件夾;
                        // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                        //     if (error) {
                        //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                        //         typeRecognition = false;
                        //         throw error;
                        //     };
                        // });
                        if (callback) { callback(null, absolute_path); };
                    });
                };
            });

        } else if (stats.isDirectory()) {
            // 異步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
            require('fs').readdir(absolute_path, { encoding: 'utf8', withFileTypes: false }, (error, files) => {

                if (error) {
                    console.log("輸入輸出數據文檔暫存媒介目錄無法讀取 " + absolute_path);
                    console.error(error);
                };

                let fn = 0;  // 記錄已刪除的文檔數目;
                let dn = 0;  // 記錄已刪除的文件夾數目;
                let l = files.length;

                if (files && files.length > 0) {

                    let typeRecognition = true;

                    for (let i = 0; i < files.length; i++) {

                        let fileName = require('path').join(absolute_path, files[i]); // 使用Node.js原生的路徑處理模塊「path」模塊中的路徑拼接函數獲取文檔全名，與 pathString.concat("/", files[i]) 作用類似;
                        // console.log(fileName);

                        // 異步查詢文檔;
                        require('fs').stat(fileName, { bigint: false }, (error, stats) => {

                            if (error) {
                                console.log("文檔 " + fileName + " 無法判斷類別碼.");
                                typeRecognition = false;
                                throw error;
                            };

                            // 判斷查看的是否為文檔或文件夾（路徑）;
                            if (stats.isFile()) {

                                // 異步判斷文檔權限，是否可讀require('fs').constants.R_OK、可寫require('fs').constants.W_OK、可執行require('fs').constants.X_OK;
                                require('fs').access(fileName, 0o777, (error) => {
                                    if (error) {
                                        console.log("無權限操作文檔 " + fileName);
                                        require('fs').chmod(fileName, 0o777, (error) => {
                                            if (error) {
                                                console.log("文檔 " + fileName + " 無法修改操作權限.");
                                                typeRecognition = false;
                                                throw error;
                                            };
                                            console.log("文檔 " + fileName + " 操作權限已被修改為 0o777");
                                            // 異步刪除文檔;
                                            require('fs').unlink(fileName, (error) => {
                                                if (error) {
                                                    console.log("文檔 " + fileName + " 無法刪除.");
                                                    typeRecognition = false;
                                                    throw error;
                                                };
                                                console.log("文檔 " + fileName + " 已被刪除.");
                                                fn = fn + 1;
                                                if ((fn + dn) === files.length) {
                                                    if (typeRecognition) {
                                                        if (callback) { callback("error", null); };
                                                    } else {
                                                        // console.log("目錄: " + absolute_path + " 已清空.");
                                                        // // 異步刪除空文件夾;
                                                        // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                        //     if (error) {
                                                        //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                                                        //         typeRecognition = false;
                                                        //         throw error;
                                                        //     };
                                                        // });
                                                        if (callback) { callback(null, fn + dn); };
                                                    };
                                                };
                                            });
                                        });

                                    } else {

                                        // 異步刪除文檔;
                                        require('fs').unlink(fileName, (error) => {
                                            if (error) {
                                                console.log("文檔 " + fileName + " 無法刪除.");
                                                typeRecognition = false;
                                                throw error;
                                            };
                                            console.log("文檔 " + fileName + " 已被刪除.");
                                            fn = fn + 1;
                                            if ((fn + dn) === files.length) {
                                                if (typeRecognition) {
                                                    if (callback) { callback("error", null); };
                                                } else {
                                                    // console.log("目錄: " + absolute_path + " 已清空.");
                                                    // // 異步刪除空文件夾;
                                                    // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                    //     if (error) {
                                                    //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                                                    //         typeRecognition = false;
                                                    //         throw error;
                                                    //     };
                                                    // });
                                                    if (callback) { callback(null, fn + dn); };
                                                };
                                            };
                                        });
                                    };
                                });

                            } else if (stats.isDirectory()) {

                                // 異步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                                require('fs').readdir(fileName, { encoding: 'utf8', withFileTypes: false }, (error, Sfiles) => {

                                    if (error) {
                                        console.log("輸入輸出數據文檔暫存媒介目錄無法讀取 " + fileName);
                                        console.error(error);
                                    };
                                    if (Sfiles && Sfiles.length > 0) {
                                        deleteDir(fileName);
                                        let id = setInterval(() => {
                                            require('fs').readdir(fileName, { encoding: 'utf8', withFileTypes: false }, (error, SSfiles) => {
                                                if (SSfiles.length === 0) {
                                                    clearInterval(id);  // 清除延時監聽動作;
                                                    // 異步刪除空文件夾;
                                                    require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                        if (error) {
                                                            console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                            typeRecognition = false;
                                                            throw error;
                                                        };
                                                        dn = dn + 1;
                                                        console.log("目錄(文件夾) " + fileName + " 已被刪除.");
                                                        if ((fn + dn) === files.length) {
                                                            if (typeRecognition) {
                                                                if (callback) { callback("error", null); };
                                                            } else {

                                                                // console.log("目錄: " + absolute_path + " 已清空.");
                                                                // // 異步刪除空文件夾;
                                                                // require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                                //     if (error) {
                                                                //         console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                                //         typeRecognition = false;
                                                                //         throw error;
                                                                //     };
                                                                // });
                                                                if (callback) { callback(null, fn + dn); };
                                                            };
                                                        };
                                                    });
                                                };
                                            });
                                        }, 8);
                                    } else {
                                        // 異步刪除空文件夾;
                                        require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                            if (error) {
                                                console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                typeRecognition = false;
                                                throw error;
                                            };
                                            dn = dn + 1;
                                            console.log("目錄(文件夾) " + fileName + " 已被刪除.");
                                            if ((fn + dn) === files.length) {
                                                if (typeRecognition) {
                                                    if (callback) { callback("error", null); };
                                                } else {

                                                    // console.log("目錄: " + absolute_path + " 已清空.");
                                                    // // 異步刪除空文件夾;
                                                    // require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                    //     if (error) {
                                                    //         console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                    //         typeRecognition = false;
                                                    //         throw error;
                                                    //     };
                                                    // });
                                                    if (callback) { callback(null, fn + dn); };
                                                };
                                            };
                                        });
                                    };
                                });

                            } else {

                                console.log("文檔: " + fileName + " 類型無法識別.");
                                typeRecognition = false;
                                throw error;
                            };
                        });
                    };
                };
            });
        } else {
            console.log("文檔: " + absolute_path + " 類型無法識別.");
            if (callback) { callback(error, null); };
        };
    });
};
module.exports.deleteDir = deleteDir; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義返回調用時函數的名字;
const where = () => {
    let reg = /\s+at\s(\s+)\s\(/g;
    let str = new Error().stack.toString();
    let res = reg.exec(str) && reg.exec(str);
    return res && res[1];
};
module.exports.where = where; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義封裝一個函數，使用正則函數的方法檢查字符串中的字符類型，用於檢驗用戶輸入參數的合規性;
function CheckString(letters, fork) {
    let Require;
    switch (fork) {
        case 'arabic_numerals':
            Require = /^[0-9]+$/; //檢查是否全部由阿拉伯數字[0-9]構成的字符串;
            return Require.test(letters);
            break; // break用於終止後面的條件選擇語句執行;
        case 'non_negative_integer':
            Require = /^\\d+$/; //非負整數(正整數 + 0);
            return Require.test(letters);
            break;
        case 'positive_integer':
            Require = /^[0-9]*[1-9][0-9]*$/; //正整數;
            return Require.test(letters);
            break;
        case 'non_positive_integer':
            Require = /^((-\\d+)|(0+))$/; //非正整數(負整數 + 0);
            return Require.test(letters);
            break;
        case 'negative_integer':
            Require = /^-[0-9]*[1-9][0-9]*$/; //負整數;
            return Require.test(letters);
            break;
        case 'integer':
            Require = /^-?\\d+$/; //整數;
            return Require.test(letters);
            break;
        case 'non_negative_float':
            Require = '^\\d+('; //非負浮點數(正浮點數 + 0);
            return Require.test(letters);
            break;
        case 'positive_float':
            Require = /^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$/; //正浮點數;
            return Require.test(letters);
            break;
        case 'non_positive_float':
            Require = '^((-\\d+('; //非正浮點數(負浮點數 + 0);
            return Require.test(letters);
            break;
        case 'negative_float':
            Require = /^(-(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //負浮點數;
            return Require.test(letters);
            break;
        case 'float':
            Require = '^(-?\\d+)('; //浮點數;
            return Require.test(letters);
            break;
        default:
        // 執行與所有 case 不同時執行的代碼;
    };
};
module.exports.CheckString = CheckString; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// // 控制臺傳參檢查埠號（port）是否已經被占用，控制臺傳參，其中「port」為需要檢測的端口號，運行方式示例：node PortIsOccupied 80;
// if (typeof (process.argv[2]) === 'undefined') {
//     console.log('端口參數未輸入，請正確輸入待測試端口號.');
// } else if (!CheckString(process.argv[2], 'arabic_numerals') || Number(process.argv[2]) >= 65535 || Number(process.argv[2]) <= 0) {
//     console.log(`端口參數「${process.argv[2]}」類型輸入錯誤，請正確輸入「1 ~ 65535」的數字端口進行測試.`);
// } else {
//     let port = Number(parseInt(process.argv[2]));
//     //console.log(port);
//     const Server = net.createServer().listen(port);
//     function PortIsOccupied(port) {
//         Server.on('listening', function () {
//             Server.close(); // 關閉服務;
//             console.log(`端口「${port}」可以使用.`);
//         });
//         Server.on('error', function (error) {
//             if (error.code === 'EADDRINUSE') {
//                 // 端口已被占用
//                 console.log(`端口「${port}」已經被占用，請更換端口重試.`);
//             } else {
//                 console.log(JSON.stringify(error));
//             };
//         });
//     };

//     // 執行
//     PortIsOccupied(port);
// };








// // child_Process;
// // 這裏是需要向Python服務器發送的參數數據JSON對象，注意不能有空格因爲控制臺shell語句使用空格區分參數，如果需要帶空格的參數，可以先使用其它符號分隔連接傳入參數，等參數傳入之後然後再將分隔符替換為空格，不要傳遞使用漢字等非ACSII碼字符;
// // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // console.log(now_date);
// let argument = "How_are_you_!";
// console.log("Client say: " + argument.replace(new RegExp("_", "g"), " "));
// // let post_Data_JSON = {
// //     "Client_say": "How_are_you_!",
// //     "time": "2021-1-17-1-55-2-75" // time = new Date().toLocaleString('chinese', { hour12: false });
// // };
// let post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + now_date + '\\"}'; // change the javascriptobject to jsonstring;
// // let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;
// // let arg1 = 'hello';
// // let arg2 = 'world.';
// // let post_Data_String = qs.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;

// let to_executable = 'C:\\Python\\python39\\python.exe';
// let to_script = 'C:\\Users\\china\\Documents\\Node.js\\Python4Node.py';
// let shell_run_to_executable = to_executable.concat(" ", to_script, " ", post_Data_String);
// // 同步運行;
// let result = require('child_process').execSync(shell_run_to_executable, { stdio: [0, 1, 2] });
// // console.log(typeof(result));
// let response_JSON = null;
// // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
// if (isStringJSON(result)) {
//     response_JSON = JSON.parse(result);
// } else {
//     response_JSON = {
//         "Server_say": result
//     };
// };
// console.log("Server say: " + response_JSON["Server_say"]);
// // 異步運行;
// // child_process.exec(shell_run_to_executable, function (error, stdout, stderr) {
// //     if (error) {
// //         console.log(`EXEC Error: ${error}`);
// //         // return;
// //     };

// //     if (stderr) {
// //         console.error(`stderr: ${stderr}`);
// //     };

// //     // console.log("stdout:");
// //     // console.log(typeof (stdout));
// //     // console.log(stdout);
// //     // console.log(JSON.parse(stdout));

// //     let response_JSON = null;
// //     if (stdout) {
// //         // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
// //         if (isStringJSON(stdout)) {
// //             response_JSON = JSON.parse(stdout);
// //         } else {
// //             response_JSON = {
// //                 "Python_say": stdout
// //             };
// //         };
// //         console.log("Python say: " + response_JSON["Python_say"]);
// //     };

// // });
// // // child_process.exec("CHCP") === "Active code page: 65001" || exec("CHCP") === "活动代码页: 936"
// // // child_process.exec('CHCP 65001' + ' ' + '&&' + ' ' + 'python' + ' ' + filename + ' ' + post_Data_String, function (error, stdout, stderr) {
// // //     if (error) {
// // //         console.log(`EXEC Error: ${error}`);
// // //         // return;
// // //     };

// // //     if (stderr) {
// // //         console.error(`stderr: ${stderr}`);
// // //     };

// // //     // console.log("stdout:");
// // //     // console.log(typeof (stdout));
// // //     // console.log(stdout);
// // //     // console.log(JSON.parse(stdout));

// // //     let response_JSON = null;
// // //     if (stdout) {
// // //         // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
// // //         if (isStringJSON(stdout)) {
// // //             response_JSON = JSON.parse(stdout);
// // //         } else {
// // //             response_JSON = {
// // //                 "Python_say": stdout
// // //             };
// // //         };
// // //         console.log("Python say: " + response_JSON["Python_say"]);
// // //     };
// // // });

// // // process.exit(0); // 停止運行，退出 Node.js 解釋器;











// // 示例函數，處理從硬盤文檔讀取到的JSON對象數據，然後返回處理之後的結果JSON對象;
// function do_data(data_Str) {

//     let response_data_String = "";
//     let require_data_JSON = {};
//     // 使用自定義函數isStringJSON(data_Str)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
//     if (isStringJSON(data_Str)) {
//         require_data_JSON = JSON.parse(data_Str);  // 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
//         // str = JSON.stringify(jsonObj);
//         // Obj = JSON.parse(jsonStr);
//     } else {
//         require_data_JSON = {
//             "Client_say": data_Str,
//         };
//     };

//     // console.log(require_data_JSON);
//     // console.log(typeof(require_data_JSON));
//     // console.log(typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length));

//     let Client_say = "";
//     // 使用函數 (typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length)) 判斷傳入的參數 require_data_JSON 是否為 JSON 格式對象;
//     if (typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length)) {
//         // 使用 JSON.hasOwnProperty("key") 判断某个"key"是否在JSON中;
//         if (require_data_JSON.hasOwnProperty("Client_say")) {
//             Client_say = require_data_JSON["Client_say"];
//         } else {
//             Client_say = "";
//             // console.log('客戶端發送的請求 JSON 對象中無法找到目標鍵(key)信息 ["Client_say"].');
//             // console.log(require_data_JSON);
//         };
//     } else {
//         Client_say = require_data_JSON;
//         // isStringJSON(request_data_JSON);
//         // text = JSON.stringify(JsonObject); sonObject = JSON.parse(String);
//     };

//     let Server_say = Client_say;  // "require no problem.";
//     // if (Client_say === "How are you" || Client_say === "How are you." || Client_say === "How are you!" || Client_say === "How are you !") {
//     //     Server_say = "Fine, thank you, and you ?";
//     // } else {
//     //     Server_say = "我現在只會説：「 Fine, thank you, and you ? 」，您就不能按規矩說一個：「 How are you ! 」";
//     // };

//     // let now_date = new Date().toLocaleString('chinese', { hour12: false });
//     let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
//     // console.log(now_date);
//     let response_data_JSON = {
//         "Server_say": Server_say,
//         "time": String(now_date)
//     };
//     response_data_String = JSON.stringify(response_data_JSON);
//     // isStringJSON(request_data_JSON);
//     // text = JSON.stringify(JsonObject); sonObject = JSON.parse(String);

//     return response_data_String;
// };


// let is_monitor = true;  // Boolean;
// // let is_Monitor_Concurrent = "";  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
// let monitor_dir = String(require('path').join(String(__dirname), "Intermediary"));  // path.normalize(p)。path.join([path1][, path2][, ...])，path.resolve('main.js') 用於輸入傳值的媒介目錄 "../temp/";
// let monitor_file = String(require('path').join(String(monitor_dir), "intermediary_write_C.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_C.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
// let do_Function = function (argument) { return argument; };  // 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
// let output_dir = String(require('path').join(String(__dirname), "Intermediary"));  // path.normalize(p)。path.join([path1][, path2][, ...])，path.resolve('main.js') 用於輸出傳值的媒介目錄 "../temp/";
// let output_file = String(require('path').join(String(output_dir), "intermediary_write_Nodejs.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_Nodejs.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
// let to_executable = "";  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\Python\\Python39\\python.exe";
// let to_script = "";  // 用於對返回數據執行功能的被調用的脚本文檔 "../py/test.py";
// let delay = parseInt(100)  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay)，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
// let number_Worker_threads = parseInt(0);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
// let Worker_threads_Script_path = "";  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let Worker_threads_eval_value = null;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let temp_NodeJS_cache_IO_data_dir = "";  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     try {
//                         // CheckString(delay, 'positive_integer');  // 自定義函數檢查輸入合規性;
//                         // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                         if (process.argv[i].split("=")[0] !== "do_Function") {
//                             eval(process.argv[i] + ";");
//                         };
//                         if (process.argv[i].split("=")[0] === "do_Function" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                             eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                         } else {
//                             do_Function = null;
//                         };
//                         console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     } catch (error) {
//                         console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                         console.log(error);
//                     };
//                     // switch (process.argv[i].split("=")[0]) {
//                     //     case "monitor_file": {
//                     //         monitor_file = String(process.argv[i].split("=")[1]);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                     //         // console.log("monitor file: " + monitor_file);
//                     //         break;
//                     //     }
//                     //     case "monitor_dir": {
//                     //         monitor_dir = String(process.argv[i].split("=")[1]);  // 用於輸入傳值的媒介目錄 "../temp/";
//                     //         // console.log("monitor dir: " + monitor_dir);
//                     //         break;
//                     //     }
//                     //     case "do_Function": {
//                     //         // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
//                     //         if (Object.prototype.toString.call(do_Function = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //             do_Function = eval(process.argv[i].split('=')[1]);
//                     //         } else {
//                     //             do_Function = null;
//                     //         };
//                     //         // console.log("do Function: " + do_Function);
//                     //         break;
//                     //     }
//                     //     case "output_dir": {
//                     //         output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
//                     //         // console.log("output dir: " + output_dir);
//                     //         break;
//                     //     }
//                     //     case "output_file": {
//                     //         output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                     //         // console.log("output file: " + output_file);
//                     //         break;
//                     //     }
//                     //     case "to_executable": {
//                     //         to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                     //         // console.log("to executable: " + to_executable);
//                     //         break;
//                     //     }
//                     //     case "to_script": {
//                     //         to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                     //         // console.log("to script: " + to_script);
//                     //         break;
//                     //     }
//                     //     case "temp_NodeJS_cache_IO_data_dir": {
//                     //         temp_NodeJS_cache_IO_data_dir = String(process.argv[i].split("=")[1]);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
//                     //         // console.log("temp NodeJS cache Input/Output data dir: " + temp_NodeJS_cache_IO_data_dir);
//                     //         break;
//                     //     }
//                     //     case "delay": {
//                     //         delay = parseInt(process.argv[i].split("=")[1]);  // delay = 500;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//                     //         // console.log("delay: " + delay);
//                     //         break;
//                     //     }
//                     //     // case "is_Monitor_Concurrent": {
//                     //     //     is_Monitor_Concurrent = String(process.argv[i].split("=")[1]);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
//                     //     //     // console.log("is_Monitor_Concurrent: " + number_Worker_threads);
//                     //     //     break;
//                     //     // }
//                     //     case "number_Worker_threads": {
//                     //         CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                     //         number_Worker_threads = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//                     //         // console.log("number_Worker_threads: " + number_Worker_threads);
//                     //         break;
//                     //     }
//                     //     case "Worker_threads_Script_path": {
//                     //         Worker_threads_Script_path = process.argv[i].split("=")[1];  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                     //         // console.log("Worker threads Script path: " + Worker_threads_Script_path);
//                     //         break;
//                     //     }
//                     //     case "Worker_threads_eval_value": {
//                     //         Worker_threads_eval_value = Boolean(process.argv[i].split("=")[1]);  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                     //         // console.log("Worker threads eval value: " + Worker_threads_eval_value);
//                     //         break;
//                     //     }
//                     //     default: {
//                     //         console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     }
//                     // };
//                 };
//             };
//         };
//     };
// };


// class WorkerPoolTaskInfo extends AsyncResource {
//     constructor(callback) {
//         super('WorkerPoolTaskInfo');
//         this.callback = callback;
//     };

//     done(err, result) {
//         this.runInAsyncScope(this.callback, null, err, result);
//         this.emitDestroy();  // `TaskInfo`s are used only once.
//     };
// };

// class file_Monitor extends EventEmitter {
//     constructor(is_monitor, monitor_file, monitor_dir, do_Function_obj, return_obj, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir) {
//         super();
//         if (monitor_dir !== null && monitor_dir !== "") {
//             this.monitor_dir = monitor_dir;
//         } else {
//             this.monitor_dir = "D:\\temp\\";
//         };
//         this.workers = [];

//         this.help = `
//             // 使用示例 This pool could be used as follows;
//             // http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource            
//         `;
//     };

//     file_Monitor() {};

//     close() {
//         for (const worker of this.workers) { worker.terminate(); };
//     };
// };


function file_Monitor() {

    // 可變參數傳值;
    // for (let i = 0; i < arguments.length; i++) {
    //     console.log(arguments[i]);
    // };
    let argument_1 = arguments[0];

    // 配置預設值;
    let is_monitor = false;
    // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
    // let is_Monitor_Concurrent = 0;  // "Multi-Threading"; # "Multi-Processes";
    // // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
    let delay = parseInt(50);  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
    // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
    let number_Worker_threads = parseInt(0);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
    // 配置子綫程運行時脚本參數 Worker_threads_Script_path 的預設值 new Worker(Worker_threads_Script_path, { eval: true });
    let Worker_threads_Script_path = "";  // process.argv[1] new Worker(Worker_threads_Script_path, { eval: true });
    // 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的預設值 // new Worker(Worker_threads_Script_path, { eval: true });
    let Worker_threads_eval_value = true;  // new Worker(Worker_threads_Script_path, { eval: true });
    // 使用Node.js原生模組fs判斷指定的用於暫存傳入傳出數據的臨時媒介文件夾;
    // temp_NodeJS_cache_IO_data_dir = "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);
    let temp_NodeJS_cache_IO_data_dir = require('path').join(require('path').resolve(".."), "temp");  // require('path').resolve("..").toString().concat("/temp/")，require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾;
    // console.log(temp_NodeJS_cache_IO_data_dir);
    // temp_NodeJS_cache_IO_data_dir = fs.mkdtempSync(require('os').tmpdir().concat(require('path').sep), { encoding: 'utf8' });  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
    // fs.rmdirSync(temp_NodeJS_cache_IO_data_dir, { maxRetries: 0, recursive: false, retryDelay: 100 });  // 同步刪除目錄 fs.rmdirSync(path[, options]) 返回值 undefined;
    // 用於輸入傳值的媒介目錄;
    // monitor_dir = "../temp/";  // 用於輸入傳值的媒介目錄，process.cwd() 當前工作目錄;
    let monitor_dir = require('path').join(require('path').resolve(".."), "temp");  // require('path').resolve("..").toString().concat("/temp/")，"../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
    // 用於接收傳值的媒介文檔;
    let monitor_file = "";  // require('path').join(monitor_dir, "intermediary_write_Python.txt");  // "../temp/intermediary_write_Python.txt" 用於接收傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
    // 用於接收執行功能的函數;
    let do_Function = function (argument) { return argument; };  // 用於接收執行功能的函數;
    // 用於輸出傳值的媒介目錄;
    // output_dir = "../temp/";  // 用於輸出傳值的媒介目錄，process.cwd() 當前工作目錄;
    let output_dir = require('path').join(require('path').resolve(".."), "temp");  // require('path').resolve("..").toString().concat("/temp/")，"../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
    // 用於輸出傳值的媒介文檔;
    let output_file = require('path').join(output_dir, "intermediary_write_Node.txt");  // "../temp/intermediary_write_Node.txt" 用於輸出傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
    // 用於對返回數據執行功能的解釋器可執行文件;
    // to_executable = "../Python/python39/python.exe";  // "C:\\Python\\python39\\python.exe" 用於對返回數據執行功能的解釋器可執行文件，process.cwd() 當前工作目錄;
    let to_executable = "";  // require('path').join(require('path').resolve(".."), "Python", "python39/python.exe");  // require('path').resolve("..").toString().concat("/Python/", "python39/python.exe")，"../Python/python39/python.exe"，path.resolve("../Python/python39/python.exe") 轉換爲絕對路徑;
    // 用於對返回數據執行功能的被調用的脚本文檔;
    // to_script = "../js/test.js";  // "../js/test.js" 用於對返回數據執行功能的被調用的脚本文檔，process.cwd() 當前工作目錄;
    let to_script = "";  // require('path').join(require('path').resolve(".."), "js", "test.js");  // require('path').resolve("..").toString().concat("/js/", "test.js")，"../js/test.js"，path.resolve("../js/test.js") 轉換爲絕對路徑;

    // 讀取傳入函數的可變參數值;
    if (typeof (argument_1) !== undefined && argument_1 !== undefined) {
        if (typeof (argument_1) === 'object' && Object.prototype.toString.call(argument_1).toLowerCase() === '[object object]' && !(argument_1.length)) {
            // 配置用於判斷是保持監聽看守進程，還是只執行一次即退出的參數值;
            if (typeof (argument_1["is_monitor"]) !== undefined && argument_1["is_monitor"] !== undefined && argument_1["is_monitor"] !== null && argument_1["is_monitor"] !== NaN && argument_1["is_monitor"] !== "") {
                is_monitor = Boolean(argument_1["is_monitor"]);  // typeof (is_monitor) === "boolean";
            };
            // // 配置用於選擇監聽看守進程函數是否並發（多協程、多綫程、多進程），可以取值："Multi-Threading"、"Multi-Processes";
            // if (typeof (argument_1["is_Monitor_Concurrent"]) !== undefined && argument_1["is_Monitor_Concurrent"] !== undefined && argument_1["is_Monitor_Concurrent"] !== null && argument_1["is_Monitor_Concurrent"] !== NaN && argument_1["is_Monitor_Concurrent"] !== "") {
            //     is_Monitor_Concurrent = String(argument_1["is_Monitor_Concurrent"]);  // typeof (is_monitor) === "string"，"Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
            // };
            // 配置使用Node.js原生模組fs判斷指定的用於暫存傳入傳出數據的臨時媒介文件夾;
            if (typeof (argument_1["temp_NodeJS_cache_IO_data_dir"]) !== undefined && argument_1["temp_NodeJS_cache_IO_data_dir"] !== undefined && argument_1["temp_NodeJS_cache_IO_data_dir"] !== null && argument_1["temp_NodeJS_cache_IO_data_dir"] !== NaN) {
                temp_NodeJS_cache_IO_data_dir = String(argument_1["temp_NodeJS_cache_IO_data_dir"]);  // typeof (temp_NodeJS_cache_IO_data_dir) === "String";
            };
            // 配置用於輸入傳值的媒介目錄，process.cwd() 當前工作目錄;
            if (typeof (argument_1["monitor_dir"]) !== undefined && argument_1["monitor_dir"] !== undefined && argument_1["monitor_dir"] !== null && argument_1["monitor_dir"] !== NaN) {
                monitor_dir = String(argument_1["monitor_dir"]);  // typeof (monitor_dir) === "String";
            };
            // 配置用於接收傳值的媒介文檔;
            if (typeof (argument_1["monitor_file"]) !== undefined && argument_1["monitor_file"] !== undefined && argument_1["monitor_file"] !== null && argument_1["monitor_file"] !== NaN) {
                monitor_file = String(argument_1["monitor_file"]);  // typeof (monitor_file) === "String";
            };
            // 配置用於輸出傳值的媒介目錄，process.cwd() 當前工作目錄;
            if (typeof (argument_1["output_dir"]) !== undefined && argument_1["output_dir"] !== undefined && argument_1["output_dir"] !== null && argument_1["output_dir"] !== NaN) {
                output_dir = String(argument_1["output_dir"]);  // typeof (output_dir) === "String";
            };
            // 配置用於輸出傳值的媒介文檔;
            if (typeof (argument_1["output_file"]) !== undefined && argument_1["output_file"] !== undefined && argument_1["output_file"] !== null && argument_1["output_file"] !== NaN) {
                output_file = String(argument_1["output_file"]);  // typeof (output_file) === "String";
            };
            // 配置用於對返回數據執行功能的解釋器可執行文件;
            if (typeof (argument_1["to_executable"]) !== undefined && argument_1["to_executable"] !== undefined && argument_1["to_executable"] !== null && argument_1["to_executable"] !== NaN) {
                to_executable = String(argument_1["to_executable"]);  // typeof (to_executable) === "String";
            };
            // 配置用於對返回數據執行功能的被調用的脚本文檔;
            if (typeof (argument_1["to_script"]) !== undefined && argument_1["to_script"] !== undefined && argument_1["to_script"] !== null && argument_1["to_script"] !== NaN) {
                to_script = String(argument_1["to_script"]);  // typeof (to_script) === "String";
            };
            // 配置創建子綫程數目參數值;
            // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
            // if (typeof (number_Worker_threads) === undefined || number_Worker_threads === undefined || number_Worker_threads === null || number_Worker_threads === "") {
            //     number_Worker_threads = parseInt(1);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
            // };
            if (typeof (argument_1["number_Worker_threads"]) !== undefined && argument_1["number_Worker_threads"] !== undefined && argument_1["number_Worker_threads"] !== null && argument_1["number_Worker_threads"] !== NaN && argument_1["number_Worker_threads"] !== "") {
                number_Worker_threads = parseInt(argument_1["number_Worker_threads"]);  // typeof (number_Worker_threads) === "number"，parseInt(1)，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
            };
            // 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 // new Worker(Worker_threads_Script_path, { eval: true });
            // if (typeof (Worker_threads_eval_value) === undefined || Worker_threads_eval_value === undefined || Worker_threads_eval_value === null || Worker_threads_eval_value === "") {
            //     Worker_threads_eval_value = true;  // new Worker(Worker_threads_Script_path, { eval: true });
            // };
            if (typeof (argument_1["Worker_threads_eval_value"]) !== undefined && argument_1["Worker_threads_eval_value"] !== undefined && argument_1["Worker_threads_eval_value"] !== null && argument_1["Worker_threads_eval_value"] !== NaN) {
                Worker_threads_eval_value = Boolean(argument_1["Worker_threads_eval_value"]);  // typeof (Worker_threads_eval_value) === "boolean"，new Worker(Worker_threads_Script_path, { eval: true });
            };
            // 配置子綫程運行時脚本參數;
            if (typeof (argument_1["Worker_threads_Script_path"]) !== undefined && argument_1["Worker_threads_Script_path"] !== undefined && argument_1["Worker_threads_Script_path"] !== null && argument_1["Worker_threads_Script_path"] !== NaN) {
                Worker_threads_Script_path = String(argument_1["Worker_threads_Script_path"]);  // typeof (Worker_threads_Script_path) === "String";
            };
            // CheckString(delay, 'positive_integer');  // 自定義函數檢查輸入合規性;
            if (typeof (argument_1["delay"]) !== undefined && argument_1["delay"] !== undefined && argument_1["delay"] !== null && argument_1["delay"] !== NaN && argument_1["delay"] !== "") {
                delay = parseInt(argument_1["delay"]);  // typeof (delay) === "number"，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
            };
            // 直接傳入函數或函數字符串，具體處理數據的函數 do_Function;
            if (typeof (argument_1["do_Function"]) !== undefined && argument_1["do_Function"] !== undefined && argument_1["do_Function"] !== null && argument_1["do_Function"] !== NaN && argument_1["do_Function"] !== "") {
                // 使用 Object.prototype.toString.call(argument_1["do_Function"]).toLowerCase() === '[object function]' 方法判斷對象是否是一個函數 typeof(fn)==='function';
                if (Object.prototype.toString.call(argument_1["do_Function"]).toLowerCase() === '[object function]' || (Object.prototype.toString.call(argument_1["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(argument_1["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + argument_1["do_Function"] + ';')).toLowerCase() === '[object function]'))) {
                    // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                    eval("do_Function = " + argument_1["do_Function"] + ";");
                } else if (Object.prototype.toString.call(argument_1["do_Function"]).toLowerCase() === '[object string]') {
                    // 以 function mytFunc(argument) {} 形式的函數傳值;
                    eval(argument_1["do_Function"]);
                    // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                    // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                    eval("do_Function = " + argument_1["do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                } else {
                    console.log("傳入的用於處理數據的函數參數 do_Function: " + argument_1["do_Function"] + " 無法識別");
                    eval("do_Function = function (argument) { return argument; };");
                };
            };
            // 以 JSON 對象形式傳入函數或函數字符串，具體處理數據的函數 do_Function_obj;
            // let do_Function = null;
            if ((typeof (argument_1["do_Function_obj"]) === 'object' && Object.prototype.toString.call(argument_1["do_Function_obj"]).toLowerCase() === '[object object]' && !(argument_1["do_Function_obj"].length)) && Object.keys(argument_1["do_Function_obj"]).length > 0) {
                for (let key in argument_1["do_Function_obj"]) {
                    if (eval('typeof (' + key + ')' + ' === undefined && ' + key + ' === undefined')) {
                        // eval('var ' + key + ' = null;');
                    } else {
                        // 使用 Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object function]' 方法判斷對象是否是一個函數 typeof(fn)==='function';
                        if (Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object function]' || (typeof (argument_1["do_Function_obj"][key]) !== undefined && argument_1["do_Function_obj"][key] !== undefined && argument_1["do_Function_obj"][key] !== null && argument_1["do_Function_obj"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(argument_1["do_Function_obj"][key])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval(key + " = " + argument_1["do_Function_obj"][key] + ';')).toLowerCase() === '[object function]'))) {
                            // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                            eval(key + " = " + argument_1["do_Function_obj"][key] + ";");
                        } else if (typeof (argument_1["do_Function_obj"][key]) !== undefined && argument_1["do_Function_obj"][key] !== undefined && argument_1["do_Function_obj"][key] !== null && argument_1["do_Function_obj"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object string]') {
                            // 以 function mytFunc(argument) {} 形式的函數傳值;
                            eval(argument_1["do_Function_obj"][key]);
                            // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                            // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                            eval(key + " = " + argument_1["do_Function_obj"][key].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                        } else {
                            console.log("傳入的用於處理數據的函數參數 do_Function_obj, key: " + key + " , value: " + argument_1["do_Function_obj"][key] + " 無法識別");
                            eval(key + " = function (argument) { return argument; };");
                        };
                        // switch (key) {
                        //     case "do_Function": {
                        //         // 判斷傳入的參數 argument_1["do_Function_obj"][key]，是直接傳入的函數對象，還是傳入的函數名字字符串;
                        //         if (Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object function]') {
                        //             do_Function = argument_1["do_Function_obj"][key];
                        //         } else if (typeof (argument_1["do_Function_obj"][key]) !== undefined && argument_1["do_Function_obj"][key] !== undefined && argument_1["do_Function_obj"][key] !== null && argument_1["do_Function_obj"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(argument_1["do_Function_obj"][key])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + argument_1["do_Function_obj"][key] + ';')).toLowerCase() === '[object function]')) {
                        //             // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                        //             eval("do_Function = " + argument_1["do_Function_obj"][key] + ";");
                        //         } else if (typeof (argument_1["do_Function_obj"][key]) !== undefined && argument_1["do_Function_obj"][key] !== undefined && argument_1["do_Function_obj"][key] !== null && argument_1["do_Function_obj"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_obj"][key]).toLowerCase() === '[object string]') {
                        //             // 以 function mytFunc(argument) {} 形式的函數傳值;
                        //             eval(argument_1["do_Function_obj"][key]);
                        //             // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                        //             // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                        //             eval("do_Function = " + argument_1["do_Function_obj"][key].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                        //         } else {
                        //             console.log("傳入的用於處理數據的函數參數 do_Function_obj, key: " + key + " , value: " + argument_1["do_Function_obj"][key] + " 無法識別");
                        //             eval(key + " = function (argument) { return argument; };");
                        //         };
                        //         break;
                        //     }
                        //     default: {
                        //         console.log("Unrecognize JSON key: [" + key + "].");
                        //         console.log("傳入的用於處理數據的函數參數 do_Function_obj, key: " + key + " , value: " + argument_1["do_Function_obj"][key] + " 無法識別");
                        //     }
                        // };
                    };
                };
            };
            // 以 JSON 對象傳入處理完數據後的，輸出參數 return_obj;
            // let output_dir = "";
            // let output_file = "";
            // let to_executable = "";
            // let to_script = "";
            if ((typeof (argument_1["return_obj"]) === 'object' && Object.prototype.toString.call(argument_1["return_obj"]).toLowerCase() === '[object object]' && !(argument_1["return_obj"].length)) && Object.keys(argument_1["return_obj"]).length > 0) {
                for (let key in argument_1["return_obj"]) {
                    if (eval('typeof (' + key + ')' + ' === undefined && ' + key + ' === undefined')) {
                        // eval('var ' + key + ' = "";');
                    } else {
                        // // 使用 Object.prototype.toString.call(argument_1["return_obj"][key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
                        // if (Object.prototype.toString.call(argument_1["return_obj"][key]).toLowerCase() === '[object string]') {
                        //     eval(key.concat(' = "', argument_1["return_obj"][key], '";'));
                        //     // eval(key.concat(' = path.format(path.parse("', argument_1["return_obj"][key], '"));'));
                        //     // console.log(eval(key));
                        // } else {
                        //     eval(key.concat(' = "";'));
                        //     console.log("Unrecognize JSON key: [" + key + "].");
                        // };
                        switch (key) {
                            case "output_dir": {
                                output_dir = argument_1["return_obj"][key];
                                break;
                            }
                            case "output_file": {
                                output_file = argument_1["return_obj"][key];
                                break;
                            }
                            case "to_executable": {
                                to_executable = argument_1["return_obj"][key];
                                break;
                            }
                            case "to_script": {
                                to_script = argument_1["return_obj"][key];
                                break;
                            }
                            default: {
                                console.log("Unrecognize JSON key: [" + key + "].");
                            }
                        };
                    };
                };
            };
        };
    };

    // 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
    function read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script) {
        // console.log("當前進程編號: " + process.pid);
        // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
        // console.log("當前進程使用的内存: " + process.memoryUsage());
        // console.log("運行當前進程的操作系統平臺: " + process.platform);
        // console.log("運行當前進程的操作系統架構: " + process.arch);
        // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
        // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
        // console.log("當前進程的用戶環境: " + process.env);
        // console.log("當前進程的工作目錄: " + process.cwd());
        // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
        // console.log("運行當前進程的運行時間: " + process.uptime());
        // console.log("當前執行緒ID: thread-" + require('worker_threads').threadId);

        // 判斷傳入的參數 do_Function，是直接傳入的函數對象，還是傳入的函數名字字符串;
        if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]'){
            if (typeof (do_Function) !== undefined && do_Function !== undefined && do_Function !== null && do_Function !== "" && Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(do_Function)).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + do_Function + ';')).toLowerCase() === '[object function]')) {
                // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                eval("do_Function = " + do_Function + ';');
            } else if (typeof (do_Function) !== undefined && do_Function !== undefined && do_Function !== null && do_Function !== "" && Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]') {
                // 以 function mytFunc(argument) {} 形式的函數傳值;
                eval(do_Function);
                // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                do_Function = eval(do_Function.match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
            } else {
                console.log("傳入的參數 do_Function 用於處理數據的函數無法識別: " + do_Function);
                do_Function = function (argument) { return argument; };
            };
            // console.log(do_Function);
            // console.log(typeof (do_Function));
        } else if (Object.prototype.toString.call(do_Function).toLowerCase() !== '[object function]') {
            console.log("傳入的參數 do_Function 用於處理數據的函數無法識別: " + do_Function);
            do_Function = function (argument) { return argument; };
        };
        // if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object function]') {
        //     do_Function = do_Function;
        // } else {
        //     console.log("傳入的參數 do_Function 用於處理數據的函數無法識別: " + do_Function);
        //     do_Function = function (argument) { return argument; };
        // };

        // if (monitor_file === "") {
        //     console.log("傳入的用於傳入數據的媒介文檔參數不合法，為空字符串，只接受輸入文檔路徑全名.");
        //     // console.log(monitor_file);
        //     return monitor_file;
        // };

        // if (output_file === "") {
        //     console.log("用於傳出數據的媒介文檔參數為空字符串不合法，只接受輸入文檔路徑全名.");
        //     // console.log(output_file);
        //     return output_file;
        // };

        // if (monitor_dir === "" || monitor_file === "" || monitor_file.indexOf(monitor_dir, 0) === -1 || output_dir === "" || output_file === "" || output_file.indexOf(output_dir, 0) === -1) {
        //     // path.format(path.parse(output_file))
        //     // (monitor_dir === "" || monitor_file === "" || path.parse(monitor_file)["dir"] !== monitor_dir || output_dir === "" || output_file === "" || path.parse(output_file)["dir"] !== output_dir)
        //     console.log("用於傳入和傳出數據的媒介文檔或媒介路徑，檢測錯誤，無法識別.");
        //     console.log([monitor_dir, monitor_file, output_dir, output_file]);
        //     return [monitor_dir, monitor_file, output_dir, output_file];
        // };

        // 使用Node.js原生模組fs判斷指定的用於傳入數據的媒介目錄是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        let file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(monitor_dir) && fs.statSync(monitor_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + monitor_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸入的媒介文件夾: " + monitor_dir + " 是否存在.");
            console.error(error);
            return monitor_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            // 同步創建，創建用於傳入數據的監聽媒介文件夾;
            try {
                // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                fs.mkdirSync(monitor_dir, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                // console.log("目錄: " + monitor_dir + " 創建成功.");
            } catch (error) {
                console.error("用於輸入數據的媒介文件夾: " + monitor_dir + " 無法創建.");
                console.error(error);
                return monitor_dir;
            };
        };

        // 判斷媒介文件夾是否創建成功;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(monitor_dir) && fs.statSync(monitor_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + monitor_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸入的媒介文件夾: " + monitor_dir + " 是否存在.");
            console.error(error);
            return monitor_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            console.log("用於傳值的媒介文件夾 [ " + monitor_dir + " ] 無法被創建.");
            return monitor_dir;
        };

        // // 同步判斷文件夾權限，使用Node.js原生模組fs的fs.accessSync(monitor_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        // try {
        //     // 同步判斷判斷文件夾權限，使用Node.js原生模組fs的fs.accessSync(monitor_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     fs.accessSync(monitor_dir, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("目錄: " + monitor_dir + " 可以讀寫.");
        // } catch (error) {
        //     // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
        //     try {
        //         // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(monitor_dir, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("目錄: " + monitor_dir + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
        //     } catch (error) {
        //         console.error("用於接收傳值的媒介文件夾 [ " + monitor_dir + " ] 無法修改為可讀可寫權限.");
        //         console.error(error);
        //         return monitor_dir;
        //     };
        // };

        // // 可以先改變工作目錄到 static 路徑;
        // console.log('Starting directory: ' + process.cwd());
        // try {
        //     process.chdir('D:\\tmp\\');
        //     console.log('New directory: ' + process.cwd());
        // } catch (error) {
        //     console.log('chdir: ' + error);
        //     console.error(error);
        // };

        // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
        // try {
        //     console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
        // } catch (error) {
        //     console.log(error);
        //     console.error(error);
        // };

        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
            // console.log("文檔: " + monitor_file + " 存在.");
        } catch (error) {
            console.error("無法確定用於傳入數據的媒介文檔: " + monitor_file + " 是否存在.");
            console.error(error);
            return monitor_file;
        };
        // 同步判斷，當用於傳入數據的媒介文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            // console.log("用於傳入數據的媒介文檔 " + monitor_file + " 不存在.");
            return monitor_file;
        };

        // 同步判斷文檔權限，後面所有代碼都是，當用於傳入數據的媒介文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        try {
            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
            fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
            // console.log("文檔: " + monitor_file + " 可以讀寫.");
        } catch (error) {
            // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
            try {
                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                fs.fchmodSync(monitor_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                // console.log("文檔: " + monitor_file + " 操作權限修改為可以讀寫.");
                // 常量                    八進制值    說明
                // fs.constants.S_IRUSR    0o400      所有者可讀
                // fs.constants.S_IWUSR    0o200      所有者可寫
                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                // fs.constants.S_IRGRP    0o40       群組可讀
                // fs.constants.S_IWGRP    0o20       群組可寫
                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                // fs.constants.S_IROTH    0o4        其他人可讀
                // fs.constants.S_IWOTH    0o2        其他人可寫
                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                // 數字	說明
                // 7	可讀、可寫、可執行
                // 6	可讀、可寫
                // 5	可讀、可執行
                // 4	唯讀
                // 3	可寫、可執行
                // 2	只寫
                // 1	只可執行
                // 0	沒有許可權
                // 例如，八進制值 0o765 表示：
                // 1) 、所有者可以讀取、寫入和執行該文檔；
                // 2) 、群組可以讀和寫入該文檔；
                // 3) 、其他人可以讀取和執行該文檔；
                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
            } catch (error) {
                console.error("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.");
                console.error(error);
                return monitor_file;
            };
        };

        let data_Str = "";  // 從傳入的媒介文檔中讀取到的數據字符串;

        // 同步讀取，用於傳入數據的媒介文檔中的數據;
        try {
            data_Str = fs.readFileSync(monitor_file, { encoding: "utf8", flag: "r+" });
            // // let buffer = new Buffer(8);
            // let buffer_data = fs.readFileSync(monitor_file, { encoding: null, flag: "r+" });
            // data_Str = buffer_data.toString("utf-8");  // 將Buffer轉換爲String;
            // // buffer_data = Buffer.from(data_Str, "utf-8");  // 將String轉換爲Buffer;
            // console.log(data_Str);
        } catch (error) {
            console.error("用於傳入數據的媒介文檔: " + monitor_file + " 無法讀取.");
            console.error(error);
            return monitor_file;
        };

        // // 使用數據流的方式異步讀取文檔數據;
        // let readerStream = fs.createReadStream(monitor_file, {
        //     fs: null,
        //     fd: null,
        //     emitClose: false,
        //     autoClose: true,
        //     flags: 'r+',
        //     start: 0,
        //     end: Infinity,
        //     encoding: 'utf8',
        //     mode: 0o666,
        //     highWaterMark: 64  // 參數 highWaterMark 表示最高水位綫，預設最多讀取 64K;
        // });
        // console.log(readerStream.readableFlowing);  //使用fs.createReadStream().readableFlowing查看可讀流狀態，值為null、false、true三個之一;
        // readerStream.setEncoding('UTF8');  // 將剛才創建的可讀流設置為 utf8 編碼，為流指定了預設的字元編碼，則監聽器回檔傳入的資料為字串，否則傳入的資料為 Buffer;
        // let arr_chunk = new Array; // 暫存從文檔讀到的内容的數據流中的數據塊chunk;
        // // // 監聽處理可讀流事件 -> 'open'、'ready'、'data'、'readable'、'end'、'error'、'close';
        // // readerStream.on('open', function () {

        // //     console.log('readerStream is "open".');
        // //     console.log(readStream.path); // 返回可讀流指向的文檔路徑;
        // //     console.log(readStream.pending); // 判斷可讀流是否已經進入’ready’狀態，在'open'狀態之後'ready'狀態之前.pending值為true;
        // // });
        // // readerStream.on('ready', function () {

        // //     console.log('readerStream is "ready" …');
        // //     console.log(readStream.path); // 返回可讀流指向的文檔路徑;
        // //     console.log(readStream.readableObjectMode); // 返回可讀流字符編碼形式;
        // //     console.log(readStream.pending); // 判斷可讀流是否已經進入’ready’狀態，在'open'狀態之後'ready'狀態之前.pending值為true;
        // //     console.log(readStream.bytesRead); // 返回已經讀取到的字節數;
        // //     console.log(readStream.readableLength); // 返回隊列中正在排隊等待被讀取的字節數;
        // // });
        // // 監聽'data'事件，會觸發數據流動;
        // readerStream.on('data', function (chunk) {
        //     // console.log('readerStream is "data" …');
        //     // console.log(`接收到 ${chunk.length} 個字節的數據`);
        //     arr_chunk.push(chunk);  // 數據流中的數據塊chunk為Buffer類型;

        //     // // 在流式讀取數據的過程中，可以使用fs.createReadStream().pause()方法暫停，然後再使用fs.createReadStream().resume()方法繼續;
        //     // readerStream.pause(); // 暫停;
        //     // console.log('暫停一秒 …');
        //     // setTimeout(() => {
        //     //     console.log('數據繼續流動 …');
        //     //     readable.resume(); // 繼續;
        //     // }, 1000);
        // });
        // // readerStream.on('readable', function () {
        // //     // 'readable' 事件表明流有新的動態：要麼有新的資料，要麼到達流的盡頭；對於前者，stream.read() 會返回可用的資料；對於後者，stream.read() 會返回 null 值；當到達流資料的盡頭時，'readable' 事件也會被觸發，但是在 'end' 事件之前被觸發，也就是説最後一個 stream.read() 值一定是 null，然後 'end' 事件將被觸發;
        // //     // 從內部緩衝拉取並返回資料，如果沒有可讀的資料，則返回 null 值，預設情況下，readable.read() 返回的資料是 Buffer 對象，除非使用 readable.setEncoding() 指定字元編碼或流處於物件模式;
        // //     // 可選的 size 參數指定要讀取的特定字節數，如果無法讀取 size 個字節，則除非流已結束，否則將會返回 null 值，在這種情況下，將會返回內部 buffer 中剩餘的所有資料，如果沒有指定 size 參數，則返回內部緩衝中的所有資料；需要注意，size 參數必須小於或等於 1 GiB;
        // //     // readable.read() 應該只對處於暫停模式的可讀流調用，在流動模式中，readable.read() 會自動調用直到內部緩衝的資料完全耗盡;

        // //     while (this.read()) {
        // //         console.log(this.read()); // readerStream.read();
        // //     };
        // // });
        // // 監聽錯誤事件'error';
        // readerStream.on('error', function (error) {
        //     console.log("媒介文檔: " + monitor_file + " 讀取錯誤.");
        //     console.log(error.stack);
        //     return monitor_file;
        // });
        // // 監聽文檔讀取完畢事件'end';
        // readerStream.on('end', function (chunk) {

        //     // console.log('readerStream is "end".');
        //     // console.log(readStream.path); // 返回可讀流指向的文檔路徑;
        //     // console.log(readStream.readableObjectMode); // 返回可讀流字符編碼形式;
        //     // console.log(readStream.bytesRead); // 返回已經讀取到的字節數;
        //     // console.log(readStream.readableLength); // 返回隊列中正在排隊等待被讀取的字節數;

        //     // data_Str = arr_chunk.join().toString("utf8");  // 將 chunks 數組中的各元素拼接成字符串在控制臺顯示;
        //     data_Str = Buffer.concat(arr_chunk).toString("utf8");  // 合并Buffer格式的arr_chunk並轉換爲字符串類型;
        //     // console.log(Buffer.concat(arr_chunk).toString("utf8"));
        //     // console.log(arr_chunk.join()); // 將 chunks 數組中的各元素拼接成字符串在控制臺顯示;

        //     fs.unlinkSync(monitor_dir);  // 同步刪除，返回值為 undefined;
        //     // console.error("媒介文檔: " + monitor_file + " 已被刪除.");
        //     // console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));

        //     // 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
        //     file_bool = false;
        //     try {
        //         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
        //         file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
        //         // console.log("文檔: " + monitor_file + " 存在.");
        //     } catch (error) {
        //         console.error("無法確定媒介文檔: " + monitor_file + " 是否存在.");
        //         console.error(error);
        //     };
        //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
        //     if (file_bool) {
        //         console.error("媒介文檔: " + monitor_file + " 無法刪除.");
        //         return monitor_file;
        //     };
        // });
        // // readerStream.on('close', function (chunk) {

        // //     console.log('readerStream is "close".');
        // //     console.log(readStream.path); // 返回可讀流指向的文檔路徑;
        // //     console.log(readStream.readableObjectMode); // 返回可讀流字符編碼形式;
        // //     console.log(readStream.bytesRead); // 返回已經讀取到的字節數;
        // //     console.log(readStream.readableLength); // 返回隊列中正在排隊等待被讀取的字節數;
        // //     readerStream.destroy(); // 銷毀流，可選地觸發 'error' 事件，並觸發 'close' 事件（除非將參數 emitClose 設置為 false）；在此調用之後，可讀流將會釋放所有內部的資源，並且將會忽略對 push() 的後續調用；一旦調用 destroy() 方法，則不會再執行任何其他操作，並且除了 _destroy() 方法以外的其他錯誤都不會作為 'error' 觸發;
        // //     console.log("readerStream is destroy ? " + readerStream.destroyed); // 在調用 readable.destroy() 方法之後 readerStream.destroyed 的值之後為 true;
        // // });


        // // 同步打開，用於傳入數據的媒介文檔;
        // let fd = fs.openSync(monitor_file, "r+", 0o666);  // fs.constants.O_RDWR 或者 fs.constants.O_RDONLY | fs.constants.O_WRONLY ;
        // // O_RDONLY        表明打開檔用於唯讀訪問。
        // // O_WRONLY        表明打開檔用於只寫訪問。
        // // O_RDWR	        表明打開檔用於讀寫訪問。
        // // O_CREAT	        表明如果檔尚不存在則創建該檔。
        // // O_EXCL          表明如果設置了 O_CREAT 標誌且檔已存在，則打開檔應該失敗。
        // // O_NOCTTY        表明如果路徑表示終端設備，則打開該路徑不應該造成該終端變成進程的控制終端（如果進程還沒有終端）。
        // // O_TRUNC         表明如果檔存在且是普通的檔、並且檔成功打開以進行寫入訪問，則其長度應截斷為零。
        // // O_APPEND        表明資料將會追加到檔的末尾。
        // // O_DIRECTORY     表明如果路徑不是目錄，則打開應該失敗。
        // // O_NOATIME       表明檔案系統的讀取訪問將不再導致與檔相關聯的 atime 資訊的更新。 僅在 Linux 作業系統上可用。
        // // O_NOFOLLOW      表明如果路徑是符號連結，則打開應該失敗。
        // // O_SYNC          表明檔是為同步 I/O 打開的，寫入操作將會等待檔的完整性。
        // // O_DSYNC         表明檔是為同步 I/O 打開的，寫入操作將會等待資料的完整性
        // // O_SYMLINK       表明打開符號連結自身，而不是它指向的資源。
        // // O_DIRECT        表明將嘗試最小化檔 I/O 的緩存效果。
        // // O_NONBLOCK      表明在可能的情況下以非阻塞模式打開檔。
        // // UV_FS_O_FILEMAP 當設置後，將會使用記憶體檔的映射來訪問檔。 此標誌僅在 Windows 作業系統上可用。 在其他作業系統上，此標誌會被忽略。

        // // 'a':   打開文件用於追加。 如果檔不存在，則創建該檔。
        // // 'ax':  類似於 'a'，但如果路徑存在，則失敗。
        // // 'a+':  打開文件用於讀取和追加。 如果檔不存在，則創建該檔。
        // // 'ax+': 類似於 'a+'，但如果路徑存在，則失敗。
        // // 'as':  打開檔用於追加（在同步模式中）。 如果檔不存在，則創建該檔。
        // // 'as+': 打開文件用於讀取和追加（在同步模式中）。 如果檔不存在，則創建該檔。
        // // 'r':   打開文件用於讀取。 如果檔不存在，則會發生異常。
        // // 'r+':  打開文件用於讀取和寫入。 如果檔不存在，則會發生異常。
        // // 'rs+': 打開文件用於讀取和寫入（在同步模式中）。 指示作業系統繞過本地的檔案系統緩存。
        // // 這對於在 NFS 掛載上打開檔時非常有用，因為它可以跳過可能過時的本地緩存。 它對 I / O 性能有非常實際的影響，因此不建議使用此標誌（除非真的需要）。
        // // 這不會把 fs.open() 或 fsPromises.open() 變成同步的阻塞調用。 如果需要同步的操作，則應使用 fs.openSync() 之類的。
        // // 'w':   打開文件用於寫入。 如果檔不存在則創建檔，如果檔存在則截斷檔。
        // // 'wx':  類似於 'w'，但如果路徑存在，則失敗。
        // // 'w+':  打開文件用於讀取和寫入。 如果檔不存在則創建檔，如果檔存在則截斷檔。
        // // 'wx+': 類似於 'w+'，但如果路徑存在，則失敗。

        // // 同步讀取，用於傳入數據的媒介文檔中的數據;
        // try {
        //     let buf = new Buffer(8);
        //     let buffer_data = fs.readSync(fd, buf, 0, buf.length, null);  // 同步讀取;
        //     data_Str = buffer_data.toString('utf8');  // 將Buffer轉換爲String;
        //     // buffer_data = Buffer.from(text, 'utf8');  // 將String轉換爲Buffer;
        //     console.log(data_Str);
        // } catch (error) {
        //     console.error("媒介文檔: " + monitor_file + " 無法讀取.");
        //     console.error(error);
        //     return monitor_file;
        // } finally {
        //     fs.closeSync(fd);  // 同步關閉;
        // };
        // // 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


        // // 讀取到輸入數據之後，同步刪除，用於接收傳值的媒介文檔;
        // try {
        //     fs.unlinkSync(monitor_file);  // 同步刪除，返回值為 undefined;
        //     // console.error("媒介文檔: " + monitor_file + " 已被刪除.");
        //     // console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
        // } catch (error) {
        //     console.error("用於傳入數據的媒介文檔: " + monitor_file + " 無法刪除.");
        //     console.error(error);
        //     return monitor_file;
        // };

        // // 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
        // file_bool = false;
        // try {
        //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
        //     file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
        //     // console.log("文檔: " + monitor_file + " 存在.");
        // } catch (error) {
        //     console.error("無法確定用於傳入數據的媒介文檔: " + monitor_file + " 是否存在.");
        //     console.error(error);
        //     return monitor_file;
        // };
        // // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
        // if (file_bool) {
        //     console.error("用於傳入數據的媒介文檔: " + monitor_file + " 無法刪除.");
        //     return monitor_file;
        // };

        let response_data_String = "";

        // // let now_date = String(new Date().toLocaleString('chinese', { hour12: false }));
        // let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
        // // // console.log(now_date);
        // let response_data_JSON = {
        //     "Server_say": "",
        //     "Server_Authorization": "",
        //     "time": ""  // now_date
        // };
        // // console.log(data_Str);
        // // console.log(typeof(data_Str));
        // if (data_Str === "") {
        //     response_data_JSON["Server_say"] = "";
        // } else {
        //     let require_data_JSON = {};
        //     // 使用自定義函數isStringJSON(data_Str)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
        //     if (isStringJSON(data_Str)) {
        //         require_data_JSON = JSON.parse(data_Str);  // 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
        //         // str = JSON.stringify(jsonObj);
        //         // Obj = JSON.parse(jsonStr);
        //     } else {
        //         require_data_JSON = {
        //             "Client_say": data_Str,
        //             "time": now_date
        //         };
        //     };
        //     // console.log(require_data_JSON);
        //     // console.log(typeof(require_data_JSON));

        //     response_data_JSON["Server_say"] = do_Function(require_data_JSON)["Server_say"];
        //     // let now_date = String(new Date().toLocaleString('chinese', { hour12: false }));
        //     now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
        //     // console.log(now_date);
        //     response_data_JSON["time"] = now_date;
        // };

        if (typeof (do_Function) !== undefined && do_Function !== undefined && do_Function !== null && do_Function !== NaN && do_Function !== "" && Object.prototype.toString.call(do_Function).toLowerCase() === '[object function]') {
            response_data_String = do_Function(data_Str);
        } else {
            response_data_String = data_Str;
        };

        // response_data_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
        let response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
        // str = JSON.stringify(jsonObj);
        // Obj = JSON.parse(jsonStr);
        // bytes = response_data_String.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
        // bytes = response_data_String.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
        // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
        // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
        // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
        // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
        response_data_String_len = Buffer.byteLength(response_data_String);


        // 使用Node.js原生模組fs判斷指定的用於傳出數據的媒介目錄是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(output_dir) && fs.statSync(output_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + output_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸出的媒介文件夾: " + output_dir + " 是否存在.");
            console.error(error);
            return output_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            // 同步創建，創建用於傳入數據的監聽媒介文件夾;
            try {
                // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                fs.mkdirSync(output_dir, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                // console.log("目錄: " + output_dir + " 創建成功.");
                // temp_dir_path_str = fs.mkdtempSync(os.tmpdir().concat(require('path').sep), {encoding: 'utf8'});  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
                // fs.rmdirSync(path[, options]);  // 同步刪除目錄;
            } catch (error) {
                console.error("用於輸出數據的媒介文件夾: " + output_dir + " 無法創建.");
                console.error(error);
                return output_dir;
            };
        };

        // 判斷媒介文件夾是否創建成功;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(output_dir) && fs.statSync(output_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + output_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸出的媒介文件夾: " + output_dir + " 是否存在.");
            console.error(error);
            return output_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            console.log("用於輸出數據的媒介文件夾 [ " + output_dir + " ] 無法被創建.");
            return output_dir;
        };

        // // 同步判斷文件夾權限，使用Node.js原生模組fs的fs.accessSync(output_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        // try {
        //     // 同步判斷文件夾權限，使用Node.js原生模組fs的fs.accessSync(output_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     fs.accessSync(output_dir, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("目錄: " + output_dir + " 可以讀寫.");
        // } catch (error) {
        //     // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
        //     try {
        //         // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(output_dir, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("目錄: " + output_dir + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
        //     } catch (error) {
        //         console.error("用於傳出數據的媒介文件夾 [ " + output_dir + " ] 無法修改為可讀可寫權限.");
        //         console.error(error);
        //         return output_dir;
        //     };
        // };

        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷判斷用於輸出傳值的媒介文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
            // console.log("文檔: " + output_file + " 存在.");
        } catch (error) {
            console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
            console.error(error);
            return output_file;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷用於輸出的媒介文檔是否存在以及是否為文檔;
        if (file_bool) {

            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
            try {
                // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                // console.log("文檔: " + output_file + " 可以讀寫.");
            } catch (error) {
                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                try {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                    fs.fchmodSync(output_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                    // console.log("文檔: " + output_file + " 操作權限修改為可以讀寫.");
                    // 常量                    八進制值    說明
                    // fs.constants.S_IRUSR    0o400      所有者可讀
                    // fs.constants.S_IWUSR    0o200      所有者可寫
                    // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                    // fs.constants.S_IRGRP    0o40       群組可讀
                    // fs.constants.S_IWGRP    0o20       群組可寫
                    // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                    // fs.constants.S_IROTH    0o4        其他人可讀
                    // fs.constants.S_IWOTH    0o2        其他人可寫
                    // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                    // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    // 數字	說明
                    // 7	可讀、可寫、可執行
                    // 6	可讀、可寫
                    // 5	可讀、可執行
                    // 4	唯讀
                    // 3	可寫、可執行
                    // 2	只寫
                    // 1	只可執行
                    // 0	沒有許可權
                    // 例如，八進制值 0o765 表示：
                    // 1) 、所有者可以讀取、寫入和執行該文檔；
                    // 2) 、群組可以讀和寫入該文檔；
                    // 3) 、其他人可以讀取和執行該文檔；
                    // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                } catch (error) {
                    console.error("用於傳出數據的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.");
                    console.error(error);
                    return output_file;
                };
            };

            // // 同步刪除，已經存在的用於輸出數據的的媒介文檔，重新創建，以輸出數據;
            // try {
            //     fs.unlinkSync(output_file);  // 同步刪除，返回值為 undefined;
            //     // console.error("已經存在的用於傳出數據的媒介文檔: " + output_file + " 已被刪除.");
            //     // console.log(fs.readdirSync(output_file, { encoding: "utf8", withFileTypes: false }));
            // } catch (error) {
            //     console.error("已經存在的用於輸出數據的媒介文檔: " + output_file + " 無法刪除.");
            //     console.error(error);
            //     return output_file;
            // };

            // // 同步判斷，已經存在的用於輸出數據的媒介文檔，是否已經從硬盤刪除;
            // file_bool = false;
            // try {
            //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            //     file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
            //     // console.log("媒介文檔: " + output_file + " 存在.");
            // } catch (error) {
            //     console.error("無法確定用於輸出數據的媒介文檔: " + output_file + " 是否存在.");
            //     console.error(error);
            //     return output_file;
            // };
            // // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            // if (file_bool) {
            //     console.error("已經存在的用於輸出數據的媒介文檔: " + output_file + " 無法刪除.");
            //     return output_file;
            // };
        };

        // 同步寫入，用於傳出數據的媒介文檔中的數據;
        // response_data_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
        // response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
        try {
            // console.log(response_data_String);
            fs.writeFileSync(output_file, response_data_String, { encoding: "utf8", mode: 0o777, flag: "w+" });  // 返回值為 undefined;
            // // response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
            // fs.writeFileSync(output_file, response_data_bytes, { mode: 0o777, flag: "w+" });  // 返回值為 undefined;
            // console.log(response_data_bytes);
            // // let buffer = new Buffer(8);
            // let buffer_data = fs.readFileSync(monitor_file, { encoding: null, flag: "r+" });
            // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
            // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
            // console.log(data_Str);
        } catch (error) {
            console.error("用於輸出的媒介文檔: " + output_file + " 無法寫入數據.");
            console.error(error);
            return output_file;
        };

        // // // 使用數據流的方式將數據異步寫入硬盤文檔;
        // // response_data_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
        // // response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
        // let writerStream = fs.createWriteStream(output_file, {
        //     fs: null,
        //     start: 0,
        //     fd: null,
        //     emitClose: false,
        //     autoClose: true,
        //     flags: 'w+',
        //     encoding: 'utf8',
        //     mode: 0o777,
        //     highWaterMark: 16  // mode: 0o666 創建一個可寫流對象，參數 highWaterMark 表示最高水位綫，預設 16K;
        // });
        // // console.log(writerStream.writable);  // 使用fs.createWriteStream().writable查看可寫流狀態，如果調用 writable.write() 是安全的（這意味著流沒有被破壞、報錯、或結束），則fs.createWriteStream().writable為 true 值;
        // writerStream.setDefaultEncoding('utf8');  // 為可寫流設置默認的 encoding 編碼;
        // // 監聽處理可寫流事件 -> 'open'、'ready'、'drain'、'finish '、'error'、'close';
        // // writerStream.on('open', function () {
        // //     console.log(writerStream.path);  // 返回可寫流指向的文檔路徑;
        // //     console.log('writerStream is "open".');
        // //     console.log(writerStream.pending);  // 判斷可寫流是否已經進入’ready’狀態，在'open'狀態之後'ready'狀態之前.pending值為true;
        // // });
        // writerStream.on('ready', function () {
        //     // console.log('writerStream is "ready".');
        //     // console.log(writerStream.pending); // 判斷可寫流是否已經進入’ready’狀態，在'open'狀態之後'ready'狀態之前.pending值為true;
        //     // console.log(writerStream.path); // 返回可寫流指向的文檔路徑;
        //     // console.log(writerStream.writableObjectMode); // 返回可寫流字符編碼形式;
        //     // console.log(writerStream.writableLength); // 返回準備被寫入的字節數;
        //     // console.log(writerStream.bytesWritten); // 返回已經寫入的字節數;

        //     // console.log(writerStream.writable); // 使用fs.createWriteStream().writable查看可寫流狀態，如果調用 writable.write() 是安全的（這意味著流沒有被破壞、報錯、或結束），則fs.createWriteStream().writable為 true 值;

        //     // 寫入String 字符串數據;
        //     // response_data_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
        //     // 將 String 數據，以數據流的數據塊chunk方式寫入文檔;
        //     let blockSize = 16;  // 預設的將數據分割為單位數據塊的大小(字符數)，預設為 1 個數據塊 blockSize = response_data_String.length;
        //     let nbBlocks = Math.ceil(response_data_String.length / blockSize);  // 數據分割後數據塊的數碼;
        //     for (let i = 0; i < nbBlocks; i++) {
        //         let chunk = response_data_String.slice(
        //             blockSize * i,
        //             Math.min(blockSize * (i + 1), response_data_String.length)
        //         );
        //         writerStream.write(chunk, 'utf8', function () {
        //             // 使用 utf8 編碼寫入數據，並在全部寫入之後回調;

        //             // console.log('writerStream is "writing" …');

        //             // console.log(writerStream.path); // 返回可寫流指向的文檔路徑;
        //             // console.log(writerStream.writableObjectMode); // 返回可寫流字符編碼形式;
        //             // console.log(writerStream.writableLength); // 返回準備被寫入的字節數;
        //             // console.log(writerStream.bytesWritten); // 返回已經寫入的字節數;
        //         });
        //     };

        //     // // 寫入 Buffer 二進制對象數據;
        //     // // response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
        //     // // 將 Buffer 數據，以數據流的數據塊chunk方式寫入文檔;
        //     // let blockSize = 128;  // 預設的將數據分割為單位數據塊的大小(kb);
        //     // let nbBlocks = Math.ceil(response_data_bytes.length / blockSize);  // 數據分割後數據塊的數碼，預設為 1 個數據塊 blockSize = response_data_bytes.length;
        //     // for (let i = 0; i < nbBlocks; i++) {
        //     //     let chunk = response_data_bytes.slice(
        //     //         blockSize * i,
        //     //         Math.min(blockSize * (i + 1), response_data_bytes.length)
        //     //     );
        //     //     writerStream.write(chunk, function () {
        //     //         // 使用 utf8 編碼寫入數據，並在全部寫入之後回調;

        //     //         // console.log('writerStream is "writing" …');

        //     //         // console.log(writerStream.path); // 返回可寫流指向的文檔路徑;
        //     //         // console.log(writerStream.writableObjectMode); // 返回可寫流字符編碼形式;
        //     //         // console.log(writerStream.writableLength); // 返回準備被寫入的字節數;
        //     //         // console.log(writerStream.bytesWritten); // 返回已經寫入的字節數;
        //     //     });
        //     // };

        //     // writerStream.end();
        // });
        // writerStream.on('error', function (error) {
        //     // 如果在寫入或管道資料時發生錯誤，則會觸發 'error' 事件，當調用時，監聽器回檔會傳入一個 Error 參數；除非在創建流時將 autoDestroy 選項設置為 false 值，否則在觸發 'error' 事件時流會被關閉；在 'error' 之後，除 'close' 事件外，不應再觸發其他事件（包括 'error' 事件）;
        //     console.log(error.stack);
        // });
        // // writerStream.on('drain', function () {
        // //     // 監聽'drain'事件，事件'drain'在.write()方法執行完畢之後觸發，表示内存中的數據已經全寫完比;

        // //     console.log('writerStream is "drain".');

        // //     console.log(writerStream.path); // 返回可寫流指向的文檔路徑;
        // //     console.log(writerStream.writableObjectMode); // 返回可寫流字符編碼形式;
        // //     console.log(writerStream.writableLength); // 返回準備被寫入的字節數;
        // //     console.log(writerStream.bytesWritten); // 返回已經寫入的字節數;
        // // });
        // // console.log("writerStream is finish ? " + writerStream.writableFinished); // 使用fs.createWriteStream().writableFinished查看可寫流是否已經觸發 'finish' 事件，在觸發 'finish' 事件之前的一瞬間fs.createWriteStream().writableFinished會立即變更為 true 值;
        // writerStream.on('finish', function () {

        //     // console.log('writerStream is "finish".');
        //     // console.log("writerStream is finish ? " + writerStream.writableFinished); // 使用fs.createWriteStream().writableFinished查看可寫流是否已經觸發 'finish' 事件，在觸發 'finish' 事件之前的一瞬間fs.createWriteStream().writableFinished會立即變更為 true 值;
        //     // console.log(writerStream.path); // 返回可寫流指向的文檔路徑;
        //     // console.log(writerStream.writableObjectMode); // 返回可寫流字符編碼形式;
        //     // console.log(writerStream.writableLength); // 返回準備被寫入的字節數;
        //     // console.log(writerStream.bytesWritten); // 返回已經寫入的字節數;

        //     writerStream.end("\\n", "utf8", function (error) {
        //         // 標記文件末尾，使用.end()方法後，後面不允許再寫入數據;
        //     });
        //     // console.log(writerStream.writableEnded); // 使用fs.createWriteStream().writableEnded查看可寫流是否已經執行.end()方法，在調用了 writable.end() 方法之後fs.createWriteStream().writableEnded為 true 值，但此屬性不表明資料是否已刷新;
        // });
        // // writerStream.on('close', function () {

        // //     console.log(writerStream.path); // 返回可寫流指向的文檔路徑;
        // //     console.log(writerStream.writableObjectMode); // 返回可寫流字符編碼形式;
        // //     console.log(writerStream.writableLength); // 返回準備被寫入的字節數;
        // //     console.log(writerStream.bytesWritten); // 返回已經寫入的字節數;

        // //     console.log('writerStream is "close".');

        // //     writerStream.destroy(err); // 銷毀流，可選地觸發 'error'，並且觸發 'close' 事件（除非將 emitClose 設置為 false）；調用該方法後，可寫流就結束了，之後再調用 write() 或 end() 都會導致 ERR_STREAM_DESTROYED 錯誤；這是銷毀流的最直接的方式，如果前面對 write() 的調用還沒有寫入完成完，則執行.destroy(err)方法後，可能觸發 ERR_STREAM_DESTROYED 錯誤；一旦調用 .destroy() 方法，則不會再執行任何其他操作，並且除了 _destroy() 以外的其他錯誤都不會作為 'error' 觸發;
        // //     console.log("writerStream is destroy ? " + writerStream.destroyed); // 在調用了 writable.destroy() 之後 writable.destroyed 的值為 true;
        // // });


        // // 同步打開，用於傳入數據的媒介文檔;
        // let fd = fs.openSync(output_file, "w+", 0o666);  // fs.constants.O_RDWR 或者 fs.constants.O_RDONLY | fs.constants.O_WRONLY ;
        // // O_RDONLY        表明打開檔用於唯讀訪問。
        // // O_WRONLY        表明打開檔用於只寫訪問。
        // // O_RDWR	        表明打開檔用於讀寫訪問。
        // // O_CREAT	        表明如果檔尚不存在則創建該檔。
        // // O_EXCL          表明如果設置了 O_CREAT 標誌且檔已存在，則打開檔應該失敗。
        // // O_NOCTTY        表明如果路徑表示終端設備，則打開該路徑不應該造成該終端變成進程的控制終端（如果進程還沒有終端）。
        // // O_TRUNC         表明如果檔存在且是普通的檔、並且檔成功打開以進行寫入訪問，則其長度應截斷為零。
        // // O_APPEND        表明資料將會追加到檔的末尾。
        // // O_DIRECTORY     表明如果路徑不是目錄，則打開應該失敗。
        // // O_NOATIME       表明檔案系統的讀取訪問將不再導致與檔相關聯的 atime 資訊的更新。 僅在 Linux 作業系統上可用。
        // // O_NOFOLLOW      表明如果路徑是符號連結，則打開應該失敗。
        // // O_SYNC          表明檔是為同步 I/O 打開的，寫入操作將會等待檔的完整性。
        // // O_DSYNC         表明檔是為同步 I/O 打開的，寫入操作將會等待資料的完整性
        // // O_SYMLINK       表明打開符號連結自身，而不是它指向的資源。
        // // O_DIRECT        表明將嘗試最小化檔 I/O 的緩存效果。
        // // O_NONBLOCK      表明在可能的情況下以非阻塞模式打開檔。
        // // UV_FS_O_FILEMAP 當設置後，將會使用記憶體檔的映射來訪問檔。 此標誌僅在 Windows 作業系統上可用。 在其他作業系統上，此標誌會被忽略。

        // // 'a':   打開文件用於追加。 如果檔不存在，則創建該檔。
        // // 'ax':  類似於 'a'，但如果路徑存在，則失敗。
        // // 'a+':  打開文件用於讀取和追加。 如果檔不存在，則創建該檔。
        // // 'ax+': 類似於 'a+'，但如果路徑存在，則失敗。
        // // 'as':  打開檔用於追加（在同步模式中）。 如果檔不存在，則創建該檔。
        // // 'as+': 打開文件用於讀取和追加（在同步模式中）。 如果檔不存在，則創建該檔。
        // // 'r':   打開文件用於讀取。 如果檔不存在，則會發生異常。
        // // 'r+':  打開文件用於讀取和寫入。 如果檔不存在，則會發生異常。
        // // 'rs+': 打開文件用於讀取和寫入（在同步模式中）。 指示作業系統繞過本地的檔案系統緩存。
        // // 這對於在 NFS 掛載上打開檔時非常有用，因為它可以跳過可能過時的本地緩存。 它對 I / O 性能有非常實際的影響，因此不建議使用此標誌（除非真的需要）。
        // // 這不會把 fs.open() 或 fsPromises.open() 變成同步的阻塞調用。 如果需要同步的操作，則應使用 fs.openSync() 之類的。
        // // 'w':   打開文件用於寫入。 如果檔不存在則創建檔，如果檔存在則截斷檔。
        // // 'wx':  類似於 'w'，但如果路徑存在，則失敗。
        // // 'w+':  打開文件用於讀取和寫入。 如果檔不存在則創建檔，如果檔存在則截斷檔。
        // // 'wx+': 類似於 'w+'，但如果路徑存在，則失敗。

        // // 同步寫入，用於傳出數據的媒介文檔中的數據;
        // // response_data_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
        // // response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
        // try {
        //     // console.log(response_data_String);
        //     fs.writeSync(fd, response_data_String, null, "utf8");  // 返回值為 <number> 寫入的字節數;
        //     // // response_data_bytes = new Uint8Array(Buffer.from(response_data_String));  // 轉換為 Buffer 二進制對象;
        //     // fs.writeSync(fd, response_data_bytes, 0, buffer.length, null);  // 返回值為 <number> 寫入的字節數;
        //     // console.log(response_data_bytes);
        //     // // let buffer = new Buffer(8);
        //     // let buffer_data = fs.readFileSync(monitor_file, { encoding: null, flag: "r+" });
        //     // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
        //     // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
        //     // console.log(data_Str);
        // } catch (error) {
        //     console.error("媒介文檔: " + output_file + " 無法寫入.");
        //     console.error(error);
        //     return output_file;
        // } finally {
        //     fs.closeSync(fd);  // 同步關閉;
        // };
        // // 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        // 驗證用於輸出的媒介文檔 output_file 是否被創建成功;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
            // console.log("文檔: " + output_file + " 存在.");
        } catch (error) {
            console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
            console.error(error);
            return output_file;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷用於輸出的媒介文檔是否存在以及是否為文檔;
        if (!file_bool) {
            console.error("用於輸出的媒介文檔: " + output_file + " 無法被創建.");
            return output_file;
        };

        // 同步判斷用於輸出的媒介文檔 output_file 是否具有可讀可寫權限，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        try {
            // 同步判斷用於輸出的媒介文檔 output_file 是否具有可讀可寫權限，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
            fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
            // console.log("文檔: " + output_file + " 可以讀寫.");
        } catch (error) {
            // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
            try {
                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                fs.fchmodSync(output_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                // console.log("文檔: " + output_file + " 操作權限修改為可以讀寫.");
                // 常量                    八進制值    說明
                // fs.constants.S_IRUSR    0o400      所有者可讀
                // fs.constants.S_IWUSR    0o200      所有者可寫
                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                // fs.constants.S_IRGRP    0o40       群組可讀
                // fs.constants.S_IWGRP    0o20       群組可寫
                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                // fs.constants.S_IROTH    0o4        其他人可讀
                // fs.constants.S_IWOTH    0o2        其他人可寫
                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                // 數字	說明
                // 7	可讀、可寫、可執行
                // 6	可讀、可寫
                // 5	可讀、可執行
                // 4	唯讀
                // 3	可寫、可執行
                // 2	只寫
                // 1	只可執行
                // 0	沒有許可權
                // 例如，八進制值 0o765 表示：
                // 1) 、所有者可以讀取、寫入和執行該文檔；
                // 2) 、群組可以讀和寫入該文檔；
                // 3) 、其他人可以讀取和執行該文檔；
                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
            } catch (error) {
                console.error("用於傳出數據的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.");
                console.error(error);
                return output_file;
            };
        };

        // // 使用 child_process.exec 調用 shell 語句反饋;
        // // 運算處理完之後，給調用語言的回復，fs.accessSync(to_executable, fs.constants.X_OK) 判斷脚本文檔是否具有被執行權限;
        // file_bool = false;
        // try {
        //     // 同步判斷，反饋目標解釋器可執行檔 to_executable 是否可執行;
        //     file_bool = Object.prototype.toString.call(to_executable).toLowerCase() === '[object string]' && to_executable !== "" && fs.existsSync(to_executable) && fs.statSync(to_executable, { bigint: false }).isFile() && fs.accessSync(to_executable, fs.constants.X_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("解釋器可執行檔: " + to_executable + " 可以運行.");
        // } catch (error) {
        //     console.error("無法確定反饋目標解釋器可執行檔: " + to_executable + " 是否具有可執行權限.");
        //     console.error(error);
        //     return to_executable;
        // };
        // if (file_bool) {
        //     file_bool = false;
        //     try {
        //         // 同步判斷，反饋目標解釋器運行脚本 to_script 是否可執行;
        //         file_bool = Object.prototype.toString.call(to_script).toLowerCase() === '[object string]' && to_script !== "" && fs.existsSync(to_script) && fs.statSync(to_script, { bigint: false }).isFile() && fs.accessSync(to_script, fs.constants.R_OK | fs.constants.W_OK) && fs.accessSync(to_script, fs.constants.X_OK);  // 0o777，可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //         // console.log("脚本文檔: " + to_script + " 可以被執行.");
        //     } catch (error) {
        //         console.error("無法確定反饋目標解釋器運行脚本文檔: " + to_script + " 是否可執行.");
        //         console.error(error);
        //         return to_script;
        //     };
        //     let shell_run_to_executable = "";
        //     if (file_bool) {
        //         shell_run_to_executable = to_executable.concat(" ", to_script, " ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
        //     } else {
        //         shell_run_to_executable = to_executable.concat(" ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
        //     };
        //     // let result = require('child_process').execSync(shell_run_to_executable);
        //     // // console.log(result);
        //     require('child_process').exec(shell_run_to_executable, function (error, stdout, stderr) {
        //         // if (error) {
        //         //     console.error("EXEC Error: " + error);
        //         //     // return;
        //         // };
        //         // if (stderr) {
        //         //     console.log("stderr: " + stderr);
        //         // };
        //         // if (stdout) {
        //         //     // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
        //         //     console.log(typeof (stdout));
        //         //     console.log(stdout);
        //         //     if (isStringJSON(stdout)) {
        //         //         console.log(JSON.parse(stdout));
        //         //     };
        //         // };
        //     });
        // };

        // // let now_date = new Date().toLocaleString('chinese', { hour12: false });
        // now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
        // // console.log(now_date);
        // let log_text = "< " + monitor_file + " > < " + output_file + " > " + String(now_date);
        // console.log(log_text);
        // // fs.appendFile(path, data[, options], callback);
        // // fs.appendFileSync(path, data[, options]);

        return [response_data_String, output_file];
    };

    // 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
    function monitor_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, delay, temp_NodeJS_cache_IO_data_dir) {
        // console.log("當前進程編號: " + process.pid);
        // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
        // console.log("當前進程使用的内存: " + process.memoryUsage());
        // console.log("運行當前進程的操作系統平臺: " + process.platform);
        // console.log("運行當前進程的操作系統架構: " + process.arch);
        // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
        // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
        // console.log("當前進程的用戶環境: " + process.env);
        // console.log("當前進程的工作目錄: " + process.cwd());
        // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
        // console.log("運行當前進程的運行時間: " + process.uptime());
        // console.log("當前執行緒ID: thread-" + require('worker_threads').threadId);
    
        // CheckString(delay, 'positive_integer');  // 自定義函數檢查輸入合規性;

        // 判斷傳入的參數 do_Function，是直接傳入的函數對象，還是傳入的函數名字字符串;
        if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]') {
            if (typeof (do_Function) !== undefined && do_Function !== undefined && do_Function !== null && do_Function !== "" && Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(do_Function)).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + do_Function + ';')).toLowerCase() === '[object function]')) {
                // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                eval("do_Function = " + do_Function + ';');
            } else if (typeof (do_Function) !== undefined && do_Function !== undefined && do_Function !== null && do_Function !== "" && Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]') {
                // 以 function mytFunc(argument) {} 形式的函數傳值;
                eval(do_Function);
                // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                do_Function = eval(do_Function.match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
            } else {
                console.log("傳入的參數 do_Function 用於處理數據的函數無法識別: " + do_Function);
                do_Function = function (argument) { return argument; };
            };
            // console.log(do_Function);
            // console.log(typeof (do_Function));
        } else if (Object.prototype.toString.call(do_Function).toLowerCase() !== '[object function]') {
            console.log("傳入的參數 do_Function 用於處理數據的函數無法識別: " + do_Function);
            do_Function = function (argument) { return argument; };
        };
        // if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object function]') {
        //     do_Function = do_Function;
        // } else {
        //     console.log("傳入的參數 do_Function 用於處理數據的函數無法識別: " + do_Function);
        //     do_Function = function (argument) { return argument; };
        // };

        if (monitor_file === "") {
            console.log("傳入的用於傳入數據的媒介文檔參數不合法，為空字符串，只接受輸入文檔路徑全名字符串.");
            // console.log(monitor_file);
            return monitor_file;
        };

        // if (output_file === "") {
        //     console.log("用於傳出數據的媒介文檔參數為空字符串不合法，只接受輸入文檔路徑全名字符串.");
        //     // console.log(output_file);
        //     return output_file;
        // };

        // if (monitor_dir === "" || monitor_file === "" || monitor_file.indexOf(monitor_dir, 0) === -1 || output_dir === "" || output_file === "" || output_file.indexOf(output_dir, 0) === -1) {
        //     // path.format(path.parse(output_file))
        //     // (monitor_dir === "" || monitor_file === "" || path.parse(monitor_file)["dir"] !== monitor_dir || output_dir === "" || output_file === "" || path.parse(output_file)["dir"] !== output_dir)
        //     console.log("用於傳入和傳出數據的媒介文檔或媒介路徑，檢測錯誤，無法識別.");
        //     console.log([monitor_dir, monitor_file, output_dir, output_file]);
        //     return [monitor_dir, monitor_file, output_dir, output_file];
        // };

        // 使用Node.js原生模組fs判斷指定的用於傳入數據的媒介目錄是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        let file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(monitor_dir) && fs.statSync(monitor_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + monitor_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸入的媒介文件夾: " + monitor_dir + " 是否存在.");
            console.error(error);
            return monitor_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            // 同步創建，創建用於傳入數據的監聽媒介文件夾;
            try {
                // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                fs.mkdirSync(monitor_dir, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                // console.log("目錄: " + monitor_dir + " 創建成功.");
            } catch (error) {
                console.error("用於輸入數據的媒介文件夾: " + monitor_dir + " 無法創建.");
                console.error(error);
                return monitor_dir;
            };
        };

        // // 同步判斷，使用Node.js原生模組fs的fs.accessSync(monitor_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        // try {
        //     // 同步修改文件夾權限，使用Node.js原生模組fs的fs.accessSync(monitor_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     fs.accessSync(monitor_dir, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("目錄: " + monitor_dir + " 可以讀寫.");
        // } catch (error) {
        //     // 同步判斷，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
        //     try {
        //         // 同步判斷，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(monitor_dir, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("目錄: " + monitor_dir + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
        //     } catch (error) {
        //         console.error("用於接收傳值的媒介文件夾 [ " + monitor_dir + " ] 無法修改為可讀可寫權限.");
        //         console.error(error);
        //         return monitor_dir;
        //     };
        // };

        // 判斷媒介文件夾是否創建成功;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(monitor_dir) && fs.statSync(monitor_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + monitor_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸入的媒介文件夾: " + monitor_dir + " 是否存在.");
            console.error(error);
            return monitor_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            console.log("用於傳值的媒介文件夾 [ " + monitor_dir + " ] 無法被創建.");
            return monitor_dir;
        };

        // // 可以先改變工作目錄到 static 路徑;
        // console.log('Starting directory: ' + process.cwd());
        // try {
        //     process.chdir('D:\\tmp\\');
        //     console.log('New directory: ' + process.cwd());
        // } catch (error) {
        //     console.log('chdir: ' + error);
        // };

        // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
        // try {
        //     console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
        // } catch (error) {
        //     console.log(error);
        // };

        // 使用Node.js原生模組fs判斷指定的用於傳出數據的媒介目錄是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(output_dir) && fs.statSync(output_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + output_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸出的媒介文件夾: " + output_dir + " 是否存在.");
            console.error(error);
            return output_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            // 同步創建，創建用於傳入數據的監聽媒介文件夾;
            try {
                // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                fs.mkdirSync(output_dir, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                // console.log("目錄: " + output_dir + " 創建成功.");
                // temp_dir_path_str = fs.mkdtempSync(os.tmpdir().concat(require('path').sep), {encoding: 'utf8'});  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
                // fs.rmdirSync(path[, options]);  // 同步刪除目錄;
            } catch (error) {
                console.error("用於輸出數據的媒介文件夾: " + output_dir + " 無法創建.");
                console.error(error);
                return output_dir;
            };
        };

        // // 同步判斷，使用Node.js原生模組fs的fs.accessSync(output_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        // try {
        //     // 同步判斷，使用Node.js原生模組fs的fs.accessSync(output_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     fs.accessSync(output_dir, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("目錄: " + output_dir + " 可以讀寫.");
        // } catch (error) {
        //     // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
        //     try {
        //         // 同步判斷，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(output_dir, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("目錄: " + output_dir + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
        //     } catch (error) {
        //         console.error("用於傳出數據的媒介文件夾 [ " + output_dir + " ] 無法修改為可讀可寫權限.");
        //         console.error(error);
        //         return output_dir;
        //     };
        // };

        // 判斷媒介文件夾是否創建成功;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(output_dir) && fs.statSync(output_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + output_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於輸出的媒介文件夾: " + output_dir + " 是否存在.");
            console.error(error);
            return output_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            console.log("用於輸出數據的媒介文件夾 [ " + output_dir + " ] 無法被創建.");
            return output_dir;
        };

        // 使用Node.js原生模組fs判斷指定的用於暫存傳入傳出數據的臨時媒介文件夾是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        // let temp_NodeJS_cache_IO_data_dir = require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾;
        // console.log(temp_NodeJS_cache_IO_data_dir);
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_NodeJS_cache_IO_data_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(temp_NodeJS_cache_IO_data_dir) && fs.statSync(temp_NodeJS_cache_IO_data_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + temp_NodeJS_cache_IO_data_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於用於暫存傳入傳出數據的臨時媒介文件夾: " + temp_NodeJS_cache_IO_data_dir + " 是否存在.");
            console.error(error);
            return temp_NodeJS_cache_IO_data_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_NodeJS_cache_IO_data_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            // 同步創建，創建用於傳入數據的監聽媒介文件夾;
            try {
                // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                fs.mkdirSync(temp_NodeJS_cache_IO_data_dir, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                // temp_NodeJS_cache_IO_data_dir = fs.mkdtempSync(require('os').tmpdir().concat(require('path').sep), { encoding: 'utf8' });  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
                // console.log(temp_NodeJS_cache_IO_data_dir);
                // fs.rmdirSync(temp_NodeJS_cache_IO_data_dir, { maxRetries: 0, recursive: false, retryDelay: 100 });  // 同步刪除目錄 fs.rmdirSync(path[, options]) 返回值 undefined;
            } catch (error) {
                console.error("用於輸入用於暫存傳入傳出數據的臨時媒介文件夾: " + temp_NodeJS_cache_IO_data_dir + " 無法創建.");
                console.error(error);
                return temp_NodeJS_cache_IO_data_dir;
            };
        };

        // // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_NodeJS_cache_IO_data_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        // try {
        //     // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_NodeJS_cache_IO_data_dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     file_bool = fs.accessSync(temp_NodeJS_cache_IO_data_dir, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("目錄: " + temp_NodeJS_cache_IO_data_dir + " 可以讀寫.");
        // } catch (error) {
        //     // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
        //     try {
        //         // 同步判斷，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(temp_NodeJS_cache_IO_data_dir, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("目錄: " + temp_NodeJS_cache_IO_data_dir + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
        //     } catch (error) {
        //         console.error("用於用於暫存傳入傳出數據的臨時媒介文件夾 [ " + temp_NodeJS_cache_IO_data_dir + " ] 無法修改為可讀可寫權限.");
        //         console.error(error);
        //         return temp_NodeJS_cache_IO_data_dir;
        //     };
        // };

        // 判斷媒介文件夾是否創建成功;
        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_NodeJS_cache_IO_data_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = fs.existsSync(temp_NodeJS_cache_IO_data_dir) && fs.statSync(temp_NodeJS_cache_IO_data_dir, { bigint: false }).isDirectory();
            // console.log("目錄: " + temp_NodeJS_cache_IO_data_dir + " 存在.");
        } catch (error) {
            console.error("無法確定用於用於暫存傳入傳出數據的臨時媒介文件夾: " + temp_NodeJS_cache_IO_data_dir + " 是否存在.");
            console.error(error);
            return temp_NodeJS_cache_IO_data_dir;
        };
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_NodeJS_cache_IO_data_dir)方法判斷目錄或文檔是否存在以及是否為文檔;
        if (!file_bool) {
            console.log("用於用於暫存傳入傳出數據的臨時媒介文件夾 [ " + temp_NodeJS_cache_IO_data_dir + " ] 無法被創建.");
            return temp_NodeJS_cache_IO_data_dir;
        };

        // // 可以先改變工作目錄到 static 路徑;
        // console.log('Starting directory: ' + process.cwd());
        // try {
        //     process.chdir('D:\\tmp\\');
        //     console.log('New directory: ' + process.cwd());
        // } catch (error) {
        //     console.log('chdir: ' + error);
        //     console.error(error);
        // };

        let input_queues_array = new Array;
        let output_queues_array = new Array;

        // 監聽文件夾，監測指定目錄下是否有新增或刪除文檔或文件夾的動作;
        let input_file_NUM = Number(0);  // 監聽到的第幾次傳入媒介文檔;


        // // 使用Node.js原生的 fs 文件處理模組的 fs.watch(filename[, options][, listener]) 方法監聽指定文檔被文檔被更改事件 "D:\\temp\\intermediary_write_Python.txt";
        // // 返回一個 fs.FSWatcher 對象，擁有一個 close 方法，用於停止 watch 操作;
        // // 監聽 filename 的更改，其中 filename 是檔或目錄;
        // // persistent < boolean > 指示如果檔已正被監視，進程是否應繼續運行。預設值: true;
        // // recursive < boolean > 指示應該監視所有子目錄，還是僅監視目前的目錄。這適用于監視目錄時，並且僅適用於受支援的平臺（參見注意事項）。預設值: false;
        // // encoding < string > 指定用於傳給監聽器的檔案名的字元編碼。預設值: 'utf8';
        // // 監聽器回檔有兩個參數(eventType, filename) 。 eventType 是 'rename' 或 'change'， filename 是觸發事件的檔的名稱，在大多數平臺上，每當檔案名在目錄中出現或消失時，就會觸發 'rename' 事件;
        // // 僅在 macOS 和 Windows 上支援 recursive 選項，當在不支援該選項的平臺上使用該選項時，則會拋出 ERR_FEATURE_UNAVAILABLE_ON_PLATFORM 異常;
        // // 在 Windows 上，如果監視的目錄被移動或重命名，則不會觸發任何事件，當監視的目錄被刪除時，則報告 EPERM 錯誤;
        // // 使用 fs.watch('./tmp', { encoding: 'buffer' }, (eventType, filename) => { }) 是通過操作系統提供的文件更改通知機制，在Linux操作系統使用inotify，在macOS系統使用FSEvents，在windows系統使用ReadDirectoryChangesW，而且可以用來監聽目錄的變化;
        // // 但當修改一個文件時，回調卻執行了4次，原因是文件被寫入時，可能觸發多次寫操作，即使只保存了一次；另外一些開源編輯器可能先清空文件再寫入，也會影響觸發回調的次數;
        // // 通過使用 md5 校驗文件内容是否被修改，並使用加入延遲機制，延遲 100 毫秒進行判斷，從而避免中間狀態，只返回一次回調觸發;
        // try {
        //     let md5Previous = null;  // md5Previous = md5(fs.readFileSync(monitor_file));
        //     let fsWait = false;
        //     const fsWatcher = fs.watch(monitor_file, { persistent: true, recursive: false, encoding: 'utf8' }, function (eventType, filename) {
        //         console.log("文檔監視器創建成功，監聽文檔觸發的事件類型: " + eventType);  // 'rename' or 'change';
        //         if (filename) {
        //             console.log("觸發事件提供的文件名: " + filename);
        //             if (fsWait) { return; };
        //             fsWait = setTimeout(function () {
        //                 fsWait = false;
        //             }, 100);
        //             const md5Current = md5(fs.readFileSync(monitor_file));
        //             if (md5Current === md5Previous) {
        //                 return;
        //             };
        //             md5Previous = md5Current;
        //             console.log(filename + " was " + eventType + " ed.");
        //             console.log(filename + " file changed.");
        //         };
        //     });
        // } catch (error) {
        //     console.error("fs.Watch file: " + monitor_file + " error.");
        // };
        // // 停止 watch 監聽動作;
        // fsWatcher.close(function (error) {
        //     if (error) { console.error(err); };
        //     console.log("文檔監視器 watch 關閉成功.");
        // });
        // // // 一秒之後停止;
        // // setTimeout(function () {
        // //     fsWatcher.close(function (error) {
        // //         if (error) { console.error(err); };
        // //         console.log("文檔監視器 watch 關閉成功.");
        // //     });
        // // }, 1000);
        // // 監聽 'rename' 事件;
        // fsWatcher.on('rename', function (error, filename) { });
        // // 監聽 'change' 事件;
        // fsWatcher.on('change', function (error, filename) { });
        // function Monitor_Array(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, temp_NodeJS_cache_IO_data_dir) {

        //     let result = null;  // 從硬盤讀取數據，並處理完畢之後的反饋結果;

        //     // 監聽待處理任務隊列數組 input_queues_array 和 空閑子綫程隊列 worker_free，當有待處理任務等待時，且有空閑子進程時，將待任務隊列中排在前面的第一個待處理任務，推入一個空閑子進程;
        //     if (input_queues_array.length > 0) {};

        //     // 監聽待傳出數據結果隊列數組 output_queues_array，當有用於傳出數據的媒介目錄 output_dir 中不在含有 output_file 時，將待傳出數據結果隊列數組 output_queues_array 中排在前面的第一個結果文檔，更名移人用於傳出數據的媒介目錄 output_dir 中;
        //     if (output_queues_array.length > 0) {};

        //     // console.log("當前進程編號: process-" + process.pid + " thread-" + require('worker_threads').threadId)
        //     return [result, output_queues_array, input_queues_array];
        // };
        // // 監聽指定文檔是否被創建;
        // setInterval_id = setInterval(function () { Monitor_Array(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, temp_NodeJS_cache_IO_data_dir) }, delay);  // 循環延時監聽;

        // 監聽指定的硬盤用於傳數據的媒介文檔，當出現監聽的目標文檔時，激活處理函數;
        function func_Monitor_file(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, temp_NodeJS_cache_IO_data_dir) {

            let result = null;  // 從硬盤讀取數據，並處理完畢之後的反饋結果;

            // 監聽待處理任務隊列數組 input_queues_array 和 空閑子綫程隊列 worker_free，當有待處理任務等待時，且有空閑子進程時，將待任務隊列中排在前面的第一個待處理任務，推入一個空閑子進程;
            if (input_queues_array.length > 0) {
                let worker_active_ID = "";
                if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                    if (Object.keys(worker_queues).length > 0) {
                        // Object.keys(worker_queues).forEach((key) => {
                        //     if (worker_free[key]) {
                        //         worker_active_ID = key;
                        //         break;
                        //     };
                        // });
                        for (let key in worker_free) {
                            if (worker_free[key]) {
                                worker_active_ID = key;
                                break;
                            };
                        };
                    };

                    // // 判斷如果子綫程序列爲空則重新創建子綫程並推入序列;
                    // if (Object.keys(worker_queues).length === 0) {
                    //     if (typeof (number_Worker_threads) !== undefined && number_Worker_threads !== undefined && !isNaN(Number(number_Worker_threads)) && parseInt(number_Worker_threads) > 0) {
                    //         // number_Worker_threads = parseInt(number_Worker_threads);
                    //         let Workers = create_worker_thread(number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value);
                    //         worker_queues = Workers[0];
                    //         worker_free = Workers[1];
                    //         Message_Channel_queues = Workers[2];
                    //     };
                    //     if (Object.keys(worker_queues).length > 0) {
                    //         // Object.keys(worker_queues).forEach((key) => {
                    //         //     if (worker_free[key]) {
                    //         //         worker_active_ID = key;
                    //         //         break;
                    //         //     };
                    //         // });
                    //         for (let key in worker_free) {
                    //             if (worker_free[key]) {
                    //                 worker_active_ID = key;
                    //                 break;
                    //             };
                    //         };
                    //     };
                    // };
                };

                if (Object.keys(worker_queues).length > 0 && worker_active_ID !== "") {

                    worker_free[worker_active_ID] = false;  // 標記該副執行緒worker_active_ID的狀態，游空閑true轉爲忙false;

                    // 記錄每個綫程的纍加的被調用運算的總次數；
                    if (total_worker_called_number.hasOwnProperty(worker_active_ID)) {
                        total_worker_called_number[worker_active_ID] = parseInt(total_worker_called_number[worker_active_ID]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
                    } else {
                        total_worker_called_number[worker_active_ID] = 1;  // 第一次被調用賦值 1 ;
                    };

                    // worker_queues[worker_active_ID].once('message', (receive_message) => {});
                    worker_queues[worker_active_ID].once('message', (receive_message) => {

                        // console.log(typeof (receive_message));
                        // console.log(receive_message);

                        worker_free[worker_active_ID] = true;
                        worker_queues[worker_active_ID].removeAllListeners('message');  // this.removeAllListeners('message');
                        worker_queues[worker_active_ID].removeAllListeners('error');  // this.removeAllListeners('error');
                        // worker_queues[worker_active_ID].terminate();  // 銷毀子綫程;

                        let Message_status = "";
                        let Data_JSON = null;
                        if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                            Message_status = 'message_response';
                            Data_JSON = receive_message[0];
                        } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                            Message_status = receive_message[0];
                            Data_JSON = receive_message[1];
                        } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                            Message_status = receive_message[0];
                            let Data_Array = [];
                            for (let i = 1; i < receive_message.length; i++) {
                                Data_Array.push(receive_message[i]);
                            };
                        } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                            Message_status = 'message_response';
                            Data_JSON = receive_message;
                            // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'error' && receive_message !== 'error_response') {
                            //     Message_status = 'message_response';
                            //     Data_JSON = receive_message;
                        } else {
                            Message_status = receive_message;
                        };
                        // console.log(Message_status);
                        // console.log(Data_JSON);

                        switch (Message_status) {

                            case 'standby_response': {
                                console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                break;
                            }

                            case 'message_response': {

                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);

                                if (Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object string]') {
                                    console.log("read file do Function error: " + Data_JSON);
                                };

                                if (typeof (Data_JSON) === 'object' && Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object object]' && !(Data_JSON.length)) {
                                    // console.log(Data_JSON);
                                    result = Data_JSON["data"];
                                    // Data_JSON === {
                                    //     "threadId": String(require('worker_threads').threadId),
                                    //     "monitor_file": Data_JSON.monitor_file,
                                    //     "result": result[0],
                                    //     "output_file": result[1]
                                    // };

                                    output_queues_array.push(Data_JSON["output_file"]);
                                    // console.log(output_queues_array);

                                    // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 在已處理完數據後，是否已經從硬盤刪除;
                                    file_bool = false;
                                    try {
                                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                        file_bool = fs.existsSync(Data_JSON["monitor_file"]) && fs.statSync(Data_JSON["monitor_file"], { bigint: false }).isFile();
                                        // console.log("文檔: " + Data_JSON["monitor_file"] + " 存在.");
                                    } catch (error) {
                                        console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 是否存在.");
                                        console.error(error);
                                        return Data_JSON["monitor_file"];
                                    };
                                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                    if (file_bool) {

                                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                                        try {
                                            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                                            fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                                            // console.log("文檔: " + Data_JSON["monitor_file"] + " 可以讀寫.");
                                        } catch (error) {
                                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                                            try {
                                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                                fs.fchmodSync(Data_JSON["monitor_file"], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                                // console.log("文檔: " + Data_JSON["monitor_file"] + " 操作權限修改為可以讀寫.");
                                                // 常量                    八進制值    說明
                                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                                // fs.constants.S_IRGRP    0o40       群組可讀
                                                // fs.constants.S_IWGRP    0o20       群組可寫
                                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                                // fs.constants.S_IROTH    0o4        其他人可讀
                                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                                // 數字	說明
                                                // 7	可讀、可寫、可執行
                                                // 6	可讀、可寫
                                                // 5	可讀、可執行
                                                // 4	唯讀
                                                // 3	可寫、可執行
                                                // 2	只寫
                                                // 1	只可執行
                                                // 0	沒有許可權
                                                // 例如，八進制值 0o765 表示：
                                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                                // 2) 、群組可以讀和寫入該文檔；
                                                // 3) 、其他人可以讀取和執行該文檔；
                                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                                            } catch (error) {
                                                console.error("用於傳入數據的臨時暫存媒介文檔 [ " + Data_JSON["monitor_file"] + " ] 無法修改為可讀可寫權限.");
                                                console.error(error);
                                                return Data_JSON["monitor_file"];
                                            };
                                        };

                                        // 同步刪除，用於臨時接收傳值的媒介文檔;
                                        try {
                                            fs.unlinkSync(Data_JSON["monitor_file"]);  // 同步刪除，返回值為 undefined;
                                            // console.error("用於臨時接收數據的媒介文檔: " + Data_JSON["monitor_file"] + " 已被刪除.");
                                            // console.log(fs.readdirSync(Data_JSON["monitor_file"], { encoding: "utf8", withFileTypes: false }));
                                        } catch (error) {
                                            console.error("用於臨時接收數據的媒介文檔: " + Data_JSON["monitor_file"] + " 無法刪除.");
                                            console.error(error);
                                            return Data_JSON["monitor_file"];
                                        };

                                        // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 是否已經從硬盤刪除;
                                        file_bool = false;
                                        try {
                                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                            file_bool = fs.existsSync(Data_JSON["monitor_file"]) && fs.statSync(Data_JSON["monitor_file"], { bigint: false }).isFile();
                                            // console.log("文檔: " + Data_JSON["monitor_file"] + " 存在.");
                                        } catch (error) {
                                            console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 是否存在.");
                                            console.error(error);
                                            return Data_JSON["monitor_file"];
                                        };
                                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                        if (file_bool) {
                                            console.error("用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 無法刪除.");
                                            return Data_JSON["monitor_file"];
                                        };
                                    };
                                };
                                break;
                            }

                            case 'SIGINT_response': {

                                // console.log(Data_JSON["threadId"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                                // console.log('副執行緒 thread-' + Data_JSON["threadId"] + " 響應主執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "SIGINT" 信號中止運行; Master thread-' + require("worker_threads").threadId + ' post "SIGINT" message exit Worker thread-' + Data_JSON["threadId"] + '.');

                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                                // if (worker_queues.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_queues[Data_JSON["threadId"]];
                                // };
                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                                // if (worker_free.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_free[Data_JSON["threadId"]];
                                // };

                                // worker_queues[Data_JSON["threadId"]].terminate();  // 銷毀子綫程;
                                break;
                            }

                            case 'exit_response': {

                                // console.log(Data_JSON["threadId"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                                // console.log('副執行緒 thread-' + Data_JSON["threadId"] + " 響應主執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "exit" 信號中止運行; Master thread-' + require("worker_threads").threadId + ' post "SIGINT" message exit Worker thread-' + Data_JSON["threadId"] + '.');

                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                                // if (worker_queues.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_queues[Data_JSON["threadId"]];
                                // };
                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                                // if (worker_free.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_free[Data_JSON["threadId"]];
                                // };

                                // worker_queues[Data_JSON["threadId"]].terminate();  // 銷毀子綫程;
                                break;
                            }

                            case 'error_response': {
                                console.log(receive_message);
                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                break;
                            }
                            case 'error': {
                                console.log(receive_message);
                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                break;
                            }
                            default: {
                                console.log(receive_message);
                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            }
                        };
                    });

                    // console.log(worker_queues[worker_active_ID]);
                    // console.log(input_queues_array[0]);

                    input_queues_array[0]["threadId"] = require('worker_threads').threadId;
                    worker_queues[worker_active_ID].postMessage(['message', input_queues_array[0]], []);  // .postMessage(worker_Data, [Message_Channel.port2];

                    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
                    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
                    // console.log(now_date);
                    let log_text = String(now_date) + " thread-" + String(worker_active_ID) + " < " + input_queues_array[0].monitor_file + " > < " + output_file + " >.";
                    console.log(log_text);
                    // fs.appendFile(path, data[, options], callback);
                    // fs.appendFileSync(path, data[, options]);

                    input_queues_array = input_queues_array.slice(1, input_queues_array.length);  // 刪除第一個元素;

                    // worker_thread.postMessage(['standby', { "threadId": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling Stand by.", "delay": 5000 }], []);
                    // worker_thread.postMessage(['SIGINT', { "threadId": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling Unstand by."}], []);
                    // worker_thread.postMessage(['exit', { "threadId": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling exit."}], []);
                    // worker_thread.postMessage(['message', worker_Data], []);
                };

                if (Object.keys(worker_queues).length === 0 || worker_active_ID === "") {

                    // 記錄每個綫程纍加的被調用運算的總次數;
                    // if (!worker_queues.hasOwnProperty(require('worker_threads').threadId)) {
                    //     worker_queues[require('worker_threads').threadId] = require('worker_threads').Worker;  // 記錄主綫程對象;
                    // };
                    if (total_worker_called_number.hasOwnProperty(require('worker_threads').threadId)) {
                        total_worker_called_number[require('worker_threads').threadId] = parseInt(total_worker_called_number[require('worker_threads').threadId]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
                    } else {
                        total_worker_called_number[require('worker_threads').threadId] = 1;  // 第一次被調用賦值 1 ;
                    };

                    result = read_file_do_Function(input_queues_array[0].monitor_file, input_queues_array[0].monitor_dir, do_Function, input_queues_array[0].output_dir, input_queues_array[0].output_file, input_queues_array[0].to_executable, input_queues_array[0].to_script);

                    if (Object.prototype.toString.call(result).toLowerCase() === '[object array]') {
                        output_queues_array.push(result[1]);
                        // console.log(output_queues_array);
                    };
                    if (Object.prototype.toString.call(result).toLowerCase() === '[object string]' && result.split(":")[0] === "error") {
                        console.log("return Error: " + result.split(":")[1]);  // error;
                    };

                    // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 在已處理完數據後，是否已經從硬盤刪除;
                    file_bool = false;
                    try {
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = fs.existsSync(input_queues_array[0]["monitor_file"]) && fs.statSync(input_queues_array[0]["monitor_file"], { bigint: false }).isFile();
                        // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 存在.");
                    } catch (error) {
                        console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + input_queues_array[0]["monitor_file"] + " 是否存在.");
                        console.error(error);
                        return input_queues_array[0]["monitor_file"];
                    };
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                    if (file_bool) {

                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(input_queues_array[0]["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        try {
                            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(input_queues_array[0]["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            fs.accessSync(input_queues_array[0]["monitor_file"], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 可以讀寫.");
                        } catch (error) {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                            try {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                fs.fchmodSync(input_queues_array[0]["monitor_file"], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 操作權限修改為可以讀寫.");
                                // 常量                    八進制值    說明
                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                // fs.constants.S_IRGRP    0o40       群組可讀
                                // fs.constants.S_IWGRP    0o20       群組可寫
                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                // fs.constants.S_IROTH    0o4        其他人可讀
                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                // 數字	說明
                                // 7	可讀、可寫、可執行
                                // 6	可讀、可寫
                                // 5	可讀、可執行
                                // 4	唯讀
                                // 3	可寫、可執行
                                // 2	只寫
                                // 1	只可執行
                                // 0	沒有許可權
                                // 例如，八進制值 0o765 表示：
                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                // 2) 、群組可以讀和寫入該文檔；
                                // 3) 、其他人可以讀取和執行該文檔；
                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                            } catch (error) {
                                console.error("用於傳入數據的臨時暫存媒介文檔 [ " + input_queues_array[0]["monitor_file"] + " ] 無法修改為可讀可寫權限.");
                                console.error(error);
                                return input_queues_array[0]["monitor_file"];
                            };
                        };

                        // 同步刪除，用於臨時接收傳值的媒介文檔;
                        try {
                            fs.unlinkSync(input_queues_array[0]["monitor_file"]);  // 同步刪除，返回值為 undefined;
                            // console.error("用於臨時接收數據的媒介文檔: " + input_queues_array[0]["monitor_file"] + " 已被刪除.");
                            // console.log(fs.readdirSync(input_queues_array[0]["monitor_file"], { encoding: "utf8", withFileTypes: false }));
                        } catch (error) {
                            console.error("用於臨時接收數據的媒介文檔: " + input_queues_array[0]["monitor_file"] + " 無法刪除.");
                            console.error(error);
                            return input_queues_array[0]["monitor_file"];
                        };

                        // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 是否已經從硬盤刪除;
                        file_bool = false;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(input_queues_array[0]["monitor_file"]) && fs.statSync(input_queues_array[0]["monitor_file"], { bigint: false }).isFile();
                            // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + input_queues_array[0]["monitor_file"] + " 是否存在.");
                            console.error(error);
                            return input_queues_array[0]["monitor_file"];
                        };
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                        if (file_bool) {
                            console.error("用於傳入數據的臨時媒介文檔序列第一位: " + input_queues_array[0]["monitor_file"] + " 無法刪除.");
                            return input_queues_array[0]["monitor_file"];
                        };
                    };

                    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
                    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
                    // console.log(now_date);
                    let log_text = String(now_date) + " thread-" + String(require('worker_threads').threadId) + " < " + input_queues_array[0].monitor_file + " > < " + output_file + " >.";
                    console.log(log_text);
                    // fs.appendFile(path, data[, options], callback);
                    // fs.appendFileSync(path, data[, options]);

                    input_queues_array = input_queues_array.slice(1, input_queues_array.length);  // 刪除第一個元素;
                };
            };

            // 監聽待傳出數據結果隊列數組 output_queues_array，當有用於傳出數據的媒介目錄 output_dir 中不在含有 output_file 時，將待傳出數據結果隊列數組 output_queues_array 中排在前面的第一個結果文檔，更名移人用於傳出數據的媒介目錄 output_dir 中;
            if (output_queues_array.length > 0) {
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷判斷用於輸出傳值的媒介文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
                file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
                    // console.log("文檔: " + output_file + " 存在.");
                } catch (error) {
                    console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
                    console.error(error);
                    return output_file;
                };
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷用於輸出的媒介文檔是否存在以及是否為文檔;
                if (!file_bool) {

                    // 判斷用於傳出數據的臨時媒介文檔序列第一位 output_queues_array[0] 是否已經從硬盤刪除;
                    file_bool = false;
                    try {
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = fs.existsSync(output_queues_array[0]) && fs.statSync(output_queues_array[0], { bigint: false }).isFile();
                        // console.log("文檔: " + output_queues_array[0] + " 存在.");
                    } catch (error) {
                        console.error("無法確定用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 是否存在.");
                        console.error(error);
                        return output_queues_array[0];
                    };
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    if (!file_bool) {

                        output_queues_array = output_queues_array.slice(1, output_queues_array.length);  // 刪除第一個元素;

                    } else {

                        // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            fs.accessSync(output_queues_array[0], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("文檔: " + output_queues_array[0] + " 可以讀寫.");
                        } catch (error) {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                            try {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                fs.fchmodSync(output_queues_array[0], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                // console.log("文檔: " + output_queues_array[0] + " 操作權限修改為可以讀寫.");
                                // 常量                    八進制值    說明
                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                // fs.constants.S_IRGRP    0o40       群組可讀
                                // fs.constants.S_IWGRP    0o20       群組可寫
                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                // fs.constants.S_IROTH    0o4        其他人可讀
                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                // 數字	說明
                                // 7	可讀、可寫、可執行
                                // 6	可讀、可寫
                                // 5	可讀、可執行
                                // 4	唯讀
                                // 3	可寫、可執行
                                // 2	只寫
                                // 1	只可執行
                                // 0	沒有許可權
                                // 例如，八進制值 0o765 表示：
                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                // 2) 、群組可以讀和寫入該文檔；
                                // 3) 、其他人可以讀取和執行該文檔；
                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                            } catch (error) {
                                console.error("用於傳出數據的臨時暫存媒介文檔 [ " + output_queues_array[0] + " ] 無法修改為可讀可寫權限.");
                                console.error(error);
                                return output_queues_array[0];
                            };
                        };

                        // 同步移動文檔，將用於傳出數據的臨時媒介文檔序列第一位 output_queues_array[0] 從臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir 移動到媒介文件夾 output_dir，並更名為 output_file;
                        try {
                            // // let buff = new Buffer.alloc(16384);  // buff.toString('utf8', 0, buff.length);
                            // let fd = 1;
                            // // fs.copyFileSync(output_queues_array[0], output_file, 0);
                            // // fs.writeFileSync(output_file, fs.readFileSync(output_queues_array[0], { encoding: null, flag: "r" }), { encoding: 'utf8', mode: 0o666, flag: "w" });
                            // fd = fs.openSync(output_queues_array[0], "r", 0o666);
                            // let data = fs.readFileSync(output_queues_array[0], { encoding: null, flag: "r" });
                            // // fs.readSync(fd, buff, { offset: 0, length: buff.length, position: null });
                            // fs.closeSync(fd);
                            // fd = fs.openSync(output_file, "w", 0o666);
                            // fs.writeFileSync(output_file, data, { encoding: 'utf8', mode: 0o666, flag: "w" });
                            // // fs.writeSync(fd, buff, 0, buff.length, null);
                            // // fs.writeSync(fd, str, null, 'utf8');  // buff.toString('utf8', 0, buff.length);
                            // fs.closeSync(fd);
                            // fs.unlinkSync(output_queues_array[0]);  // 同步刪除，返回值為 undefined;

                            fs.renameSync(output_queues_array[0], output_file);  // 重命名或移動文檔，返回值為 undefined;
                            // // require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"];
                            // // require('path').parse(output_file)["base"] === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"];
                            // // console.log(temp_output_file);
                            // // console.log(require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]));
                        } catch (error) {
                            if (error.code !== 'EBUSY') {
                                console.error("用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 無法移動更名為用於傳出數據的媒介文檔: " + output_file);
                                console.error(error);
                            };
                            return output_queues_array[0];
                        };

                        // 判斷用於傳出數據的臨時媒介文檔序列第一位 output_queues_array[0] 是否已經從硬盤刪除;
                        file_bool = false;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_queues_array[0])方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(output_queues_array[0]) && fs.statSync(output_queues_array[0], { bigint: false }).isFile();
                            // console.log("文檔: " + output_queues_array[0] + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 是否存在.");
                            console.error(error);
                            return output_queues_array[0];
                        };
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_queues_array[0])方法判斷目錄或文檔是否存在以及是否為文檔;
                        if (file_bool) {
                            console.error("用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 無法刪除.");
                            return output_queues_array[0];
                        };

                        // 判斷用於傳出數據的臨時暫存媒介文檔 output_queues_array[0]，是否已經從暫存目錄 temp_NodeJS_cache_IO_data_dir 移動到媒介目錄 output_dir，並已經更名為 output_file;
                        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
                            // console.log("文檔: " + output_file + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
                            console.error(error);
                            return output_file;
                        };
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        if (!file_bool) {
                            console.error("用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 無法移動更名為用於傳出數據的媒介文檔: " + output_file);
                            return output_queues_array[0];
                        };

                        output_queues_array = output_queues_array.slice(1, output_queues_array.length);  // 刪除第一個元素;

                        // 同步判斷，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("文檔: " + output_file + " 可以讀寫.");
                        } catch (error) {
                            // 同步判斷，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                            try {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                fs.fchmodSync(output_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                // console.log("文檔: " + output_file + " 操作權限修改為可以讀寫.");
                                // 常量                    八進制值    說明
                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                // fs.constants.S_IRGRP    0o40       群組可讀
                                // fs.constants.S_IWGRP    0o20       群組可寫
                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                // fs.constants.S_IROTH    0o4        其他人可讀
                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                // 數字	說明
                                // 7	可讀、可寫、可執行
                                // 6	可讀、可寫
                                // 5	可讀、可執行
                                // 4	唯讀
                                // 3	可寫、可執行
                                // 2	只寫
                                // 1	只可執行
                                // 0	沒有許可權
                                // 例如，八進制值 0o765 表示：
                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                // 2) 、群組可以讀和寫入該文檔；
                                // 3) 、其他人可以讀取和執行該文檔；
                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                            } catch (error) {
                                console.error("用於傳出數據的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.");
                                console.error(error);
                                return output_file;
                            };
                        };

                        // 使用 child_process.exec 調用 shell 語句反饋;
                        // 運算處理完之後，給調用語言的回復，fs.accessSync(to_executable, fs.constants.X_OK) 判斷脚本文檔是否具有被執行權限;
                        file_bool = false;
                        try {
                            // 同步判斷，反饋目標解釋器可執行檔 to_executable 是否可執行;
                            file_bool = Object.prototype.toString.call(to_executable).toLowerCase() === '[object string]' && to_executable !== "" && fs.existsSync(to_executable) && fs.statSync(to_executable, { bigint: false }).isFile() && fs.accessSync(to_executable, fs.constants.X_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("解釋器可執行檔: " + to_executable + " 可以運行.");
                        } catch (error) {
                            console.error("無法確定反饋目標解釋器可執行檔: " + to_executable + " 是否具有可執行權限.");
                            console.error(error);
                            return to_executable;
                        };
                        if (file_bool) {
                            file_bool = false;
                            try {
                                // 同步判斷，反饋目標解釋器運行脚本 to_script 是否可執行;
                                file_bool = Object.prototype.toString.call(to_script).toLowerCase() === '[object string]' && to_script !== "" && fs.existsSync(to_script) && fs.statSync(to_script, { bigint: false }).isFile() && fs.accessSync(to_script, fs.constants.R_OK | fs.constants.W_OK) && fs.accessSync(to_script, fs.constants.X_OK);  // 0o777，可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                                // console.log("脚本文檔: " + to_script + " 可以被執行.");
                            } catch (error) {
                                console.error("無法確定反饋目標解釋器運行脚本文檔: " + to_script + " 是否可執行.");
                                console.error(error);
                                return to_script;
                            };
                            let shell_run_to_executable = "";
                            if (file_bool) {
                                shell_run_to_executable = to_executable.concat(" ", to_script, " ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
                            } else {
                                shell_run_to_executable = to_executable.concat(" ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
                            };
                            // let result = require('child_process').execSync(shell_run_to_executable);
                            // // console.log(result);
                            require('child_process').exec(shell_run_to_executable, function (error, stdout, stderr) {
                                // if (error) {
                                //     console.error("EXEC Error: " + error);
                                //     // return;
                                // };
                                // if (stderr) {
                                //     console.log("stderr: " + stderr);
                                // };
                                // if (stdout) {
                                //     // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
                                //     console.log(typeof (stdout));
                                //     console.log(stdout);
                                //     if (isStringJSON(stdout)) {
                                //         console.log(JSON.parse(stdout));
                                //     };
                                // };
                            });
                        };
                    };
                };
            };

            // 監聽指定的硬盤用於傳數據的媒介文檔，當出現監聽的目標文檔時，激活處理函數;
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
            try {
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
                // console.log("文檔: " + monitor_file + " 存在.");
            } catch (error) {
                console.error("無法確定用於傳入數據的媒介文檔: " + monitor_file + " 是否存在.");
                console.error(error);
                return monitor_file;
            };
            // 同步判斷，當用於傳入數據的媒介文檔存在時，激活處理函數;，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            if (file_bool) {

                input_file_NUM = parseInt(input_file_NUM) + parseInt(1);

                // 同步判斷文檔權限，後面所有代碼都是，當用於傳入數據的媒介文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + monitor_file + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(monitor_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + monitor_file + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.error("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        return monitor_file;
                    };
                };

                // 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                let index_NUM = "_".concat(input_file_NUM.toString());  // 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                // if (input_queues_array.length > 0) {
                //     index_NUM = "_" + String(parseInt(require('path').parse(input_queues_array[parseInt(parseInt(input_queues_array.length) - parseInt(1))])["name"].split("_")[1]) + parseInt(1));
                // } else {
                //     index_NUM = "_0";
                // };
                let temp_monitor_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(monitor_file)["name"] + index_NUM + require('path').parse(monitor_file)["ext"]);  // 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                // console.log(temp_monitor_file);
                let temp_output_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]);  // 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                // console.log(temp_output_file);
                // console.log(require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"]);

                // 判斷用於接收或輸出傳值的臨時媒介文檔是否有重名的;
                file_bool = false;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = (fs.existsSync(temp_monitor_file) && fs.statSync(temp_monitor_file, { bigint: false }).isFile()) || (fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile());
                    // console.log("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.");
                } catch (error) {
                    console.error("無法確定用於傳入數據的臨時媒介文檔: " + temp_monitor_file + " 或用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                    console.error(error);
                    return [temp_monitor_file, temp_output_file];
                };
                while (file_bool) {
                    console.log("用於傳入數據的臨時媒介文檔: " + temp_monitor_file + " 或用於傳出數據的臨時媒介文檔: " + temp_output_file + " 已經存在.");
                    input_file_NUM = parseInt(Number(input_file_NUM) + parseInt(1));  // 監聽到的第幾次傳入媒介文檔增加一個;
                    // 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                    index_NUM = "_".concat(input_file_NUM.toString());  // 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                    // if (input_queues_array.length > 0) {
                    //     index_NUM = "_" + String(parseInt(require('path').parse(input_queues_array[parseInt(parseInt(input_queues_array.length) - parseInt(1))])["name"].split("_")[1]) + parseInt(1));
                    // } else {
                    //     index_NUM = "_0";
                    // };
                    temp_monitor_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(monitor_file)["name"] + index_NUM + require('path').parse(monitor_file)["ext"]);  // 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                    // console.log(temp_monitor_file);
                    temp_output_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]);  // 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                    // console.log(temp_output_file);
                    // console.log(require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"]);

                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = false;
                    try {
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = (fs.existsSync(temp_monitor_file) && fs.statSync(temp_monitor_file, { bigint: false }).isFile()) || (fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile());
                        // console.log("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.");
                    } catch (error) {
                        console.error("無法確定用於傳入數據的臨時媒介文檔: " + temp_monitor_file + " 或用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                        console.error(error);
                        return [temp_monitor_file, temp_output_file];
                    };
                };

                // // 判斷用於輸出傳值的臨時媒介文檔是否有重名的;
                // // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                // file_bool = false;
                // try {
                //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                //     file_bool = fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile();
                //     // console.log("文檔: " + temp_output_file + " 存在.");
                // } catch (error) {
                //     console.error("無法確定用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                //     console.error(error);
                //     return temp_output_file;
                // };
                // while (file_bool) {
                //     console.log("用於傳出數據的臨時媒介文檔: " + temp_output_file + " 已經存在.");
                //     input_file_NUM = parseInt(Number(input_file_NUM) + parseInt(1));  // 監聽到的第幾次傳入媒介文檔增加一個;
                //     // 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                //     index_NUM = "_".concat(input_file_NUM.toString());  // 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                //     // if (input_queues_array.length > 0) {
                //     //     index_NUM = "_" + String(parseInt(require('path').parse(input_queues_array[parseInt(parseInt(input_queues_array.length) - parseInt(1))])["name"].split("_")[1]) + parseInt(1));
                //     // } else {
                //     //     index_NUM = "_0";
                //     // };
                //     temp_monitor_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(monitor_file)["name"] + index_NUM + require('path').parse(monitor_file)["ext"]);  // 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                //     // console.log(temp_monitor_file);
                //     temp_output_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]);  // 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                //     // console.log(temp_output_file);
                //     // console.log(require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"]);

                //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                //     file_bool = false;
                //     try {
                //         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                //         file_bool = fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile();
                //         // console.log("文檔: " + temp_output_file + " 存在.");
                //     } catch (error) {
                //         console.error("無法確定用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                //         console.error(error);
                //         return temp_output_file;
                //     };
                // };

                try {
                    // // let buff = new Buffer.alloc(16384);  // buff.toString('utf8', 0, buff.length);
                    // let fd = 1;
                    // // fs.copyFileSync(monitor_file, temp_monitor_file, 0);
                    // // fs.writeFileSync(temp_monitor_file, fs.readFileSync(monitor_file, { encoding: null, flag: "r" }), { encoding: 'utf8', mode: 0o666, flag: "w" });
                    // fd = fs.openSync(monitor_file, "r", 0o666);
                    // let data = fs.readFileSync(monitor_file, { encoding: null, flag: "r" });
                    // // fs.readSync(fd, buff, { offset: 0, length: buff.length, position: null });
                    // fs.closeSync(fd);
                    // fd = fs.openSync(temp_monitor_file, "w", 0o666);
                    // fs.writeFileSync(temp_monitor_file, data, { encoding: 'utf8', mode: 0o666, flag: "w" });
                    // // fs.writeSync(fd, buff, 0, buff.length, null);
                    // // fs.writeSync(fd, str, null, 'utf8');  // buff.toString('utf8', 0, buff.length);
                    // fs.closeSync(fd);
                    // fs.unlinkSync(monitor_file);  // 同步刪除，返回值為 undefined;

                    fs.renameSync(monitor_file, temp_monitor_file);  // 重命名或移動文檔，返回值為 undefined;
                    // require('path').basename(monitor_file) === require('path').parse(monitor_file)["name"] + require('path').parse(monitor_file)["ext"];
                    // require('path').parse(monitor_file)["base"] === require('path').parse(monitor_file)["name"] + require('path').parse(monitor_file)["ext"];
                    // console.log(monitor_file);
                    // console.log(temp_monitor_file);
                } catch (error) {
                    if (error.code !== 'EBUSY') {
                        console.error("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file);
                        console.error(error);
                    };
                    return monitor_file;
                };

                // 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                file_bool = false;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
                    // console.log("文檔: " + monitor_file + " 存在.");
                } catch (error) {
                    console.error("無法確定用於傳入數據的媒介文檔: " + monitor_file + " 是否存在.");
                    console.error(error);
                    return monitor_file;
                };
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                if (file_bool) {
                    console.error("用於傳入數據的媒介文檔: " + monitor_file + " 無法被刪除.");
                    return monitor_file;
                };

                // 判斷用於接收傳值的媒介文檔，是否已經從媒介目錄移動到暫存目錄，並已經更名為 <原名> + "_<序號>" + <原擴展名> 硬盤刪除;
                file_bool = false;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = fs.existsSync(temp_monitor_file) && fs.statSync(temp_monitor_file, { bigint: false }).isFile();
                    // console.log("文檔: " + temp_monitor_file + " 存在.");
                } catch (error) {
                    console.error("無法確定用於傳入數據的暫存媒介文檔: " + temp_monitor_file + " 是否存在.");
                    console.error(error);
                    return temp_monitor_file;
                };
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                if (!file_bool) {
                    console.error("無法將用於傳入數據的媒介文檔: " + monitor_file + " 移動更名為暫存文檔: " + temp_monitor_file);
                    return temp_monitor_file;
                };

                // 同步判斷判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(temp_monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    file_bool = fs.accessSync(temp_monitor_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + temp_monitor_file + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(temp_monitor_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + temp_monitor_file + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.error("用於接收傳入數據的暫存媒介文檔 [ " + temp_monitor_file + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        return temp_monitor_file;
                    };
                };

                let worker_Data = {
                    // "read_file_do_Function": read_file_do_Function.toString(),
                    "monitor_file": temp_monitor_file,  // monitor_file;
                    "monitor_dir": temp_NodeJS_cache_IO_data_dir,  // monitor_dir;
                    // "do_Function": do_Function.toString(),  // do_Function_obj["do_Function"];
                    "output_dir": temp_NodeJS_cache_IO_data_dir,  // output_dir;
                    "output_file": temp_output_file,  // output_file，output_queues_array;
                    "to_executable": to_executable,
                    "to_script": to_script
                };
                // if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]' && Object.prototype.toString.call(eval('"' + do_Function + '"')).toLowerCase() === '[object function]') {
                //     worker_Data["do_Function"] = eval(do_Function).toString();  // do_Function_obj["do_Function"];
                // } else if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object function]') {
                //     worker_Data["do_Function"] = do_Function.toString();  // do_Function_obj["do_Function"]; new Buffer(do_Function_obj["do_Function"]);  // .from(do_Function_obj["do_Function"]);
                // } else {
                //     worker_Data["do_Function"] = null;
                // };

                input_queues_array.push(worker_Data);

                // result = read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script);
                // continue;
            };

            // console.log("當前進程編號: process-" + process.pid + " thread-" + require('worker_threads').threadId)
            return [result, output_queues_array, input_queues_array];
        };

        // 監聽指定的硬盤用於傳數據的媒介目錄，當目錄中出現監聽的目標文檔時，激活處理函數;
        // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
        let initial_dir_list_array = new Array;  // 用於保存目錄中監聽起始時，所包含内容名稱字符串的數組;
        let changed_dir_list_array = new Array;  // 用於保存目錄中監聽被改變後，所包含内容名稱字符串的數組;
        try {
            // 同步讀取監聽目錄起始時所包含的内容條目;
            initial_dir_list_array = fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });  // 同步讀取，返回值 Array;
            // console.log(fs.readdirSync("D:\\", { encoding: "utf8", withFileTypes: false }));
        } catch (error) {
            console.error("無法讀取用於輸入數據的媒介文件夾: " + monitor_dir + " 中的内容條目.");
            console.error(error);
            return monitor_dir;
        };
        function func_Monitor_dir(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, temp_NodeJS_cache_IO_data_dir) {

            let result = null;  // 從硬盤讀取數據，並處理完畢之後的反饋結果;

            // 監聽待處理任務隊列數組 input_queues_array 和 空閑子綫程隊列 worker_free，當有待處理任務等待時，且有空閑子進程時，將待任務隊列中排在前面的第一個待處理任務，推入一個空閑子進程;
            if (input_queues_array.length > 0) {
                let worker_active_ID = "";
                if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                    if (Object.keys(worker_queues).length > 0) {
                        // Object.keys(worker_queues).forEach((key) => {
                        //     if (worker_free[key]) {
                        //         worker_active_ID = key;
                        //         break;
                        //     };
                        // });
                        for (let key in worker_free) {
                            if (worker_free[key]) {
                                worker_active_ID = key;
                                break;
                            };
                        };
                    };

                    // // 判斷如果子綫程序列爲空則重新創建子綫程並推入序列;
                    // if (Object.keys(worker_queues).length === 0) {
                    //     if (typeof (number_Worker_threads) !== undefined && number_Worker_threads !== undefined && !isNaN(Number(number_Worker_threads)) && parseInt(number_Worker_threads) > 0) {
                    //         // number_Worker_threads = parseInt(number_Worker_threads);
                    //         let Workers = create_worker_thread(number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value);
                    //         worker_queues = Workers[0];
                    //         worker_free = Workers[1];
                    //         Message_Channel_queues = Workers[2];
                    //     };
                    //     if (Object.keys(worker_queues).length > 0) {
                    //         // Object.keys(worker_queues).forEach((key) => {
                    //         //     if (worker_free[key]) {
                    //         //         worker_active_ID = key;
                    //         //         break;
                    //         //     };
                    //         // });
                    //         for (let key in worker_free) {
                    //             if (worker_free[key]) {
                    //                 worker_active_ID = key;
                    //                 break;
                    //             };
                    //         };
                    //     };
                    // };

                };

                if (Object.keys(worker_queues).length > 0 && worker_active_ID !== "") {

                    worker_free[worker_active_ID] = false;  // 標記該副執行緒worker_active_ID的狀態，游空閑true轉爲忙false;

                    // 記錄每個綫程的纍加的被調用運算的總次數；
                    if (total_worker_called_number.hasOwnProperty(worker_active_ID)) {
                        total_worker_called_number[worker_active_ID] = parseInt(total_worker_called_number[worker_active_ID]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
                    } else {
                        total_worker_called_number[worker_active_ID] = 1;  // 第一次被調用賦值 1 ;
                    };

                    // worker_queues[worker_active_ID].once('message', (receive_message) => {});
                    worker_queues[worker_active_ID].once('message', (receive_message) => {

                        // console.log(typeof (receive_message));
                        // console.log(receive_message);

                        worker_free[worker_active_ID] = true;
                        worker_queues[worker_active_ID].removeAllListeners('message');  // this.removeAllListeners('message');
                        worker_queues[worker_active_ID].removeAllListeners('error');  // this.removeAllListeners('error');
                        // worker_queues[worker_active_ID].terminate();  // 銷毀子綫程;

                        let Message_status = "";
                        let Data_JSON = null;
                        if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                            Message_status = 'message_response';
                            Data_JSON = receive_message[0];
                        } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                            Message_status = receive_message[0];
                            Data_JSON = receive_message[1];
                        } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                            Message_status = receive_message[0];
                            let Data_Array = [];
                            for (let i = 1; i < receive_message.length; i++) {
                                Data_Array.push(receive_message[i]);
                            };
                        } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                            Message_status = 'message_response';
                            Data_JSON = receive_message;
                            // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'error' && receive_message !== 'error_response') {
                            //     Message_status = 'message_response';
                            //     Data_JSON = receive_message;
                        } else {
                            Message_status = receive_message;
                        };
                        // console.log(Message_status);
                        // console.log(Data_JSON);

                        switch (Message_status) {

                            case 'standby_response': {
                                console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                break;
                            }

                            case 'message_response': {

                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);

                                if (Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object string]') {
                                    console.log("read file do Function error: " + Data_JSON);
                                };

                                if (typeof (Data_JSON) === 'object' && Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object object]' && !(Data_JSON.length)) {
                                    // console.log(Data_JSON);
                                    result = Data_JSON["data"];
                                    // Data_JSON === {
                                    //     "threadId": String(require('worker_threads').threadId),
                                    //     "monitor_file": Data_JSON.monitor_file,
                                    //     "result": result[0],
                                    //     "output_file": result[1]
                                    // };

                                    output_queues_array.push(Data_JSON["output_file"]);
                                    // console.log(output_queues_array);

                                    // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 在已處理完數據後，是否已經從硬盤刪除;
                                    file_bool = false;
                                    try {
                                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                        file_bool = fs.existsSync(Data_JSON["monitor_file"]) && fs.statSync(Data_JSON["monitor_file"], { bigint: false }).isFile();
                                        // console.log("文檔: " + Data_JSON["monitor_file"] + " 存在.");
                                    } catch (error) {
                                        console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 是否存在.");
                                        console.error(error);
                                        return Data_JSON["monitor_file"];
                                    };
                                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                    if (file_bool) {

                                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                                        try {
                                            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                                            fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                                            // console.log("文檔: " + Data_JSON["monitor_file"] + " 可以讀寫.");
                                        } catch (error) {
                                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                                            try {
                                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                                fs.fchmodSync(Data_JSON["monitor_file"], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                                // console.log("文檔: " + Data_JSON["monitor_file"] + " 操作權限修改為可以讀寫.");
                                                // 常量                    八進制值    說明
                                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                                // fs.constants.S_IRGRP    0o40       群組可讀
                                                // fs.constants.S_IWGRP    0o20       群組可寫
                                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                                // fs.constants.S_IROTH    0o4        其他人可讀
                                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                                // 數字	說明
                                                // 7	可讀、可寫、可執行
                                                // 6	可讀、可寫
                                                // 5	可讀、可執行
                                                // 4	唯讀
                                                // 3	可寫、可執行
                                                // 2	只寫
                                                // 1	只可執行
                                                // 0	沒有許可權
                                                // 例如，八進制值 0o765 表示：
                                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                                // 2) 、群組可以讀和寫入該文檔；
                                                // 3) 、其他人可以讀取和執行該文檔；
                                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                                            } catch (error) {
                                                console.error("用於傳入數據的臨時暫存媒介文檔 [ " + Data_JSON["monitor_file"] + " ] 無法修改為可讀可寫權限.");
                                                console.error(error);
                                                return Data_JSON["monitor_file"];
                                            };
                                        };

                                        // 同步刪除，用於臨時接收傳值的媒介文檔;
                                        try {
                                            fs.unlinkSync(Data_JSON["monitor_file"]);  // 同步刪除，返回值為 undefined;
                                            // console.error("用於臨時接收數據的媒介文檔: " + Data_JSON["monitor_file"] + " 已被刪除.");
                                            // console.log(fs.readdirSync(Data_JSON["monitor_file"], { encoding: "utf8", withFileTypes: false }));
                                        } catch (error) {
                                            console.error("用於臨時接收數據的媒介文檔: " + Data_JSON["monitor_file"] + " 無法刪除.");
                                            console.error(error);
                                            return Data_JSON["monitor_file"];
                                        };

                                        // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 是否已經從硬盤刪除;
                                        file_bool = false;
                                        try {
                                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                            file_bool = fs.existsSync(Data_JSON["monitor_file"]) && fs.statSync(Data_JSON["monitor_file"], { bigint: false }).isFile();
                                            // console.log("文檔: " + Data_JSON["monitor_file"] + " 存在.");
                                        } catch (error) {
                                            console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 是否存在.");
                                            console.error(error);
                                            return Data_JSON["monitor_file"];
                                        };
                                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                                        if (file_bool) {
                                            console.error("用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 無法刪除.");
                                            return Data_JSON["monitor_file"];
                                        };
                                    };
                                };
                                break;
                            }

                            case 'SIGINT_response': {

                                // console.log(Data_JSON["threadId"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                                // console.log('副執行緒 thread-' + Data_JSON["threadId"] + " 響應主執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "SIGINT" 信號中止運行; Master thread-' + require("worker_threads").threadId + ' post "SIGINT" message exit Worker thread-' + Data_JSON["threadId"] + '.');

                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                                // if (worker_queues.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_queues[Data_JSON["threadId"]];
                                // };
                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                                // if (worker_free.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_free[Data_JSON["threadId"]];
                                // };

                                // worker_queues[Data_JSON["threadId"]].terminate();  // 銷毀子綫程;
                                break;
                            }

                            case 'exit_response': {

                                // console.log(Data_JSON["threadId"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                console.log("Worker thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                                // console.log('副執行緒 thread-' + Data_JSON["threadId"] + " 響應主執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "exit" 信號中止運行; Master thread-' + require("worker_threads").threadId + ' post "SIGINT" message exit Worker thread-' + Data_JSON["threadId"] + '.');

                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                                // if (worker_queues.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_queues[Data_JSON["threadId"]];
                                // };
                                // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                                // if (worker_free.hasOwnProperty(Data_JSON["threadId"])) {
                                //     delete worker_free[Data_JSON["threadId"]];
                                // };

                                // worker_queues[Data_JSON["threadId"]].terminate();  // 銷毀子綫程;
                                break;
                            }

                            case 'error_response': {
                                console.log(receive_message);
                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                break;
                            }
                            case 'error': {
                                console.log(receive_message);
                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                                break;
                            }
                            default: {
                                console.log(receive_message);
                                // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            }
                        };
                    });

                    // console.log(worker_queues[worker_active_ID]);
                    // console.log(input_queues_array[0]);

                    input_queues_array[0]["threadId"] = require('worker_threads').threadId;
                    worker_queues[worker_active_ID].postMessage(['message', input_queues_array[0]], []);  // .postMessage(worker_Data, [Message_Channel.port2];

                    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
                    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
                    // console.log(now_date);
                    let log_text = String(now_date) + " thread-" + String(worker_active_ID) + " < " + input_queues_array[0].monitor_file + " > < " + output_file + " >.";
                    console.log(log_text);
                    // fs.appendFile(path, data[, options], callback);
                    // fs.appendFileSync(path, data[, options]);

                    input_queues_array = input_queues_array.slice(1, input_queues_array.length);  // 刪除第一個元素;

                    // worker_thread.postMessage(['standby', { "threadId": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling Stand by.", "delay": 5000 }], []);
                    // worker_thread.postMessage(['SIGINT', { "threadId": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling Unstand by."}], []);
                    // worker_thread.postMessage(['exit', { "threadId": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling exit."}], []);
                    // worker_thread.postMessage(['message', worker_Data], []);
                };

                if (Object.keys(worker_queues).length === 0 || worker_active_ID === "") {

                    // 記錄每個綫程纍加的被調用運算的總次數;
                    // if (!worker_queues.hasOwnProperty(require('worker_threads').threadId)) {
                    //     worker_queues[require('worker_threads').threadId] = require('worker_threads').Worker;  // 記錄主綫程對象;
                    // };
                    if (total_worker_called_number.hasOwnProperty(require('worker_threads').threadId)) {
                        total_worker_called_number[require('worker_threads').threadId] = parseInt(total_worker_called_number[require('worker_threads').threadId]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
                    } else {
                        total_worker_called_number[require('worker_threads').threadId] = 1;  // 第一次被調用賦值 1 ;
                    };

                    result = read_file_do_Function(input_queues_array[0].monitor_file, input_queues_array[0].monitor_dir, do_Function, input_queues_array[0].output_dir, input_queues_array[0].output_file, input_queues_array[0].to_executable, input_queues_array[0].to_script);

                    if (Object.prototype.toString.call(result).toLowerCase() === '[object array]') {
                        output_queues_array.push(result[1]);
                        // console.log(output_queues_array);
                    };
                    if (Object.prototype.toString.call(result).toLowerCase() === '[object string]' && result.split(":")[0] === "error") {
                        console.log("return Error: " + result.split(":")[1]);  // error;
                    };

                    // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 在已處理完數據後，是否已經從硬盤刪除;
                    file_bool = false;
                    try {
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = fs.existsSync(input_queues_array[0]["monitor_file"]) && fs.statSync(input_queues_array[0]["monitor_file"], { bigint: false }).isFile();
                        // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 存在.");
                    } catch (error) {
                        console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + input_queues_array[0]["monitor_file"] + " 是否存在.");
                        console.error(error);
                        return input_queues_array[0]["monitor_file"];
                    };
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                    if (file_bool) {

                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(input_queues_array[0]["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        try {
                            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(input_queues_array[0]["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            fs.accessSync(input_queues_array[0]["monitor_file"], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 可以讀寫.");
                        } catch (error) {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                            try {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                fs.fchmodSync(input_queues_array[0]["monitor_file"], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 操作權限修改為可以讀寫.");
                                // 常量                    八進制值    說明
                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                // fs.constants.S_IRGRP    0o40       群組可讀
                                // fs.constants.S_IWGRP    0o20       群組可寫
                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                // fs.constants.S_IROTH    0o4        其他人可讀
                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                // 數字	說明
                                // 7	可讀、可寫、可執行
                                // 6	可讀、可寫
                                // 5	可讀、可執行
                                // 4	唯讀
                                // 3	可寫、可執行
                                // 2	只寫
                                // 1	只可執行
                                // 0	沒有許可權
                                // 例如，八進制值 0o765 表示：
                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                // 2) 、群組可以讀和寫入該文檔；
                                // 3) 、其他人可以讀取和執行該文檔；
                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                            } catch (error) {
                                console.error("用於傳入數據的臨時暫存媒介文檔 [ " + input_queues_array[0]["monitor_file"] + " ] 無法修改為可讀可寫權限.");
                                console.error(error);
                                return input_queues_array[0]["monitor_file"];
                            };
                        };

                        // 同步刪除，用於臨時接收傳值的媒介文檔;
                        try {
                            fs.unlinkSync(input_queues_array[0]["monitor_file"]);  // 同步刪除，返回值為 undefined;
                            // console.error("用於臨時接收數據的媒介文檔: " + input_queues_array[0]["monitor_file"] + " 已被刪除.");
                            // console.log(fs.readdirSync(input_queues_array[0]["monitor_file"], { encoding: "utf8", withFileTypes: false }));
                        } catch (error) {
                            console.error("用於臨時接收數據的媒介文檔: " + input_queues_array[0]["monitor_file"] + " 無法刪除.");
                            console.error(error);
                            return input_queues_array[0]["monitor_file"];
                        };

                        // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 是否已經從硬盤刪除;
                        file_bool = false;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(input_queues_array[0]["monitor_file"]) && fs.statSync(input_queues_array[0]["monitor_file"], { bigint: false }).isFile();
                            // console.log("文檔: " + input_queues_array[0]["monitor_file"] + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + input_queues_array[0]["monitor_file"] + " 是否存在.");
                            console.error(error);
                            return input_queues_array[0]["monitor_file"];
                        };
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                        if (file_bool) {
                            console.error("用於傳入數據的臨時媒介文檔序列第一位: " + input_queues_array[0]["monitor_file"] + " 無法刪除.");
                            return input_queues_array[0]["monitor_file"];
                        };
                    };

                    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
                    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
                    // console.log(now_date);
                    let log_text = String(now_date) + " thread-" + String(require('worker_threads').threadId) + " < " + input_queues_array[0].monitor_file + " > < " + output_file + " >.";
                    console.log(log_text);
                    // fs.appendFile(path, data[, options], callback);
                    // fs.appendFileSync(path, data[, options]);

                    input_queues_array = input_queues_array.slice(1, input_queues_array.length);  // 刪除第一個元素;
                };
            };

            // 監聽待傳出數據結果隊列數組 output_queues_array，當有用於傳出數據的媒介目錄 output_dir 中不在含有 output_file 時，將待傳出數據結果隊列數組 output_queues_array 中排在前面的第一個結果文檔，更名移人用於傳出數據的媒介目錄 output_dir 中;
            if (output_queues_array.length > 0) {
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷判斷用於輸出傳值的媒介文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
                file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
                    // console.log("文檔: " + output_file + " 存在.");
                } catch (error) {
                    console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
                    console.error(error);
                    return output_file;
                };
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷用於輸出的媒介文檔是否存在以及是否為文檔;
                if (!file_bool) {

                    // 判斷用於傳出數據的臨時媒介文檔序列第一位 output_queues_array[0] 是否已經從硬盤刪除;
                    file_bool = false;
                    try {
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = fs.existsSync(output_queues_array[0]) && fs.statSync(output_queues_array[0], { bigint: false }).isFile();
                        // console.log("文檔: " + output_queues_array[0] + " 存在.");
                    } catch (error) {
                        console.error("無法確定用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 是否存在.");
                        console.error(error);
                        return output_queues_array[0];
                    };
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    if (!file_bool) {

                        output_queues_array = output_queues_array.slice(1, output_queues_array.length);  // 刪除第一個元素;

                    } else {

                        // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            fs.accessSync(output_queues_array[0], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("文檔: " + output_queues_array[0] + " 可以讀寫.");
                        } catch (error) {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                            try {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                fs.fchmodSync(output_queues_array[0], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                // console.log("文檔: " + output_queues_array[0] + " 操作權限修改為可以讀寫.");
                                // 常量                    八進制值    說明
                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                // fs.constants.S_IRGRP    0o40       群組可讀
                                // fs.constants.S_IWGRP    0o20       群組可寫
                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                // fs.constants.S_IROTH    0o4        其他人可讀
                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                // 數字	說明
                                // 7	可讀、可寫、可執行
                                // 6	可讀、可寫
                                // 5	可讀、可執行
                                // 4	唯讀
                                // 3	可寫、可執行
                                // 2	只寫
                                // 1	只可執行
                                // 0	沒有許可權
                                // 例如，八進制值 0o765 表示：
                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                // 2) 、群組可以讀和寫入該文檔；
                                // 3) 、其他人可以讀取和執行該文檔；
                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                            } catch (error) {
                                console.error("用於傳出數據的臨時暫存媒介文檔 [ " + output_queues_array[0] + " ] 無法修改為可讀可寫權限.");
                                console.error(error);
                                return output_queues_array[0];
                            };
                        };

                        // 同步移動文檔，將用於傳出數據的臨時媒介文檔序列第一位 output_queues_array[0] 從臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir 移動到媒介文件夾 output_dir，並更名為 output_file;
                        try {
                            // // let buff = new Buffer.alloc(16384);  // buff.toString('utf8', 0, buff.length);
                            // let fd = 1;
                            // // fs.copyFileSync(output_queues_array[0], output_file, 0);
                            // // fs.writeFileSync(output_file, fs.readFileSync(output_queues_array[0], { encoding: null, flag: "r" }), { encoding: 'utf8', mode: 0o666, flag: "w" });
                            // fd = fs.openSync(output_queues_array[0], "r", 0o666);
                            // let data = fs.readFileSync(output_queues_array[0], { encoding: null, flag: "r" });
                            // // fs.readSync(fd, buff, { offset: 0, length: buff.length, position: null });
                            // fs.closeSync(fd);
                            // fd = fs.openSync(output_file, "w", 0o666);
                            // fs.writeFileSync(output_file, data, { encoding: 'utf8', mode: 0o666, flag: "w" });
                            // // fs.writeSync(fd, buff, 0, buff.length, null);
                            // // fs.writeSync(fd, str, null, 'utf8');  // buff.toString('utf8', 0, buff.length);
                            // fs.closeSync(fd);
                            // fs.unlinkSync(output_queues_array[0]);  // 同步刪除，返回值為 undefined;

                            fs.renameSync(output_queues_array[0], output_file);  // 重命名或移動文檔，返回值為 undefined;
                            // // require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"];
                            // // require('path').parse(output_file)["base"] === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"];
                            // // console.log(temp_output_file);
                            // // console.log(require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]));
                        } catch (error) {
                            if (error.code !== 'EBUSY') {
                                console.error("用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 無法移動更名為用於傳出數據的媒介文檔: " + output_file);
                                console.error(error);
                            };
                            return output_queues_array[0];
                        };

                        // 判斷用於傳出數據的臨時媒介文檔序列第一位 output_queues_array[0] 是否已經從硬盤刪除;
                        file_bool = false;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_queues_array[0])方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(output_queues_array[0]) && fs.statSync(output_queues_array[0], { bigint: false }).isFile();
                            // console.log("文檔: " + output_queues_array[0] + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 是否存在.");
                            console.error(error);
                            return output_queues_array[0];
                        };
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_queues_array[0])方法判斷目錄或文檔是否存在以及是否為文檔;
                        if (file_bool) {
                            console.error("用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 無法刪除.");
                            return output_queues_array[0];
                        };

                        // 判斷用於傳出數據的臨時暫存媒介文檔 output_queues_array[0]，是否已經從暫存目錄 temp_NodeJS_cache_IO_data_dir 移動到媒介目錄 output_dir，並已經更名為 output_file;
                        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
                            // console.log("文檔: " + output_file + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
                            console.error(error);
                            return output_file;
                        };
                        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        if (!file_bool) {
                            console.error("用於傳出數據的臨時媒介文檔序列第一位: " + output_queues_array[0] + " 無法移動更名為用於傳出數據的媒介文檔: " + output_file);
                            return output_queues_array[0];
                        };

                        output_queues_array = output_queues_array.slice(1, output_queues_array.length);  // 刪除第一個元素;

                        // 同步判斷，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("文檔: " + output_file + " 可以讀寫.");
                        } catch (error) {
                            // 同步判斷，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                            try {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                fs.fchmodSync(output_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                // console.log("文檔: " + output_file + " 操作權限修改為可以讀寫.");
                                // 常量                    八進制值    說明
                                // fs.constants.S_IRUSR    0o400      所有者可讀
                                // fs.constants.S_IWUSR    0o200      所有者可寫
                                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                // fs.constants.S_IRGRP    0o40       群組可讀
                                // fs.constants.S_IWGRP    0o20       群組可寫
                                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                // fs.constants.S_IROTH    0o4        其他人可讀
                                // fs.constants.S_IWOTH    0o2        其他人可寫
                                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                // 數字	說明
                                // 7	可讀、可寫、可執行
                                // 6	可讀、可寫
                                // 5	可讀、可執行
                                // 4	唯讀
                                // 3	可寫、可執行
                                // 2	只寫
                                // 1	只可執行
                                // 0	沒有許可權
                                // 例如，八進制值 0o765 表示：
                                // 1) 、所有者可以讀取、寫入和執行該文檔；
                                // 2) 、群組可以讀和寫入該文檔；
                                // 3) 、其他人可以讀取和執行該文檔；
                                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                            } catch (error) {
                                console.error("用於傳出數據的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.");
                                console.error(error);
                                return output_file;
                            };
                        };


                        // 使用 child_process.exec 調用 shell 語句反饋;
                        // 運算處理完之後，給調用語言的回復，fs.accessSync(to_executable, fs.constants.X_OK) 判斷脚本文檔是否具有被執行權限;
                        file_bool = false;
                        try {
                            // 同步判斷，反饋目標解釋器可執行檔 to_executable 是否可執行;
                            file_bool = Object.prototype.toString.call(to_executable).toLowerCase() === '[object string]' && to_executable !== "" && fs.existsSync(to_executable) && fs.statSync(to_executable, { bigint: false }).isFile() && fs.accessSync(to_executable, fs.constants.X_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                            // console.log("解釋器可執行檔: " + to_executable + " 可以運行.");
                        } catch (error) {
                            console.error("無法確定反饋目標解釋器可執行檔: " + to_executable + " 是否具有可執行權限.");
                            console.error(error);
                            return to_executable;
                        };
                        if (file_bool) {
                            file_bool = false;
                            try {
                                // 同步判斷，反饋目標解釋器運行脚本 to_script 是否可執行;
                                file_bool = Object.prototype.toString.call(to_script).toLowerCase() === '[object string]' && to_script !== "" && fs.existsSync(to_script) && fs.statSync(to_script, { bigint: false }).isFile() && fs.accessSync(to_script, fs.constants.R_OK | fs.constants.W_OK) && fs.accessSync(to_script, fs.constants.X_OK);  // 0o777，可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                                // console.log("脚本文檔: " + to_script + " 可以被執行.");
                            } catch (error) {
                                console.error("無法確定反饋目標解釋器運行脚本文檔: " + to_script + " 是否可執行.");
                                console.error(error);
                                return to_script;
                            };
                            let shell_run_to_executable = "";
                            if (file_bool) {
                                shell_run_to_executable = to_executable.concat(" ", to_script, " ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
                            } else {
                                shell_run_to_executable = to_executable.concat(" ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
                            };
                            // let result = require('child_process').execSync(shell_run_to_executable);
                            // // console.log(result);
                            require('child_process').exec(shell_run_to_executable, function (error, stdout, stderr) {
                                // if (error) {
                                //     console.error("EXEC Error: " + error);
                                //     // return;
                                // };
                                // if (stderr) {
                                //     console.log("stderr: " + stderr);
                                // };
                                // if (stdout) {
                                //     // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
                                //     console.log(typeof (stdout));
                                //     console.log(stdout);
                                //     if (isStringJSON(stdout)) {
                                //         console.log(JSON.parse(stdout));
                                //     };
                                // };
                            });
                        };
                    };
                };
            };

            // 監聽指定的硬盤用於傳數據的媒介目錄，當目錄中出現監聽的目標文檔時，激活處理函數;
            try {
                // 同步讀取，用於保存監聽目錄被改變後所包含的内容條目;
                changed_dir_list_array = fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });  // 同步讀取，返回值 Array;
                // console.log(fs.readdirSync("D:\\", { encoding: "utf8", withFileTypes: false }));
            } catch (error) {
                console.error("無法讀取用於輸入數據的媒介文件夾: " + monitor_dir + " 中的内容條目.");
                console.error(error);
                return monitor_dir;
            };
            // 比較讀取到的監聽目錄中所包含的條目，與初始記錄的是否一致，如果不一致即被改變，以此達到監聽目錄的目標;
            // 兩個數組對象之間，不能直接使用 === 比較，需要先將元素排序 .sort()，然後轉換成字符串 JSON.stringify()，再進行比較;
            if (JSON.stringify(changed_dir_list_array.sort()) !== JSON.stringify(initial_dir_list_array.sort())) {
                let added = new Array;  // 記錄監聽目錄中新增的條目;
                let removed = new Array;  // 記錄監聽目錄中被刪除的條目;
                for (let i = 0; i < Math.max(changed_dir_list_array.length, initial_dir_list_array.length); i++) {
                    if (i < Math.min(changed_dir_list_array.length, initial_dir_list_array.length)) {
                        if (changed_dir_list_array.indexOf(initial_dir_list_array[i]) === -1) {
                            removed.push(initial_dir_list_array[i]);  // 被刪除的文檔名;
                        };
                        if (initial_dir_list_array.indexOf(changed_dir_list_array[i]) === -1) {
                            added.push(changed_dir_list_array[i]);  // 新增加的文檔名;
                        };
                    } else {
                        if (changed_dir_list_array.length > initial_dir_list_array.length) {
                            if (initial_dir_list_array.indexOf(changed_dir_list_array[i]) === -1) {
                                added.push(changed_dir_list_array[i]);  // 新增加的文檔名;
                            };
                        };
                        if (changed_dir_list_array.length < initial_dir_list_array.length) {
                            if (changed_dir_list_array.indexOf(initial_dir_list_array[i]) === -1) {
                                removed.push(initial_dir_list_array[i]);  // 被刪除的文檔名;
                            };
                        };
                    };
                };

                if (added) {
                    // console.log("Added: " + added.join(" , "));
                    // 判斷監聽目錄中新增的文檔名稱與指定監聽的文檔名稱是否相等;
                    for (let i = 0; i < added.length; i++) {
                        // added[i] === require('path').parse(monitor_file)["base"];
                        if (added[i] === require('path').basename(monitor_file)) {
                            console.log("Added: " + added[i]);
                            input_file_NUM = parseInt(Number(input_file_NUM) + parseInt(1));  // 監聽到的第幾次傳入媒介文檔;
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            // // 同步判斷文檔 monitor_file 是否存在，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                            // try {
                            //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            //     file_bool = fs.existsSync(require('path').join(monitor_dir, added[i])) && fs.statSync(require('path').join(monitor_dir, added[i]), { bigint: false }).isFile();
                            //     // console.log("文檔: " + require('path').join(monitor_dir, added[i]) + " 存在.");
                            // } catch (error) {
                            //     console.error("無法確定用於傳入數據的媒介文檔: " + require('path').join(monitor_dir, added[i]) + " 是否存在.");
                            //     console.error(error);
                            //     return require('path').join(monitor_dir, added[i]);
                            // };
                            // 同步判斷文檔 monitor_file 是否具有可讀可寫權限，當用於傳入數據的媒介文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            try {
                                // 同步判斷文檔 monitor_file 是否具有可讀可寫權限，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                                fs.accessSync(require('path').join(monitor_dir, added[i]), fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                                // console.log("文檔: " + require('path').join(monitor_dir, added[i]) + " 可以讀寫.");
                            } catch (error) {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                                try {
                                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                    fs.fchmodSync(require('path').join(monitor_dir, added[i]), fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                    // console.log("文檔: " + require('path').join(monitor_dir, added[i]) + " 操作權限修改為可以讀寫.");
                                    // 常量                    八進制值    說明
                                    // fs.constants.S_IRUSR    0o400      所有者可讀
                                    // fs.constants.S_IWUSR    0o200      所有者可寫
                                    // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                    // fs.constants.S_IRGRP    0o40       群組可讀
                                    // fs.constants.S_IWGRP    0o20       群組可寫
                                    // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                    // fs.constants.S_IROTH    0o4        其他人可讀
                                    // fs.constants.S_IWOTH    0o2        其他人可寫
                                    // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                    // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                    // 數字	說明
                                    // 7	可讀、可寫、可執行
                                    // 6	可讀、可寫
                                    // 5	可讀、可執行
                                    // 4	唯讀
                                    // 3	可寫、可執行
                                    // 2	只寫
                                    // 1	只可執行
                                    // 0	沒有許可權
                                    // 例如，八進制值 0o765 表示：
                                    // 1) 、所有者可以讀取、寫入和執行該文檔；
                                    // 2) 、群組可以讀和寫入該文檔；
                                    // 3) 、其他人可以讀取和執行該文檔；
                                    // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                    // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                                } catch (error) {
                                    console.error("用於接收傳值的媒介文檔 [ " + require('path').join(monitor_dir, added[i]) + " ] 無法修改為可讀可寫權限.");
                                    console.error(error);
                                    return require('path').join(monitor_dir, added[i]);
                                };
                            };

                            // 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                            let index_NUM = "_".concat(input_file_NUM.toString());  // 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                            // if (input_queues_array.length > 0) {
                            //     index_NUM = "_" + String(parseInt(require('path').parse(input_queues_array[parseInt(parseInt(input_queues_array.length) - parseInt(1))])["name"].split("_")[1]) + parseInt(1));
                            // } else {
                            //     index_NUM = "_0";
                            // };
                            let temp_monitor_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(monitor_file)["name"] + index_NUM + require('path').parse(monitor_file)["ext"]);  // 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                            // console.log(temp_monitor_file);
                            let temp_output_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]);  // 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                            // console.log(temp_output_file);
                            // console.log(require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"]);

                            // 判斷用於接收或輸出傳值的臨時媒介文檔是否有重名的;
                            file_bool = false;
                            try {
                                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                                file_bool = (fs.existsSync(temp_monitor_file) && fs.statSync(temp_monitor_file, { bigint: false }).isFile()) || (fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile());
                                // console.log("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.");
                            } catch (error) {
                                console.error("無法確定用於傳入數據的臨時媒介文檔: " + temp_monitor_file + " 或用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                                console.error(error);
                                return [temp_monitor_file, temp_output_file];
                            };
                            while (file_bool) {
                                console.log("用於傳入數據的臨時媒介文檔: " + temp_monitor_file + " 或用於傳出數據的臨時媒介文檔: " + temp_output_file + " 已經存在.");
                                input_file_NUM = parseInt(Number(input_file_NUM) + parseInt(1));  // 監聽到的第幾次傳入媒介文檔增加一個;
                                // 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                                index_NUM = "_".concat(input_file_NUM.toString());  // 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                                // if (input_queues_array.length > 0) {
                                //     index_NUM = "_" + String(parseInt(require('path').parse(input_queues_array[parseInt(parseInt(input_queues_array.length) - parseInt(1))])["name"].split("_")[1]) + parseInt(1));
                                // } else {
                                //     index_NUM = "_0";
                                // };
                                temp_monitor_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(monitor_file)["name"] + index_NUM + require('path').parse(monitor_file)["ext"]);  // 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                                // console.log(temp_monitor_file);
                                temp_output_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]);  // 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                                // console.log(temp_output_file);
                                // console.log(require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"]);

                                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                                file_bool = false;
                                try {
                                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                                    file_bool = (fs.existsSync(temp_monitor_file) && fs.statSync(temp_monitor_file, { bigint: false }).isFile()) || (fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile());
                                    // console.log("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.");
                                } catch (error) {
                                    console.error("無法確定用於傳入數據的臨時媒介文檔: " + temp_monitor_file + " 或用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                                    console.error(error);
                                    return [temp_monitor_file, temp_output_file];
                                };
                            };

                            // // 判斷用於輸出傳值的臨時媒介文檔是否有重名的;
                            // // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            // file_bool = false;
                            // try {
                            //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            //     file_bool = fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile();
                            //     // console.log("文檔: " + temp_output_file + " 存在.");
                            // } catch (error) {
                            //     console.error("無法確定用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                            //     console.error(error);
                            //     return temp_output_file;
                            // };
                            // while (file_bool) {
                            //     console.log("用於傳出數據的臨時媒介文檔: " + temp_output_file + " 已經存在.");
                            //     input_file_NUM = parseInt(Number(input_file_NUM) + parseInt(1));  // 監聽到的第幾次傳入媒介文檔增加一個;
                            //     // 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                            //     index_NUM = "_".concat(input_file_NUM.toString());  // 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                            //     // if (input_queues_array.length > 0) {
                            //     //     index_NUM = "_" + String(parseInt(require('path').parse(input_queues_array[parseInt(parseInt(input_queues_array.length) - parseInt(1))])["name"].split("_")[1]) + parseInt(1));
                            //     // } else {
                            //     //     index_NUM = "_0";
                            //     // };
                            //     temp_monitor_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(monitor_file)["name"] + index_NUM + require('path').parse(monitor_file)["ext"]);  // 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                            //     // console.log(temp_monitor_file);
                            //     temp_output_file = require('path').join(temp_NodeJS_cache_IO_data_dir, require('path').parse(output_file)["name"] + index_NUM + require('path').parse(output_file)["ext"]);  // 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                            //     // console.log(temp_output_file);
                            //     // console.log(require('path').basename(output_file) === require('path').parse(temp_output_file)["name"].split("_")[0] + require('path').parse(temp_output_file)["ext"]);

                            //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            //     file_bool = false;
                            //     try {
                            //         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            //         file_bool = fs.existsSync(temp_output_file) && fs.statSync(temp_output_file, { bigint: false }).isFile();
                            //         // console.log("文檔: " + temp_output_file + " 存在.");
                            //     } catch (error) {
                            //         console.error("無法確定用於傳出數據的臨時媒介文檔: " + temp_output_file + " 是否存在.");
                            //         console.error(error);
                            //         return temp_output_file;
                            //     };
                            // };

                            try {
                                // // let buff = new Buffer.alloc(16384);  // buff.toString('utf8', 0, buff.length);
                                // let fd = 1;
                                // // fs.copyFileSync(require('path').join(monitor_dir, added[i]), temp_monitor_file, 0);
                                // // fs.writeFileSync(temp_monitor_file, fs.readFileSync(require('path').join(monitor_dir, added[i]), { encoding: null, flag: "r" }), { encoding: 'utf8', mode: 0o666, flag: "w" });
                                // fd = fs.openSync(require('path').join(monitor_dir, added[i]), "r", 0o666);
                                // let data = fs.readFileSync(require('path').join(monitor_dir, added[i]), { encoding: null, flag: "r" });
                                // // fs.readSync(fd, buff, { offset: 0, length: buff.length, position: null });
                                // fs.closeSync(fd);
                                // fd = fs.openSync(temp_monitor_file, "w", 0o666);
                                // fs.writeFileSync(temp_monitor_file, data, { encoding: 'utf8', mode: 0o666, flag: "w" });
                                // // fs.writeSync(fd, buff, 0, buff.length, null);
                                // // fs.writeSync(fd, str, null, 'utf8');  // buff.toString('utf8', 0, buff.length);
                                // fs.closeSync(fd);
                                // fs.unlinkSync(require('path').join(monitor_dir, added[i]));  // 同步刪除，返回值為 undefined;

                                fs.renameSync(require('path').join(monitor_dir, added[i]), temp_monitor_file);  // 重命名或移動文檔，返回值為 undefined;
                                // require('path').basename(monitor_file) === require('path').parse(monitor_file)["name"] + require('path').parse(monitor_file)["ext"];
                                // require('path').parse(monitor_file)["base"] === require('path').parse(monitor_file)["name"] + require('path').parse(monitor_file)["ext"];
                                // console.log(monitor_file);
                                // console.log(temp_monitor_file);
                            } catch (error) {
                                if (error.code !== 'EBUSY') {
                                    console.error("用於傳入數據的媒介文檔: " + require('path').join(monitor_dir, added[i]) + " 無法移動更名為: " + temp_monitor_file);
                                    console.error(error);
                                };
                                return require('path').join(monitor_dir, added[i]);
                            };

                            // 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                            file_bool = false;
                            try {
                                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                                file_bool = fs.existsSync(require('path').join(monitor_dir, added[i])) && fs.statSync(monitor_file, { bigint: false }).isFile();
                                // console.log("文檔: " + require('path').join(monitor_dir, added[i]) + " 存在.");
                            } catch (error) {
                                console.error("無法確定用於傳入數據的媒介文檔: " + require('path').join(monitor_dir, added[i]) + " 是否存在.");
                                console.error(error);
                                return require('path').join(monitor_dir, added[i]);
                            };
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            if (file_bool) {
                                console.error("用於傳入數據的媒介文檔: " + require('path').join(monitor_dir, added[i]) + " 無法被刪除.");
                                return require('path').join(monitor_dir, added[i]);
                            };

                            // 判斷用於接收傳值的媒介文檔，是否已經從媒介目錄移動到暫存目錄，並已經更名為 <原名> + "_<序號>" + <原擴展名> 硬盤刪除;
                            file_bool = false;
                            try {
                                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                                file_bool = fs.existsSync(temp_monitor_file) && fs.statSync(temp_monitor_file, { bigint: false }).isFile();
                                // console.log("文檔: " + temp_monitor_file + " 存在.");
                            } catch (error) {
                                console.error("無法確定用於傳入數據的暫存媒介文檔: " + temp_monitor_file + " 是否存在.");
                                console.error(error);
                                return temp_monitor_file;
                            };
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            if (!file_bool) {
                                console.error("無法將用於傳入數據的媒介文檔: " + monitor_file + " 移動更名為暫存文檔: " + temp_monitor_file);
                                return temp_monitor_file;
                            };

                            // 同步判斷判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(temp_monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                            try {
                                // 同步判斷，使用Node.js原生模組fs的fs.accessSync(temp_monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                                file_bool = fs.accessSync(temp_monitor_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                                // console.log("文檔: " + temp_monitor_file + " 可以讀寫.");
                            } catch (error) {
                                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                                try {
                                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                                    fs.fchmodSync(temp_monitor_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                                    // console.log("文檔: " + temp_monitor_file + " 操作權限修改為可以讀寫.");
                                    // 常量                    八進制值    說明
                                    // fs.constants.S_IRUSR    0o400      所有者可讀
                                    // fs.constants.S_IWUSR    0o200      所有者可寫
                                    // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                                    // fs.constants.S_IRGRP    0o40       群組可讀
                                    // fs.constants.S_IWGRP    0o20       群組可寫
                                    // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                                    // fs.constants.S_IROTH    0o4        其他人可讀
                                    // fs.constants.S_IWOTH    0o2        其他人可寫
                                    // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                                    // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                                    // 數字	說明
                                    // 7	可讀、可寫、可執行
                                    // 6	可讀、可寫
                                    // 5	可讀、可執行
                                    // 4	唯讀
                                    // 3	可寫、可執行
                                    // 2	只寫
                                    // 1	只可執行
                                    // 0	沒有許可權
                                    // 例如，八進制值 0o765 表示：
                                    // 1) 、所有者可以讀取、寫入和執行該文檔；
                                    // 2) 、群組可以讀和寫入該文檔；
                                    // 3) 、其他人可以讀取和執行該文檔；
                                    // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                                    // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                                } catch (error) {
                                    console.error("用於接收傳入數據的暫存媒介文檔 [ " + temp_monitor_file + " ] 無法修改為可讀可寫權限.");
                                    console.error(error);
                                    return temp_monitor_file;
                                };
                            };

                            let worker_Data = {
                                // "read_file_do_Function": read_file_do_Function.toString(),
                                "monitor_file": temp_monitor_file,  // monitor_file;
                                "monitor_dir": temp_NodeJS_cache_IO_data_dir,  // monitor_dir;
                                // "do_Function": do_Function.toString(),  // do_Function_obj["do_Function"];
                                "output_dir": temp_NodeJS_cache_IO_data_dir,  // output_dir;
                                "output_file": temp_output_file,  // output_file，output_queues_array;
                                "to_executable": to_executable,
                                "to_script": to_script
                            };
                            // if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]' && Object.prototype.toString.call(eval('"' + do_Function + '"')).toLowerCase() === '[object function]') {
                            //     worker_Data["do_Function"] = eval(do_Function).toString();  // do_Function_obj["do_Function"];
                            // } else if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object function]') {
                            //     worker_Data["do_Function"] = do_Function.toString();  // do_Function_obj["do_Function"]; new Buffer(do_Function_obj["do_Function"]);  // .from(do_Function_obj["do_Function"]);
                            // } else {
                            //     worker_Data["do_Function"] = null;
                            // };

                            input_queues_array.push(worker_Data);

                            // result = read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script);
                            // break; // continue;
                        };
                    };
                };

                if (removed) {
                    // console.log("removed: " + removed.join(" , "));
                    for (let i = 0; i < removed.length; i++) {
                        // 判斷監聽目錄中被刪除的文檔名稱與指定的用於傳值的輸出文檔名稱是否相等;
                        // removed[i] === require('path').parse(output_file)["base"];
                        if (removed[i] === require('path').basename(output_file)) {
                            console.log("removed: " + removed[i]);
                            // break; // continue;
                        };
                    };
                };
                // 深拷貝（複製傳值）數組，數組複製，不能直接使用 = 符號，直接使用 = 符號複製數組，只能淺拷貝（引用傳址）;
                initial_dir_list_array = JSON.parse(JSON.stringify(changed_dir_list_array));  // 深拷貝（複製傳值）數組;
            };
            // console.log("當前進程編號: process-" + process.pid + " thread-" + require('worker_threads').threadId)
            return [result, output_queues_array, input_queues_array];
        };

        // let delay = 500;  // 延遲時長，單位毫秒;
        let setInterval_id = null;  // 循環延時監聽指定文檔是否被創建的ID號碼，用於取消循環 setInterval_id = setInterval(func_Monitor_dir, delay);
        // 監聽指定文檔是否被創建;
        setInterval_id = setInterval(function () { func_Monitor_file(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, temp_NodeJS_cache_IO_data_dir) }, delay);  // 循環延時監聽;
        // // 監聽文件夾;
        // setInterval_id = setInterval(function () { func_Monitor_dir(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, temp_NodeJS_cache_IO_data_dir) }, delay);  // 循環延時監聽;
        // console.log(setInterval_id)
        // clearInterval(setInterval_id);  // 清除延時監聽動作;

        return setInterval_id;
    };

    function create_worker_thread(number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value) {
        // console.log("當前進程編號: " + process.pid);
        // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
        // console.log("當前進程使用的内存: " + process.memoryUsage());
        // console.log("運行當前進程的操作系統平臺: " + process.platform);
        // console.log("運行當前進程的操作系統架構: " + process.arch);
        // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
        // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
        // console.log("當前進程的用戶環境: " + process.env);
        // console.log("當前進程的工作目錄: " + process.cwd());
        // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
        // console.log("運行當前進程的運行時間: " + process.uptime());
        // console.log("當前綫程ID: thread-" + require('worker_threads').threadId);

        // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
        // if (typeof (number_Worker_threads) === undefined && number_Worker_threads === undefined && isNaN(Number(number_Worker_threads)) && parseInt(number_Worker_threads) <= 0) {
        //     // number_Worker_threads.toString("utf-8").match(/[0-9]{1,10}/gim) !== null && number_Worker_threads.toString("utf-8").match(/[0-9]{1,10}/gim).length = 1:
        //     // number_Worker_threads = number_Worker_threads.toString("utf-8").match(/[0-9]{1,10}/gim)[0]:
        //     // number_Worker_threads = parseInt(number_Worker_threads);

        //     console.log("傳入的創建子綫程數目的參數(number_Worker_threads): " + number_Worker_threads + " 錯誤.");
        //     return number_Worker_threads;
        // };

        // 配置創建子綫程數目參數預設值;
        if (typeof (number_Worker_threads) === undefined || number_Worker_threads === undefined || number_Worker_threads === null || number_Worker_threads === "") {
            number_Worker_threads = parseInt(1);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
        } else if (number_Worker_threads && typeof (number_Worker_threads) !== "number" && number_Worker_threads !== "") {
            number_Worker_threads = parseInt(number_Worker_threads);  // parseInt(1)，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
        };

        // 配置子綫程運行時脚本參數 Worker_threads_Script_path 的預設值 new Worker(Worker_threads_Script_path, { eval: true });
        if (typeof (Worker_threads_Script_path) === undefined || Worker_threads_Script_path === undefined || Worker_threads_Script_path === null || Worker_threads_Script_path === "") {
            Worker_threads_Script_path = "";  // process.argv[1] new Worker(Worker_threads_Script_path, { eval: true });
        };

        // 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的預設值 // new Worker(Worker_threads_Script_path, { eval: true });
        if (typeof (Worker_threads_eval_value) === undefined || Worker_threads_eval_value === undefined || Worker_threads_eval_value === null || Worker_threads_eval_value === "") {
            Worker_threads_eval_value = true;  // new Worker(Worker_threads_Script_path, { eval: true });
        } else if (Worker_threads_eval_value && typeof (Worker_threads_eval_value) !== "boolean" && Worker_threads_eval_value !== "") {
            Worker_threads_eval_value = Boolean(Worker_threads_eval_value);  // new Worker(Worker_threads_Script_path, { eval: true });
        };

        // 可以通過兩種方式使用 worker。第一種是生成一個 worker，然後執行它的代碼，並將結果發送到父執行緒。通過這種方法，每當出現新任務時，都必須重新創建一個工作者;
        // 第二種方法是生成一個 worker 並為 message 事件設置監聽器。每次觸發 message 時，它都會完成工作並將結果發送回父執行緒，這會使 worker 保持活動狀態以供以後使用;
        // Node.js 文檔推薦第二種方法，因為在創建 thread worker 時需要創建虛擬機器並解析和執行代碼，這會產生比較大的開銷。所以這種方法比不斷產生新 worker 的效率更高;
        // 這種方法被稱為工作池，因為我們創建了一個工作池並讓它們等待，在需要時調度 message 事件來完成工作;
        // process.argv[1] === module.filename === __filename;
        let total_worker_called_number = {};
        let Message_Channel_queues = {};
        let worker_queues = {};
        let worker_free = {};
        if (require('worker_threads').isMainThread) {

            // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組;

            let worker_Data = {
                "read_file_do_Function": read_file_do_Function.toString(),
                // "monitor_file": monitor_file,
                // "monitor_dir": monitor_dir,                
                // "output_dir": output_dir,
                // "output_file": output_file,
                // "to_executable": to_executable,
                // "to_script": to_script,
                "do_Function": do_Function.toString()  // do_Function_obj["do_Function"];
            };
            // 將函數對象轉換爲字符串;
            // if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object string]' && Object.prototype.toString.call(eval('"' + do_Function + '"')).toLowerCase() === '[object function]') {
            //     worker_Data["do_Function"] = eval(do_Function).toString();  // do_Function_obj["do_Function"];
            // } else if (Object.prototype.toString.call(do_Function).toLowerCase() === '[object function]') {
            //     worker_Data["do_Function"] = do_Function.toString();  // do_Function_obj["do_Function"]; new Buffer(do_Function_obj["do_Function"]);  // .from(do_Function_obj["do_Function"]);
            // } else {
            //     worker_Data["do_Function"] = null;
            // };
            // 將函數對象轉換爲二進制緩存 Buffer 類;
            // if (Object.prototype.toString.call(do_Function_obj["do_Function"]).toLowerCase() === '[object string]' && eval("Object.prototype.toString.call(" + do_Function_obj["do_Function"] + ").toLowerCase() === '[object function]'")) {
            //     worker_Data["do_Function"] = do_Function_obj["do_Function"];
            // } else if (Object.prototype.toString.call(do_Function_obj["do_Function"]).toLowerCase() === '[object function]') {
            //     worker_Data["do_Function"] = new Buffer(do_Function_obj["do_Function"]);  // .from(do_Function_obj["do_Function"]);
            // } else {
            //     worker_Data["do_Function"] = null;
            // };

            // 使用 Node.js 原生模組 require('worker_threads') 循環創建子綫程池 new Workers(script.js,{})，每調用一次 new Workers(script.js,{})，就會創建一個子綫程;
            // let number_Worker_threads = os.cpus().length;  // 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;;
            // 判斷傳入的自定義子進程數目 number_Worker_threads 參數是否爲 0 ~ 9 的阿拉伯數字，並且規定創建子進程數目不得超過 5 個;

            console.log("Master thread-" + require('worker_threads').threadId + " setting up " + number_Worker_threads + " worker threads ...");
            for (let i = 0; i < number_Worker_threads; i++) {

                let thread_Id = null;
                try {

                    // let code_string = `
                    // let monitor_file = ${ monitor_file};
                    // let monitor_dir = ${ monitor_dir};
                    // let do_Function_obj = {
                    //     "do_data": ${ do_data}  // 用於接收執行功能的函數;
                    // };
                    // let return_obj = {
                    //     "output_dir": ${ output_dir}, // "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
                    //     "output_file": ${ output_file},  // "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
                    //     "to_executable": ${ to_executable},  // "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
                    //     "to_script": ${ to_script }  // "../js/test.js" 用於執行功能的被調用的脚步文檔;
                    // };
                    // let monitor = false;
                    // require(process.argv[1]).file_Monitor(monitor_file, monitor_dir, do_Function_obj, return_obj, monitor);
                    // `
                    // const worker_thread = new Worker(code_string, { workerData: worker_Data, eval: true });

                    // 子綫程 Worker thread 中運行的代碼字符串化;
                    let Script_code = `
                        if (require('worker_threads').isMainThread) { throw new Error('isMainThread: ' + require('worker_threads').isMainThread + ', threadId-' + require('worker_threads').threadId + ' is not a worker.') };
                        const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組;
                        const { AsyncResource } = require('async_hooks');  // 導入 Node.js 原生異步鈎子模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
                        const { EventEmitter } = require('events');  // 導入 Node.js 原生事件模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;

                        const child_process = require('child_process');  // Node原生的創建子進程模組;
                        const os = require('os');  // Node原生的操作系統信息模組;
                        const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
                        const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;

                        // 自定義封裝的函數isStringJSON(str)判斷一個字符串是否爲 JSON 格式的字符串;
                        function isStringJSON(str) {
                            // 首先判斷傳入參數 str 是否為一個字符串 typeof (str) === 'string'，如果不是字符串直接返回錯誤;
                            if (Object.prototype.toString.call(str).toLowerCase() === '[object string]') {
                                try {
                                    let Obj = JSON.parse(str);
                                    // 使用語句 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) 判斷 Obj 是否為一個 JSON 對象;
                                    if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) {
                                        return true;
                                    } else {
                                        return false;
                                    };
                                } catch (error) {
                                    // console.log(error);
                                    return false;
                                } finally {};
                            } else {
                                // console.log("It is not a String!");
                                return false;
                            };
                        };

                        if (Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object function]' || (typeof (workerData["read_file_do_Function"]) !== undefined && workerData["read_file_do_Function"] !== undefined && workerData["read_file_do_Function"] !== null && workerData["read_file_do_Function"] !== "" && Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(workerData["read_file_do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("read_file_do_Function = " + workerData["read_file_do_Function"] + ';')).toLowerCase() === '[object function]'))) {
                        // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                            eval("read_file_do_Function = " + workerData["read_file_do_Function"] + ";");
                        } else if (typeof (workerData["read_file_do_Function"]) !== undefined && workerData["read_file_do_Function"] !== undefined && workerData["read_file_do_Function"] !== null && workerData["read_file_do_Function"] !== "" && Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object string]') {
                        // 以 function mytFunc(argument) {} 形式的函數傳值;
                            eval(workerData["read_file_do_Function"]);
                            // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                            // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                            eval("read_file_do_Function = " + workerData["read_file_do_Function"].match(/(function =?)(\\S*)(?=\\()/)[2].replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                            // eval("read_file_do_Function = " + workerData["read_file_do_Function"].substring(workerData["read_file_do_Function"].indexOf('function') + 9, workerData["read_file_do_Function"].indexOf('(')).replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                        } else {
                            // console.log("傳入的用於處理數據的函數參數 read_file_do_Function: " + workerData["read_file_do_Function"] + " 無法識別.");
                            read_file_do_Function = function (argument) { return argument; };
                        };

                        if (Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object function]' || (typeof (workerData["do_Function"]) !== undefined && workerData["do_Function"] !== undefined && workerData["do_Function"] !== null && workerData["do_Function"] !== "" && Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(workerData["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + workerData["do_Function"] + ';')).toLowerCase() === '[object function]'))) {
                        // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                            eval("do_Function = " + workerData["do_Function"] + ";");
                        } else if (typeof (workerData["do_Function"]) !== undefined && workerData["do_Function"] !== undefined && workerData["do_Function"] !== null && workerData["do_Function"] !== "" && Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object string]') {
                        // 以 function mytFunc(argument) {} 形式的函數傳值;
                            eval(workerData["do_Function"]);
                            // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                            // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                            eval("do_Function = " + workerData["do_Function"].match(/(function =?)(\\S*)(?=\\()/)[2].replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                            // eval("do_Function = " + workerData["do_Function"].substring(workerData["do_Function"].indexOf('function') + 9, workerData["do_Function"].indexOf('(')).replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                        } else {
                            // console.log("傳入的用於處理數據的函數參數 do_Function: " + workerData["do_Function"] + " 無法識別.");
                            do_Function = function (argument) { return argument; };
                        };

                        // 創建延時循環，使子綫程一直處於運行狀態，不至於運行完畢被銷毀 setInterval_id = setInterval(function(){}, delay)，清楚循環 clearInterval(setInterval_id);
                        let setInterval_id = null;  // 子綫程延時待命的循環對象;
                        let delay = null;  //延遲時長，單位毫秒;
                        // setInterval_id = setInterval(function () {}, delay);  // 延時循環等待;

                        let response_message = null;
                        // response_message = read_file_do_Function(workerData.monitor_file, workerData.monitor_dir, workerData.do_Function, workerData.output_dir, workerData.output_file, workerData.to_executable, workerData.to_script);
                        // const port = message.ports[0];
                        // port.postMessage(response_message, []);
                        // // read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script);

                        // // 首次向主綫程 Master thread 發送響應;
                        // response_message = {
                        //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                        //     "data": "Worker thread-" + require('worker_threads').threadId + " Stand by Pooling delay " + delay + " ms ...",
                        //     "setInterval_id": setInterval_id
                        // };
                        // parentPort.postMessage(["standby_response", response_message], []);

                        // 監聽主綫程 Master thread 發送的信號;
                        // 在子綫程中注冊監聽 parentPort.on('message', (data) => {}) 事件，會使子綫程處於等待狀態，執行完畢也不被銷毀，從而實現，子綫程的「池化」效果，使用子綫程池技術，與頻繁創建銷毀子綫程相比，效率更高;
                        parentPort.on('message', (receive_message) => {

                            // console.log(typeof (receive_message));
                            // console.log(receive_message);
                            // parentPort.postMessage(["message_response", receive_message], []);

                            let Message_status = "";
                            let Data_JSON = null;
                            if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                                Message_status = 'message';
                                Data_JSON = receive_message[0];
                            } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                                Message_status = receive_message[0];
                                Data_JSON = receive_message[1];
                            } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                                Message_status = receive_message[0];
                                let Data_Array = [];
                                for (let i = 1; i < receive_message.length; i++) {
                                    Data_Array.push(receive_message[i]);
                                };
                            } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                                Message_status = 'message';
                                Data_JSON = receive_message;
                            // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'SIGINT' && receive_message !== 'error') {
                            //     Message_status = 'message';
                            //     Data_JSON = receive_message;
                            } else {
                                Message_status = receive_message;
                            };

                            // if (typeof (Data_JSON["read_file_do_Function"]) !== undefined && Data_JSON["read_file_do_Function"] !== undefined && Data_JSON["read_file_do_Function"] !== null && Data_JSON["read_file_do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["read_file_do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["read_file_do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"] + ';')).toLowerCase() === '[object function]')) {
                            // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                            //     eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"] + ";");
                            // } else if (typeof (Data_JSON["read_file_do_Function"]) !== undefined && Data_JSON["read_file_do_Function"] !== undefined && Data_JSON["read_file_do_Function"] !== null && Data_JSON["read_file_do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["read_file_do_Function"]).toLowerCase() === '[object string]') {
                            // // 以 function mytFunc(argument) {} 形式的函數傳值;
                            //     eval(Data_JSON["read_file_do_Function"]);
                            //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                            //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                            //     eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"].match(/(function =?)(\\S*)(?=\\()/)[2].replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                            //     // eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"].substring(Data_JSON["read_file_do_Function"].indexOf('function') + 9, Data_JSON["read_file_do_Function"].indexOf('(')).replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                            // } else {
                            //     // console.log("傳入的用於處理數據的函數參數 read_file_do_Function: " + Data_JSON["read_file_do_Function"] + " 無法識別.");
                            //     read_file_do_Function = function (argument) { return argument; };
                            // };

                            // if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + Data_JSON["do_Function"] + ';')).toLowerCase() === '[object function]')) {
                            // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                            //     eval("do_Function = " + Data_JSON["do_Function"] + ";");
                            // } else if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]') {
                            // // 以 function mytFunc(argument) {} 形式的函數傳值;
                            //     eval(Data_JSON["do_Function"]);
                            //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                            //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                            //     eval("do_Function = " + Data_JSON["do_Function"].match(/(function =?)(\\S*)(?=\\()/)[2].replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                            //     // eval("do_Function = " + Data_JSON["do_Function"].substring(Data_JSON["do_Function"].indexOf('function') + 9, Data_JSON["do_Function"].indexOf('(')).replace(/\\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                            // } else {
                            //     // console.log("傳入的用於處理數據的函數參數 do_Function: " + Data_JSON["do_Function"] + " 無法識別.");
                            //     do_Function = function (argument) { return argument; };
                            // };

                            switch (Message_status) {

                                case 'standby': {
                                    delay = parseInt(Data_JSON["delay"]);  // 500 延遲時長，單位毫秒;
                                    if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
                                        // console.log(setInterval_id);
                                        clearInterval(setInterval_id);  // 清除延時監聽動作;
                                        // console.log(setInterval_id);
                                    };
                                    setInterval_id = setInterval(function () { }, delay);  // 延時循環等待;
                                    // console.log(setInterval_id)
                                    // clearInterval(setInterval_id);  // 清除延時監聽動作;

                                    // console.log("Worker thread-" + require('worker_threads').threadId + " stand by Pooling ...");

                                    response_message = {
                                        "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                        "data": "Worker thread-" + require('worker_threads').threadId + " stand by Pooling ...",
                                        "setInterval_id": setInterval_id,
                                        "authenticate": "",
                                        "time": ""
                                    };
                                    parentPort.postMessage(["standby_response", response_message], []);
                                    break;
                                }

                                case 'message': {
                                    let result = read_file_do_Function(Data_JSON.monitor_file, Data_JSON.monitor_dir, do_Function, Data_JSON.output_dir, Data_JSON.output_file, Data_JSON.to_executable, Data_JSON.to_script);
                                    if (Object.prototype.toString.call(result).toLowerCase() === '[object array]') {
                                        response_message = {
                                            "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                            "monitor_file": Data_JSON.monitor_file,
                                            "data": result[0],
                                            "output_file": result[1],
                                            "authenticate": "",
                                            "time": ""
                                        };
                                    } else if (Object.prototype.toString.call(result).toLowerCase() === '[object string]') {
                                        response_message = result;
                                    } else { };
                                    parentPort.postMessage(["message_response", response_message], []);
                                    break;
                                }

                                case 'SIGINT': {
                                    // console.log('Got SIGINT to exit.');
                                    if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
                                        // console.log(setInterval_id);
                                        clearInterval(setInterval_id);  // 清除延時監聽動作;
                                        // console.log(setInterval_id);
                                    };
                                    response_message = {
                                        "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                        "data": '工作綫程 thread-' + require("worker_threads").threadId + " 響應主進程 thread-" + Data_JSON["threadId"] + ' 發送的 "SIGINT" 信號終止延時循環待命狀態(clear Interval); Master thread-' + Data_JSON["threadId"] + ' post "SIGINT" message stop Worker thread-' + require("worker_threads").threadId + ', unstand by clearInterval(setInterval_id).',
                                        "setInterval_id": setInterval_id,
                                        "authenticate": "",
                                        "time": ""
                                    };
                                    parentPort.postMessage(["SIGINT_response", response_message], []);
                                    // process.exit(1);
                                    break;
                                }

                                case 'exit': {
                                    // console.log('Got exit to exit.');
                                    if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
                                        // console.log(setInterval_id);
                                        clearInterval(setInterval_id);  // 清除延時監聽動作;
                                        // console.log(setInterval_id);
                                    };
                                    response_message = {
                                        "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                        "data": '工作綫程 thread-' + require("worker_threads").threadId + " 響應主進程 thread-" + Data_JSON["threadId"] + ' 發送的 "exit" 信號被終止; Master thread-' + Data_JSON["threadId"] + ' post "exit" message destruction Worker thread-' + require("worker_threads").threadId + ', process.exit(1).',
                                        "setInterval_id": setInterval_id,
                                        "authenticate": "",
                                        "time": ""
                                    };
                                    parentPort.postMessage(["exit_response", response_message], []);
                                    process.exit(1);
                                }

                                case 'error': {
                                    // response_message = {
                                    //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                    //     "data": "Post [ " + receive_message[0] + " ] unrecognized.",
                                    //     "authenticate": "",
                                    //     "time": ""
                                    // };
                                    // parentPort.postMessage(["error_response", response_message], []);
                                    break;
                                }

                                default: {
                                    response_message = {
                                        "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                        "data": "Post [ " + receive_message[0] + " ] unrecognized.",
                                        "authenticate": "",
                                        "time": ""
                                    };
                                    parentPort.postMessage(["error", response_message], []);
                                }
                            };
                        });
                    `;

                    if (Worker_threads_Script_path === "") {
                        if (Worker_threads_eval_value) {
                            Worker_threads_Script_path = Script_code;  // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時脚本參數 Worker_threads_Script_path 的預設值;
                        } else {
                            Worker_threads_Script_path = process.argv[1];  // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時脚本參數 Worker_threads_Script_path 的預設值;
                        };
                    };

                    const worker_thread = new Worker(Worker_threads_Script_path, {
                        eval: Worker_threads_eval_value,  // false <boolean> 如果為 true 且第一個參數是一個 string，則將構造函數的第一個參數解釋為工作執行緒連線後執行的腳本。
                        workerData: worker_Data  // <any> 能被克隆並作為 require('worker_threads').workerData 的任何 JavaScript 值。 克隆將會按照 HTML 結構化克隆演算法中描述的進行，如果物件無法被克隆（例如，因為它包含 function），則會拋出錯誤;
                        // argv: process.argv,  // process.argv[1] <any[]> 參數清單，其將會被字串化並附加到工作執行緒中的 process.argv。 這大部分與 workerData 相似，但是這些值將會在全域的 process.argv 中可用，就好像它們是作為 CLI 選項傳給腳本一樣;
                        // env: process.env,  // <Object> 如果設置，則指定工作執行緒中 process.env 的初始值。 作為一個特殊值，worker.SHARE_ENV 可以用於指定父執行緒和子執行緒應該共用它們的環境變數。 在這種情況下，對一個執行緒的 process.env 對象的更改也會影響另一個執行緒。 預設值: process.env;
                        // execArgv: process.execPath,  // <string[]> 傳遞給工作執行緒的 node CLI 選項的清單。 不支援 V8 選項（例如 --max-old-space-size）和影響進程的選項（例如 --title）。 如果設置，則它將會作為工作執行緒內部的 process.execArgv 提供。 預設情況下，選項將會從父執行緒繼承;
                        // stdin: true,  // <boolean> 如果將其設置為 true，則 worker.stdin 將會提供一個可寫流，其內容將會在工作執行緒中以 process.stdin 出現。 預設情況下，不提供任何資料;
                        // stdout: false,  // <boolean> 如果將其設置為 true，則 worker.stdout 將不會自動地通過管道傳遞到父執行緒中的 process.stdout;
                        // stderr: false,  // <boolean> 如果將其設置為 true，則 worker.stderr 將不會自動地通過管道傳遞到父執行緒中的 process.stderr;
                        // trackUnmanagedFds: false,  // <boolean> If this is set to true, then the Worker will track raw file descriptors managed through fs.open() and fs.close(), and close them when the Worker exits, similar to other resources like network sockets or file descriptors managed through the FileHandle API. This option is automatically inherited by all nested Workers. Default: false;
                        // transferList: [],  // <Object[]> If one or more MessagePort-like objects are passed in workerData, a transferList is required for those items or ERR_MISSING_MESSAGE_PORT_IN_TRANSFER_LIST will be thrown. See port.postMessage() for more information;
                        // resourceLimits: {
                        // // 參數 resourceLimits: 值類型為 <Object> 新的 JS 引擎實例的一組可選的資源限制。 達到這些限制將會導致終止 Worker 實例。 這些限制僅影響 JS 引擎，並且不影響任何外部資料，包括 ArrayBuffers。 即使設置了這些限制，如果遇到全域記憶體不足的情況，該進程仍可能中止;
                        //     maxOldGenerationSizeMb: 4,  // <number> 主堆的最大大小，以 MB 為單位;
                        //     maxYoungGenerationSizeMb: 4,  // <number> 最近創建的對象的堆空間的最大大小;
                        //     codeRangeSizeMb: 4,  // <number> 用於生成代碼的預分配的記憶體範圍的大小;
                        //     stackSizeMb: 4  // <number> The default maximum stack size for the thread.Small values may lead to unusable Worker instances.Default: 4;
                        // }
                    });
                    thread_Id = worker_thread.threadId;
                    worker_queues[thread_Id] = worker_thread;  // 用子綫程的 Worker.threadId 號記錄每一個創建成功的子綫程;
                    worker_free[thread_Id] = true;  // 用子綫程的 Worker.threadId 號記錄每一個創建成功的子綫程的狀態是否「空閑」;
                    total_worker_called_number[thread_Id] = parseInt(0);  // 纍加記錄每個子綫程的被調用的縂次數;

                    // 主綫程 master.threadId 監聽子綫程 worker.threadId 的創建運行成功 online 事件，用以判斷子綫程啓動是否成功;
                    worker_thread.on('online', () => {
                        console.log("Worker thread-" + thread_Id + " is online now.");
                        // worker_thread.ref();  // 通常情況下父綫程維護了一個子綫程的引用計數，只有在當子綫程退出之後，父綫程才會退出，這個引用就是 .ref()，如果調用了 .unref()方法，則允許父綫程獨立於子綫程退出;
                        // thread_Id === worker_thread.threadId;
                    });

                    worker_thread.on('error', (error) => {
                        console.log("副執行緒 thread-" + thread_Id + " 抛出錯誤 " + error + " 終止; Worker thread-" + thread_Id + " Error: " + error);
                        // worker_thread.unref();  // 通常情況下父綫程維護了一個子綫程的引用計數，只有在當子綫程退出之後，父綫程才會退出，這個引用就是 .ref()，如果調用了 .unref()方法，則允許父綫程獨立於子綫程退出;
                        worker_thread.terminate();  // 銷毀子綫程;
                        // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;
                        if (worker_queues.hasOwnProperty(thread_Id)) {
                            delete worker_queues[thread_Id];
                        };
                        // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                        if (worker_free.hasOwnProperty(thread_Id)) {
                            delete worker_free[thread_Id];
                        };
                    });

                    // 主綫程 master.threadId 監聽子綫程 worker.threadId 的退出 exit 事件，用以判斷子綫程是否出現故障關閉;
                    worker_thread.on('exit', (exitCode) => {
                        console.log("副執行緒 thread-" + thread_Id + " 返回終止碼 " + exitCode + " 中止運行; Worker thread-" + thread_Id + " exit with code: " + exitCode);
                        // worker_thread.unref();  // 通常情況下父綫程維護了一個子綫程的引用計數，只有在當子綫程退出之後，父綫程才會退出，這個引用就是 .ref()，如果調用了 .unref()方法，則允許父綫程獨立於子綫程退出;
                        // worker_thread.terminate();  // 銷毀子綫程;
                        // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;
                        if (worker_queues.hasOwnProperty(thread_Id)) {
                            delete worker_queues[thread_Id];
                        };
                        // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                        if (worker_free.hasOwnProperty(thread_Id)) {
                            delete worker_free[thread_Id];
                        };
                    });

                    // // worker_queues[worker_active_ID].once('message', (receive_message) => {});
                    // worker_thread.on('message', (receive_message) => {

                    //     // console.log(typeof (receive_message));
                    //     // console.log(receive_message);

                    //     worker_free[thread_Id] = true;
                    //     // worker_free[thread_Id].removeAllListeners('message');  // this.removeAllListeners('message');
                    //     // worker_free[thread_Id].removeAllListeners('error');  // this.removeAllListeners('error');
                    //     // worker_free[thread_Id].terminate();  // 銷毀子綫程;

                    //     let Message_status = "";
                    //     let Data_JSON = null;
                    //     if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                    //         Message_status = 'message_response';
                    //         Data_JSON = receive_message[0];
                    //     } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                    //         Message_status = receive_message[0];
                    //         Data_JSON = receive_message[1];
                    //     } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                    //         Message_status = receive_message[0];
                    //         let Data_Array = [];
                    //         for (let i = 1; i < receive_message.length; i++) {
                    //             Data_Array.push(receive_message[i]);
                    //         };
                    //     } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                    //         Message_status = 'message_response';
                    //         Data_JSON = receive_message;
                    //         // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'error' && receive_message !== 'error_response') {
                    //         //     Message_status = 'message_response';
                    //         //     Data_JSON = receive_message;
                    //     } else {
                    //         Message_status = receive_message;
                    //     };
                    //     // console.log(Message_status);
                    //     // console.log(Data_JSON);

                    //     switch (Message_status) {

                    //         case 'standby_response': {
                    //             console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             break;
                    //         }

                    //         case 'message_response': {

                    //             // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);

                    //             if (Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object string]') {
                    //                 console.log("read file do Function error: " + Data_JSON);
                    //             };

                    //             if (typeof (Data_JSON) === 'object' && Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object object]' && !(Data_JSON.length)) {
                    //                 // console.log(Data_JSON);
                    //                 result = Data_JSON["data"];
                    //                 // Data_JSON === {
                    //                 //     "threadId": String(require('worker_threads').threadId),
                    //                 //     "monitor_file": Data_JSON.monitor_file,
                    //                 //     "result": result[0],
                    //                 //     "output_file": result[1]
                    //                 // };

                    //                 output_queues_array.push(Data_JSON["output_file"]);
                    //                 // console.log(output_queues_array);

                    //                 // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 在已處理完數據後，是否已經從硬盤刪除;
                    //                 file_bool = false;
                    //                 try {
                    //                     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                    //                     file_bool = fs.existsSync(Data_JSON["monitor_file"]) && fs.statSync(Data_JSON["monitor_file"], { bigint: false }).isFile();
                    //                     // console.log("文檔: " + Data_JSON["monitor_file"] + " 存在.");
                    //                 } catch (error) {
                    //                     console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 是否存在.");
                    //                     console.error(error);
                    //                     return Data_JSON["monitor_file"];
                    //                 };
                    //                 // 同步判斷，使用Node.js原生模組fs的fs.existsSync(input_queues_array[0]["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                    //                 if (file_bool) {

                    //                     // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    //                     try {
                    //                         // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    //                         fs.accessSync(Data_JSON["monitor_file"], fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    //                         // console.log("文檔: " + Data_JSON["monitor_file"] + " 可以讀寫.");
                    //                     } catch (error) {
                    //                         // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    //                         try {
                    //                             // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                    //                             fs.fchmodSync(Data_JSON["monitor_file"], fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                    //                             // console.log("文檔: " + Data_JSON["monitor_file"] + " 操作權限修改為可以讀寫.");
                    //                             // 常量                    八進制值    說明
                    //                             // fs.constants.S_IRUSR    0o400      所有者可讀
                    //                             // fs.constants.S_IWUSR    0o200      所有者可寫
                    //                             // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                    //                             // fs.constants.S_IRGRP    0o40       群組可讀
                    //                             // fs.constants.S_IWGRP    0o20       群組可寫
                    //                             // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                    //                             // fs.constants.S_IROTH    0o4        其他人可讀
                    //                             // fs.constants.S_IWOTH    0o2        其他人可寫
                    //                             // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                    //                             // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    //                             // 數字	說明
                    //                             // 7	可讀、可寫、可執行
                    //                             // 6	可讀、可寫
                    //                             // 5	可讀、可執行
                    //                             // 4	唯讀
                    //                             // 3	可寫、可執行
                    //                             // 2	只寫
                    //                             // 1	只可執行
                    //                             // 0	沒有許可權
                    //                             // 例如，八進制值 0o765 表示：
                    //                             // 1) 、所有者可以讀取、寫入和執行該文檔；
                    //                             // 2) 、群組可以讀和寫入該文檔；
                    //                             // 3) 、其他人可以讀取和執行該文檔；
                    //                             // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    //                             // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    //                         } catch (error) {
                    //                             console.error("用於傳入數據的臨時暫存媒介文檔 [ " + Data_JSON["monitor_file"] + " ] 無法修改為可讀可寫權限.");
                    //                             console.error(error);
                    //                             return Data_JSON["monitor_file"];
                    //                         };
                    //                     };

                    //                     // 同步刪除，用於臨時接收傳值的媒介文檔;
                    //                     try {
                    //                         fs.unlinkSync(Data_JSON["monitor_file"]);  // 同步刪除，返回值為 undefined;
                    //                         // console.error("用於臨時接收數據的媒介文檔: " + Data_JSON["monitor_file"] + " 已被刪除.");
                    //                         // console.log(fs.readdirSync(Data_JSON["monitor_file"], { encoding: "utf8", withFileTypes: false }));
                    //                     } catch (error) {
                    //                         console.error("用於臨時接收數據的媒介文檔: " + Data_JSON["monitor_file"] + " 無法刪除.");
                    //                         console.error(error);
                    //                         return Data_JSON["monitor_file"];
                    //                     };

                    //                     // 判斷用於傳入數據的臨時媒介文檔序列第一位 input_queues_array[0]["monitor_file"] 是否已經從硬盤刪除;
                    //                     file_bool = false;
                    //                     try {
                    //                         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                    //                         file_bool = fs.existsSync(Data_JSON["monitor_file"]) && fs.statSync(Data_JSON["monitor_file"], { bigint: false }).isFile();
                    //                         // console.log("文檔: " + Data_JSON["monitor_file"] + " 存在.");
                    //                     } catch (error) {
                    //                         console.error("無法確定用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 是否存在.");
                    //                         console.error(error);
                    //                         return Data_JSON["monitor_file"];
                    //                     };
                    //                     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Data_JSON["monitor_file"])方法判斷目錄或文檔是否存在以及是否為文檔;
                    //                     if (file_bool) {
                    //                         console.error("用於傳入數據的臨時媒介文檔序列第一位: " + Data_JSON["monitor_file"] + " 無法刪除.");
                    //                         return Data_JSON["monitor_file"];
                    //                     };
                    //                 };
                    //             };
                    //             break;
                    //         }

                    //         case 'SIGINT_response': {

                    //             // console.log(Data_JSON["threadId"]);
                    //             console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             console.log("Worker thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                    //             // console.log('副執行緒 thread-' + Data_JSON["threadId"] + " 響應主執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "SIGINT" 信號中止運行; Master thread-' + require("worker_threads").threadId + ' post "SIGINT" message exit Worker thread-' + Data_JSON["threadId"] + '.');

                    //             // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                    //             // if (worker_queues.hasOwnProperty(Data_JSON["threadId"])) {
                    //             //     delete worker_queues[Data_JSON["threadId"]];
                    //             // };
                    //             // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                    //             // if (worker_free.hasOwnProperty(Data_JSON["threadId"])) {
                    //             //     delete worker_free[Data_JSON["threadId"]];
                    //             // };

                    //             // worker_queues[Data_JSON["threadId"]].terminate();  // 銷毀子綫程;
                    //             break;
                    //         }

                    //         case 'exit_response': {

                    //             // console.log(Data_JSON["threadId"]);
                    //             console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             console.log("Worker thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                    //             // console.log('副執行緒 thread-' + Data_JSON["threadId"] + " 響應主執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "exit" 信號中止運行; Master thread-' + require("worker_threads").threadId + ' post "SIGINT" message exit Worker thread-' + Data_JSON["threadId"] + '.');

                    //             // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                    //             // if (worker_queues.hasOwnProperty(Data_JSON["threadId"])) {
                    //             //     delete worker_queues[Data_JSON["threadId"]];
                    //             // };
                    //             // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經退出 'exit' 的子綫程;
                    //             // if (worker_free.hasOwnProperty(Data_JSON["threadId"])) {
                    //             //     delete worker_free[Data_JSON["threadId"]];
                    //             // };

                    //             // worker_queues[Data_JSON["threadId"]].terminate();  // 銷毀子綫程;
                    //             break;
                    //         }

                    //         case 'error_response': {
                    //             console.log(receive_message);
                    //             // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             break;
                    //         }
                    //         case 'error': {
                    //             console.log(receive_message);
                    //             // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             break;
                    //         }
                    //         default: {
                    //             console.log(receive_message);
                    //             // console.log("Worker thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //         }
                    //     };
                    // });

                    // worker_thread.postMessage(['standby', { "thread_Id": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling Stand by.", "delay": 5000 }], []);
                    // worker_thread.postMessage(['SIGINT', { "thread_Id": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling Unstand by."}], []);
                    // worker_thread.postMessage(['exit', { "thread_Id": require('worker_threads').threadId, "data": "Master thread-" + require('worker_threads').threadId + " calling exit."}], []);
                    // worker_thread.postMessage(['message', worker_Data], []);

                    // worker_thread.on('message', (event) => {
                    //     // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組;
                    //     result = event.data;
                    //     console.log(event.data);  // worker_Data;
                    //     console.log(event.ports);  // [port];

                    //     this.removeAllListeners('message');
                    //     this.removeAllListeners('error');
                    //     // this.terminate();  // 銷毀子綫程;
                    // });

                } catch (error) {
                    console.log("Create worker thread failure !");
                    console.error(error);
                } finally {};

                // try {
                //     const Message_Channel = new MessageChannel();  // { port1, port2 };
                //     Message_Channel_queues[thread_Id] = Message_Channel;
                //     worker_queues[1].postMessage("from Master to Worker1", [Message_Channel_queues[1].port1]);  // 第二個參數用於轉移對象所有權，被轉移後，在發送它的上下文中將變得不可用，並且只有在它被發送到的worker中可用;
                //     worker_queues[2].postMessage("from Master to Worker2", [Message_Channel_queues[1].port2]);  // 第二個參數用於轉移對象所有權，被轉移後，在發送它的上下文中將變得不可用，並且只有在它被發送到的worker中可用;
                //     // 在子綫程 Worker 1 中寫入如下代碼，可以接收到有主綫程轉移過來的 port2 端口;
                //     if (require('worker_threads').threadId === 1) {
                //         parentPort.on('message', (event) => {
                //             console.log(event.data);  // worker_Data;
                //             console.log(event.ports);  // [port2];
                //             const port = event.ports[0];
                //             port.on('message', (event) => {
                //                 console.log(event.data);  // worker_Data;
                //                 console.log(event.ports);  // [port2];
                //                 const port = event.ports[0];
                //                 port.postMessage("this is Worker thread-" + require('worker_threads').threadId + " response.");
                //             });
                //             port.postMessage("this is Worker thread-" + require('worker_threads').threadId + " calling.");
                //         });                        
                //     };
                //     // 在子綫程 Worker 2 中寫入如下代碼，可以接收到有主綫程轉移過來的 port2 端口;
                //     if (require('worker_threads').threadId === 2) {
                //         parentPort.on('message', (event) => {
                //             console.log(event.data);  // worker_Data;
                //             console.log(event.ports);  // [port2];
                //             const port = event.ports[0];
                //             port.on('message', (event) => {
                //                 console.log(event.data);  // worker_Data;
                //                 console.log(event.ports);  // [port2];
                //                 const port = event.ports[0];
                //                 port.postMessage("this is Worker thread-" + require('worker_threads').threadId + " response.");
                //             });
                //             port.postMessage("this is Worker thread-" + require('worker_threads').threadId + " calling.");
                //         });
                //     };
                // } catch (error) {
                //     console.log("Create Message Channel failure !");
                //     console.error(error);
                // } finally {};
            };

            // // web worker 兄弟綫程通信;
            // let worker1 = new Worker('./worker1.js');
            // let worker2 = new Worker('./worker2.js');
            // let ms = new MessageChannel();

            // // 把 port1 分配給 worker1
            // worker1.postMessage('main', [ms.port1]);
            // // 把 port2 分配給 worker2
            // worker2.postMessage('main', [ms.port2]);

            // //worker1.js
            // self.onmessage = function (e) {
            //     console.log('worker1', e.ports);
            //     if (e.data === 'main') {
            //         const port = e.ports[0];
            //         port.postMessage(`worker1: Hi! I'm worker1`);
            //         port.onmessage = function (ev) {
            //             console.log('reveice: ', ev.data, ev.origin);
            //         }
            //     }
            // }

            // //worker2.js
            // self.onmessage = function (e) {
            //     if (e.data === 'main') {
            //         const port = e.ports[0];
            //         port.onmessage = function (e) {
            //             console.log('receive: ', e.data);
            //             port.postMessage('worker2: ' + e.data);
            //         }
            //     }
            // }
        };

        // // 子綫程(副執行緒) Worker thread 中運行的代碼;
        // if (!require('worker_threads').isMainThread) {

        //     if (require('worker_threads').isMainThread) { throw new Error('isMainThread: ' + require('worker_threads').isMainThread + ', threadId-' + require('worker_threads').threadId + ' is not a worker.') };
        //     const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組;
        //     const { AsyncResource } = require('async_hooks');  // 導入 Node.js 原生異步鈎子模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
        //     const { EventEmitter } = require('events');  // 導入 Node.js 原生事件模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;

        //     const child_process = require('child_process');  // Node原生的創建子進程模組;
        //     const os = require('os');  // Node原生的操作系統信息模組;
        //     const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
        //     const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;

        //     // 自定義封裝的函數isStringJSON(str)判斷一個字符串是否爲 JSON 格式的字符串;
        //     function isStringJSON(str) {
        //         // 首先判斷傳入參數 str 是否為一個字符串 typeof (str) === 'string'，如果不是字符串直接返回錯誤;
        //         if (Object.prototype.toString.call(str).toLowerCase() === '[object string]') {
        //             try {
        //                 let Obj = JSON.parse(str);
        //                 // 使用語句 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) 判斷 Obj 是否為一個 JSON 對象;
        //                 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) {
        //                     return true;
        //                 } else {
        //                     return false;
        //                 };
        //             } catch (error) {
        //                 // console.log(error);
        //                 return false;
        //             } finally { };
        //         } else {
        //             // console.log("It is not a String!");
        //             return false;
        //         };
        //     };

        //     if (typeof (workerData["read_file_do_Function"]) !== undefined && workerData["read_file_do_Function"] !== undefined && workerData["read_file_do_Function"] !== null && workerData["read_file_do_Function"] !== "" && Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(workerData["read_file_do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("read_file_do_Function = " + workerData["read_file_do_Function"] + ';')).toLowerCase() === '[object function]')) {
        //         // 以 let mytFunc = function (argument) {} 形式的函數傳值;
        //         eval("read_file_do_Function = " + workerData["read_file_do_Function"] + ";");
        //     } else if (typeof (workerData["read_file_do_Function"]) !== undefined && workerData["read_file_do_Function"] !== undefined && workerData["read_file_do_Function"] !== null && workerData["read_file_do_Function"] !== "" && Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object string]') {
        //         // 以 function mytFunc(argument) {} 形式的函數傳值;
        //         eval(workerData["read_file_do_Function"]);
        //         // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
        //         // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
        //         eval("read_file_do_Function = " + workerData["read_file_do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //         // eval("read_file_do_Function = " + workerData["read_file_do_Function"].substring(workerData["read_file_do_Function"].indexOf('function') + 9, workerData["read_file_do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //     } else {
        //         // console.log("傳入的用於處理數據的函數參數 read_file_do_Function: " + workerData["read_file_do_Function"] + " 無法識別.");
        //         read_file_do_Function = function (argument) { return argument; };
        //     };

        //     if (typeof (workerData["do_Function"]) !== undefined && workerData["do_Function"] !== undefined && workerData["do_Function"] !== null && workerData["do_Function"] !== "" && Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(workerData["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + workerData["do_Function"] + ';')).toLowerCase() === '[object function]')) {
        //         // 以 let mytFunc = function (argument) {} 形式的函數傳值;
        //         eval("do_Function = " + workerData["do_Function"] + ";");
        //     } else if (typeof (workerData["do_Function"]) !== undefined && workerData["do_Function"] !== undefined && workerData["do_Function"] !== null && workerData["do_Function"] !== "" && Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object string]') {
        //         // 以 function mytFunc(argument) {} 形式的函數傳值;
        //         eval(workerData["do_Function"]);
        //         // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
        //         // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
        //         eval("do_Function = " + workerData["do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //         // eval("do_Function = " + workerData["do_Function"].substring(workerData["do_Function"].indexOf('function') + 9, workerData["do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //     } else {
        //         // console.log("傳入的用於處理數據的函數參數 do_Function: " + workerData["do_Function"] + " 無法識別.");
        //         do_Function = function (argument) { return argument; };
        //     };

        //     // 創建延時循環，使子綫程一直處於運行狀態，不至於運行完畢被銷毀 setInterval_id = setInterval(function(){}, delay)，清楚循環 clearInterval(setInterval_id);
        //     let setInterval_id = null;  // 子綫程延時待命的循環對象;
        //     let delay = null;  //延遲時長，單位毫秒;
        //     // setInterval_id = setInterval(function () {}, delay);  // 延時循環等待;

        //     let response_message = null;
        //     // response_message = read_file_do_Function(workerData.monitor_file, workerData.monitor_dir, workerData.do_Function, workerData.output_dir, workerData.output_file, workerData.to_executable, workerData.to_script);
        //     // const port = message.ports[0];
        //     // port.postMessage(response_message, []);
        //     // // read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script);

        //     // // 首次向主綫程 Master thread 發送響應;
        //     // response_message = {
        //     //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //     //     "data": "Worker thread-" + require('worker_threads').threadId + " Stand by Pooling delay " + delay + " ms ...",
        //     //     "setInterval_id": setInterval_id
        //     // };
        //     // parentPort.postMessage(["standby_response", response_message], []);

        //     // 監聽主綫程 Master thread 發送的信號;
        //     // 在子綫程中注冊監聽 parentPort.on('message', (data) => {}) 事件，會使子綫程處於等待狀態，執行完畢也不被銷毀，從而實現，子綫程的「池化」效果，使用子綫程池技術，與頻繁創建銷毀子綫程相比，效率更高;
        //     parentPort.on('message', (receive_message) => {

        //         // console.log(typeof (receive_message));
        //         // console.log(receive_message);
        //         // parentPort.postMessage(["message_response", receive_message], []);

        //         let Message_status = "";
        //         let Data_JSON = null;
        //         if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
        //             Message_status = 'message';
        //             Data_JSON = receive_message[0];
        //         } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
        //             Message_status = receive_message[0];
        //             Data_JSON = receive_message[1];
        //         } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
        //             Message_status = receive_message[0];
        //             let Data_Array = [];
        //             for (let i = 1; i < receive_message.length; i++) {
        //                 Data_Array.push(receive_message[i]);
        //             };
        //         } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
        //             Message_status = 'message';
        //             Data_JSON = receive_message;
        //             // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'SIGINT' && receive_message !== 'error') {
        //             //     Message_status = 'message';
        //             //     Data_JSON = receive_message;
        //         } else {
        //             Message_status = receive_message;
        //         };

        //         // if (typeof (Data_JSON["read_file_do_Function"]) !== undefined && Data_JSON["read_file_do_Function"] !== undefined && Data_JSON["read_file_do_Function"] !== null && Data_JSON["read_file_do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["read_file_do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["read_file_do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"] + ';')).toLowerCase() === '[object function]')) {
        //         // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
        //         //     eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"] + ";");
        //         // } else if (typeof (Data_JSON["read_file_do_Function"]) !== undefined && Data_JSON["read_file_do_Function"] !== undefined && Data_JSON["read_file_do_Function"] !== null && Data_JSON["read_file_do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["read_file_do_Function"]).toLowerCase() === '[object string]') {
        //         // // 以 function mytFunc(argument) {} 形式的函數傳值;
        //         //     eval(Data_JSON["read_file_do_Function"]);
        //         //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
        //         //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
        //         //     eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //         //     // eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"].substring(Data_JSON["read_file_do_Function"].indexOf('function') + 9, Data_JSON["read_file_do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //         // } else {
        //         //     // console.log("傳入的用於處理數據的函數參數 read_file_do_Function: " + Data_JSON["read_file_do_Function"] + " 無法識別.");
        //         //     read_file_do_Function = function (argument) { return argument; };
        //         // };

        //         // if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + Data_JSON["do_Function"] + ';')).toLowerCase() === '[object function]')) {
        //         // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
        //         //     eval("do_Function = " + Data_JSON["do_Function"] + ";");
        //         // } else if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]') {
        //         // // 以 function mytFunc(argument) {} 形式的函數傳值;
        //         //     eval(Data_JSON["do_Function"]);
        //         //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
        //         //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
        //         //     eval("do_Function = " + Data_JSON["do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //         //     // eval("do_Function = " + Data_JSON["do_Function"].substring(Data_JSON["do_Function"].indexOf('function') + 9, Data_JSON["do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
        //         // } else {
        //         //     // console.log("傳入的用於處理數據的函數參數 do_Function: " + Data_JSON["do_Function"] + " 無法識別.");
        //         //     do_Function = function (argument) { return argument; };
        //         // };

        //         switch (Message_status) {

        //             case 'standby': {
        //                 delay = parseInt(Data_JSON["delay"]);  // 500 延遲時長，單位毫秒;
        //                 if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
        //                     // console.log(setInterval_id);
        //                     clearInterval(setInterval_id);  // 清除延時監聽動作;
        //                     // console.log(setInterval_id);
        //                 };
        //                 setInterval_id = setInterval(function () { }, delay);  // 延時循環等待;
        //                 // console.log(setInterval_id)
        //                 // clearInterval(setInterval_id);  // 清除延時監聽動作;

        //                 // console.log("Worker thread-" + require('worker_threads').threadId + " stand by Pooling ...");

        //                 response_message = {
        //                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //                     "data": "Worker thread-" + require('worker_threads').threadId + " stand by Pooling ...",
        //                     "setInterval_id": setInterval_id,
        //                 };
        //                 parentPort.postMessage(["standby_response", response_message], []);
        //                 break;
        //             }

        //             case 'message': {
        //                 let result = read_file_do_Function(Data_JSON.monitor_file, Data_JSON.monitor_dir, do_Function, Data_JSON.output_dir, Data_JSON.output_file, Data_JSON.to_executable, Data_JSON.to_script);
        //                 if (Object.prototype.toString.call(result).toLowerCase() === '[object array]') {
        //                     response_message = {
        //                         "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //                         "monitor_file": Data_JSON.monitor_file,
        //                         "data": result[0],
        //                         "output_file": result[1]
        //                     };
        //                 } else if (Object.prototype.toString.call(result).toLowerCase() === '[object string]') {
        //                     response_message = result;
        //                 } else { };
        //                 parentPort.postMessage(["message_response", response_message], []);
        //                 break;
        //             }

        //             case 'SIGINT': {
        //                 // console.log('Got SIGINT to exit.');
        //                 if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
        //                     // console.log(setInterval_id);
        //                     clearInterval(setInterval_id);  // 清除延時監聽動作;
        //                     // console.log(setInterval_id);
        //                 };
        //                 response_message = {
        //                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //                     "data": '副執行緒 thread-' + require("worker_threads").threadId + " 響應主執行緒 thread-" + Data_JSON["threadId"] + ' 發送的 "SIGINT" 信號中止延時循環待命狀態(clear Interval); Master thread-' + Data_JSON["threadId"] + ' post "SIGINT" message stop Worker thread-' + require("worker_threads").threadId + ', unstand by clearInterval(setInterval_id).',
        //                     "setInterval_id": setInterval_id
        //                 };
        //                 parentPort.postMessage(["SIGINT_response", response_message], []);
        //                 // process.exit(1);
        //                 break;
        //             }

        //             case 'exit': {
        //                 // console.log('Got exit to exit.');
        //                 if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
        //                     // console.log(setInterval_id);
        //                     clearInterval(setInterval_id);  // 清除延時監聽動作;
        //                     // console.log(setInterval_id);
        //                 };
        //                 response_message = {
        //                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //                     "data": '副執行緒 thread-' + require("worker_threads").threadId + " 響應主執行緒 thread-" + Data_JSON["threadId"] + ' 發送的 "exit" 信號中止運行; Master thread-' + Data_JSON["threadId"] + ' post "exit" message destruction Worker thread-' + require("worker_threads").threadId + ', process.exit(1).',
        //                     "setInterval_id": setInterval_id
        //                 };
        //                 parentPort.postMessage(["exit_response", response_message], []);
        //                 process.exit(1);
        //             }

        //             case 'error': {
        //                 // response_message = {
        //                 //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //                 //     "data": "Post [ " + receive_message[0] + " ] unrecognized."
        //                 // };
        //                 // parentPort.postMessage(["error_response", response_message], []);
        //                 break;
        //             }

        //             default: {
        //                 response_message = {
        //                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
        //                     "data": "Post [ " + receive_message[0] + " ] unrecognized."
        //                 };
        //                 parentPort.postMessage(["error", response_message], []);
        //             }
        //         };
        //     });
        // };

        return [worker_queues, worker_free, Message_Channel_queues, total_worker_called_number];
    };    

    function Run(is_monitor, temp_NodeJS_cache_IO_data_dir, monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value) {
        // console.log("當前進程編號: " + process.pid);
        // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
        // console.log("當前進程使用的内存: " + process.memoryUsage());
        // console.log("運行當前進程的操作系統平臺: " + process.platform);
        // console.log("運行當前進程的操作系統架構: " + process.arch);
        // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
        // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
        // console.log("當前進程的用戶環境: " + process.env);
        // console.log("當前進程的工作目錄: " + process.cwd());
        // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
        // console.log("運行當前進程的運行時間: " + process.uptime());
        // console.log("當前進程編號: process-" + process.pid + " , 當前執行緒編號: thread-" + require('worker_threads').threadId);

        // let server_setInterval_id = null;
        // let result_Array = [];
        if (is_monitor) {

            // console.log("進程: process-" + process.pid + " , 執行緒: thread-" + require('worker_threads').threadId + " 正在監聽目錄「 " + monitor_dir + " 」文檔「 " + require('path').basename(monitor_file) + " 」 ...");
            console.log("process-" + process.pid + " > thread-" + require('worker_threads').threadId + " listening on directory [ " + monitor_dir + " ] file [ " + require('path').basename(monitor_file) + " ] ...");
            console.log("Cache directory [ " + temp_NodeJS_cache_IO_data_dir + " ].");
            console.log("Export at the directory [ " + output_dir + " ] file [ " + require('path').basename(output_file) + " ].");
            console.log('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.');
            console.log('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.');
            console.log("Keyboard Enter [ Ctrl ] + [ c ] to close.");
            console.log("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.");

            if (require('worker_threads').isMainThread) {
                // 當未捕獲的 JavaScript 異常冒泡回到事件循環時，則會觸發 'uncaughtException' 事件;
                process.on("uncaughtException", (error, origin) => {
                    console.log("未捕獲異常: " + error);
                    console.log("異常來源: " + origin);
                    // console.error(error);
                    // let arr = new Array;
                    // Object.keys(worker_queues).forEach((id) => {
                    //     arr.push("thread-" + id);
                    //     worker_queues[id].postMessage(["SIGINT", "Master thread .on('beforeExit')."], []);
                    //     worker_queues[id].terminate();  // 銷毀子綫程;
                    // });
                    // console.log("正在運行的子綫程: " + arr);
                    // worker_queues = [];
                    // worker_free = [];
                    // process.exit(1);
                });
                // throw new Error("I am tired...");  // 故意抛出一個異常測試;

                // 監聽 'SIGINT' 信號，當 Node.js 進程接收到 'SIGINT' 信號時，會觸發該事件;
                // 'SIGHUP' 信號在 Windows 平臺上當控制臺使用鍵盤輸入 [ Ctrl ] + [ c ] 窗口被關閉時會被觸發，在其它平臺上在相似的條件下也會被觸發;
                process.on('SIGINT', function () {

                    // 監聽 'SIGINT' 信號事件，使用鍵盤輸入 [ Ctrl ] + [ c ] 中止進程運行，不會激活 'beforeExit' 事件，而直接激活 'exit' 事件;
                    console.log("[ Ctrl ] + [ c ] received, shutting down the monitor server.");  // "Master process-" + process.pid + " Master thread-" + require('worker_threads').threadId
                    if (typeof (server_setInterval_id) === 'object' && Object.prototype.toString.call(server_setInterval_id).toLowerCase() === '[object object]' && !(server_setInterval_id.length) && server_setInterval_id["_onTimeout"] !== null) {
                        // console.log(server_setInterval_id);
                        clearInterval(server_setInterval_id);  // 清除延時監聽動作;
                        // console.log(server_setInterval_id);
                        console.log("clear Interval, monitor server will be exit.");
                    };

                    // 打印進程被調用數目;
                    if (typeof (total_worker_called_number) === 'object' && Object.prototype.toString.call(total_worker_called_number).toLowerCase() === '[object object]' && !(total_worker_called_number.length)) {
                        if (Object.keys(total_worker_called_number).length > 0) {
                            let arr = new Array;
                            Object.keys(total_worker_called_number).forEach((id) => {
                                if (String(id) === String(require('worker_threads').threadId)) {
                                    console.log("正在運行的進程: process-" + process.pid + " thread-" + require('worker_threads').threadId + " [ " + total_worker_called_number[id] + " ].");
                                } else {
                                    if (worker_queues[id] !== undefined && worker_queues[id] !== null && worker_queues[id] !== "") {
                                        arr.push("thread-".concat(id, "(Runing)", " [ ", total_worker_called_number[id], " ]"));
                                    } else {
                                        arr.push("thread-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                                    };
                                };
                            });
                            if (arr.length > 0) { console.log("副執行緒: Worker " + arr); };
                        };
                    };

                    // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                    if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                        if (Object.keys(worker_queues).length > 0) {
                            Object.keys(worker_queues).forEach((id) => {
                                worker_queues[id].postMessage(["exit", "Master thread .on('beforeExit')."], []);
                                // worker_queues[id].terminate();  // 銷毀子綫程;
                                // console.log("副執行緒 thread-" + id + " 已中止運行, Worker thread-" + id + " be exit. 「 .terminate() 」");
                                // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .terminate() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                                // delete worker_queues[id];
                                // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經使用 .terminate() 方法退出 'exit' 的子綫程 worker_free.hasOwnProperty(id);
                                // delete worker_free[id];
                            });
                        };
                    };

                    // 注意當注冊了監聽 'SIGINT' 信號事件時，使用鍵盤輸入 [ Ctrl ] + [ c ] 不會自動中止進程，需要手動調用 process.exit([code]) 方法來中止進程;
                    process.exit(1);
                });

                // 配置中止主綫程前的最後一個動作;
                process.on('beforeExit', (code) => {

                    // if (typeof (server_setInterval_id) === 'object' && Object.prototype.toString.call(server_setInterval_id).toLowerCase() === '[object object]' && !(server_setInterval_id.length) && server_setInterval_id["_onTimeout"] !== null) {
                    //     // console.log(server_setInterval_id);
                    //     clearInterval(server_setInterval_id);  // 清除延時監聽動作;
                    //     // console.log(server_setInterval_id);
                    //     console.log("clear Interval, monitor server be exit.");
                    // };

                    // // 打印進程被調用數目;
                    // if (typeof (total_worker_called_number) === 'object' && Object.prototype.toString.call(total_worker_called_number).toLowerCase() === '[object object]' && !(total_worker_called_number.length)) {
                    //     if (Object.keys(total_worker_called_number).length > 0) {
                    //         let arr = new Array;
                    //         Object.keys(total_worker_called_number).forEach((id) => {
                    //             if (String(id) === String(require('worker_threads').threadId)) {
                    //                 console.log("正在運行的進程: process-" + process.pid + " thread-" + require('worker_threads').threadId + " [ " + total_worker_called_number[id] + " ].");
                    //             } else {
                    //                 if (worker_queues[id] !== undefined && worker_queues[id] !== null && worker_queues[id] !== "") {
                    //                     arr.push("thread-".concat(id, "(Runing)", " [ ", total_worker_called_number[id], " ]"));
                    //                 } else {
                    //                     arr.push("thread-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                    //                 };
                    //             };
                    //         });
                    //         if (arr.length > 0) { console.log("副執行緒: Worker " + arr); };
                    //     };
                    // };

                    // // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                    // if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                    //     if (Object.keys(worker_queues).length > 0) {
                    //         Object.keys(worker_queues).forEach((id) => {
                    //             // worker_queues[id].postMessage(["exit", "Master thread .on('beforeExit')."], []);
                    //             worker_queues[id].terminate();  // 銷毀子綫程;
                    //             // console.log("副執行緒 thread-" + id + " 已中止運行, Worker thread-" + id + " be exit. 「 .terminate() 」");
                    //             // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .terminate() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                    //             delete worker_queues[id];
                    //             // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經使用 .terminate() 方法退出 'exit' 的子綫程 worker_free.hasOwnProperty(id);
                    //             delete worker_free[id];
                    //         });
                    //     };
                    // };

                    // // 判斷當用於暫存數據的媒介目錄文件夾，與用於傳出數據的媒介目錄文件夾不是同一個文件夾時，程序退出時清空用於暫存數據的媒介文件夾;
                    // if (temp_NodeJS_cache_IO_data_dir !== output_dir) {
                    //     // 同步判斷，判斷數據文檔暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir 是否存在;
                    //     let file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                    //     try {
                    //         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Directory)方法判斷目錄或文檔是否存在以及是否為文檔;
                    //         file_bool = fs.existsSync(temp_NodeJS_cache_IO_data_dir) && fs.statSync(temp_NodeJS_cache_IO_data_dir, { bigint: false }).isDirectory();
                    //         // console.log("目錄: " + temp_NodeJS_cache_IO_data_dir + " 存在.");
                    //     } catch (error) {
                    //         console.error("無法確定用於輸入和輸出的數據文檔暫存媒介文件夾: " + temp_NodeJS_cache_IO_data_dir + " 是否存在.");
                    //         console.error(error);
                    //         return temp_NodeJS_cache_IO_data_dir;
                    //     };
                    //     // 刪除清空，清空數據文檔暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir ;
                    //     if (file_bool) {
                    //         // 同步刪除清空，清空數據文檔暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir ;
                    //         let files = require('fs').readdirSync(temp_NodeJS_cache_IO_data_dir); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                    //         if (files.length > 0) {
                    //             for (let i = 0; i < files.length; i++) {
                    //                 deleteDirSync(require('path').join(temp_NodeJS_cache_IO_data_dir, files[i]));  // 自定義函數遞歸刪除文件夾;
                    //             };
                    //             console.log("用於輸入和輸出的數據文檔暫存媒介目錄: " + temp_NodeJS_cache_IO_data_dir + " 已清空 " + files.length + " 個子項.");
                    //         };
                    //     };
                    // };

                    // // 判斷當用於傳入數據的媒介目錄文件夾，與用於傳出數據的媒介目錄文件夾不是同一個文件夾時，程序退出時清空用於傳入數據的媒介文件夾;
                    // if (monitor_dir !== output_dir) {
                    //     // 同步判斷，判斷數據文檔傳入媒介文件夾 monitor_dir 是否存在;
                    //     file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                    //     try {
                    //         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Directory)方法判斷目錄或文檔是否存在以及是否為文檔;
                    //         file_bool = fs.existsSync(monitor_dir) && fs.statSync(monitor_dir, { bigint: false }).isDirectory();
                    //         // console.log("目錄: " + monitor_dir + " 存在.");
                    //     } catch (error) {
                    //         console.error("無法確定用於輸入數據文檔的媒介文件夾: " + monitor_dir + " 是否存在.");
                    //         console.error(error);
                    //         return monitor_dir;
                    //     };
                    //     // 刪除清空，清空數據文檔傳入媒介文件夾 monitor_dir ;
                    //     if (file_bool) {
                    //         // 同步刪除清空，清空數據文檔傳入媒介文件夾 monitor_dir ;
                    //         let files = require('fs').readdirSync(monitor_dir); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                    //         if (files.length > 0) {
                    //             for (let i = 0; i < files.length; i++) {
                    //                 deleteDirSync(require('path').join(monitor_dir, files[i]));  // 自定義函數遞歸刪除文件夾;
                    //             };
                    //             console.log("用於輸入數據文檔的媒介目錄: " + monitor_dir + " 已清空 " + files.length + " 個子項.");
                    //         };
                    //     };
                    // };

                    // // 同步判斷，判斷數據文檔傳出媒介文件夾 output_dir 是否存在;
                    // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                    // try {
                    //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Directory)方法判斷目錄或文檔是否存在以及是否為文檔;
                    //     file_bool = fs.existsSync(output_dir) && fs.statSync(output_dir, { bigint: false }).isDirectory();
                    //     // console.log("目錄: " + output_dir + " 存在.");
                    // } catch (error) {
                    //     console.error("無法確定用於輸出數據文檔的媒介文件夾: " + output_dir + " 是否存在.");
                    //     console.error(error);
                    //     return output_dir;
                    // };
                    // // 刪除清空，清空數據文檔傳出媒介文件夾 output_dir ;
                    // if (file_bool) {
                    //     // 同步刪除清空，清空數據文檔傳出媒介文件夾 output_dir ;
                    //     let files = require('fs').readdirSync(output_dir); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                    //     if (files.length > 0) {
                    //         for (let i = 0; i < files.length; i++) {
                    //             deleteDirSync(require('path').join(output_dir, files[i]));  // 自定義函數遞歸刪除文件夾;
                    //         };
                    //         console.log("用於輸出數據文檔的媒介目錄: " + output_dir + " 已清空 " + files.length + " 個子項.");
                    //     };
                    // };
                });

                // 監聽主進程的退出 'exit' 事件;
                process.on('exit', (code) => {

                    if (typeof (server_setInterval_id) === 'object' && Object.prototype.toString.call(server_setInterval_id).toLowerCase() === '[object object]' && !(server_setInterval_id.length) && server_setInterval_id["_onTimeout"] !== null) {
                        // console.log(server_setInterval_id);
                        clearInterval(server_setInterval_id);  // 清除延時監聽動作;
                        // console.log(server_setInterval_id);
                        console.log("clear Interval, monitor server be exit.");
                    };

                    // // 打印進程被調用數目;
                    // if (typeof (total_worker_called_number) === 'object' && Object.prototype.toString.call(total_worker_called_number).toLowerCase() === '[object object]' && !(total_worker_called_number.length)) {
                    //     if (Object.keys(total_worker_called_number).length > 0) {
                    //         let arr = new Array;
                    //         Object.keys(total_worker_called_number).forEach((id) => {
                    //             if (String(id) === String(require('worker_threads').threadId)) {
                    //                 console.log("正在運行的進程: process-" + process.pid + " thread-" + require('worker_threads').threadId + " [ " + total_worker_called_number[id] + " ].");
                    //             } else {
                    //                 if (worker_queues[id] !== undefined && worker_queues[id] !== null && worker_queues[id] !== "") {
                    //                     arr.push("thread-".concat(id, "(Runing)", " [ ", total_worker_called_number[id], " ]"));
                    //                 } else {
                    //                     arr.push("thread-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                    //                 };
                    //             };
                    //         });
                    //         if (arr.length > 0) { console.log("副執行緒: Worker " + arr); };
                    //     };
                    // };

                    // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                    if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                        if (Object.keys(worker_queues).length > 0) {
                            Object.keys(worker_queues).forEach((id) => {
                                // worker_queues[id].postMessage(["exit", "Master thread .on('beforeExit')."], []);
                                worker_queues[id].terminate();  // 銷毀子綫程;
                                // console.log("副執行緒 thread-" + id + " 已中止運行, Worker thread-" + id + " be exit. 「 .terminate() 」");
                                // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .terminate() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                                delete worker_queues[id];
                                // 從記錄正在運行的子綫程對象的 JSON 變量 worker_free 中，删除已經使用 .terminate() 方法退出 'exit' 的子綫程 worker_free.hasOwnProperty(id);
                                delete worker_free[id];
                            });
                        };
                    };

                    console.log("the Master process-" + process.pid + " Master thread-" + require('worker_threads').threadId + " be exit.");

                    // 判斷當用於暫存數據的媒介目錄文件夾，與用於傳出數據的媒介目錄文件夾不是同一個文件夾時，程序退出時清空用於暫存數據的媒介文件夾;
                    if (temp_NodeJS_cache_IO_data_dir !== output_dir) {
                        // 同步判斷，判斷數據文檔暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir 是否存在;
                        let file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Directory)方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(temp_NodeJS_cache_IO_data_dir) && fs.statSync(temp_NodeJS_cache_IO_data_dir, { bigint: false }).isDirectory();
                            // console.log("目錄: " + temp_NodeJS_cache_IO_data_dir + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於輸入和輸出的數據文檔暫存媒介文件夾: " + temp_NodeJS_cache_IO_data_dir + " 是否存在.");
                            console.error(error);
                            return temp_NodeJS_cache_IO_data_dir;
                        };
                        // 刪除清空，清空數據文檔暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir ;
                        if (file_bool) {
                            // 同步刪除清空，清空數據文檔暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir ;
                            let files = require('fs').readdirSync(temp_NodeJS_cache_IO_data_dir); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                            if (files.length > 0) {
                                for (let i = 0; i < files.length; i++) {
                                    deleteDirSync(require('path').join(temp_NodeJS_cache_IO_data_dir, files[i]));  // 自定義函數遞歸刪除文件夾;
                                };
                                console.log("用於輸入和輸出的數據文檔暫存媒介目錄: " + temp_NodeJS_cache_IO_data_dir + " 已清空 " + files.length + " 個子項.");
                            };
                        };
                    };

                    // 判斷當用於傳入數據的媒介目錄文件夾，與用於傳出數據的媒介目錄文件夾不是同一個文件夾時，程序退出時清空用於傳入數據的媒介文件夾;
                    if (monitor_dir !== output_dir) {
                        // 同步判斷，判斷數據文檔傳入媒介文件夾 monitor_dir 是否存在;
                        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                        try {
                            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Directory)方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = fs.existsSync(monitor_dir) && fs.statSync(monitor_dir, { bigint: false }).isDirectory();
                            // console.log("目錄: " + monitor_dir + " 存在.");
                        } catch (error) {
                            console.error("無法確定用於輸入數據文檔的媒介文件夾: " + monitor_dir + " 是否存在.");
                            console.error(error);
                            return monitor_dir;
                        };
                        // 刪除清空，清空數據文檔傳入媒介文件夾 monitor_dir ;
                        if (file_bool) {
                            // 同步刪除清空，清空數據文檔傳入媒介文件夾 monitor_dir ;
                            let files = require('fs').readdirSync(monitor_dir); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                            if (files.length > 0) {
                                for (let i = 0; i < files.length; i++) {
                                    deleteDirSync(require('path').join(monitor_dir, files[i]));  // 自定義函數遞歸刪除文件夾;
                                };
                                console.log("用於輸入數據文檔的媒介目錄: " + monitor_dir + " 已清空 " + files.length + " 個子項.");
                            };
                        };
                    };

                    // // 同步判斷，判斷數據文檔傳出媒介文件夾 output_dir 是否存在;
                    // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                    // try {
                    //     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(Directory)方法判斷目錄或文檔是否存在以及是否為文檔;
                    //     file_bool = fs.existsSync(output_dir) && fs.statSync(output_dir, { bigint: false }).isDirectory();
                    //     // console.log("目錄: " + output_dir + " 存在.");
                    // } catch (error) {
                    //     console.error("無法確定用於輸出數據文檔的媒介文件夾: " + output_dir + " 是否存在.");
                    //     console.error(error);
                    //     return output_dir;
                    // };
                    // // 刪除清空，清空數據文檔傳出媒介文件夾 output_dir ;
                    // if (file_bool) {
                    //     // 同步刪除清空，清空數據文檔傳出媒介文件夾 output_dir ;
                    //     let files = require('fs').readdirSync(output_dir); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                    //     if (files.length > 0) {
                    //         for (let i = 0; i < files.length; i++) {
                    //             deleteDirSync(require('path').join(output_dir, files[i]));  // 自定義函數遞歸刪除文件夾;
                    //         };
                    //         console.log("用於輸出數據文檔的媒介目錄: " + output_dir + " 已清空 " + files.length + " 個子項.");
                    //     };
                    // };
                });
            };

            // let worker_queues = {};
            // let worker_free = {};
            // let Message_Channel_queues = {};
            if (typeof (number_Worker_threads) !== undefined && number_Worker_threads !== undefined && !isNaN(Number(number_Worker_threads)) && parseInt(number_Worker_threads) > 0) {
                // number_Worker_threads = parseInt(number_Worker_threads);
                let Workers = create_worker_thread(number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value);
                worker_queues = Workers[0];
                worker_free = Workers[1];
                Message_Channel_queues = Workers[2];
                total_worker_called_number = Workers[3];
            };

            server_setInterval_id = monitor_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, delay, temp_NodeJS_cache_IO_data_dir);
            // console.log(server_setInterval_id);

            return [server_setInterval_id, worker_queues, worker_free, Message_Channel_queues, total_worker_called_number];

        } else {

            if (monitor_file ==="") {
                console.log("傳入的用於傳入數據的媒介文檔參數不合法，為空字符串，只接受輸入文檔路徑全名字符串.");
                // console.log(monitor_file);
                return monitor_file;
            };

            // if (output_file === "") {
            //     console.log("用於傳出數據的媒介文檔參數為空字符串不合法，只接受輸入文檔路徑全名字符串.");
            //     // console.log(output_file);
            //     return output_file;
            // };

            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
            try {
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
                // console.log("文檔: " + monitor_file + " 存在.");
            } catch (error) {
                console.error("無法確定用於傳入數據的媒介文檔: " + monitor_file + " 是否存在.");
                console.error(error);
                return monitor_file;
            };
            // 同步判斷，當用於傳入數據的媒介文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            if (file_bool) {
                // 同步判斷文檔權限，後面所有代碼都是，當用於傳入數據的媒介文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + monitor_file + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(monitor_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + monitor_file + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.error("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        return monitor_file;
                    };
                };
            } else {
                console.log("用於傳入數據的目標媒介文檔 " + monitor_file + " 不存在.");
                return monitor_file;
            };

            result_Array = read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script);
            // console.log(result_Array);

            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
            try {
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                file_bool = fs.existsSync(monitor_file) && fs.statSync(monitor_file, { bigint: false }).isFile();
                // console.log("文檔: " + monitor_file + " 存在.");
            } catch (error) {
                console.error("無法確定用於傳入數據的媒介文檔: " + monitor_file + " 是否存在.");
                console.error(error);
                return monitor_file;
            };
            // 同步判斷，當用於傳入數據的媒介文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            if (file_bool) {
                // 同步判斷文檔權限，後面所有代碼都是，當用於傳入數據的媒介文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(monitor_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + monitor_file + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(monitor_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + monitor_file + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.error("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        return monitor_file;
                    };
                };

                // 讀取到輸入數據之後，同步刪除，用於接收傳值的媒介文檔;
                try {
                    fs.unlinkSync(monitor_file);  // 同步刪除，返回值為 undefined;
                    // console.error("媒介文檔: " + monitor_file + " 已被刪除.");
                    // console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
                } catch (error) {
                    console.error("用於傳入數據的媒介文檔: " + monitor_file + " 無法刪除.");
                    console.error(error);
                    return monitor_file;
                };
            };

            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            file_bool = false;  // 用於判斷輸出文件夾和文檔是否存在及是否有權限讀寫操作;
            try {
                // 同步判斷，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                file_bool = fs.existsSync(output_file) && fs.statSync(output_file, { bigint: false }).isFile();
                // console.log("文檔: " + output_file + " 存在.");
            } catch (error) {
                console.error("無法確定用於傳出數據的媒介文檔: " + output_file + " 是否存在.");
                console.error(error);
                return output_file;
            };
            // 同步判斷，當用於傳出數據的媒介文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
            if (file_bool) {
                // 同步判斷文檔權限，後面所有代碼都是，當用於傳入數據的媒介文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(output_file, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + output_file + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(output_file, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + output_file + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.error("用於輸出傳值的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        return output_file;
                    };
                };
            };

            // 使用 child_process.exec 調用 shell 語句反饋;
            // 運算處理完之後，給調用語言的回復，fs.accessSync(to_executable, fs.constants.X_OK) 判斷脚本文檔是否具有被執行權限;
            file_bool = false;
            try {
                // 同步判斷，反饋目標解釋器可執行檔 to_executable 是否可執行;
                file_bool = Object.prototype.toString.call(to_executable).toLowerCase() === '[object string]' && to_executable !== "" && fs.existsSync(to_executable) && fs.statSync(to_executable, { bigint: false }).isFile() && fs.accessSync(to_executable, fs.constants.X_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                // console.log("解釋器可執行檔: " + to_executable + " 可以運行.");
            } catch (error) {
                console.error("無法確定反饋目標解釋器可執行檔: " + to_executable + " 是否具有可執行權限.");
                console.error(error);
                return to_executable;
            };
            if (file_bool) {
                file_bool = false;
                try {
                    // 同步判斷，反饋目標解釋器運行脚本 to_script 是否可執行;
                    file_bool = Object.prototype.toString.call(to_script).toLowerCase() === '[object string]' && to_script !== "" && fs.existsSync(to_script) && fs.statSync(to_script, { bigint: false }).isFile() && fs.accessSync(to_script, fs.constants.R_OK | fs.constants.W_OK) && fs.accessSync(to_script, fs.constants.X_OK);  // 0o777，可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("脚本文檔: " + to_script + " 可以被執行.");
                } catch (error) {
                    console.error("無法確定反饋目標解釋器運行脚本文檔: " + to_script + " 是否可執行.");
                    console.error(error);
                    return to_script;
                };
                let shell_run_to_executable = "";
                if (file_bool) {
                    shell_run_to_executable = to_executable.concat(" ", to_script, " ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
                } else {
                    shell_run_to_executable = to_executable.concat(" ", output_dir, " ", output_file, " ", monitor_dir, " ", do_Function, " ", monitor_file);
                };
                // let result = require('child_process').execSync(shell_run_to_executable);
                // // console.log(result);
                require('child_process').exec(shell_run_to_executable, function (error, stdout, stderr) {
                    // if (error) {
                    //     console.error("EXEC Error: " + error);
                    //     // return;
                    // };
                    // if (stderr) {
                    //     console.log("stderr: " + stderr);
                    // };
                    // if (stdout) {
                    //     // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
                    //     console.log(typeof (stdout));
                    //     console.log(stdout);
                    //     if (isStringJSON(stdout)) {
                    //         console.log(JSON.parse(stdout));
                    //     };
                    // };
                });
            };

            // let now_date = new Date().toLocaleString('chinese', { hour12: false });
            let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
            // console.log(now_date);
            let log_text = String(now_date) + " thread-" + String(require('worker_threads').threadId) + " < " + monitor_file + " > < " + output_file + " >.";
            console.log(log_text);
            // fs.appendFile(path, data[, options], callback);
            // fs.appendFileSync(path, data[, options]);

            return result_Array;
        };
    };

    let server_setInterval_id = null;
    let worker_queues = {};
    let worker_free = {};
    let Message_Channel_queues = {};
    let result_Array = [];
    let total_worker_called_number = {};

    let result = Run(is_monitor, temp_NodeJS_cache_IO_data_dir, monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value);

    // if (is_monitor) {
    //     worker_queues = result[1];
    //     worker_free = result[2];
    //     Message_Channel_queues = result[3];
    //     server_setInterval_id = result[0];
    // };

    return result;
};
module.exports.file_Monitor = file_Monitor; // 使用「module.exports」接口對象，用來導出模塊中的成員;


// // 當選擇監聽且多綫程啓動時（is_monitor = true, number_Worker_threads = 1 or more），子綫程(副執行緒) Worker thread 中運行的代碼;
// is_monitor = true, number_Worker_threads = 1 or more, Worker_threads_eval_value = false, Worker_threads_Script_path = 脚本中可以寫入如下代碼;
// if (!require('worker_threads').isMainThread) {

//     if (require('worker_threads').isMainThread) { throw new Error('isMainThread: ' + require('worker_threads').isMainThread + ', threadId-' + require('worker_threads').threadId + ' is not a worker.') };
//     const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組;
//     const { AsyncResource } = require('async_hooks');  // 導入 Node.js 原生異步鈎子模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
//     const { EventEmitter } = require('events');  // 導入 Node.js 原生事件模組，用於構建子綫程池 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;

//     const child_process = require('child_process');  // Node原生的創建子進程模組;
//     const os = require('os');  // Node原生的操作系統信息模組;
//     const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
//     const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;

//     // 自定義封裝的函數isStringJSON(str)判斷一個字符串是否爲 JSON 格式的字符串;
//     function isStringJSON(str) {
//         // 首先判斷傳入參數 str 是否為一個字符串 typeof (str) === 'string'，如果不是字符串直接返回錯誤;
//         if (Object.prototype.toString.call(str).toLowerCase() === '[object string]') {
//             try {
//                 let Obj = JSON.parse(str);
//                 // 使用語句 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) 判斷 Obj 是否為一個 JSON 對象;
//                 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) {
//                     return true;
//                 } else {
//                     return false;
//                 };
//             } catch (error) {
//                 // console.log(error);
//                 return false;
//             } finally { };
//         } else {
//             // console.log("It is not a String!");
//             return false;
//         };
//     };

//     if (typeof (workerData["read_file_do_Function"]) !== undefined && workerData["read_file_do_Function"] !== undefined && workerData["read_file_do_Function"] !== null && workerData["read_file_do_Function"] !== "" && Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(workerData["read_file_do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("read_file_do_Function = " + workerData["read_file_do_Function"] + ';')).toLowerCase() === '[object function]')) {
//     // 以 let mytFunc = function (argument) {} 形式的函數傳值;
//         eval("read_file_do_Function = " + workerData["read_file_do_Function"] + ";");
//     } else if (typeof (workerData["read_file_do_Function"]) !== undefined && workerData["read_file_do_Function"] !== undefined && workerData["read_file_do_Function"] !== null && workerData["read_file_do_Function"] !== "" && Object.prototype.toString.call(workerData["read_file_do_Function"]).toLowerCase() === '[object string]') {
//     // 以 function mytFunc(argument) {} 形式的函數傳值;
//         eval(workerData["read_file_do_Function"]);
//         // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
//         // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
//         eval("read_file_do_Function = " + workerData["read_file_do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//         // eval("read_file_do_Function = " + workerData["read_file_do_Function"].substring(workerData["read_file_do_Function"].indexOf('function') + 9, workerData["read_file_do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//     } else {
//         // console.log("傳入的用於處理數據的函數參數 read_file_do_Function: " + workerData["read_file_do_Function"] + " 無法識別.");
//         read_file_do_Function = function (argument) { return argument; };
//     };

//     if (typeof (workerData["do_Function"]) !== undefined && workerData["do_Function"] !== undefined && workerData["do_Function"] !== null && workerData["do_Function"] !== "" && Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(workerData["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + workerData["do_Function"] + ';')).toLowerCase() === '[object function]')) {
//     // 以 let mytFunc = function (argument) {} 形式的函數傳值;
//         eval("do_Function = " + workerData["do_Function"] + ";");
//     } else if (typeof (workerData["do_Function"]) !== undefined && workerData["do_Function"] !== undefined && workerData["do_Function"] !== null && workerData["do_Function"] !== "" && Object.prototype.toString.call(workerData["do_Function"]).toLowerCase() === '[object string]') {
//     // 以 function mytFunc(argument) {} 形式的函數傳值;
//         eval(workerData["do_Function"]);
//         // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
//         // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
//         eval("do_Function = " + workerData["do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//         // eval("do_Function = " + workerData["do_Function"].substring(workerData["do_Function"].indexOf('function') + 9, workerData["do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//     } else {
//         // console.log("傳入的用於處理數據的函數參數 do_Function: " + workerData["do_Function"] + " 無法識別.");
//         do_Function = function (argument) { return argument; };
//     };

//     // 創建延時循環，使子綫程一直處於運行狀態，不至於運行完畢被銷毀 setInterval_id = setInterval(function(){}, delay)，清楚循環 clearInterval(setInterval_id);
//     let setInterval_id = null;  // 子綫程延時待命的循環對象;
//     let delay = null;  //延遲時長，單位毫秒;
//     // setInterval_id = setInterval(function () {}, delay);  // 延時循環等待;

//     let response_message = null;
//     // response_message = read_file_do_Function(workerData.monitor_file, workerData.monitor_dir, workerData.do_Function, workerData.output_dir, workerData.output_file, workerData.to_executable, workerData.to_script);
//     // const port = message.ports[0];
//     // port.postMessage(response_message, []);
//     // // read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script);

//     // // 首次向主綫程 Master thread 發送響應;
//     // response_message = {
//     //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//     //     "data": "Worker thread-" + require('worker_threads').threadId + " Stand by Pooling delay " + delay + " ms ...",
//     //     "setInterval_id": setInterval_id
//     // };
//     // parentPort.postMessage(["standby_response", response_message], []);

//     // 監聽主綫程 Master thread 發送的信號;
//     // 在子綫程中注冊監聽 parentPort.on('message', (data) => {}) 事件，會使子綫程處於等待狀態，執行完畢也不被銷毀，從而實現，子綫程的「池化」效果，使用子綫程池技術，與頻繁創建銷毀子綫程相比，效率更高;
//     parentPort.on('message', (receive_message) => {

//         // console.log(typeof (receive_message));
//         // console.log(receive_message);
//         // parentPort.postMessage(["message_response", receive_message], []);

//         let Message_status = "";
//         let Data_JSON = null;
//         if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
//             Message_status = 'message';
//             Data_JSON = receive_message[0];
//         } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
//             Message_status = receive_message[0];
//             Data_JSON = receive_message[1];
//         } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
//             Message_status = receive_message[0];
//             let Data_Array = [];
//             for (let i = 1; i < receive_message.length; i++) {
//                 Data_Array.push(receive_message[i]);
//             };
//         } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
//             Message_status = 'message';
//             Data_JSON = receive_message;
//             // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'SIGINT' && receive_message !== 'error') {
//             //     Message_status = 'message';
//             //     Data_JSON = receive_message;
//         } else {
//             Message_status = receive_message;
//         };

//         // if (typeof (Data_JSON["read_file_do_Function"]) !== undefined && Data_JSON["read_file_do_Function"] !== undefined && Data_JSON["read_file_do_Function"] !== null && Data_JSON["read_file_do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["read_file_do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["read_file_do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"] + ';')).toLowerCase() === '[object function]')) {
//         // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
//         //     eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"] + ";");
//         // } else if (typeof (Data_JSON["read_file_do_Function"]) !== undefined && Data_JSON["read_file_do_Function"] !== undefined && Data_JSON["read_file_do_Function"] !== null && Data_JSON["read_file_do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["read_file_do_Function"]).toLowerCase() === '[object string]') {
//         // // 以 function mytFunc(argument) {} 形式的函數傳值;
//         //     eval(Data_JSON["read_file_do_Function"]);
//         //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
//         //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
//         //     eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//         //     // eval("read_file_do_Function = " + Data_JSON["read_file_do_Function"].substring(Data_JSON["read_file_do_Function"].indexOf('function') + 9, Data_JSON["read_file_do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//         // } else {
//         //     // console.log("傳入的用於處理數據的函數參數 read_file_do_Function: " + Data_JSON["read_file_do_Function"] + " 無法識別.");
//         //     read_file_do_Function = function (argument) { return argument; };
//         // };

//         // if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + Data_JSON["do_Function"] + ';')).toLowerCase() === '[object function]')) {
//         // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
//         //     eval("do_Function = " + Data_JSON["do_Function"] + ";");
//         // } else if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]') {
//         // // 以 function mytFunc(argument) {} 形式的函數傳值;
//         //     eval(Data_JSON["do_Function"]);
//         //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
//         //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
//         //     eval("do_Function = " + Data_JSON["do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//         //     // eval("do_Function = " + Data_JSON["do_Function"].substring(Data_JSON["do_Function"].indexOf('function') + 9, Data_JSON["do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
//         // } else {
//         //     // console.log("傳入的用於處理數據的函數參數 do_Function: " + Data_JSON["do_Function"] + " 無法識別.");
//         //     do_Function = function (argument) { return argument; };
//         // };

//         switch (Message_status) {

//             case 'standby': {
//                 delay = parseInt(Data_JSON["delay"]);  // 500 延遲時長，單位毫秒;
//                 if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
//                     // console.log(setInterval_id);
//                     clearInterval(setInterval_id);  // 清除延時監聽動作;
//                     // console.log(setInterval_id);
//                 };
//                 setInterval_id = setInterval(function () { }, delay);  // 延時循環等待;
//                 // console.log(setInterval_id)
//                 // clearInterval(setInterval_id);  // 清除延時監聽動作;

//                 // console.log("Worker thread-" + require('worker_threads').threadId + " stand by Pooling ...");

//                 response_message = {
//                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//                     "data": "Worker thread-" + require('worker_threads').threadId + " stand by Pooling ...",
//                     "setInterval_id": setInterval_id,
//                 };
//                 parentPort.postMessage(["standby_response", response_message], []);
//                 break;
//             }

//             case 'message': {
//                 let result = read_file_do_Function(Data_JSON.monitor_file, Data_JSON.monitor_dir, do_Function, Data_JSON.output_dir, Data_JSON.output_file, Data_JSON.to_executable, Data_JSON.to_script);
//                 if (Object.prototype.toString.call(result).toLowerCase() === '[object array]') {
//                     response_message = {
//                         "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//                         "monitor_file": Data_JSON.monitor_file,
//                         "data": result[0],
//                         "output_file": result[1]
//                     };
//                 } else if (Object.prototype.toString.call(result).toLowerCase() === '[object string]') {
//                     response_message = result;
//                 } else { };
//                 parentPort.postMessage(["message_response", response_message], []);
//                 break;
//             }

//             case 'SIGINT': {
//                 // console.log('Got SIGINT to exit.');
//                 if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
//                     // console.log(setInterval_id);
//                     clearInterval(setInterval_id);  // 清除延時監聽動作;
//                     // console.log(setInterval_id);
//                 };
//                 response_message = {
//                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//                     "data": '副執行緒 thread-' + require("worker_threads").threadId + " 響應主執行緒 thread-" + Data_JSON["threadId"] + ' 發送的 "SIGINT" 信號中止延時循環待命狀態(clear Interval); Master thread-' + Data_JSON["threadId"] + ' post "SIGINT" message stop Worker thread-' + require("worker_threads").threadId + ', unstand by clearInterval(setInterval_id).',
//                     "setInterval_id": setInterval_id
//                 };
//                 parentPort.postMessage(["SIGINT_response", response_message], []);
//                 // process.exit(1);
//                 break;
//             }

//             case 'exit': {
//                 // console.log('Got exit to exit.');
//                 if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
//                     // console.log(setInterval_id);
//                     clearInterval(setInterval_id);  // 清除延時監聽動作;
//                     // console.log(setInterval_id);
//                 };
//                 response_message = {
//                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//                     "data": '副執行緒 thread-' + require("worker_threads").threadId + " 響應主執行緒 thread-" + Data_JSON["threadId"] + ' 發送的 "exit" 信號中止運行; Master thread-' + Data_JSON["threadId"] + ' post "exit" message destruction Worker thread-' + require("worker_threads").threadId + ', process.exit(1).',
//                     "setInterval_id": setInterval_id
//                 };
//                 parentPort.postMessage(["exit_response", response_message], []);
//                 process.exit(1);
//             }

//             case 'error': {
//                 // response_message = {
//                 //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//                 //     "data": "Post [ " + receive_message[0] + " ] unrecognized."
//                 // };
//                 // parentPort.postMessage(["error_response", response_message], []);
//                 break;
//             }

//             default: {
//                 response_message = {
//                     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
//                     "data": "Post [ " + receive_message[0] + " ] unrecognized."
//                 };
//                 parentPort.postMessage(["error", response_message], []);
//             }
//         };
//     });
// };


// // 硬盤文檔監聽函數 file_Monitor() 使用説明;
// if (require('worker_threads').isMainThread) {
//     // const child_process = require('child_process');  // Node原生的創建子進程模組;
//     // const os = require('os');  // Node原生的操作系統信息模組;
//     // const net = require('net');  // Node原生的網卡網絡操作模組;
//     // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//     // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//     // const qs = require('querystring');
//     // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
//     // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
//     // const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
//     // const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
//     // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
//     // const cluster = require('cluster');  // Node原生的支持多進程模組;
//     // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
//     // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
    
//     // // 可以先改變工作目錄到 static 路徑;
//     // console.log('Starting directory: ' + process.cwd());
//     // try {
//     //     process.chdir('D:\\tmp\\');
//     //     console.log('New directory: ' + process.cwd());
//     // } catch (error) {
//     //     console.log('chdir: ' + error);
//     // };

//     // // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
//     // try {
//     //     console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
//     // } catch (error) {
//     //     console.log(error);
//     // };

//     let monitor_dir = require('path').join(require('path').resolve(".."), "temp");  //require('path').resolve("..").toString().concat("/temp/")，"D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//     let monitor_file = require('path').join(monitor_dir, "intermediary_write_Python.txt");  // "../temp/intermediary_write_Python.txt" 用於接收傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//     let do_Function = do_data;  // 用於接收執行功能的函數;
//     let output_dir = require('path').join(require('path').resolve(".."), "temp");  // "D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//     let output_file = require('path').join(output_dir, "intermediary_write_Node.txt");  // "../temp/intermediary_write_Node.txt" 用於輸出傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//     let to_executable = require('path').join(require('path').resolve(".."), "Python", "python39/python.exe");  // require('path').resolve("..").toString().concat("/Python/", "python39/python.exe")，"../Python/python39/python.exe"，path.resolve("../Python/python39/python.exe") 轉換爲絕對路徑;
//     let to_script = require('path').join(require('path').resolve(".."), "js", "test.js");  // require('path').resolve("..").toString().concat("/js/", "test.js")，"../js/test.js"，path.resolve("../js/test.js") 轉換爲絕對路徑;
//     let do_Function_obj = {
//         "do_Function": do_Function  // 用於接收執行功能的函數;
//     };
//     let return_obj = {
//         "output_dir": output_dir,  // 需要注意目錄操作權限 "./temp/" 用於傳值的媒介目錄;
//         "output_file": output_file,  // "./temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
//         "to_executable": to_executable,  // 用於對返回數據執行功能的解釋器可執行文件;
//         "to_script": to_script  // "./js/test.js" 用於執行功能的被調用的脚步文檔;
//     };
//     let is_monitor = true;  // 用於判斷只運行一次，還是保持文檔監聽;
//     // let is_Monitor_Concurrent = 0;  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
//     let delay = 50;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//     let number_Worker_threads = 1;  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//     let Worker_threads_Script_path = "";  // process.argv[1]; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值;
//     let Worker_threads_eval_value = "";  // true; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值;
//     let temp_NodeJS_cache_IO_data_dir = require('path').join(require('path').resolve(".."), "temp");  // require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);  // "C:\\Users\\china\\AppData\\Local\\Temp\\temp_NodeJS_cache_IO_data\\" 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾;
//     // let temp_NodeJS_cache_IO_data_dir = fs.mkdtempSync(require('os').tmpdir().concat(require('path').sep), { encoding: 'utf8' });  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
//     // fs.rmdirSync(temp_NodeJS_cache_IO_data_dir, { maxRetries: 0, recursive: false, retryDelay: 100 });  // 同步刪除目錄 fs.rmdirSync(path[, options]) 返回值 undefined;
//     // console.log(temp_NodeJS_cache_IO_data_dir);

//     let data = Interface_file_Monitor({
//         "is_monitor": is_monitor,
//         // "is_Monitor_Concurrent": is_Monitor_Concurrent,
//         "monitor_file": monitor_file,
//         "monitor_dir": monitor_dir,
//         // "do_Function_obj": do_Function_obj,
//         "do_Function": do_Function,
//         // "return_obj": return_obj,
//         "output_dir": output_dir,
//         "output_file": output_file,
//         "to_executable": to_executable,
//         "to_script": to_script,
//         "delay": delay,
//         "number_Worker_threads": number_Worker_threads,
//         "Worker_threads_Script_path": Worker_threads_Script_path,
//         "Worker_threads_eval_value": Worker_threads_eval_value,
//         "temp_NodeJS_cache_IO_data_dir": temp_NodeJS_cache_IO_data_dir
//     });
//     // let data = Interface_file_Monitor({
//     //     "is_monitor": is_monitor,
//     //     "monitor_file": monitor_file,
//     //     "do_Function": do_Function,
//     //     "output_file": output_file,
//     // });
// };









// // 自定義具體處理 GET 或 POST 請求的執行函數;
// function do_Request_Router(
//     request_url,
//     request_POST_String,
//     request_headers,
//     callback
// ){
// // async function do_Request_Router(
// //     request_url,
// //     request_POST_String,
// //     request_headers
// // ){

//     // Check the file extension required and set the right mime type;
//     // try {
//     //     fs.readFileSync();
//     //     fs.writeFileSync();
//     // } catch (error) {
//     //     console.log("硬盤文件打開或讀取錯誤.");
//     // } finally {
//     //     fs.close();
//     // };

//     let response_body_String = "";
//     // let now_date = new Date().toLocaleString('chinese', { hour12: false });
//     let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
//     // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
//     let response_data_JSON = {
//         "time": String(now_date),
//         "request_url": request_url,
//         "request_POST": request_POST_String,
//         // "request_Authorization": request_headers["authorization"],  // "username:password";
//         // "request_Cookie": request_headers["cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
//         "Server_Authorization": Key,  // "username:password";
//         "Database_say": "",
//     };
//     // console.log(request_headers);
//     if (typeof (request_headers) === 'object' && Object.prototype.toString.call(request_headers).toLowerCase() === '[object object]' && !(request_headers.length)) {
//         if (request_headers.hasOwnProperty("authorization")) {
//             response_data_JSON["request_Authorization"] = Base64.decode(String(request_headers["authorization"]).split(" ")[1]);  // "username:password";
//             // console.log(response_data_JSON["request_Authorization"]);
//         };
//         if (request_headers.hasOwnProperty("cookie")) {
//             response_data_JSON["request_Cookie"] = request_headers["cookie"];  // String(request_headers["cookie"]).split("=")[0].concat("=", Base64.decode(String(request_headers["cookie"]).split("=")[1]));  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
//             // console.log(response_data_JSON["request_Cookie"]);
//         };
//     };
//     // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//     // String = JSON.stringify(JSON); JSON = JSON.parse(String);

//     // console.log(request_POST_String);
//     let request_POST_JSON = {};
//     // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
//     // // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
//     //     try {
//     //         if (request_POST_String !== "") {
//     //             request_POST_JSON = JSON.parse(request_POST_String, true);
//     //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//     //         };
//     //     } catch (error) {
//     //         console.error(error);
//     //         response_data_JSON["Database_say"] = String(error);
//     //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//     //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//     //         if (callback) { callback(response_body_String, null); };
//     //         return response_body_String;
//     //     } finally {};
//     //     // console.log(request_POST_JSON);
//     // // };

//     // console.log(request_url);
//     // let request_url_JSON = url.parse(request_url, true);
//     const request_url_JSON = new URL(request_url, `http://${request_headers["host"]}`);  // http://127.0.0.1:8000
//     // console.log(request_url_JSON);
//     const url_search_JSON = new URLSearchParams(request_url_JSON.search);
//     // console.log(url_search_JSON);
//     const request_url_path = String(request_url_JSON.pathname);
//     // console.log(request_url_path);
//     // console.log(webPath);
//     let web_path = String(path.join(webPath, request_url_path));
//     // console.log(web_path);

//     // // try {
//     // //     // 異步寫入硬盤文檔;
//     // //     fs.writeFile(
//     // //         web_path,
//     // //         data,
//     // //         function (error) {
//     // //             if (error) { return console.error(error); };
//     // //         }
//     // //     );
//     // //     // 同步讀取硬盤文檔;
//     // //     // fs.writeFileSync(web_path, data);
//     // // } catch (error) {
//     // //     console.log("硬盤文檔打開或寫入錯誤.");
//     // // } finally {
//     // //     fs.close();
//     // // };

//     let file_data = null;
//     // try {
//     //     // // 異步讀取硬盤文檔;
//     //     // fs.readFile(
//     //     //     web_path,
//     //     //     function (error, data) {
//     //     //         if (error) {
//     //     //             console.error(error);
//     //     //             response_body_String = String(error);
//     //     //             if (callback) { callback(response_body_String, null); };
//     //     //         };
//     //     //         if (data) {
//     //     //             // console.log("異步讀取文檔: " + data.toString());
//     //     //             file_data = data;
//     //     //             response_body_String = file_data.toString();
//     //     //             // console.log(response_body_String);
//     //     //             if (callback) { callback(null, response_body_String); };
//     //     //         };
//     //     //     }
//     //     // );
//     //     // 同步讀取硬盤文檔;
//     //     file_data = fs.readFileSync(web_path);
//     //     // console.log("同步讀取文檔: " + file_data.toString());
//     //     response_body_String = file_data.toString();
//     //     // console.log(response_body_String);
//     //     if (callback) { callback(null, response_body_String); };
//     //     return response_body_String;
//     // } catch (error) {
//     //     console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
//     //     response_body_String = String(error);
//     //     if (callback) { callback(response_body_String, null); };
//     //     return response_body_String;
//     // } finally {
//     //     // fs.close();
//     // };

//     let fileName = "";
//     if (url_search_JSON.has("fileName")) {
//         fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
//     };

//     if (url_search_JSON.has("Key")) {
//         Key = String(url_search_JSON.get("Key"));  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//     };
//     if (url_search_JSON.has("dbUser")) {
//         dbUser = String(url_search_JSON.get("dbUser"));  // 'admin_test20220703'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
//     };
//     if (url_search_JSON.has("dbPass")) {
//         dbPass = String(url_search_JSON.get("dbPass"));  // 'admin'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
//     };
//     // UserPass = dbUser.concat(":", dbPass);  // 'admin_test20220703:admin';  // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
//     if (url_search_JSON.has("dbName")) {
//         dbName = String(url_search_JSON.get("dbName"));  // 'testWebData'; // ['admin', 'testWebData'];  // 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，Mongodb 要求數據庫名稱首字母必須為大寫單數;
//     };
//     if (url_search_JSON.has("dbTableName")) {
//         dbTableName = String(url_search_JSON.get("dbTableName"));  // 'test20220703'; // ['test20220703'];  // MongoDB 數據庫包含的數據集合（表格）;
//     };

//     switch (request_url_path) {

//         case "/": {

//             web_path = String(path.join(webPath, "/index.html"));
//             file_data = null;

//             Select_Statistical_Algorithms_HTML_path = String(path.join(webPath, "/SelectStatisticalAlgorithms.html"));  // 拼接本地當前目錄下的請求文檔名;
//             Select_Statistical_Algorithms_HTML = ""  // '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>';
//             Input_HTML_path = String(path.join(webPath, "/InputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
//             Input_HTML = ""  // '<table id="LC5PFitInputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitInputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表頭名稱</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表頭名稱</th></tr></thead><tfoot id="LC5PFitInputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表足名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表足名稱</td></tr></tfoot><tbody id="LC5PFitInputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Input-1名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-2名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-3名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Input-4名稱</td></tr></tbody></table>';
//             Output_HTML_path = String(path.join(webPath, "/OutputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
//             Output_HTML = ""  // '<table id="LC5PFitOutputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitOutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表頭名稱</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表頭名稱</th></tr></thead><tfoot id="LC5PFitOutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表足名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表足名稱</td></tr></tfoot><tbody id="LC5PFitOutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Output-1名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-2名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-3名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Output-4名稱</td></tr></tbody></table><canvas id="LC5PFitOutputCanvas" width="300" height="150" style="display: block;"></canvas>';

//             try {

//                 // 異步讀取硬盤文檔;
//                 fs.readFile(
//                     web_path,
//                     function (error, data) {

//                         if (error) {
//                             console.error(error);
//                             response_data_JSON["Database_say"] = String(error);
//                             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                             if (callback) { callback(response_body_String, null); };
//                             // return response_body_String;
//                         };

//                         if (data) {
//                             // console.log("異步讀取文檔: " + "\\n" + data.toString());
//                             file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             response_body_String = file_data.toString();
//                             // console.log(response_body_String);

//                             // 同步讀取硬盤文檔;
//                             Select_Statistical_Algorithms_HTML = fs.readFileSync(Select_Statistical_Algorithms_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             Select_Statistical_Algorithms_HTML = Select_Statistical_Algorithms_HTML.toString();
//                             // console.log("同步讀取文檔: " + "\\n" + Select_Statistical_Algorithms_HTML.toString());
//                             response_body_String = response_body_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML);
//                             // console.log(response_body_String);

//                             // 同步讀取硬盤文檔;
//                             Input_HTML = fs.readFileSync(Input_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             Input_HTML = Input_HTML.toString();
//                             // console.log("同步讀取文檔: " + "\\n" + Input_HTML.toString());
//                             response_body_String = response_body_String.replace("<!-- Input_HTML -->", Input_HTML);
//                             // console.log(response_body_String);

//                             // 同步讀取硬盤文檔;
//                             Output_HTML = fs.readFileSync(Output_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             Output_HTML = Output_HTML.toString();
//                             // console.log("同步讀取文檔: " + "\\n" + Output_HTML.toString());
//                             response_body_String = response_body_String.replace("<!-- Output_HTML -->", Output_HTML);
//                             // console.log(response_body_String);

//                             if (callback) { callback(null, response_body_String); };
//                             // return response_body_String;
//                         };
//                     }
//                 );

//             } catch (error) {
//                 console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
//                 console.error(error);
//                 response_data_JSON["Database_say"] = String(error);
//                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                 if (callback) { callback(response_body_String, null); };
//                 // return response_body_String;
//             } finally {
//                 // fs.close();
//             };

//             return response_body_String;
//         }

//         case "/index.html": {

//             // web_path = String(path.join(webPath, "/index.html"));
//             file_data = null;

//             Select_Statistical_Algorithms_HTML_path = String(path.join(webPath, "/SelectStatisticalAlgorithms.html"));  // 拼接本地當前目錄下的請求文檔名;
//             Select_Statistical_Algorithms_HTML = ""  // '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>';
//             Input_HTML_path = String(path.join(webPath, "/InputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
//             Input_HTML = ""  // '<table id="LC5PFitInputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitInputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表頭名稱</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表頭名稱</th></tr></thead><tfoot id="LC5PFitInputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表足名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表足名稱</td></tr></tfoot><tbody id="LC5PFitInputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Input-1名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-2名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-3名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Input-4名稱</td></tr></tbody></table>';
//             Output_HTML_path = String(path.join(webPath, "/OutputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
//             Output_HTML = ""  // '<table id="LC5PFitOutputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitOutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表頭名稱</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表頭名稱</th></tr></thead><tfoot id="LC5PFitOutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表足名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表足名稱</td></tr></tfoot><tbody id="LC5PFitOutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Output-1名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-2名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-3名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Output-4名稱</td></tr></tbody></table><canvas id="LC5PFitOutputCanvas" width="300" height="150" style="display: block;"></canvas>';

//             try {

//                 // 異步讀取硬盤文檔;
//                 fs.readFile(
//                     web_path,
//                     function (error, data) {

//                         if (error) {
//                             console.error(error);
//                             response_data_JSON["Database_say"] = String(error);
//                             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                             if (callback) { callback(response_body_String, null); };
//                             // return response_body_String;
//                         };

//                         if (data) {
//                             // console.log("異步讀取文檔: " + "\\n" + data.toString());
//                             file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             response_body_String = file_data.toString();
//                             // console.log(response_body_String);

//                             // 同步讀取硬盤文檔;
//                             Select_Statistical_Algorithms_HTML = fs.readFileSync(Select_Statistical_Algorithms_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             Select_Statistical_Algorithms_HTML = Select_Statistical_Algorithms_HTML.toString();
//                             // console.log("同步讀取文檔: " + "\\n" + Select_Statistical_Algorithms_HTML.toString());
//                             response_body_String = response_body_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML);
//                             // console.log(response_body_String);

//                             // 同步讀取硬盤文檔;
//                             Input_HTML = fs.readFileSync(Input_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             Input_HTML = Input_HTML.toString();
//                             // console.log("同步讀取文檔: " + "\\n" + Input_HTML.toString());
//                             response_body_String = response_body_String.replace("<!-- Input_HTML -->", Input_HTML);
//                             // console.log(response_body_String);

//                             // 同步讀取硬盤文檔;
//                             Output_HTML = fs.readFileSync(Output_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             Output_HTML = Output_HTML.toString();
//                             // console.log("同步讀取文檔: " + "\\n" + Output_HTML.toString());
//                             response_body_String = response_body_String.replace("<!-- Output_HTML -->", Output_HTML);
//                             // console.log(response_body_String);

//                             if (callback) { callback(null, response_body_String); };
//                             // return response_body_String;
//                         };
//                     }
//                 );

//             } catch (error) {
//                 console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
//                 console.error(error);
//                 response_data_JSON["Database_say"] = String(error);
//                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                 if (callback) { callback(response_body_String, null); };
//                 // return response_body_String;
//             } finally {
//                 // fs.close();
//             };

//             return response_body_String;
//         }

//         case "/administrator.html": {

//             // web_path = String(path.join(webPath, "/administrator.html"));
//             file_data = null;

//             try {

//                 // // 同步讀取硬盤文檔;
//                 // file_data = fs.readFileSync(web_path);
//                 // // console.log("同步讀取文檔: " + file_data.toString());
//                 // let filesName = fs.readdirSync(webPath);
//                 // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
//                 // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
//                 // filesName.forEach(
//                 //     function (item) {
//                 //         // console.log("異步讀取文件夾目錄: " + item.toString());
//                 //         let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
//                 //         if (statsObj.isFile()) {
//                 //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
//                 //         } else if (statsObj.isDirectory()) {
//                 //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
//                 //         } else {};
//                 //     }
//                 // );
//                 // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
//                 // // console.log(response_body_String);
//                 // // return response_body_String;

//                 // 異步讀取硬盤文檔;
//                 fs.readFile(
//                     web_path,
//                     function (error, data) {

//                         if (error) {
//                             console.error(error);
//                             response_data_JSON["Database_say"] = String(error);
//                             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                             if (callback) { callback(response_body_String, null); };
//                             // return response_body_String;
//                         };

//                         if (data) {
//                             file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
//                             // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
//                             fs.readdir(
//                                 webPath,
//                                 function (error, filesName) {

//                                     if (error) {
//                                         console.error(error);
//                                         response_data_JSON["Database_say"] = String(error);
//                                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                         if (callback) { callback(response_body_String, null); };
//                                         // return response_body_String;
//                                     };

//                                     if (filesName) {
//                                         let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
//                                         // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
//                                         filesName.forEach(
//                                             function (item) {
//                                                 // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
//                                                 let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
//                                                 let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
//                                                 let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
//                                                 let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
//                                                 // console.log("異步讀取文件夾目錄: " + item.toString());
//                                                 let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
//                                                 if (statsObj.isFile()) {
//                                                     // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
//                                                     directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
//                                                     // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//                                                     // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//                                                 } else if (statsObj.isDirectory()) {
//                                                     // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
//                                                     directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
//                                                     // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//                                                 } else {};
//                                             }
//                                         );
//                                         response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
//                                         // console.log(response_body_String);
//                                         if (callback) { callback(null, response_body_String); };
//                                         // return response_body_String;
//                                     };
//                                 }
//                             );
//                         };
//                     }
//                 );

//             } catch (error) {
//                 console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
//                 console.error(error);
//                 response_data_JSON["Database_say"] = String(error);
//                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                 if (callback) { callback(response_body_String, null); };
//                 // return response_body_String;
//             } finally {
//                 // fs.close();
//             };

//             return response_body_String;
//         }

//         case "/uploadFile": {

//             // fileName = "";
//             // if (url_search_JSON.has("fileName")) {
//             //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
//             // };
//             if (fileName === "" || fileName === null) {
//                 console.log("上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
//                 response_data_JSON["Database_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
//                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                 if (callback) { callback(response_body_String, null); };
//                 return response_body_String;
//             };

//             web_path = String(path.join(webPath, fileName));
//             file_data = request_POST_String;

//             let file_data_Uint8Array_String = JSON.parse(file_data);  // JSON.stringify(file_data_Uint8Array);
//             let file_data_Uint8Array = new Array();
//             for (let i = 0; i < file_data_Uint8Array_String.length; i++) {
//                 if (Object.prototype.toString.call(file_data_Uint8Array_String[i]).toLowerCase() === '[object string]') {
//                     // file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 2));  // 函數 parseInt("11100101", 2) 表示將二進制數字的字符串轉爲十進制的數字，例如 parseInt("11100101", 2) === 二進制的：11100101 也可以表示爲（0b11100101）=== 十進制的：229;
//                     file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 10));  // 函數 parseInt("229", 10) 表示將十進制數字的字符串轉爲十進制的數字，例如 parseInt("229", 10) === 十進制的：229 === 二進制的：11100101 也可以表示爲（0b11100101）;
//                 } else {
//                     file_data_Uint8Array.push(file_data_Uint8Array_String[i]);
//                 };
//             };
//             // let file_data_bytes = new Uint8Array(Buffer.from(file_data_String));  // 轉換為 Buffer 二進制對象;
//             let file_data_bytes = Buffer.from(new Uint8Array(file_data_Uint8Array));  // 轉換為 Buffer 二進制對象;
//             // let file_data_Buffer = Buffer.allocUnsafe(file_data_Uint8Array.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
//             // let file_data_bytes = new Uint8Array(file_data_Buffer);  // 轉換為 Buffer 二進制對象;
//             // for (let i = 0; i < file_data_Uint8Array.length; i++) {
//             //     file_data_bytes[i] = file_data_Uint8Array[i];
//             // };
//             // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
//             // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
//             // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
//             // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
//             // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
//             // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
//             let file_data_len = file_data_Uint8Array.length;
//             // let file_data_len = Buffer.byteLength(file_data);

//             // let statsObj = fs.statSync(web_path, {bigint: false});
//             // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
//             if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
//                 // console.log("文檔路徑全名: " + web_path);
//                 // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
//                 // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
//                 // console.log("文檔操作權限值: " + String(statsObj.mode));

//                 // 同步判斷指定的目標文檔權限，當指定的目標文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//                 try {
//                     // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//                     fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
//                     // console.log("文檔: " + web_path + " 可以讀寫.");
//                 } catch (error) {
//                     // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
//                     try {
//                         // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
//                         fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
//                         // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
//                         // 常量                    八進制值    說明
//                         // fs.constants.S_IRUSR    0o400      所有者可讀
//                         // fs.constants.S_IWUSR    0o200      所有者可寫
//                         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
//                         // fs.constants.S_IRGRP    0o40       群組可讀
//                         // fs.constants.S_IWGRP    0o20       群組可寫
//                         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
//                         // fs.constants.S_IROTH    0o4        其他人可讀
//                         // fs.constants.S_IWOTH    0o2        其他人可寫
//                         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
//                         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
//                         // 數字	說明
//                         // 7	可讀、可寫、可執行
//                         // 6	可讀、可寫
//                         // 5	可讀、可執行
//                         // 4	唯讀
//                         // 3	可寫、可執行
//                         // 2	只寫
//                         // 1	只可執行
//                         // 0	沒有許可權
//                         // 例如，八進制值 0o765 表示：
//                         // 1) 、所有者可以讀取、寫入和執行該文檔；
//                         // 2) 、群組可以讀和寫入該文檔；
//                         // 3) 、其他人可以讀取和執行該文檔；
//                         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
//                         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
//                     } catch (error) {
//                         console.log("指定的待替換的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
//                         console.error(error);
//                         response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
//                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         if (callback) { callback(response_body_String, null); };
//                         // return response_body_String;
//                     };
//                 };

//                 // 向指定的目標文檔同步寫入數據;
//                 // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                 try {

//                     // // console.log(file_data);
//                     // // fs.writeFileSync(
//                     // //     web_path,
//                     // //     file_data,
//                     // //     {
//                     // //         encoding: "utf8",
//                     // //         mode: 0o777,
//                     // //         flag: "w+"
//                     // //     }
//                     // // );  // 返回值為 undefined;
//                     // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                     // fs.writeFileSync(
//                     //     web_path,
//                     //     file_data_bytes,
//                     //     {
//                     //         mode: 0o777,
//                     //         flag: "w+"
//                     //     }
//                     // );  // 返回值為 undefined;
//                     // // console.log(file_data_bytes);
//                     // // // let buffer = new Buffer(8);
//                     // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
//                     // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
//                     // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
//                     // // console.log(data_Str);
//                     // // console.log("目標文檔: " + web_path + " 寫入成功.");
//                     // // response_body_String = JSON.stringify(result);
//                     // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
//                     // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     // if (callback) { callback(null, response_body_String); };
//                     // // return response_body_String;

//                     fs.writeFile(
//                         web_path,
//                         file_data_bytes,  // file_data,
//                         {
//                             // encoding: "utf8",
//                             mode: 0o777,
//                             flag: "w+"
//                         },
//                         function (error) {

//                             if (error) {

//                                 console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
//                                 console.error(error);
//                                 response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
//                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                 if (callback) { callback(response_body_String, null); };
//                                 // return response_body_String;

//                             } else {

//                                 // console.log("目標文檔: " + web_path + " 寫入成功.");
//                                 // response_body_String = JSON.stringify(result);
//                                 response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
//                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                 if (callback) { callback(null, response_body_String); };
//                                 // return response_body_String;
//                             };
//                         }
//                     );

//                 } catch (error) {

//                     console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
//                     console.error(error);
//                     response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
//                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     if (callback) { callback(response_body_String, null); };
//                     // return response_body_String;
//                 };

//             } else {

//                 // 截取目標寫入目錄;
//                 let writeDirectory = "";
//                 if (fileName.indexOf("/") === -1) {
//                     writeDirectory = "/";
//                 } else {
//                     let tempArray = new Array();
//                     tempArray = fileName.split("/");
//                     if (tempArray.length <= 2) {
//                         writeDirectory = "/";
//                     } else {
//                         for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
//                             if (i === 0) {
//                                 writeDirectory = tempArray[i];
//                             } else {
//                                 writeDirectory = writeDirectory + "/" + tempArray[i];
//                             };
//                         };
//                     };
//                 };
//                 writeDirectory = String(path.join(webPath, writeDirectory));

//                 // 判斷目標寫入目錄是否存在，如果不存在則創建;
//                 try {
//                     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(writeDirectory)方法判斷指定的目標寫入目錄是否存在以及是否為文件夾;
//                     if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
//                         // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
//                         fs.mkdirSync(writeDirectory, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
//                         // console.log("目錄: " + writeDirectory + " 創建成功.");
//                     };
//                     // 判斷指定的目標寫入目錄是否創建成功;
//                     if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
//                         console.log("無法創建指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.");
//                         response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.";
//                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         if (callback) { callback(response_body_String, null); };
//                         return response_body_String;
//                     };
//                 } catch (error) {
//                     console.log("無法創建或識別指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create or recognize the directory = { " + String(writeDirectory) + " }.");
//                     console.error(error);
//                     response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + String(error);
//                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     if (callback) { callback(response_body_String, null); };
//                     return response_body_String;
//                 };

//                 // 同步創建指定的目標文檔，並向文檔寫入數據;
//                 // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                 try {

//                     // // console.log(file_data);
//                     // // fs.writeFileSync(
//                     // //     web_path,
//                     // //     file_data,
//                     // //     {
//                     // //         encoding: "utf8",
//                     // //         mode: 0o777,
//                     // //         flag: "w+"
//                     // //     }
//                     // // );  // 返回值為 undefined;
//                     // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                     // fs.writeFileSync(
//                     //     web_path,
//                     //     file_data_bytes,
//                     //     {
//                     //         mode: 0o777,
//                     //         flag: "w+"
//                     //     }
//                     // );  // 返回值為 undefined;
//                     // // console.log(web_path_bytes);
//                     // // // let buffer = new Buffer(8);
//                     // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
//                     // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
//                     // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
//                     // // console.log(data_Str);

//                     fs.writeFile(
//                         web_path,
//                         file_data_bytes,  // file_data,
//                         {
//                             // encoding: "utf8",
//                             mode: 0o777,
//                             flag: "w+"
//                         },
//                         function (error) {

//                             if (error) {

//                                 console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
//                                 console.error(error);
//                                 response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
//                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                 if (callback) { callback(response_body_String, null); };
//                                 // return response_body_String;

//                             } else {

//                                 // console.log("目標文檔: " + web_path + " 寫入成功.");
//                                 // response_body_String = JSON.stringify(result);
//                                 response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
//                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                 if (callback) { callback(null, response_body_String); };
//                                 // return response_body_String;
//                             };
//                         }
//                     );

//                 } catch (error) {
//                     console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
//                     console.error(error);
//                     response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
//                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     if (callback) { callback(response_body_String, null); };
//                     // return response_body_String;
//                 };
//             };

//             return response_body_String;
//         }

//         case "/deleteFile": {

//             // fileName = "";
//             // if (url_search_JSON.has("fileName")) {
//             //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待刪除的文件路徑全名;
//             // };
//             if (fileName === "" || fileName === null) {
//                 console.log("上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
//                 response_data_JSON["Database_say"] = "上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
//                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                 if (callback) { callback(response_body_String, null); };
//                 return response_body_String;
//             };

//             if (fileName !== "" && fileName !== null) {

//                 web_path = String(path.join(webPath, fileName));
//                 file_data = request_POST_String;

//                 let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                 // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
//                 // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
//                 // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
//                 // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
//                 // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
//                 // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
//                 let file_data_len = Buffer.byteLength(file_data);

//                 // let statsObj = fs.statSync(web_path, {bigint: false});
//                 // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
//                 if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
//                     // console.log("文檔路徑全名: " + web_path);
//                     // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
//                     // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
//                     // console.log("文檔操作權限值: " + String(statsObj.mode));

//                     // 同步判斷文檔權限，後面所有代碼都是，當指定的文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//                     try {
//                         // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//                         fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
//                         // console.log("文檔: " + web_path + " 可以讀寫.");
//                     } catch (error) {
//                         // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
//                         try {
//                             // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
//                             fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
//                             // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
//                             // 常量                    八進制值    說明
//                             // fs.constants.S_IRUSR    0o400      所有者可讀
//                             // fs.constants.S_IWUSR    0o200      所有者可寫
//                             // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
//                             // fs.constants.S_IRGRP    0o40       群組可讀
//                             // fs.constants.S_IWGRP    0o20       群組可寫
//                             // fs.constants.S_IXGRP    0o10       群組可執行或搜索
//                             // fs.constants.S_IROTH    0o4        其他人可讀
//                             // fs.constants.S_IWOTH    0o2        其他人可寫
//                             // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
//                             // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
//                             // 數字	說明
//                             // 7	可讀、可寫、可執行
//                             // 6	可讀、可寫
//                             // 5	可讀、可執行
//                             // 4	唯讀
//                             // 3	可寫、可執行
//                             // 2	只寫
//                             // 1	只可執行
//                             // 0	沒有許可權
//                             // 例如，八進制值 0o765 表示：
//                             // 1) 、所有者可以讀取、寫入和執行該文檔；
//                             // 2) 、群組可以讀和寫入該文檔；
//                             // 3) 、其他人可以讀取和執行該文檔；
//                             // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
//                             // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
//                         } catch (error) {
//                             console.log("指定的待刪除的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
//                             console.error(error);
//                             response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
//                             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                             if (callback) { callback(response_body_String, null); };
//                             // return response_body_String;
//                         };
//                     };

//                     // 同步刪除指定的文檔;
//                     // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                     try {

//                         // 同步刪除指定的文檔;
//                         fs.unlinkSync(web_path);  // 同步刪除，返回值為 undefined;
//                         // Get the files in current diectory;
//                         // after deletion;
//                         // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
//                         // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

//                         // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
//                         response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
//                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         if (callback) { callback(response_body_String, null); };
//                         // return response_body_String;

//                         // // 異步刪除指定的文檔;
//                         // fs.unlink(
//                         //     web_path,
//                         //     function (error) {
//                         //         if (error) {
//                         //             console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
//                         //             console.error(error);
//                         //             response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
//                         //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         //             if (callback) { callback(response_body_String, null); };
//                         //             // return response_body_String;
//                         //         } else {
//                         //             // console.log(`\nDeleted file:\n${web_path}`);
//                         //             // // Get the files in current diectory;
//                         //             // // after deletion;
//                         //             // console.log("\nFiles present in directory:");
//                         //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
//                         //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } ); 

//                         //             // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
//                         //             response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
//                         //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         //             // if (callback) { callback(response_body_String, null); };
//                         //             // return response_body_String;
//                         //         };
//                         //     }
//                         // );

//                         // 同步寫入文檔;
//                         // // console.log(file_data);
//                         // fs.writeFileSync(
//                         //     web_path,
//                         //     file_data,
//                         //     { encoding: "utf8", mode: 0o777, flag: "w+" }
//                         // );  // 返回值為 undefined;
//                         // // // web_path_bytes = new Uint8Array(Buffer.from(web_path));  // 轉換為 Buffer 二進制對象;
//                         // // fs.writeFileSync(web_path, web_path_bytes, { mode: 0o777, flag: "w+" });  // 返回值為 undefined;
//                         // // console.log(web_path_bytes);
//                         // // // let buffer = new Buffer(8);
//                         // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
//                         // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
//                         // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
//                         // // console.log(data_Str);
//                         // console.log("目標文檔: " + web_path + " 寫入成功.");
//                         // // response_body_String = JSON.stringify(result);
//                         // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
//                         // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         // if (callback) { callback(null, response_body_String); };
//                         // // return response_body_String;

//                         // fs.writeFile(
//                         //     web_path,
//                         //     file_data,
//                         //     {
//                         //         encoding: "utf8",
//                         //         mode: 0o777,
//                         //         flag: "w+"
//                         //     },
//                         //     function (error) {
//                         //         if (error) {
//                         //             console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
//                         //             console.error(error);
//                         //             response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
//                         //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         //             if (callback) { callback(response_body_String, null); };
//                         //             // return response_body_String;
//                         //         } else {
//                         //             console.log("目標文檔: " + web_path + " 寫入成功.");
//                         //             // response_body_String = JSON.stringify(result);
//                         //             response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
//                         //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         //             if (callback) { callback(null, response_body_String); };
//                         //             // return response_body_String;
//                         //         };
//                         //     }
//                         // );

//                     } catch (error) {

//                         console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
//                         console.error(error);
//                         response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
//                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         if (callback) { callback(response_body_String, null); };
//                         // return response_body_String;
//                     };

//                 } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

//                     // 同步判斷文檔權限，後面所有代碼都是，當指定的文件夾存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//                     try {
//                         // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//                         fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
//                         // console.log("文件夾: " + web_path + " 可以讀寫.");
//                     } catch (error) {
//                         // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
//                         try {
//                             // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
//                             fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
//                             // console.log("文件夾: " + web_path + " 操作權限修改為可以讀寫.");
//                             // 常量                    八進制值    說明
//                             // fs.constants.S_IRUSR    0o400      所有者可讀
//                             // fs.constants.S_IWUSR    0o200      所有者可寫
//                             // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
//                             // fs.constants.S_IRGRP    0o40       群組可讀
//                             // fs.constants.S_IWGRP    0o20       群組可寫
//                             // fs.constants.S_IXGRP    0o10       群組可執行或搜索
//                             // fs.constants.S_IROTH    0o4        其他人可讀
//                             // fs.constants.S_IWOTH    0o2        其他人可寫
//                             // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
//                             // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
//                             // 數字	說明
//                             // 7	可讀、可寫、可執行
//                             // 6	可讀、可寫
//                             // 5	可讀、可執行
//                             // 4	唯讀
//                             // 3	可寫、可執行
//                             // 2	只寫
//                             // 1	只可執行
//                             // 0	沒有許可權
//                             // 例如，八進制值 0o765 表示：
//                             // 1) 、所有者可以讀取、寫入和執行該文檔；
//                             // 2) 、群組可以讀和寫入該文檔；
//                             // 3) 、其他人可以讀取和執行該文檔；
//                             // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
//                             // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
//                         } catch (error) {
//                             console.log("指定的待刪除的文件夾 [ " + web_path + " ] 無法修改為可讀可寫權限.");
//                             console.error(error);
//                             response_data_JSON["Database_say"] = "指定的待刪除的文件夾 Directory = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
//                             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                             if (callback) { callback(response_body_String, null); };
//                             // return response_body_String;
//                         };
//                     };

//                     // 同步刪除指定的文件夾;
//                     // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
//                     try {

//                         // 同步刪除指定的文件夾;
//                         fs.rmdirSync(web_path, { recursive: true, maxRetries: 0, retryDelay: 100 });  // 同步刪除，返回值為 undefined;
//                         // Get the current filenames;
//                         // in the directory to verify;
//                         // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
//                         // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

//                         // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
//                         response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
//                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         if (callback) { callback(response_body_String, null); };
//                         // return response_body_String;

//                         // // 異步刪除指定的文件夾;
//                         // fs.rmdir(
//                         //     web_path,
//                         //     { 
//                         //         recursive: true,
//                         //         maxRetries: 0,
//                         //         retryDelay: 100
//                         //     },
//                         //     function (error) {
//                         //         if (error) {
//                         //             console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
//                         //             console.error(error);
//                         //             response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
//                         //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         //             if (callback) { callback(response_body_String, null); };
//                         //             // return response_body_String;
//                         //         } else {
//                         //             // console.log(`\nDeleted file:\n${web_path}`);
//                         //             // // Get the files in current diectory;
//                         //             // // after deletion;
//                         //             // console.log("\nFiles present in directory:");
//                         //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
//                         //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

//                         //             // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
//                         //             response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
//                         //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         //             // if (callback) { callback(response_body_String, null); };
//                         //             // return response_body_String;
//                         //         };
//                         //     }
//                         // );

//                         // // 同步創建文件夾;
//                         // fs.mkdirSync(web_path, 0777);
//                         // // 伊布創建文件夾;
//                         // fs.mkdir(
//                         //     web_path,
//                         //     {
//                         //         recursive: true
//                         //     },
//                         //     function (error) {
//                         //         if (error) {
//                         //             console.error(err);
//                         //         } else {
//                         //             console.log('Directory created successfully!');
//                         //         };
//                         //     }
//                         // );

//                     } catch (error) {

//                         console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
//                         console.error(error);
//                         response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
//                         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                         if (callback) { callback(response_body_String, null); };
//                         // return response_body_String;
//                     };

//                 } else {

//                     console.log("指定的待刪除的文檔: " + String(web_path) + " 不存在或無法識別." + "\n" + "file = { " + String(web_path) + " } can not found.");
//                     response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 不存在或無法識別." + "\n" + "file = { " + String(fileName) + " } can not found.";
//                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     if (callback) { callback(response_body_String, null); };
//                     // return response_body_String;
//                 };
//             };

//             // let web_path_index_Html = String(path.join(webPath, "/administrator.html"));
//             // file_data = request_POST_String;
//             // // web_path = String(path.join(webPath, request_url_path));
//             // let currentDirectory = "";
//             // if (fileName === "" || fileName === null) {
//             //     currentDirectory = "/";
//             // } else {
//             //     if (fileName.indexOf("/") !== -1) {
//             //         let tempArray = new Array();
//             //         tempArray = fileName.split("/");
//             //         for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
//             //             if (i === 0) {
//             //                 currentDirectory = tempArray[i];
//             //             } else {
//             //                 currentDirectory = currentDirectory + "/" + tempArray[i];
//             //             };
//             //         };
//             //     } else {
//             //         currentDirectory = "/";
//             //     };
//             // };
//             // web_path = String(path.join(webPath, currentDirectory));

//             // if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

//             //     try {

//             //         // // 同步讀取硬盤文檔;
//             //         // file_data = fs.readFileSync(web_path_index_Html);
//             //         // // console.log("同步讀取文檔: " + file_data.toString());
//             //         // let filesName = fs.readdirSync(web_path);
//             //         // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
//             //         // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
//             //         // filesName.forEach(
//             //         //     function (item) {
//             //         //         // console.log("異步讀取文件夾目錄: " + item.toString());
//             //         //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
//             //         //         if (statsObj.isFile()) {
//             //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
//             //         //         } else if (statsObj.isDirectory()) {
//             //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
//             //         //         } else {};
//             //         //     }
//             //         // );
//             //         // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
//             //         // // console.log(response_body_String);
//             //         // // return response_body_String;

//             //         // 異步讀取硬盤文檔;
//             //         fs.readFile(
//             //             web_path_index_Html,
//             //             function (error, data) {

//             //                 if (error) {
//             //                     console.error(error);
//             //                     response_data_JSON["Database_say"] = String(error);
//             //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //                     if (callback) { callback(response_body_String, null); };
//             //                     // return response_body_String;
//             //                 };

//             //                 if (data) {
//             //                     file_data = data;
//             //                     // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
//             //                     fs.readdir(
//             //                         web_path,
//             //                         function (error, filesName) {

//             //                             if (error) {
//             //                                 console.error(error);
//             //                                 response_data_JSON["Database_say"] = String(error);
//             //                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //                                 if (callback) { callback(response_body_String, null); };
//             //                                 // return response_body_String;
//             //                             };

//             //                             if (filesName) {
//             //                                 let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
//             //                                 // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
//             //                                 filesName.forEach(
//             //                                     function (item) {
//             //                                         // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
//             //                                         let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
//             //                                         let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
//             //                                         let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
//             //                                         let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
//             //                                         // console.log("異步讀取文件夾目錄: " + item.toString());
//             //                                         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
//             //                                         if (statsObj.isFile()) {
//             //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
//             //                                         directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
//             //                                         // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//             //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//             //                                         } else if (statsObj.isDirectory()) {
//             //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
//             //                                         directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
//             //                                         // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//             //                                         } else {};
//             //                                     }
//             //                                 );
//             //                                 response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
//             //                                 // console.log(response_body_String);
//             //                                 if (callback) { callback(null, response_body_String); };
//             //                                 // return response_body_String;
//             //                             };
//             //                         }
//             //                     );
//             //                 };
//             //             }
//             //         );

//             //     } catch (error) {
//             //         console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
//             //         console.error(error);
//             //         response_data_JSON["Database_say"] = String(error);
//             //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //         if (callback) { callback(response_body_String, null); };
//             //         // return response_body_String;
//             //     } finally {
//             //         // fs.close();
//             //     };
//             // };

//             return response_body_String;
//         }

//         case "/LC5PFit": {
//         // 讀取用戶端（前端 Client）發送的請求數據（Request），並進行四參數邏輯回歸擬合（5 parameter Logistic fitting）運算，並向用戶端（前端 Client）返回運算結果數據;

//             request_POST_JSON = {
//                 'trainXdata': [
//                     0.00001,  // parseFloat(0.00001),
//                     1,  // parseFloat(1),
//                     2,  // parseFloat(2),
//                     3,  // parseFloat(3),
//                     4,  // parseFloat(4),
//                     5,  // parseFloat(5),
//                     6,  // parseFloat(6),
//                     7,  // parseFloat(7),
//                     8,  // parseFloat(8),
//                     9,  // parseFloat(9),
//                     10  // parseFloat(10)
//                 ],
//                 'trainYdata_1': [
//                     100,  // parseFloat(100),
//                     200,  // parseFloat(200),
//                     300,  // parseFloat(300),
//                     400,  // parseFloat(400),
//                     500,  // parseFloat(500),
//                     600,  // parseFloat(600),
//                     700,  // parseFloat(700),
//                     800,  // parseFloat(800),
//                     900,  // parseFloat(900),
//                     1000,  // parseFloat(1000),
//                     1100  // parseFloat(1100)
//                 ],
//                 'trainYdata_2': [
//                     98,  // parseFloat(98),
//                     198,  // parseFloat(198),
//                     298,  // parseFloat(298),
//                     398,  // parseFloat(398),
//                     498,  // parseFloat(498),
//                     598,  // parseFloat(598),
//                     698,  // parseFloat(698),
//                     798,  // parseFloat(798),
//                     898,  // parseFloat(898),
//                     998,  // parseFloat(998),
//                     1098  // parseFloat(1098)
//                 ],
//                 'trainYdata_3': [
//                     102,  // parseFloat(102),
//                     202,  // parseFloat(202),
//                     302,  // parseFloat(302),
//                     402,  // parseFloat(402),
//                     502,  // parseFloat(502),
//                     602,  // parseFloat(602),
//                     702,  // parseFloat(702),
//                     802,  // parseFloat(802),
//                     902,  // parseFloat(902),
//                     1002,  // parseFloat(1002),
//                     1102  // parseFloat(1102)
//                 ],
//                 'weight': [
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5,  // parseFloat(0.5),
//                     0.5  // parseFloat(0.5)
//                 ],
//                 'Pdata_0': [
//                     90,  // parseFloat(90),
//                     4,  // parseFloat(4),
//                     1,  // parseFloat(1),
//                     1210  // parseFloat(1210)
//                 ],
//                 'Plower': [
//                     '-inf',  // -Infinity,
//                     '-inf',  // -Infinity,
//                     '-inf',  // -Infinity,
//                     '-inf'  // -Infinity
//                 ],
//                 'Pupper': [
//                     '+inf',  // +Infinity,
//                     '+inf',  // +Infinity,
//                     '+inf',  // +Infinity,
//                     '+inf'  // +Infinity
//                 ],
//                 'testYdata_1': [
//                     150,  // parseFloat(150),
//                     200,  // parseFloat(200),
//                     250,  // parseFloat(250),
//                     350,  // parseFloat(350),
//                     450,  // parseFloat(450),
//                     550,  // parseFloat(550),
//                     650,  // parseFloat(650),
//                     750,  // parseFloat(750),
//                     850,  // parseFloat(850),
//                     950,  // parseFloat(950),
//                     1050  // parseFloat(1050)
//                 ],
//                 'testYdata_2': [
//                     148,  // parseFloat(148),
//                     198,  // parseFloat(198),
//                     248,  // parseFloat(248),
//                     348,  // parseFloat(348),
//                     448,  // parseFloat(448),
//                     548,  // parseFloat(548),
//                     648,  // parseFloat(648),
//                     748,  // parseFloat(748),
//                     848,  // parseFloat(848),
//                     948,  // parseFloat(948),
//                     1048  // parseFloat(1048)
//                 ],
//                 'testYdata_3': [
//                     152,  // parseFloat(152),
//                     202,  // parseFloat(202),
//                     252,  // parseFloat(252),
//                     352,  // parseFloat(352),
//                     452,  // parseFloat(452),
//                     552,  // parseFloat(552),
//                     652,  // parseFloat(652),
//                     752,  // parseFloat(752),
//                     852,  // parseFloat(852),
//                     952,  // parseFloat(952),
//                     1052  // parseFloat(1052)
//                 ],
//                 'testXdata': [
//                     0.5,  // parseFloat(0.5),
//                     1,  // parseFloat(1),
//                     1.5,  // parseFloat(1.5),
//                     2.5,  // parseFloat(2.5),
//                     3.5,  // parseFloat(3.5),
//                     4.5,  // parseFloat(4.5),
//                     5.5,  // parseFloat(5.5),
//                     6.5,  // parseFloat(6.5),
//                     7.5,  // parseFloat(7.5),
//                     8.5,  // parseFloat(8.5),
//                     9.5  // parseFloat(9.5)
//                 ],
//                 'trainYdata': [
//                     [100, 98, 102],  // [parseFloat(100), parseFloat(98), parseFloat(102)],
//                     [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
//                     [300, 298, 302],  // [parseFloat(300), parseFloat(298), parseFloat(302)],
//                     [400, 398, 402],  // [parseFloat(400), parseFloat(398), parseFloat(402)],
//                     [500, 498, 502],  // [parseFloat(500), parseFloat(498), parseFloat(502)],
//                     [600, 598, 602],  // [parseFloat(600), parseFloat(598), parseFloat(602)],
//                     [700, 698, 702],  // [parseFloat(700), parseFloat(698), parseFloat(702)],
//                     [800, 798, 802],  // [parseFloat(800), parseFloat(798), parseFloat(802)],
//                     [900, 898, 902],  // [parseFloat(900), parseFloat(898), parseFloat(902)],
//                     [1000, 998, 1002],  // [parseFloat(1000), parseFloat(998), parseFloat(1002)],
//                     [1100, 1098, 1102]  // [parseFloat(1100), parseFloat(1098), parseFloat(1102)]
//                 ],
//                 'testYdata': [
//                     [150, 148, 152],  // [parseFloat(150), parseFloat(148), parseFloat(152)],
//                     [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
//                     [250, 248, 252],  // [parseFloat(250), parseFloat(248), parseFloat(252)],
//                     [350, 348, 352],  // [parseFloat(350), parseFloat(348), parseFloat(352)],
//                     [450, 448, 452],  // [parseFloat(450), parseFloat(448), parseFloat(452)],
//                     [550, 548, 552],  // [parseFloat(550), parseFloat(548), parseFloat(552)],
//                     [650, 648, 652],  // [parseFloat(650), parseFloat(648), parseFloat(652)],
//                     [750, 748, 752],  // [parseFloat(750), parseFloat(748), parseFloat(752)],
//                     [850, 848, 852],  // [parseFloat(850), parseFloat(848), parseFloat(852)],
//                     [950, 948, 952],  // [parseFloat(950), parseFloat(948), parseFloat(952)],
//                     [1050, 1048, 1052]  // [parseFloat(1050), parseFloat(1048), parseFloat(1052)]
//                 ]
//             };

//             let Plower = [
//                 -Infinity,
//                 -Infinity,
//                 -Infinity,
//                 -Infinity
//                 // -Infinity
//             ];
//             if (request_POST_JSON.hasOwnProperty("Plower")) {
//                 if (request_POST_JSON["Plower"].length > 0) {
//                     // Plower = request_POST_JSON["Plower"];
//                     Plower = new Array;
//                     for (let i = 0; i < request_POST_JSON["Plower"].length; i++) {
//                         if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "+Base.Inf" || request_POST_JSON["Plower"][i] === "+Inf" || request_POST_JSON["Plower"][i] === "+inf" || request_POST_JSON["Plower"][i] === "+Infinity" || request_POST_JSON["Plower"][i] === "+infinity" || request_POST_JSON["Plower"][i] === "Base.Inf" || request_POST_JSON["Plower"][i] === "Inf" || request_POST_JSON["Plower"][i] === "inf" || request_POST_JSON["Plower"][i] === "Infinity" || request_POST_JSON["Plower"][i] === "infinity")) {
//                             Plower.push(+Infinity);
//                         } else if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "-Base.Inf" || request_POST_JSON["Plower"][i] === "-Inf" || request_POST_JSON["Plower"][i] === "-inf" || request_POST_JSON["Plower"][i] === "-Infinity" || request_POST_JSON["Plower"][i] === "-infinity")) {
//                             Plower.push(-Infinity);
//                         } else {
//                             Plower.push(parseFloat(request_POST_JSON["Plower"][i]));
//                         };
//                     };
//                 };
//             };
//             // console.log(Plower);

//             let Pupper = [
//                 +Infinity,
//                 +Infinity,
//                 +Infinity,
//                 +Infinity
//                 // +Infinity
//             ];
//             if (request_POST_JSON.hasOwnProperty("Pupper")) {
//                 if (request_POST_JSON["Pupper"].length > 0) {
//                     // Pupper = request_POST_JSON["Pupper"];
//                     Pupper = new Array;
//                     for (let i = 0; i < request_POST_JSON["Pupper"].length; i++) {
//                         if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "+Base.Inf" || request_POST_JSON["Pupper"][i] === "+Inf" || request_POST_JSON["Pupper"][i] === "+inf" || request_POST_JSON["Pupper"][i] === "+Infinity" || request_POST_JSON["Pupper"][i] === "+infinity" || request_POST_JSON["Pupper"][i] === "Base.Inf" || request_POST_JSON["Pupper"][i] === "Inf" || request_POST_JSON["Pupper"][i] === "inf" || request_POST_JSON["Pupper"][i] === "Infinity" || request_POST_JSON["Pupper"][i] === "infinity")) {
//                             Pupper.push(+Infinity);
//                         } else if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "-Base.Inf" || request_POST_JSON["Pupper"][i] === "-Inf" || request_POST_JSON["Pupper"][i] === "-inf" || request_POST_JSON["Pupper"][i] === "-Infinity" || request_POST_JSON["Pupper"][i] === "-infinity")) {
//                             Pupper.push(-Infinity);
//                         } else {
//                             Pupper.push(parseFloat(request_POST_JSON["Pupper"][i]));
//                         };
//                     };
//                 };
//             };
//             // console.log(Pupper);

//             // if ((Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length > 0 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}')) || (typeof (request_POST_JSON) === 'object' && Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object object]' && !(request_POST_JSON.length) && JSON.stringify(request_POST_JSON) !== '{}')) {

//             //     if (MongoDBClient !== null) {

//             //         // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

//             //         // // let result = await MongoDBClient.db(dbName).collection(dbTableName).insertMany(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 數組;
//             //         // response_data_JSON["Database_say"] = JSON.stringify(result);
//             //         // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //         // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //         // // return response_body_String;

//             //         // 注意，在使用 insertMany() 函數插入多條文檔的時候，在參數 ordered 為 true 值的情況下，如果其中一條數據出現錯誤（比如主鍵重複之類的錯誤），那麽會導致所有數據都無法被插入，反之，如果參數 ordered 為 false 值的情況下，只有出錯的數據無法被插入；可以使用 db.dbName.insertMany([], { ordered: false }) 方法來控制是否按順序插入多條數據。
//             //         MongoDBClient.db(dbName).collection(dbTableName).insertMany(
//             //             request_POST_JSON,
//             //             {
//             //                 ordered: false
//             //             },
//             //             function (error, result) {
//             //                 if (error) {
//             //                     console.error(error);
//             //                     response_data_JSON["Database_say"] = String(error);
//             //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //                     if (callback) { callback(response_body_String, null); };
//             //                     // return response_body_String;
//             //                 };
//             //                 if (result) {
//             //                     // console.log("向數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中插入 " + String(result.insertedCount) + " 條數據成功.");
//             //                     // console.log(result);
//             //                     // response_body_String = JSON.stringify(result);
//             //                     response_data_JSON["Database_say"] = JSON.stringify(result);
//             //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //                     if (callback) { callback(null, response_body_String); };
//             //                     // return response_body_String;
//             //                 };
//             //             }
//             //         );
    
//             //     } else {
    
//             //         console.log("Database error.");
//             //         response_data_JSON["Database_say"] = "Database error.";
//             //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //         if (callback) { callback(response_body_String, null); };
//             //         // return response_body_String;
//             //     };
    
//             // } else {
    
//             //     console.log("error, data is empty.");
//             //     response_data_JSON["Database_say"] = "error, data is empty.";
//             //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //     if (callback) { callback(response_body_String, null); };
//             //     // return response_body_String;
//             // };
    

//             // if (MongoDBClient !== null) {

//             //     // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

//             //     // let result = await MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray();  // 變量 request_POST_JSON 為 JSON 對象;
//             //     // response_data_JSON["Database_say"] = JSON.stringify(result);
//             //     // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //     // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //     // // return response_body_String;

//             //     MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray(
//             //         function (error, result) {
//             //             if (error) {
//             //                 console.error(error);
//             //                 response_data_JSON["Database_say"] = String(error);
//             //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //                 if (callback) { callback(response_body_String, null); };
//             //                 // return response_body_String;
//             //             };
//             //             if (result) {
//             //                 // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中查詢數據成功.");
//             //                 // console.log(result);
//             //                 // response_body_String = JSON.stringify(result);
//             //                 response_data_JSON["Database_say"] = JSON.stringify(result);
//             //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //                 if (callback) { callback(null, response_body_String); };
//             //                 // return response_body_String;
//             //             };
//             //         }
//             //     );

//             // } else {

//             //     console.log("Database error.");
//             //     response_data_JSON["Database_say"] = "Database error.";
//             //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//             //     if (callback) { callback(response_body_String, null); };
//             //     // return response_body_String;
//             // };

//             response_data_JSON = {
//                 "Coefficient": [
//                     100.007982422761,
//                     42148.4577551448,
//                     1.0001564001486,
//                     4221377.92224082
//                 ],
//                 "Coefficient-StandardDeviation": [
//                     0.00781790123184812,
//                     2104.76673086505,
//                     0.0000237490808220821,
//                     210359.023599377
//                 ],
//                 "Coefficient-Confidence-Lower-95%": [
//                     99.9908250045862,
//                     37529.2688077105,
//                     1.0001042796499,
//                     3759717.22485611
//                 ],
//                 "Coefficient-Confidence-Upper-95%": [
//                     100.025139840936,
//                     46767.6467025791,
//                     1.00020852064729,
//                     4683038.61962554
//                 ],
//                 "Yfit": [
//                     100.008980483748,
//                     199.99155580718,
//                     299.992070696316,
//                     399.99603100866,
//                     500.000567344017,
//                     600.00431688223,
//                     700.006476967595,
//                     800.006517272442,
//                     900.004060927778,
//                     999.998826196417,
//                     1099.99059444852
//                 ],
//                 "Yfit-Uncertainty-Lower": [
//                     99.0089499294379,
//                     198.991136273453,
//                     298.990136898385,
//                     398.991624763274,
//                     498.99282487668,
//                     598.992447662226,
//                     698.989753032473,
//                     798.984266632803,
//                     898.975662941844,
//                     998.963708008532,
//                     1098.94822805642
//                 ],
//                 "Yfit-Uncertainty-Upper": [
//                     101.00901103813,
//                     200.991951293373,
//                     300.993902825086,
//                     401.000210884195,
//                     501.007916682505,
//                     601.015588680788,
//                     701.022365894672,
//                     801.027666045591,
//                     901.031064750697,
//                     1001.0322361364,
//                     1101.0309201882
//                 ],
//                 "Residual": [
//                     0.00898048374801874,
//                     -0.00844419281929731,
//                     -0.00792930368334055,
//                     -0.00396899133920669,
//                     0.000567344017326831,
//                     0.00431688223034143,
//                     0.00647696759551763,
//                     0.00651727244257926,
//                     0.00406092777848243,
//                     -0.00117380358278751,
//                     -0.00940555147826671
//                 ],
//                 "testData": {
//                     "Ydata": [
//                         [150, 148, 152],
//                         [200, 198, 202],
//                         [250, 248, 252],
//                         [350, 348, 352],
//                         [450, 448, 452],
//                         [550, 548, 552],
//                         [650, 648, 652],
//                         [750, 748, 752],
//                         [850, 848, 852],
//                         [950, 948, 952],
//                         [1050, 1048, 1052]
//                     ],
//                     "test-Xvals": [
//                         0.500050586546119,
//                         1.00008444458554,
//                         1.50008923026377,
//                         2.50006143908055,
//                         3.50001668919562,
//                         4.49997400999207,
//                         5.49994366811569,
//                         6.49993211621922,
//                         7.49994379302719,
//                         8.49998194168741,
//                         9.50004903674755
//                     ],
//                     "test-Xvals-Uncertainty-Lower": [
//                         0.499936310423273,
//                         0.999794808816128,
//                         1.49963107921017,
//                         2.49927920023971,
//                         3.49892261926065,
//                         4.49857747071072,
//                         5.4982524599721,
//                         6.4979530588239,
//                         7.49768303155859,
//                         8.49744512880161,
//                         9.49724144950174
//                     ],
//                     "test-Xvals-Uncertainty-Upper": [
//                         0.500160692642957,
//                         1.00036584601127,
//                         1.50053513648402,
//                         2.5008235803856,
//                         3.50108303720897,
//                         4.50133543331854,
//                         5.50159259771137,
//                         6.50186196458511,
//                         7.50214864756277,
//                         8.50245638268284,
//                         9.50278802032924
//                     ],
//                     "Xdata": [
//                         0.5,
//                         1,
//                         1.5,
//                         2.5,
//                         3.5,
//                         4.5,
//                         5.5,
//                         6.5,
//                         7.5,
//                         8.5,
//                         9.5
//                     ],
//                     "test-Yfit": [
//                         149.99283432168886,
//                         199.98780598165467,
//                         249.98704946506768,
//                         349.9910371559672,
//                         449.9975369446911,
//                         550.0037557953037,
//                         650.0081868763082,
//                         750.0098833059892,
//                         850.0081939375959,
//                         950.002643218264,
//                         1049.9928684998304
//                     ],
//                     "test-Yfit-Uncertainty-Lower": [],
//                     "test-Yfit-Uncertainty-Upper": [],
//                     "test-Residual": [
//                         [0.000050586546119],
//                         [0.00008444458554],
//                         [0.00008923026377],
//                         [0.00006143908055],
//                         [0.00001668919562],
//                         [-0.00002599000793],
//                         [-0.0000563318843],
//                         [-0.00006788378077],
//                         [-0.0000562069728],
//                         [-0.00001805831259],
//                         [0.00004903674755]
//                     ]
//                 },
//                 "request_Url": '/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit',
//                 "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
//                 "request_Cookie": 'Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
//                 "time": '2024-02-03 17:59:58.239794',
//                 "Server_say": '',
//                 "error": ''
//             };

//             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//             // String = JSON.stringify(JSON); JSON = JSON.parse(String);

//             // response_body_String = request_POST_String;
//             if (callback) { callback(null, response_body_String); };
//             return response_body_String;
//         }

//         default: {

//             let web_path_index_Html = String(path.join(webPath, "/administrator.html"));
//             // web_path = String(path.join(webPath, request_url_path));
//             file_data = null;

//             if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {

//                 try {

//                     // // 同步讀取硬盤文檔;
//                     // file_data = fs.readFileSync(web_path);
//                     // // console.log("同步讀取文檔: " + file_data.toString());
//                     // response_body_String = file_data.toString();
//                     // // console.log(response_body_String);
//                     // // return response_body_String;

//                     // 異步讀取硬盤文檔;
//                     fs.readFile(
//                         web_path,
//                         function (error, data) {

//                             if (error) {
//                                 console.error(error);
//                                 response_data_JSON["Database_say"] = String(error);
//                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                 if (callback) { callback(response_body_String, null); };
//                                 // return response_body_String;
//                             };

//                             if (data) {

//                                 let file_data_Buffer = data;
//                                 // let buffer = new ArrayBuffer(TemporaryPublicVariableCollectResultStoredStringArray.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
//                                 // let file_data_bytes_Uint8Array = new Uint8Array(buffer);  // 轉換為 Buffer 二進制對象;
//                                 // for (let i = 0; i < TemporaryPublicVariableCollectResultStoredStringArray.length; i++) {
//                                 //     file_data_bytes_Uint8Array[i] = TemporaryPublicVariableCollectResultStoredStringArray[i];
//                                 // };
//                                 // file_data_String = file_data_bytes_Uint8Array.toString();
//                                 file_data_Buffer = new Uint8Array(file_data_Buffer);
//                                 // console.log(file_data_Buffer);
//                                 // file_data = file_data_Buffer.toString();
//                                 // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
//                                 // file_data = JSON.stringify(file_data_Buffer);  // JSON.parse(file_data);
//                                 let file_data_Uint8Array = new Array();
//                                 for (let i = 0; i < file_data_Buffer.length; i++) {
//                                     file_data_Uint8Array.push(file_data_Buffer[i]);
//                                     // file_data_Uint8Array.push(String(file_data_Buffer[i]));
//                                 };
//                                 file_data = JSON.stringify(file_data_Uint8Array);  // JSON.parse(file_data);
//                                 response_body_String = file_data;
//                                 // console.log(response_body_String);
//                                 if (callback) { callback(null, response_body_String); };
//                             };
//                         }
//                     );

//                 } catch (error) {
//                     console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
//                     console.error(error);
//                     response_data_JSON["Database_say"] = String(error);
//                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     if (callback) { callback(response_body_String, null); };
//                     // return response_body_String;
//                 } finally {
//                     // fs.close();
//                 };

//             } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

//                 try {

//                     // // 同步讀取硬盤文檔;
//                     // file_data = fs.readFileSync(web_path_index_Html);
//                     // // console.log("同步讀取文檔: " + file_data.toString());
//                     // let filesName = fs.readdirSync(web_path);
//                     // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
//                     // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
//                     // filesName.forEach(
//                     //     function (item) {
//                     //         // console.log("異步讀取文件夾目錄: " + item.toString());
//                     //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
//                     //         if (statsObj.isFile()) {
//                     //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
//                     //         } else if (statsObj.isDirectory()) {
//                     //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
//                     //         } else {};
//                     //     }
//                     // );
//                     // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
//                     // // console.log(response_body_String);
//                     // // return response_body_String;

//                     // 異步讀取硬盤文檔;
//                     fs.readFile(
//                         web_path_index_Html,
//                         function (error, data) {

//                             if (error) {
//                                 console.error(error);
//                                 response_data_JSON["Database_say"] = String(error);
//                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                 if (callback) { callback(response_body_String, null); };
//                                 // return response_body_String;
//                             };

//                             if (data) {
//                                 file_data = data;
//                                 // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
//                                 fs.readdir(
//                                     web_path,
//                                     function (error, filesName) {

//                                         if (error) {
//                                             console.error(error);
//                                             response_data_JSON["Database_say"] = String(error);
//                                             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                                             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                                             if (callback) { callback(response_body_String, null); };
//                                             // return response_body_String;
//                                         };

//                                         if (filesName) {
//                                             let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
//                                             // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
//                                             filesName.forEach(
//                                                 function (item) {
//                                                     // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
//                                                     let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
//                                                     let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
//                                                     let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
//                                                     let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
//                                                     // console.log("異步讀取文件夾目錄: " + item.toString());
//                                                     let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
//                                                     if (statsObj.isFile()) {
//                                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
//                                                         directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
//                                                         // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//                                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//                                                     } else if (statsObj.isDirectory()) {
//                                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
//                                                         directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
//                                                         // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
//                                                     } else {};
//                                                 }
//                                             );
//                                             response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
//                                             // console.log(response_body_String);
//                                             if (callback) { callback(null, response_body_String); };
//                                             // return response_body_String;
//                                         };
//                                     }
//                                 );
//                             };
//                         }
//                     );

//                 } catch (error) {
//                     console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
//                     console.error(error);
//                     response_data_JSON["Database_say"] = String(error);
//                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                     if (callback) { callback(response_body_String, null); };
//                     // return response_body_String;
//                 } finally {
//                     // fs.close();
//                 };

//             } else {

//                 console.log("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(web_path) + " } 無法識別.");
//                 response_data_JSON["Database_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(fileName) + " } 無法識別.";
//                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
//                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
//                 if (callback) { callback(response_body_String, null); };
//                 // return response_body_String;
//             };

//             return response_body_String;
//         }
//     };
// };



// http_Server_「http」;

// let webPath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// // let webPath = String(require('path').join(String(__dirname), "html"));
// let Key = "username:password";  // 自定義的訪問網站簡單驗證用戶名和密碼;
// let Session = { "request_Key->username:password": Key };  // 自定義 session 值，JSON 對象;
// let host = "::0";  // "::0" or "::1" or "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// let port = 10001;  // 1 ~ 65535 監聽端口;
// let number_cluster_Workers = parseInt(0);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
// // let do_Function_JSON = "";  // { "do_Request": do_Request_Router }; JSON 對象，用於使用 Node.js 服務器監聽到請求數據後，執行具體功能的函數;
// let do_Request = function (argument) { return argument; };  // 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     try {
//                         if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                             eval(process.argv[i] + ";");
//                         };
//                         if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                             // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                             eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                         };
//                         if (process.argv[i].split("=")[0] === "Session") {
//                             if (isStringJSON(process.argv[i].split('=')[1])) {
//                                 eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                             } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                                 eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                             } else {
//                                 eval(process.argv[i] + ";");
//                             };
//                         };
//                         if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                             eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                         } else {
//                             do_Request = null;
//                         };
//                         console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     } catch (error) {
//                         console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                         console.log(error);
//                     };
//                     // switch (process.argv[i].split("=")[0]) {
//                     //     case "Key": {
//                     //         Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                     //         // console.log("Server UserName and PassWord: " + Key);
//                     //         break;
//                     //     }
//                     //     case "host": {
//                     //         host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                     //         // console.log("Host domain name: " + host);
//                     //         break;
//                     //     }
//                     //     case "port": {
//                     //         port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                     //         // console.log("listening Port: " + port);
//                     //         break;
//                     //     }
//                     //     case "webPath": {
//                     //         webPath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 監聽端口;
//                     //         // console.log("http Server root directory: " + webPath);
//                     //         break;
//                     //     }
//                     //     case "number_cluster_Workers": {
//                     //         number_cluster_Workers = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
//                     //         // console.log("number cluster Workers: " + number_cluster_Workers);
//                     //         break;
//                     //     }
//                     //     case "Session": {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             Session = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             Session[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             Session = null;
//                     //         };
//                     //         // console.log("Server Session: " + Session);
//                     //         break;
//                     //     }
//                     //     case "do_Request": {
//                     //         // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
//                     //         if (Object.prototype.toString.call(do_Request = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //             do_Request = eval(process.argv[i].split('=')[1]);
//                     //         } else {
//                     //             do_Request = null;
//                     //         };
//                     //         // console.log("do_Request: " + do_Request);
//                     //         break;
//                     //     }
//                     //     default: {
//                     //         console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     }
//                     // };
//                 };
//             };
//         };
//     };
// };


// class WorkerPoolTaskInfo extends AsyncResource {
//     constructor(callback) {
//         super('WorkerPoolTaskInfo');
//         this.callback = callback;
//     };

//     done(err, result) {
//         this.runInAsyncScope(this.callback, null, err, result);
//         this.emitDestroy();  // `TaskInfo`s are used only once.
//     };
// };

// class http_Server extends EventEmitter {
//     constructor(host, port, number_cluster_Workers, Key, Session, do_Function_JSON) {
//         super();
//         if (port !== null && port !== "") {
//             this.port = parseInt(port);
//         } else {
//             this.port = parseInt(8000);
//         };
//         this.workers = [];

//         this.help = `
//             // 使用示例 This pool could be used as follows;
//             // http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource            
//         `;
//     };

//     http_Server() {};

//     close() {
//         for (const worker of this.workers) { worker.terminate(); };
//     };
// };

function http_Server() {

    // 可變參數傳值;
    // for (let i = 0; i < arguments.length; i++) {
    //     console.log(arguments[i]);
    // };
    let argument_1 = arguments[0];

    // 配置預設值;
    let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
    let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
    // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
    let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
    let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
    let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
    // 配置子綫程運行時脚本參數 "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
    let host = "0.0.0.0";  // "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
    // 配置監聽埠號（端口）參數;
    let port = parseInt(8000);  // 1 ~ 65535;
    // 配置創建集群子進程數目參數預設值;
    let number_cluster_Workers = parseInt(0);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
    // console.log(number_cluster_Workers);
    // 自定義的訪問網站簡單驗證用戶名和密碼;
    let Key = "";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
    let Session = {};
    // 函數 do_Request;
    let do_Request = function (argument1, argument2, argument3, callback) { callback(null, argument1); return argument1; };
    // do_Request = do_Request_Router;

    // 讀取傳入參數的可變參數值;
    if (typeof (argument_1) !== undefined && argument_1 !== undefined) {
        if (typeof (argument_1) === 'object' && Object.prototype.toString.call(argument_1).toLowerCase() === '[object object]' && !(argument_1.length)) {
            // 配置監聽主機域名 Host domain name;
            if (argument_1.hasOwnProperty("host") && typeof (argument_1["host"]) !== undefined && argument_1["host"] !== undefined && argument_1["host"] !== null && argument_1["host"] !== NaN && argument_1["host"] !== "") {
                host = String(argument_1["host"]);  // typeof (host) === "String";
            };
            // 配置監聽埠號（端口）參數 1 ~ 65535;
            if (argument_1.hasOwnProperty("port") && typeof (argument_1["port"]) !== undefined && argument_1["port"] !== undefined && argument_1["port"] !== null && argument_1["port"] !== NaN && argument_1["port"] !== "") {
                port = parseInt(argument_1["port"]);  // typeof (port) === "Number";
            };
            // 配置創建集群子進程數目參數預設值 os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
            if (argument_1.hasOwnProperty("number_cluster_Workers") && typeof (argument_1["number_cluster_Workers"]) !== undefined && argument_1["number_cluster_Workers"] !== undefined && argument_1["number_cluster_Workers"] !== null && argument_1["number_cluster_Workers"] !== NaN && argument_1["number_cluster_Workers"] !== "") {
                number_cluster_Workers = parseInt(argument_1["number_cluster_Workers"]);  // typeof (number_cluster_Workers) === "Number";
            };
            // 配置自定義的訪問網站簡單驗證用戶名和密碼 "username:password";
            if (argument_1.hasOwnProperty("Key") && typeof (argument_1["Key"]) !== undefined && argument_1["Key"] !== undefined && argument_1["Key"] !== null && argument_1["Key"] !== NaN && argument_1["Key"] !== "") {
                Key = String(argument_1["Key"]);  // typeof (Key) === "String";
            };
            // 配置自定義 session 值，JSON 對象 { "request_Key->username:password": Key };
            if ((argument_1.hasOwnProperty("Session") && typeof (argument_1["Session"]) === 'object' && Object.prototype.toString.call(argument_1["Session"]).toLowerCase() === '[object object]' && !(argument_1["Session"].length)) && Object.keys(argument_1["Session"]).length > 0) {
                Session = argument_1["Session"];
            } else if (argument_1.hasOwnProperty("Session") && Object.prototype.toString.call(argument_1["Session"]).toLowerCase() === '[object string]') {
                // 使用自定義封裝的函數isStringJSON(str)判斷一個字符串是否爲 JSON 格式的字符串;
                if (isStringJSON(argument_1["Session"])) {
                    Session = JSON.parse(argument_1["Session"]);
                    // JSON.stringify();
                };
            } else {};
            // 直接傳入函數或函數字符串，具體處理數據的函數 do_Request;
            if (argument_1.hasOwnProperty("do_Request") && typeof (argument_1["do_Request"]) !== undefined && argument_1["do_Request"] !== undefined && argument_1["do_Request"] !== null && argument_1["do_Request"] !== NaN && argument_1["do_Request"] !== "") {
                // 使用 Object.prototype.toString.call(argument_1["do_Request"]).toLowerCase() === '[object function]' 方法判斷對象是否是一個函數 typeof(fn)==='function';
                if (Object.prototype.toString.call(argument_1["do_Request"]).toLowerCase() === '[object function]' || (Object.prototype.toString.call(argument_1["do_Request"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(argument_1["do_Request"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Request = " + argument_1["do_Request"] + ';')).toLowerCase() === '[object function]'))) {
                    // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                    do_Request = argument_1["do_Request"];
                    // eval("do_Request = " + argument_1["do_Request"] + ";");
                } else if (Object.prototype.toString.call(argument_1["do_Request"]).toLowerCase() === '[object string]') {
                    // 以 function mytFunc(argument) {} 形式的函數傳值;
                    eval(argument_1["do_Request"]);
                    // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                    // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                    eval("do_Request = " + argument_1["do_Request"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                } else {
                    console.log("傳入的用於處理數據的函數參數 do_Request: " + argument_1["do_Request"] + " 無法識別");
                    eval("do_Request = function (argument1, argument2, argument3, callback) { callback(null, argument1); return argument1; };");
                    // do_Request = argument_1["do_Request"];
                };
            };
            // 以 JSON 對象形式傳入函數或函數字符串，具體處理數據的函數 do_Function_JSON;
            // let do_Request = null;
            if ((argument_1.hasOwnProperty("do_Function_JSON") && typeof (argument_1["do_Function_JSON"]) === 'object' && Object.prototype.toString.call(argument_1["do_Function_JSON"]).toLowerCase() === '[object object]' && !(argument_1["do_Function_JSON"].length)) && Object.keys(argument_1["do_Function_JSON"]).length > 0) {
                for (let key in argument_1["do_Function_JSON"]) {
                    if (eval('typeof (' + key + ')' + ' === undefined && ' + key + ' === undefined')) {
                        // eval('var ' + key + ' = null;');
                    } else {
                        // 使用 Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object function]' 方法判斷對象是否是一個函數 typeof(fn)==='function';
                        if (Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object function]' || (typeof (argument_1["do_Function_JSON"][key]) !== undefined && argument_1["do_Function_JSON"][key] !== undefined && argument_1["do_Function_JSON"][key] !== null && argument_1["do_Function_JSON"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(argument_1["do_Function_JSON"][key])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval(key + " = " + argument_1["do_Function_JSON"][key] + ';')).toLowerCase() === '[object function]'))) {
                            // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                            eval(key + " = " + argument_1["do_Function_JSON"][key] + ";");
                        } else if (typeof (argument_1["do_Function_JSON"][key]) !== undefined && argument_1["do_Function_JSON"][key] !== undefined && argument_1["do_Function_JSON"][key] !== null && argument_1["do_Function_JSON"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object string]') {
                            // 以 function mytFunc(argument) {} 形式的函數傳值;
                            eval(argument_1["do_Function_JSON"][key]);
                            // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                            // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                            eval(key + " = " + argument_1["do_Function_JSON"][key].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                        } else {
                            console.log("傳入的用於處理數據的函數參數 do_Function_JSON, key: " + key + " , value: " + argument_1["do_Function_JSON"][key] + " 無法識別");
                            eval(key + " = function (argument1, argument2, argument3, callback) { callback(null, argument1); return argument1; };");
                            // eval(key + " = " + argument_1["do_Function_JSON"][key] + ";");
                        };
                        // switch (key) {
                        //     case "do_Request": {
                        //         // 判斷傳入的參數 argument_1["do_Function_JSON"][key]，是直接傳入的函數對象，還是傳入的函數名字字符串;
                        //         if (Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object function]') {
                        //             do_Request = argument_1["do_Function_JSON"][key];
                        //         } else if (typeof (argument_1["do_Function_JSON"][key]) !== undefined && argument_1["do_Function_JSON"][key] !== undefined && argument_1["do_Function_JSON"][key] !== null && argument_1["do_Function_JSON"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(argument_1["do_Function_JSON"][key])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Request = " + argument_1["do_Function_JSON"][key] + ';')).toLowerCase() === '[object function]')) {
                        //             // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                        //             eval("do_Request = " + argument_1["do_Function_JSON"][key] + ";");
                        //         } else if (typeof (argument_1["do_Function_JSON"][key]) !== undefined && argument_1["do_Function_JSON"][key] !== undefined && argument_1["do_Function_JSON"][key] !== null && argument_1["do_Function_JSON"][key] !== "" && Object.prototype.toString.call(argument_1["do_Function_JSON"][key]).toLowerCase() === '[object string]') {
                        //             // 以 function mytFunc(argument) {} 形式的函數傳值;
                        //             eval(argument_1["do_Function_JSON"][key]);
                        //             // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                        //             // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                        //             eval("do_Request = " + argument_1["do_Function_JSON"][key].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                        //         } else {
                        //             console.log("傳入的用於處理數據的函數參數 do_Function_JSON, key: " + key + " , value: " + argument_1["do_Function_JSON"][key] + " 無法識別");
                        //             eval(key + " = function (argument) { return argument; };");
                        //         };
                        //         break;
                        //     }
                        //     default: {
                        //         console.log("Unrecognize JSON key: [" + key + "].");
                        //         console.log("傳入的用於處理數據的函數參數 do_Function_JSON, key: " + key + " , value: " + argument_1["do_Function_JSON"][key] + " 無法識別");
                        //     }
                        // };
                    };
                };
            };
            // 配置如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
            if (argument_1.hasOwnProperty("exclusive") && typeof (argument_1["exclusive"]) !== undefined && argument_1["exclusive"] !== undefined && argument_1["exclusive"] !== null && argument_1["exclusive"] !== NaN && argument_1["exclusive"] !== "") {
                exclusive = Boolean(argument_1["exclusive"]);  // typeof (exclusive) === "Boolean";
            };
            // 配置預設值:511，backlog 參數來指定待連接佇列的最大長度;
            if (argument_1.hasOwnProperty("backlog") && typeof (argument_1["backlog"]) !== undefined && argument_1["backlog"] !== undefined && argument_1["backlog"] !== null && argument_1["backlog"] !== NaN && argument_1["backlog"] !== "") {
                backlog = parseInt(argument_1["backlog"]);  // typeof (backlog) === "Number";
            };
            // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
            // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
            if (argument_1.hasOwnProperty("readableAll") && typeof (argument_1["readableAll"]) !== undefined && argument_1["readableAll"] !== undefined && argument_1["readableAll"] !== null && argument_1["readableAll"] !== NaN && argument_1["readableAll"] !== "") {
                readableAll = Boolean(argument_1["readableAll"]);  // typeof (readableAll) === "Boolean";
            };
            // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
            if (argument_1.hasOwnProperty("writableAll") && typeof (argument_1["writableAll"]) !== undefined && argument_1["writableAll"] !== undefined && argument_1["writableAll"] !== null && argument_1["writableAll"] !== NaN && argument_1["writableAll"] !== "") {
                writableAll = Boolean(argument_1["writableAll"]);  // typeof (writableAll) === "Boolean";
            };
            // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
            if (argument_1.hasOwnProperty("ipv6Only") && typeof (argument_1["ipv6Only"]) !== undefined && argument_1["ipv6Only"] !== undefined && argument_1["ipv6Only"] !== null && argument_1["ipv6Only"] !== NaN && argument_1["ipv6Only"] !== "") {
                ipv6Only = Boolean(argument_1["ipv6Only"]);  // typeof (ipv6Only) === "Boolean";
            };
        };
    };

    // 自定義函數，檢測輸入的監聽主機 IP 地址類型，是否爲：IPv6，或是：IPv4;
    function check_ip(address) {
        // IPv6 地址由八組四位十六進制數（0-9a-fA-F）構成，每組之間用冒號（:）分隔;
        let IPv6_regex = /^(::)?((([\da-f]{1,4}:){7}[\da-f]{1,4})|(([\da-f]{1,4}:){5}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){4}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){3}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){2}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:)(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})))$/;
        // IPv4 地址由四組數字（0-255）組成，每組之間用點號（.）分隔;
        let IPv4_regex = /^(\d{1,3}\.){3}(\d{1,3})$/;

        if (Object.prototype.toString.call(address).toLowerCase() === '[object string]' && IPv6_regex.test(address)) {
            return "IPv6";
        } else if (Object.prototype.toString.call(address).toLowerCase() === '[object string]' && IPv4_regex.test(address)) {
            return "IPv4";
        } else {
            return false;
        };
    };

    // 自定義函數，指定響應狀態碼對應的文本信息;
    function status_Message(response_statusCode) {
        // response_statusCode = 200;  // 401, "需要身份驗證賬號密碼", 301, "重定向";
        let statusMessage_CN = "";
        let statusMessage_EN = "";
        switch (response_statusCode) {
            case 200:
                statusMessage_CN = "請求成功";
                statusMessage_EN = "OK.";
                break;
            case 301:
                statusMessage_CN = "服務器要求重定向";
                statusMessage_EN = "Moved Permanently.";
                break;
            case 307:
                statusMessage_CN = "服務器要求臨時重定向";
                statusMessage_EN = "Temporary Redirect.";
                break;
            case 401:
                statusMessage_CN = "服務器要求客戶端身份驗證出具賬號密碼";
                statusMessage_EN = "Unauthorized.";
                break;
            case 404:
                statusMessage_CN = "請求路徑(URL)錯誤";
                statusMessage_EN = "Page not Found !";
                break;
            case 405:
                statusMessage_CN = "請求方法錯誤";
                statusMessage_EN = "Method Not Allowed !";
                break;
            default:
                statusMessage_CN = "";
                statusMessage_EN = "";
        };
        let status_Message = new Base64().encode(statusMessage_CN).concat(" ", statusMessage_EN);
        return status_Message;
    };

    function do_Server(request, response) {

        // console.log("當前進程編號: " + process.pid);
        // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
        // console.log("當前進程使用的内存: " + process.memoryUsage());
        // console.log("運行當前進程的操作系統平臺: " + process.platform);
        // console.log("運行當前進程的操作系統架構: " + process.arch);
        // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
        // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
        // console.log("當前進程的用戶環境: " + process.env);
        // console.log("當前進程的工作目錄: " + process.cwd());
        // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
        // console.log("運行當前進程的運行時間: " + process.uptime());
        // console.log("當前進程: process-" + process.pid + " 當前執行緒: thread-" + require('worker_threads').threadId);

        let request_Cookie = "";
        let Session_ID = "";
        let request_Authorization = "";
        let request_Key = "";
        let request_Nikename = "";
        let request_Password = "";

        // if (request.url !== "/") {
        //     do_HEAD(request, response, 404, 0, "");
        //     response.end();
        //     return;
        // };

        request.setEncoding("UTF8");

        // console.log("request:");
        // console.log(request);  // 打印全部請求信息;
        // console.log("request IP: ", request.connection.remoteAddress);  // request.ip 打印發送請求的客戶端Client的IP位址;
        // console.log("request protocol: ", request.httpVersion);  // 打印客戶端使用的通訊協議;
        // console.log("request method: ", request.method);  // 打印請求類型 "POST" or "GET";
        // console.log("request URL: ", request.url);  // 打印請求 URL 字符串值;

        let request_headers = {};
        request_headers = request.headers;  // 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
        // console.log(request.headers);  // 換行打印請求頭;
        // console.log(type(request.headers));  // 打印請求頭的數據類型;
        request_headers["protocol"] = String(request.httpVersion);
        request_headers["method"] = String(request.method);
        request_headers["remoteAddress"] = String(request.connection.remoteAddress);
        request_headers["url"] = String(request.url);

        let request_Url_Query_Dict = {};
        for (let [key, value] of new URLSearchParams(String(request.url).split('?')[1])) {
            request_Url_Query_Dict[key] = value;
        };
        // console.log(request_Url_Query_Dict);

        let Content_Type = "";  // "application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8";
        // console.log(self.headers['Accept']);
        if (typeof (request.headers["Accept"]) !== undefined && request.headers["Accept"] !== undefined && request.headers["Accept"] !== null && request.headers["Accept"] !== NaN) {
            if (request.headers["Accept"].length === 0) {
                Content_Type = "text/html; charset=utf-8";
            } else if (request.headers["Accept"].indexOf("text/html", 0) !== -1) {
                Content_Type = "text/html; charset=utf-8";
            } else if (request.headers["Accept"].indexOf("text/javascript", 0) !== -1) {
                Content_Type = "text/javascript; charset=utf-8";
            } else if (request.headers["Accept"].indexOf("text/css", 0) !== -1) {
                Content_Type = "text/css; charset=utf-8";
            } else if (request.headers["Accept"].indexOf("application/octet-stream", 0) !== -1) {
                Content_Type = "application/octet-stream; charset=utf-8";
            } else {
                Content_Type = request.headers["Accept"];  // 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';
            };
        } else {
            Content_Type = "text/html; charset=utf-8";  // 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';
        };

        // 配置響應頭信息;
        response.setHeader("Allow", "GET, POST, HEAD, PATCH");  // 設置可接受的客戶端請求方法;
        response.setHeader("Content-Language", "zh-Hant-TW; q=0.8, zh-Hant; q=0.7, zh-Hans-CN; q=0.7, zh-Hans; q=0.5, en-US, en; q=0.3");  // 服務器發送響應的自然語言類型;
        // response.setHeader("Content-Encoding", "gzip");  // 服務器發送響應的壓縮類型;
        // response.setHeader("Content-Disposition", "attachment; filename=Test.zip");  // 服務端要求客戶端以下載文檔的方式打開該文檔;
        // response.setHeader("Transfer-Encoding", "chunked");  // 以數據流形式分塊發送響應數據到客戶端;
        response.setHeader("Expires", "100-continue header");  // 服務端禁止客戶端緩存頁面數據;
        response.setHeader("Cache-Control", "no-cache");  // 'max-age=0' 或 no-store, must-revalidate 設置不允許瀏覽器緩存，必須刷新數據;
        // response.setHeader("Pragma", "no-cache");  // 服務端禁止客戶端緩存頁面數據;
        response.setHeader("Connection", "close");  // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, HEAD, PATCH");  // 設置響應頭，但是并不發送響應頭;
        response.setHeader("Access-Control-Allow-Origin", "*");  // 設置響應頭，但是并不發送響應頭;
        response.setHeader("Access-Control-Allow-Headers", "content-type, Accept");  // 設置響應頭，但是并不發送響應頭;
        response.setHeader("Access-Control-Allow-Credentials", true);  // 設置響應頭，但是并不發送響應頭;
        // response.setHeader("Date", new Date().toLocaleString('chinese', { hour12: false }));  // 服務端向客戶端返回響應的時間;
        response.sendDate = true;

        let server_info = "Node.js_http.createServer.listen";
        // server_info = child_process.execSync('node --version').toString("UTF8");
        // // console.log(child_process.execSync('node --version'));
        // // console.log(typeof(child_process.execSync('node --version')));
        // server_info = server_info.replace(unescape("%0D%0A"), "").replace(new RegExp("/[\r\n]/", "g"), "").replace(new RegExp("/(^\s*)|(\s*$)/", "g"), "");  // .replace(new RegExp("\\.", "g"), "");
        // server_info = escape(server_info);
        // // server_info = String(process.release["name"]).concat("-", String(process.platform));  // 當前正在運行的 node 解釋器的編譯時的信息;
        // // server_info = String(os.hostname());
        // server_info = "Node.js ".concat(User_Agent, "_http.createServer.listen_", String(os.type()), "_", String(os.hostname()));
        // // console.log(server_info);
        response.setHeader("Server", server_info);  // web 服務器名稱版本信息;

        // response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
        // response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
        // response.setHeader("Location", "http://www.baidu.com");  // 當響應要求重定向（301）時，服務端要求客戶端重定向訪問的頁面路徑;
        // response.setHeader("Refresh", "1;url=http://localhost:8000/");  // 服務端要求客戶端1秒鐘後刷新頁面，然後訪問指定的頁面路徑;
        // response.setHeader("Content-MD5", "Q2hlY2sgSW50ZWdyaXR5IQ==");  // 返回實體 MD5 加密的校驗值;
        // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;

        // Set-Cookie: name=value[; expires=date][; domain=domain][; path=path][; secure];
        // 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
        // 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
        // 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
        // 參數value部分，通常是一個 name=value 格式的字串，通常性的使用方式是以 name=value 的格式來指定cookie的值；
        // 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
        // let after_30_Days = new Date(new Date(new Date(new Date().setDate(new Date().getDate() + 30)))).toLocaleString('chinese', { hour12: false });  // 計算 30 日之後的日期;
        // console.log(after_30_Days);
        // // let cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; domain=abc.com; path=/; HTTPOnly;");
        // let cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");  // 拼接 cookie 字符串值;
        // console.log(cookie_string);
        // response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;


        // 讀取請求頭中的 "Authorization" 值賬號密碼信息;
        if (typeof (request.headers["authorization"]) !== undefined && request.headers["authorization"] !== undefined && request.headers["authorization"] !== null && request.headers["authorization"] !== NaN && request.headers["authorization"].length > 0) {
            // console.log("request Headers Authorization: ", request.headers["authorization"]);
            // console.log(typeof(request.headers["authorization"]));
            if (request.headers["authorization"].indexOf(" ", 0) !== -1 && request.headers["authorization"].split(" ")[0] === "Basic" && request.headers["authorization"].split(" ")[1] !== undefined && request.headers["authorization"].split(" ")[1] !== null && request.headers["authorization"].split(" ")[1] !== NaN && request.headers["authorization"].split(" ")[1].length > 0) {
                // console.log("request Headers Authorization: ", request.headers["authorization"].split(" ")[0] + " " + new Base64().decode(request.headers["authorization"].split(" ")[1]));  // 打印請求頭中的使用自定義函數new Base64().decode()解密之後的用戶賬號和密碼參數"Authorization";
                request_Authorization = new Base64().decode(request.headers["authorization"].split(" ")[1]).toString("utf-8");
                // 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                // 打印請求頭中的使用自定義函數new Base64().decode()解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                // console.log(type(new Base64().decode(request.headers["authorization"].split(" ")[1])));
            } else {
                request_Authorization = "";
            };
        } else {
            request_Authorization = "";
        };
        // console.log(request_Authorization);

        // 讀取請求頭中的 "Cookie" 值信息;
        if (typeof (request.headers["cookie"]) !== undefined && request.headers["cookie"] !== undefined && request.headers["cookie"] !== null && request.headers["cookie"] !== NaN && request.headers["cookie"].length > 0) {
            // console.log("request Headers Cookie: ", request.headers["cookie"]);  // 打印客戶端請求頭中的 Cookie 參數值;
            // console.log(typeof(request.headers["cookie"]));
            request_Cookie = request.headers["cookie"];  // escape(request_Cookie);
            // console.log("request Headers Cookie: ", request_Cookie);  // 打印客戶端請求頭中的 Cookie 參數值;
            // console.log(typeof(request_Cookie));
            // 判斷客戶端發送的請求頭中 Cookie 參數值中是否包含"="符號，如果包含"="符號，則首先使用"="符號分割 Cookie 參數值字符串，否則直接使用 Cookie 參數值字符串;
            if (request_Cookie.indexOf("=", 0) !== -1 && request_Cookie.split("=")[0] === "Session_ID") {
                Session_ID = new Base64().decode(request_Cookie.split("=")[1].toString("utf-8"));
            } else {
                Session_ID = new Base64().decode(request_Cookie.toString("utf-8"));
            };
            // console.log("request Session ID: ", Session_ID);
        } else {
            request_Cookie = "";
        };
        // console.log(request_Cookie);
        // console.log(Session_ID);

        // 判斷如果客戶端發送的請求的賬號密碼來源，提取請求 URL 字符串中的查詢（?）字段中的：key=value 鍵值，或如果請求頭 request.headers["Authorization"] 參數不爲空則使用 request.headers["Authorization"] 的參數值作爲客戶端的賬號密碼，如果請求頭 request.headers["Authorization"] 參數為空但 request.headers["Cookie"] 參數不爲空則使用 request.headers["Cookie"]  的參數值，作爲在自定義的 Session 對象中查找的"key"對應的"value"值，作爲客戶端的賬號密碼;
        if ((typeof (request_Url_Query_Dict) === 'object' && Object.prototype.toString.call(request_Url_Query_Dict).toLowerCase() === '[object object]' && !(request_Url_Query_Dict.length)) && Object.keys(request_Url_Query_Dict).length > 0 && (request_Url_Query_Dict.hasOwnProperty("key") || request_Url_Query_Dict.hasOwnProperty("Key") || request_Url_Query_Dict.hasOwnProperty("KEY"))) {
            // 提取請求 URL 字符串中的查詢（?）字段中的：key=value 鍵值;

            // console.log(Object.keys(request_Url_Query_Dict).length);
            if (Object.keys(request_Url_Query_Dict).length > 0) {    
                // 解析獲取客戶端請求 url 中的賬號密碼 "key" 參數;
                // request_Key = "";
                // console.log(request_Url_Query_Dict["Key"]);
                // console.log(request_Url_Query_Dict.hasOwnProperty("Key"));
                if (request_Url_Query_Dict.hasOwnProperty("key")) {
                    // if (Object.prototype.toString.call(request_Url_Query_Dict["key"]).toLowerCase() === '[object string]' && request_Url_Query_Dict["key"].indexOf(":", 0) !== -1) {
                        request_Key = String(request_Url_Query_Dict["key"]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                    // };
                } else if (request_Url_Query_Dict.hasOwnProperty("Key")) {
                    request_Key = String(request_Url_Query_Dict["Key"]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                } else if (request_Url_Query_Dict.hasOwnProperty("KEY")) {
                    request_Key = String(request_Url_Query_Dict["KEY"]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                };
                // console.log("request url query key: [ " + request_Key + " ].");
            };
        } else if (request_Authorization !== "") {
            //如果請求頭 request.headers["Authorization"] 參數不爲空，則使用 request.headers["Authorization"] 的參數值，作爲客戶端的賬號密碼;
            request_Key = request_Authorization;
        } else if (request_Cookie !== "" && Session_ID !== "") {
            // 如果客戶端發送的請求頭 request.headers["Authorization"] 參數為空，但如果客戶端發送的請求頭的 request.headers["Cookie"] 參數不爲空，則使用 request.headers["Cookie"]  的參數值，作爲在自定義的 Session 對象中查找的"key"對應的"value"值，作爲客戶端的賬號密碼;
            if (typeof (Session) === 'object' && Object.prototype.toString.call(Session).toLowerCase() === '[object object]' && !(Session.length)) {
                if (Object.keys(Session).length > 0 && typeof (Session[Session_ID]) !== undefined && Session[Session_ID] !== undefined && Session[Session_ID] !== null && Session[Session_ID] !== NaN) {
                    request_Key = Session[Session_ID];
                };
            };
        } else {

            request_Key = "";
            
            if (Key !== "") {

                let response_statusCode = 401;

                // let Content_Type = "text/plain, text/html; charset=utf-8";

                // Set-Cookie: name=value[; expires=date][; domain=domain][; path=path][; secure];
                // 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
                // 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
                // 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
                // 參數value部分，通常是一個 name=value 格式的字串，通常性的使用方式是以 name=value 的格式來指定cookie的值；
                // 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
                let after_1_Days = new Date(new Date(new Date(new Date().setDate(new Date().getDate() + 1)))).toLocaleString('chinese', { hour12: false });  // 計算 30 日之後的日期;
                // console.log(after_1_Days);
                let cookie_value = "session_id=" + new Base64().encode("request_Key->" + request_Key).toString("UTF8");  // 將漢字做Base64轉碼 new Base64().encode(base64);
                // console.log(new Base64().decode(cookie_value));  // Base64解碼 new Base64().decode(base64);
                // // let cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_1_Days), "; domain=abc.com; path=/; HTTPOnly;");
                let cookie_string = cookie_value.concat("; expires=", String(after_1_Days), "; path=/;");  // 拼接 cookie 字符串值;
                // console.log(cookie_string);

                // let now_date = new Date().toLocaleString('chinese', { hour12: false });
                let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
                // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
                let response_data = {
                    "Server_say": "No request Headers Authorization or Cookie received.",
                    "Server_Authorization": Key,
                    "time": String(now_date)
                };
                response_data = JSON.stringify(response_data);  // 將JOSN對象轉換為JSON字符串;

                let response_Body_String_len = Buffer.byteLength(response_data, "utf8");

                response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                response.write(response_data, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                response.end("", "utf8", () => {
                    // if (!response.complete) {
                    //     console.error("消息仍在發送時中止了鏈接.");
                    // };
                });
                // console.log("No request Headers Authorization or Cookie received.");
                // console.log("request Headers Authorization: ", request.headers["Authorization"]);
                // console.log("request Headers Cookie: ", request.headers["Cookie"]);

                // console.log(now_date);
                // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                // console.log(log_text);
                let log_JSON = {
                    "time": now_date,
                    "process_pid": process.pid,
                    "threadId": require('worker_threads').threadId,
                    "request_connection_remoteAddress": request.connection.remoteAddress,
                    "request_url": request.url,
                    "request_method": request.method,
                    "request_httpVersion": request.httpVersion,
                    "response_statusCode": response_statusCode
                };
                // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                // fs.appendFile(path, data[, options], callback);
                // fs.appendFileSync(path, data[, options]);

                return log_JSON;
            };
        };

        // 提取賬號密碼;
        if (typeof (request_Key) !== undefined && request_Key !== undefined && request_Key !== "" && request_Key.indexOf(":", 0) !== -1) {
            request_Nikename = request_Key.split(":")[0];
            request_Password = request_Key.split(":")[1];
            // console.log("request Nikename: [", request_Key.split(":", -1)[0], "], request Password: [", request_Key.split(":", -1)[1], "].");
        } else {
            request_Nikename = request_Key;
            request_Password = "";
        };

        if (Key !== "" && (request_Nikename !== Key.split(":")[0] || request_Password !== Key.split(":")[1])) {

            let response_statusCode = 401;

            // let Content_Type = "text/plain, text/html; charset=utf-8";

            // Set-Cookie: name=value[; expires=date][; domain=domain][; path=path][; secure];
            // 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
            // 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
            // 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
            // 參數value部分，通常是一個 name=value 格式的字串，通常性的使用方式是以 name=value 的格式來指定cookie的值；
            // 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
            let after_1_Days = new Date(new Date(new Date(new Date().setDate(new Date().getDate() + 1)))).toLocaleString('chinese', { hour12: false });  // 計算 30 日之後的日期;
            // console.log(after_1_Days);
            let cookie_value = "session_id=" + new Base64().encode("request_Key->" + request_Key).toString("UTF8");  // 將漢字做Base64轉碼 new Base64().encode(base64);
            // console.log(new Base64().decode(cookie_value));  // Base64解碼 new Base64().decode(base64);
            // // let cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_1_Days), "; domain=abc.com; path=/; HTTPOnly;");
            let cookie_string = cookie_value.concat("; expires=", String(after_1_Days), "; path=/;");  // 拼接 cookie 字符串值;
            // console.log(cookie_string);

            // let now_date = new Date().toLocaleString('chinese', { hour12: false });
            let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
            // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
            let response_data = {
                "Server_say": "request Header Authorization [ " + request_Nikename + " ] not authenticated.",
                "Server_Authorization": Key,
                "time": String(now_date)
            };
            response_data = JSON.stringify(response_data);  // 將JOSN對象轉換為JSON字符串;

            let response_Body_String_len = Buffer.byteLength(response_data, "utf8");

            response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
            response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
            response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
            response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
            // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
            response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

            response.write(response_data, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
            response.end("", "utf8", () => {
                // if (!response.complete) {
                //     console.error("消息仍在發送時中止了鏈接.");
                // };
            });
            // console.log("request Header Authorization [ " + request_Authorization + " ] not authenticated.");

            // console.log(now_date);
            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
            // console.log(log_text);
            let log_JSON = {
                "time": now_date,
                "process_pid": process.pid,
                "threadId": require('worker_threads').threadId,
                "request_connection_remoteAddress": request.connection.remoteAddress,
                "request_url": request.url,
                "request_method": request.method,
                "request_httpVersion": request.httpVersion,
                "response_statusCode": response_statusCode
            };
            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
            // fs.appendFile(path, data[, options], callback);
            // fs.appendFileSync(path, data[, options]);

            return log_JSON;

        } else {

            // Set-Cookie: name=value[; expires=date][; domain=domain][; path=path][; secure];
            // 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
            // 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
            // 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
            // 參數value部分，通常是一個 name=value 格式的字串，通常性的使用方式是以 name=value 的格式來指定cookie的值；
            // 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
            let after_30_Days = new Date(new Date(new Date(new Date().setDate(new Date().getDate() + 30)))).toLocaleString('chinese', { hour12: false });  // 計算 30 日之後的日期;
            // console.log(after_30_Days);
            let cookie_value = "session_id=" + new Base64().encode("request_Key->" + request_Key).toString("UTF8");  // 將漢字做Base64轉碼 new Base64().encode(base64);
            // console.log(new Base64().decode(cookie_value));  // Base64解碼 new Base64().decode(base64);
            // // let cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_1_Days), "; domain=abc.com; path=/; HTTPOnly;");
            let cookie_string = cookie_value.concat("; expires=", String(after_30_Days), "; path=/;");  // 拼接 cookie 字符串值;
            // console.log(cookie_string);

            // let now_date = new Date().toLocaleString('chinese', { hour12: false });
            let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
            // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
            let response_body_JSON = {
                "request Nikename": request_Nikename,
                "request Passwork": request_Password,
                "Server_Authorization": Key,
                "time": String(now_date)
            };

            switch (request.url) {
                // http://username:password@127.0.0.1:8000/query?key=nikename&key=password#0;
                // new url.URL(request.url);
                case "/": {

                    switch (request.method.toLocaleUpperCase()) {

                        case "GET": {
                            // http://username:password@127.0.0.1:8000/query?key=nikename&key=password#0;
                            // new url.URL(request.url);

                            // let request_data_JSON = {
                            //     "Client_say": "Browser GET request test.",
                            //     "request_url": request.url
                            // };

                            let response_statusCode = 200;

                            let response_body_String = "";
                            if (typeof (do_Request) !== undefined && do_Request !== undefined && do_Request !== null && do_Request !== NaN && do_Request !== "" && Object.prototype.toString.call(do_Request).toLowerCase() === '[object function]') {

                                // response_body_String = do_Request(request.url, "", request_headers);
                                // response_body_JSON["Server_say"] = do_Request(request.url, "", request_headers);

                                do_Request(
                                    request.url,
                                    "",
                                    request_headers,
                                    function (error, result) {

                                        if (error) {
                                            response_body_String = error;
                                        };
                                        if (result) {
                                            response_body_String = result;
                                        };

                                        response_statusCode = 200;

                                        // let Content_Type = "text/plain, text/html; charset=utf-8";

                                        let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");

                                        response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                        response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                        response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                        // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                        // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                        response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                        response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                        response.end("", "utf8", () => {
                                            // if (!request.complete) {
                                            //     console.error("消息仍在發送時中止了鏈接.");
                                            // };
                                        });
                                    }
                                );

                            } else {

                                response_body_String = "";
                                // response_body_JSON["Server_say"] = "";

                                response_statusCode = 200;

                                // let Content_Type = "text/plain, text/html; charset=utf-8";
    
                                let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");
    
                                response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
    
                                response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                response.end("", "utf8", () => {
                                    // if (!request.complete) {
                                    //     console.error("消息仍在發送時中止了鏈接.");
                                    // };
                                });
                            };
                            // response_body_String = JSON.stringify(response_body_JSON);  // 將JOSN對象轉換為JSON字符串;

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "POST": {

                            let request_POST_Buffer = [];  // 客戶端POST請求表單form中的數據塊流數組;
                            request.on('data', (chunk) => {
                                request_POST_Buffer.push(chunk);  // 從流中讀取客戶端POST請求表單中的數據塊推入自定義數組;
                            });
                            // 監聽當數據傳輸完畢事件;
                            let request_data_JSON = {};  // 客戶端POST請求表單form中的數據JSON對象;
                            let response_statusCode = 200;
                            request.on('end', () => {
                                // console.log(typeof (request_POST_Buffer));
                                // console.log(request_POST_Buffer);
                                // console.log(isStringJSON(request_POST_Buffer));
                                // console.log(JSON.parse(request_POST_Buffer));

                                if (!request.complete) {
                                    console.error("客戶端請求消息仍在發送時，中止了鏈接.");
                                };

                                let request_POST_String = request_POST_Buffer.join("");
                                // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
                                // if (isStringJSON(request_POST_String)) {
                                //     request_data_JSON = JSON.parse(request_POST_String);
                                // } else {
                                //     request_data_JSON = {
                                //         "Client_say": request_POST_String,
                                //         "request_url": request.url,
                                //         "request_Authorization": "",  // "username:password";
                                //         "time": ""
                                //     };
                                // };
                                // console.log("Client say: " + request_data_JSON["Client_say"]);
                                // console.log("Client say request Authorization: [ " + request_data_JSON["request_Authorization"] + " ].");

                                let response_body_String = "";
                                if (typeof (do_Request) !== undefined && do_Request !== undefined && do_Request !== null && do_Request !== NaN && do_Request !== "" && Object.prototype.toString.call(do_Request).toLowerCase() === '[object function]') {

                                    // response_body_String = do_Request(request.url, request_POST_String, request_headers);
                                    // response_body_JSON["Server_say"] = do_Request(request.url, request_POST_String, request_headers);

                                    do_Request(
                                        request.url,
                                        request_POST_String,
                                        request_headers,
                                        function (error, result) {

                                            if (error) {
                                                response_body_String = error;
                                            };
                                            if (result) {
                                                response_body_String = result;
                                            };

                                            response_statusCode = 200;

                                            // let Content_Type = "text/plain, text/html; charset=utf-8";

                                            let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");

                                            response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                            response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                            response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                            // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                            // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                            response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                            response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                            response.end("", "utf8", () => {
                                                // if (!request.complete) {
                                                //     console.error("消息仍在發送時中止了鏈接.");
                                                // };
                                            });
                                        }
                                    );

                                } else {

                                    response_body_String = request_POST_String;
                                    // response_body_JSON["Server_say"] = "";

                                    response_statusCode = 200;

                                    // let Content_Type = "text/plain, text/html; charset=utf-8";

                                    let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");

                                    response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                    response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                    response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                    // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                    // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                    response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                    response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                    response.end("", "utf8", () => {
                                        // if (!request.complete) {
                                        //     console.error("消息仍在發送時中止了鏈接.");
                                        // };
                                    });
                                };
                                // response_body_String = JSON.stringify(response_body_JSON);  // 將JOSN對象轉換為JSON字符串;
                            });

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "HEAD": {
                            response.writeHead(405, status_Message(405));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                            response.end("", "utf8", () => { });
                            // console.log("request method error: " + request.method);

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "OPTIONS": {

                            let request_POST_Buffer = [];  // 客戶端POST請求表單form中的數據塊流數組;
                            request.on('data', (chunk) => {
                                request_POST_Buffer.push(chunk);  // 從流中讀取客戶端POST請求表單中的數據塊推入自定義數組;
                            });
                            // 監聽當數據傳輸完畢事件;
                            let request_data_JSON = {};  // 客戶端POST請求表單form中的數據JSON對象;
                            let response_statusCode = 200;
                            request.on('end', () => {
                                // console.log(typeof (request_POST_Buffer));
                                // console.log(request_POST_Buffer);
                                // console.log(isStringJSON(request_POST_Buffer));
                                // console.log(JSON.parse(request_POST_Buffer));

                                if (!request.complete) {
                                    console.error("客戶端請求消息仍在發送時，中止了鏈接.");
                                };

                                let request_POST_String = request_POST_Buffer.join("");
                                // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
                                // if (isStringJSON(request_POST_String)) {
                                //     request_data_JSON = JSON.parse(request_POST_String);
                                // } else {
                                //     request_data_JSON = {
                                //         "Client_say": request_POST_String,
                                //         "request_url": request.url,
                                //         "request_Authorization": "",  // "username:password";
                                //         "time": ""
                                //     };
                                // };
                                // console.log("Client say: " + request_data_JSON["Client_say"]);
                                // console.log("Client say request Authorization: [ " + request_data_JSON["request_Authorization"] + " ].");

                                let response_body_String = "";

                                response_body_String = request_POST_String;
                                // response_body_JSON["Server_say"] = "";

                                response_statusCode = 200;

                                // let Content_Type = "text/plain, text/html; charset=utf-8";

                                let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");

                                response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                response.end("", "utf8", () => {
                                    // if (!request.complete) {
                                    //     console.error("消息仍在發送時中止了鏈接.");
                                    // };
                                });
                                // response_body_String = JSON.stringify(response_body_JSON);  // 將JOSN對象轉換為JSON字符串;
                            });

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "PATCH": {
                            response.writeHead(405, status_Message(405));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                            response.end("", "utf8", () => { });
                            // console.log("request method error: " + request.method);

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        default: {
                            response.writeHead(405, status_Message(405));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                            response.end("", "utf8", () => { });
                            // console.log("request method error: " + request.method);

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }
                    };
                }

                default: {

                    switch (request.method.toLocaleUpperCase()) {

                        case "GET": {
                            // http://username:password@127.0.0.1:8000/query?key=nikename&key=password#0;
                            // new url.URL(request.url);
                            // let request_data_JSON = {
                            //     "Client_say": "Browser GET request test.",
                            //     "request_url": request.url
                            // };

                            let response_statusCode = 200;

                            let response_body_String = "";
                            if (typeof (do_Request) !== undefined && do_Request !== undefined && do_Request !== null && do_Request !== NaN && do_Request !== "" && Object.prototype.toString.call(do_Request).toLowerCase() === '[object function]') {

                                // response_body_String = do_Request(request.url, "", request_headers);
                                // response_body_JSON["Server_say"] = do_Request(request.url, "", request_headers);

                                do_Request(
                                    request.url,
                                    "",
                                    request_headers,
                                    function (error, result) {

                                        if (error) {
                                            response_body_String = error;
                                        };
                                        if (result) {
                                            response_body_String = result;
                                        };

                                        let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");
                                        response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");

                                        // let Content_Type = "text/html; charset=UTF-8";  // "text/html, text/javascript, text/css, text/plain, application/json; charset=UTF-8";
                                        response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;

                                        response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                        // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;

                                        response_statusCode = 200;
                                        // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                        response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                        response.write(response_body_String, "utf8", function () {});  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                        response.end("", "utf8", () => {
                                            // if (!request.complete) {
                                            //     console.error("消息仍在發送時中止了鏈接.");
                                            // };
                                        });
                                    }
                                );

                            } else {

                                response_body_String = "";
                                // response_body_JSON["Server_say"] = "";

                                let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");
                                response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");

                                // let Content_Type = "text/html; charset=UTF-8";  // "text/html, text/javascript, text/css, text/plain, application/json; charset=UTF-8";
                                response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;

                                response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;

                                response_statusCode = 200;
                                // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                response.write(response_body_String, "utf8", function () {});  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                response.end("", "utf8", () => {
                                    // if (!request.complete) {
                                    //     console.error("消息仍在發送時中止了鏈接.");
                                    // };
                                });
                            }
                            // response_body_String = JSON.stringify(response_body_JSON);  // 將JOSN對象轉換為JSON字符串;

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "POST": {

                            let request_POST_Buffer = [];  // 客戶端POST請求表單form中的數據塊流數組;
                            request.on('data', (chunk) => {
                                request_POST_Buffer.push(chunk);  // 從流中讀取客戶端POST請求表單中的數據塊推入自定義數組;
                            });
                            // 監聽當數據傳輸完畢事件;
                            let request_data_JSON = {};  // 客戶端POST請求表單form中的數據JSON對象;
                            let response_statusCode = 200;
                            request.on('end', () => {
                                // console.log(typeof (request_POST_Buffer));
                                // console.log(request_POST_Buffer);
                                // console.log(isStringJSON(request_POST_Buffer));
                                // console.log(JSON.parse(request_POST_Buffer));

                                if (!request.complete) {
                                    console.error("客戶端請求消息仍在發送時，中止了鏈接.");
                                };

                                let request_POST_String = request_POST_Buffer.join("");
                                // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
                                // if (isStringJSON(request_POST_String)) {
                                //     request_data_JSON = JSON.parse(request_POST_String);
                                // } else {
                                //     request_data_JSON = {
                                //         "Client_say": request_POST_String,
                                //         "request_url": request.url,
                                //         "request_Authorization": "",  // "username:password";
                                //         "time": ""
                                //     };
                                // };
                                // console.log("Client say: " + request_data_JSON["Client_say"]);
                                // console.log("Client say request Authorization: [ " + request_data_JSON["request_Authorization"] + " ].");

                                let response_body_String = "";
                                if (typeof (do_Request) !== undefined && do_Request !== undefined && do_Request !== null && do_Request !== NaN && do_Request !== "" && Object.prototype.toString.call(do_Request).toLowerCase() === '[object function]') {

                                    // response_body_String = do_Request(request.url, request_POST_String, request_headers);
                                    // response_body_JSON["Server_say"] = do_Request(request.url, request_POST_String, request_headers);

                                    do_Request(
                                        request.url,
                                        request_POST_String,
                                        request_headers,
                                        function (error, result) {

                                            if (error) {
                                                response_body_String = error;
                                            };
                                            if (result) {
                                                response_body_String = result;
                                            };

                                            response_statusCode = 200;

                                            // let Content_Type = "text/plain, text/html; charset=utf-8";

                                            let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");

                                            response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                            response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                            response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                            // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                            // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                            response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                            response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                            response.end("", "utf8", () => {
                                                // if (!request.complete) {
                                                //     console.error("消息仍在發送時中止了鏈接.");
                                                // };
                                            });
                                        }
                                    );

                                } else {

                                    response_body_String = request_POST_String;
                                    // response_body_JSON["Server_say"] = "";

                                    response_statusCode = 200;

                                    // let Content_Type = "text/plain, text/html; charset=utf-8";
    
                                    let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");
    
                                    response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                    response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                    response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                    // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                    // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                    response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
    
                                    response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                    response.end("", "utf8", () => {
                                        // if (!request.complete) {
                                        //     console.error("消息仍在發送時中止了鏈接.");
                                        // };
                                    });
                                };
                                // response_body_String = JSON.stringify(response_body_JSON);  // 將JOSN對象轉換為JSON字符串;
                            });

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "HEAD": {
                            response.writeHead(405, status_Message(405));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                            response.end("", "utf8", () => { });
                            // console.log("request method error: " + request.method);

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "OPTIONS": {

                            let request_POST_Buffer = [];  // 客戶端POST請求表單form中的數據塊流數組;
                            request.on('data', (chunk) => {
                                request_POST_Buffer.push(chunk);  // 從流中讀取客戶端POST請求表單中的數據塊推入自定義數組;
                            });
                            // 監聽當數據傳輸完畢事件;
                            let request_data_JSON = {};  // 客戶端POST請求表單form中的數據JSON對象;
                            let response_statusCode = 200;
                            request.on('end', () => {
                                // console.log(typeof (request_POST_Buffer));
                                // console.log(request_POST_Buffer);
                                // console.log(isStringJSON(request_POST_Buffer));
                                // console.log(JSON.parse(request_POST_Buffer));

                                if (!request.complete) {
                                    console.error("客戶端請求消息仍在發送時，中止了鏈接.");
                                };

                                let request_POST_String = request_POST_Buffer.join("");
                                // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
                                // if (isStringJSON(request_POST_String)) {
                                //     request_data_JSON = JSON.parse(request_POST_String);
                                // } else {
                                //     request_data_JSON = {
                                //         "Client_say": request_POST_String,
                                //         "request_url": request.url,
                                //         "request_Authorization": "",  // "username:password";
                                //         "time": ""
                                //     };
                                // };
                                // console.log("Client say: " + request_data_JSON["Client_say"]);
                                // console.log("Client say request Authorization: [ " + request_data_JSON["request_Authorization"] + " ].");

                                let response_body_String = "";

                                response_body_String = request_POST_String;
                                // response_body_JSON["Server_say"] = "";

                                response_statusCode = 200;

                                // let Content_Type = "text/plain, text/html; charset=utf-8";

                                let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");

                                response.setHeader("Content-Type", Content_Type);  // "text/plain, text/html; charset=utf-8" 設置響應頭，但是并不發送響應頭;
                                response.setHeader("Content-Length", response_Body_String_len);  // 設置響應體數據長度 response_Body_String_len = Buffer.byteLength(post_Data_String, "utf8");
                                response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
                                // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                                // response.writeHead(200, "請求成功", { 'Content-Type': 'text/plain' });  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                                response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;

                                response.write(response_body_String, "utf8", function () { });  // 發送一段響應躰，面對一個請求可多次調用 response.write() 方法;
                                response.end("", "utf8", () => {
                                    // if (!request.complete) {
                                    //     console.error("消息仍在發送時中止了鏈接.");
                                    // };
                                });
                                // response_body_String = JSON.stringify(response_body_JSON);  // 將JOSN對象轉換為JSON字符串;
                            });

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        case "PATCH": {
                            let response_statusCode = 405;
                            response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                            response.end("", "utf8", () => { });
                            // console.log("request method error: " + request.method);

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }

                        default: {
                            let response_statusCode = 405;
                            response.writeHead(response_statusCode, status_Message(response_statusCode));  // 發送響應頭，只能調用一次，必須在 response.end() 之前調用;
                            response.end("", "utf8", () => { });
                            // console.log("request method error: " + request.method);

                            // console.log(now_date);
                            // let log_text = String(now_date) + " process-" + String(process.pid) + " thread-" + String(require('worker_threads').threadId) + " " + request.connection.remoteAddress + " " + request.httpVersion + " " + request.method + " " + request.url + " " + response_statusCode;
                            // console.log(log_text);
                            let log_JSON = {
                                "time": now_date,
                                "process_pid": process.pid,
                                "threadId": require('worker_threads').threadId,
                                "request_connection_remoteAddress": request.connection.remoteAddress,
                                "request_url": request.url,
                                "request_method": request.method,
                                "request_httpVersion": request.httpVersion,
                                "response_statusCode": response_statusCode
                            };
                            // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);
                            // fs.appendFile(path, data[, options], callback);
                            // fs.appendFileSync(path, data[, options]);

                            return log_JSON;
                        }
                    };
                }
            };
        };
    };

    // Workers can share aclearny TCP connection
    // In this case its a HTTP server
    // const server = https.createServer({
    //     key: require('fs').readFileSync('test/fixtures/keys/agent2-key.pem'),
    //     cert: require('fs').readFileSync('test/fixtures/keys/agent2-cert.pem')
    //     or
    //     pfx: require('fs').readFileSync('test/fixtures/test_cert.pfx'),
    //     passphrase: '密碼'
    // }, (request, response) => {
    //     request.socket.getPeerCertificate();  // 讀取客戶端的身份驗證詳細信息;
    // });
    // const server = http.createServer({ IncomingMessage: http.IncomingMessage, ServerResponse: http.ServerResponse, insecureHTTPParser: false, maxHeaderSize: 16384 }, (request, response) => {});
    // IncomingMessage < http.IncomingMessage > 指定要使用的 IncomingMessage 類。 對於擴展原始的 IncomingMessage 很有用。 預設值: IncomingMessage。
    // ServerResponse < http.ServerResponse > 指定要使用的 ServerResponse 類。 對於擴展原始的 ServerResponse 很有用。 預設值: ServerResponse。
    // insecureHTTPParser < boolean > 使用不安全的 HTTP 解析器，當為 true 時可以接受無效的 HTTP 請求頭。 應避免使用不安全的解析器。 詳見--insecure - http - parser。 預設值: false。
    // maxHeaderSize < number > 可選地重寫--max - http - header - size（用於伺服器接收的請求）的值，即請求頭的最大長度（以位元組為單位）。 預設值: 16384（16KB）。

    const server = http.createServer({
        IncomingMessage: http.IncomingMessage,
        ServerResponse: http.ServerResponse,
        insecureHTTPParser: false,
        maxHeaderSize: 16384
    }, function (request, response) {

        if (require('cluster').isMaster) {
            let worker_process_pid = process.pid;
            if (!worker_queues.hasOwnProperty(worker_process_pid)) {
                worker_queues[worker_process_pid] = require('cluster').Worker;  // 記錄主進程對象 cluster Master;
            };
            if (total_worker_called_number.hasOwnProperty(worker_process_pid)) {
                total_worker_called_number[worker_process_pid] = parseInt(total_worker_called_number[worker_process_pid]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
            } else {
                total_worker_called_number[worker_process_pid] = 1;  // 第一次被調用賦值 1 ;
            };
        } else {
            let response_message = {
                "process_pid": process.pid,  // String(process.pid);
                "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                // "worker_id": worker_id,
                "data": "Response counting.",
                "authenticate": "",
                "time": ""
            };
            process.send(["message_response", response_message], function () { });
        };

        let log_JSON = do_Server(request, response);
        // log_JSON === {
        //     "time": now_date,
        //     "process_pid": process.pid,
        //     "threadId": require('worker_threads').threadId,
        //     "request_url": request.url,
        //     "request_connection_remoteAddress": request.connection.remoteAddress,
        //     "request_method": request.method,
        //     "request_httpVersion": request.httpVersion,
        //     "response_statusCode": response_statusCode
        // };
        // log_JSON = JSON.stringify(log_text); log_text = JSON.parse(log_JSON);

        let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
        // let now_date = new Date().toLocaleString('chinese', { hour12: false });
        
        let log_text = String(now_date) + " process-" + String(log_JSON["process_pid"]) + " thread-" + String(log_JSON["threadId"]) + " " + log_JSON["request_url"] + " " + log_JSON["request_connection_remoteAddress"] + " " + log_JSON["request_method"] + " " + log_JSON["request_httpVersion"] + " " + log_JSON["response_statusCode"];
        console.log(log_text);

    });

    // 以多進程監聽方式啓動服務器;
    function Multiprocess_start_Server(host, port, number_cluster_Workers, backlog, exclusive, readableAll, writableAll, ipv6Only) {
        // let Key = "username:password";  // 訪問網站簡單驗證用戶名和密碼;
        // let Session = {
        //     "request_Key->username:password": Key
        // };
        // options = {
        //     "host": "localhost",
        //     "port": 8000,
        //     "exclusive": true,
        //     "backlog": 511,
        //     "do_HEAD": do_HEAD,
        //     "do_GET": do_GET,
        //     "do_POST": do_POST,
        //     "do_PATCH": do_PATCH
        // };

        // CheckString(number_cluster_Workers, 'positive_integer');  // 自定義函數檢查輸入合規性;
        // if (typeof (number_cluster_Workers) === undefined && number_cluster_Workers === undefined && isNaN(Number(number_cluster_Workers)) && parseInt(number_cluster_Workers) <= 0) {
        //     // number_cluster_Workers.toString("utf-8").match(/[0-9]{1,10}/gim) !== null && number_cluster_Workers.toString("utf-8").match(/[0-9]{1,10}/gim).length = 1:
        //     // number_cluster_Workers = number_cluster_Workers.toString("utf-8").match(/[0-9]{1,10}/gim)[0]:
        //     // number_cluster_Workers = parseInt(number_cluster_Workers);

        //     console.log("傳入的創建的集群子進程數目的參數(number_cluster_Workers): " + number_cluster_Workers + " 錯誤.");
        //     return number_cluster_Workers;
        // };

        // 配置創建子綫程數目參數預設值;
        if (typeof (number_cluster_Workers) === undefined || number_cluster_Workers === undefined || number_cluster_Workers === null || number_cluster_Workers === "") {
            number_cluster_Workers = parseInt(1);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
        } else if (number_cluster_Workers && typeof (number_cluster_Workers) !== "number" && number_cluster_Workers !== "") {
            number_cluster_Workers = parseInt(number_cluster_Workers);  // parseInt(1)，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
        };

        // https://www.cnblogs.com/zmxmumu/p/6179503.html
        // 使用 cluster 集群模組創建子綫程 worker，變量 cluster.isMaster 判斷當前綫程是否為主綫程 master，如果是主綫程 master 則 cluster.isMaster 返回值為 true;
        // cluster 會在綫程之間共享一個端口，當有外部請求到達時，cluster 會在綫程之間共享一個端口，當有外部請求到達時，cluster 會將這個請求轉發到隨機的子綫程 worker 中，這裏的運行機制，是由一個綫程池（通常設置大小為 CPU 物理核心數）來處理所有請求，并不是為每個請求都創建一個綫程;
        // 當程序啓動時，.isMaster 值會被設置爲 true，然後就進入了第一個 if 語句塊中，在其中每次調用 cluster.fork() 就創建一個子綫程 worker，使用 for 循環創建一個子綫程 worker 池，並重新運行，這時 cluster.isMaster 值會被設置為 false;
        // 每一個子進程 worker 都是使用 child_process.fork() 方法創建的，當子進程 worker 調用 server.listen() 方法時，會向主進程 master 發送一個消息，讓主進程創建一個服務器 socket 做好監聽，並分享給子進程 worker，如果主進程已經有正在監聽的 socker，就跳過創建監聽的過程，直接分享，換句話説，所有的子進程 worker 監聽的都是同一個 socker，當有新鏈接進來的時候，由負載均衡算法選出一個子進程 worker，然後分配給這個選出的子進程 worker 進行處置;
        if (require('cluster').isMaster) {
        // 使用 if 語句判斷當前進程是否為主進程，如果 cluster.isMaster 值為 true 則表示當前為主進程;

            // console.log("當前進程編號: process-" + process.pid);
            // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
            // console.log("當前進程使用的内存: " + process.memoryUsage());
            // console.log("運行當前進程的操作系統平臺: " + process.platform);
            // console.log("運行當前進程的操作系統架構: " + process.arch);
            // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
            // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
            // console.log("當前進程的用戶環境: " + process.env);
            // console.log("當前進程的工作目錄: " + process.cwd());
            // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
            // console.log("運行當前進程的運行時間: " + process.uptime());
            // console.log("當前進程: process-" + process.pid + " 當前執行緒: thread-" + require('worker_threads').threadId);

            // cluster.isMaster：標志是否為主進程 master，如果是則返回 true 值;
            // cluster.isWorker：標志是否為子進程 worker ，如果是則返回 true 值;
            // cluster.worker：獲取當前的子進程 worker 對象，注意這個屬性在主進程 master 中使用無效;
            // cluster.workers：獲取子進程集群中所有尚且存活的子進程 worker 對象，注意這個屬性只能在主進程 master 中使用，在子進程 worker 中使用無效;
            // cluster.fork()：創建子進程 worker;
            // cluster.disconnect([callback])：斷開主進程 master 與所有子進程 worker 的通信連接;

            // 循環創建子綫程池 Fork workers，每調用一次 cluster.fork，就會創建一個子綫程;
            // let number_cluster_Workers = os.cpus().length;  // os.cpus().length 使創建子進程 worker 數目等於物理 CPU 數目;
            console.log("cluster Master setting up " + number_cluster_Workers + " cluster Workers ...");
            for (let i = 0; i < number_cluster_Workers; i++) {
                const cluster_Worker = cluster.fork();  // 調用 cluster.fork 創建一個子綫程;
                worker_queues[cluster_Worker.process.pid] = cluster_Worker;  // 記錄每一個創建成功的子進程 worker 的 ID 號;
                total_worker_called_number[cluster_Worker.process.pid] = 0;
                const worker_id = cluster_Worker.id;
                const worker_process_pid = cluster_Worker.process.pid;

                // 主進程 master 監聽子進程 worker 的創建 fork 事件;
                cluster_Worker.on('fork', (worker) => {
                    console.log("cluster Master fork -> cluster Worker-" + worker.id + " = process-" + worker_process_pid);
                });

                // // 主進程 master 監聽子進程 worker 的創建運行成功 online 事件，用以判斷子進程啓動是否成功;
                // cluster_Worker.on('online', function (worker) {
                //     console.log("cluster Worker-" + worker_id + " = process-" + worker_process_pid + " is online now.");
                //     // worker_queues[worker_process_pid] = cluster_Worker;  // 記錄每一個創建成功的子進程 worker 的 ID 號;
                //     // total_worker_called_number[worker_process_pid] = 0;
                // });

                // 主進程 master 監聽子進程 worker 進入監聽端口事件 listening ;
                cluster_Worker.on('listening', (worker) => {
                    console.log("cluster Worker-" + worker_id + " = process-" + worker_process_pid + " listening on " + worker.address + ":" + worker.port);
                    // worker_queues[worker_process_pid] = cluster_Worker;  // 記錄每一個創建成功的子進程 worker 的 ID 號;
                    // total_worker_called_number[worker_process_pid] = 0;
                });

                // // 主進程 master 監聽子進程 worker 與主進程 master 斷開通信鏈接事件 disconnect ;
                // cluster_Worker.on('disconnect', (worker) => {
                //     console.log("cluster Worker-" + worker.id + " = process-" + worker_process_pid + " is disconnected.");
                // });

                // 主進程 master 監聽子進程 worker 的退出 exit 事件，用以判斷子進程是否出現故障關閉，如果有子進程退出，則從新補充 cluster.fork() 創建一個新的子進程 worker，子進程 worker 進程一旦創建成功可以正常運行，就會激發啓動創建成功 online 事件;
                cluster_Worker.on('exit', (code) => {
                    // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                    console.log("cluster Worker-" + worker_id + " = process-" + worker_process_pid + " exit with code: " + code);

                    // worker.disconnect(function () {});
                    // worker.kill('SIGTERM');
                    // worker.destroy();
                    // console.log("副執行緒 thread-" + id + " 已中止運行, Worker thread-" + id + " be exit. 「 .destroy() 」");

                    // 從記錄正在運行的子進程 worker.id 的 JSON 對象 worker_queues 中，删除已經退出 'exit' 的子進程 ID 編號;
                    if (Object.keys(worker_queues).length > 0) {
                        Object.keys(worker_queues).forEach((id) => {
                            if (id === worker_process_pid) {                                
                                // 從記錄正在運行的子綫程對象的 JSON 變量 cluster.workers 中，删除已經使用 .destroy() 方法退出 'exit' 的子綫程 cluster.workers.hasOwnProperty(id);
                                delete worker_queues[id];
                            };
                        });
                    };


                    // // 從新補充 cluster.fork() 創建一個新的子進程 worker;
                    // const s_cluster_Worker = cluster.fork();  // 調用 cluster.fork 創建一個子綫程;
                    // worker_queues[s_cluster_Worker.id] = s_cluster_Worker;  // 記錄每一個創建成功的子進程 worker 的 ID 號;
                    // total_worker_called_number[s_cluster_Worker.id] = 0;
                    // let s_worker_id = s_cluster_Worker.id;
                    // const s_worker_process_pid = cluster_Worker.process.pid;

                    // // 主進程 master 監聽子進程 worker 的創建 fork 事件;
                    // s_cluster_Worker.on('fork', (worker) => {
                    //     console.log("cluster Master fork -> cluster Worker-" + worker.id + " = process-" + s_worker_process_pid);
                    // });

                    // // 主進程 master 監聽子進程 worker 的創建運行成功 online 事件，用以判斷子進程啓動是否成功;
                    // s_cluster_Worker.on('online', function () {
                    //     console.log("cluster Worker-" + s_worker_id + " = process-" + s_worker_process_pid + " is online now.");
                    //     // worker_queues[s_worker_id] = s_cluster_Worker;  // 記錄每一個創建成功的子進程 worker 的 ID 號;
                    //     // total_worker_called_number[s_worker_id] = 0;
                    // });

                    // // 主進程 master 監聽子進程 worker 進入監聽端口事件 listening ;
                    // s_cluster_Worker.on('listening', (worker) => {
                    //     console.log("cluster Worker-" + s_worker_id + " = process-" + s_worker_process_pid + " listening on " + worker.address + ":" + worker.port);
                    //     // worker_queues[s_worker_id] = s_cluster_Worker;  // 記錄每一個創建成功的子進程 worker 的 ID 號;
                    //     // total_worker_called_number[s_worker_id] = 0;
                    // });

                    // // 主進程 master 監聽子進程 worker 與主進程 master 斷開通信鏈接事件 disconnect ;
                    // s_cluster_Worker.on('disconnect', (worker) => {
                    //     console.log("cluster Worker-" + worker.id + " = process-" + s_worker_process_pid + " is disconnected.");
                    // });

                    // // 主進程 master 監聽子進程 worker 的退出 exit 事件，用以判斷子進程是否出現故障關閉，如果有子進程退出，則從新補充 cluster.fork() 創建一個新的子進程 worker，子進程 worker 進程一旦創建成功可以正常運行，就會激發啓動創建成功 online 事件;
                    // s_cluster_Worker.on('exit', (code) => {
                    //     // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                    //     console.log("cluster Worker-" + s_worker_id + " = process-" + s_worker_process_pid + " exit with code: " + code);

                    //     // worker.disconnect(function () {});
                    //     // worker.kill('SIGTERM');
                    //     // worker.destroy();
                    //     // console.log("副執行緒 thread-" + id + " 已中止運行, Worker thread-" + id + " be exit. 「 .destroy() 」");

                    //     // 從記錄正在運行的子進程 worker.id 的 JSON 對象 worker_queues 中，删除已經退出 'exit' 的子進程 ID 編號;
                    //     if (Object.keys(worker_queues).length > 0) {
                    //         Object.keys(worker_queues).forEach((id) => {
                    //             if (id === s_worker_process_pid) {
                    //                 // 從記錄正在運行的子綫程對象的 JSON 變量 cluster.workers 中，删除已經使用 .destroy() 方法退出 'exit' 的子綫程 cluster.workers.hasOwnProperty(id);
                    //                 delete worker_queues[s_worker_process_pid];
                    //             };
                    //         });
                    //     };
                    // });

                    // // 主進程 master 監聽子進程 worker 向主進程 master 發送消息通信事件 message ;
                    // // worker_queues[worker_active_ID].once('message', (receive_message) => {});
                    // s_cluster_Worker.on('message', (receive_message) => {

                    //     // console.log("Master got the Worker " + s_worker_id + "'s message:");
                    //     // console.log(typeof (receive_message));
                    //     // console.log(receive_message);

                    //     // worker_free[s_worker_process_pid].removeAllListeners('message');  // this.removeAllListeners('message');
                    //     // worker_free[s_worker_process_pid].removeAllListeners('error');  // this.removeAllListeners('error');
                    //     // s_cluster_Worker.send(["exit", {}], function () {});  // cluster.workers[id].send() 主進程 master 向子進程 worker 發送消息通信;
                    //     // s_cluster_Worker.kill(s_worker_process_pid, 'SIGTERM');

                    //     let Message_status = "";
                    //     let Data_JSON = null;
                    //     if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                    //         Message_status = 'message_response';
                    //         Data_JSON = receive_message[0];
                    //     } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                    //         Message_status = receive_message[0];
                    //         Data_JSON = receive_message[1];
                    //     } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                    //         Message_status = receive_message[0];
                    //         let Data_Array = [];
                    //         for (let i = 1; i < receive_message.length; i++) {
                    //             Data_Array.push(receive_message[i]);
                    //         };
                    //     } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                    //         Message_status = 'message_response';
                    //         Data_JSON = receive_message;
                    //         // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'error' && receive_message !== 'error_response') {
                    //         //     Message_status = 'message_response';
                    //         //     Data_JSON = receive_message;
                    //     } else {
                    //         Message_status = receive_message;
                    //     };
                    //     // console.log(Message_status);
                    //     // console.log(Data_JSON);

                    //     switch (Message_status) {

                    //         case 'standby_response': {
                    //             console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             break;
                    //         }

                    //         case 'message_response': {
                    //             // Data_JSON === {
                    //             //     "process_pid": process.pid,  // String(process.pid);
                    //             //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                    //             //     "data": "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ...",
                    //             //     "setInterval_id": setInterval_id,
                    //             //     "authenticate": "",
                    //             //     "time": ""
                    //             // };
                    //             // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);

                    //             if (Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object string]') {
                    //                 console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say error: " + Data_JSON);
                    //             };

                    //             if (typeof (Data_JSON) === 'object' && Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object object]' && !(Data_JSON.length)) {

                    //                 // 記錄每一個子進程 worker 被調用的總次數，函數 JSON.hasOwnProperty("key") 判斷 JSON 對象中是否包含某個 key 值 obj['key'] === undefined;
                    //                 if (Data_JSON["data"] === "Response counting.") {
                    //                     // total_worker_called_number.hasOwnProperty(Data_JSON["process_pid"])
                    //                     if (total_worker_called_number.hasOwnProperty(s_worker_process_pid)) {
                    //                         total_worker_called_number[s_worker_process_pid] = parseInt(total_worker_called_number[s_worker_process_pid]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
                    //                     } else {
                    //                         total_worker_called_number[s_worker_process_pid] = 1;  // 第一次被調用賦值 1 ;
                    //                     };
                    //                 };

                    //                 // // console.log(Data_JSON);
                    //                 // let result = Data_JSON["data"];
                    //                 // // Data_JSON === {
                    //                 // //     "process_pid": process.pid,  // String(process.pid);
                    //                 // //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                    //                 // //     "data": "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ...",
                    //                 // //     "setInterval_id": setInterval_id,
                    //                 // //     "authenticate": "",
                    //                 // //     "time": ""
                    //                 // // };
                    //                 // output_queues_array.push(Data_JSON);
                    //                 // // console.log(output_queues_array);
                    //             };
                    //             break;
                    //         }

                    //         case 'SIGINT_response': {

                    //             // console.log(Data_JSON["process_pid"]);
                    //             // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                    //             // console.log('子進程 process-' + Data_JSON["process_pid"] + ' 執行緒 thread-' + Data_JSON["threadId"] + " 響應主進程 process-" + process.pid + " 執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "SIGINT" 信號中止延時循環運行 setInterval(function(){}, delay).');

                    //             // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                    //             // if (worker_queues.hasOwnProperty(Data_JSON["process_pid"])) {
                    //             //     delete worker_queues[Data_JSON["process_pid"]];
                    //             // };

                    //             // worker_queues[Data_JSON["process_pid"]].kill(Data_JSON["process_pid"], 'SIGTERM');  // 等待子進程運行完畢，正常斷開，銷毀子綫程;
                    //             // worker_queues[Data_JSON["process_pid"]].process.kill(Data_JSON["process_pid"], 'SIGTERM');  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                    //             break;
                    //         }

                    //         case 'exit_response': {

                    //             // console.log(Data_JSON["process_pid"]);
                    //             console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             // console.log('子進程 process-' + Data_JSON["process_pid"] + ' 執行緒 thread-' + Data_JSON["threadId"] + " 響應主進程 process-" + process.pid + " 執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "exit" 信號中止運行.');

                    //             // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                    //             // if (worker_queues.hasOwnProperty(Data_JSON["process_pid"])) {
                    //             //     delete worker_queues[Data_JSON["process_pid"]];
                    //             // };

                    //             // worker_queues[Data_JSON["process_pid"]].kill(Data_JSON["process_pid"], 'SIGTERM');  // 等待子進程運行完畢，正常斷開，銷毀子綫程;
                    //             // worker_queues[Data_JSON["process_pid"]].process.kill(Data_JSON["process_pid"], 'SIGTERM');  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                    //             break;
                    //         }

                    //         case 'error_response': {
                    //             console.log(receive_message);
                    //             // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             break;
                    //         }
                    //         case 'error': {
                    //             console.log(receive_message);
                    //             // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //             break;
                    //         }
                    //         default: {
                    //             console.log(receive_message);
                    //             // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                    //         }
                    //     };
                    // });
                });

                // 主進程 master 監聽子進程 worker 向主進程 master 發送消息通信事件 message ;
                let k = 0;  // 記錄所有子進程 worker 與主進程 master 之間的通信縂次數，用於控制縂測試次數之後，終止主進程測試;
                // worker_queues[worker_active_ID].once('message', (receive_message) => {});
                cluster_Worker.on('message', (receive_message) => {

                    // console.log("Master got the Worker " + worker_id + "'s message:");
                    // console.log(typeof (receive_message));
                    // console.log(receive_message);

                    // worker_free[worker_process_pid].removeAllListeners('message');  // this.removeAllListeners('message');
                    // worker_free[worker_process_pid].removeAllListeners('error');  // this.removeAllListeners('error');
                    // cluster_Worker.send(["exit", {}], function () {});  // cluster.workers[id].send() 主進程 master 向子進程 worker 發送消息通信;
                    // cluster_Worker.kill(worker_id, 'SIGTERM');

                    let Message_status = "";
                    let Data_JSON = null;
                    if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                        Message_status = 'message_response';
                        Data_JSON = receive_message[0];
                    } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                        Message_status = receive_message[0];
                        Data_JSON = receive_message[1];
                    } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                        Message_status = receive_message[0];
                        let Data_Array = [];
                        for (let i = 1; i < receive_message.length; i++) {
                            Data_Array.push(receive_message[i]);
                        };
                    } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                        Message_status = 'message_response';
                        Data_JSON = receive_message;
                        // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'error' && receive_message !== 'error_response') {
                        //     Message_status = 'message_response';
                        //     Data_JSON = receive_message;
                    } else {
                        Message_status = receive_message;
                    };
                    // console.log(Message_status);
                    // console.log(Data_JSON);

                    switch (Message_status) {

                        case 'standby_response': {
                            console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            break;
                        }

                        case 'message_response': {
                            // Data_JSON === {
                            //     "process_pid": process.pid,  // String(process.pid);
                            //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                            //     "worker_id": worker_id,
                            //     "data": "record number.",  // "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ..."
                            //     "setInterval_id": setInterval_id,
                            //     "authenticate": "",
                            //     "time": ""
                            // };
                            // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            // console.log(Data_JSON);

                            if (Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object string]') {
                                console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say error: " + Data_JSON);
                            };

                            if (typeof (Data_JSON) === 'object' && Object.prototype.toString.call(Data_JSON).toLowerCase() === '[object object]' && !(Data_JSON.length)) {
                                
                                // 統計每個子進程 worker 與主進程 master 之間特定通信（message === 'ex'）的縂次數，用於檢查子進程池 workers 分配的負載是否均衡;
                                // if (Data_JSON["data"] === 'ex') {
                                //     k++;  // 記錄主進程 master 的與所有子進程的通信縂次數;
                                //     (k >= 80) && (process.exit(1));  // 主進程 master 與子進程 worker 通信 80 次通信之後，退出主進程;
                                // };
                                // 記錄每一個子進程 worker 被調用的總次數，函數 JSON.hasOwnProperty("key") 判斷 JSON 對象中是否包含某個 key 值 obj['key'] === undefined;
                                if (Data_JSON["data"] === "Response counting.") {
                                    // total_worker_called_number.hasOwnProperty(Data_JSON["process_pid"])
                                    if (total_worker_called_number.hasOwnProperty(worker_process_pid)) {
                                        total_worker_called_number[worker_process_pid] = parseInt(total_worker_called_number[worker_process_pid]) + parseInt(1);  // 每被調用一次，就在相應子進程號下加 1 ;
                                    } else {
                                        total_worker_called_number[worker_process_pid] = 1;  // 第一次被調用賦值 1 ;
                                    };
                                };

                                // // console.log(Data_JSON);
                                // let result = Data_JSON["data"];
                                // // Data_JSON === {
                                // //     "process_pid": process.pid,  // String(process.pid);
                                // //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                                // //     "data": "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ...",
                                // //     "setInterval_id": setInterval_id,
                                // //     "authenticate": "",
                                // //     "time": ""
                                // // };
                                // output_queues_array.push(Data_JSON);
                                // // console.log(output_queues_array);
                            };
                            break;
                        }

                        case 'SIGINT_response': {

                            // console.log(Data_JSON["process_pid"]);
                            // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " setInterval_id: " + Data_JSON["setInterval_id"]);
                            // console.log('子進程 process-' + Data_JSON["process_pid"] + ' 執行緒 thread-' + Data_JSON["threadId"] + " 響應主進程 process-" + process.pid + " 執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "SIGINT" 信號中止延時循環運行 setInterval(function(){}, delay).');

                            // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                            // if (worker_queues.hasOwnProperty(Data_JSON["process_pid"])) {
                            //     delete worker_queues[Data_JSON["process_pid"]];
                            // };

                            // worker_queues[Data_JSON["process_pid"]].kill(Data_JSON["process_pid"], 'SIGTERM');  // 等待子進程運行完畢，正常斷開，銷毀子綫程;
                            // worker_queues[Data_JSON["process_pid"]].process.kill(Data_JSON["process_pid"], 'SIGTERM');  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                            break;
                        }

                        case 'exit_response': {

                            // console.log(Data_JSON["process_pid"]);
                            console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            // console.log('子進程 process-' + Data_JSON["process_pid"] + ' 執行緒 thread-' + Data_JSON["threadId"] + " 響應主進程 process-" + process.pid + " 執行緒 thread-" + require("worker_threads").threadId + ' 發送的 "exit" 信號中止運行.');

                            // // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經退出 'exit' 的子綫程;                                    
                            // if (worker_queues.hasOwnProperty(Data_JSON["process_pid"])) {
                            //     delete worker_queues[Data_JSON["process_pid"]];
                            // };

                            // worker_queues[Data_JSON["process_pid"]].kill(Data_JSON["process_pid"], 'SIGTERM');  // 等待子進程運行完畢，正常斷開，銷毀子綫程;
                            // worker_queues[Data_JSON["process_pid"]].process.kill(Data_JSON["process_pid"], 'SIGTERM');  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                            break;
                        }

                        case 'error_response': {
                            console.log(receive_message);
                            // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            break;
                        }
                        case 'error': {
                            console.log(receive_message);
                            // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                            break;
                        }
                        default: {
                            console.log(receive_message);
                            // console.log("cluster Worker process-" + Data_JSON["process_pid"] + " thread-" + Data_JSON["threadId"] + " say: " + Data_JSON["data"]);
                        }
                    };
                });

                let send_message = {
                    "process_pid": process.pid,  // String(process.pid);
                    "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                    "worker_id": worker_id,
                    "data": "record number.",  // "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ..."
                    "authenticate": "",
                    "time": ""
                };
                cluster_Worker.send(["message", send_message], function () {});  // cluster.workers[id].send() 主進程 master 向子進程 worker 發送消息通信;

            };

            // 主進程 master 向每一個子進程 worker 發送消息：hello, worker ${id}，函數 Object.keys(JSON).forEach((key) => {}) 循環遍歷 JSON 對象中的每一個元素，cluster.workers 返回子進程池（JSON）中所有子進程對象;
            // Object.keys(cluster.workers).forEach((id) => {
            //     cluster.workers[id].send(["message", { "data": "code" }], function () { });  // cluster.workers[id].send() 主進程 master 向子進程 worker 發送消息通信;
            // });

            // Object.keys(cluster.workers).forEach((id) => {
            //     cluster.workers[id].disconnect(function () {});  // cluster.workers[id].disconnect(function(){}) 主進程 Master 斷開與子進程 Worker 的消息通信;
            // });

            // Object.keys(cluster.workers).forEach((id) => {
            //     // cluster.workers[id].kill(worker_id, 'SIGTERM');  // 等待子進程運行完畢，正常斷開，銷毀子綫程;
            //     cluster.workers[id].destroy();  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
            // });

            // Object.keys(cluster.workers).forEach((id) => {
            //     cluster.workers[id].send(["exit", "I am the Master, Worker-" + id + " be exit."], function () {});  // cluster.workers[id].send(['SIGINT',""]) 主進程 master 向子進程 worker 發送消息通信;
            // });

            // process.send(["message", "I am the master, How are you worker " + id + "."], new socket, { keepOpen: false }, function () {});

            // cluster_Worker.send("I am the master, How are you worker " + id + ".");  // cluster.workers[id].send() 主進程 master 向子進程 worker 發送消息通信;
            // cluster_Worker.kill(worker_id, 'SIGTERM');  // 等待子進程運行完畢，正常斷開，銷毀子綫程;
            // cluster_Worker.process.kill(worker_id, 'SIGTERM');  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
            // process.kill(Object.keys(worker_queues)[0], 'exit');  // 'SIGTERM';
            // worker_queues[Object.keys(worker_queues)[0]].kill(Object.keys(worker_queues)[0], 'SIGTERM');
            // worker_queues[Object.keys(worker_queues)[0]].process.kill(Object.keys(worker_queues)[0], 'SIGTERM');
        };

        // 判斷如果當前是子進程 worker，那麽就通知主進程 master 啓動創建並運行服務器監聽，當監聽到有客戶端請求進入後，就均衡分享請求給子進程處理;
        if (!require('cluster').isMaster) {

            // console.log("當前進程編號: process-" + process.pid);
            // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
            // console.log("當前進程使用的内存: " + process.memoryUsage());
            // console.log("運行當前進程的操作系統平臺: " + process.platform);
            // console.log("運行當前進程的操作系統架構: " + process.arch);
            // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
            // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
            // console.log("當前進程的用戶環境: " + process.env);
            // console.log("當前進程的工作目錄: " + process.cwd());
            // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
            // console.log("運行當前進程的運行時間: " + process.uptime());
            // console.log("當前進程: process-" + process.pid + " 當前執行緒: thread-" + require('worker_threads').threadId);

            if (require('cluster').isMaster) { throw new Error('isMaster: ' + require('cluster').isMaster + ', process-' + process.pid + ' threadId-' + require('worker_threads').threadId + ' is not a cluster Worker.') };

            // 創建延時循環，使子綫程一直處於運行狀態，不至於運行完畢被銷毀 setInterval_id = setInterval(function(){}, delay)，清楚循環 clearInterval(setInterval_id);
            let setInterval_id = null;  // 子綫程延時待命的循環對象;
            let delay = null;  //延遲時長，單位毫秒;
            // setInterval_id = setInterval(function () {}, delay);  // 延時循環等待;

            let worker_id = null;
            // 首次向主綫程 Master thread 發送響應;
            let response_message = null;
            // response_message = {
            //     "process_pid": process.pid,  // String(process.pid);
            //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
            //     "worker_id": worker_id,
            //     "data": "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ...",
            //     "setInterval_id": setInterval_id,
            //     "authenticate": "",
            //     "time": ""
            // };
            // process.send(["standby_response", response_message], new socket, { keepOpen: false }, function () {});

            // 子進程 worker 監聽主進程 master 向子進程 worker 發送消息通信事件 message ;
            process.on('message', (receive_message, socket) => {
                // console.log(typeof (receive_message));
                // console.log(receive_message);
                // process.send(["message_response", receive_message]);

                let Message_status = "";
                let Data_JSON = null;
                if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 1) {
                    Message_status = 'message';
                    Data_JSON = receive_message[0];
                } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length === 2) {
                    Message_status = receive_message[0];
                    Data_JSON = receive_message[1];
                } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object array]' && receive_message.length > 2) {
                    Message_status = receive_message[0];
                    let Data_Array = [];
                    for (let i = 1; i < receive_message.length; i++) {
                        Data_Array.push(receive_message[i]);
                    };
                } else if (typeof (receive_message) === 'object' && Object.prototype.toString.call(receive_message).toLowerCase() === '[object object]' && !(receive_message.length)) {
                    Message_status = 'message';
                    Data_JSON = receive_message;
                    // } else if (Object.prototype.toString.call(receive_message).toLowerCase() === '[object string]' && receive_message !== "" && receive_message !== 'SIGINT' && receive_message !== 'error') {
                    //     Message_status = 'message';
                    //     Data_JSON = receive_message;
                } else {
                    Message_status = receive_message;
                };

                // if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]' && (Object.prototype.toString.call(eval(Data_JSON["do_Function"])).toLowerCase() === '[object function]' || Object.prototype.toString.call(eval("do_Function = " + Data_JSON["do_Function"] + ';')).toLowerCase() === '[object function]')) {
                // // 以 let mytFunc = function (argument) {} 形式的函數傳值;
                //     eval("do_Function = " + Data_JSON["do_Function"] + ";");
                // } else if (typeof (Data_JSON["do_Function"]) !== undefined && Data_JSON["do_Function"] !== undefined && Data_JSON["do_Function"] !== null && Data_JSON["do_Function"] !== "" && Object.prototype.toString.call(Data_JSON["do_Function"]).toLowerCase() === '[object string]') {
                // // 以 function mytFunc(argument) {} 形式的函數傳值;
                //     eval(Data_JSON["do_Function"]);
                //     // 使用正則表達式截取傳入的函數名 "function mytFunc(argument) {}".match(/(function =?)(\S*)(?=\()/)[2] 表示截取從 "function " 到 "(" 之間的一段字符串，例如 "aaabbbfff".match(/aaa(\S*)fff/)[1];
                //     // str.replace(/\s+/g,"") 表示去除字符串中所有空格，str.replace(/^\s+|\s+$/g,"") 表示去除字符串兩頭空格，str.replace( /^\s*/, '') 表示去除左頭空格，str.replace(/(\s*$)/g, "") 去除右頭空格;
                //     eval("do_Function = " + Data_JSON["do_Function"].match(/(function =?)(\S*)(?=\()/)[2].replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                //     // eval("do_Function = " + Data_JSON["do_Function"].substring(Data_JSON["do_Function"].indexOf('function') + 9, Data_JSON["do_Function"].indexOf('(')).replace(/\s+/g, ""));  // 使用正則表達式截取傳入的函數名;
                // } else {
                //     // console.log("傳入的用於處理數據的函數參數 do_Function: " + Data_JSON["do_Function"] + " 無法識別.");
                //     do_Function = function (argument) { return argument; };
                // };

                switch (Message_status) {

                    case 'standby': {
                        delay = parseInt(Data_JSON["delay"]);  // 500 延遲時長，單位毫秒;
                        if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
                            // console.log(setInterval_id);
                            clearInterval(setInterval_id);  // 清除延時監聽動作;
                            // console.log(setInterval_id);
                        };
                        setInterval_id = setInterval(function () { }, delay);  // 延時循環等待;
                        // console.log(setInterval_id)
                        // clearInterval(setInterval_id);  // 清除延時監聽動作;

                        // console.log("cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ...");

                        response_message = {
                            "process_pid": process.pid,  // String(process.pid);
                            "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                            "worker_id": worker_id,
                            "data": "cluster Worker process-" + process.pid + " thread-" + require('worker_threads').threadId + " web server Stand by ...",
                            "setInterval_id": setInterval_id,
                            "authenticate": "",
                            "time": ""
                        };
                        process.send(["standby_response", response_message], function () {});
                        break;
                    }

                    case 'message': {
                        // console.log('Worker process-' + process.pid + ' thread-' + require("worker_threads").threadId + ' Web Server start successful.');
                        if (Data_JSON["data"] === "record number.") {
                            if (typeof (Data_JSON["worker_id"]) !== undefined && Data_JSON["worker_id"] !== undefined && Data_JSON["worker_id"] !== null && Data_JSON["worker_id"] !== NaN && Data_JSON["worker_id"] !== "") {
                                worker_id = Data_JSON["worker_id"];
                            };
                        };

                        // // eval(Data_JSON["data"]);
                        // // let result = do_Function(Data_JSON["data"]);
                        // response_message = {
                        //     "process_pid": process.pid,  // String(process.pid);
                        //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                        //     "worker_id": worker_id,
                        //     "data": Data_JSON,
                        //     "authenticate": "",
                        //     "time": ""
                        // };
                        // process.send(["message_response", response_message], function () {});
                        break;
                    }

                    case 'SIGINT': {
                        // console.log('Got SIGINT to exit.');
                        if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
                            // console.log(setInterval_id);
                            clearInterval(setInterval_id);  // 清除延時監聽動作;
                            // console.log(setInterval_id);
                        };
                        response_message = {
                            "process_pid": process.pid,  // String(process.pid);
                            "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                            "worker_id": worker_id,
                            "data": 'Master process-' + Data_JSON["process_pid"] + ' thread-' + Data_JSON["threadId"] + ' post "SIGINT" message stop Worker process-' + process.pid + ' thread-' + require("worker_threads").threadId + ', unstand by clearInterval(setInterval_id).',
                            "setInterval_id": setInterval_id,
                            "authenticate": "",
                            "time": ""
                        };
                        process.send(["SIGINT_response", response_message]);
                        // process.exit(1);
                        break;
                    }

                    case 'exit': {
                        // console.log('Got exit to exit.');
                        if (typeof (setInterval_id) === 'object' && Object.prototype.toString.call(setInterval_id).toLowerCase() === '[object object]' && !(setInterval_id.length) && setInterval_id["_onTimeout"] !== null) {
                            // console.log(setInterval_id);
                            clearInterval(setInterval_id);  // 清除延時監聽動作;
                            // console.log(setInterval_id);
                        };
                        response_message = {
                            "process_pid": process.pid,  // String(process.pid);
                            "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                            "worker_id": worker_id,
                            "data": 'Master process-' + Data_JSON["process_pid"] + ' thread-' + Data_JSON["threadId"] + ' post "exit" message destruction Worker process-' + process.pid + ' thread-' + require("worker_threads").threadId + ', process.exit(1).',
                            "setInterval_id": setInterval_id,
                            "authenticate": "",
                            "time": ""
                        };
                        process.send(["exit_response", response_message], function () {});
                        process.exit(1);
                    }

                    case 'error': {
                        // response_message = {
                        //     "process_pid": process.pid,  // String(process.pid);
                        //     "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                        //     "worker_id": worker_id,
                        //     "data": "Post [ " + receive_message[0] + " ] unrecognized.",
                        //     "authenticate": "",
                        //     "time": ""
                        // };
                        // process.send(["error_response", response_message], function () {});
                        break;
                    }

                    default: {
                        response_message = {
                            "process_pid": process.pid,  // String(process.pid);
                            "threadId": require('worker_threads').threadId,  // String(require('worker_threads').threadId);
                            "worker_id": worker_id,
                            "data": "Post [ " + receive_message[0] + " ] unrecognized.",
                            "authenticate": "",
                            "time": ""
                        };
                        process.send(["error", response_message], function () {});
                    }
                };
            });

            // Workers can share aclearny TCP connection
            // In this case its a HTTP server
            // const server = https.createServer(options, (request, response) => {
            //     request.socket.getPeerCertificate();  // 讀取客戶端的身份驗證詳細信息;
            // });
            // const server = http.createServer((request, response) => {});

            // 如果有積壓，最多允許511個請求在隊列中等候;
            // let options = {
            //     host: "localhost",
            //     port: 8000,
            //     exclusive: false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
            //     backlog: 511,  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
            //     readableAll: false,  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
            //     writableAll: false,  // </boolean>writableAll < boolean > 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
            //     ipv6Only: false  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
            // };
            // server.listen(options, () => {
            //     console.log('server start');
            // });

            server.listen({
                host: host, // "0.0.0.0" or "127.0.0.1" or "localhost"
                port: port, // 1 ~ 65535;
                exclusive: exclusive,  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
                backlog: backlog,  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
                readableAll: readableAll,  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
                writableAll: writableAll,  // </boolean>writableAll < boolean > 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
                ipv6Only: ipv6Only  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
            }, function () {
                // console.log("Starting server. listening on " + host + ":" + port);
                // console.log("Keyboard Enter: [ Ctrl ] + [ c ] to close.");
            });

            server.on('close', () => {
                console.log("Event 'close', stop the web server.");
                // let arr = [];
                // Object.keys(cluster.workers).forEach((id) => {
                //     arr.push(cluster.workers[id]);
                // });
                // console.log("正在運行的子進程: " + arr);
            });

            // server.on('request', (req, res) => {
            //     console.log(req.url);
            //     //设置应答头信息
            //     res.writeHead(200, { 'Content-Type': 'text/html' });
            //     res.write('HHHHH<br>');
            // });

            // server.on('connection', (req, socket, head) => {
            //     console.log('有连接');
            // });

            // server.on('clientError', (err, socket) => {
            //     socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
            // });
        };

        // server.close(function () {
        //     console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");
        // });
        return [server, worker_queues, total_worker_called_number];
    };

    function Run(host, port, number_cluster_Workers, backlog, exclusive, readableAll, writableAll, ipv6Only) {

        // let Key = "username:password";  // 訪問網站簡單驗證用戶名和密碼;
        // let Session = {
        //     "request_Key->username:password": Key
        // };
        // options = {
        //     "host": "localhost",
        //     "port": 8000, // 1 ~ 65535;
        //     "exclusive": true,
        //     "backlog": 511,
        //     "do_HEAD": do_HEAD,
        //     "do_GET": do_GET,
        //     "do_POST": do_POST,
        //     "do_PATCH": do_PATCH
        // };
        // let options = {
        //     // SSL/TLS單向認證指的是只有一個物件校驗對端的證書合法性;
        //     // 通常都是client來校驗伺服器的合法性；
        //     // client需要 ca.crt
        //     // server需要 server.crt, server.key
        //     // SSL / TLS雙向認證指的是相互校驗，伺服器需要校驗每個client客戶端，客戶端client也需要校驗伺服器；
        //     // server 需要 server.key 、server.crt 、ca.crt
        //     // client 需要 client.key 、client.crt 、ca.crt
        //     key: fs.readFileSync('./ssl/server.pem'),  // 用於 https 擴展包的 http + ssl 請求，這是在 ssl 目錄下生成的 server.key 改名爲 server.pem;
        //     cert: fs.readFileSync('./ssl/cert.pem'),
        //     requestCert: true,  // 請求客戶端證書;
        //     rejectUnauthorized: false  // 如果沒有請求到客戶端來自信任的 CA 頒發的證書，拒絕客戶端連接;
        // };

        if (require('cluster').isMaster) {

            // console.log("當前進程編號: " + process.pid);
            // console.log("當前進程使用的中央處理器(CPU): " + process.cpuUsage());
            // console.log("當前進程使用的内存: " + process.memoryUsage());
            // console.log("運行當前進程的操作系統平臺: " + process.platform);
            // console.log("運行當前進程的操作系統架構: " + process.arch);
            // console.log("當前進程使用的 node 解釋器被編譯時的配置信息: " + process.config);
            // console.log("當前進程使用的 node 解釋器的發行版本: " + process.release);
            // console.log("當前進程的用戶環境: " + process.env);
            // console.log("當前進程的工作目錄: " + process.cwd());
            // console.log("當前進程使用的 node 解釋器二進制可執行檔保存路徑: " + process.execPath);
            // console.log("運行當前進程的運行時間: " + process.uptime());
            console.log("當前進程: process-" + process.pid + " , 當前執行緒: thread-" + require('worker_threads').threadId);

            if (host === "::0" || host === "::1" || check_ip(host) === "IPv6") {
                // console.log("進程: process-" + process.pid + " , 執行緒: thread-" + require('worker_threads').threadId + " 正在監「 http://[" + host + "]:" + port + "/ 」 ...");
                console.log("process-" + process.pid + " > thread-" + require('worker_threads').threadId + " listening on host domain > http://[" + host + "]:" + port + "/ ...");
            } else if (host === "0.0.0.0" || host === "127.0.0.1" || check_ip(host) === "IPv4") {
                // console.log("進程: process-" + process.pid + " , 執行緒: thread-" + require('worker_threads').threadId + " 正在監「 http://" + host + ":" + port + "/ 」 ...");
                console.log("process-" + process.pid + " > thread-" + require('worker_threads').threadId + " listening on host domain > http://" + host + ":" + port + "/ ...");
            } else if (host === "localhost") {
                // console.log("進程: process-" + process.pid + " , 執行緒: thread-" + require('worker_threads').threadId + " 正在監「 http://" + host + ":" + port + "/ 」 ...");
                console.log("process-" + process.pid + " > thread-" + require('worker_threads').threadId + " listening on host domain > http://" + host + ":" + port + "/ ...");
            } else {
                console.log("Error: host IP [ " + host + " ] unrecognized.");
                // return false;
            };
            if (Object.prototype.toString.call(Key).toLowerCase() === '[object string]' && Key !== "") {
                let Key_username = "";  // "username";
                let Key_password = "";  // "password";
                if (Key.indexOf(":", 0) !== -1) {
                    Key_username = Key.split(':')[0];  // "username";
                    Key_password = Key.split(':')[1];  // "password";
                } else {
                    Key_username = Key;  // "username";
                };
                if (Key_username !== "" && Key_password !== "") {
                    console.log("Client key = [ " + Key_username + " ]" + " : " + "[ " + Key_password + " ].");
                } else if (Key_username !== "" && Key_password === "") {
                    console.log("Client key = " + Key_username);
                } else if (Key_username === "" && Key_password !== "") {
                    console.log("Client key = :" + Key_password);
                };
            };
            console.log('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.');
            console.log('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.');
            console.log("Keyboard Enter [ Ctrl ] + [ c ] to close.");
            console.log("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.");

            // 當未捕獲的 JavaScript 異常冒泡回到事件循環時，則會觸發 'uncaughtException' 事件;
            process.on("uncaughtException", (error, origin) => {
                console.log("未捕獲異常: " + error);
                console.log("異常來源: " + origin);
                // console.error(error);
                // if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                //     if (Object.keys(worker_queues).length > 0) {
                //         Object.keys(worker_queues).forEach((id) => {
                //             if (cluster.workers[worker_queues[id].id]) {
                //                 // worker_queues[id].send(["exit", "Master thread .on('beforeExit')."], function () { });  // cluster.workers[id].send(['SIGINT',""]) 主進程 master 向子進程 worker 發送消息通信;
                //                 // worker_queues[id].disconnect(function () { });  // cluster.workers[id].disconnect(function(){}) 主進程 Master 斷開與子進程 Worker 的消息通信;
                //                 worker_queues[id].destroy();  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                //                 // console.log("子進程 cluster Worker-" + id + " 已中止運行, cluster Worker-" + id + " be exit. 「 .destroy() 」");
                //             };
                //             // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .destroy() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                //             delete worker_queues[id];
                //         });
                //     };
                // };
                // process.exit(1);
            });
            // throw new Error("I am tired...");  // 故意抛出一個異常測試;

            // 監聽 'SIGINT' 信號，當 Node.js 進程接收到 'SIGINT' 信號時，會觸發該事件;
            // 'SIGHUP' 信號在 Windows 平臺上當控制臺使用鍵盤輸入 [ Ctrl ] + [ c ] 窗口被關閉時會被觸發，在其它平臺上在相似的條件下也會被觸發;
            process.on('SIGINT', function () {

                // 監聽 'SIGINT' 信號事件，使用鍵盤輸入 [ Ctrl ] + [ c ] 中止進程運行，不會激活 'beforeExit' 事件，而直接激活 'exit' 事件;
                console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");  // "Master process-" + process.pid + " Master thread-" + require('worker_threads').threadId
                if (typeof (total_worker_called_number) === 'object' && Object.prototype.toString.call(total_worker_called_number).toLowerCase() === '[object object]' && !(total_worker_called_number.length)) {
                    if (Object.keys(total_worker_called_number).length > 0) {
                        let arr = new Array;
                        // Object.keys(cluster.workers).forEach((id) => { arr.push("Worker-".concat(id)); });
                        // console.log("正在運行的集群伺服: cluster " + arr);
                        Object.keys(total_worker_called_number).forEach((id) => {
                            if (String(id) === String(process.pid)) {
                                console.log("正在運行的伺服: Web server process-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                            } else {
                                if (typeof (worker_queues[id].id) !== undefined && worker_queues[id].id !== undefined && worker_queues[id].id !== null && worker_queues[id].id !== "" && cluster.workers.hasOwnProperty(worker_queues[id].id)) {
                                    arr.push("Worker-".concat(worker_queues[id].id, "(Runing) [ ", total_worker_called_number[id], " ]"));
                                } else {
                                    arr.push("Worker process-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                                };
                            };
                        });
                        if (arr.length > 0) { console.log("集群伺服: cluster " + arr); };
                    };
                };

                if (Object.keys(cluster.workers).length > 0) {
                    Object.keys(cluster.workers).forEach((id) => {
                        cluster.workers[id].send(["exit", "Master thread .on('beforeExit')."], function () {});  // cluster.workers[id].send(['SIGINT',""]) 主進程 master 向子進程 worker 發送消息通信;
                        // cluster.workers[id].disconnect(function () { });  // cluster.workers[id].disconnect(function(){}) 主進程 Master 斷開與子進程 Worker 的消息通信;
                        // cluster.workers[id].destroy();  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                        // console.log("子進程 cluster Worker-" + id + " 已中止運行, cluster Worker-" + id + " be exit. 「 .destroy() 」");
                        // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .destroy() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                        // delete worker_queues[id];
                    });
                };

                // 關閉服務器主進程;
                if (server) {
                    server.close(function () {
                        // console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");
                    });
                };

                // 注意當注冊了監聽 'SIGINT' 信號事件時，使用鍵盤輸入 [ Ctrl ] + [ c ] 不會自動中止進程，需要手動調用 process.exit([code]) 方法來中止進程;
                process.exit(1);
            });

            // 配置中止主綫程前的最後一個動作;
            process.on('beforeExit', (code) => {

                // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                    if (Object.keys(worker_queues).length > 0) {
                        Object.keys(worker_queues).forEach((id) => {
                            if (cluster.workers[worker_queues[id].id]) {
                                worker_queues[id].send(["exit", "Master thread .on('beforeExit')."], function () { });  // cluster.workers[id].send(['SIGINT',""]) 主進程 master 向子進程 worker 發送消息通信;
                                // worker_queues[id].disconnect(function () { });  // cluster.workers[id].disconnect(function(){}) 主進程 Master 斷開與子進程 Worker 的消息通信;
                                // worker_queues[id].destroy();  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                                // console.log("子進程 cluster Worker-" + id + " 已中止運行, cluster Worker-" + id + " be exit. 「 .destroy() 」");
                            };
                            // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .destroy() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                            delete worker_queues[id];
                        });
                    };
                };

            });

            // 監聽主進程的退出 'exit' 事件;
            process.on('exit', (code) => {

                // // "exit" 事件的回調函數中的内容，必須是同步的，如果是異步的，則不會被執行;
                // if (typeof (total_worker_called_number) === 'object' && Object.prototype.toString.call(total_worker_called_number).toLowerCase() === '[object object]' && !(total_worker_called_number.length)) {
                //     if (Object.keys(total_worker_called_number).length > 0) {
                //         let arr = new Array;
                //         // Object.keys(worker_queues).forEach((id) => { arr.push("Worker-".concat(id)); });
                //         // console.log("正在運行的集群伺服: cluster " + arr);
                //         Object.keys(total_worker_called_number).forEach((id) => {
                //             if (String(id) === String(process.pid)) {
                //                 console.log("正在運行的伺服: Web server process-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                //             } else {
                //                 if (typeof (worker_queues[id].id) !== undefined && worker_queues[id].id !== undefined && worker_queues[id].id !== null && worker_queues[id].id !== "" && cluster.workers.hasOwnProperty(worker_queues[id].id)) {
                //                     arr.push("Worker-".concat(worker_queues[id].id, "(Runing) [ ", total_worker_called_number[id], " ]"));
                //                 } else {
                //                     arr.push("Worker process-".concat(id, " [ ", total_worker_called_number[id], " ]"));
                //                 };
                //             };
                //         });
                //         if (arr.length > 0) { console.log("集群伺服: cluster " + arr); };
                //     };
                // };
                // if (typeof (worker_queues) === 'object' && Object.prototype.toString.call(worker_queues).toLowerCase() === '[object object]' && !(worker_queues.length)) {
                //     if (Object.keys(worker_queues).length > 0) {
                //         Object.keys(worker_queues).forEach((id) => {
                //             if (cluster.workers[worker_queues[id].id]) {
                //                 // worker_queues[id].send(["exit", "Master thread .on('beforeExit')."], function () { });  // cluster.workers[id].send(['SIGINT',""]) 主進程 master 向子進程 worker 發送消息通信;
                //                 // worker_queues[id].disconnect(function () { });  // cluster.workers[id].disconnect(function(){}) 主進程 Master 斷開與子進程 Worker 的消息通信;
                //                 worker_queues[id].destroy();  // 不等待子進程運行完畢，强制中止斷開，銷毀子綫程;
                //                 // console.log("子進程 cluster Worker-" + id + " 已中止運行, cluster Worker-" + id + " be exit. 「 .destroy() 」");
                //             };
                //             // 從記錄正在運行的子綫程對象的 JSON 變量 worker_queues 中，删除已經使用 .destroy() 方法退出 'exit' 的子綫程 worker_queues.hasOwnProperty(id);
                //             delete worker_queues[id];
                //         });
                //     };
                // };

                console.log("Master process-" + process.pid + " thread-" + require('worker_threads').threadId + " be exit.");
            });
        };

        // 判斷當輸入參數 number_cluster_Workers > 0 且為整數時，以并行集群的方式多進程啓動服務器，否則以單進程啓動服務器;
        if (typeof (number_cluster_Workers) !== undefined && number_cluster_Workers !== undefined && !isNaN(Number(number_cluster_Workers)) && parseInt(number_cluster_Workers) > 0) {
        // 以并行集群的方式多進程啓動服務器;

            // let worker_queues = {};  // 用於記錄子進程池 workers 中的每個子進程 worker 的 ID 號碼;
            // let total_worker_called_number = {};  // 用於記錄每一個子進程被調用的總次數;
            let Workers = [];
            try {
                Workers = Multiprocess_start_Server(host, port, number_cluster_Workers, backlog, exclusive, readableAll, writableAll, ipv6Only);
                worker_queues = Workers[1];  // 用於記錄子進程池 workers 中的每個子進程 worker 的 ID 號碼;
                total_worker_called_number = Workers[2];  // 用於記錄每一個子進程被調用的總次數;
            } catch (error) {
                console.log("start server failure !");
                console.log(error.message);
            } finally {};

            return [Workers[0], worker_queues, total_worker_called_number];

        } else {
        // 以單進程監聽方式啓動服務器;

            // 如果有積壓，最多允許511個請求在隊列中等候;
            // let options = {
            //     host: "localhost",
            //     port: 8000,
            //     exclusive: false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
            //     backlog: 511,  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
            //     readableAll: false,  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
            //     writableAll: false,  // </boolean>writableAll < boolean > 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
            //     ipv6Only: false  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
            // };
            // server.listen(options, () => {
            //     console.log('server start');
            // });

            try {

                server.listen({
                    host: host, // "0.0.0.0" or "127.0.0.1" or "localhost";
                    port: port, // 1 ~ 65535;
                    exclusive: exclusive,  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
                    backlog: backlog,  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
                    readableAll: readableAll,  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
                    writableAll: writableAll,  // </boolean>writableAll < boolean > 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
                    ipv6Only: ipv6Only  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
                }, function () {
                    // // console.log("進程: process-" + process.pid + " , 執行緒: thread-" + require('worker_threads').threadId + " 正在監「 http://" + host + ":" + port + "/ 」 ...");
                    // console.log("process-" + process.pid + " > thread-" + require('worker_threads').threadId + " listening on Host domain [ http://" + host + ":" + port + "/ ] ...");
                    // console.log('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.');
                    // console.log('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.');
                    // console.log("Keyboard Enter [ Ctrl ] + [ c ] to close.");
                    // console.log("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.");
                });

                server.on('close', () => {
                    console.log("Web server stopped.");
                });

                // server.on('request', (req, res) => {
                //     console.log(req.url);
                //     // 設置應答頭信息;
                //     res.writeHead(200, { 'Content-Type': 'text/html' });
                //     res.write('HHHHH<br>');
                // });

                // server.on('connection', (req, socket, head) => {
                //     console.log('有鏈接');
                // });

                // server.on('clientError', (err, socket) => {
                //     socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
                // });

                // server.close(function () {
                //     console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");
                // });

            } catch (error) {
                console.log("start server failure !");
                console.log(error.message);
            } finally {};

            return [server, worker_queues, total_worker_called_number];
        };
    };


    let worker_queues = {};  // 用於記錄子進程池 workers 中的每個子進程 worker 的 ID 號碼;
    let total_worker_called_number = {};  // 用於記錄每一個子進程被調用的總次數;

    let result = Run(host, port, number_cluster_Workers, backlog, exclusive, readableAll, writableAll, ipv6Only);

    worker_queues = result[1];
    total_worker_called_number = result[2];

    return [result[0], worker_queues, total_worker_called_number];
};
module.exports.http_Server = http_Server; // 使用「module.exports」接口對象，用來導出模塊中的成員;



// // 媒介服務器函數服務端（後端） http_Server() 使用説明;
// // const child_process = require('child_process');  // Node原生的創建子進程模組;
// // const os = require('os');  // Node原生的操作系統信息模組;
// // const net = require('net');  // Node原生的網卡網絡操作模組;
// // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const qs = require('querystring');
// const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
// const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
// const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
// // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
// // const cluster = require('cluster');  // Node原生的支持多進程模組;
// // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
// // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
// let host = "::0";  // "::0" or "::1" or "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// let port = 10001;  // 1 ~ 65535 監聽端口;
// let webPath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// let number_cluster_Workers = 2;  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// // console.log(number_cluster_Workers);
// let Key = "";  // "username:password";  // 自定義的訪問網站簡單驗證用戶名和密碼;
// // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
// let Session = {
//     "request_Key->username:password": Key
// };
// let do_Request = do_Request_Router;  // 用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// let do_Function_JSON = {
//     "do_Request": do_Request.toString(),  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// };
// let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
// let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
// let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
// let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
// let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
// const base64 = new Base64();
// let Server = http_Server({
//     "host": host,
//     "port": port,
//     "number_cluster_Workers": number_cluster_Workers,
//     "Key": Key,
//     "Session": Session,
//     // "do_Function_JSON": do_Function_JSON,
//     "do_Request": do_Request,
//     "exclusive": exclusive,
//     "backlog": backlog,
//     "readableAll": readableAll,
//     "writableAll": writableAll,
//     "ipv6Only": ipv6Only
// });
// // let Server = Interface_http_Server({
// //     "do_Request": do_Request,
// //     "Session": Session,
// //     "Key": Key,
// //     "number_cluster_Workers": number_cluster_Workers,
// // });







// http_Client_「http」;
function http_Client({}, callback) {

    // 可變參數傳值;
    // for (let i = 0; i < arguments.length; i++) {
    //     console.log(arguments[i]);
    // };
    let argument_1 = arguments[0];

    // 用於向服務器發送請求的參數變量
    let Host = "localhost";  // "0.0.0.0"; "127.0.0.1";
    let Port = parseInt(8000);
    let URL = "/";  // "http://localhost:8000"，"http://usename:password@localhost:8000/";
    let Method = "POST";  // "GET" 請求方法;
    let time_out = parseInt(1000);  // 500 設置鏈接超時自動中斷，單位毫秒;
    let request_Auth = "";  // "username:password";
    // let request_Authorization_Base64 = "Basic ".concat(new Base64().encode("username:password", "utf8"));  // request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
    let request_Cookie = "";  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
    // let request_Cookie_Base64 = "Session_ID=".concat(new Base64().encode("request_Key->username:password"));  // 使用自定義函數Base64()編碼請求 Cookie 信息;
    let post_Data_String = "";

    // 讀取傳入函數的可變參數的值;
    if (typeof (argument_1) !== undefined && argument_1 !== undefined) {
        if (typeof (argument_1) === 'object' && Object.prototype.toString.call(argument_1).toLowerCase() === '[object object]' && !(argument_1.length)) {
            // 配置鏈接主機域名 Host domain name "localhost"; "0.0.0.0"; "127.0.0.1";
            if (argument_1.hasOwnProperty("Host") && typeof (argument_1["Host"]) !== undefined && argument_1["Host"] !== undefined && argument_1["Host"] !== null && argument_1["Host"] !== NaN && argument_1["Host"] !== "") {
                Host = String(argument_1["Host"]);  // typeof (Host) === "String";
            };
            // 配置鏈接埠號 parseInt(8000);
            if (argument_1.hasOwnProperty("Port") && typeof (argument_1["Port"]) !== undefined && argument_1["Port"] !== undefined && argument_1["Port"] !== null && argument_1["Port"] !== NaN && argument_1["Port"] !== "") {
                Port = parseInt(argument_1["Port"]);  // typeof (Port) === "Number";
            };
            // 配置請求路徑 "/"; "http://localhost:8000"，"http://usename:password@localhost:8000/";
            if (argument_1.hasOwnProperty("URL") && typeof (argument_1["URL"]) !== undefined && argument_1["URL"] !== undefined && argument_1["URL"] !== null && argument_1["URL"] !== NaN && argument_1["URL"] !== "") {
                URL = String(argument_1["URL"]);  // typeof (URL) === "String";
            };
            // 配置請求方法 "GET";
            if (argument_1.hasOwnProperty("Method") && typeof (argument_1["Method"]) !== undefined && argument_1["Method"] !== undefined && argument_1["Method"] !== null && argument_1["Method"] !== NaN && argument_1["Method"] !== "") {
                Method = String(argument_1["Method"]);  // typeof (Method) === "String";
            };
            // 設置鏈接超時自動中斷，單位毫秒 parseInt(1000);
            if (argument_1.hasOwnProperty("time_out") && typeof (argument_1["time_out"]) !== undefined && argument_1["time_out"] !== undefined && argument_1["time_out"] !== null && argument_1["time_out"] !== NaN && argument_1["time_out"] !== "") {
                time_out = parseInt(argument_1["time_out"]);  // typeof (time_out) === "Number";
            };
            // 配置請求身份驗證密碼 "username:password";
            if (argument_1.hasOwnProperty("request_Auth") && typeof (argument_1["request_Auth"]) !== undefined && argument_1["request_Auth"] !== undefined && argument_1["request_Auth"] !== null && argument_1["request_Auth"] !== NaN && argument_1["request_Auth"] !== "") {
                request_Auth = String(argument_1["request_Auth"]);  // typeof (request_Auth) === "String";
            };
            // 配置請求 Cookie 值 "Session_ID=request_Key->username:password";
            if (argument_1.hasOwnProperty("request_Cookie") && typeof (argument_1["request_Cookie"]) !== undefined && argument_1["request_Cookie"] !== undefined && argument_1["request_Cookie"] !== null && argument_1["request_Cookie"] !== NaN && argument_1["request_Cookie"] !== "") {
                request_Cookie = String(argument_1["request_Cookie"]);  // typeof (request_Cookie) === "String";
            };
            // 配置當發送 "POST" 請求時，發送的數據 post_Data_String;
            if (argument_1.hasOwnProperty("post_Data_String") && typeof (argument_1["post_Data_String"]) !== undefined && argument_1["post_Data_String"] !== undefined) {
                if (typeof (argument_1["post_Data_String"]) === 'object' && Object.prototype.toString.call(argument_1["post_Data_String"]).toLowerCase() === '[object object]' && !(argument_1["post_Data_String"].length)) {
                    post_Data_String = JSON.stringify(argument_1["post_Data_String"]); // JSON 對象 typeof (post_Data_String) === "Object"，使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;
                } else if (Object.prototype.toString.call(argument_1["post_Data_String"]).toLowerCase() === '[object string]') {
                    post_Data_String = argument_1["post_Data_String"];  // JSON 對象 typeof (post_Data_String) === "String";
                } else { };
            };
        };
    };

    let User_Agent = "Node.js_http.request";
    // User_Agent = child_process.execSync('node --version').toString("UTF8");
    // // console.log(child_process.execSync('node --version'));
    // // console.log(typeof(child_process.execSync('node --version')));
    // User_Agent = User_Agent.replace(unescape("%0D%0A"), "").replace(new RegExp("/[\r\n]/", "g"), "").replace(new RegExp("/(^\s*)|(\s*$)/", "g"), "");  // .replace(new RegExp("\\.", "g"), "");
    // User_Agent = escape(User_Agent);
    // // User_Agent = String(process.release["name"]).concat("-", String(process.platform));  // 當前正在運行的 node 解釋器的編譯時的信息;
    // // User_Agent = String(os.hostname());
    // User_Agent = "Node.js ".concat(User_Agent, "_http.request_", String(os.type()), "_", String(os.hostname()));
    // // console.log(User_Agent);

    // // 這裏是需要向Python服務器發送的參數數據JSON對象;
    // // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    // let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // // let nowDate = new Date();
    // // let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
    // // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    // let argument = "How_are_you_!";
    // let post_Data_JSON = {
    //     "Client_say": argument.replace(new RegExp("_", "g"), " "),
    //     "time": String(now_date)
    // };
    // // let post_Data_String = '{\\"Node_say\\":\\"' + argument + '\\",\\"time\\":\\"' + time + '\\"}'; // change the javascriptobject to jsonstring;
    // if (typeof (post_Data_String) === 'object' && Object.prototype.toString.call(post_Data_String).toLowerCase() === '[object object]' && !(post_Data_String.length)) {
    //     post_Data_String = JSON.stringify(post_Data_String); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;
    // };
    // if (isStringJSON(post_Data_String)) {
    //     post_Data_JSON = JSON.parse(post_Data_String);
    // };
    // let arg1 = 'hello';
    // let arg2 = 'world.';
    // let post_Data_String = qs.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;

    // 下面是真正使用request方法向服務器傳遞的參數;
    // host: 表示請求網站的域名或IP位址（請求的位址），預設值為：'localhost';
    // hostname: host 的別名。為了支持 url.parse()，如果同時指定 host 和 hostname，則使用 hostname;
    // port: 請求網站的埠，預設值為：80;
    // auth: <string> 身份認證，即 'user:password'，用於計算授權請求頭;
    // localAddress: 為網絡連接綁定的本地接口;
    // protocol: <string> 使用的網絡傳輸協議，預設值為：'http:';
    // timeout: <number> 指定通訊端響應超時的數值，以毫秒為單位，這會在通訊端被連接之前設置超時;
    // socketPath: Unix Domain Socket（Domain通訊端路徑）;
    // method: HTTP請求方法，預設值為：'GET';
    // path: 請求的相對於根的路徑，預設值為：'/'，QueryString應該包含在其中，例如：/index.html?page=12;
    // headers: 請求頭對象;
    // auth: Basic認證（基本驗證），這個值將被計算成請求頭中的 Authorization 部分;
    // callback: 回檔，傳遞一個參數，為 http.ClientResponse的實例。http.request 返回一個 http.ClientRequest 的實例;
    let options = {
        host: Host,
        port: Port,
        path: URL,  // 也可以選 { host: 'localhost', port: '8000', path: '/' } 參數組合;
        // 如果這裏寫入網站URL全名，例如 path: 'http://usename:password@localhost:8000/' ，然後在 host: 'baidu.com' ，假設 'baidu.com' 是一個提供代理服務器的主機名，那麽這就實現了一個從指定的代理服務器發出請求的功能;
        method: Method,  // 'POST',
        timeout: time_out,  // 500 設置鏈接超時自動中斷，單位毫秒;
        auth: request_Auth,  // 選填 {auth: 'username:password'} 參數後，http 庫會自動在請求頭 headers 中加入 { "Authorization": "Basic ".concat(new Base64().encode("username:password") } 參數;
        // // SSL/TLS單向認證指的是只有一個物件校驗對端的證書合法性;
        // // 通常都是client來校驗伺服器的合法性；
        // // client需要 ca.crt
        // // server需要 server.crt, server.key
        // // SSL / TLS雙向認證指的是相互校驗，伺服器需要校驗每個client客戶端，客戶端client也需要校驗伺服器；
        // // server 需要 server.key 、server.crt 、ca.crt
        // // client 需要 client.key 、client.crt 、ca.crt
        // requestCert: true,  // 當使用 https 庫發送 http + SSL(TLS) 請求時，請求客戶端證書;
        // rejectUnauthorized: false,  // 當使用 https 庫發送 http + SSL(TLS) 請求時，如果沒有請求到客戶端來自信任 CA 頒發的證書，拒絕客戶端的連接;
        // key: fs.readFileSync('../key/client-key.pem'),  // 同步讀取硬盤中保存的 http + ssl 請求的 CA 證書;
        // cert: fs.readFileSync('../key/client-cert.pem'),  // 同步讀取硬盤中保存的 http + ssl 請求的 CA 證書;
        // ca: [fs.readFileSync('../key/ca-cert.pem')],  // 同步讀取硬盤中保存的 http + ssl 請求的 CA 證書;
        // agent: false,  // 必須設置爲false，否則證書不起作用;
        headers: {
            'Accept': '*/*',  // 客戶端能接受的資源類型 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' ;
            'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8', // post 請求需要設置的 type 值;
            'Content-Length': Buffer.byteLength(post_Data_String),  // 客戶端發送的請求數據長度;
            // 'Transfer-Encoding': 'chunked',
            'Accept-Language': 'zh-Hant-TW; q=0.8, zh-Hant; q=0.7, zh-Hans-CN; q=0.7, zh-Hans; q=0.5, en-US, en; q=0.3',  // 客戶端能接受的自然語言類型;
            'Accept-Charset': 'utf-8',  // 瀏覽器告訴服務器自己能接受的字符編碼;
            // 'Accept-Encoding': 'gzip, deflate',  // 客戶端能接收的壓縮數據的類型;
            // 'Host': 'localhost:8000',  // 鏈接的目標主機和端口號;
            // 'Request URL': 'http://username:password@localhost:8000/',  // 請求的服務器網址 URL ;
            // 'Request Method': 'POST',  // 請求的方法 POST GET ;
            // 'Referer': 'http://localhost',  // 告訴服務器這個請求是從哪裏鏈接過來的;
            // 'If-Modified-Since': new Date().toLocaleString('chinese', { hour12: false }),  // 緩存時間;
            'Cache-Control': 'no-cache',  // 'max-age=0' 或 no-store, must-revalidate 設置不允許瀏覽器緩存，必須刷新數據;
            'Connection': 'close',  // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
            'Upgrade': 'HTTP/1.0, HTTP/1.1, HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11',  // 向服務器指定某種傳輸協議;
            'From': 'user@email.com',  // 發送請求用戶的 Email 地址;
            // 'Authorization': request_Authorization_Base64,  // 服務器訪問密碼參數；使用自定義函數對字符串進行base64編解碼，解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
            'Cookie': request_Cookie,  // 請求 cookie 值;
            'Date': String(new Date().toLocaleString('chinese', { hour12: false })),  // 客戶端請求服務端的時間;
            'User-Agent': User_Agent  // 客戶端版本號的名字 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36';
        }
    };
    // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
    // options.host = "localhost";  // Host;
    // options.port = "8000";  // Port;
    // options.path = "/";  // URL;
    // options.auth = "username:password";  // request_Auth;
    // options.headers["Content-Length"] = Buffer.byteLength(post_Data_String);
    // options.headers["Authorization"] = "Basic ".concat(new Base64().encode("username:password"));  // request_Authorization_Base64;
    // options.headers["Cookie"] = "";  // "Session_ID=request_Key->username:password";  // request_Cookie;  // request_Cookie_Base64;

    // 向服務端發送請求
    function start_Client(Client_options, callback) {

        let options = Client_options["options"];
        let post_Data_String = Client_options["post_Data_String"];
        // let post_Data_JSON = {
        //     "Client_say": argument.replace(new RegExp("_", "g"), " "),
        //     "time": String(now_date)
        // };
        // // let post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + time + '\\"}'; // change the javascriptobject to jsonstring;
        // let post_Data_String = JSON.stringify(post_Data_JSON);

        const request = http.request(options, (response) => {

            // response.setEncoding("UTF8");

            // 讀取響應狀態碼值 response.statusCode，200-正常，401-無權訪問需要身份驗證，302-重定向;
            let response_statusCode = new Number;
            let response_statusMessage = new String;
            if (typeof (response.statusCode) !== undefined && response.statusCode !== undefined && response.statusCode !== null && response.statusCode !== NaN && response.statusCode !== "") {
                response_statusCode = response.statusCode;  // 獲取響應狀態碼200-正常，401-無權訪問需要身份驗證，302-重定向;
                response_statusCode = response_statusCode.toString();  // String(response_statusCode) 强制轉換為字符串類型;
                // console.log("response status Code: " + response.statusCode);
                // console.log(typeof (response.statusCode));
            };
            if (typeof (response.statusMessage) !== undefined && response.statusMessage !== undefined && response.statusMessage !== null && response.statusMessage !== NaN && response.statusMessage !== "") {
                response_statusMessage = response.statusMessage;  // 獲取響應狀態碼的提示信息 200-正常，401-無權訪問需要身份驗證，302-重定向;
                response_statusMessage = new Base64().decode(response_statusMessage.split(" ")[0]).toString("UTF8").concat(" ", response_statusMessage.split(" ")[1]);  // unescape(response_statusMessage).toString("UTF8"); decodeURIComponent(response_statusMessage); String(response_statusCode) 强制轉換為字符串類型;
                // console.log("response status Message: " + response_statusMessage);
                // console.log(typeof (response.statusMessage));
            };

            // 獲取響應頭值JSON對象;
            let response_headers = response.headers; // 獲取響應頭 response_headers = JSON.stringify(response.headers);
            // console.log(response.headers);

            // 讀取響應頭中的 Cookie 參數值;
            let response_Cookies = "";
            if (typeof (response.headers["set-cookie"]) !== undefined && response.headers["set-cookie"] !== undefined && response.headers["set-cookie"] !== null && response.headers["set-cookie"] !== NaN && response.headers["set-cookie"].length > 0) {
                response_Cookies = response.headers["set-cookie"]; // 獲取響應頭中的"set-cookie"參數值 response.headers["set-cookie"];
                // console.log("response Headers set-cookie: " + response.headers["set-cookie"]);
                let cookieName = "";
                if (response_Cookies[0].indexOf(";", 0) !== -1) {
                    // response.headers["set-cookie"].charAt(response.headers["set-cookie"].indexOf(";", 0));
                    // let request_Key = response_Cookies[0].split(";")[0].split(",")[1]; 
                    // let session_id = response_Cookies[0].split(";")[0].split(",")[0];

                    // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    // request_Cookie = response_Cookies[0].split(";")[0];  // 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
                    options.headers["Cookie"] = response_Cookies[0].split(";")[0];  // 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;

                    if (response_Cookies[0].split(";")[0].indexOf("=", 0) !== -1) {
                        cookieName = response_Cookies[0].split(";")[0].split("=")[0].concat("=", new Base64().decode(response_Cookies[0].split(";")[0].split("=")[1]));
                    } else {
                        cookieName = new Base64().decode(response_Cookies[0].split(";")[0]);
                    };
                } else {
                    // request_Cookie = response_Cookies[0];
                    options.headers["Cookie"] = response_Cookies[0];

                    if (response_Cookies[0].indexOf("=", 0) !== -1) {
                        cookieName = response_Cookies[0].split("=")[0].concat("=", new Base64().decode(response_Cookies[0].split("=")[1]));
                    } else {
                        cookieName = new Base64().decode(response_Cookies[0]);
                    };
                };
                // console.log(cookieName);  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
            };

            // 讀取響應頭中的重定向參數值 response.headers["location"];
            let response_Location = "";
            if (typeof (response.headers["location"]) !== undefined && response.headers["location"] !== undefined && response.headers["location"] !== null && response.headers["location"] !== NaN && response.headers["location"].length > 0) {
                // /^https?:\/\//.test(response.headers["location"]);  // 使用正則表達式判斷網址 URL 格式是否正確;
                response_Location = response.headers["location"]; // 獲取響應頭中的重定向"location"參數值 response.headers["location"];
                // console.log("response Headers location: " + response.headers["location"]);
            };

            // 讀出響應頭中 www-authenticate 參數值;
            let response_wwwauthenticate = ""
            if (typeof (response.headers["www-authenticate"]) !== undefined && response.headers["www-authenticate"] !== undefined && response.headers["www-authenticate"] !== null && response.headers["www-authenticate"] !== NaN && response.headers["www-authenticate"] !== "") {
                response_wwwauthenticate = response.headers["www-authenticate"]; // 'www-authenticate': 'Basic realm="domain name -> username:password"'  獲取響應頭中的"www-authenticate"參數值 response.headers["www-authenticate"];
                // console.log("response Headers www-authenticate: " + response.headers["www-authenticate"]);
                let wwwauthenticate_Value = "";
                if (response_wwwauthenticate.indexOf("Basic realm=", 0) !== -1) {
                    // response.headers["www-authenticate"].charAt(response.headers["www-authenticate"].indexOf("Basic realm=", 0));
                    // let request_Key = response_wwwauthenticate.split("Basic realm=")[0].split(" -> ")[1];
                    wwwauthenticate_Value = eval(response_wwwauthenticate.split("Basic realm=")[1]);  // 'www-authenticate': 'Basic realm="domain name -> username:password"';
                    wwwauthenticate_Value = wwwauthenticate_Value.split(" -> ")[1];  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    // request_Auth = wwwauthenticate_Value;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options["auth"] = wwwauthenticate_Value;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // request_Authorization_Base64 = new Base64().encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options.headers["Authorization"] = new Base64().encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                } else {
                    wwwauthenticate_Value = response_wwwauthenticate;
                    wwwauthenticate_Value = wwwauthenticate_Value.split(" -> ")[1];  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    // request_Auth = wwwauthenticate_Value;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options["auth"] = wwwauthenticate_Value;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // request_Authorization_Base64 = new Base64().encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options.headers["Authorization"] = new Base64().encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                };
                // console.log(wwwauthenticate_Value);  // 'www-authenticate': 'Basic realm="domain name -> username:password"';
            };


            // 持續接收從服務器返回的響應躰數據流中的資料，然後拼接;
            let response_Buffer_Array = new Array;
            response.on('data', function (chunk) {
                response_Buffer_Array.push(chunk);
            });

            // 從服務器返回的數據流中的響應躰資料接收完畢，讀取數據，控制臺打印出來;
            response.on('end', function () {
                // console.log(typeof (response_Buffer));
                // console.log(response_Buffer);
                // console.log(isStringJSON(response_Buffer));
                // console.log(JSON.parse(response_Buffer));

                if (!response.complete) {
                    console.error("服務器響應消息仍在發送時，中止了鏈接.");
                };

                let response_Buffer = response_Buffer_Array.join("");

                // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
                // let response_body = {};
                // if (isStringJSON(response_Buffer)) {
                //     response_body = JSON.parse(response_Buffer);
                // } else {
                //     response_body = {
                //         "Server_Authorization": "",  // "username:password";
                //         "Server_say": response_Buffer
                //     };
                // };
                // // console.log("Server say: " + response_body["Server_say"]);
                // // console.log("Server say request Authorization: [ " + response_body["request_Authorization"] + " ].");

                // if (callback !== undefined) {
                //     if (typeof (response_Buffer) !== undefined && response_Buffer !== undefined && response_Buffer !== null && response_Buffer !== NaN) {
                //         callback(null, [response_statusCode, response_headers, response_Buffer]);
                //     } else {
                //         callback(response.statusCode.toString().concat(" ", response.statusMessage.toString()), null);
                //     };
                // };

                // 處理響應頭中的要求身份驗證的情況，響應狀態碼為 401 表示無權訪問需要身份驗證;
                if (response_statusCode === "401") {

                    console.log("服務器返回響應狀態碼「401」要求身份驗證.");
                    let Key = "";  // 用戶名：密碼;

                    // // 讀出響應頭中 www-authenticate 參數值;
                    // if (typeof (response.headers["www-authenticate"]) !== undefined && response.headers["www-authenticate"] !== undefined && response.headers["www-authenticate"] !== null && response.headers["www-authenticate"] !== NaN && response.headers["www-authenticate"] !== "") {
                    //     // response_wwwauthenticate = response.headers["www-authenticate"]; // 'www-authenticate': 'Basic realm="domain name -> username:password"'  獲取響應頭中的"www-authenticate"參數值 response.headers["www-authenticate"];
                    //     // console.log("response Headers www-authenticate: " + response.headers["www-authenticate"]);
                    //     let wwwauthenticate_Value = "";
                    //     if (response_wwwauthenticate.indexOf("Basic realm=", 0) !== -1) {
                    //         // response.headers["www-authenticate"].charAt(response.headers["www-authenticate"].indexOf("Basic realm=", 0));
                    //         // let request_Key = response_wwwauthenticate.split("Basic realm=")[0].split(" -> ")[1];
                    //         wwwauthenticate_Value = eval(response_wwwauthenticate.split("Basic realm=")[1]);  // 'www-authenticate': 'Basic realm="domain name -> username:password"';
                    //         Key = wwwauthenticate_Value.split(" -> ")[1];  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    //         // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    //         // request_Auth = Key;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         options["auth"] = Key;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // request_Authorization_Base64 = new Base64().encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // options.headers["Authorization"] = new Base64().encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    //     } else {
                    //         wwwauthenticate_Value = response_wwwauthenticate;
                    //         Key = wwwauthenticate_Value.split(" -> ")[1];  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    //         // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    //         // request_Auth = Key;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         options["auth"] = Key;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // request_Authorization_Base64 = new Base64().encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // options.headers["Authorization"] = new Base64().encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //     };
                    //     // console.log(wwwauthenticate_Value);  // 'www-authenticate': 'Basic realm="domain name -> username:password"';
                    //     // console.log(Key);  // 'www-authenticate': 'Basic realm="domain name -> username:password"';
                    // };
                    // // 從響應躰數據中讀出，服務器給的請求身份賬號和密碼值，配置 request.headers["Authorization"]，和請求Cookie值 request.headers["Cookie"];
                    // if (response_body !== null && response_body !== NaN) {
                    //     // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    //     Key = response_body["Server_Authorization"];  // .split(";")[0].split("=")[1];
                    //     // request_Auth = Key;
                    //     options["auth"] = Key;
                    //     // request_Authorization_Base64 = "Basic ".concat(new Base64().encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                    //     // options.headers["Authorization"] = "Basic ".concat(new Base64().encode(Key));
                    //     // console.log("Python say require Authorization: " + response_body["Server_Authorization"]);
                    //     // console.log(request_Auth);
                    //     // console.log(options["auth"]);
                    // };
                    // // 從響應頭的 Cookie 參數值中讀出，服務器給的請求身份賬號和密碼值，配置 request.headers["Authorization"]，和請求Cookie值 request.headers["Cookie"];
                    // if (response_Cookies !== "") {
                    //     // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;

                    //     let cookieName = "";
                    //     if (response_Cookies[0].indexOf(";", 0) !== -1) {
                    //         // response.headers["set-cookie"].charAt(response.headers["set-cookie"].indexOf(";", 0));
                    //         // let request_Key = response_Cookies[0].split(";")[0].split(",")[1]; 
                    //         // let session_id = response_Cookies[0].split(";")[0].split(",")[0];

                    //         // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    //         // request_Cookie = response_Cookies[0].split(";")[0];  // 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
                    //         options.headers["Cookie"] = response_Cookies[0].split(";")[0];  // 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;

                    //         if (response_Cookies[0].split(";")[0].indexOf("=", 0) !== -1) {
                    //             cookieName = response_Cookies[0].split(";")[0].split("=")[0].concat("=", new Base64().decode(response_Cookies[0].split(";")[0].split("=")[1]));
                    //         } else {
                    //             cookieName = new Base64().decode(response_Cookies[0].split(";")[0]);
                    //         };
                    //     } else {
                    //         // request_Cookie = response_Cookies[0];
                    //         options.headers["Cookie"] = response_Cookies[0];

                    //         if (response_Cookies[0].indexOf("=", 0) !== -1) {
                    //             cookieName = response_Cookies[0].split("=")[0].concat("=", new Base64().decode(response_Cookies[0].split("=")[1]));
                    //         } else {
                    //             cookieName = new Base64().decode(response_Cookies[0]);
                    //         };
                    //     };
                    //     // console.log(cookieName);  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));

                    //     Key = cookieName.split("=")[1].split("->")[1];
                    //     // request_Auth = Key;
                    //     options["auth"] = Key;
                    //     // request_Authorization_Base64 = "Basic ".concat(new Base64().encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                    //     options.headers["Authorization"] = "Basic ".concat(new Base64().encode(Key));
                    //     // console.log("response Headers Cookie: " + response_Cookies);
                    //     // console.log("response Headers Cookie say request Authorization: " + cookieName.split("=")[1].split("->")[1]);
                    // };

                    // // options["auth"] = Key;  // "username:password";
                    // // options.headers["Authorization"] = "Basic ".concat(new Base64().encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                    // // 重新向服務端發送請求;
                    // return start_Client({
                    //     "options": options,
                    //     "post_Data_String": post_Data_String
                    // }, (error, resData) => {
                    //     if (callback !== undefined) { callback(error, resData); };
                    //     // if (error) {
                    //     //     console.error(error);
                    //     // };
                    //     // if (resData) {
                    //     //     console.log("Server say: " + resData["Server_say"]);
                    //     // };
                    // });

                    // 從控制臺中逐行讀取從鍵盤輸入的賬號和密碼;
                    const rl = readline.createInterface({
                        output: process.stdout,
                        input: process.stdin
                    });

                    rl.on('SIGINT', () => {
                        // rl.question("確定要退出嗎 ? ", (answer) => {
                        //     if (answer.match(/^y(es)?$/i)) {
                        //         console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");
                        //         // rl.pause();
                        //         // rl.resume();
                        //         rl.close();
                        //     };
                        // });
                        console.log("\n[ Ctrl ] + [ c ] received, shutting down the web client.");
                        rl.close();
                    });

                    rl.on('close', function () {
                        // console.log('bye bye!');
                        // process.exit(0);             
                    });

                    rl.question("「 nikename:password 」 -> ", (lineInput) => {
                        // TODO：将答案记录在数据库中。
                        Key = lineInput.toString();  // "username:password";
                        // console.log("輸入的 「 昵稱 : 密碼 」 -> 「 " + lineInput + " 」.");

                        rl.close();

                        options["auth"] = Key;  // "username:password";
                        // options.headers["Authorization"] = "Basic ".concat(new Base64().encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                        // 重新向服務端發送請求;
                        return start_Client({
                            "options": options,
                            "post_Data_String": post_Data_String
                        }, (error, resData) => {
                            if (callback !== undefined) { callback(error, resData); };
                            // if (error) {
                            //     console.error(error);
                            // };
                            // if (resData) {
                            //     console.log("Server say: " + resData["Server_say"]);
                            // };
                        });
                    });

                    // rl.setPrompt("「 nikename:password 」 -> ");
                    // rl.prompt();
                    // rl.on('line', (lineInput) => {
                    //     Key = lineInput.toString();  // "username:password";
                    // //     console.log("輸入的 「 昵稱 : 密碼 」 -> 「 " + lineInput + " 」.");

                    //     rl.close();

                    //     options["auth"] = Key;  // "username:password";
                    //     // options.headers["Authorization"] = "Basic ".concat(new Base64().encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                    //     // 重新向服務端發送請求;
                    //     return start_Client({ "options": options, "post_Data_String": post_Data_String, "Response_Action": Response_Action });
                    // });
                };

                // 處理響應頭中要求重定向的情況，響應狀態碼為 301 表示永久重定向、303 表示臨時重定向，將原POST請求重定向新URL的GET請求、307 表示臨時重定向;
                if (response_statusCode === "301" || response_statusCode === "307") {

                    if (response_Location !== "") {

                        // 配置請求網址 URL 值 request.url / options["path"];
                        // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                        // // Host = response_Location;  // "localhost";
                        // options["host"] = response_Location;  // "localhost";
                        // // Port = response_Location;  // "8000";
                        // options["port"] = response_Location;  // "8000"
                        // // URL = response_Location;  // "/";
                        options["path"] = response_Location;  // "/";
                        options["method"] = "POST";

                        // 重新向服務端發送請求
                        return start_Client({ "options": options, "post_Data_String": post_Data_String });

                    } else {
                        console.error('response.headers["location"] Error: ' + response.headers["location"]);  // 響應頭中的重定向參數網址值錯誤 response.headers["location"];
                    };
                };
                if (response_statusCode === "302" || response_statusCode === "303") {

                    if (response_Location !== "") {

                        // 配置請求網址 URL 值 request.url / options["path"];
                        // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                        // // Host = response_Location;  // "localhost";
                        // options["host"] = response_Location;  // "localhost";
                        // // Port = response_Location;  // "8000";
                        // options["port"] = response_Location;  // "8000"
                        // // URL = response_Location;  // "/";
                        options["path"] = response_Location;  // "/";
                        options["method"] = "GET";

                        // 重新向服務端發送請求
                        return start_Client({ "options": options, "post_Data_String": post_Data_String });

                    } else {
                        console.error('response.headers["location"] Error: ' + response.headers["location"]);  // 響應頭中的重定向參數網址值錯誤 response.headers["location"];
                    };
                };

                // 處理請求成功，與服務器鏈接一切正常的情況下的動作，響應狀態碼為 200 表示請求成功;
                if (response_statusCode === "200") {
                    //  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    // 在這裏編寫需要的應用，response_Buffer 是服務器返回的響應躰原始數據，response_body 是原始數據經過 JSON.parse(response_Buffer) 轉化之後的 JSON 對象數據：

                    // console.log(typeof (response_Buffer));
                    // console.log(response_Buffer);
                    // console.log(typeof (response_body));
                    // console.log(response_body);


                    // console.log("Client say: " + argument.replace(new RegExp("_", "g"), " "));
                    // console.log("Server say: " + response_body["Server_say"]);
                    // console.log("Server say request Authorization: [ " + response_body["request_Authorization"] + " ].");
                    // callback(null, response_body["Server_say"]);

                    if (callback !== undefined) {
                        if (typeof (response_Buffer) !== undefined && response_Buffer !== undefined && response_Buffer !== null && response_Buffer !== NaN) {
                            callback(null, [response_statusCode, response_headers, response_Buffer]);
                        } else {
                            callback(response.statusCode.toString().concat(" ", response.statusMessage.toString()), null);
                        };
                    };

                    // response_body = {
                    //     "request Nikename": request_Nikename,
                    //     "request Passwork": request_Password,
                    //     "request_Authorization": Key,
                    //     "Server_say": "",
                    //     "time": "2021-02-03 20:21:25.136"
                    // };

                    //  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
                };

            });
        });

        request.on('error', (error) => {
            // if (error.code === "ECONNRESET") {
            //     console.log("Python Server say: 對暗號啊，沒暗號要花錢買啊 ! 想吃白食啊 ？ 耍小聰明招人煩啊 !");
            // };
            console.error("request Error: " + error.message); // "socket hang up";
        });

        if (options["method"].toUpperCase() === "POST" && post_Data_String !== undefined && post_Data_String !== null && post_Data_String !== NaN && post_Data_String !== "") {
            request.write(post_Data_String); // 將 post 請求携帶的參數數據寫入請求體（request.body）;
        };

        request.end("", "utf8", () => {
            // if (!request.complete) {
            //     console.error("服務器響應消息仍在發送時，中止了鏈接.");
            // };
        });

        return request;
    };

    start_Client({
        "options": options,
        "post_Data_String": post_Data_String,
    }, (error, resData) => {
        if (callback !== undefined) { callback(error, resData); };
        // if (error) {
        //     console.error(error);
        // };
        // if (resData) {
        //     console.log("Server say: " + resData["Server_say"]);
        // };
    });
};
module.exports.http_Client = http_Client; // 使用「module.exports」接口對象，用來導出模塊中的成員;


// // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const qs = require('querystring');
// // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// // 這裏是需要向Python服務器發送的參數數據JSON對象;
// // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // let nowDate = new Date();
// // let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
// let argument = "How_are_you_!";
// let post_Data_JSON = {
//     "Client_say": argument.replace(new RegExp("\\_", "g"), " "),
//     "time": String(now_date)
// };
// let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;

// let Host = "localhost";
// let Port = "8000";
// let URL = "/"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let Method = "POST";  // "GET"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = ""; // "username:password";
// let request_Cookie = ""; // "Session_ID=request_Key->username:password";
// request_Cookie = request_Cookie.split("=")[0].concat("=", new Base64().encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));

// // console.log(String(now_date) + " " + "http://" + Host + ":" + Port + URL + " " + options["method"] + " @" + request_Auth + " " + request_Cookie);
// console.log("Client say: " + argument.replace(new RegExp("_", "g"), " "));

// http_Client({
//     "Host": Host,
//     "Port": Port,
//     "URL": URL,
//     "Method": Method,
//     "time_out": time_out,
//     "request_Auth": request_Auth,
//     "request_Cookie": request_Cookie,
//     "post_Data_String": post_Data_String
// }, (error, response) => {
//     console.log(response);

//     // let response_status_String = response[0];
//     // console.log(response_status_String);
//     // let response_head_String = response[1];
//     // console.log(response_head_String);

//     // let response_body_String = response[2];
//     // console.log(response_body_String);
//     // // // response_body_String = {
//     // // //     "request Nikename": request_Nikename,
//     // // //     "request Passwork": request_Password,
//     // // //     "request_Authorization": Key,  // "username:password";
//     // // //     "Server_say": "Fine, thank you, and you ?",
//     // // //     "time": "2021-02-03 20:21:25.136"
//     // // // };

//     // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
//     // let data_JSON = {};
//     // if (isStringJSON(response_body_String)) {
//     //     data_JSON = JSON.parse(response_body_String);
//     // } else {
//     //     data_JSON = {
//     //         "Server_say": response_body_String
//     //     };
//     // };

//     // console.log("Server say: " + data_JSON["Server_say"]);
// });


// function http_Client_Sync(Host, Port, URL, request_Auth, request_Cookie, post_Data_JSON) {
//     // ;
// };
// module.exports.http_Client_Sync = http_Client_Sync; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// process.exit(0); // 停止運行，退出 Node.js 解釋器;
