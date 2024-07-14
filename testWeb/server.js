
const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(urlString, true), url.format(urlObject);
const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組 path.parse(pathString), path.format(pathObject), path.join([path1][, path2][, ...]);

let host = "::0";  // "::0" or "::1" or "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
let port = 8000;  // 1 ~ 65535 監聽端口;
// let webPath = "C:/Criss/Chrome_Extension/Automatic/strategies/test/testWeb/";  // 定義一個網站保存路徑變量;
let webPath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;

// 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// console.log(typeof(process.argv));
// console.log(process.argv);
// 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
if (process.argv.length > 2) {
    for (let i = 0; i < process.argv.length; i++) {
        console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
        if (i > 1) {
            // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
            if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
                // if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
                //     eval('var ' + process.argv[i].split("=")[0] + ' = "";');
                // } else {
                //     try {
                //         if (isStringJSON(process.argv[i].split('=')[1])) {
                //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
                //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
                //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
                //         } else {
                //             eval(process.argv[i] + ";");
                //             // // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
                //             // eval(process.argv[i].split("=")[0] = process.argv[i].split('=')[1]);
                //         };
                //         console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
                //     } catch (error) {
                //         console.log("Don't recognize argument [ " + process.argv[i] + " ].");
                //         console.log(error);
                //     };
                // };
                // // let argvArr = process.argv[i].split('--'); // 將控制臺輸入的參數字符串轉化成數組類型，使用'--'間隔每個參數作爲數組的一個元素「--port=3000」;
                // // console.log(argvArr);
                // // for (let i = 1, i < argvArr.length, i++ ) {
                // //    eval(argvArr[i]); // 運行每個輸入的字符串類型的參數賦值語句，詳情查詢 eval() 動態定義變量函數;
                // // };
                if (String(process.argv[i].split("=")[0]) === "port") {
                    port = parseInt(process.argv[i].split("=")[1]);
                };
                if (String(process.argv[i].split("=")[0]) === "host") {
                    host = String(process.argv[i].split("=")[1]);
                };
                if (String(process.argv[i].split("=")[0]) === "webPath") {
                    webPath = String(process.argv[i].split("=")[1]);
                };
            };
        };
    };
};

function do_GET_root_directory(request_url) {

    // Check the file extension required and set the right mime type;
    // try {
    //     fs.readFileSync();
    //     fs.writeFileSync();
    // } catch (error) {
    //     console.log("硬盤文件打開或讀取錯誤.");
    // } finally {
    //     fs.close();
    // };

    // console.log(request_url);
    let request_url_JSON = url.parse(request_url, true);
    // console.log(request_url_JSON);
    let request_url_path = String(request_url_JSON["path"]);
    // console.log(request_url_path);
    if (request_url_path === "/") {
        request_url_path = "/index.html";
    };
    // console.log(request_url_path);
    // console.log(webPath);
    let web_path = String(path.join(webPath, request_url_path));
    // console.log(web_path);

    // try {
    //     // 異步寫入硬盤文檔;
    //     fs.writeFile(
    //         web_path,
    //         data,
    //         function (error) {
    //             if (error) { return console.error(error); };
    //         }
    //     );
    //     // 同步讀取硬盤文檔;
    //     // fs.writeFileSync(web_path, data);
    // } catch (error) {
    //     console.log(`硬盤文檔 ( ${web_path} ) 打開或寫入錯誤.`);
    // } finally {
    //     fs.close();
    // };

    let response_body_String = "";
    let file_data = null;
    try {

        // // 異步讀取硬盤文檔;
        // fs.readFile(
        //     web_path,
        //     function (error, data) {
        //         if (error) { return console.error(error); };
        //         console.log("異步讀取文檔: " + data.toString());
        //     }
        // );

        // 同步讀取硬盤文檔;
        file_data = fs.readFileSync(web_path);
        // console.log("同步讀取文檔: " + file_data.toString());
        response_body_String = file_data.toString();
        // console.log(response_body_String);

    } catch (error) {
        console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
    } finally {
        // fs.close();
    };

    // // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    // let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    // let response_data_JSON = {
    //     "Server_say": "Server_say",
    //     "time": String(now_date),
    //     "request_url": request_url
    //     // "request_Authorization": request_data_JSON["request_Authorization"],  // "username:password";
    // };
    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);

    return response_body_String;
};

function do_Server(request, response) {

    let response_body_String = do_GET_root_directory(request.url);
    let response_Body_String_len = Buffer.byteLength(response_body_String, "utf8");
    response.setHeader("Content-Length", response_Body_String_len);

    let Content_Type = "text/html; charset=UTF-8";
    response.setHeader('Content-Type', Content_Type);

    // response.setHeader("Set-Cookie", cookie_string);  // 設置 Cookie;
    // response.setHeader('WWW-Authenticate', 'Basic realm=\"domain name -> username:password\"');  // 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;

    response.writeHead(200, "OK");

    response.write(response_body_String, "utf8", function () {});

    response.end("", "utf8", () => {});

    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();

    console.log(String(now_date) + " " + String(request.url) + " " + String(request.method) + " " + String(request.connection.remoteAddress));

    return 1;
};

const server = http.createServer({
    IncomingMessage: http.IncomingMessage,
    ServerResponse: http.ServerResponse,
    insecureHTTPParser: false,
    maxHeaderSize: 16384
}, function (request, response) {
    do_Server(request, response);
});

// 監聽 'SIGINT' 信號，當 Node.js 進程接收到 'SIGINT' 信號時，會觸發該事件;
// 'SIGHUP' 信號在 Windows 平臺上當控制臺使用鍵盤輸入 [ Ctrl ] + [ c ] 窗口被關閉時會被觸發，在其它平臺上在相似的條件下也會被觸發;
process.on('SIGINT', function () {

    // 監聽 'SIGINT' 信號事件，使用鍵盤輸入 [ Ctrl ] + [ c ] 中止進程運行，不會激活 'beforeExit' 事件，而直接激活 'exit' 事件;
    console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");  // "Master process-" + process.pid + " Master thread-" + require('worker_threads').threadId

    // 關閉服務器主進程;
    if (server) {
        server.close(function () {
            // console.log("[ Ctrl ] + [ c ] received, shutting down the web server.");
        });
    };

    // 注意當注冊了監聽 'SIGINT' 信號事件時，使用鍵盤輸入 [ Ctrl ] + [ c ] 不會自動中止進程，需要手動調用 process.exit([code]) 方法來中止進程;
    process.exit(1);
});

server.on('close', () => {
    console.log("Web server stopped.");
});

server.listen({
    host: host, // "0.0.0.0" or "127.0.0.1" or "localhost";
    port: port, // 1 ~ 65535;
    exclusive: false,
    backlog: 511,
    readableAll: false,
    writableAll: false,
    ipv6Only: false
}, function (){
    console.log(`server running at http://${host}:${port}`);
    console.log(`web root directory at ${webPath}`);
    console.log("Keyboard Enter [ Ctrl ] + [ c ] to close.");
    console.log("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.");
});
