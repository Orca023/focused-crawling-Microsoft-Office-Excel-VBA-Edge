
window.document.getElementById("SkipPageButton").onclick = function () {

    let WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁";
    // console.log(WebPageNumberTextString);
    // let CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    let CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // let MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    let MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(MaximumPageNumber);

    let pageNumber = ["a", "b", "c", "d", "e"];

    let TargetPageNumber = parseInt(window.document.getElementById("SkipPageInput").value);
    if (TargetPageNumber > MaximumPageNumber) {
        TargetPageNumber = MaximumPageNumber;
        window.document.getElementById("SkipPageInput").value = String(TargetPageNumber);
    };
    if (TargetPageNumber < parseInt(1)) {
        TargetPageNumber = parseInt(1);
        window.document.getElementById("SkipPageInput").value = String(TargetPageNumber);
    };
    if (TargetPageNumber !== CurrentPageNumber && TargetPageNumber <= MaximumPageNumber && TargetPageNumber >= parseInt(1)) {
        let location_href = "./" + String(pageNumber[parseInt(TargetPageNumber) - parseInt(1)]) + ".html";
        window.location.replace(location_href);
    };
};

window.document.getElementById("QueryButton").onclick = function () {

    let KeyWord = String(window.document.getElementById("QueryInput").value);
    // alert("已經收到檢索關鍵詞：{ " + KeyWord + " }" + "\n" + "並已經點擊關鍵詞檢索按鈕.");

    let WebPageNumberTextString = String(window.document.getElementById("PageNumberLabel").innerHTML);  // "當前第 1 頁，縂 5 頁";
    // console.log(WebPageNumberTextString);
    // let CurrentPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[0]);
    let CurrentPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("頁")[0]).trim()).split("第")[1]).trim());  // 獲取到的載入當前頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
    // console.log(CurrentPageNumber);
    // let MaximumPageNumber = parseInt(WebPageNumberTextString.match(/[0-9]{1,10}/gim)[1]);
    let MaximumPageNumber = parseInt(String(String(String(WebPageNumberTextString.split("縂")[1]).trim()).split("頁")[0]).trim());  // 獲取到的允許載入最大頁碼值的存儲，函數 parseInt() 表示將字符串型變量强制轉換爲短整型變量，函數 String() 表示將數值變量强制轉換爲字符串型變量，函數 "P1".split("P2")[P3] 表示：對字符串“p1”按照指定字符“p2”為間隔符號分割為字符串數組，參數“p3”表示分割後得到的數組的指定索引，以 0 為起始；函數 “p1”.trim() 表示對字符串“p1”頭尾兩端去空格。
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
        let location_href = "./" + String(pageNumber[parseInt(TargetPageNumber) - parseInt(1)]) + ".html";
        window.location.replace(location_href);
    };
};
