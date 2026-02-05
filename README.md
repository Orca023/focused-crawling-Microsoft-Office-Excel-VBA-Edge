## Focused Crawling
#### web power automate using Microsoft Office Excel Visual Basic for Applications ( VBA ) drive Edge browser.
#### focused crawling using Microsoft Office Excel Visual Basic for Applications ( VBA ) drive Edge browser.
#### Microsoft Office Excel Professional 2019 x86_64
#### Microsoft Edge x86_64 version 126.0.2592.102 ( version > 103.0.1264.71 )
#### 使用微軟電子表格宏 Excel-VBA 驅動 Edge 瀏覽器, 自動化操作網頁讀取資訊, 網頁定向爬蟲工具.
#### 可自定義擴展新增適配目標頁面網址.
---

<p word-wrap: break-word; word-break: break-all; overflow-x: hidden; overflow-x: hidden;></p>

項目使用了微軟電子表格 ( Windows - Office - Excel - Visual Basic for Applications ) 應用的第三方擴展 :  `clsBrowser.cls` , `clsCore.cls` , `clsJsConverter.cls` 三個類模組，由 codeproject 網站發佈取得.

[第三方擴展類模組提供網站 codeproject 裏的 Automate Chrome or Edge using VBA 庫 ( Tips ) 官方説明頁](https://www.codeproject.com/Tips/5307593/Automate-Chrome-Edge-using-VBA): 
https://www.codeproject.com/Tips/5307593/Automate-Chrome-Edge-using-VBA

項目使用了微軟電子表格 ( Windows - Office - Excel - Visual Basic for Applications ) 應用的第三方擴展 :  `JsonConverter.bas` 模組，由 GitHub 網站倉庫 ( Repository ) : VBA-JSON 發佈取得.

[相互轉換 JSON 字符串與 Excel-VBA-Dict 對象 ( Object ) 使用的第三方擴展類模組 VBA-JSON 官方 GitHub 網站倉庫頁](https://github.com/VBA-tools/VBA-JSON): 
https://github.com/VBA-tools/VBA-JSON.git

---

一. 確保 Microsoft Window10 系統的 Edge 瀏覽器已全部關閉, 啓動 Microsoft Office Excel 應用.

二. 手動操作 Microsoft Excel 應用, 載入文件夾 `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/` 裏的 Microsoft Excel VBA 類模組 ( Class Modul ) : `clsBrowser.cls` , `clsCore.cls` , `clsJsConverter.cls`

三. 手動操作 Microsoft Excel 應用, 載入文件夾 `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/` 裏的 Microsoft Excel VBA 窗體 ( Form ) : `CrawlerControlPanel.frm` , `CrawlerControlPanel.frx`

四. 手動操作 Microsoft Excel 應用, 載入文件夾 `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/` 裏的 Microsoft Excel VBA 模組 ( Module ) : `CrawlerDispatchModule.bas`

五. 手動操作 Microsoft Excel 應用, 載入文件夾 `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/` 裏的 Microsoft Excel VBA 模組 ( Module ) : `testCrawlerModule.bas`

六. 手動操作 Microsoft Excel 應用, 載入文件夾 `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/` 裏的 Microsoft Excel VBA 對象 ( Object ) : `ThisWorkbook.cls`

七. 啓動運行測試網站 :  `root@localhost:~# /bin/node ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/server.js`

八. 運行 Microsoft Excel VBA 宏擴展應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 選擇 `test` 選項, 從 Microsoft Excel 應用的「`加載項 ( add-in )`」菜單裏, 選擇 : 「 `Focused Crawling` 」 → 「 `operation panel` 」 → 「 `test` 」, 加載顯示 `test` 人機交互介面.

九. 測試 Microsoft Excel VBA 宏擴展應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 操控讀取測試網站 `testWeb` 頁面顯示的資訊, 將讀取結果存儲在電子表格 ( Microsoft Excel ) 指定位置.

---

項目空間裏的電子表格 Microsoft Excel 檔 : 「 `Crawler.xlsm` 」 已經載入 :

第三方類模組 ( Class Modul ) : `clsBrowser.cls` , `clsCore.cls` , `clsJsConverter.cls`

窗體 ( Form ) : `CrawlerControlPanel.frm` , `CrawlerControlPanel.frx`

模組 ( Module ) : `CrawlerDispatchModule.bas` , `testCrawlerModule.bas`

對象 ( Object ) : `ThisWorkbook.cls`

可直接從 Microsoft Excel 應用的「`加載項 ( add-in )`」菜單裏, 選擇 : 「 `Focused Crawling` 」 → 「 `operation panel` 」 → 「 `test` 」, 加載顯示 `test` 人機交互介面.

祇需啓動運行測試網站 :  `root@localhost:~# /bin/node ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/server.js`

之後即可測試 Microsoft Excel VBA 宏擴展應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 操控讀取測試網站 `testWeb` 頁面顯示的資訊, 將讀取結果存儲在電子表格 ( Microsoft Excel ) 指定位置.

---

使用微軟電子表格 Microsoft Excel VBA 驅動瀏覽器 Microsoft Edge 宏應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 説明 :

1. 項目架構執行序 :

   1). 啓動 Microsoft Office Excel Professional 2019 應用, 電子表格 Excel 應用會自動運行已載入的模組 ( Module ) 和類模組 ( Class Modul ), 其中載入的調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 裏的自定義過程 ( Subroutine ) : `MenuSetup()` 會修改電子表格 Excel 的菜單欄 ( Menu Bar ) 向「 `加載項 ( add-in )` 」菜單下寫入自定義的 Microsoft Excel VBA 宏擴展應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 標簽.

   2).     單擊電子表格 Excel 「 `加載項 ( add-in )` 」菜單 ( Menu ) 下 Microsoft Excel VBA 宏擴展應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 標簽, 首先執行的是調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ).

   3). 調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 調用操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ), 並讀取操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 裏的自定義配置參數值.

   4). 同時, 調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 調用窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ), 並根據操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 裏的自定義配置參數值, 爲窗體 ( Form ) 介面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 賦初值, 窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 是人機交互介面.

   5). 手動操控窗體 ( Form ) 介面使用瀏覽器 Microsoft Edge 打開待讀取資訊的目標網站頁面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/` ).

   6). 首先, 窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 調用操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ).

   7). 然後, 操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 引用第三方類模組 ( Class Modul ) : ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsBrowser.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsCore.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsJsConverter.cls` ).

   8). 最後, 第三方類模組 ( Class Modul ) : ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsBrowser.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsCore.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsJsConverter.cls` ) 會驅動瀏覽器 Microsoft Edge 加載打開目標網站頁面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/` ).

   9). 手動操控窗體 ( Form ) 介面, 啓動循環操控瀏覽器 Microsoft Edge 並讀取載入的目標網站頁面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/` ) 裏顯示的資訊.

   10). 首先, 窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 調用操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ).

   11). 然後, 操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 引用第三方類模組 ( Class Modul ) : ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsBrowser.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsCore.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsJsConverter.cls` ).

   12). 然後, 第三方類模組 ( Class Modul ) : ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsBrowser.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsCore.cls` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/clsJsConverter.cls` ) 會驅動瀏覽器 Microsoft Edge 翻頁, 並讀取載入的目標網站頁面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/` ) 顯示的資訊.

   13). 然後, 操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 將讀取到的資訊, 回饋至窗體 ( Form ) 介面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 動態提示運行狀態.

   14). 同時, 操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 讀取窗體 ( Form ) 介面 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 裏自定義的保存位置參數值.

   15). 最後, 操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 根據自定義的保存位置參數值, 將讀取到的資訊, 寫入電子表格 Excel 指定的位置存儲.

2. 項目將自定義的操作模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 作爲獨立的一個模組 ( Module ) 設計, 目的是, 與調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 分開, 解耦合, 這樣便於日後維護擴展功能, 增加更多元的操控介面, 使之可選擇的, 適用於讀取更多目標網站頁面裏顯示的資訊.

   同樣的, 項目將調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 作爲獨立的一個模組 ( Module ) 設計, 與窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 分開, 其目的也是爲了, 解耦合, 便於日後維護擴展功能, 增加更多元的操控介面, 使之可選擇的, 適用於讀取更多目標網站頁面裏顯示的資訊.

   若不考慮日後的功能擴展, 可取消獨立的調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 設計, 將之全部功能, 整合入窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 裏, 這樣可降低項目架構的複雜性, 更易於理解.

3. 若想擴展功能, 增加更多元的操控介面, 使之可選擇的, 適用於讀取更多目標網站頁面, 可新增複製 `test/` 文件夾並重新命名, 保存路徑位於 `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/` 文件夾裏, 重新命名並自定義修改文件夾 `test/` 裏的模組 ( Module ) : `testCrawlerModule.bas` , 根據需要自定義修改設計編寫代碼脚本即可, 這一操作的目的, 是爲實現新增一組操作介面的效果, 例如像 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 類似的.

   并且, 需要修改調度模組 ( Module ) ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerDispatchModule.bas` ) 裏的代碼, 使其可以正確找到調用自定義擴展新增的操作模組 ( Module ) 並正確的讀取適配合規的自定義擴展新增的配置參數初值, 例如像 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 類似的.

   并且, 需要修改窗體 ( Form ) 對象 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frx` ) , ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerControlPanel.frm` ) 裏的代碼, 使其可以正確適配合規的顯示自定義擴展新增的模組 ( Module )的配置參數值, 作爲人機交互介面, 可以正確的操控自定義擴展新增的模組 ( Module ) 引用第三方類模組 ( Class Modul ) : `clsBrowser.cls` , `clsCore.cls` , `clsJsConverter.cls` 驅動 Microsoft Edge 瀏覽器, 例如像 ( `./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/testCrawlerModule.bas` ) 類似的.

4. 項目空間裏的文件夾 `testWeb` 祇是一組用於配合測試電子表格 Microsoft Excel VBA 驅動瀏覽器 Microsoft Edge 宏應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 框架基礎功能的網站頁面, 主要用於開發階段的測試之用, 當 `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 的策略介面選擇 `test` 選項加載顯示 `test` 人機交互介面時, 才需要啓動運行 `testWeb` 伺服器, 定型之後生產階段則不再需要; 若不需要測試框架基礎功能, 可將文件夾 `testWeb` 刪除, 不會影響 電子表格 Microsoft Excel VBA 驅動瀏覽器 Microsoft Edge 宏應用 : `focused-crawling-Microsoft-Office-Excel-VBA-Edge` 的功能.

   伺服器 testWeb 運行需要 Node.js 環境, 所以運行之前, 需對作業系統 ( Operating System ) 安裝配置 Node.js 環境成功方可.

   可在 Linux-Ubuntu 系統的控制臺命令列人機交互介面窗口 ( Ubuntu-bash ) 使用如下指令, 安裝配置 Node.js 環境 :
   ```
   root@localhost:~# sudo apt install nodejs
   root@localhost:~# sudo apt install npm
   ```
   可在 Linux-Ubuntu 系統的控制臺命令列人機交互介面窗口 ( Ubuntu-bash ) 使用如下指令, 啓動運行 testWeb 伺服器 :
   ```
   root@localhost:~# /bin/node ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/server.js
   ```

![]()

---

Operating System :

Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

---

Application :

Microsoft Office Excel Professional 2019 x86_64

Browser :

Microsoft Internet Explorer ( Trident ) x86_64 version 11

Microsoft Edge ( Chromium - Blink ) x86_64 version 126.0.2592.102

Google Chrome ( Chromium - Blink ) x86_64 version 126.0.6478.127

Mozilla Firefox ( Gecko ) x86_64 version 128.0 2024/07/09

Interpreter :

Node.js - version 20.15.0

npm - version 10.7.0

---

Application : Microsoft Office Excel Professional 2019

[作業系統 ( Operating system ) 之 Microsoft Windows 官方網站](https://www.microsoft.com/zh-tw/windows): 
https://www.microsoft.com/zh-tw/windows

[電子表格應用 Microsoft Office Excel 官方下載頁](https://www.microsoft.com/zh-tw/download/office): 
https://www.microsoft.com/zh-tw/download/office

[電子表格應用 Microsoft Office Excel 2019 官方説明頁](https://learn.microsoft.com/zh-tw/deployoffice/office2019/overview): 
https://learn.microsoft.com/zh-tw/deployoffice/office2019/overview

微軟電子表格 ( Windows - Office - Excel - Visual Basic for Applications ) 應用，轉換 JSON 字符串類型的變量 ( JSON - String Object ) 與微軟電子表格字典類型的變量 ( Windows - Office - Excel - Visual Basic for Applications - Dict Object ) 數據類型，通過借用微軟電子表格 ( Windows - Office - Excel - Visual Basic for Applications ) 應用的第三方擴展類模組「VBA-JSON」實現.

[相互轉換 JSON 字符串與 Excel-VBA-Dict 對象 ( Object ) 使用的第三方擴展類模組 VBA-JSON 官方 GitHub 網站倉庫](https://github.com/VBA-tools/VBA-JSON): 
https://github.com/VBA-tools/VBA-JSON.git

微軟電子表格 ( Windows - Office - Excel - Visual Basic for Applications ) 應用，操作 Windows - Edge , Google - Chrome , Mozilla - Firebox 瀏覽器, 通過借用 codeproject 網站提供的，微軟電子表格 ( Windows - Office - Excel - Visual Basic for Applications ) 應用的第三方擴展類模組 : clsBrowser.cls , clsCore.cls , clsJsConverter.cls 實現，官方網站 ( codeproject ) 的地址 ( Uniform Resource Locator , URL ) 如下 :

[第三方擴展類模組提供網站 codeproject 裏的 Automate Chrome or Edge using VBA 庫 ( Tips ) 官方説明頁](https://www.codeproject.com/Tips/5307593/Automate-Chrome-Edge-using-VBA): 
https://www.codeproject.com/Tips/5307593/Automate-Chrome-Edge-using-VBA

[第三方擴展類模組 Chromium-Automation-with-CDP-for-VBA 官方 GitHub 網站倉庫](https://github.com/longvh211/Chromium-Automation-with-CDP-for-VBA): 
https://github.com/longvh211/Chromium-Automation-with-CDP-for-VBA.git

[第三方擴展類模組 Edge-IE-Mode-Automation-with-IES-for-VBA 官方 GitHub 網站倉庫](https://github.com/longvh211/Edge-IE-Mode-Automation-with-IES-for-VBA): 
https://github.com/longvh211/Edge-IE-Mode-Automation-with-IES-for-VBA.git

Browser : Microsoft Internet Explorer ( Trident )

[瀏覽器 ( Browser ) 之 Microsoft Internet Explorer 下載官方網站](https://www.microsoft.com/en-za/download/internet-explorer.aspx): 
https://www.microsoft.com/en-za/download/internet-explorer.aspx

Browser : Microsoft Edge ( Chromium - Blink )

[瀏覽器 ( Browser ) 之 Microsoft Edge 官方 GitHub 網站賬戶](https://github.com/MicrosoftEdge/): 
https://github.com/MicrosoftEdge/

[瀏覽器 ( Browser ) 之 Microsoft Edge 官方手冊 GitHub 網站倉庫](https://github.com/MicrosoftEdge/MSEdgeExplainers): 
https://github.com/MicrosoftEdge/MSEdgeExplainers.git

[瀏覽器 ( Browser ) 之 Microsoft Edge 下載官方網站](https://www.microsoft.com/zh-tw/edge/download?form=MA13FJ): 
https://www.microsoft.com/zh-tw/edge/download?form=MA13FJ

[瀏覽器 ( Browser ) 之 Microsoft Edge 驅動 ( Driver ) 下載官方網站](https://developer.microsoft.com/zh-tw/microsoft-edge/tools/webdriver/?form=MA13LH): 
https://developer.microsoft.com/zh-tw/microsoft-edge/tools/webdriver/?form=MA13LH

Browser : Google Chrome ( Chromium - Blink )

[瀏覽器 ( Browser ) 之 Google Chrome 官方 GitHub 網站賬戶](https://github.com/GoogleChrome): 
https://github.com/GoogleChrome

[瀏覽器 ( Browser ) 之 Google Chrome 擴展插件 (Extensions) 開發官方示例 GitHub 網站倉庫](https://github.com/GoogleChrome/chrome-extensions-samples): 
https://github.com/GoogleChrome/chrome-extensions-samples.git

[瀏覽器 ( Browser ) 之 Google Chrome 下載官方網站](https://www.google.com/intl/zh-TW/chrome/dev/?standalone=1): 
https://www.google.com/intl/zh-TW/chrome/dev/?standalone=1

[瀏覽器 ( Browser ) 之 Google Chrome ( Chromium ) 開發人員版 ( dev ) 下載中文網站](https://www.google.cn/intl/zh-TW/chrome/dev/?standalone=1&system=true&statcb=1&installdataindex=empty&defaultbrowser=0): 
https://www.google.cn/intl/zh-TW/chrome/dev/?standalone=1&system=true&statcb=1&installdataindex=empty&defaultbrowser=0

[瀏覽器 ( Browser ) 之 Google Chrome 驅動 ( Driver ) 下載官方網站](https://chromedriver.storage.googleapis.com/index.html): 
https://chromedriver.storage.googleapis.com/index.html

[瀏覽器 ( Browser ) 之 Google Chrome 驅動 ( Driver ) 下載官方網站淘寶網鏡像源](https://npm.taobao.org/mirrors/chromedriver): 
https://npm.taobao.org/mirrors/chromedriver

Browser : Mozilla Firefox ( Gecko )

[瀏覽器 ( Browser ) 之 Mozilla Firefox 官方 GitHub 網站賬戶](https://github.com/mozilla): 
https://github.com/mozilla

[瀏覽器 ( Browser ) 之 Mozilla Firefox 官方 GitHub 網站倉庫](https://github.com/mozilla/gecko-dev): 
https://github.com/mozilla/gecko-dev.git

[瀏覽器 ( Browser ) 之 Mozilla Firefox 下載官方網站](https://www.mozilla.org/zh-TW/firefox/): 
https://www.mozilla.org/zh-TW/firefox/

[瀏覽器 ( Browser ) 之 Mozilla Firefox 驅動 ( Driver ) 官方 GitHub 網站倉庫](https://github.com/mozilla/geckodriver): 
https://github.com/mozilla/geckodriver.git

[瀏覽器 ( Browser ) 之 Mozilla Firefox 驅動 ( Driver ) 預編譯二進位檔官方 GitHub 網站倉庫](https://github.com/mozilla/geckodriver/releases): 
https://github.com/mozilla/geckodriver/releases

[瀏覽器 ( Browser ) 之 Mozilla Firefox 驅動 ( Driver ) 官方説明頁](https://firefox-source-docs.mozilla.org/testing/geckodriver/): 
https://firefox-source-docs.mozilla.org/testing/geckodriver/

Interpreter : Node.js

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方網站](https://node.js.org/): 
https://node.js.org/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方網站](https://nodejs.org/en/): 
https://nodejs.org/en/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方下載頁](https://nodejs.org/en/download/package-manager): 
https://nodejs.org/en/download/package-manager

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方 GitHub 網站賬戶](https://github.com/nodejs): 
https://github.com/nodejs

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方 GitHub 網站倉庫](https://github.com/nodejs/node): 
https://github.com/nodejs/node.git

Interpreter : Python

[程式設計 Python 語言解釋器 ( Interpreter ) 官方網站](https://www.python.org/): 
https://www.python.org/

[程式設計 Python 語言解釋器 ( Interpreter ) 官方下載頁](https://www.python.org/downloads/): 
https://www.python.org/downloads/

[程式設計 Python 語言解釋器 ( Interpreter ) 官方 GitHub 網站賬戶](https://github.com/python): 
https://github.com/python

[程式設計 Python 語言解釋器 ( Interpreter ) 官方 GitHub 網站倉庫頁](https://github.com/python/cpython): 
https://github.com/python/cpython.git

Database : Microsoft Access

[資料庫 Microsoft Access 應用軟體官方網站](https://www.microsoft.com/en-us/microsoft-365/access): 
https://www.microsoft.com/en-us/microsoft-365/access

[資料庫 Microsoft Access 應用軟體官方網站中文版](https://www.microsoft.com/zh-tw/microsoft-365/access): 
https://www.microsoft.com/zh-tw/microsoft-365/access

[資料庫 Microsoft Access 應用軟體官方手冊](https://learn.microsoft.com/en-us/office/vba/api/overview/access): 
https://learn.microsoft.com/en-us/office/vba/api/overview/access

[資料庫 Microsoft Access 應用軟體官方手冊中文版](https://learn.microsoft.com/zh-tw/office/vba/api/overview/access): 
https://learn.microsoft.com/zh-tw/office/vba/api/overview/access

---

瀏覽器 ( Browser : Microsoft Internet Explorer , Microsoft Edge , Google Chrome , Mozilla Firefox ) 和解釋器 ( Interpreter : Node.js ) 預編譯二進制可執行檔 [百度網盤(pan.baidu.com)](https://pan.baidu.com/s/1IXjbZBRkurrNRs0GoURCaA?pwd=1dm7) 下載頁: 
https://pan.baidu.com/s/1IXjbZBRkurrNRs0GoURCaA?pwd=1dm7

提取碼：1dm7

開箱即用 ( out of the box ) ( portable application ) 檔 :

1. 壓縮檔 : `Nodejs-22.20.0-Window10-AMD_FX8800P_x86_64.7z`

壓縮檔「`Nodejs-22.20.0-Window10-AMD_FX8800P_x86_64.7z`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 程式設計語言 ( JavaScript ) 解釋器 ( Interpreter ) 二進位可執行檔 ( node-v22.20.0-x64.msi ) 開箱即用 ( out of the box ) ( portable application ) 免安裝版，需自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/Nodejs/` 内，最終完整路徑應爲「`focused-crawling-Microsoft-Office-Excel-VBA-Edge/Nodejs/Nodejs-22.20.0/node.exe`」

2. 壓縮檔 : `Python-3.11.2-Window10-AMD_FX8800P_x86_64.7z`

壓縮檔「`Python-3.11.2-Window10-AMD_FX8800P_x86_64.7z`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 程式設計語言 ( Python ) 解釋器 ( Interpreter ) 二進位可執行檔 ( python-3.11.2-amd64.exe ) 開箱即用 ( out of the box ) ( portable application ) 免安裝版，需自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/Python/` 内，最終完整路徑應爲「`focused-crawling-Microsoft-Office-Excel-VBA-Edge/Python/Python311/python.exe`」

3. 壓縮檔 : `NodejsToMongoDB-MongoDB_8.2.3-Window10-AMD_FX8800P_x86_64.zip`

壓縮檔「`NodejsToMongoDB-MongoDB_8.2.3-Window10-AMD_FX8800P_x86_64.zip`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 使用程式設計語言 ( computer programming language ) : JavaScript 鏈接操作 MongoDB 資料庫的伺服器 'NodejsToMongoDB' 開箱即用 ( out of the box ) ( portable application ) 版，已配置計算機程式設計語言 ( computer programming language ) : JavaScript 解釋器 ( Interpreter ) 運行此資料庫伺服器 'NodejsToMongoDB' 項目所需的第三方擴展模組 ( third-party extensions ( libraries or modules ) ) 的運行環境，可自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MongoDB/NodejsToMongoDB/` 内，再因應協調配置壓縮檔「`Nodejs-22.20.0-Window10-AMD_FX8800P_x86_64.7z`」之後，即可使用如下指令啓動運行資料庫伺服器「`NodejsToMongoDB`」項目 : 
```
C:\focused-crawling-Microsoft-Office-Excel-VBA-Edge\Data\MongoDB> C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Nodejs/Nodejs-22.20.0/node.exe C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MongoDB/NodejsToMongoDB/Nodejs2MongodbServer.js host=::0 port=27016 number_cluster_Workers=0 MongodbHost=[::1] MongodbPort=27017 dbUser=admin_Database1 dbPass=admin dbName=Database1
```

4. 壓縮檔 : `PythonToMariaDB-MariaDB10.11-Window10-AMD_FX8800P_x86_64.zip`

壓縮檔「`PythonToMariaDB-MariaDB10.11-Window10-AMD_FX8800P_x86_64.zip`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 使用程式設計語言 ( computer programming language ) : Python 鏈接操作 MariaDB 資料庫的伺服器 'PythonToMariaDB' 開箱即用 ( out of the box ) ( portable application ) 版，已配置計算機程式設計語言 ( computer programming language ) : Python 解釋器 ( Interpreter ) 運行此資料庫伺服器 'PythonToMariaDB' 項目所需的第三方擴展模組 ( third-party extensions ( libraries or modules ) ) 的運行環境，可自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MariaDB/PythonToMariaDB/` 内，再因應協調配置壓縮檔「`Python-3.11.2-Window10-AMD_FX8800P_x86_64.7z`」之後，即可使用如下指令啓動運行統計運算伺服器「'PythonToMariaDB`」項目 : 
```
C:\focused-crawling-Microsoft-Office-Excel-VBA-Edge\Data\MariaDB> C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MariaDB/PythonToMariaDB/Scripts/python.exe C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MariaDB/PythonToMariaDB/src/Python2MariaDBServer.py host=::0 port=27016 Is_multi_thread=False number_Worker_process=0 MongodbHost=[::1] MongodbPort=27017 dbUser=admin_Database1 dbPass=admin dbName=Database1
```
或者 : 
```
C:\focused-crawling-Microsoft-Office-Excel-VBA-Edge\Data\MariaDB> C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Python/Python311/python.exe C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MariaDB/PythonToMariaDB/src/Python2MariaDBServer.py host=::0 port=27016 Is_multi_thread=False number_Worker_process=0 MongodbHost=[::1] MongodbPort=27017 dbUser=admin_Database1 dbPass=admin dbName=Database1
```

5. 壓縮檔 : `Server-MongoDB_8.2.3-Window10-AMD_FX8800P_x86_64.zip`

壓縮檔「`Server-MongoDB_8.2.3-Window10-AMD_FX8800P_x86_64.zip`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 資料庫應用 MongoDB 伺服器端二進位可執行啓動檔 'mongod.exe' 開箱即用 ( out of the box ) ( portable application ) 版運行環境，可自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/MongoDB/Server/` 内，最終完整路徑應爲「`focused-crawling-Microsoft-Office-Excel-VBA-Edge/MongoDB/Server/8.2/bin/mongod.exe`」，即可使用如下指令啓動運行資料庫 MongoDB 伺服器應用 : 
```
C:\focused-crawling-Microsoft-Office-Excel-VBA-Edge\Data\MongoDB> C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/MongoDB/Server/8.2/bin/mongod.exe --config=C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MongoDB/NodejsToMongoDB/mongod.cfg
```

6. 壓縮檔 : `mongosh_2.6.0-Window10-AMD_FX8800P_x86_64.zip`

壓縮檔「`mongosh_2.6.0-Window10-AMD_FX8800P_x86_64.zip`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 資料庫應用 MongoDB 用戶端二進位可執行啓動檔 'mongosh.exe' 開箱即用 ( out of the box ) ( portable application ) 版運行環境，可自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/MongoDB/mongosh/` 内，最終完整路徑應爲「`focused-crawling-Microsoft-Office-Excel-VBA-Edge/MongoDB/mongosh/mongosh.exe`」，即可使用如下指令啓動運行資料庫 MongoDB 用戶端應用 : 
```
C:\focused-crawling-Microsoft-Office-Excel-VBA-Edge\Data\MongoDB> C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/MongoDB/mongosh/mongosh.exe mongodb://username:password@[::1]:27017/Database1
```

7. 壓縮檔 : `data-MongoDB_8.2.3-Window10-AMD_FX8800P_x86_64.zip`

壓縮檔「`data-MongoDB_8.2.3-Window10-AMD_FX8800P_x86_64.zip`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 資料庫應用 MongoDB 伺服器端自定義創建的名爲 'Database1' 資料庫 ( Database ) , 内含名爲 'Collection1' 自定義數據集 ( Collection/Table ) , 開箱即用 ( out of the box ) ( portable application ) 版運行環境，可自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/Data/MongoDB/data/` 内，可使用資料庫 MongoDB 用戶端應用鏈接伺服器之後，操作處理增、刪、改、查資料集合.

8. 壓縮檔 : `MariaDB10.11-Window10-AMD_FX8800P_x86_64.zip`

壓縮檔「`MariaDB10.11-Window10-AMD_FX8800P_x86_64.zip`」爲微軟視窗作業系統 ( Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30 ) 資料庫應用 MariaDB 伺服器端二進位可執行啓動檔 'mysqld.exe' 開箱即用 ( out of the box ) ( portable application ) 版運行環境，可自行下載解壓縮，將其保存至檔案夾 ( folder ) : `focused-crawling-Microsoft-Office-Excel-VBA-Edge/MariaDB/MariaDB10.11/` 内，最終完整路徑應爲「`focused-crawling-Microsoft-Office-Excel-VBA-Edge/MariaDB/MariaDB10.11/bin/mysqld.exe`」，即可使用如下指令啓動運行資料庫 MongoDB 伺服器應用 : 
```
C:\focused-crawling-Microsoft-Office-Excel-VBA-Edge\Data\MariaDB> C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/MariaDB/MariaDB10.11/bin/mysqld.exe
```
即可.
