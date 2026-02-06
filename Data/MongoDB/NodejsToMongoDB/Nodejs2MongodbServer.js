'use strict'

// https://github.com/mongodb/node-mongodb-native 數據庫操作第三方包「mongodb」官網;
// https://mongoosejs.com/ 數據庫操作第三方包「mongoose」官網;
// https://www.mongodb.com/download-center/community 官網下載地址mongodb數據庫服務器軟件;
// https://www.npmjs.com/package/mongoose 數據庫擴展包mongoose説明;
// https://github.com/Automattic/mongoose
// https://mongoosejs.com/docs/schematypes.html#objectids
// https://github.com/mongodb/node-mongodb-native
// https://docs.mongodb.com/manual/tutorial/getting-started/
// https://github.com/mongodb
// https://github.com/mongodb/mongo
// https://www.w3cschool.cn/mongodb/ MongoDB數據庫使用 W3C 網教程;
// https://www.runoob.com/mongodb/mongodb-tutorial.html MongoDB數據庫使用菜鳥網教程;
// https://www.runoob.com/nodejs/nodejs-mongodb.html
// https://www.mongodb.com/docs/drivers/node/current/quick-start/

// 需要事先在控制臺命令行安裝第三方擴展包;
// root@localhost:~# npm install mongodb --registry=https://registry.npm.taobao.org
// root@localhost:~# npm install mongoose --registry=https://registry.npm.taobao.org

// 載入node原生API
// const child_process = require('child_process');  // Node原生的創建子進程模組;
// const os = require('os');  // Node原生的操作系統信息模組;
// const net = require('net');  // Node原生的網卡網絡操作模組;
const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// const qs = require('querystring');
const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(urlString, true), url.format(urlObject);
// const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組 path.parse(pathString), path.format(pathObject), path.join([path1][, path2][, ...]);
const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
const cluster = require('cluster');  // Node原生的支持多進程模組;
// const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
// const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;

// 載入第三方擴展包（需要先在Windows控制臺（CMD），使用「npm install」方法安裝成功，才能引入使用）
// const IP = require('ip'); //引用第三方擴展包（package）「ip」用於查看本地 IP 地址，第三方模塊「ip」需要先「npm install ip@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const EXPRESS = require('express'); //引用第三方擴展包「express」，express是一個快速 Web 框架（web framework）用於搭建服務器，需要先「npm install express@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const HTTP_SERVER = EXPRESS(); // 使用 EXPRESS() 框架方法創建一個http監聽服務器，並返回一個 Server 實例化
// const express_BodyParser = require('body-parser') //引用第三方擴展包「express」的中間件（middleware）「body-parser」用於獲取客戶端瀏覽器post請求發送的數據，需要先「npm install body-parser@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
// const express_CookieParser = require('cookie-parser') //引用第三方擴展包「express」的中間件（middleware）「cookie-parser」用於保存用戶端登陸狀態用於操作Cookie，需要先「npm install cookie-parser@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
// const express_Session = require('express-session') //引用第三方擴展包「express」的中間件（middleware）「express-session」用於保存用戶端登陸狀態操作Session，需要先「npm install express-session@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
// const express_Session_RedisStore = require('connect-redis')(express_Session) //引用第三方擴展包「express-session」的中間件（middleware）「connect-redis」用於將用戶端登陸狀態的Session數據存入内存數據庫Redis，目的是做持久化保存，機器重啓也不會丟失Session數據，需要先「npm install connect-redis@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
// const express_Session_FileStore = require('session-file-store')(express_Session) //引用第三方擴展包「express-session」的中間件（middleware）「session-file-store」用於將用戶端登陸狀態的Session數據存入硬盤txt文件，目的是做持久化保存，機器重啓也不會丟失Session數據，需要先「npm install session-file-store@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
// const express_Session_MongoStore = require('connect-mongo')(session) //引用第三方擴展包「express-session」的中間件（middleware）「connect-mongo」用於將用戶端登陸狀態的Session數據存入硬盤txt文件，目的是做持久化保存，機器重啓也不會丟失Session數據，需要先「npm install connect-mongo@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
// const ArtTemplate = require('art-template'); //引用第三方擴展包「art-template」，art-template是一個模板引擎（Template Engine）用於渲染網頁代碼，需要先「npm install art-template@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const express_ArtTemplate = require('express-art-template'); //引用第三方擴展包「express-art-template」用於在Web框架express中使用art-template模板渲染網頁，需要先「npm install express-art-template@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功，並配置好之後才能使用;
const mongodb = require('mongodb'); //引用第三方擴展包「mongodb」用於與mongodb數據庫服務器通信進行數據操作，需要先「npm install mongodb@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const mongoose = require('mongoose'); //引用第三方擴展包「mongoose」用於與mongodb數據庫服務器通信進行數據操作，需要先「npm install mongoose@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const redis = require('redis'); //引用第三方擴展包「redis」用於與操作内存數據庫服務器redis，需要先「npm install redis@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const mysql = require('mysql'); //引用第三方擴展包「mysql」用於與mysql數據庫服務器通信進行數據操作，需要先「npm install mysql@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const superagent = require('superagent'); //引用第三方擴展包「superagent」，這是一個輕量的、漸進式的第三方客戶端請求代理模塊，用於編寫網絡爬蟲，需要先「npm install superagent@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const cheerio = require('cheerio'); //引用第三方擴展包「cheerio」，cheerio相當於node版的jQuery，用來獲取服務器返回的響應頁面中的元素和數據信息，需要先「npm install cheerio@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const MD5 = require('blueimp-md5') // 引入賬號傳輸加密算法包md5，需要先「npm install blueimp-md5@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;
// const XLSX = require('xlsx'); // 第三方包xlsx用於讀寫操作Excel，需要先「npm install xlsx@version --prefix=./node_modules --registry=https://registry.npm.taobao.org/」安裝成功才能使用;

// console.log(`${OS.platform()},${OS.hostname()},${IP.address()}`); //查看服務器系統信息用於調試;

// 創建 web server 服務器接收到客戶端請求時的具體響應操作;
function do_Request_Router(
    request_url,
    request_POST_String,
    request_headers,
    callback
){

    let response_body_String = "";
    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    let response_data_JSON = {
        "time": String(now_date),
        "request_url": request_url,
        "request_POST": request_POST_String,
        // "request_Authorization": request_headers["authorization"],  // "username:password";
        // "request_Cookie": request_headers["cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
        "Server_Authorization": Key,  // "username:password";
        "Database_say": "",
    };
    // console.log(request_headers);
    if (typeof (request_headers) === 'object' && Object.prototype.toString.call(request_headers).toLowerCase() === '[object object]' && !(request_headers.length)) {
        if (request_headers.hasOwnProperty("authorization")) {
            response_data_JSON["request_Authorization"] = base64.decode(String(request_headers["authorization"]).split(" ")[1]);  // "username:password";
            // console.log(response_data_JSON["request_Authorization"]);
        };
        if (request_headers.hasOwnProperty("cookie")) {
            response_data_JSON["request_Cookie"] = request_headers["cookie"];  // String(request_headers["cookie"]).split("=")[0].concat("=", base64.decode(String(request_headers["cookie"]).split("=")[1]));  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
            // console.log(response_data_JSON["request_Cookie"]);
        };
    };
    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    // String = JSON.stringify(JSON); JSON = JSON.parse(String);

    // console.log(request_POST_String);
    let request_POST_JSON = {};
    // // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
    // // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
    //     try {
    //         if (request_POST_String !== "") {
    //             request_POST_JSON = JSON.parse(request_POST_String, true);
    //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    //         };
    //     } catch (error) {
    //         console.error(error);
    //         response_data_JSON["Database_say"] = String(error);
    //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    //         if (callback) { callback(response_body_String, null); };
    //         return response_body_String;
    //     } finally {};
    //     // console.log(request_POST_JSON);
    // // };

    // console.log(request_url);
    // let request_url_JSON = url.parse(request_url, true);
    const request_url_JSON = new URL(request_url, `http://${request_headers["host"]}`);  // http://127.0.0.1:8000
    // console.log(request_url_JSON);
    const url_search_JSON = new URLSearchParams(request_url_JSON.search);
    // console.log(url_search_JSON);
    const request_url_path = String(request_url_JSON.pathname);
    // console.log(request_url_path);
    // console.log(webPath);
    let web_path = String(path.join(webPath, request_url_path));
    // console.log(web_path);

    // // try {
    // //     // 異步寫入硬盤文檔;
    // //     fs.writeFile(
    // //         web_path,
    // //         data,
    // //         function (error) {
    // //             if (error) { return console.error(error); };
    // //         }
    // //     );
    // //     // 同步讀取硬盤文檔;
    // //     // fs.writeFileSync(web_path, data);
    // // } catch (error) {
    // //     console.log("硬盤文檔打開或寫入錯誤.");
    // // } finally {
    // //     fs.close();
    // // };

    let file_data = null;
    // try {
    //     // // 異步讀取硬盤文檔;
    //     // fs.readFile(
    //     //     web_path,
    //     //     function (error, data) {
    //     //         if (error) {
    //     //             console.error(error);
    //     //             response_body_String = String(error);
    //     //             if (callback) { callback(response_body_String, null); };
    //     //         };
    //     //         if (data) {
    //     //             // console.log("異步讀取文檔: " + data.toString());
    //     //             file_data = data;
    //     //             response_body_String = file_data.toString();
    //     //             // console.log(response_body_String);
    //     //             if (callback) { callback(null, response_body_String); };
    //     //         };
    //     //     }
    //     // );
    //     // 同步讀取硬盤文檔;
    //     file_data = fs.readFileSync(web_path);
    //     // console.log("同步讀取文檔: " + file_data.toString());
    //     response_body_String = file_data.toString();
    //     // console.log(response_body_String);
    //     if (callback) { callback(null, response_body_String); };
    //     return response_body_String;
    // } catch (error) {
    //     console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
    //     response_body_String = String(error);
    //     if (callback) { callback(response_body_String, null); };
    //     return response_body_String;
    // } finally {
    //     // fs.close();
    // };

    let fileName = "";
    if (url_search_JSON.has("fileName")) {
        fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
    };

    if (url_search_JSON.has("Key")) {
        Key = String(url_search_JSON.get("Key"));  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    };
    if (url_search_JSON.has("dbUser")) {
        dbUser = String(url_search_JSON.get("dbUser"));  // 'admin_test20220703'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    };
    if (url_search_JSON.has("dbPass")) {
        dbPass = String(url_search_JSON.get("dbPass"));  // 'admin'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    };
    // UserPass = dbUser.concat(":", dbPass);  // 'admin_test20220703:admin';  // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    if (url_search_JSON.has("dbName")) {
        dbName = String(url_search_JSON.get("dbName"));  // 'testWebData'; // ['admin', 'testWebData'];  // 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，Mongodb 要求數據庫名稱首字母必須為大寫單數;
    };
    if (url_search_JSON.has("dbTableName")) {
        dbTableName = String(url_search_JSON.get("dbTableName"));  // 'test20220703'; // ['test20220703'];  // MongoDB 數據庫包含的數據集合（表格）;
    };

    switch (request_url_path) {

        case "/": {

            web_path = String(path.join(webPath, "/index.html"));
            file_data = null;

            try {

                // // 同步讀取硬盤文檔;
                // file_data = fs.readFileSync(web_path);
                // // console.log("同步讀取文檔: " + file_data.toString());
                // let filesName = fs.readdirSync(webPath);
                // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                // filesName.forEach(
                //     function (item) {
                //         // console.log("異步讀取文件夾目錄: " + item.toString());
                //         let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                //         if (statsObj.isFile()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                //         } else if (statsObj.isDirectory()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                //         } else {};
                //     }
                // );
                // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                // // console.log(response_body_String);
                // // return response_body_String;

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            file_data = data;
                            // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                            fs.readdir(
                                webPath,
                                function (error, filesName) {

                                    if (error) {
                                        console.error(error);
                                        response_data_JSON["Database_say"] = String(error);
                                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                        if (callback) { callback(response_body_String, null); };
                                        // return response_body_String;
                                    };

                                    if (filesName) {
                                        let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                        // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                        filesName.forEach(
                                            function (item) {
                                                // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(request_url_path, item.toString())), search: String("fileName=" + url.resolve(request_url_path, item.toString()) + "&Key=" + Key), hash: ""}));
                                                let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(request_url_path, item.toString())), search: String("fileName=" + url.resolve(request_url_path, item.toString()) + "&Key=" + Key), hash: ""}));
                                                let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(request_url_path, item.toString()) + "&Key=" + Key), hash: ""}));
                                                let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                // console.log("異步讀取文件夾目錄: " + item.toString());
                                                let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                                                if (statsObj.isFile()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else if (statsObj.isDirectory()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else {};
                                            }
                                        );
                                        response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                        // console.log(response_body_String);
                                        if (callback) { callback(null, response_body_String); };
                                        // return response_body_String;
                                    };
                                }
                            );
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/index.html": {

            // web_path = String(path.join(webPath, "/index.html"));
            file_data = null;

            try {

                // // 同步讀取硬盤文檔;
                // file_data = fs.readFileSync(web_path);
                // // console.log("同步讀取文檔: " + file_data.toString());
                // let filesName = fs.readdirSync(webPath);
                // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                // filesName.forEach(
                //     function (item) {
                //         // console.log("異步讀取文件夾目錄: " + item.toString());
                //         let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                //         if (statsObj.isFile()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                //         } else if (statsObj.isDirectory()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                //         } else {};
                //     }
                // );
                // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                // // console.log(response_body_String);
                // // return response_body_String;

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            file_data = data;
                            // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                            fs.readdir(
                                webPath,
                                function (error, filesName) {

                                    if (error) {
                                        console.error(error);
                                        response_data_JSON["Database_say"] = String(error);
                                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                        if (callback) { callback(response_body_String, null); };
                                        // return response_body_String;
                                    };

                                    if (filesName) {
                                        let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                        // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                        filesName.forEach(
                                            function (item) {
                                                // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                // console.log("異步讀取文件夾目錄: " + item.toString());
                                                let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                                                if (statsObj.isFile()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else if (statsObj.isDirectory()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else {};
                                            }
                                        );
                                        response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                        // console.log(response_body_String);
                                        if (callback) { callback(null, response_body_String); };
                                        // return response_body_String;
                                    };
                                }
                            );
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/uploadFile": {

            // fileName = "";
            // if (url_search_JSON.has("fileName")) {
            //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
            // };
            if (fileName === "" || fileName === null) {
                console.log("上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                return response_body_String;
            };

            web_path = String(path.join(webPath, fileName));
            file_data = request_POST_String;

            let file_data_Uint8Array_String = JSON.parse(file_data);  // JSON.stringify(file_data_Uint8Array);
            let file_data_Uint8Array = new Array();
            for (let i = 0; i < file_data_Uint8Array_String.length; i++) {
                if (Object.prototype.toString.call(file_data_Uint8Array_String[i]).toLowerCase() === '[object string]') {
                    // file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 2));  // 函數 parseInt("11100101", 2) 表示將二進制數字的字符串轉爲十進制的數字，例如 parseInt("11100101", 2) === 二進制的：11100101 也可以表示爲（0b11100101）=== 十進制的：229;
                    file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 10));  // 函數 parseInt("229", 10) 表示將十進制數字的字符串轉爲十進制的數字，例如 parseInt("229", 10) === 十進制的：229 === 二進制的：11100101 也可以表示爲（0b11100101）;
                } else {
                    file_data_Uint8Array.push(file_data_Uint8Array_String[i]);
                };
            };
            // let file_data_bytes = new Uint8Array(Buffer.from(file_data_String));  // 轉換為 Buffer 二進制對象;
            let file_data_bytes = Buffer.from(new Uint8Array(file_data_Uint8Array));  // 轉換為 Buffer 二進制對象;
            // let file_data_Buffer = Buffer.allocUnsafe(file_data_Uint8Array.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
            // let file_data_bytes = new Uint8Array(file_data_Buffer);  // 轉換為 Buffer 二進制對象;
            // for (let i = 0; i < file_data_Uint8Array.length; i++) {
            //     file_data_bytes[i] = file_data_Uint8Array[i];
            // };
            // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
            // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
            // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
            // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
            // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
            // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
            let file_data_len = file_data_Uint8Array.length;
            // let file_data_len = Buffer.byteLength(file_data);

            // let statsObj = fs.statSync(web_path, {bigint: false});
            // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
            if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
                // console.log("文檔路徑全名: " + web_path);
                // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
                // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
                // console.log("文檔操作權限值: " + String(statsObj.mode));

                // 同步判斷指定的目標文檔權限，當指定的目標文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + web_path + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
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
                        console.log("指定的待替換的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };
                };

                // 向指定的目標文檔同步寫入數據;
                // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                try {

                    // // console.log(file_data);
                    // // fs.writeFileSync(
                    // //     web_path,
                    // //     file_data,
                    // //     {
                    // //         encoding: "utf8",
                    // //         mode: 0o777,
                    // //         flag: "w+"
                    // //     }
                    // // );  // 返回值為 undefined;
                    // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    // fs.writeFileSync(
                    //     web_path,
                    //     file_data_bytes,
                    //     {
                    //         mode: 0o777,
                    //         flag: "w+"
                    //     }
                    // );  // 返回值為 undefined;
                    // // console.log(file_data_bytes);
                    // // // let buffer = new Buffer(8);
                    // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                    // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                    // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                    // // console.log(data_Str);
                    // // console.log("目標文檔: " + web_path + " 寫入成功.");
                    // // response_body_String = JSON.stringify(result);
                    // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // if (callback) { callback(null, response_body_String); };
                    // // return response_body_String;

                    fs.writeFile(
                        web_path,
                        file_data_bytes,  // file_data,
                        {
                            // encoding: "utf8",
                            mode: 0o777,
                            flag: "w+"
                        },
                        function (error) {

                            if (error) {

                                console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                                console.error(error);
                                response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;

                            } else {

                                // console.log("目標文檔: " + web_path + " 寫入成功.");
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } catch (error) {

                    console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                // 截取目標寫入目錄;
                let writeDirectory = "";
                if (fileName.indexOf("/") === -1) {
                    writeDirectory = "/";
                } else {
                    let tempArray = new Array();
                    tempArray = fileName.split("/");
                    if (tempArray.length <= 2) {
                        writeDirectory = "/";
                    } else {
                        for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
                            if (i === 0) {
                                writeDirectory = tempArray[i];
                            } else {
                                writeDirectory = writeDirectory + "/" + tempArray[i];
                            };
                        };
                    };
                };
                writeDirectory = String(path.join(webPath, writeDirectory));

                // 判斷目標寫入目錄是否存在，如果不存在則創建;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(writeDirectory)方法判斷指定的目標寫入目錄是否存在以及是否為文件夾;
                    if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
                        // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                        fs.mkdirSync(writeDirectory, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                        // console.log("目錄: " + writeDirectory + " 創建成功.");
                    };
                    // 判斷指定的目標寫入目錄是否創建成功;
                    if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
                        console.log("無法創建指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.");
                        response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.";
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        return response_body_String;
                    };
                } catch (error) {
                    console.log("無法創建或識別指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create or recognize the directory = { " + String(writeDirectory) + " }.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                };

                // 同步創建指定的目標文檔，並向文檔寫入數據;
                // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                try {

                    // // console.log(file_data);
                    // // fs.writeFileSync(
                    // //     web_path,
                    // //     file_data,
                    // //     {
                    // //         encoding: "utf8",
                    // //         mode: 0o777,
                    // //         flag: "w+"
                    // //     }
                    // // );  // 返回值為 undefined;
                    // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    // fs.writeFileSync(
                    //     web_path,
                    //     file_data_bytes,
                    //     {
                    //         mode: 0o777,
                    //         flag: "w+"
                    //     }
                    // );  // 返回值為 undefined;
                    // // console.log(web_path_bytes);
                    // // // let buffer = new Buffer(8);
                    // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                    // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                    // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                    // // console.log(data_Str);

                    fs.writeFile(
                        web_path,
                        file_data_bytes,  // file_data,
                        {
                            // encoding: "utf8",
                            mode: 0o777,
                            flag: "w+"
                        },
                        function (error) {

                            if (error) {

                                console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                                console.error(error);
                                response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;

                            } else {

                                // console.log("目標文檔: " + web_path + " 寫入成功.");
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } catch (error) {
                    console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };
            };

            return response_body_String;
        }

        case "/deleteFile": {

            // fileName = "";
            // if (url_search_JSON.has("fileName")) {
            //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待刪除的文件路徑全名;
            // };
            if (fileName === "" || fileName === null) {
                console.log("上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                return response_body_String;
            };

            if (fileName !== "" && fileName !== null) {

                web_path = String(path.join(webPath, fileName));
                file_data = request_POST_String;

                let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
                // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
                // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
                // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
                // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
                // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
                let file_data_len = Buffer.byteLength(file_data);

                // let statsObj = fs.statSync(web_path, {bigint: false});
                // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
                if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
                    // console.log("文檔路徑全名: " + web_path);
                    // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
                    // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
                    // console.log("文檔操作權限值: " + String(statsObj.mode));

                    // 同步判斷文檔權限，後面所有代碼都是，當指定的文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    try {
                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                        // console.log("文檔: " + web_path + " 可以讀寫.");
                    } catch (error) {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                        try {
                            // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                            fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                            // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
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
                            console.log("指定的待刪除的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                            console.error(error);
                            response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                    };

                    // 同步刪除指定的文檔;
                    // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    try {

                        // 同步刪除指定的文檔;
                        fs.unlinkSync(web_path);  // 同步刪除，返回值為 undefined;
                        // Get the files in current diectory;
                        // after deletion;
                        // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
                        response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;

                        // // 異步刪除指定的文檔;
                        // fs.unlink(
                        //     web_path,
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             // console.log(`\nDeleted file:\n${web_path}`);
                        //             // // Get the files in current diectory;
                        //             // // after deletion;
                        //             // console.log("\nFiles present in directory:");
                        //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } ); 

                        //             // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
                        //             response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
                        //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             // if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                        // 同步寫入文檔;
                        // // console.log(file_data);
                        // fs.writeFileSync(
                        //     web_path,
                        //     file_data,
                        //     { encoding: "utf8", mode: 0o777, flag: "w+" }
                        // );  // 返回值為 undefined;
                        // // // web_path_bytes = new Uint8Array(Buffer.from(web_path));  // 轉換為 Buffer 二進制對象;
                        // // fs.writeFileSync(web_path, web_path_bytes, { mode: 0o777, flag: "w+" });  // 返回值為 undefined;
                        // // console.log(web_path_bytes);
                        // // // let buffer = new Buffer(8);
                        // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                        // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                        // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                        // // console.log(data_Str);
                        // console.log("目標文檔: " + web_path + " 寫入成功.");
                        // // response_body_String = JSON.stringify(result);
                        // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                        // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        // if (callback) { callback(null, response_body_String); };
                        // // return response_body_String;

                        // fs.writeFile(
                        //     web_path,
                        //     file_data,
                        //     {
                        //         encoding: "utf8",
                        //         mode: 0o777,
                        //         flag: "w+"
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             console.log("目標文檔: " + web_path + " 寫入成功.");
                        //             // response_body_String = JSON.stringify(result);
                        //             response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(null, response_body_String); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                    } catch (error) {

                        console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };

                } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

                    // 同步判斷文檔權限，後面所有代碼都是，當指定的文件夾存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    try {
                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                        // console.log("文件夾: " + web_path + " 可以讀寫.");
                    } catch (error) {
                        // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                        try {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                            fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                            // console.log("文件夾: " + web_path + " 操作權限修改為可以讀寫.");
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
                            console.log("指定的待刪除的文件夾 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                            console.error(error);
                            response_data_JSON["Database_say"] = "指定的待刪除的文件夾 Directory = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                    };

                    // 同步刪除指定的文件夾;
                    // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    try {

                        // 同步刪除指定的文件夾;
                        fs.rmdirSync(web_path, { recursive: true, maxRetries: 0, retryDelay: 100 });  // 同步刪除，返回值為 undefined;
                        // Get the current filenames;
                        // in the directory to verify;
                        // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
                        response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;

                        // // 異步刪除指定的文件夾;
                        // fs.rmdir(
                        //     web_path,
                        //     { 
                        //         recursive: true,
                        //         maxRetries: 0,
                        //         retryDelay: 100
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             // console.log(`\nDeleted file:\n${web_path}`);
                        //             // // Get the files in current diectory;
                        //             // // after deletion;
                        //             // console.log("\nFiles present in directory:");
                        //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        //             // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
                        //             response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
                        //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             // if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                        // // 同步創建文件夾;
                        // fs.mkdirSync(web_path, 0777);
                        // // 伊布創建文件夾;
                        // fs.mkdir(
                        //     web_path,
                        //     {
                        //         recursive: true
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.error(err);
                        //         } else {
                        //             console.log('Directory created successfully!');
                        //         };
                        //     }
                        // );

                    } catch (error) {

                        console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };

                } else {

                    console.log("指定的待刪除的文檔: " + String(web_path) + " 不存在或無法識別." + "\n" + "file = { " + String(web_path) + " } can not found.");
                    response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 不存在或無法識別." + "\n" + "file = { " + String(fileName) + " } can not found.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };
            };

            // let web_path_index_Html = String(path.join(webPath, "/index.html"));
            // file_data = request_POST_String;
            // // web_path = String(path.join(webPath, request_url_path));
            // let currentDirectory = "";
            // if (fileName === "" || fileName === null) {
            //     currentDirectory = "/";
            // } else {
            //     if (fileName.indexOf("/") !== -1) {
            //         let tempArray = new Array();
            //         tempArray = fileName.split("/");
            //         for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
            //             if (i === 0) {
            //                 currentDirectory = tempArray[i];
            //             } else {
            //                 currentDirectory = currentDirectory + "/" + tempArray[i];
            //             };
            //         };
            //     } else {
            //         currentDirectory = "/";
            //     };
            // };
            // web_path = String(path.join(webPath, currentDirectory));

            // if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

            //     try {

            //         // // 同步讀取硬盤文檔;
            //         // file_data = fs.readFileSync(web_path_index_Html);
            //         // // console.log("同步讀取文檔: " + file_data.toString());
            //         // let filesName = fs.readdirSync(web_path);
            //         // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
            //         // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
            //         // filesName.forEach(
            //         //     function (item) {
            //         //         // console.log("異步讀取文件夾目錄: " + item.toString());
            //         //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
            //         //         if (statsObj.isFile()) {
            //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
            //         //         } else if (statsObj.isDirectory()) {
            //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
            //         //         } else {};
            //         //     }
            //         // );
            //         // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
            //         // // console.log(response_body_String);
            //         // // return response_body_String;

            //         // 異步讀取硬盤文檔;
            //         fs.readFile(
            //             web_path_index_Html,
            //             function (error, data) {

            //                 if (error) {
            //                     console.error(error);
            //                     response_data_JSON["Database_say"] = String(error);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(response_body_String, null); };
            //                     // return response_body_String;
            //                 };

            //                 if (data) {
            //                     file_data = data;
            //                     // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
            //                     fs.readdir(
            //                         web_path,
            //                         function (error, filesName) {

            //                             if (error) {
            //                                 console.error(error);
            //                                 response_data_JSON["Database_say"] = String(error);
            //                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                                 if (callback) { callback(response_body_String, null); };
            //                                 // return response_body_String;
            //                             };

            //                             if (filesName) {
            //                                 let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td><td>操作</td></tr>';
            //                                 // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
            //                                 filesName.forEach(
            //                                     function (item) {
            //                                         // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
            //                                         let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
            //                                         // console.log("異步讀取文件夾目錄: " + item.toString());
            //                                         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
            //                                         if (statsObj.isFile()) {
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
            //                                         directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         } else if (statsObj.isDirectory()) {
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
            //                                         directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         } else {};
            //                                     }
            //                                 );
            //                                 response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
            //                                 // console.log(response_body_String);
            //                                 if (callback) { callback(null, response_body_String); };
            //                                 // return response_body_String;
            //                             };
            //                         }
            //                     );
            //                 };
            //             }
            //         );

            //     } catch (error) {
            //         console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
            //         console.error(error);
            //         response_data_JSON["Database_say"] = String(error);
            //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         if (callback) { callback(response_body_String, null); };
            //         // return response_body_String;
            //     } finally {
            //         // fs.close();
            //     };
            // };

            return response_body_String;
        }

        case "/createCollection": {

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (MongoDBClient !== null) {

                // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                // let result = await MongoDBClient.db(dbName).createCollection(dbTableName);
                // response_data_JSON["Database_say"] = JSON.stringify(result);
                // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                // // return response_body_String;

                MongoDBClient.db(dbName).createCollection(
                    dbTableName,
                    function (error, result) {
                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                        if (result) {
                            // console.log("已從數據庫 " + dbName + " 中創建集合 " + dbTableName + ".");
                            // console.log(result);
                            // response_body_String = JSON.stringify(result);
                            response_data_JSON["Database_say"] = String(result.namespace);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } else {

                console.log("Database error.");
                response_data_JSON["Database_say"] = "Database error.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/dropCollection": {

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (MongoDBClient !== null) {

                // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                // let result = await MongoDBClient.db(dbName).collection(dbTableName).drop();
                // response_data_JSON["Database_say"] = String(result);
                // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                // // return response_body_String;

                MongoDBClient.db(dbName).collection(dbTableName).drop(
                    // 刪除操作成功，參數 delOK 返回值為：true，刪除操作失敗，參數 delOK 返回值為：false;
                    function(error, delOK) {
                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                        if (delOK) {
                            // console.log("集合 " + dbTableName + " 已從數據庫 " + dbName + " 中刪除.");
                            // response_body_String = String(delOK);
                            response_data_JSON["Database_say"] = String(delOK);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } else {

                console.log("Database error.");
                response_data_JSON["Database_say"] = "Database error.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/insertOne": {
        // 向 MongoDB 數據庫的指定數據庫中的指定集合（表格）中插入數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if ((Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length > 0 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}')) || (typeof (request_POST_JSON) === 'object' && Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object object]' && !(request_POST_JSON.length) && JSON.stringify(request_POST_JSON) !== '{}')) {

                if (MongoDBClient !== null) {

                    // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                    // let result = await MongoDBClient.db(dbName).collection(dbTableName).insertOne(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 對象;
                    // response_data_JSON["Database_say"] = JSON.stringify(result);
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // // return response_body_String;

                    MongoDBClient.db(dbName).collection(dbTableName).insertOne(
                        request_POST_JSON,
                        function (error, result) {
                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };
                            if (result) {
                                // console.log("向數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中插入數據成功.");
                                // console.log(result);
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = JSON.stringify(result);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } else {

                    console.log("Database error.");
                    response_data_JSON["Database_say"] = "Database error.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                console.log("error, data is empty.");
                response_data_JSON["Database_say"] = "error, data is empty.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/insertMany": {
        // 向 MongoDB 數據庫的指定數據庫中的指定集合（表格）中插入數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if ((Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length > 0 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}')) || (typeof (request_POST_JSON) === 'object' && Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object object]' && !(request_POST_JSON.length) && JSON.stringify(request_POST_JSON) !== '{}')) {

                if (MongoDBClient !== null) {

                    // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                    // // let result = await MongoDBClient.db(dbName).collection(dbTableName).insertMany(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 數組;
                    // response_data_JSON["Database_say"] = JSON.stringify(result);
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // // return response_body_String;

                    // 注意，在使用 insertMany() 函數插入多條文檔的時候，在參數 ordered 為 true 值的情況下，如果其中一條數據出現錯誤（比如主鍵重複之類的錯誤），那麽會導致所有數據都無法被插入，反之，如果參數 ordered 為 false 值的情況下，只有出錯的數據無法被插入；可以使用 db.dbName.insertMany([], { ordered: false }) 方法來控制是否按順序插入多條數據。
                    MongoDBClient.db(dbName).collection(dbTableName).insertMany(
                        request_POST_JSON,
                        {
                            ordered: false
                        },
                        function (error, result) {
                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };
                            if (result) {
                                // console.log("向數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中插入 " + String(result.insertedCount) + " 條數據成功.");
                                // console.log(result);
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = JSON.stringify(result);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } else {

                    console.log("Database error.");
                    response_data_JSON["Database_say"] = "Database error.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                console.log("error, data is empty.");
                response_data_JSON["Database_say"] = "error, data is empty.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/deleteOne": {
        // 從 MongoDB 數據庫的指定數據庫中的指定集合（表格）中刪除數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (MongoDBClient !== null) {

                // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                // let result = await MongoDBClient.db(dbName).collection(dbTableName).deleteOne(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 對象;
                // response_data_JSON["Database_say"] = JSON.stringify(result);
                // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                // // return response_body_String;

                MongoDBClient.db(dbName).collection(dbTableName).deleteOne(
                    request_POST_JSON,
                    function (error, obj) {
                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                        if (obj) {
                            // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中刪除數據成功.");
                            // console.log(obj);
                            // response_body_String = JSON.stringify(obj);
                            response_data_JSON["Database_say"] = JSON.stringify(obj);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } else {

                console.log("Database error.");
                response_data_JSON["Database_say"] = "Database error.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/deleteMany": {
        // 從 MongoDB 數據庫的指定數據庫中的指定集合（表格）中刪除數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (MongoDBClient !== null) {

                // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                // // let result = await MongoDBClient.db(dbName).collection(dbTableName).deleteMany(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 對象;
                // response_data_JSON["Database_say"] = JSON.stringify(result);
                // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                // // return response_body_String;

                MongoDBClient.db(dbName).collection(dbTableName).deleteMany(
                    request_POST_JSON,
                    function (error, obj) {
                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                        if (obj) {
                            // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中刪除 " + String(obj.result.n) + " 條數據成功.");
                            // console.log(obj);
                            // response_body_String = JSON.stringify(obj);
                            response_data_JSON["Database_say"] = JSON.stringify(obj);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } else {

                console.log("Database error.");
                response_data_JSON["Database_say"] = "Database error.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/updateOne": {
        // 更新 MongoDB 數據庫的指定數據庫中的指定集合（表格）中的指定數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length >= 2 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}') && (typeof (request_POST_JSON[1]) === 'object' && Object.prototype.toString.call(request_POST_JSON[1]).toLowerCase() === '[object object]' && !(request_POST_JSON[1].length) && JSON.stringify(request_POST_JSON[1]) !== '{}')) {

                if (MongoDBClient !== null) {

                    // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                    // let result = await MongoDBClient.db(dbName).collection(dbTableName).updateOne(
                    //     request_POST_JSON[0],
                    //     { $set: request_POST_JSON[1] }
                    // );  // 變量 request_POST_JSON 為 JSON 數組;
                    // response_data_JSON["Database_say"] = JSON.stringify(result);
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // // return response_body_String;

                    MongoDBClient.db(dbName).collection(dbTableName).updateOne(
                        request_POST_JSON[0],
                        { $set: request_POST_JSON[1] },
                        function (error, result) {
                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };
                            if (result) {
                                // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中更新數據成功.");
                                // console.log(result);
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = JSON.stringify(result);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } else {

                    console.log("Database error.");
                    response_data_JSON["Database_say"] = "Database error.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                console.log("error, data is empty.");
                response_data_JSON["Database_say"] = "error, data is empty.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/updateMany": {
        // 更新 MongoDB 數據庫的指定數據庫中的指定集合（表格）中的指定數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length >= 2 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}') && (typeof (request_POST_JSON[1]) === 'object' && Object.prototype.toString.call(request_POST_JSON[1]).toLowerCase() === '[object object]' && !(request_POST_JSON[1].length) && JSON.stringify(request_POST_JSON[1]) !== '{}')) {

                if (MongoDBClient !== null) {

                    // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                    // // let result = await MongoDBClient.db(dbName).collection(dbTableName).updateMany(
                    // //     request_POST_JSON[0],
                    // //     { $set: request_POST_JSON[1] }
                    // // );  // 變量 request_POST_JSON 為 JSON 數組;
                    // response_data_JSON["Database_say"] = JSON.stringify(result);
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // // return response_body_String;

                    MongoDBClient.db(dbName).collection(dbTableName).updateMany(
                        request_POST_JSON[0],
                        { $set: request_POST_JSON[1] },
                        function (error, result) {
                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };
                            if (result) {
                                // console.log("在數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中更新 " + String(result.nModified) + " 條數據成功.");
                                // console.log(result);
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = JSON.stringify(result);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } else {

                    console.log("Database error.");
                    response_data_JSON["Database_say"] = "Database error.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                console.log("error, data is empty.");
                response_data_JSON["Database_say"] = "error, data is empty.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/find": {
        // 向 MongoDB 數據庫的指定數據庫中的指定集合（表格）中發出檢索指令，並接收返回數據;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (MongoDBClient !== null) {

                // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                // let result = await MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray();  // 變量 request_POST_JSON 為 JSON 對象;
                // response_data_JSON["Database_say"] = JSON.stringify(result);
                // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                // // return response_body_String;

                // 參數 .sort({"_id": 1}) 表示查詢結果按照 "_id" 升序排序，參數 .toArray() 表示將查詢結果轉換爲 JSON 數組的形式輸出;
                MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).sort({"_id": 1}).toArray(
                    function (error, result) {
                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                        if (result) {
                            // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中查詢數據成功.");
                            // console.log(result);
                            // response_body_String = JSON.stringify(result);
                            response_data_JSON["Database_say"] = JSON.stringify(result);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } else {

                console.log("Database error.");
                response_data_JSON["Database_say"] = "Database error.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        case "/countDocuments": {
        // 向 MongoDB 數據庫的指定數據庫中的指定集合（表格）中發出檢索數據條目數量指令，並接收返回符合條件的數據的個數;

            request_POST_JSON = {};
            // 自定義函數判斷客戶端 POST 請求傳送的 request_POST_String 是否為一個 JSON 格式的字符串;
            // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
                try {
                    if (request_POST_String !== "") {
                        request_POST_JSON = JSON.parse(request_POST_String, true);
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    };
                } catch (error) {
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                } finally {};
                // console.log(request_POST_JSON);
            // };

            if (MongoDBClient !== null) {

                // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

                // let result = await MongoDBClient.db(dbName).collection(dbTableName).countDocuments(request_POST_JSON, { maxTimeMS: 5000 });  // 變量 request_POST_JSON 為 JSON 對象;
                // response_data_JSON["Database_say"] = String(result);
                // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                // // return response_body_String;

                MongoDBClient.db(dbName).collection(dbTableName).countDocuments(
                    request_POST_JSON,
                    { maxTimeMS: 5000 },
                    function (error, result) {
                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                        if (result) {
                            // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中查詢數據條目數量成功.");
                            // console.log(result);
                            // response_body_String = JSON.stringify(result);
                            response_data_JSON["Database_say"] = String(result);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } else {

                console.log("Database error.");
                response_data_JSON["Database_say"] = "Database error.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }

        default: {

            let web_path_index_Html = String(path.join(webPath, "/index.html"));
            // web_path = String(path.join(webPath, request_url_path));
            file_data = null;

            if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {

                try {

                    // // 同步讀取硬盤文檔;
                    // file_data = fs.readFileSync(web_path);
                    // // console.log("同步讀取文檔: " + file_data.toString());
                    // response_body_String = file_data.toString();
                    // // console.log(response_body_String);
                    // // return response_body_String;

                    // 異步讀取硬盤文檔;
                    fs.readFile(
                        web_path,
                        function (error, data) {

                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };

                            if (data) {

                                let file_data_Buffer = data;
                                // let buffer = new ArrayBuffer(TemporaryPublicVariableCollectResultStoredStringArray.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
                                // let file_data_bytes_Uint8Array = new Uint8Array(buffer);  // 轉換為 Buffer 二進制對象;
                                // for (let i = 0; i < TemporaryPublicVariableCollectResultStoredStringArray.length; i++) {
                                //     file_data_bytes_Uint8Array[i] = TemporaryPublicVariableCollectResultStoredStringArray[i];
                                // };
                                // file_data_String = file_data_bytes_Uint8Array.toString();
                                file_data_Buffer = new Uint8Array(file_data_Buffer);
                                // console.log(file_data_Buffer);
                                // file_data = file_data_Buffer.toString();
                                // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                                // file_data = JSON.stringify(file_data_Buffer);  // JSON.parse(file_data);
                                let file_data_Uint8Array = new Array();
                                for (let i = 0; i < file_data_Buffer.length; i++) {
                                    file_data_Uint8Array.push(file_data_Buffer[i]);
                                    // file_data_Uint8Array.push(String(file_data_Buffer[i]));
                                };
                                file_data = JSON.stringify(file_data_Uint8Array);  // JSON.parse(file_data);
                                response_body_String = file_data;
                                // console.log(response_body_String);
                                if (callback) { callback(null, response_body_String); };
                            };
                        }
                    );

                } catch (error) {
                    console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                } finally {
                    // fs.close();
                };

            } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

                try {

                    // // 同步讀取硬盤文檔;
                    // file_data = fs.readFileSync(web_path_index_Html);
                    // // console.log("同步讀取文檔: " + file_data.toString());
                    // let filesName = fs.readdirSync(web_path);
                    // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                    // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                    // filesName.forEach(
                    //     function (item) {
                    //         // console.log("異步讀取文件夾目錄: " + item.toString());
                    //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
                    //         if (statsObj.isFile()) {
                    //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                    //         } else if (statsObj.isDirectory()) {
                    //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                    //         } else {};
                    //     }
                    // );
                    // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                    // // console.log(response_body_String);
                    // // return response_body_String;

                    // 異步讀取硬盤文檔;
                    fs.readFile(
                        web_path_index_Html,
                        function (error, data) {

                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };

                            if (data) {
                                file_data = data;
                                // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                                fs.readdir(
                                    web_path,
                                    function (error, filesName) {

                                        if (error) {
                                            console.error(error);
                                            response_data_JSON["Database_say"] = String(error);
                                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                            if (callback) { callback(response_body_String, null); };
                                            // return response_body_String;
                                        };

                                        if (filesName) {
                                            let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                            // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                            filesName.forEach(
                                                function (item) {
                                                    // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                    let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                    // console.log("異步讀取文件夾目錄: " + item.toString());
                                                    let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
                                                    if (statsObj.isFile()) {
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                        directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    } else if (statsObj.isDirectory()) {
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                        directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    } else {};
                                                }
                                            );
                                            response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                            // console.log(response_body_String);
                                            if (callback) { callback(null, response_body_String); };
                                            // return response_body_String;
                                        };
                                    }
                                );
                            };
                        }
                    );

                } catch (error) {
                    console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                } finally {
                    // fs.close();
                };

            } else {

                console.log("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(web_path) + " } 無法識別.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(fileName) + " } 無法識別.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }
    };
};


// 參數預設值, 讀入控制臺傳入的參數，並檢查輸入格式合規性;
let host = "::0";  // "::0","0.0.0.0" or "::1","127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
let port = 27016;  // 1 ~ 65535 監聽端口;
let webPath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;

// 連接配置mongodb數據庫服務器的參數;
let MongodbHost = "[::1]";  // [::0],"0.0.0.0" or [::1],"127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
let MongodbPort = "27017";  // 1 ~ 65535 監聽端口;
let dbUser = "";  // 'administrator';  // ['root:root', 'administrator:administrator', 'admin_Database1:admin', 'user_Database1:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
let dbPass = "";  // 'administrator';  // ['root:root', 'administrator:administrator', 'admin_Database1:admin', 'user_Database1:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
// let UserPass = dbUser.concat(":", dbPass);  // 'admin_Database1:admin';  // ['root:root', 'administrator:administrator', 'admin_Database1:admin', 'user_Database1:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
let dbName = "";  // 'Database1';  // ['admin', 'Database1'];  // 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，Mongodb 要求數據庫名稱首字母必須為大寫單數;
let MongodbUrl = "";
// MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;  // [`mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`];  // 定義 Mongodb 數據庫服務器入口地址，將數據庫入口地址設為形參，這樣便於日後更換數據庫服務器;
// MongodbUrl = "mongodb://admin_Database1:admin@[::1]:27017/Database1?connect=direct&slaveOk=true&safe=true&w=2&wtimeoutMS=2000";
if ((dbUser.length === 0) && (dbPass.length === 0)) {
    MongodbUrl = `mongodb://${ MongodbHost }:${ MongodbPort }/${ dbName }`;
} else if ((dbUser.length !== 0) || (dbPass.length !== 0)) {
    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;
} else {
    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;
};
// console.log(MongodbUrl);
let dbTableName = 'Collection1';  // ['Collection1'];  // MongoDB 數據庫包含的數據集合（表格）;

// 媒介服務器函數服務端（後端） http_Server() 使用説明;
// let host = "0.0.0.0";  // "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// let port = 8000;  // 1 ~ 65535 監聽端口;
let number_cluster_Workers = 0;  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// console.log(number_cluster_Workers);
let Key = "";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
let Session = {
    "request_Key->username:password": Key
};
let do_Request = do_Request_Router;
let do_Function_JSON = {
    "do_Request": do_Request_Router,  // do_GET_root_directory, // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_GET_root_directory";
};
let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。


// 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// console.log(typeof(process.argv));
// console.log(process.argv);
// 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
if (process.argv.length > 2) {
    for (let i = 0; i < process.argv.length; i++) {
        // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
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
                if (String(process.argv[i].split("=")[0]) === "Key") {
                    Key = String(process.argv[i].split("=")[1]);
                };
                if (String(process.argv[i].split("=")[0]) === "number_cluster_Workers") {
                    number_cluster_Workers = parseInt(process.argv[i].split("=")[1]);
                };

                if (String(process.argv[i].split("=")[0]) === "MongodbHost") {
                    MongodbHost = String(process.argv[i].split("=")[1]);
                    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;  // [`mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`];  // 定義 Mongodb 數據庫服務器入口地址，將數據庫入口地址設為形參，這樣便於日後更換數據庫服務器;
                };
                if (String(process.argv[i].split("=")[0]) === "MongodbPort") {
                    MongodbPort = String(process.argv[i].split("=")[1]);
                    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;  // [`mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`];  // 定義 Mongodb 數據庫服務器入口地址，將數據庫入口地址設為形參，這樣便於日後更換數據庫服務器;
                };
                if (String(process.argv[i].split("=")[0]) === "dbUser") {
                    dbUser = String(process.argv[i].split("=")[1]);
                    // dbUserPass = dbUser.concat(":", dbPass);
                    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;  // [`mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`];  // 定義 Mongodb 數據庫服務器入口地址，將數據庫入口地址設為形參，這樣便於日後更換數據庫服務器;
                };
                if (String(process.argv[i].split("=")[0]) === "dbPass") {
                    dbPass = String(process.argv[i].split("=")[1]);
                    // dbUserPass = dbUser.concat(":", dbPass);
                    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;  // [`mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`];  // 定義 Mongodb 數據庫服務器入口地址，將數據庫入口地址設為形參，這樣便於日後更換數據庫服務器;
                };
                if (String(process.argv[i].split("=")[0]) === "dbName") {
                    dbName = String(process.argv[i].split("=")[1]);
                    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;  // [`mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`];  // 定義 Mongodb 數據庫服務器入口地址，將數據庫入口地址設為形參，這樣便於日後更換數據庫服務器;
                };
                if (String(process.argv[i].split("=")[0]) === "dbTableName") {
                    dbTableName = String(process.argv[i].split("=")[1]);
                };
                if (String(process.argv[i].split("=")[0]) === "MongodbUrl") {
                    MongodbUrl = String(process.argv[i].split("=")[1]);
                    // MongodbUrl = "mongodb://admin_test20220703:admin@127.0.0.1:27017/testWebData?connect=direct&slaveOk=true&safe=true&w=2&wtimeoutMS=2000";
                    dbUser = String(MongodbUrl.split("://")[1].split("@")[0].split(":")[0]);
                    dbPass = String(MongodbUrl.split("://")[1].split("@")[0].split(":")[1]);
                    MongodbHost = String(MongodbUrl.split("@")[1].split("/")[0].split(":")[0]);
                    MongodbPort = String(MongodbUrl.split("@")[1].split("/")[0].split(":")[1]);
                    // dbName = String(MongodbUrl.split("@")[1].split("/")[1].split("?")[0]);
                };
            };
        };
    };
};

if ((dbUser.length === 0) && (dbPass.length === 0)) {
    MongodbUrl = `mongodb://${ MongodbHost }:${ MongodbPort }/${ dbName }`;
} else if ((dbUser.length !== 0) || (dbPass.length !== 0)) {
    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;
} else {
    MongodbUrl = `mongodb://${ dbUser }:${ dbPass }@${ MongodbHost }:${ MongodbPort }/${ dbName }`;
};
// console.log(MongodbUrl);

// // 控制臺傳參檢查埠號（port）是否已經被占用，控制臺傳參，其中「port」為需要檢測的端口號，運行方式示例：node PortIsOccupied 80;
// if (port >= 65535 || port <= 0) {
//     console.log(`端口參數「${port}」類型輸入錯誤，請正確輸入「1 ~ 65535」的數字端口進行測試.`);
//     process.exit(1);
// } else {
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
//                 // process.exit(1);
//             } else {
//                 console.log(JSON.stringify(error));
//             };
//         });
//     };
//     // 執行
//     PortIsOccupied(port);
// };

// 自定義函數，對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64String = new Base64().encode(str);
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
const base64 = new Base64();
module.exports.Base64 = Base64; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 調用示例：
// const Base64 = Interface.Base64;  // 使用「Interface.js」模塊中的成員「Base64()」函數, 用於對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// 解碼：str = new Base64().decode(base64) ，編碼：base64 = new Base64().encode(str);

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


// 使用 Node.js 原生的 http 庫創建 web server 服務器;
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
        let status_Message = base64.encode(statusMessage_CN).concat(" ", statusMessage_EN);
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

        let request_headers = request.headers;  // 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
        // console.log(request.headers);  // 換行打印請求頭;
        // console.log(type(request.headers));  // 打印請求頭的數據類型;
        request_headers["protocol"] = String(request.httpVersion);
        request_headers["method"] = String(request.method);
        request_headers["remoteAddress"] = String(request.connection.remoteAddress);
        request_headers["url"] = String(request.url);

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
                // console.log("request Headers Authorization: ", request.headers["authorization"].split(" ")[0] + " " + base64.decode(request.headers["authorization"].split(" ")[1]));  // 打印請求頭中的使用自定義函數base64.decode()解密之後的用戶賬號和密碼參數"Authorization";
                request_Authorization = base64.decode(request.headers["authorization"].split(" ")[1]).toString("utf-8");
                // 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                // 打印請求頭中的使用自定義函數base64.decode()解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                // console.log(type(base64.decode(request.headers["authorization"].split(" ")[1])));
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
                Session_ID = base64.decode(request_Cookie.split("=")[1].toString("utf-8"));
            } else {
                Session_ID = base64.decode(request_Cookie.toString("utf-8"));
            };
            // console.log("request Session ID: ", Session_ID);
        } else {
            request_Cookie = "";
        };
        // console.log(request_Cookie);
        // console.log(Session_ID);

        // 判斷如果客戶端發送的請求的賬號密碼來源，如果請求頭 request.headers["Authorization"] 參數不爲空則使用 request.headers["Authorization"] 的參數值作爲客戶端的賬號密碼，如果請求頭 request.headers["Authorization"] 參數為空但 request.headers["Cookie"] 參數不爲空則使用 request.headers["Cookie"]  的參數值，作爲在自定義的 Session 對象中查找的"key"對應的"value"值，作爲客戶端的賬號密碼;
        if (request_Authorization !== "") {
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

                let Content_Type = "text/plain, text/html; charset=utf-8";

                // Set-Cookie: name=value[; expires=date][; domain=domain][; path=path][; secure];
                // 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
                // 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
                // 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
                // 參數value部分，通常是一個 name=value 格式的字串，通常性的使用方式是以 name=value 的格式來指定cookie的值；
                // 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
                let after_1_Days = new Date(new Date(new Date(new Date().setDate(new Date().getDate() + 1)))).toLocaleString('chinese', { hour12: false });  // 計算 30 日之後的日期;
                // console.log(after_1_Days);
                let cookie_value = "session_id=" + base64.encode("request_Key->" + request_Key).toString("UTF8");  // 將漢字做Base64轉碼 base64.encode(base64);
                // console.log(base64.decode(cookie_value));  // Base64解碼 base64.decode(base64);
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

            let Content_Type = "text/plain, text/html; charset=utf-8";

            // Set-Cookie: name=value[; expires=date][; domain=domain][; path=path][; secure];
            // 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
            // 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
            // 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
            // 參數value部分，通常是一個 name=value 格式的字串，通常性的使用方式是以 name=value 的格式來指定cookie的值；
            // 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
            let after_1_Days = new Date(new Date(new Date(new Date().setDate(new Date().getDate() + 1)))).toLocaleString('chinese', { hour12: false });  // 計算 30 日之後的日期;
            // console.log(after_1_Days);
            let cookie_value = "session_id=" + base64.encode("request_Key->" + request_Key).toString("UTF8");  // 將漢字做Base64轉碼 base64.encode(base64);
            // console.log(base64.decode(cookie_value));  // Base64解碼 base64.decode(base64);
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
            let cookie_value = "session_id=" + base64.encode("request_Key->" + request_Key).toString("UTF8");  // 將漢字做Base64轉碼 base64.encode(base64);
            // console.log(base64.decode(cookie_value));  // Base64解碼 base64.decode(base64);
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

                                        let Content_Type = "text/plain, text/html; charset=utf-8";

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

                                let Content_Type = "text/plain, text/html; charset=utf-8";
    
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

                                            let Content_Type = "text/plain, text/html; charset=utf-8";

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

                                    let Content_Type = "text/plain, text/html; charset=utf-8";

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

                                        let Content_Type = "text/html; charset=UTF-8";  // "text/html, text/javascript, text/css, text/plain, application/json; charset=UTF-8";
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

                                let Content_Type = "text/html; charset=UTF-8";  // "text/html, text/javascript, text/css, text/plain, application/json; charset=UTF-8";
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

                                            let Content_Type = "text/plain, text/html; charset=utf-8";

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

                                    let Content_Type = "text/plain, text/html; charset=utf-8";
    
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

            // console.log("進程: process-" + process.pid + " , 執行緒: thread-" + require('worker_threads').threadId + " 正在監「 http://" + host + ":" + port + "/ 」 ...");
            console.log("process-" + process.pid + " > thread-" + require('worker_threads').threadId + " listening on host domain [ http://" + host + ":" + port + "/ ] ...");
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
// // let host = "0.0.0.0";  // "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// // let port = 27016;  // 1 ~ 65535 監聽端口;
// let number_cluster_Workers = 0;  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// // console.log(number_cluster_Workers);
// let Key = "";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
// let Session = {
//     "request_Key->username:password": Key
// };
// let do_Request = do_Request_Router;
// let do_Function_JSON = {
//     "do_Request": do_Request_Router,  // do_GET_root_directory, // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_GET_root_directory";
// };
// let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
// let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
// let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
// let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
// let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
// let Server = http_Server(
//     {
//         "host": host,
//         "port": port,
//         "number_cluster_Workers": number_cluster_Workers,
//         "Key": Key,
//         "Session": Session,
//         // "do_Function_JSON": do_Function_JSON,
//         "do_Request": do_Request_Router,
//         "exclusive": exclusive,
//         "backlog": backlog,
//         "readableAll": readableAll,
//         "writableAll": writableAll,
//         "ipv6Only": ipv6Only
//     }
// );
// // let Server = http_Server({
// //     "do_Request": do_Request_Router,
// //     "Session": Session,
// //     "Key": Key,
// //     "number_cluster_Workers": number_cluster_Workers,
// // });


// 使用 Node.js 原生的 http 庫創建 web client 客戶端;
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
    // let request_Authorization_Base64 = "Basic ".concat(base64.encode("username:password", "utf8"));  // request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
    let request_Cookie = "";  // "Session_ID=".concat(base64.encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
    // let request_Cookie_Base64 = "Session_ID=".concat(base64.encode("request_Key->username:password"));  // 使用自定義函數Base64()編碼請求 Cookie 信息;
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
        auth: request_Auth,  // 選填 {auth: 'username:password'} 參數後，http 庫會自動在請求頭 headers 中加入 { "Authorization": "Basic ".concat(base64.encode("username:password") } 參數;
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
            // 'Authorization': request_Authorization_Base64,  // 服務器訪問密碼參數；使用自定義函數對字符串進行base64編解碼，解碼：str = base64.decode(base64)，編碼：base64 = base64.encode(str);
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
    // options.headers["Authorization"] = "Basic ".concat(base64.encode("username:password"));  // request_Authorization_Base64;
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
                response_statusMessage = base64.decode(response_statusMessage.split(" ")[0]).toString("UTF8").concat(" ", response_statusMessage.split(" ")[1]);  // unescape(response_statusMessage).toString("UTF8"); decodeURIComponent(response_statusMessage); String(response_statusCode) 强制轉換為字符串類型;
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
                        cookieName = response_Cookies[0].split(";")[0].split("=")[0].concat("=", base64.decode(response_Cookies[0].split(";")[0].split("=")[1]));
                    } else {
                        cookieName = base64.decode(response_Cookies[0].split(";")[0]);
                    };
                } else {
                    // request_Cookie = response_Cookies[0];
                    options.headers["Cookie"] = response_Cookies[0];

                    if (response_Cookies[0].indexOf("=", 0) !== -1) {
                        cookieName = response_Cookies[0].split("=")[0].concat("=", base64.decode(response_Cookies[0].split("=")[1]));
                    } else {
                        cookieName = base64.decode(response_Cookies[0]);
                    };
                };
                // console.log(cookieName);  // "Session_ID=".concat(base64.encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
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
                    // request_Authorization_Base64 = base64.encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options.headers["Authorization"] = base64.encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                } else {
                    wwwauthenticate_Value = response_wwwauthenticate;
                    wwwauthenticate_Value = wwwauthenticate_Value.split(" -> ")[1];  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    // request_Auth = wwwauthenticate_Value;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options["auth"] = wwwauthenticate_Value;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // request_Authorization_Base64 = base64.encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    // options.headers["Authorization"] = base64.encode(wwwauthenticate_Value);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
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
                    //         // request_Authorization_Base64 = base64.encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // options.headers["Authorization"] = base64.encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    //     } else {
                    //         wwwauthenticate_Value = response_wwwauthenticate;
                    //         Key = wwwauthenticate_Value.split(" -> ")[1];  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;

                    //         // 這裏務必要注意傳值的類型：深拷貝、淺拷貝、複製傳值、引用傳址，基本類型、引用類型;
                    //         // request_Auth = Key;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         options["auth"] = Key;  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // request_Authorization_Base64 = base64.encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                    //         // options.headers["Authorization"] = base64.encode(Key);  // 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
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
                    //     // request_Authorization_Base64 = "Basic ".concat(base64.encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                    //     // options.headers["Authorization"] = "Basic ".concat(base64.encode(Key));
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
                    //             cookieName = response_Cookies[0].split(";")[0].split("=")[0].concat("=", base64.decode(response_Cookies[0].split(";")[0].split("=")[1]));
                    //         } else {
                    //             cookieName = base64.decode(response_Cookies[0].split(";")[0]);
                    //         };
                    //     } else {
                    //         // request_Cookie = response_Cookies[0];
                    //         options.headers["Cookie"] = response_Cookies[0];

                    //         if (response_Cookies[0].indexOf("=", 0) !== -1) {
                    //             cookieName = response_Cookies[0].split("=")[0].concat("=", base64.decode(response_Cookies[0].split("=")[1]));
                    //         } else {
                    //             cookieName = base64.decode(response_Cookies[0]);
                    //         };
                    //     };
                    //     // console.log(cookieName);  // "Session_ID=".concat(base64.encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));

                    //     Key = cookieName.split("=")[1].split("->")[1];
                    //     // request_Auth = Key;
                    //     options["auth"] = Key;
                    //     // request_Authorization_Base64 = "Basic ".concat(base64.encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
                    //     options.headers["Authorization"] = "Basic ".concat(base64.encode(Key));
                    //     // console.log("response Headers Cookie: " + response_Cookies);
                    //     // console.log("response Headers Cookie say request Authorization: " + cookieName.split("=")[1].split("->")[1]);
                    // };

                    // // options["auth"] = Key;  // "username:password";
                    // // options.headers["Authorization"] = "Basic ".concat(base64.encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
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
                        // options.headers["Authorization"] = "Basic ".concat(base64.encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
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
                    //     // options.headers["Authorization"] = "Basic ".concat(base64.encode(Key));  // 使用自定義函數Base64()編碼加密驗證賬號信息;
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
// let Port = "27016";
// let URL = "/"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let Method = "POST";  // "GET"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = ""; // "username:password";
// let request_Cookie = ""; // "Session_ID=request_Key->username:password";
// request_Cookie = request_Cookie.split("=")[0].concat("=", base64.encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(base64.encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));

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


// 鏈接到 MongoDB 數據庫;
// Windows 系統啓動 MongoDB 數據庫服務器示例：
// 查看幫助信息：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --help
// 對於 Windows 系統，在 cmd 控制臺，使用如下命令：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe  --dbpath=C:\Criss\DatabaseServer\MongoDB\db  --bind_ip=0.0.0.0 --port=27017 --logpath=C:\Criss\DatabaseServer\MongoDB\log\mongod.log
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
// 即可啓動 MongoDB 數據庫的服務器端程序，並加載指定的配置文檔。鍵盤輸入：「Ctrl」+「c」，可關閉正在運行的 MongoDB 服務器端程序。
// 或者，對於 Windows 系統，在 cmd 控制臺命令行，使用如下命令：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg --install
// 可以安裝 MongoDB 數據庫的服務器端程序。
// 然後在控制臺命令行，使用如下命令：
// C:\Criss\DatabaseServer\MongoDB>net start MongoDB
// 即可在後臺啓動 MongoDB 服務器端程序。
// 然後在控制臺命令行，使用如下命令：
// C:\Criss\DatabaseServer\MongoDB>net stop MongoDB
// 即可關閉後臺正在運行的 MongoDB 服務器端程序。
// 在 cmd 控制臺命令行，使用如下命令：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --remove
// 可以卸載已經安裝成功的 MongoDB 服務器端程序。

// 注意，數據庫的服務器和用戶端是兩個程序，因此如果使用指令「mongod.exe --config="C:\Data\mongod.cfg"」在操作系統前臺啓動服務器，則需要另打開一個控制臺命令行窗口（例如 Windows 系統的 cmd 控制臺窗口），在新窗口中啓動數據庫用戶端程序。如果使用指令「mongod.exe --config="C:\Data\mongod.cfg" --install」在操作系統後臺運行服務器，則無需另打開一個控制臺命令行窗口（例如 Windows 系統的 cmd 控制臺窗口），可以在原窗口中直接啓動數據庫用戶端程序。

// 查看幫助信息：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongo.exe --help
// 在 Windows 系統的 cmd 控制臺命令行，使用如下命令：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongo.exe mongodb://administrator:administrator@127.0.0.1:27017/
// 即可使用 MongoDB 數據庫的用戶端程序「mongo.exe」鏈接到指定的正在運行監聽的 MongoDB 數據庫的服務器端程序。鏈接到服務器之後，預設鏈接的是「test」數據庫。
// 在如果需要直接鏈接到指定的數據庫（例如需要直接鏈接到名爲「testWebData」的數據庫），可使用如下指令：
// C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongo.exe mongodb://127.0.0.1:27017/testWebData
// 即可使用 MongoDB 數據庫的用戶端程序「mongo.exe」鏈接到指定的正在運行監聽的 MongoDB 數據庫的服務器端程序。並且在鏈接到服務器之後，直接鏈接至指定的「testWebData」數據庫。
// 可以在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令查看包含的所有數據庫清單：
// > show dbs
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令查看當前鏈接的數據庫：
// > show db
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令切換或創建當前鏈接的數據庫，例如切換到一個名爲「testWebData」的數據庫，如果系統中不存在這個數據庫，則會自動創建：
// > use testWebData
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令查看當前鏈接的數據庫中包含的所有集合（表格）：
// > show collections
// 在用戶端程序「mongo.exe」的控制臺命令行，在當前鏈接的數據庫中創建指定名稱的集合（表格），例如創建一個名爲「test20220703」的集合（表格），可以使用如下命令：
// > db.createCollection("test20220703")
// 在用戶端程序「mongo.exe」的控制臺命令行，如果想對當前鏈接的數據庫中包含的指定集合（表格）重命名，例如對一個名爲「test20220703」的集合（表格）重命名為「aaa」，可以使用如下命令：
// > db.test20220703.renameCollection("aaa")
// 在用戶端程序「mongo.exe」的控制臺命令行，如果想刪除當前鏈接的數據庫中包含的指定集合（表格），例如刪除一個名爲「test20220703」的集合（表格），可以使用如下命令：
// > db.test20220703.drop()
// 在用戶端程序「mongo.exe」的控制臺命令行，如果想刪除當前鏈接的數據庫，可以使用如下命令：
// > db.dropDatabase()
// 在用戶端程序「mongo.exe」的控制臺命令行，如果想從遠程主機克隆複製數據庫，可以使用如下命令：
// > db.copyDatabase(<from_dbname>, <to_dbname>, <from_hostname>, <username>,
//  <password>)
// 例如下實例：
// > db.copyDatabase(test_1, test_2, "127.41.4.1", "username", "password")
// 即表示複製遠程服務器「"127.41.4.1"」上的「test_1」數據庫到本地「test_2」數據庫，遠程服務器「"127.41.4.1"」上的「test_1」數據庫的登陸驗證賬號為："username"，密碼為："password"。
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令查看當前鏈接的數據庫中指定集合（表格）中包含的所有數據，假設當前數據庫中包含一個名爲「test20220703」的集合（表格）：
// > db.test20220703.find({})
// 如果顯示屏輸出的結果太長看起來比較無序混亂，可以在 .find() 函數後面連接一個 .pretty() 函數，即可格式化輸出結果顯示：
// > db.test20220703.find({}).pretty()
// 如果需要查看當前鏈接的數據庫中指定集合（表格）中包含的指定數據（例如：{"Column_1":"a-1"}），可以在 .find() 函數中傳入哈希（Hach）鍵值對格式的檢索關鍵詞查找：
// > db.test20220703.find({"Column_1":"a-1"}).pretty()
// 查詢指定數據庫指定集合（表格）中符合條件的數據條目數量：
// > db.test20220703.countDocuments({"Column_1":"a-1"}, { maxTimeMS: 5000 })
// 在用戶端程序「mongo.exe」的控制臺命令行，例如假設需要向當前鏈接的數據庫中指定的「test20220703」集合（表格）中插入哈希（Hach）鍵值對格式的數據：
// {"Column_1" : "a-1", "Column_2" : "一級", "Column_3" : "a-1-1", "Column_4" : "二級", "Column_5" : "a-1-2", "Column_6" : "二級", "Column_7" : "a-1-3", "Column_8" : "二級", "Column_9" : "a-1-4", "Column_10" : "二級", "Column_11" : "a-1-5", "Column_12" : "二級"}
// 可使用如下指令：
// > db.test20220703.insert({"Column_1" : "a-1", "Column_2" : "一級", "Column_3" : "a-1-1", "Column_4" : "二級", "Column_5" : "a-1-2", "Column_6" : "二級", "Column_7" : "a-1-3", "Column_8" : "二級", "Column_9" : "a-1-4", "Column_10" : "二級", "Column_11" : "a-1-5", "Column_12" : "二級"})
// 在用戶端程序「mongo.exe」的控制臺命令行，如果需要插入多條數據，例如假設需要向當前鏈接的數據庫中指定的「test20220703」集合（表格）中插入哈希（Hach）鍵值對格式的數據：
// {"Column_1" : "a-1", "Column_2" : "一級", "Column_3" : "", "Column_4" : "", "Column_5" : "", "Column_6" : "", "Column_7" : "", "Column_8" : "", "Column_9" : "", "Column_10" : "", "Column_11" : "", "Column_12" : ""}
// 和
// {"Column_1" : "a-1", "Column_2" : "一級", "Column_3" : "a-1-1", "Column_4" : "二級", "Column_5" : "a-1-2", "Column_6" : "二級", "Column_7" : "a-1-3", "Column_8" : "二級", "Column_9" : "a-1-4", "Column_10" : "二級", "Column_11" : "a-1-5", "Column_12" : "二級"}
// 可使用如下指令：
// > db.test20220703.insertMany([{"Column_1" : "a-1", "Column_2" : "一級", "Column_3" : "", "Column_4" : "", "Column_5" : "", "Column_6" : "", "Column_7" : "", "Column_8" : "", "Column_9" : "", "Column_10" : "", "Column_11" : "", "Column_12" : ""}, {"Column_1" : "a-1", "Column_2" : "一級", "Column_3" : "a-1-1", "Column_4" : "二級", "Column_5" : "a-1-2", "Column_6" : "二級", "Column_7" : "a-1-3", "Column_8" : "二級", "Column_9" : "a-1-4", "Column_10" : "二級", "Column_11" : "a-1-5", "Column_12" : "二級"}])
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令刪除當前鏈接的數據庫中指定集合（表格）中包含的指定數據（例如：{"ID":101, "Name":"liai"}），可以使用如下指令：
// > db.test20220703.remove({"Column_1":"a-1"}, {justOne: true})
// 前面第一個參數表示檢索條件，後面第二個參數，表示需要刪除所有檢索到的結果，還是只刪除檢索到的第一條結果，取 true 值表示只刪除檢索到的第一條結果，取 false 值表示刪除所有檢索到的結果。注意，如果不傳入檢索條件，則表示刪除指定集合（表格）中包含的所有數據。
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令修改當前鏈接的數據庫中指定集合（表格）中包含的指定數據（例如：{"Column_1":"a-1"} 改爲：{"Column_1":"b-1"}），可以使用如下指令：
// > db.test20220703.update({"Column_1":"a-1"}, {$set:{"Column_1" : "b-1", "Column_2" : "一級", "Column_3" : "b-1-1"}}, {multi: false})
// 前面第一個參數表示檢索條件，後面第二個參數表示需要更新為的目標數據，符號 $set 表示未更新數據保留，如不加 $set 符號則表示未更新數據丟棄，後面第三個參數 multi 如果取 false 值，表示只更新檢索到的第一條記錄，如果取 true 值，表示把檢索到的全部數據全部都更新。
// 在用戶端程序「mongo.exe」的控制臺命令行，使用如下命令退出用戶端程序「mongo.exe」的控制臺命令行，返回至操作系統 Ubuntu 的控制臺命令行：
// > quit()
// 或者，鍵盤輸入：「Ctrl」+「c」，也可退出用戶端程序「mongo.exe」的控制臺命令行，返回至操作系統 Ubuntu 的控制臺命令行：
// C:\Criss\DatabaseServer\MongoDB>

// try {
//     mongodb.MongoClient.connect(MongodbUrl, function (error, conn) { MongoDBConnect = conn; });
// } catch (error) {
//     console.log("錯誤：" + error.message);
// } finally {
//     if (MongoDBConnect != null) { MongoDBConnect.close(); };
// };

// 連接配置mongodb數據庫服務器;
let MongoDBClient = null;
mongodb.MongoClient.connect(
    MongodbUrl,
    function (error, conn) {

        if (error) {
            console.log(`MongoDB 數據庫「${MongodbUrl}」鏈接失敗：`);
            console.log(error);
            // return 1;
        };

        if (conn) {

            MongoDBClient = conn;
            console.log(`MongoDB 數據庫「${MongodbUrl}」鏈接成功.`);

            // // 媒介服務器函數服務端（後端） http_Server() 使用説明;
            // // let host = "0.0.0.0";  // "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
            // // let port = 8000;  // 1 ~ 65535 監聽端口;
            // let number_cluster_Workers = 0;  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
            // // console.log(number_cluster_Workers);
            // let Key = "";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
            // // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
            // let Session = {
            //     "request_Key->username:password": Key
            // };
            // let do_Request = do_Request_Router;
            // let do_Function_JSON = {
            //     "do_Request": do_Request_Router,  // do_GET_root_directory, // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_GET_root_directory";
            // };
            // let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
            // let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
            // // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
            // let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
            // let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
            // let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。
            let Server = http_Server({
                "host": host,
                "port": port,
                "number_cluster_Workers": number_cluster_Workers,
                "Key": Key,
                "Session": Session,
                // "do_Function_JSON": do_Function_JSON,
                "do_Request": do_Request,
                "exclusive": exclusive,
                "backlog": backlog,
                "readableAll": readableAll,
                "writableAll": writableAll,
                "ipv6Only": ipv6Only
            });
            // let Server = http_Server({
            //     "do_Request": do_Request,
            //     "Session": Session,
            //     "Key": Key,
            //     "number_cluster_Workers": number_cluster_Workers,
            // });

            // const test20220703 = MongoDBClient.db("testWebData").collection("test20220703"); // 鏈接指定數據庫中包含的指定集合（表格）：
            // // 插入;
            // test20220703.insertOne(
            //     { "site": "runoob.com" },
            //     function (error, result) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (result) {
            //             console.log(result);
            //             // return 0;
            //         };
            //     }
            // );
            // test20220703.insertMany(
            //     [
            //         { "site": "runoob.com" },
            //         { "site": "w3cschool.com" },
            //         { "site": "mongodb.com" }
            //     ],
            //     function (error, result) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (result) {
            //             console.log(result);
            //             // return 0;
            //         };
            //     }
            // );
            // // 查詢;
            // test20220703.find({ "site": "runoob.com" }).toArray(
            //     function (error, result) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (result) {
            //             console.log(result);
            //             // return 0;
            //         };
            //     }
            // );
            // // 查詢數據條目數量;
            // MongoDBClient.db("testWebData").collection("test20220703").countDocuments(
            //     {"column_1":"a-1"},
            //     { maxTimeMS: 5000 },
            //     function (error, result) {
            //         console.log(result);
            //     }
            // );
            // // 修改;
            // test20220703.updateOne(
            //     { "site": "runoob.com" },
            //     { $set: { "site": "example.com" } },
            //     function (error, result) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (result) {
            //             console.log(result);
            //             // return 0;
            //         };
            //     }
            // );
            // test20220703.updateMany(
            //     { "site": "runoob.com" },
            //     { $set: { "site": "example.com" } },
            //     function (error, result) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (result) {
            //             console.log(result);
            //             // return 0;
            //         };
            //     }
            // );
            // // 刪除;
            // test20220703.deleteMany(
            //     { "site": "example.com" },
            //     function (error, obj) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (obj) {
            //             console.log(obj);
            //             // return 0;
            //         };
            //     }
            // );
            // test20220703.deleteMany(
            //     { "site": "example.com" },
            //     function (error, obj) {
            //         if (error) {
            //             console.log(error);
            //             // return 1;
            //         };
            //         if (result) {
            //             console.log(obj.result.n + " 條數據被刪除.");
            //             MongoDBClient.close();
            //             // return 0;
            //         };
            //     }
            // );

            // MongoDBClient.close();
            // return 0;
        };
    }
);


// // 使用示例：
// // 一、控制臺啓動 MongoDB 數據庫服務器端程序;
// // C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
// // 二、控制臺啓動自定義的鏈接 MongoDB 數據庫的 http 服務器;
// // C:\Criss\DatabaseServer\MongoDB>C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:\Criss\DatabaseServer\MongoDB\Nodejs2MongodbServer.js host=0.0.0.0 port=27016 number_cluster_Workers=0 Key=username:password MongodbHost=0.0.0.0 MongodbPort=27017 dbUser=administrator dbPass=administrator dbName=testWebData
// // 三、使用自定義的 http 客戶端（Client）程序，鏈接自定義的 http 服務器，進而通過 http 服務器操控 MongoDB 數據庫服務端程序;
// let post_Data_JSON_1 = {"Column_1" : "b-1", "Column_2" : "一級", "Column_3" : "b-1-1", "Column_4" : "二級", "Column_5" : "b-1-2", "Column_6" : "二級", "Column_7" : "b-1-3", "Column_8" : "二級", "Column_9" : "b-1-4", "Column_10" : "二級", "Column_11" : "b-1-5", "Column_12" : "二級"};
// let post_Data_JSON_2 = {"Column_1" : "c-1", "Column_2" : "一級", "Column_3" : "c-1-1", "Column_4" : "二級", "Column_5" : "c-1-2", "Column_6" : "二級", "Column_7" : "c-1-3", "Column_8" : "二級", "Column_9" : "c-1-4", "Column_10" : "二級", "Column_11" : "c-1-5", "Column_12" : "二級"};
// // let post_Data_String = JSON.stringify(post_Data_JSON_1);
// let Host = "localhost";
// let Port = "27016";
// let dbUser = 'admin_testWebData';  // ['root:root', 'administrator:administrator', 'admin_testWebData:admin', 'user_testWebData:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
// let dbPass = 'admin';  // ['root:root', 'administrator:administrator', 'admin_testWebData:admin', 'user_testWebData:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
// // let UserPass = dbUser.concat(":", dbPass);  // 'admin_test20220703:admin';  // ['root:root', 'administrator:administrator', 'admin_testWebData:admin', 'user_testWebData:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
// let dbName = 'testWebData';  // ['admin', 'testWebData'];  // 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，Mongodb 要求數據庫名稱首字母必須為大寫單數;
// // MongodbUrl = "mongodb://admin_test20220703:admin@127.0.0.1:27017/testWebData?connect=direct&slaveOk=true&safe=true&w=2&wtimeoutMS=2000";
// let dbTableName = 'test20220703';  // ['test20220703'];  // MongoDB 數據庫包含的數據集合（表格）;
// let Key = "username:password";  // 自定義的訪問網站簡單驗證用戶名和密碼;
// let CURD = "/insertMany";  // "/insertOne", "/insertMany", "/find", "/deleteOne", "/deleteMany", "/updateOne", "/updateMany";
// let URL = `${CURD}?dbName=${dbName}&dbTableName=${dbTableName}&dbUser=${dbUser}&dbPass=${dbPass}&Key=${Key}`; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// // URL = "/insertOne?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// // let post_Data_String = JSON.stringify(post_Data_JSON_1);
// // // URL = "/insertMany?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let post_Data_String = JSON.stringify([post_Data_JSON_1,post_Data_JSON_2]);
// // URL = "/deleteOne?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// // let post_Data_String = JSON.stringify(post_Data_JSON_1);
// // // URL = "/updateOne?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// // let post_Data_String = JSON.stringify([post_Data_JSON_1, post_Data_JSON_2]);
// // // URL = "/find?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// // let post_Data_String = JSON.stringify(post_Data_JSON_1);
// // // URL = "/countDocuments?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// // let post_Data_String = JSON.stringify(post_Data_JSON_1);
// // 向服務器運行目錄替換或寫入指定名稱的文檔;
// // URL = "/uploadFile?Key=username:password&fileName=/Nodejs2MongodbServer.js"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let Method = "POST";  // "GET"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = "username:password";
// let request_Cookie = "Session_ID=request_Key->username:password";
// request_Cookie = request_Cookie.split("=")[0].concat("=", base64.encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(base64.encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
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
//     // let response_status_String = response[0];
//     // console.log(response_status_String);
//     // let response_head_String = response[1];
//     // console.log(response_head_String);
//     let response_body_String = response[2];
//     console.log(response_body_String);
//     // response_body_String === '{"time":"2022-61-11 20:45:55.681","request_url":"/find?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password","request_POST":"","Server_Authorization":"username:password","Database_say":"[{\"_id\":\"62c1a23ad6502f61e890a061\",\"Column_1\":\"a-1\",\"Column_2\":\"一級\",\"Column_3\":\"a-1-1\",\"Column_4\":\"二級\",\"Column_5\":\"a-1-2\",\"Column_6\":\"二級\",\"Column_7\":\"a-1-3\",\"Column_8\":\"二級\",\"Column_9\":\"a-1-4\",\"Column_10\":\"二級\",\"Column_11\":\"a-1-5\",\"Column_12\":\"二級\"},{\"_id\":\"62c1a2c7d6502f61e890a062\",\"Column_1\":\"a-1\",\"Column_2\":\"一級\",\"Column_3\":\"\",\"Column_4\":\"\",\"Column_5\":\"\",\"Column_6\":\"\",\"Column_7\":\"\"\"Column_8\":\"\",\"Column_9\":\"\",\"Column_10\":\"\",\"Column_11\":\"\",\"Column_12\":\"\"}]","request_Authorization":"username:password","request_Cookie":"Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk"}';
//     // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
//     let data_JSON = {};
//     if (isStringJSON(response_body_String)) {
//         data_JSON = JSON.parse(response_body_String);
//         // data_JSON === {
//         //     "request_url": request.url,
//         //     "request_POST": request_POST_String,
//         //     "request_Authorization": request.headers["authorization"],  // "username:password";
//         //     "Server_Authorization": Key,  // "username:password";
//         //     "request_Cookie": request.headers["cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
//         //     "Database_say": '[{"_id":"62c1a23ad6502f61e890a061","Column_1":"a-1","Column_2":"一級","Column_3":"a-1-1","Column_4":"二級","Column_5":"a-1-2","Column_6":"二級","Column_7":"a-1-3","Column_8":"二級","Column_9":"a-1-4","Column_10":"二級","Column_11":"a-1-5","Column_12":"二級"},{"_id":"62c1a2c7d6502f61e890a062","Column_1":"a-1","Column_2":"一級","Column_3":"","Column_4":"","Column_5":"","Column_6":"","Column_7":"","Column_8":"","Column_9":"","Column_10":"","Column_11":"","Column_12":""}]',
//         //     "time": "2021-02-03 20:21:25.136"
//         // };
//     };
//     // console.log("Database_say:" + "\\n" + data_JSON["Database_say"]);
//     console.log("Database_say:\n", JSON.parse(data_JSON["Database_say"]));
// });
