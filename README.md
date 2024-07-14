## Focused Crawling
#### web power automate using Microsoft Office Excel VBA drive Edge browser.
#### focused crawling using Microsoft Office Excel VBA drive Edge browser.
#### Microsoft Office Professional 2019
#### 使用微軟電子表格宏 Excel-VBA 驅動 Edge 瀏覽器, 自動化操作網頁讀取資訊, 網頁定向爬蟲工具.
---
<p word-wrap: break-word; word-break: break-all; overflow-x: hidden; overflow-x: hidden;>
一. 確保 Microsoft Window10 系統的 Edge 瀏覽器已全部關閉, 啓動 Microsoft Office Excel 應用.

二. 手動操作 Microsoft Excel 應用, 載入文件夾 ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CDPimport/ 裏的 Microsoft Excel VBA 類模組 : clsBrowser.cls , clsCore.cls , clsJsConverter.cls

三. 手動操作 Microsoft Excel 應用, 載入文件夾 ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/ 裏的 Microsoft Excel VBA 窗體 : CrawlerControlPanel.frm , CrawlerControlPanel.frx

四. 手動操作 Microsoft Excel 應用, 載入文件夾 ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/ 裏的 Microsoft Excel VBA 模組 : CrawlerDispatchModule.bas

五. 手動操作 Microsoft Excel 應用, 載入文件夾 ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/ 裏的 Microsoft Excel VBA 模組 : testCrawlerModule.bas

六. 手動操作 Microsoft Excel 應用, 載入文件夾 ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/CrawlerStrategyServer/test/ 裏的 Microsoft Excel VBA 對象 : ThisWorkbook.cls

七. 啓動運行測試網站 :  root@localhost:~# /bin/node ./focused-crawling-Microsoft-Office-Excel-VBA-Edge/testWeb/server.js

八. 運行 Microsoft Excel VBA 宏擴展應用 : focused-crawling-Microsoft-Office-Excel-VBA-Edge 選擇 test 選項, 從 Microsoft Excel 應用的「加載項」菜單裏, 選擇 : 「 Focused Crawling 」 → 「 operation panel 」 → 「 test 」, 加載顯示 test 人機交互介面.

九. 測試 Microsoft Excel VBA 宏擴展應用 : focused-crawling-Microsoft-Office-Excel-VBA-Edge 操控讀取測試網站 testWeb 頁面顯示的資訊, 將讀取結果存儲在電子表格 ( Microsoft Excel ) 指定位置.
</p>

---

使用微軟電子表格 Microsoft Excel VBA 驅動瀏覽器 Edge 宏應用 : focused-crawling-Microsoft-Office-Excel-VBA-Edge 説明 :

1. 項目架構執行序 :

   1). 單擊 Google 瀏覽器 Chrome 擴展插件 ( Extension ) : focused-crawling-Chrome-Extension 啓動運行, 按照配置文檔 ( ./focused-crawling-Chrome-Extension/manifest.json ) 裏記錄的自定義指令預設的後臺脚本檔 ( background ), 載入運行 JavaScript 代碼脚本檔 ( ./focused-crawling-Chrome-Extension/background/starter_backgroundHtml.js ).

   2). 後臺脚本檔 JavaScript 代碼脚本檔 ( ./focused-crawling-Chrome-Extension/background/starter_backgroundHtml.js ) 新建標籤頁面 ( Chrome-Tag ) 載入運行背景頁面 ( ./focused-crawling-Chrome-Extension/background/background.html ).

   3). 背景頁面 ( ./focused-crawling-Chrome-Extension/background/background.html ) 新建標籤頁面 ( Chrome-Tag ) 依據背景頁面裏自定義選項, 載入運行自定義的操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ).

   4). 自定義的操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 新建標籤頁面 ( Chrome-Tag ) 依據操作頁面裏自定義選項, 載入目標網站頁面待讀取頁面顯示的資訊 ( ./focused-crawling-Chrome-Extension/testWeb/ ).

   5). 瀏覽器 Google-Chrome 按照配置文檔 ( ./focused-crawling-Chrome-Extension/manifest.json ) 裏記錄的自定義指令預設的注入脚本檔 ( content_scripts ), 自動在所有打開的網頁中, 載入運行 JavaScript 代碼脚本檔 ( ./focused-crawling-Chrome-Extension/content_script.js ).

   6). 注入脚本檔 ( ./focused-crawling-Chrome-Extension/content_script.js ) 按照檔裏自定義設計的代碼, 判斷目標網站頁面 ( ./focused-crawling-Chrome-Extension/testWeb/ ) 打開的待讀取資訊的頁面地址 ( URL ), 並依照頁面地址 ( URL ) 選擇將自定義的插入脚本檔 ( injected_script ) 注入目標網站 ( ./focused-crawling-Chrome-Extension/testWeb/ ) 頁面, 本例會載入運行 JavaScript 代碼脚本檔 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test_injected.js ).

   7). 自定義的插入脚本檔 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test_injected.js ), 從目標網站 ( ./focused-crawling-Chrome-Extension/testWeb/ ) 頁面, 向操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 返回插入成功信號.

   8). 手動點擊操控, 從操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 發送信號, 經由背景頁面 ( ./focused-crawling-Chrome-Extension/background/background.html ) 轉發, 向目標網站 ( ./focused-crawling-Chrome-Extension/testWeb/ ) 頁面裏插入的脚本檔 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test_injected.js ) 發送信號, 啓動讀取頁面裏顯示的資訊及翻頁等其他網頁動作.

   9). 從目標網站 ( ./focused-crawling-Chrome-Extension/testWeb/ ) 頁面裏插入的脚本檔 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test_injected.js ) 自動發送信號, 經由背景頁面 ( ./focused-crawling-Chrome-Extension/background/background.html ) 轉發, 向操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 發送讀取到的資訊結果.

   10). 操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 自動將接受到的目標網站頁面顯示的資訊結果, 寫入指定位置存儲.

2. 項目將自定義的操作介面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 獨立一個頁面設計, 目的是, 與背景頁面 ( ./focused-crawling-Chrome-Extension/background/background.html ) 分開, 解耦合, 這樣便於日後維護擴展功能, 增加更多元的操控介面, 使之可選擇的, 適用於讀取更多目標網站頁面裏顯示的資訊.

   若不考慮日後的功能擴展, 可取消獨立的操作介面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 設計, 將之全部功能, 整合入背景頁面 ( ./focused-crawling-Chrome-Extension/background/background.html ) 裏, 這樣即可實現單擊 Google 瀏覽器 Chrome 擴展插件 ( Extension ) : focused-crawling-Chrome-Extension 啓動運行, 即打開顯示操作頁面 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 的效果, 更簡潔明快.

3. 若想擴展功能, 增加更多元的操控介面, 使之可選擇的, 適用於讀取更多目標網站頁面, 可新增複製 test/ 文件夾並重新命名, 保存路徑位於 ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/ 文件夾裏, 重新命名並自定義修改文件夾 test/ 裏的四個代碼脚本檔 : test_injected.js , test.html , test.js , test.css , 根據需要自定義修改設計編寫代碼脚本即可, 這一操作的目的, 是爲實現新增一組操作介面的效果, 例如像 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 類似的.

   并且, 需要修改背景頁面的代碼脚本檔 ( ./focused-crawling-Chrome-Extension/background/background.html ) 和  ( ./focused-crawling-Chrome-Extension/background/background.js ) 裏的代碼, 使其可以正確找到載入運行自定義擴展新增的操作頁面的代碼脚本檔, 例如像 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test.html ) 類似的.

   并且, 需要修改注入脚本檔 ( ./focused-crawling-Chrome-Extension/content_script.js ) 裏的代碼, 使其可以正確判斷自定義擴展新增的待讀取資訊的目標網站頁面的 URL 地址, 並找到載入運行對應的自定義擴展新增的外源加載的注入代碼脚本檔, 例如像 ( ./focused-crawling-Chrome-Extension/CrawlerStrategyServer/test/test_injected.js ) 類似的.

4. 項目空間裏的文件夾 testWeb 祇是一組用於配合測試 Google 瀏覽器 Chrome 擴展插件 ( Extension ) : focused-crawling-Chrome-Extension 框架基礎功能的網站頁面, 主要用於開發階段的測試之用, 當 focused-crawling-Chrome-Extension 的策略介面選擇 test 選項加載顯示 test 人機交互介面時, 才需要啓動運行 testWeb 伺服器, 定型之後生產階段則不再需要; 若不需要測試框架基礎功能, 可將文件夾 testWeb 刪除, 不會影響 Google 瀏覽器 Chrome 擴展插件 ( Extension ) : focused-crawling-Chrome-Extension 的功能.

   伺服器 testWeb 運行需要 Node.js 環境, 所以運行之前, 需對作業系統 ( Operating System ) 安裝配置 Node.js 環境成功方可.

   可在 Linux-Ubuntu 系統的控制臺命令列人機交互介面窗口 ( Ubuntu-bash ) 使用如下指令, 安裝配置 Node.js 環境 :

   root@localhost:~# sudo apt install nodejs

   root@localhost:~# sudo apt install npm

   可在 Linux-Ubuntu 系統的控制臺命令列人機交互介面窗口 ( Ubuntu-bash ) 使用如下指令, 啓動運行 testWeb 伺服器 :

   root@localhost:~# /bin/node ./focused-crawling-Chrome-Extension/testWeb/server.js

![]()

---

Operating System :

Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

Acer-NEO-2023 Linux-Ubuntu-22.04 x86_64 Inter(R)-Core(TM)-m3-6Y30

Google-Pixel-7 Android-11 Termux-0.118 Linux-Ubuntu-22.04-LTS-rootfs Arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280

---

使用 Microsoft Office Excel VBA 操作 Edge、Chrome、Firebox 瀏覽器, 使用 codeproject 網站提供的第三方擴展類模組 : clsBrowser.cls , clsCore.cls , clsJsConverter.cls 官方網站 :

[第三方擴展類模組 VBA-JSON 官方 GitHub 網站倉庫](https://github.com/VBA-tools/VBA-JSON): 
https://github.com/VBA-tools/VBA-JSON.git

[第三方擴展類模組提供網站 codeproject 裏的 Automate Chrome or Edge using VBA 庫 ( Tips ) 官方説明頁](https://www.codeproject.com/Tips/5307593/Automate-Chrome-Edge-using-VBA): 
https://www.codeproject.com/Tips/5307593/Automate-Chrome-Edge-using-VBA

[第三方擴展類模組 Chromium-Automation-with-CDP-for-VBA 官方 GitHub 網站倉庫](https://github.com/longvh211/Chromium-Automation-with-CDP-for-VBA): 
https://github.com/longvh211/Chromium-Automation-with-CDP-for-VBA.git

[第三方擴展類模組 Edge-IE-Mode-Automation-with-IES-for-VBA 官方 GitHub 網站倉庫](https://github.com/longvh211/Edge-IE-Mode-Automation-with-IES-for-VBA): 
https://github.com/longvh211/Edge-IE-Mode-Automation-with-IES-for-VBA.git

Browser : Google Chrome ( Chromium )

[作業系統 ( Operating system ) Linux → Ubuntu Arm64 瀏覽器 ( Browser ) 之 Google Chrome Arm64 下載官方網站](http://ports.ubuntu.com/pool/universe/c/chromium-browser/): 
http://ports.ubuntu.com/pool/universe/c/chromium-browser/

[瀏覽器 ( Browser ) 之 Google Chrome 下載官方網站](https://www.google.com/intl/zh-TW/chrome/dev/?standalone=1): 
https://www.google.com/intl/zh-TW/chrome/dev/?standalone=1

[瀏覽器 ( Browser ) 之 Google Chrome ( Chromium ) 開發人員版 ( dev ) 下載中文網站](https://www.google.cn/intl/zh-TW/chrome/dev/?standalone=1&system=true&statcb=1&installdataindex=empty&defaultbrowser=0): 
https://www.google.cn/intl/zh-TW/chrome/dev/?standalone=1&system=true&statcb=1&installdataindex=empty&defaultbrowser=0

[瀏覽器 ( Browser ) 之 Google Chrome 驅動 ( Driver ) 下載官方網站](https://chromedriver.storage.googleapis.com/index.html): 
https://chromedriver.storage.googleapis.com/index.html

[瀏覽器 ( Browser ) 之 Google Chrome 驅動 ( Driver ) 下載官方網站淘寶網鏡像源](https://npm.taobao.org/mirrors/chromedriver): 
https://npm.taobao.org/mirrors/chromedriver

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

JavaScript library : jQuery , Bootstrap

[網頁元素選擇器工具 jQuery 官方網站](https://jquery.com/): 
https://jquery.com/

[網頁元素選擇器工具 jQuery 官方下載頁](https://jquery.com/download/): 
https://jquery.com/download/

[網頁元素選擇器工具 jQuery 官方説明手冊](https://api.jquery.com/): 
https://api.jquery.com/

[網頁元素選擇器工具 jQuery 的 npm ( Node Package Manager ) 官方倉庫頁](https://www.npmjs.com/package/jquery): 
https://www.npmjs.com/package/jquery

[網頁元素選擇器工具 jQuery 的 GitHub 官方倉庫頁](https://github.com/jquery/jquery): 
https://github.com/jquery/jquery.git

[響應式網站布局框架 bootstrap 官方網站](https://v5.bootcss.com/): 
https://v5.bootcss.com/

[響應式網站布局框架 bootstrap 官方下載頁](https://v5.bootcss.com/docs/getting-started/download/): 
https://v5.bootcss.com/docs/getting-started/download/

[響應式網站布局框架 bootstrap 官方説明手冊](https://getbootstrap.com/docs/versions/): 
https://getbootstrap.com/docs/versions/

[響應式網站布局框架 bootstrap 的 npm ( Node Package Manager ) 官方倉庫頁](https://www.npmjs.com/package/bootstrap): 
https://www.npmjs.com/package/bootstrap

[響應式網站布局框架 bootstrap 的 GitHub 官方倉庫頁](https://github.com/twbs/bootstrap): 
https://github.com/twbs/bootstrap.git

---

瀏覽器 ( Browser : Google Chrome ) 和解釋器 ( Interpreter : Node.js ) 預編譯二進制可執行檔 [百度網盤(pan.baidu.com)](https://pan.baidu.com/s/1OK1J8J5rbMiQPabvYGDUCQ?pwd=h8t9) 下載頁: 
https://pan.baidu.com/s/1OK1J8J5rbMiQPabvYGDUCQ?pwd=h8t9

提取碼：h8t9

---

![]()
