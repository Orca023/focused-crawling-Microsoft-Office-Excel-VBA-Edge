
let WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
// console.log(WebPageNumberTextString);
// let CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
let CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
// console.log(CurrentPageNumber);
// let MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
let MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
// console.log(MaximumPageNumber);

// let pageNumber = ["a", "b", "c", "d", "e"];

function InputNext(TargetPage) {

    let firstDataArray = null;
    let secondDataArray = null;
    switch (TargetPage) {
        case "tr1": {
            switch (CurrentPageNumber) {
                case 1: {
                    secondDataArray = a1;
                    break;
                }
                case 2: {
                    secondDataArray = b1;
                    break;
                }
                case 3: {
                    secondDataArray = c1;
                    break;
                }
                case 4: {
                    secondDataArray = d1;
                    break;
                }
                case 5: {
                    secondDataArray = e1;
                    break;
                }
                default: {}
            };
            break;
        }
        case "tr2": {
            switch (CurrentPageNumber) {
                case 1: {
                    secondDataArray = a2;
                    break;
                }
                case 2: {
                    secondDataArray = b2;
                    break;
                }
                case 3: {
                    secondDataArray = c2;
                    break;
                }
                case 4: {
                    secondDataArray = d2;
                    break;
                }
                case 5: {
                    secondDataArray = e2;
                    break;
                }
                default: {}
            };
            break;
        }
        case "tr3": {
            switch (CurrentPageNumber) {
                case 1: {
                    secondDataArray = a3;
                    break;
                }
                case 2: {
                    secondDataArray = b3;
                    break;
                }
                case 3: {
                    secondDataArray = c3;
                    break;
                }
                case 4: {
                    secondDataArray = d3;
                    break;
                }
                case 5: {
                    secondDataArray = e3;
                    break;
                }
                default: {}
            };
            break;
        }
        case "tr4": {
            switch (CurrentPageNumber) {
                case 1: {
                    secondDataArray = a4;
                    break;
                }
                case 2: {
                    secondDataArray = b4;
                    break;
                }
                case 3: {
                    secondDataArray = c4;
                    break;
                }
                case 4: {
                    secondDataArray = d4;
                    break;
                }
                case 5: {
                    secondDataArray = e4;
                    break;
                }
                default: {}
            };
            break;
        }
        case "tr5": {
            switch (CurrentPageNumber) {
                case 1: {
                    secondDataArray = a5;
                    break;
                }
                case 2: {
                    secondDataArray = b5;
                    break;
                }
                case 3: {
                    secondDataArray = c5;
                    break;
                }
                case 4: {
                    secondDataArray = d5;
                    break;
                }
                case 5: {
                    secondDataArray = e5;
                    break;
                }
                default: {}
            };
            break;
        }
        default: {
            let TargetPageNumber = parseInt(TargetPage);
            if (TargetPageNumber > MaximumPageNumber) {
                TargetPageNumber = MaximumPageNumber;
            };
            if (TargetPageNumber < parseInt(1)) {
                TargetPageNumber = parseInt(1);
            };
            switch (TargetPageNumber) {
                case 1: {
                    firstDataArray = a;
                    break;
                }
                case 2: {
                    firstDataArray = b;
                    break;
                }
                case 3: {
                    firstDataArray = c;
                    break;
                }
                case 4: {
                    firstDataArray = d;
                    break;
                }
                case 5: {
                    firstDataArray = e;
                    break;
                }
                default: {}
            };
            window.document.getElementById("PageNumberLabel").innerHTML = "";
            window.document.getElementById("PageNumberLabel").innerHTML = "當前第 " + String(TargetPageNumber) + " 頁，縂 5 頁，第 1 級頁面";
            WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
            // console.log(WebPageNumberTextString);
            // CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
            CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
            // console.log(CurrentPageNumber);
            // MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
            MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
            // console.log(MaximumPageNumber);
        }
    };

    let tableByTagName = window.document.getElementsByTagName("table")[0];
    let tbodyByTagName = tableByTagName.children[0];
    let trByTagName = tbodyByTagName.children;
    if (firstDataArray !== null) {
        for (let i in firstDataArray) {
            let tdByTagName = trByTagName[i].children;
            for (let j in firstDataArray[i]) {
                // let Xpath_string = "";
                // if (parseInt(j) === parseInt(0)) {
                //     Xpath_string = "/html/body/div/centre/div/table/tbody/tr[" + String(parseInt(i) + parseInt(1)) + "]/td[" + String(parseInt(j) + parseInt(1)) + "]/a";
                //     if (window.document.evaluate(Xpath_string, window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0) === null) {
                //         window.document.evaluate("/html/body/div/centre/div/table/tbody/tr[" + String(parseInt(i) + parseInt(1)) + "]/td[" + String(parseInt(j) + parseInt(1)) + "]", window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).innerHTML = "";
                //         let tra = window.document.createElement("a");
                //         tra.setAttribute("id", "tr" + String(parseInt(i) + parseInt(1)) + "td" + String(parseInt(j) + parseInt(1)) + "a");
                //         tra.setAttribute("target", "_self");
                //         // tra.setAttribute("onclick", "javascript:InputNext('tr" + String(parseInt(i) + parseInt(1)) + "')");
                //         tra.innerText = String(firstDataArray[i][j]);
                //         window.document.evaluate("/html/body/div/centre/div/table/tbody/tr[" + String(parseInt(i) + parseInt(1)) + "]/td[" + String(parseInt(j) + parseInt(1)) + "]", window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).appendChild(tra);
                //         window.document.getElementById("tr" + String(parseInt(i) + parseInt(1)) + "td" + String(parseInt(j) + parseInt(1)) + "a").onclick = function () {
                //             InputNext("tr" + String(parseInt(i) + parseInt(1)));
                //         };
                //     };
                // };
                // if (parseInt(j) === parseInt(1)) {
                //     Xpath_string = "/html/body/div/centre/div/table/tbody/tr[" + String(parseInt(i) + parseInt(1)) + "]/td[" + String(parseInt(j) + parseInt(1)) + "]";
                // };
                // window.document.evaluate(Xpath_string, window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).innerHTML = "";
                // window.document.evaluate(Xpath_string, window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).innerHTML = String(firstDataArray[i][j]);

                tdByTagName[j].innerHTML = "";
                if (parseInt(j) === parseInt(0)) {
                    let tra = window.document.createElement("a");
                    tra.setAttribute("id", "tr" + String(parseInt(i) + parseInt(1)) + "td" + String(parseInt(j) + parseInt(1)) + "a");
                    tra.setAttribute("target", "_self");
                    // tra.setAttribute("onclick", "javascript:InputNext('tr" + String(parseInt(i) + parseInt(1)) + "')");
                    tra.innerText = String(firstDataArray[i][j]);
                    tra.onclick = function () {
                        InputNext("tr" + String(parseInt(i) + parseInt(1)));
                    };
                    tdByTagName[j].appendChild(tra);
                };
                if (parseInt(j) > parseInt(0)) {
                    tdByTagName[j].innerHTML = String(firstDataArray[i][j]);
                };
            };
        };
    };
    if (secondDataArray !== null) {
        for (let i in secondDataArray) {
            let tdByTagName = trByTagName[i].children;
            for (let j in secondDataArray[i]) {
                // let Xpath_string = "/html/body/div/centre/div/table/tbody/tr[" + String(parseInt(i) + parseInt(1)) + "]/td[" + String(parseInt(j) + parseInt(1)) + "]";
                // window.document.evaluate(Xpath_string, window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).innerHTML = "";
                // window.document.evaluate(Xpath_string, window.document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).innerHTML = String(secondDataArray[i][j]);

                tdByTagName[j].innerHTML = "";
                tdByTagName[j].innerText = String(secondDataArray[i][j]);
            };
        };
        window.document.getElementById("PageNumberLabel").innerHTML = "";
        window.document.getElementById("PageNumberLabel").innerText = "當前第 1 頁，縂 1 頁，第 2 級頁面";
        window.document.getElementById("returnFirstPageButton").style.display = "block";
    };
    tableByTagName = null;
    tbodyByTagName = null;
    trByTagName = null;
};

if (window.document.getElementById("tr1td1a") !== null) {
    window.document.getElementById("tr1td1a").onclick = function () {
        InputNext("tr1");
    };
};

if (window.document.getElementById("tr2td1a") !== null) {
    window.document.getElementById("tr2td1a").onclick = function () {
        InputNext("tr2");
    };
};

if (window.document.getElementById("tr3td1a") !== null) {
    window.document.getElementById("tr3td1a").onclick = function () {
        InputNext("tr3");
    };
};

if (window.document.getElementById("tr4td1a") !== null) {
    window.document.getElementById("tr4td1a").onclick = function () {
        InputNext("tr4");
    };
};

if (window.document.getElementById("tr5td1a") !== null) {
    window.document.getElementById("tr5td1a").onclick = function () {
        InputNext("tr5");
    };
};

window.document.getElementById("NextPageButton").onclick = function () {

    let TargetPageNumber = parseInt(parseInt(CurrentPageNumber) + parseInt(1));
    if (TargetPageNumber > MaximumPageNumber) {
        TargetPageNumber = MaximumPageNumber;
    };
    if (TargetPageNumber < parseInt(1)) {
        TargetPageNumber = parseInt(1);
    };
    if (TargetPageNumber !== CurrentPageNumber && TargetPageNumber <= MaximumPageNumber && TargetPageNumber >= parseInt(1)) {
        InputNext(String(TargetPageNumber));
    };
    WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
    // console.log(WebPageNumberTextString);
    // CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(MaximumPageNumber);
};

window.document.getElementById("BackPageButton").onclick = function () {

    let TargetPageNumber = parseInt(parseInt(CurrentPageNumber) - parseInt(1));
    if (TargetPageNumber > MaximumPageNumber) {
        TargetPageNumber = MaximumPageNumber;
    };
    if (TargetPageNumber < parseInt(1)) {
        TargetPageNumber = parseInt(1);
    };
    if (TargetPageNumber !== CurrentPageNumber && TargetPageNumber <= MaximumPageNumber && TargetPageNumber >= parseInt(1)) {
        InputNext(String(TargetPageNumber));
    };
    WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
    // console.log(WebPageNumberTextString);
    // CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(MaximumPageNumber);
};

window.document.getElementById("SkipPageButton").onclick = function () {

    let TargetPageNumber = parseInt(window.document.getElementById("SkipPageInput").value);
    if (TargetPageNumber > MaximumPageNumber) {
        TargetPageNumber = MaximumPageNumber;
        // window.document.getElementById("SkipPageInput").value = String(TargetPageNumber);
    };
    if (TargetPageNumber < parseInt(1)) {
        TargetPageNumber = parseInt(1);
        // window.document.getElementById("SkipPageInput").value = String(TargetPageNumber);
    };
    if (TargetPageNumber !== CurrentPageNumber && TargetPageNumber <= MaximumPageNumber && TargetPageNumber >= parseInt(1)) {
        InputNext(String(TargetPageNumber));
    };
    WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
    // console.log(WebPageNumberTextString);
    // CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(MaximumPageNumber);
};

window.document.getElementById("QueryButton").onclick = function () {

    let KeyWord = String(window.document.getElementById("QueryInput").value);
    // alert("已經收到檢索關鍵詞：{ " + KeyWord + " }" + "\n" + "並已經點擊關鍵詞檢索按鈕.");

    WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
    // console.log(WebPageNumberTextString);
    // CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(MaximumPageNumber);

    let pageNumber = ["a", "b", "c", "d", "e"];

    let TargetPageNumber = parseInt(Math.floor(Math.random() * (pageNumber.length - 1) + 1));
    // let TargetPageNumber = parseInt(window.document.getElementById("SkipPageInput").value);
    if (TargetPageNumber > MaximumPageNumber) {
        TargetPageNumber = MaximumPageNumber;
        // window.document.getElementById("SkipPageInput").value = String(TargetPageNumber);
    };
    if (TargetPageNumber < parseInt(1)) {
        TargetPageNumber = parseInt(1);
        // window.document.getElementById("SkipPageInput").value = String(TargetPageNumber);
    };

    if (TargetPageNumber !== CurrentPageNumber && TargetPageNumber <= MaximumPageNumber && TargetPageNumber >= parseInt(1)) {
        InputNext(String(TargetPageNumber));
    };

    WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁，第 1 級頁面";
    // console.log(WebPageNumberTextString);
    // CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(MaximumPageNumber);
};

window.document.getElementById("returnFirstPageButton").onclick = function () {
    InputNext(CurrentPageNumber);
    window.document.getElementById("returnFirstPageButton").style.display = "none";
};

let a = [
    ["a-1", "一級"],
    ["a-2", "一級"],
    ["a-3", "一級"],
    ["a-4", "一級"],
    ["a-5", "一級"]
];
let a1 = [
    ["a-1-1", "二級"],
    ["a-1-2", "二級"],
    ["a-1-3", "二級"],
    ["a-1-4", "二級"],
    ["a-1-5", "二級"]
];
let a2 = [
    ["a-2-1", "二級"],
    ["a-2-2", "二級"],
    ["a-2-3", "二級"],
    ["a-2-4", "二級"],
    ["a-2-5", "二級"]
];
let a3 = [
    ["a-3-1", "二級"],
    ["a-3-2", "二級"],
    ["a-3-3", "二級"],
    ["a-3-4", "二級"],
    ["a-3-5", "二級"]
];
let a4 = [
    ["a-4-1", "二級"],
    ["a-4-2", "二級"],
    ["a-4-3", "二級"],
    ["a-4-4", "二級"],
    ["a-4-5", "二級"]
];
let a5 = [
    ["a-5-1", "二級"],
    ["a-5-2", "二級"],
    ["a-5-3", "二級"],
    ["a-5-4", "二級"],
    ["a-5-5", "二級"]
];

let b = [
    ["b-1", "一級"],
    ["b-2", "一級"],
    ["b-3", "一級"],
    ["b-4", "一級"],
    ["b-5", "一級"]
];
let b1 = [
    ["b-1-1", "二級"],
    ["b-1-2", "二級"],
    ["b-1-3", "二級"],
    ["b-1-4", "二級"],
    ["b-1-5", "二級"]
];
let b2 = [
    ["b-2-1", "二級"],
    ["b-2-2", "二級"],
    ["b-2-3", "二級"],
    ["b-2-4", "二級"],
    ["b-2-5", "二級"]
];
let b3 = [
    ["b-3-1", "二級"],
    ["b-3-2", "二級"],
    ["b-3-3", "二級"],
    ["b-3-4", "二級"],
    ["b-3-5", "二級"]
];
let b4 = [
    ["b-4-1", "二級"],
    ["b-4-2", "二級"],
    ["b-4-3", "二級"],
    ["b-4-4", "二級"],
    ["b-4-5", "二級"]
];
let b5 = [
    ["b-5-1", "二級"],
    ["b-5-2", "二級"],
    ["b-5-3", "二級"],
    ["b-5-4", "二級"],
    ["b-5-5", "二級"]
];

let c = [
    ["c-1", "一級"],
    ["c-2", "一級"],
    ["c-3", "一級"],
    ["c-4", "一級"],
    ["c-5", "一級"]
];
let c1 = [
    ["c-1-1", "二級"],
    ["c-1-2", "二級"],
    ["c-1-3", "二級"],
    ["c-1-4", "二級"],
    ["c-1-5", "二級"]
];
let c2 = [
    ["c-2-1", "二級"],
    ["c-2-2", "二級"],
    ["c-2-3", "二級"],
    ["c-2-4", "二級"],
    ["c-2-5", "二級"]
];
let c3 = [
    ["c-3-1", "二級"],
    ["c-3-2", "二級"],
    ["c-3-3", "二級"],
    ["c-3-4", "二級"],
    ["c-3-5", "二級"]
];
let c4 = [
    ["c-4-1", "二級"],
    ["c-4-2", "二級"],
    ["c-4-3", "二級"],
    ["c-4-4", "二級"],
    ["c-4-5", "二級"]
];
let c5 = [
    ["c-5-1", "二級"],
    ["c-5-2", "二級"],
    ["c-5-3", "二級"],
    ["c-5-4", "二級"],
    ["c-5-5", "二級"]
];

let d = [
    ["d-1", "一級"],
    ["d-2", "一級"],
    ["d-3", "一級"],
    ["d-4", "一級"],
    ["d-5", "一級"]
];
let d1 = [
    ["d-1-1", "二級"],
    ["d-1-2", "二級"],
    ["d-1-3", "二級"],
    ["d-1-4", "二級"],
    ["d-1-5", "二級"]
];
let d2 = [
    ["d-2-1", "二級"],
    ["d-2-2", "二級"],
    ["d-2-3", "二級"],
    ["d-2-4", "二級"],
    ["d-2-5", "二級"]
];
let d3 = [
    ["d-3-1", "二級"],
    ["d-3-2", "二級"],
    ["d-3-3", "二級"],
    ["d-3-4", "二級"],
    ["d-3-5", "二級"]
];
let d4 = [
    ["d-4-1", "二級"],
    ["d-4-2", "二級"],
    ["d-4-3", "二級"],
    ["d-4-4", "二級"],
    ["d-4-5", "二級"]
];
let d5 = [
    ["d-5-1", "二級"],
    ["d-5-2", "二級"],
    ["d-5-3", "二級"],
    ["d-5-4", "二級"],
    ["d-5-5", "二級"]
];

let e = [
    ["e-1", "一級"],
    ["e-2", "一級"],
    ["e-3", "一級"],
    ["e-4", "一級"],
    ["e-5", "一級"]
];
let e1 = [
    ["e-1-1", "二級"],
    ["e-1-2", "二級"],
    ["e-1-3", "二級"],
    ["e-1-4", "二級"],
    ["e-1-5", "二級"]
];
let e2 = [
    ["e-2-1", "二級"],
    ["e-2-2", "二級"],
    ["e-2-3", "二級"],
    ["e-2-4", "二級"],
    ["e-2-5", "二級"]
];
let e3 = [
    ["e-3-1", "二級"],
    ["e-3-2", "二級"],
    ["e-3-3", "二級"],
    ["e-3-4", "二級"],
    ["e-3-5", "二級"]
];
let e4 = [
    ["e-4-1", "二級"],
    ["e-4-2", "二級"],
    ["e-4-3", "二級"],
    ["e-4-4", "二級"],
    ["e-4-5", "二級"]
];
let e5 = [
    ["e-5-1", "二級"],
    ["e-5-2", "二級"],
    ["e-5-3", "二級"],
    ["e-5-4", "二級"],
    ["e-5-5", "二級"]
];
