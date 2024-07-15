VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} CrawlerControlPanel 
   Caption         =   "Crawler control panel"
   ClientHeight    =   12144
   ClientLeft      =   48
   ClientTop       =   372
   ClientWidth     =   12168
   OleObjectBlob   =   "CrawlerControlPanel.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  '所有者中心
End
Attribute VB_Name = "CrawlerControlPanel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'Author: 趙健
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
'Date: 歲在丙申


'The codes were enhanced for both VBA7 (64-bit) and others (32-bit) by Long Vh.
#If VBA7 Then

    Private Declare PtrSafe Sub sleep Lib "kernel64" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 64 位軟件使用這條語句聲明
    Private Declare PtrSafe Function timeGetTime Lib "winmm.dll" () As Long: Rem 64 位軟件使用這條語句聲明
    
    '聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。
    Private Declare PtrSafe Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 64 位軟件使用這條語句聲明

#Else

    Private Declare Sub sleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 32 位軟件使用這條語句聲明，聲明 sleep 函數，函數 sleep 是 Windows API 函數，使用前，必須先聲明，然後再使用。這條語句是為後面使用 sleep 函數精確延時使用的，如果程序中不使用 sleep 函數，可以刪除這條語句。函數 sleep 的使用方法是，sleep 3000  '3000 表示 3000 毫秒。函數 sleep 延時是毫秒級的，精確度比較高，但它在延時時，會將程序挂起，使操作系統暫時無法響應用戶操作，所以長延時不適合使用。
    Private Declare Function timeGetTime Lib "winmm.dll" () As Long: Rem 32 位軟件使用這條語句聲明，聲明 timeGetTime 函數，函數 timeGetTime 是 Windows API 函數，使用前，必須先聲明，然後再使用。這條語句是為後面使用 timeGetTime 函數精確延時使用的，如果程序中不需要使用 timeGetTime 函數也可以刪除這條語句。函數 timeGetTime 返回的是開機到現在的毫秒數，可以支持 1 毫秒的間隔時間，一直增加。

    '聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。
    Private Declare Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 32 位軟件使用這條語句聲明，聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。

#End If
Private Const WM_SYSCOMMAND = &H112: Rem 聲明函數參數使用的常數值
Private Const SC_MINIMIZE = &HF020&: Rem 聲明函數參數使用的常數值
'使用函數示例
'SendMessage IEA.hwnd, WM_SYSCOMMAND, SC_MINIMIZE, 0: Rem 向瀏覽器窗口發送消息，最小化瀏覽器窗口，這是使用的 Windows 系統的 API 函數，在模塊頭部的幾條語句中聲明過


'如果使用全局變量 public 的方法實現，在用戶窗體裏邊的全局變量賦值方式如下：
Option Explicit: Rem 語句 Option Explicit 表示强制要求變量需要先聲明後使用；聲明全局變量，可以跨越函數和子過程之間使用的，用于監測窗體中按钮控件點擊狀態。
Public PublicCurrentWorkbookName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentWorkbookName”，用於存放當前工作簿的名稱
Public PublicCurrentWorkbookFullName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentWorkbookFullName”，用於存放當前工作簿的全名（工作簿路徑和名稱）
Public PublicCurrentSheetName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentSheetName”，用於存放當前工作表的名稱


Public Public_Browser_Name As String: Rem 表示判斷使用的辨識瀏覽器種類，可以取值：("InternetExplorer", "Edge", "Chrome", "Firefox")，如果空白不傳入該參數，預設值表示使用 "Edge" 瀏覽器加載指定網頁
Public Public_Browser_page_window_object As Object: Rem 定義一個全局型（Public）對象變量（IWebBrowser2），用於存放瀏覽器加載的目標數據源頁面窗口對象的句柄，用於後續操作頁面


Public PublicVariableStartORStopCollectDataButtonClickState As Boolean: Rem 定義一個全局型（Public）布爾型变量“PublicVariableStartORStopCollectDataButtonClickState”用於監測窗體中數據採集按钮控件的點擊狀態，即是否正在進行采集的狀態提示


Public Public_Current_page_number As Integer: Rem 獲取到的載入當前頁碼值的存儲
Public Public_Max_page_number As Integer: Rem 獲取到的允許載入最大頁碼值的存儲
Public Public_Number_of_entrance_from_first_level_page_to_second_level_page As Integer  'Max_Entry_number As Integer: Rem 當前第一層級頁面中，進入對應第二層級頁面的入口元素數目，即獲取到的載入最大條目值的存儲

Public Public_Data_Server_Url As String: Rem 用於存儲采集結果的數據庫服務器網址，字符串變量
Public Public_Data_Receptors As String: Rem 用於存儲采集結果的容器類型複選框值，字符串變量
Public Public_Key_Word As String: Rem 執行關鍵詞檢索動作時，傳入的關鍵詞，字符串變量
Public Public_Start_page_number As Integer: Rem 開始采集的第一層級網頁的頁碼號，短整型變量
Public Public_Start_entry_number As Integer: Rem 開始采集的第二層級網頁的頁碼號，短整型變量
Public Public_End_page_number As Integer: Rem 結束采集的第一層級網頁的頁碼號，短整型變量
Public Public_Data_level As String: Rem 目標數據源網頁層級結構，字符串型變量，取 "1" 值表示只采集當前頁中的數據，取 "2" 表示還需自動進入第二層級頁面讀取數據
Public Public_Delay_length_input As Long: Rem 循環點擊操作之間延遲等待的時長的基礎值，單位毫秒
Public Public_Delay_length_random_input As Single: Rem 循環點擊操作之間延遲等待的時長的隨機化範圍，單位為基礎值的百分比
Public Public_Delay_length As Long: Rem 循環點擊操作之間延遲等待的時長，單位毫秒


'定位目標數據源網頁中各元素的 XPath 值變量
Public Public_Crawler_Strategy_module_name As String: Rem 導入的爬蟲策略模塊的自定義命名值字符串
Public Public_Custom_name_of_data_page As String: Rem 目標數據源網站頁面的自定義標記命名值字符串
Public Public_URL_of_data_page As String: Rem 目標數據源網站頁面的網址 URL 值字符串
Public Public_First_level_page_number_source_xpath As String: Rem 定位“當前第一層級頁面中頁碼信息源元素”的 XPath 值字符串
Public Public_First_level_page_data_source_xpath As String: Rem 定位“當前第一層級頁面中目標數據源元素”的 XPath 值字符串
Public Public_First_level_page_KeyWord_query_textbox_xpath As String: Rem 定位“關鍵詞檢索”輸入框的 XPath 值字符串
Public Public_First_level_page_KeyWord_query_button_xpath As String: Rem 定位“關鍵詞檢索”按鈕的 XPath 值字符串
Public Public_First_level_page_skip_textbox_xpath As String: Rem 定位“跳頁”輸入框的 XPath 值字符串
Public Public_First_level_page_skip_button_xpath As String: Rem 定位“跳頁”按鈕的 XPath 值字符串
Public Public_First_level_page_next_button_xpath As String: Rem 定位“下一頁”按鈕的 XPath 值字符串
Public Public_First_level_page_back_button_xpath As String: Rem 定位“上一頁”按鈕的 XPath 值字符串
Public Public_From_first_level_page_to_second_level_page_xpath As String: Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的 XPath 值字符串
'Public Public_Second_level_page_number_source_xpath As String: Rem 定位“當前第二層級頁面中頁碼信息源元素”的 XPath 值字符串
Public Public_Second_level_page_data_source_xpath As String: Rem 定位“當前第二層級頁面中目標數據源元素”的 XPath 值字符串
Public Public_From_second_level_page_return_first_level_page_xpath As String: Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的 XPath 值字符串
Public Public_Inject_data_page_JavaScript As String: Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
Public Public_Inject_data_page_JavaScript_filePath As String: Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名

Public Public_First_level_page_number_source_tag_name As String: Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
Public Public_First_level_page_number_source_position_index As Integer: Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
Public Public_First_level_page_data_source_tag_name As String: Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
Public Public_First_level_page_data_source_position_index As Integer: Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
Public Public_First_level_page_KeyWord_query_textbox_tag_name As String: Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
Public Public_First_level_page_KeyWord_query_textbox_position_index As Integer: Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
Public Public_First_level_page_KeyWord_query_button_tag_name As String: Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
Public Public_First_level_page_KeyWord_query_button_position_index As Integer: Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
Public Public_First_level_page_skip_textbox_tag_name As String: Rem 定位“跳頁”輸入框的標簽名稱值字符串
Public Public_First_level_page_skip_textbox_position_index As Integer: Rem 定位“跳頁”輸入框的位置索引整數值
Public Public_First_level_page_skip_button_tag_name As String: Rem 定位“跳頁”按鈕的標簽名稱值字符串
Public Public_First_level_page_skip_button_position_index As Integer: Rem 定位“跳頁”按鈕的位置索引整數值
Public Public_First_level_page_next_button_tag_name As String: Rem 定位“下一頁”按鈕的標簽名稱值字符串
Public Public_First_level_page_next_button_position_index As Integer: Rem 定位“下一頁”按鈕的位置索引整數值
Public Public_First_level_page_back_button_tag_name As String: Rem 定位“上一頁”按鈕的標簽名稱值字符串
Public Public_First_level_page_back_button_position_index As Integer: Rem 定位“上一頁”按鈕的位置索引整數值
Public Public_From_first_level_page_to_second_level_page_tag_name As String: Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
Public Public_From_first_level_page_to_second_level_page_position_index As Integer: Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
'Public Public_Second_level_page_number_source_tag_name As String: Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
'Public Public_Second_level_page_number_source_position_index As Integer: Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
Public Public_Second_level_page_data_source_tag_name As String: Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
Public Public_Second_level_page_data_source_position_index As Integer: Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
Public Public_From_second_level_page_return_first_level_page_tag_name As String: Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
Public Public_From_second_level_page_return_first_level_page_position_index As Integer: Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值


Public Sub UserForm_Initialize()
'窗體打開前事件，給窗體控件中的全局變量賦初值，函數 UserForm_Initialize 的作用是窗體控件打開即運行初始化

    '語句 On Error Resume Next 會使程序按照產生錯誤的語句之後的語句繼續執行
    On Error Resume Next

    CrawlerControlPanel.PublicCurrentWorkbookName = ThisWorkbook.name: Rem 獲得當前工作簿的名稱，效果等同於“ = ActiveWorkbook.Name ”
    CrawlerControlPanel.PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem 獲得當前工作簿的全名（工作簿路徑和名稱）
    CrawlerControlPanel.PublicCurrentSheetName = ActiveSheet.name: Rem 獲得當前工作表的名稱


    '給監測窗體中數據採集按钮控件的點擊狀態變量賦初值初始化
    PublicVariableStartORStopCollectDataButtonClickState = True: Rem 布爾型變量，用於監測窗體中數據採集按钮控件的點擊狀態，即是否正在進行采集的狀態提示

    '給當前頁碼信息賦初值初始化
    Public_Current_page_number = 0: Rem 獲取到的載入當前頁碼值的存儲
    Public_Max_page_number = 0: Rem 獲取到的允許載入最大頁碼值的存儲
    Public_Number_of_entrance_from_first_level_page_to_second_level_page = 0  'Max_Entry_number = 0: Rem 當前第一層級頁面中，進入對應第二層級頁面的入口元素數目，即獲取到的載入最大條目值的存儲

    Public_Browser_Name = "": Rem 表示判斷使用的辨識瀏覽器種類，可以取值：("InternetExplorer", "Edge", "Chrome", "Firefox")，如果空白不傳入該參數，預設值表示使用 "Edge" 瀏覽器加載指定網頁

    '為定位頁面各元素的 XPath 字符串變量賦初值
    Public_Crawler_Strategy_module_name = "": Rem 導入的爬蟲策略模塊的自定義命名值字符串（當前所處的模塊名），例如：testCrawlerModule
    Public_Custom_name_of_data_page = "": Rem 目標數據源網站的自定義標記命名值字符串，例如：testContainDataWebPage
    Public_URL_of_data_page = "": Rem 目標數據源網站頁面的網址 URL 值字符串，例如：http://127.0.0.1:8000/a.html
    Public_First_level_page_number_source_xpath = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的 XPath 值字符串，例如：/html/body/div/centre/label 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-label
    Public_First_level_page_data_source_xpath = "": Rem 定位“當前第一層級頁面中目標數據源元素”的 XPath 值字符串，例如：/html/body/div/centre/div/table 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-table
    Public_First_level_page_KeyWord_query_textbox_xpath = "": Rem 定位“關鍵詞檢索”輸入框的 XPath 值字符串，例如：/html/body/div/centre/input[1] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-input
    Public_First_level_page_KeyWord_query_button_xpath = "": Rem 定位“關鍵詞檢索”按鈕的 XPath 值字符串，例如：/html/body/div/centre/button[1] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-button
    Public_First_level_page_skip_textbox_xpath = "": Rem 定位“跳頁”輸入框的 XPath 值字符串，例如：/html/body/div/centre/input[2] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：1-input
    Public_First_level_page_skip_button_xpath = "": Rem 定位“跳頁”按鈕的 XPath 值字符串，例如：/html/body/div/centre/button[2] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：1-button
    Public_First_level_page_next_button_xpath = "": Rem 定位“下一頁”按鈕的 XPath 值字符串，例如：/html/body/div/centre/a[2] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：1-a
    Public_First_level_page_back_button_xpath = "": Rem 定位“上一頁”按鈕的 XPath 值字符串，例如：/html/body/div/centre/a[1] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-a
    Public_From_first_level_page_to_second_level_page_xpath = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的 XPath 值字符串，例如：/html/body/div/centre/div/table 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-table
    'Public_Second_level_page_number_source_xpath = "": Rem 定位“當前第二層級頁面中頁碼信息源元素”的 XPath 值字符串
    Public_Second_level_page_data_source_xpath = "": Rem 定位“當前第二層級頁面中目標數據源元素”的 XPath 值字符串，例如：/html/body/div/centre/div/table 或針對 InternetExplorer 瀏覽器 byTagName 的方法：0-table
    Public_From_second_level_page_return_first_level_page_xpath = "": Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的 XPath 值字符串，例如：/html/body/div/centre/a[3] 或針對 InternetExplorer 瀏覽器 byTagName 的方法：2-a
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
    Public_Inject_data_page_JavaScript = "": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
    'Public_Inject_data_page_JavaScript_filePath = "C:/Criss/vba/Automatic/test/test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    Public_Inject_data_page_JavaScript_filePath = "": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名

    '為定位頁面各元素的標簽名稱和位置索引字符串變量賦初值
    Public_First_level_page_number_source_tag_name = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    Public_First_level_page_number_source_position_index = CInt(-1): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
    Public_First_level_page_data_source_tag_name = "": Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
    Public_First_level_page_data_source_position_index = CInt(-1): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
    Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
    Public_First_level_page_KeyWord_query_textbox_position_index = CInt(-1): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
    Public_First_level_page_KeyWord_query_button_tag_name = "": Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
    Public_First_level_page_KeyWord_query_button_position_index = CInt(-1): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
    Public_First_level_page_skip_textbox_tag_name = "": Rem 定位“跳頁”輸入框的標簽名稱值字符串
    Public_First_level_page_skip_textbox_position_index = CInt(-1): Rem 定位“跳頁”輸入框的位置索引整數值
    Public_First_level_page_skip_button_tag_name = "": Rem 定位“跳頁”按鈕的標簽名稱值字符串
    Public_First_level_page_skip_button_position_index = CInt(-1): Rem 定位“跳頁”按鈕的位置索引整數值
    Public_First_level_page_next_button_tag_name = "": Rem 定位“下一頁”按鈕的標簽名稱值字符串
    Public_First_level_page_next_button_position_index = CInt(-1): Rem 定位“下一頁”按鈕的位置索引整數值
    Public_First_level_page_back_button_tag_name = "": Rem 定位“上一頁”按鈕的標簽名稱值字符串
    Public_First_level_page_back_button_position_index = CInt(-1): Rem 定位“上一頁”按鈕的位置索引整數值
    Public_From_first_level_page_to_second_level_page_tag_name = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
    Public_From_first_level_page_to_second_level_page_position_index = CInt(-1): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
    'Public_Second_level_page_number_source_tag_name = "": Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    'Public_Second_level_page_number_source_position_index = CInt(-1): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
    Public_Second_level_page_data_source_tag_name = "": Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
    Public_Second_level_page_data_source_position_index = CInt(-1): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
    Public_From_second_level_page_return_first_level_page_tag_name = "": Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
    Public_From_second_level_page_return_first_level_page_position_index = CInt(-1): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值

    If Public_Browser_Name = "InternetExplorer" Then

        ''Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組

        ''定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
        'Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
        ''Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
        ''Public_First_level_page_number_source_tag_name = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index

        ''定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
        'Public_First_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-")
        ''Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
        ''Public_First_level_page_data_source_tag_name = "": Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_data_source_tag_name & ", " & Public_First_level_page_data_source_position_index

        ''定位“關鍵詞檢索”輸入框的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
        'Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
        ''Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
        ''Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index

        ''定位“關鍵詞檢索”按鈕的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
        'Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
        ''Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
        ''Public_First_level_page_KeyWord_query_button_tag_name = "": Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index

        ''定位“跳頁”輸入框的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”輸入框的位置索引整數值
        'Public_First_level_page_skip_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“跳頁”輸入框的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-")
        ''Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”輸入框的位置索引整數值
        ''Public_First_level_page_skip_textbox_tag_name = "": Rem 定位“跳頁”輸入框的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & CStr(tempArr(i)): Rem 定位“跳頁”輸入框的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“跳頁”輸入框的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_skip_textbox_tag_name & ", " & Public_First_level_page_skip_textbox_position_index

        ''定位“跳頁”按鈕的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”按鈕的位置索引整數值
        'Public_First_level_page_skip_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“跳頁”按鈕的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-")
        ''Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”按鈕的位置索引整數值
        ''Public_First_level_page_skip_button_tag_name = "": Rem 定位“跳頁”按鈕的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & CStr(tempArr(i)): Rem 定位“跳頁”按鈕的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“跳頁”按鈕的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_skip_button_tag_name & ", " & Public_First_level_page_skip_button_position_index

        ''定位“下一頁”按鈕的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        ''tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
        'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“下一頁”按鈕的位置索引整數值
        'Public_First_level_page_next_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“下一頁”按鈕的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
        ''Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“下一頁”按鈕的位置索引整數值
        ''Public_First_level_page_next_button_tag_name = "": Rem 定位“下一頁”按鈕的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & CStr(tempArr(i)): Rem 定位“下一頁”按鈕的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“下一頁”按鈕的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_next_button_tag_name & ", " & Public_First_level_page_next_button_position_index

        ''定位“上一頁”按鈕的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“上一頁”按鈕的位置索引整數值
        'Public_First_level_page_back_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“上一頁”按鈕的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-")
        ''Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“上一頁”按鈕的位置索引整數值
        ''Public_First_level_page_back_button_tag_name = "": Rem 定位“上一頁”按鈕的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & CStr(tempArr(i)): Rem 定位“上一頁”按鈕的標簽名稱值字符串
        ''    Else
        ''        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“上一頁”按鈕的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_back_button_tag_name & ", " & Public_First_level_page_back_button_position_index

        ''定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
        'Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
        ''Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
        ''Public_From_first_level_page_to_second_level_page_tag_name = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
        ''    Else
        ''        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index

        '''定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
        ''ReDim tempArr(0): Rem 清空數組
        ''tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        '''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        ''Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
        ''Public_Second_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
        '''tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-")
        '''Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
        '''Public_Second_level_page_number_source_tag_name = "": Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
        '''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '''        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
        '''    Else
        '''        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
        '''    End If
        '''Next
        '''Debug.Print Public_Second_level_page_number_source_tag_name & ", " & Public_Second_level_page_number_source_position_index

        ''定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
        'Public_Second_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-")
        ''Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
        ''Public_Second_level_page_data_source_tag_name = "": Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
        ''    Else
        ''        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_Second_level_page_data_source_tag_name & ", " & Public_Second_level_page_data_source_position_index

        ''定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
        'ReDim tempArr(0): Rem 清空數組
        'tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值
        'Public_From_second_level_page_return_first_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
        ''tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-")
        ''Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值
        ''Public_From_second_level_page_return_first_level_page_tag_name = "": Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
        ''    Else
        ''        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
        ''    End If
        ''Next
        ''Debug.Print Public_From_second_level_page_return_first_level_page_tag_name & ", " & Public_From_second_level_page_return_first_level_page_position_index

    End If


    '為定位頁面各元素的 XPath 字符串變量賦初值
    'Public_Custom_name_of_data_page = "": Rem 目標數據源網站的自定義標記命名值字符串
    'If Not (CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox") Is Nothing) Then
    '    'Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If
    'Public_URL_of_data_page = "": Rem 目標數據源網站頁面的網址 URL 值字符串
    'If Not (CrawlerControlPanel.Controls("URL_of_data_page_TextBox") Is Nothing) Then
    '    'Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If
    'Public_First_level_page_number_source_xpath = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
    '    '    Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
    '    '    'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
    '    '    'Public_First_level_page_number_source_tag_name = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
    '    'End If
    'End If
    'Public_First_level_page_data_source_xpath = "": Rem 定位“當前第一層級頁面中目標數據源元素”的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
    '    '    Public_First_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-")
    '    '    'Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
    '    '    'Public_First_level_page_data_source_tag_name = "": Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_data_source_tag_name & ", " & Public_First_level_page_data_source_position_index
    '    'End If
    'End If
    'Public_First_level_page_KeyWord_query_textbox_xpath = "": Rem 定位“關鍵詞檢索”輸入框的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“關鍵詞檢索”輸入框的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
    '    '    Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
    '    '    'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
    '    '    'Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index
    '    'End If
    'End If
    'Public_First_level_page_KeyWord_query_button_xpath = "": Rem 定位“關鍵詞檢索”按鈕的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“關鍵詞檢索”按鈕的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
    '    '    Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
    '    '    'Public_First_level_page_KeyWord_query_button_tag_name = "": Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index
    '    'End If
    'End If
    'Public_First_level_page_skip_textbox_xpath = "": Rem 定位“跳頁”輸入框的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“跳頁”輸入框的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”輸入框的位置索引整數值
    '    '    Public_First_level_page_skip_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“跳頁”輸入框的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-")
    '    '    'Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”輸入框的位置索引整數值
    '    '    'Public_First_level_page_skip_textbox_tag_name = "": Rem 定位“跳頁”輸入框的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & CStr(tempArr(i)): Rem 定位“跳頁”輸入框的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“跳頁”輸入框的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_skip_textbox_tag_name & ", " & Public_First_level_page_skip_textbox_position_index
    '    'End If
    'End If
    'Public_First_level_page_skip_button_xpath = "": Rem 定位“跳頁”按鈕的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“跳頁”按鈕的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”按鈕的位置索引整數值
    '    '    Public_First_level_page_skip_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“跳頁”按鈕的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”按鈕的位置索引整數值
    '    '    'Public_First_level_page_skip_button_tag_name = "": Rem 定位“跳頁”按鈕的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & CStr(tempArr(i)): Rem 定位“跳頁”按鈕的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“跳頁”按鈕的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_skip_button_tag_name & ", " & Public_First_level_page_skip_button_position_index
    '    'End If
    'End If
    'Public_First_level_page_next_button_xpath = "": Rem 定位“下一頁”按鈕的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“下一頁”按鈕的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
    '    '    tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“下一頁”按鈕的位置索引整數值
    '    '    Public_First_level_page_next_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“下一頁”按鈕的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“下一頁”按鈕的位置索引整數值
    '    '    'Public_First_level_page_next_button_tag_name = "": Rem 定位“下一頁”按鈕的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & CStr(tempArr(i)): Rem 定位“下一頁”按鈕的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“下一頁”按鈕的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_next_button_tag_name & ", " & Public_First_level_page_next_button_position_index
    '    'End If
    'End If
    'Public_First_level_page_back_button_xpath = "": Rem 定位“上一頁”按鈕的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“上一頁”按鈕的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“上一頁”按鈕的位置索引整數值
    '    '    Public_First_level_page_back_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“上一頁”按鈕的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“上一頁”按鈕的位置索引整數值
    '    '    'Public_First_level_page_back_button_tag_name = "": Rem 定位“上一頁”按鈕的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & CStr(tempArr(i)): Rem 定位“上一頁”按鈕的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“上一頁”按鈕的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_back_button_tag_name & ", " & Public_First_level_page_back_button_position_index
    '    'End If
    'End If
    'Public_From_first_level_page_to_second_level_page_xpath = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox") Is Nothing) Then
    '    'Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
    '    '    Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
    '    '    'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
    '    '    'Public_From_first_level_page_to_second_level_page_tag_name = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index
    '    'End If
    'End If
    ''Public_Second_level_page_number_source_xpath = "": Rem 定位“當前第二層級頁面中頁碼信息源元素”的 XPath 值字符串
    ''If Not (CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox") Is Nothing) Then
    ''    'Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    ''    Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    ''    'If Public_Browser_Name = "InternetExplorer" Then
    ''    '    '定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
    ''    '    ReDim tempArr(0): Rem 清空數組
    ''    '    tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    ''    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    ''    '    Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
    ''    '    Public_Second_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    ''    '    'tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-")
    ''    '    'Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
    ''    '    'Public_Second_level_page_number_source_tag_name = "": Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    ''    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    ''    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    ''    '    '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    ''    '    '    Else
    ''    '    '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    ''    '    '    End If
    ''    '    'Next
    ''    '    'Debug.Print Public_Second_level_page_number_source_tag_name & ", " & Public_Second_level_page_number_source_position_index
    ''    'End If
    ''End If
    'Public_Second_level_page_data_source_xpath = "": Rem 定位“當前第二層級頁面中目標數據源元素”的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox") Is Nothing) Then
    '    'Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
    '    '    Public_Second_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-")
    '    '    'Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
    '    '    'Public_Second_level_page_data_source_tag_name = "": Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_Second_level_page_data_source_tag_name & ", " & Public_Second_level_page_data_source_position_index
    '    'End If
    'End If
    'Public_From_second_level_page_return_first_level_page_xpath = "": Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox") Is Nothing) Then
    '    'Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值
    '    '    Public_From_second_level_page_return_first_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-")
    '    '    'Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值
    '    '    'Public_From_second_level_page_return_first_level_page_tag_name = "": Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_From_second_level_page_return_first_level_page_tag_name & ", " & Public_From_second_level_page_return_first_level_page_position_index
    '    'End If
    'End If
    ''Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
    'Public_Inject_data_page_JavaScript = "": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
    ''If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    ''    'Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    ''    Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    ''End If
    ''Public_Inject_data_page_JavaScript_filePath = "C:/Criss/vba/Automatic/test/test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'Public_Inject_data_page_JavaScript_filePath = "": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    '    'Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    'Debug.Print Public_Inject_data_page_JavaScript_filePath
    'End If
    'If Public_Inject_data_page_JavaScript_filePath <> "" Then

    '    '判斷自定義的待插入目標數據源頁面的 JavaScript 脚本文檔是否存在
    '    Dim fso As Object, sFile As Object
    '    Set fso = CreateObject("Scripting.FileSystemObject")

    '    If fso.Fileexists(Public_Inject_data_page_JavaScript_filePath) Then

    '        'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

    '        '使用 OpenTextFile 方法打開一個指定的文檔並返回一個 TextStream 對象，該對象可以對文檔進行讀操作或追加寫入操作
    '        '函數語法：object.OpenTextFile(filename[,iomode[,create[,format]]])
    '        '參數 filename 為目標文檔的路徑全名字符串
    '        '參數 iomode 表示輸入和輸出方式，可以為兩個常數之一：ForReading、ForAppending
    '        '參數 Create 表示如果指定的 filename 不存在時，是否可以新創建一個新文檔，為 Boolean 值，若創建新文檔取 True 值，不創建則取 False 值，預設為 False 值
    '        '參數 Format 為三種 Tristate 值之一，預設為以 ASCII 格式打開文檔

    '        '設置打開文檔參數常量
    '        Const ForReading = 1: Rem 打開一個只讀文檔，不能對文檔進行寫操作
    '        Const ForWriting = 2: Rem 打開一個可讀可寫操作的文檔，注意，會清空刪除文檔中原有的内容
    '        Const ForAppending = 8: Rem 打開一個可寫操作的文檔，並將指針移動到文檔的末尾，執行在文檔尾部追加寫入操作，不會刪除文檔中原有的内容
    '        Const TristateUseDefault = -2: Rem 使用系統缺省的編碼方式打開文檔
    '        Const TristateTrue = -1: Rem 以 Unicode 編碼的方式打開文檔
    '        Const TristateFalse = 0: Rem 以 ASCII 編碼的方式打開文檔，注意，漢字會亂碼

    '        '以只讀方式打開文檔
    '        Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

    '        ''判斷如果不是文檔文本的尾端，則持續讀取數據拼接
    '        'Public_Inject_data_page_JavaScript = ""
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem 從打開的文檔中讀取一行字符串拼接，並在字符串結尾加上一個回車符號
    '        '    'Debug.Print sFile.ReadLine: Rem 讀取一行，不包括行尾的換行符
    '        'Loop
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem 從打開的文檔中讀取一個字符拼接
    '        '    'Debug.Print sFile.Read(1): Rem 讀取一個字符
    '        'Loop

    '        Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem 讀取文檔中的全部數據
    '        'Debug.Print sFile.ReadAll
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem 將 Unicode 編碼的字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        sFile.Close

    '    Else

    '        Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
    '        'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

    '    End If

    '    Set sFile = Nothing
    '    Set fso = Nothing

    'End If


    Public_Data_Server_Url = "": Rem 用於存儲采集結果的數據庫服務器網址，字符串變量，例如：CStr("http://username:password@localhost:9001/?keyword=aaa")
    'If Not (CrawlerControlPanel.Controls("Data_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If

    Public_Data_Receptors = "": Rem 用於存儲采集結果的容器類型複選框值，字符串變量，可取 "Database"，"Database_and_Excel"，"Excel" 值，例如取值：CStr("Excel")
    '判斷子框架控件是否存在
    If Not (CrawlerControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
        Public_Data_Receptors = ""
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Data_Receptors_Frame.Controls
            '判斷複選框控件的選中狀態
            If element_i.Value Then
                If Public_Data_Receptors = "" Then
                    Public_Data_Receptors = CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Else
                    Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                End If
            End If
        Next
        Set element_i = Nothing
        'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
        'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = ""
        'Else
        'End If
    End If

    Public_Key_Word = "": Rem 執行關鍵詞檢索動作時，傳入的關鍵詞，字符串變量
    'If Not (CrawlerControlPanel.Controls("Keyword_Query_TextBox") Is Nothing) Then
    '    'Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If

    Public_Start_page_number = CInt(0): Rem 開始采集的第一層級網頁的頁碼號，短整型變量，函數 CInt() 表示强制轉換為短整型
    'If Not (CrawlerControlPanel.Controls("Start_page_number_TextBox") Is Nothing) Then
    '    'Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型
    '    Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text): Rem 從文本輸入框控件中提取值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型
    'End If

    Public_Start_entry_number = CInt(0): Rem 開始采集的第二層級網頁的頁碼號，短整型變量，函數 CInt() 表示强制轉換為短整型
    'If Not (CrawlerControlPanel.Controls("Start_entry_number_TextBox") Is Nothing) Then
    '    'Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型
    '    Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text): Rem 從文本輸入框控件中提取值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型
    'End If

    Public_End_page_number = CInt(0): Rem 結束采集的第一層級網頁的頁碼號，短整型變量，函數 CInt() 表示强制轉換為短整型
    'If Not (CrawlerControlPanel.Controls("End_page_number_TextBox") Is Nothing) Then
    '    'Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型
    '    Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Text): Rem 從文本輸入框控件中提取值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型
    'End If

    Public_Delay_length_input = CLng(0): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型，例如取值：CLng(1500)
    Public_Delay_length_random_input = CSng(0): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型，例如取值：CSng(0.2)
    'If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
    '    'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
    '    Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。
    'End If
    'If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
    '    'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
    '    Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
    'End If
    'Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng(0)  'CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(0)  'CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

    Public_Data_level = "0": Rem 目標數據源網頁層級結構，字符串型變量，取 "1" 值表示只采集當前頁中的數據，取 "2" 表示還需自動進入第二層級頁面讀取數據。函數 CStr() 表示轉換爲字符串類型，例如取值：CStr(2)
    '判斷子框架控件是否存在
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        'Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If

End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
'窗體關閉前事件（鼠標左鍵單擊右上角×號）。
'參數 Cancel 為 > 0 的值時，表示禁止關閉動作的發生。即不允許用戶點擊窗體右上角的 × 號，也不允許使用“控制”菜單中的“關閉”命令。
'參數 CloseMode 表示關閉的模式。

    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。

    If Public_Browser_Name = "InternetExplorer" Then
        'If CloseMode = 0 Then Cancel = 1: Rem 不允許關閉窗體，或寫成 cancel=true 這樣的形式也可以，取 true 值時值為 1。
        Public_Browser_page_window_object.quit: Rem 關閉 IE 瀏覽器窗口
        'Public_Browser_page_window_object.document.parentwindow.execscript "javascript:window.opener=null;window.open('','_self');window.close();": Rem 關閉 IE 瀏覽器窗口
        Set Public_Browser_page_window_object = Nothing: Rem 清空變量釋放内存
    ElseIf (Public_Browser_Name = "Edge") Or (Public_Browser_Name = "Chrome") Or (Public_Browser_Name = "Firefox") Then
        Public_Browser_page_window_object.quit: Rem 關閉 Edge 瀏覽器窗口
        Set Public_Browser_page_window_object = Nothing: Rem 清空變量釋放内存
    Else
    End If

End Sub

'VBA Base64 編碼函數：
Function Base64Encode(StrA As String) As String
    On Error GoTo over
    Dim buf() As Byte, Length As Long, mods As Long
    Dim Str() As Byte
    Dim i, kk As Integer
    kk = Len(StrA) - 1
    ReDim Str(kk)
    For i = 0 To kk
        Str(i) = Asc(Mid(StrA, i + 1, 1))
    Next i
    Const B64_CHAR_DICT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    mods = (UBound(Str) + 1) Mod 3
    Length = UBound(Str) + 1 - mods
    ReDim buf(Length / 3 * 4 + IIf(mods <> 0, 4, 0) - 1)
    For i = 0 To Length - 1 Step 3
        buf(i / 3 * 4) = (Str(i) And &HFC) / &H4
        buf(i / 3 * 4 + 1) = (Str(i) And &H3) * &H10 + (Str(i + 1) And &HF0) / &H10
        buf(i / 3 * 4 + 2) = (Str(i + 1) And &HF) * &H4 + (Str(i + 2) And &HC0) / &H40
        buf(i / 3 * 4 + 3) = Str(i + 2) And &H3F
    Next
    If mods = 1 Then
        buf(Length / 3 * 4) = (Str(Length) And &HFC) / &H4
        buf(Length / 3 * 4 + 1) = (Str(Length) And &H3) * &H10
        buf(Length / 3 * 4 + 2) = 64
        buf(Length / 3 * 4 + 3) = 64
    ElseIf mods = 2 Then
        buf(Length / 3 * 4) = (Str(Length) And &HFC) / &H4
        buf(Length / 3 * 4 + 1) = (Str(Length) And &H3) * &H10 + (Str(Length + 1) And &HF0) / &H10
        buf(Length / 3 * 4 + 2) = (Str(Length + 1) And &HF) * &H4
        buf(Length / 3 * 4 + 3) = 64
    End If
    For i = 0 To UBound(buf)
        Base64Encode = Base64Encode + Mid(B64_CHAR_DICT, buf(i) + 1, 1)
    Next
over:
End Function

'VBA Base64 解碼函數：
Function Base64Decode(B64 As String) As String
    On Error GoTo over
    Dim OutStr() As Byte, i As Long, j As Long
    Const B64_CHAR_DICT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    If InStr(1, B64, "=") <> 0 Then B64 = left(B64, InStr(1, B64, "=") - 1)
    Dim kk, Length As Long, mods As Long
    mods = Len(B64) Mod 4
    Length = Len(B64) - mods
    ReDim OutStr(Length / 4 * 3 - 1 + Switch(mods = 0, 0, mods = 2, 1, mods = 3, 2))
    For i = 1 To Length Step 4
        Dim buf(3) As Byte
        For j = 0 To 3
            buf(j) = InStr(1, B64_CHAR_DICT, Mid(B64, i + j, 1)) - 1
        Next
        OutStr((i - 1) / 4 * 3) = buf(0) * &H4 + (buf(1) And &H30) / &H10
        OutStr((i - 1) / 4 * 3 + 1) = (buf(1) And &HF) * &H10 + (buf(2) And &H3C) / &H4
        OutStr((i - 1) / 4 * 3 + 2) = (buf(2) And &H3) * &H40 + buf(3)
    Next
    If mods = 2 Then
        OutStr(Length / 4 * 3) = (InStr(1, B64_CHAR_DICT, Mid(B64, Length + 1, 1)) - 1) * &H4 + ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 2, 1)) - 1) And &H30) / 16
    ElseIf mods = 3 Then
        OutStr(Length / 4 * 3) = (InStr(1, B64_CHAR_DICT, Mid(B64, Length + 1, 1)) - 1) * &H4 + ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 2, 1)) - 1) And &H30) / 16
        OutStr(Length / 4 * 3 + 1) = ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 2, 1)) - 1) And &HF) * &H10 + ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 3, 1)) - 1) And &H3C) / &H4
    End If
    For i = 0 To UBound(OutStr)
        Base64Decode = Base64Decode & Chr(OutStr(i))
    Next i
over:
End Function

Public Sub delay(T As Long): Rem 創建一個自定義精確延時子過程，用於後面需要延時功能時直接調用。用法為：delay(T);“T”就是要延時的時長，單位是毫秒，取值最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，這個值的範圍在 0 到 2^32 之間，大約爲 49.71 日。關鍵字 Private 表示子過程作用域只在本模塊有效，關鍵字 Public 表示子過程作用域在所有模塊都有效
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。
    Dim time1 As Long
    time1 = timeGetTime: Rem 函數 timeGetTime 表示系統時間，該時間為從系統開啓算起所經過的時間（單位毫秒），持續纍加記錄。
    Do
        If Not (CrawlerControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
            If timeGetTime - time1 < T Then
                CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
            End If
            If timeGetTime - time1 >= T Then
                CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
            End If
        End If

        DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。

    Loop While timeGetTime - time1 < T

    If Not (CrawlerControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
        If timeGetTime - time1 < T Then
            CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
        End If
        If timeGetTime - time1 >= T Then
            CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
        End If
    End If

End Sub


'用於存儲采集結果的容器類型複選框值，字符串變量，可取 "Database"，"Database_and_Excel"，"Excel" 值，例如取值：CStr("Excel")
Private Sub Data_Receptors_CheckBox1_Click()
    Public_Data_Receptors = ""
    '遍歷框架中包含的子元素。
    Dim element_i
    For Each element_i In Data_Receptors_Frame.Controls
        '判斷複選框控件的選中狀態
        If element_i.Value Then
            If Public_Data_Receptors = "" Then
                Public_Data_Receptors = CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
            Else
                Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
            End If
        End If
    Next
    Set element_i = Nothing
    'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = ""
    'Else
    'End If
End Sub

Private Sub Data_Receptors_CheckBox2_Click()
    Public_Data_Receptors = ""
    '遍歷框架中包含的子元素。
    Dim element_i
    For Each element_i In Data_Receptors_Frame.Controls
        '判斷複選框控件的選中狀態
        If element_i.Value Then
            If Public_Data_Receptors = "" Then
                Public_Data_Receptors = CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
            Else
                Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
            End If
        End If
    Next
    Set element_i = Nothing
    'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = ""
    'Else
    'End If
End Sub


'單選框鼠標左鍵單擊事件，目標數據源網頁層級結構，字符串型變量，取 "1" 值表示只采集當前頁中的數據，取 "2" 表示還需自動進入第二層級頁面讀取數據。函數 CStr() 表示轉換爲字符串類型，例如取值：CStr(2)
Private Sub Data_level_OptionButton1_Click()
    '判斷單選框控件的選中狀態
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    '判斷單選框控件的選中狀態
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    '判斷子框架控件是否存在
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
End Sub
Private Sub Data_level_OptionButton2_Click()
    '判斷單選框控件的選中狀態
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    '判斷單選框控件的選中狀態
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    '判斷子框架控件是否存在
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
End Sub


Private Sub Load_data_source_page_CommandButton_Click()
'鼠標左鍵單擊“載入目標數據源網頁（Load）”按鈕事件。
'用戶窗體運行後，鼠標左鍵單擊“Load”命令按鈕，執行這段程序。（還可以加上用戶窗體隱藏語句，則在運行中，不會顯示用戶窗體），調用子程序 “LoadWebPage(WebURL)” 。

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊

    'Call UserForm_Initialize: Rem 窗體初始化賦初值

    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。

    '刷新目標數據源網站的自定義標記命名值字符串
    If Not (CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox") Is Nothing) Then
        'Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
        Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    End If
    'Debug.Print "Custom name of data web = " & "[ " & Public_Custom_name_of_data_page & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Custom_name_of_data_page 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Custom_name_of_data_page = Public_Custom_name_of_data_page: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（目標數據源網站頁面的自定義標記命名值值字符串）變量更新賦值
            'testCrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text)
            'testCrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Custom_name_of_data_page)
            'Debug.Print testCrawlerModule.Public_Custom_name_of_data_page
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Custom_name_of_data_page = Public_Custom_name_of_data_page"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Custom_name_of_data_page = Public_Custom_name_of_data_page"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Custom_name_of_data_page = Public_Custom_name_of_data_page: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（目標數據源網站頁面的自定義標記命名值值字符串）變量更新賦值
            'CFDACrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text)
            'CFDACrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Custom_name_of_data_page)
            'Debug.Print CFDACrawlerModule.Public_Custom_name_of_data_page
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select

    '刷新目標數據源網站頁面網址 URL 字符串值
    If Not (CrawlerControlPanel.Controls("URL_of_data_page_TextBox") Is Nothing) Then
        'Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
        Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    End If
    'Debug.Print "URL of data page = " & "[ " & Public_URL_of_data_page & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_URL_of_data_page 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_URL_of_data_page = Public_URL_of_data_page: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（目標數據源網站頁面的網址值字符串）變量更新賦值
            'testCrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text)
            'testCrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_URL_of_data_page)
            'Debug.Print testCrawlerModule.Public_URL_of_data_page
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_URL_of_data_page = Public_URL_of_data_page: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（目標數據源網站頁面的網址值字符串）變量更新賦值
            'CFDACrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text)
            'CFDACrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_URL_of_data_page)
            'Debug.Print CFDACrawlerModule.Public_URL_of_data_page
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select

    '刷新待插入目標數據源頁面的 JavaScript 脚本字符串
    If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
        'Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value)
        Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
        'Debug.Print Public_Inject_data_page_JavaScript_filePath
    End If
    If Public_Inject_data_page_JavaScript_filePath <> "" Then

        '判斷自定義的待插入目標數據源頁面的 JavaScript 脚本文檔是否存在
        Dim fso As Object, sFile As Object
        Set fso = CreateObject("Scripting.FileSystemObject")

        If fso.FileExists(Public_Inject_data_page_JavaScript_filePath) Then

            'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

            '使用 OpenTextFile 方法打開一個指定的文檔並返回一個 TextStream 對象，該對象可以對文檔進行讀操作或追加寫入操作
            '函數語法：object.OpenTextFile(filename[,iomode[,create[,format]]])
            '參數 filename 為目標文檔的路徑全名字符串
            '參數 iomode 表示輸入和輸出方式，可以為兩個常數之一：ForReading、ForAppending
            '參數 Create 表示如果指定的 filename 不存在時，是否可以新創建一個新文檔，為 Boolean 值，若創建新文檔取 True 值，不創建則取 False 值，預設為 False 值
            '參數 Format 為三種 Tristate 值之一，預設為以 ASCII 格式打開文檔

            '設置打開文檔參數常量
            Const ForReading = 1: Rem 打開一個只讀文檔，不能對文檔進行寫操作
            Const ForWriting = 2: Rem 打開一個可讀可寫操作的文檔，注意，會清空刪除文檔中原有的内容
            Const ForAppending = 8: Rem 打開一個可寫操作的文檔，並將指針移動到文檔的末尾，執行在文檔尾部追加寫入操作，不會刪除文檔中原有的内容
            Const TristateUseDefault = -2: Rem 使用系統缺省的編碼方式打開文檔
            Const TristateTrue = -1: Rem 以 Unicode 編碼的方式打開文檔
            Const TristateFalse = 0: Rem 以 ASCII 編碼的方式打開文檔，注意，漢字會亂碼

            '以只讀方式打開文檔
            Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

            ''判斷如果不是文檔文本的尾端，則持續讀取數據拼接
            'Public_Inject_data_page_JavaScript = ""
            'Do While Not sFile.AtEndOfStream
            '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem 從打開的文檔中讀取一行字符串拼接，並在字符串結尾加上一個回車符號
            '    'Debug.Print sFile.ReadLine: Rem 讀取一行，不包括行尾的換行符
            'Loop
            'Do While Not sFile.AtEndOfStream
            '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem 從打開的文檔中讀取一個字符拼接
            '    'Debug.Print sFile.Read(1): Rem 讀取一個字符
            'Loop

            Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem 讀取文檔中的全部數據
            'Debug.Print sFile.ReadAll
            'Debug.Print Public_Inject_data_page_JavaScript

            'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem 將 Unicode 編碼的字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
            'Debug.Print Public_Inject_data_page_JavaScript

            sFile.Close

        Else

            Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
            'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

        End If

        Set sFile = Nothing
        Set fso = Nothing

    End If
    'Debug.Print "Inject data page JavaScript filePath = " & "[ " & Public_Inject_data_page_JavaScript_filePath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Inject_data_page_JavaScript_filePath 值。
    'Debug.Print "Inject data page JavaScript = " & "[ " & Public_Inject_data_page_JavaScript & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Inject_data_page_JavaScript 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本路徑全名）變量更新賦值
            'testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript_filePath)
            'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript_filePath
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
            testCrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本字符串）變量更新賦值
            ''testCrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript)
            'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名）變量更新賦值
            'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath)
            'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath
            'CFDACrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本字符串）變量更新賦值
            ''CFDACrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript)
            'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select

    '[A1] = URL1: Rem 這條語句用於測試，調式完畢後可刪除，效果是在 Excel 當前活動工作簿中的 A1 單元格中顯示變量 URL1 的值。
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" 轉換爲日期格式顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber 轉換爲普通數字顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式

    'CrawlerControlPanel.Hide: Rem 隱藏用戶窗體

    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'CFDACrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_input
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'CFDACrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_random_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_random_input
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length)
            'Debug.Print CFDACrawlerModule.Public_Delay_length
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select


    ''Dim Public_Browser_Name As String: Rem 可變參數 ParamArray OtherArgs() 表示判斷使用的辨識瀏覽器種類。
    ''Public_Browser_Name = "InternetExplorer": Rem 可變參數 ParamArray OtherArgs() 表示判斷使用的辨識瀏覽器種類，可以取值：("InternetExplorer", "Edge", "Chrome", "Firefox")，如果空白不傳入該參數，預設值表示使用 "InternetExplorer" 瀏覽器加載指定網頁
    'Application.Run (Public_Crawler_Strategy_module_name & "." & "LoadWebPage(""" & Public_URL_of_data_page & """, """ & Public_Browser_Name & """)"): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
    'Application.Evaluate ("Call " & Public_Crawler_Strategy_module_name & "." & "LoadWebPage(""" & Public_URL_of_data_page & """, """ & Public_Browser_Name & """)"): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
    'Application.Evaluate (Public_Crawler_Strategy_module_name & "." & "LoadWebPage(""" & Public_URL_of_data_page & """, """ & Public_Browser_Name & """)"): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
    ''刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    'Select Case Public_Crawler_Strategy_module_name
    '    Case Is = "testCrawlerModule"
    '        Set testCrawlerModule.Public_Browser_page_window_object = Public_Browser_page_window_object: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（調用打開目標數據源頁面的瀏覽器對象）變量更新賦值
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Browser_page_window_object)
    '        'Application.Evaluate "Set " & Public_Crawler_Strategy_module_name & ".Public_Browser_page_window_object = Public_Browser_page_window_object"
    '        'Application.Run "Set " & Public_Crawler_Strategy_module_name & ".Public_Browser_page_window_object = Public_Browser_page_window_object"
    '    Case Is = "CFDACrawlerModule"
    '        'Set CFDACrawlerModule.Public_Browser_page_window_object = Public_Browser_page_window_object: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（調用打開目標數據源頁面的瀏覽器對象）變量更新賦值
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Browser_page_window_object)
    '    Case Else
    '        MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    '        'Exit Sub
    'End Select
    '判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            '判斷使用的辨識瀏覽器種類，可以取值：("InternetExplorer", "Edge", "Chrome", "Firefox")，如果空白不傳入該參數，預設值表示使用 "Edge" 瀏覽器加載指定網頁
            Select Case Public_Browser_Name

                Case Is = "InternetExplorer"

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "假裝在等待的樣子 …": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    'Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Inject_data_page_JavaScript, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
                    Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("LoadWebPage")
                    Set Public_Browser_page_window_object = testCrawlerModule.Public_Browser_page_window_object

                    '使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                        Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    End If

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If Public_Browser_page_window_object.ReadyState = 4 Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Data source page loading success, Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "數據源頁面加載錯誤 Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。
                        End If
                    End If

                    'Exit Sub

                Case "Edge", "Chrome", "Firefox"

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "假裝在等待的樣子 …": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    'Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Inject_data_page_JavaScript, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
                    Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("LoadWebPage")
                    Set Public_Browser_page_window_object = testCrawlerModule.Public_Browser_page_window_object

                    '使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                        Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    End If

                    'Debug.Print CStr(Public_Browser_page_window_object.jsEval("window.location.href")): Rem 使用 jsEval() 函數取出當前打開網頁的網址。
                    'Debug.Print CBool(Public_Browser_page_window_object.isLive): Rem 使用 .isLive() 判斷瀏覽器窗口對象是否還在正常運行。
                    'Debug.Print "Data source web page ( " & Public_Custom_name_of_data_page & " ) loading state = " & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)): Rem 在立即窗口打印網頁加載狀態，觀察延時等待 3000 毫秒（3 秒鐘），是否能夠將網頁全部載入成功，如果網頁載入成功，則狀態碼應顯示“objBrowser.Readystate=4”
                    ''ReadyState 的五種狀態:
                    ''0:(Uninitialized) the send( ) method has not yet been invoked.
                    ''1:(Loading) the send( ) method has been invoked,request in progress.
                    ''2:(Loaded) the send( ) method has completed,entire response received.
                    ''3:(Interactive) the response is being parsed.
                    ''4:(Completed) the response has been parsed,is ready for harvesting.
                    ''0-（未初始化），表示還沒有調用 send() 方法
                    ''1-（载入）已調用 send() 方法，表示正在向服務器發送請求
                    ''2-（载入完成）方法 send() 已執行完成，表示已經接收到服務器返回的全部響應内容
                    ''3-（交互），表示瀏覽器正在解析服務器返回的響應内容
                    ''4-（完成）瀏覽器對服務器返回的響應内容解析完成，表示用戶可以調用網頁中的元素了

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "complete") Or (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "interactive") Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Data source page loading success, Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "數據源頁面加載錯誤 Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。
                        End If
                    End If

                    'Exit Sub

                'Case "Chrome"
                'Case "Firefox"
                Case Else

                    MsgBox "調用瀏覽器類型輸入錯誤（Browser Name = " & CStr(Public_Browser_Name) & "），只能取字符串 InternetExplorer、Edge、Chrome、Firefox 之一."
                    Exit Sub

            End Select

        Case Is = "CFDACrawlerModule"

            'Call CFDACrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function LoadWebPage()”函數，打開目標數據源網頁。: Rem 這個 LoadWebPage 函數的返回值為 InternetExplorer 瀏覽器加載目標數據源頁面後的窗口對象，效果是在 InternetExplorer 瀏覽器中載入指定 URL 的網頁，然後從載入網頁的 HTML 脚本中提取目標信息。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("LoadWebPage")
            'Set Public_Browser_page_window_object = CFDACrawlerModule.Public_Browser_page_window_object

            ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'End If

            'Exit Sub

        Case Else

            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule 爬蟲策略."
            'Exit Sub

    End Select
    'Public_Browser_page_window_object.Quit: Rem 關閉 InternetExplorer.Application 瀏覽器窗口
    'Debug.Print "Data source web page ( " & Public_Custom_name_of_data_page & " ) loading state = " & Public_Browser_page_window_object.ReadyState: Rem 在立即窗口打印網頁加載狀態，觀察延時等待 3000 毫秒（3 秒鐘），是否能夠將網頁全部載入成功，如果網頁載入成功，則狀態碼應顯示“IEA.Readystate=4”
    'Debug.Print Public_Browser_page_window_object.LocationURL: Rem 通過“.LocationURL”屬性取出當前打開網頁的網址。
    'Debug.Print VBA.TypeName(Public_Browser_page_window_object)


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊

End Sub

Private Sub Keyword_Query_CommandButton_Click()
'鼠標左鍵單擊“關鍵詞檢索”按鈕事件

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊

    '[A1] = URL1: Rem 這條語句用於測試，調式完畢後可刪除，效果是在 Excel 當前活動工作簿中的 A1 單元格中顯示變量 URL1 的值。
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" 轉換爲日期格式顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber 轉換爲普通數字顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式

    'CrawlerControlPanel.Hide: Rem 隱藏用戶窗體
    'Call UserForm_Initialize: Rem 窗體初始化賦初值

    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。


    'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
    Dim tempArr() As String: Rem 字符串分割之後得到的數組

    '刷新定位“關鍵詞檢索”輸入框的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox") Is Nothing) Then

        'Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "Key word query textbox xpath = " & "[ " & Public_First_level_page_KeyWord_query_textbox_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_KeyWord_query_textbox_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的 XPath 值字符串）變量更新賦值
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath)
                'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '定位“關鍵詞檢索”輸入框的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
            Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
            'Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_position_index: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

        End If

    End If

    '刷新定位“關鍵詞檢索”按鈕的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then

        'Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "Key word query button xpath = " & "[ " & Public_First_level_page_KeyWord_query_button_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_KeyWord_query_button_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的 XPath 值字符串）變量更新賦值
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath)
                'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '定位“關鍵詞檢索”按鈕的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
            Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
            'Public_First_level_page_KeyWord_query_button_tag_name = "": Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_position_index)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_position_index
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

        End If

    End If


    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'CFDACrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_input
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'CFDACrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_random_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_random_input
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length)
            'Debug.Print CFDACrawlerModule.Public_Delay_length
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select


    '讀取輸入框中傳入的檢索關鍵詞字符串
    If Not (CrawlerControlPanel.Controls("Keyword_Query_TextBox") Is Nothing) Then
        'Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Value)
        Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    End If
    'Debug.Print "Key Word = " & "[ " & Public_Key_Word & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Key_Word 值。
    ''刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    'Select Case Public_Crawler_Strategy_module_name
    '    Case Is = "testCrawlerModule"
    '        testCrawlerModule.Public_Key_Word = Public_Key_Word: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（檢索關鍵詞字符串）變量更新賦值
    '        'testCrawlerModule.Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text)
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Key_Word)
    '        'Debug.Print testCrawlerModule.Public_Key_Word
    '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '    Case Is = "CFDACrawlerModule"
    '        'CFDACrawlerModule.Public_Key_Word = Public_Key_Word: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（檢索關鍵詞字符串）變量更新賦值
    '        'CFDACrawlerModule.Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Key_Word)
    '        'Debug.Print CFDACrawlerModule.Public_Key_Word
    '    Case Else
    '        MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    '        'Exit Sub
    'End Select


    '判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            '判斷使用的辨識瀏覽器種類，可以取值：("InternetExplorer", "Edge", "Chrome", "Firefox")，如果空白不傳入該參數，預設值表示使用 "Edge" 瀏覽器加載指定網頁
            Select Case Public_Browser_Name

                Case Is = "InternetExplorer"

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "假裝在等待的樣子 …": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_Current_page_number, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Sub First_level_page_KeyWord_Query()”子過程，執行關鍵詞檢索動作。
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("First_level_page_KeyWord_Query")

                    ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                    '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    'End If

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If Public_Browser_page_window_object.ReadyState = 4 Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Key-Word query page loading success, Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "關鍵詞檢索頁面加載錯誤 Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。
                        End If
                    End If

                    'Exit Sub

                Case "Edge", "Chrome", "Firefox"

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "假裝在等待的樣子 …": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_Current_page_number, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Sub First_level_page_KeyWord_Query()”子過程，執行關鍵詞檢索動作。
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("First_level_page_KeyWord_Query")

                    ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                    '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
                    'End If

                    'Debug.Print CStr(Public_Browser_page_window_object.jsEval("window.location.href")): Rem 使用 jsEval() 函數取出當前打開網頁的網址。
                    'Debug.Print CBool(Public_Browser_page_window_object.isLive): Rem 使用 .isLive() 判斷瀏覽器窗口對象是否還在正常運行。
                    'Debug.Print "Data source web page ( " & Public_Custom_name_of_data_page & " ) loading state = " & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)): Rem 在立即窗口打印網頁加載狀態，觀察延時等待 3000 毫秒（3 秒鐘），是否能夠將網頁全部載入成功，如果網頁載入成功，則狀態碼應顯示“objBrowser.Readystate=4”
                    ''ReadyState 的五種狀態:
                    ''0:(Uninitialized) the send( ) method has not yet been invoked.
                    ''1:(Loading) the send( ) method has been invoked,request in progress.
                    ''2:(Loaded) the send( ) method has completed,entire response received.
                    ''3:(Interactive) the response is being parsed.
                    ''4:(Completed) the response has been parsed,is ready for harvesting.
                    ''0-（未初始化），表示還沒有調用 send() 方法
                    ''1-（载入）已調用 send() 方法，表示正在向服務器發送請求
                    ''2-（载入完成）方法 send() 已執行完成，表示已經接收到服務器返回的全部響應内容
                    ''3-（交互），表示瀏覽器正在解析服務器返回的響應内容
                    ''4-（完成）瀏覽器對服務器返回的響應内容解析完成，表示用戶可以調用網頁中的元素了

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "complete") Or (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "interactive") Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Key-Word query page loading success, Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "關鍵詞檢索頁面加載錯誤 Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。
                        End If
                    End If

                    'Exit Sub

                'Case "Chrome"
                'Case "Firefox"
                Case Else

                    MsgBox "調用瀏覽器類型輸入錯誤（Browser Name = " & CStr(Public_Browser_Name) & "），只能取字符串 InternetExplorer、Edge、Chrome、Firefox 之一."
                    Exit Sub

            End Select

        Case Is = "CFDACrawlerModule"

            'Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, CFDACrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Sub First_level_page_KeyWord_Query()”子過程，執行關鍵詞檢索動作。
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("First_level_page_KeyWord_Query")

            ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'End If

            'Exit Sub

        Case Else

            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule 爬蟲策略."
            'Exit Sub

    End Select
    'Debug.Print VBA.TypeName(Public_Browser_page_window_object)

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊

End Sub

Private Sub Extract_Page_Number_CommandButton_Click()
'鼠標左鍵單擊“讀取頁碼信息”按鈕事件

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    'CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.End_page_number_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

    '[A1] = URL1: Rem 這條語句用於測試，調式完畢後可刪除，效果是在 Excel 當前活動工作簿中的 A1 單元格中顯示變量 URL1 的值。
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" 轉換爲日期格式顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber 轉換爲普通數字顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式

    'CrawlerControlPanel.Hide: Rem 隱藏用戶窗體
    'Call UserForm_Initialize: Rem 窗體初始化賦初值

    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。


    'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
    Dim tempArr() As String: Rem 字符串分割之後得到的數組

    '刷新定位“頁碼信息源元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then

        'Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "Page number source xpath = " & "[ " & Public_First_level_page_number_source_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_number_source_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“頁碼信息源元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_number_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“頁碼信息源元素”的 XPath 值字符串）變量更新賦值
                'CFDACrawlerModule.Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print CFDACrawlerModule.Public_First_level_page_number_source_xpath
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
            Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
            'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
            'Public_First_level_page_number_source_tag_name = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“頁碼信息源元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    testCrawlerModule.Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“頁碼信息源元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“頁碼信息源元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_number_source_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_number_source_tag_name
                    'CFDACrawlerModule.Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“頁碼信息源元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_number_source_position_index)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_number_source_position_index
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

        End If

    End If

    '刷新定位“從當前第一層級頁面進入第二層級頁面的入口元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then

        'Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "Entrance from first level page to second level page xpath = " & "[ " & Public_From_first_level_page_to_second_level_page_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_From_first_level_page_to_second_level_page_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“從當前第一層級頁面進入第二層級頁面的入口元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath)
                'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“從當前第一層級頁面進入第二層級頁面的入口元素”的 XPath 值字符串）變量更新賦值
                'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath)
                'Debug.Print CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
            Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
            'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
            'Public_From_first_level_page_to_second_level_page_tag_name = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            '    Else
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“從當前第一層級頁面進入第二層級頁面的入口元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“從當前第一層級頁面進入第二層級頁面的入口元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“從當前第一層級頁面進入第二層級頁面的入口元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name
                    'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（定位“從當前第一層級頁面進入第二層級頁面的入口元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_position_index)
                    'Debug.Print CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_position_index
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

        End If

    End If


    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'CFDACrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_input
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'CFDACrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_random_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_random_input
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length)
            'Debug.Print CFDACrawlerModule.Public_Delay_length
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select


    '判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            '刷新控制面板窗體控件中包含的提示標簽顯示值
            If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "假裝在瀏覽的樣子 …": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            End If

            Call testCrawlerModule.First_level_page_Extract_Page_Number(Public_Current_page_number, Public_First_level_page_number_source_xpath, Public_From_first_level_page_to_second_level_page_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function First_level_page_Extract_Page_Number()”函數，執行讀取頁碼信息的動作。
            'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("First_level_page_Extract_Page_Number")

            ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'End If

            '刷新控制面板窗體控件中包含的提示標簽顯示值
            If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "當前頁碼信息已更新": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            End If

            'Exit Sub

        Case Is = "CFDACrawlerModule"

            'Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, CFDACrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function First_level_page_Extract_Page_Number()”函數，執行讀取頁碼信息的動作。
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("First_level_page_KeyWord_Query")

            'Exit Sub

        Case Else

            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule 爬蟲策略."
            'Exit Sub

    End Select
    ''Debug.Print VBA.TypeName(Public_Current_page_number)
    'Debug.Print Public_Current_page_number
    'Debug.Print Public_Max_page_number
    'Debug.Print Public_Number_of_entrance_from_first_level_page_to_second_level_page

    '刷新啓動頁碼（第一層級頁面）輸入框
    If Not (CrawlerControlPanel.Controls("Start_page_number_TextBox") Is Nothing) Then
        'CrawlerControlPanel.Controls("Start_page_number_TextBox").Value = CStr(Public_Current_page_number): Rem 給文本輸入框控件的 .Value 屬性賦值，函數 CStr() 表示强制轉換為字符串型
        CrawlerControlPanel.Controls("Start_page_number_TextBox").Text = CStr(Public_Current_page_number): Rem 給文本輸入框控件的 .Text 屬性賦值，函數 CStr() 表示强制轉換為字符串型
    End If

    '刷新啓動頁碼（第二層級頁面）輸入框
    If Not (CrawlerControlPanel.Controls("Start_entry_number_TextBox") Is Nothing) Then
        'CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value = CStr(1): Rem 給文本輸入框控件的 .Value 屬性賦值，函數 CStr() 表示强制轉換為字符串型
        CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text = CStr(1): Rem 給文本輸入框控件的 .Text 屬性賦值，函數 CStr() 表示强制轉換為字符串型
    End If

    '刷新終止頁碼（第一層級頁面）輸入框
    If Not (CrawlerControlPanel.Controls("End_page_number_TextBox") Is Nothing) Then
        'CrawlerControlPanel.Controls("End_page_number_TextBox").Value = CStr(Public_Max_page_number): Rem 給文本輸入框控件的 .Value 屬性賦值，函數 CStr() 表示强制轉換為字符串型
        CrawlerControlPanel.Controls("End_page_number_TextBox").Text = CStr(Public_Max_page_number): Rem 給文本輸入框控件的 .Text 屬性賦值，函數 CStr() 表示强制轉換為字符串型
    End If

    '刷新提示標簽（當前第一層級頁面中包含的進入第二層級頁面的入口元素的數量）
    If Not (CrawlerControlPanel.Controls("Max_entry_Label") Is Nothing) Then
        CrawlerControlPanel.Controls("Max_entry_Label").Caption = "(" & CStr(Public_Number_of_entrance_from_first_level_page_to_second_level_page) & ")": Rem 給文本輸入框控件的 .Caption 屬性賦值，函數 CStr() 表示强制轉換為字符串型
    End If


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    'CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

End Sub

Private Sub Start_or_Stop_Collect_Data_CommandButton_Click()
'鼠標左鍵單擊“開始或中止采集數據”按鈕事件

    'Call UserForm_Initialize: Rem 窗體初始化賦初值
    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。


    '更改按鈕狀態和標志
    PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
    If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
        Select Case PublicVariableStartORStopCollectDataButtonClickState
            Case True
                CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
            Case False
                CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
            Case Else
                MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
        End Select
    End If
    'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
            'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
            'Debug.Print CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select
    '判斷是否跳出子過程不繼續執行後面的動作
    If PublicVariableStartORStopCollectDataButtonClickState Then

        ''刷新控制面板窗體控件中包含的提示標簽顯示值
        'If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
        '    CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "數據採集過程被中止.": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
        'End If

        ''Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
        ''刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        'Select Case Public_Crawler_Strategy_module_name
        '    Case Is = "testCrawlerModule"
        '        testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
        '        'Debug.Print VBA.TypeName(testCrawlerModule)
        '        'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
        '        'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
        '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
        '        'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
        '    Case Is = "CFDACrawlerModule"
        '        'CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
        '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
        '        'Debug.Print VBA.TypeName(CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
        '        'Debug.Print CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
        '    Case Else
        '        MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
        '        'Exit Sub
        'End Select

        '使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
        If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
        End If

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

        Exit Sub

    End If


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.End_page_number_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_level_OptionButton1.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_level_OptionButton2.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = False: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊


    Dim i, j As Integer: Rem 整型，記錄 for 循環次數變量
    Dim tempArr() As String: Rem 字符串分割之後得到的數組


    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
        Case Else
            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
            'Exit Sub
    End Select

    '用於存儲采集結果的數據庫服務器網址，字符串變量，例如：CStr("http://username:password@localhost:9001/?keyword=aaa")
    If Not (CrawlerControlPanel.Controls("Data_Server_Url_TextBox") Is Nothing) Then
        'Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

        'Debug.Print "Data Server Url = " & "[ " & Public_Data_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Data_Server_Url 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Data_Server_Url = Public_Data_Server_Url: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（用於存儲采集結果的數據庫服務器網址，字符串變量）變量更新賦值
                'testCrawlerModule.Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_Server_Url)
                'Debug.Print testCrawlerModule.Public_Data_Server_Url
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_Server_Url = Public_Data_Server_Url"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_Server_Url = Public_Data_Server_Url"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If

    '用於存儲采集結果的容器類型複選框值，字符串變量，可取 "Database"，"Database_and_Excel"，"Excel" 值，例如取值：CStr("Excel")
    '判斷子框架控件是否存在
    If Not (CrawlerControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
        Public_Data_Receptors = ""
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Data_Receptors_Frame.Controls
            '判斷複選框控件的選中狀態
            If element_i.Value Then
                If Public_Data_Receptors = "" Then
                    Public_Data_Receptors = CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Else
                    Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                End If
            End If
        Next
        Set element_i = Nothing
        'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
        'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = ""
        'Else
        'End If

        'Debug.Print "Public_Data_Receptors = " & "[ " & Public_Data_Receptors & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Data_Receptors 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Data_Receptors = Public_Data_Receptors: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（用於存儲采集結果的容器類型複選框值，字符串變量）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_Receptors)
                'Debug.Print testCrawlerModule.Public_Data_Receptors
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_Receptors = Public_Data_Receptors"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_Receptors = Public_Data_Receptors"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If

    ''執行關鍵詞檢索動作時，傳入的關鍵詞，字符串變量
    'If Not (CrawlerControlPanel.Controls("Keyword_Query_TextBox") Is Nothing) Then
    '    'Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    'Debug.Print "Key Word = " & "[ " & Public_Key_Word & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Key_Word 值。
    '    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    '    Select Case Public_Crawler_Strategy_module_name
    '        Case Is = "testCrawlerModule"
    '            testCrawlerModule.Public_Key_Word = Public_Key_Word: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（執行關鍵詞檢索動作時，傳入的關鍵詞，字符串變量）變量更新賦值
    '            'testCrawlerModule.Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text)
    '            'Debug.Print VBA.TypeName(testCrawlerModule)
    '            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Key_Word)
    '            'Debug.Print testCrawlerModule.Public_Data_Receptors
    '            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '        Case Is = "CFDACrawlerModule"
    '        Case Else
    '            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    '            'Exit Sub
    '    End Select
    'End If

    '開始采集的第一層級網頁的頁碼號，短整型變量，函數 CInt() 表示强制轉換為短整型
    If Not (CrawlerControlPanel.Controls("Start_page_number_TextBox") Is Nothing) Then
        'If CStr(CrawlerControlPanel.Controls("Start_page_number_TextBox").Value) = "" Then
        '    Public_Start_page_number = CInt(0)
        'Else
        '    Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型
        'End If
        If CStr(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text) = "" Then
            Public_Start_page_number = CInt(0)
        Else
            Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text): Rem 從文本輸入框控件中提取值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型
        End If

        'Debug.Print "Start page number = " & "[ " & Public_Start_page_number & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Start_page_number 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Start_page_number = Public_Start_page_number: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（開始采集的第一層級網頁的頁碼號，短整型變量）變量更新賦值
                'testCrawlerModule.Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Start_page_number)
                'Debug.Print testCrawlerModule.Public_Start_page_number
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Start_page_number = Public_Start_page_number"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Start_page_number = Public_Start_page_number"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If

    '開始采集的第二層級網頁的頁碼號，短整型變量，函數 CInt() 表示强制轉換為短整型
    If Not (CrawlerControlPanel.Controls("Start_entry_number_TextBox") Is Nothing) Then
        'If CStr(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value) = "" Then
        '    Public_Start_entry_number = CInt(0)
        'Else
        '    Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型
        'End If
        If CStr(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text) = "" Then
            Public_Start_entry_number = CInt(0)
        Else
            Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text): Rem 從文本輸入框控件中提取值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型
        End If

        'Debug.Print "Start entry number = " & "[ " & Public_Start_entry_number & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Start_entry_number 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Start_entry_number = Public_Start_entry_number: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（開始采集的第二層級網頁的頁碼號，短整型變量）變量更新賦值
                'testCrawlerModule.Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Start_entry_number)
                'Debug.Print testCrawlerModule.Public_Start_entry_number
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Start_entry_number = Public_Start_entry_number"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Start_entry_number = Public_Start_entry_number"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If

    '結束采集的第一層級網頁的頁碼號，短整型變量，函數 CInt() 表示强制轉換為短整型
    If Not (CrawlerControlPanel.Controls("End_page_number_TextBox") Is Nothing) Then
        'If CStr(CrawlerControlPanel.Controls("End_page_number_TextBox").Value) = "" Then
        '    Public_End_page_number = CInt(0)
        'Else
        '    Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型
        'End If
        If CStr(CrawlerControlPanel.Controls("End_page_number_TextBox").Text) = "" Then
            Public_End_page_number = CInt(0)
        Else
            Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Text): Rem 從文本輸入框控件中提取值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型
        End If

        'Debug.Print "End page number = " & "[ " & Public_End_page_number & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_End_page_number 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_End_page_number = Public_End_page_number: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（結束采集的第一層級網頁的頁碼號，短整型變量）變量更新賦值
                'testCrawlerModule.Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_End_page_number)
                'Debug.Print testCrawlerModule.Public_End_page_number
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_End_page_number = Public_End_page_number"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_End_page_number = Public_End_page_number"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If

    '目標數據源網頁層級結構，字符串型變量，取 "1" 值表示只采集當前頁中的數據，取 "2" 表示還需自動進入第二層級頁面讀取數據。函數 CStr() 表示轉換爲字符串類型，例如取值：CStr(2)
    '判斷子框架控件是否存在
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        'Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing

        'Debug.Print "Data level = " & "[ " & Public_Data_level & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Data_level 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Data_level = Public_Data_level: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（目標數據源網頁層級結構，字符串型變量）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_level)
                'Debug.Print testCrawlerModule.Public_Data_level
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If


    '[A1] = URL1: Rem 這條語句用於測試，調式完畢後可刪除，效果是在 Excel 當前活動工作簿中的 A1 單元格中顯示變量 URL1 的值。
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" 轉換爲日期格式顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber 轉換爲普通數字顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式

    'CrawlerControlPanel.Hide: Rem 隱藏用戶窗體


    ''刷新目標數據源網站的自定義標記命名值字符串
    'If Not (CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox") Is Nothing) Then
    '    'Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
    '    Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    'End If
    ''Debug.Print "Custom name of data web = " & "[ " & Public_Custom_name_of_data_page & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Custom_name_of_data_page 值。
    '''刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    ''Select Case Public_Crawler_Strategy_module_name
    ''    Case Is = "testCrawlerModule"
    ''        testCrawlerModule.Public_Custom_name_of_data_page = Public_Custom_name_of_data_page: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（目標數據源網站頁面的網址值字符串）變量更新賦值
    ''        'testCrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_level)
    ''        'Debug.Print testCrawlerModule.Public_Data_level
    ''        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
    ''        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
    ''    Case Is = "CFDACrawlerModule"
    ''    Case Else
    ''        MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    ''        'Exit Sub
    ''End Select

    ''刷新目標數據源網站頁面網址 URL 字符串值
    'If Not (CrawlerControlPanel.Controls("URL_of_data_page_TextBox") Is Nothing) Then
    '    'Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
    '    Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    'End If
    ''Debug.Print "URL of data page = " & "[ " & Public_URL_of_data_page & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_URL_of_data_page 值。
    '''刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    ''Select Case Public_Crawler_Strategy_module_name
    ''    Case Is = "testCrawlerModule"
    ''        testCrawlerModule.Public_URL_of_data_page = Public_URL_of_data_page: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（目標數據源網站頁面的網址 URL 值字符串）變量更新賦值
    ''        'testCrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule.Public_URL_of_data_page)
    ''        'Debug.Print testCrawlerModule.Public_URL_of_data_page
    ''        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
    ''        'Application.Run Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
    ''    Case Is = "CFDACrawlerModule"
    ''    Case Else
    ''        MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    ''        'Exit Sub
    ''End Select

    '定位“當前第一層級頁面中頁碼信息源元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page number source xpath = " & "[ " & Public_First_level_page_number_source_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_number_source_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中頁碼信息源元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_number_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
            Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
            'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
            'Public_First_level_page_number_source_tag_name = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    testCrawlerModule.Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“當前第一層級頁面中目標數據源元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page data source xpath = " & "[ " & Public_First_level_page_data_source_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_data_source_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_data_source_xpath = Public_First_level_page_number_source_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中目標數據源元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_number_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
            Public_First_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-")
            'Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中目標數據源元素”的位置索引整數值
            'Public_First_level_page_data_source_tag_name = "": Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_data_source_tag_name & ", " & Public_First_level_page_data_source_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中目標數據源元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_data_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_data_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name"
                    testCrawlerModule.Public_First_level_page_data_source_position_index = Public_First_level_page_data_source_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中目標數據源元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_data_source_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_data_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_position_index = Public_First_level_page_data_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_position_index = Public_First_level_page_data_source_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“關鍵詞檢索”輸入框的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page KeyWord query textbox xpath = " & "[ " & Public_First_level_page_KeyWord_query_textbox_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_KeyWord_query_textbox_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“關鍵詞檢索”輸入框的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
            Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”輸入框的位置索引整數值
            'Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”輸入框的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”輸入框的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“關鍵詞檢索”按鈕的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page KeyWord query button xpath = " & "[ " & Public_First_level_page_KeyWord_query_button_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_KeyWord_query_button_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“關鍵詞檢索”按鈕的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
            Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“關鍵詞檢索”按鈕的位置索引整數值
            'Public_First_level_page_KeyWord_query_button_tag_name = "": Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“關鍵詞檢索”按鈕的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“關鍵詞檢索”按鈕的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“跳頁”輸入框的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page skip textbox xpath = " & "[ " & Public_First_level_page_skip_textbox_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_skip_textbox_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_skip_textbox_xpath = Public_First_level_page_skip_textbox_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“跳頁”輸入框的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_textbox_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_skip_textbox_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_xpath = Public_First_level_page_skip_textbox_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_xpath = Public_First_level_page_skip_textbox_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“跳頁”輸入框的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”輸入框的位置索引整數值
            Public_First_level_page_skip_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“跳頁”輸入框的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-")
            'Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”輸入框的位置索引整數值
            'Public_First_level_page_skip_textbox_tag_name = "": Rem 定位“跳頁”輸入框的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & CStr(tempArr(i)): Rem 定位“跳頁”輸入框的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & "-" & CStr(tempArr(i)): Rem 定位“跳頁”輸入框的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_skip_textbox_tag_name & ", " & Public_First_level_page_skip_textbox_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“跳頁”輸入框的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_textbox_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_textbox_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name"
                    testCrawlerModule.Public_First_level_page_skip_textbox_position_index = Public_First_level_page_skip_textbox_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“跳頁”輸入框的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_textbox_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_textbox_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_position_index = Public_First_level_page_skip_textbox_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_position_index = Public_First_level_page_skip_textbox_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“跳頁”按鈕的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page skip button xpath = " & "[ " & Public_First_level_page_skip_button_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_skip_button_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_skip_button_xpath = Public_First_level_page_skip_button_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“跳頁”按鈕的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_skip_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_xpath = Public_First_level_page_skip_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_xpath = Public_First_level_page_skip_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“跳頁”按鈕的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”按鈕的位置索引整數值
            Public_First_level_page_skip_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“跳頁”按鈕的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-")
            'Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“跳頁”按鈕的位置索引整數值
            'Public_First_level_page_skip_button_tag_name = "": Rem 定位“跳頁”按鈕的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & CStr(tempArr(i)): Rem 定位“跳頁”按鈕的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“跳頁”按鈕的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_skip_button_tag_name & ", " & Public_First_level_page_skip_button_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“跳頁”按鈕的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name"
                    testCrawlerModule.Public_First_level_page_skip_button_position_index = Public_First_level_page_skip_button_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“跳頁”按鈕的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_position_index = Public_First_level_page_skip_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_position_index = Public_First_level_page_skip_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“下一頁”按鈕的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page next button xpath = " & "[ " & Public_First_level_page_next_button_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_next_button_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_next_button_xpath = Public_First_level_page_next_button_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“下一頁”按鈕的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_next_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_next_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_xpath = Public_First_level_page_next_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_xpath = Public_First_level_page_next_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“下一頁”按鈕的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
            tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“下一頁”按鈕的位置索引整數值
            Public_First_level_page_next_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“下一頁”按鈕的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
            'Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“下一頁”按鈕的位置索引整數值
            'Public_First_level_page_next_button_tag_name = "": Rem 定位“下一頁”按鈕的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & CStr(tempArr(i)): Rem 定位“下一頁”按鈕的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“下一頁”按鈕的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_next_button_tag_name & ", " & Public_First_level_page_next_button_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“下一頁”按鈕的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_next_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_next_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name"
                    testCrawlerModule.Public_First_level_page_next_button_position_index = Public_First_level_page_next_button_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“下一頁”按鈕的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_next_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_next_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_position_index = Public_First_level_page_next_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_position_index = Public_First_level_page_next_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“上一頁”按鈕的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "First level page back button xpath = " & "[ " & Public_First_level_page_back_button_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_First_level_page_back_button_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_back_button_xpath = Public_First_level_page_back_button_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“上一頁”按鈕的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_back_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_back_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_xpath = Public_First_level_page_back_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_xpath = Public_First_level_page_back_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“上一頁”按鈕的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“上一頁”按鈕的位置索引整數值
            Public_First_level_page_back_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“上一頁”按鈕的標簽名稱值字符串
            'tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-")
            'Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“上一頁”按鈕的位置索引整數值
            'Public_First_level_page_back_button_tag_name = "": Rem 定位“上一頁”按鈕的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & CStr(tempArr(i)): Rem 定位“上一頁”按鈕的標簽名稱值字符串
            '    Else
            '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & "-" & CStr(tempArr(i)): Rem 定位“上一頁”按鈕的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_First_level_page_back_button_tag_name & ", " & Public_First_level_page_back_button_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“上一頁”按鈕的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_back_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_back_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name"
                    testCrawlerModule.Public_First_level_page_back_button_position_index = Public_First_level_page_back_button_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“上一頁”按鈕的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_back_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_back_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_position_index = Public_First_level_page_back_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_position_index = Public_First_level_page_back_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox") Is Nothing) Then
        'Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "From first level page to second level page xpath = " & "[ " & Public_From_first_level_page_to_second_level_page_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_From_first_level_page_to_second_level_page_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath)
                'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
            Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
            'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值
            'Public_From_first_level_page_to_second_level_page_tag_name = "": Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            '    Else
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第一層級頁面中進入對應的第二層級頁面的入口元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    ''定位“當前第二層級頁面中頁碼信息源元素”的 XPath 值字符串
    'If Not (CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox") Is Nothing) Then
    '    'Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    'Debug.Print "Second level page number source xpath = " & "[ " & Public_Second_level_page_number_source_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Second_level_page_number_source_xpath 值。
    '    '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    '    Select Case Public_Crawler_Strategy_module_name
    '        Case Is = "testCrawlerModule"
    '            testCrawlerModule.Public_Second_level_page_number_source_xpath = Public_Second_level_page_number_source_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中頁碼信息源元素”的 XPath 值字符串）變量更新賦值
    '            'testCrawlerModule.Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Text)
    '            'Debug.Print VBA.TypeName(testCrawlerModule)
    '            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_number_source_xpath)
    '            'Debug.Print testCrawlerModule.Public_Second_level_page_number_source_xpath
    '            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_xpath = Public_Second_level_page_number_source_xpath"
    '            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_xpath = Public_Second_level_page_number_source_xpath"
    '        Case Is = "CFDACrawlerModule"
    '        Case Else
    '            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    '            'Exit Sub
    '    End Select

    '    If Public_Browser_Name = "InternetExplorer" Then
    '        '定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
    '        ReDim tempArr(0): Rem 清空數組
    '        tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '        Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
    '        Public_Second_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '        'tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-")
    '        'Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值
    '        'Public_Second_level_page_number_source_tag_name = "": Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '        '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '        '    Else
    '        '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '        '    End If
    '        'Next
    '        'Debug.Print Public_Second_level_page_number_source_tag_name & ", " & Public_Second_level_page_number_source_position_index
    '        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    '        Select Case Public_Crawler_Strategy_module_name
    '            Case Is = "testCrawlerModule"
    '                testCrawlerModule.Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中頁碼信息源元素”的標簽名稱值字符串）變量更新賦值
    '                'Debug.Print VBA.TypeName(testCrawlerModule)
    '                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_number_source_tag_name)
    '                'Debug.Print testCrawlerModule.Public_Second_level_page_number_source_tag_name
    '                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name"
    '                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name"
    '                testCrawlerModule.Public_Second_level_page_number_source_position_index = Public_Second_level_page_number_source_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中頁碼信息源元素”的位置索引整數值）變量更新賦值
    '                'Debug.Print VBA.TypeName(testCrawlerModule)
    '                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_number_source_position_index)
    '                'Debug.Print testCrawlerModule.Public_Second_level_page_number_source_position_index
    '                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_position_index = Public_Second_level_page_number_source_position_index"
    '                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_position_index = Public_Second_level_page_number_source_position_index"
    '            Case Is = "CFDACrawlerModule"
    '            Case Else
    '                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    '                'Exit Sub
    '        End Select
    '    End If
    'End If

    '定位“當前第二層級頁面中目標數據源元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox") Is Nothing) Then
        'Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "Second level page data source xpath = " & "[ " & Public_Second_level_page_data_source_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Second_level_page_data_source_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Second_level_page_data_source_xpath = Public_Second_level_page_data_source_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中目標數據源元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_data_source_xpath)
                'Debug.Print testCrawlerModule.Public_Second_level_page_data_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_xpath = Public_Second_level_page_data_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_xpath = Public_Second_level_page_data_source_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
            Public_Second_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-")
            'Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中目標數據源元素”的位置索引整數值
            'Public_Second_level_page_data_source_tag_name = "": Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
            '    Else
            '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_Second_level_page_data_source_tag_name & ", " & Public_Second_level_page_data_source_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中目標數據源元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_data_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_Second_level_page_data_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name"
                    testCrawlerModule.Public_Second_level_page_data_source_position_index = Public_Second_level_page_data_source_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中目標數據源元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_data_source_position_index)
                    'Debug.Print testCrawlerModule.Public_Second_level_page_data_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_position_index = Public_Second_level_page_data_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_position_index = Public_Second_level_page_data_source_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If

    '定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的 XPath 值字符串
    If Not (CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox") Is Nothing) Then
        'Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
        'Debug.Print "From second level page return first level page xpath = " & "[ " & Public_From_second_level_page_return_first_level_page_xpath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_From_second_level_page_return_first_level_page_xpath 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath = Public_From_second_level_page_return_first_level_page_xpath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的 XPath 值字符串）變量更新賦值
                'testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath)
                'Debug.Print testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_xpath = Public_From_second_level_page_return_first_level_page_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_xpath = Public_From_second_level_page_return_first_level_page_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串和位置索引整數值
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值
            Public_From_second_level_page_return_first_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
            'tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-")
            'Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值
            'Public_From_second_level_page_return_first_level_page_tag_name = "": Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
            '    Else
            '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串
            '    End If
            'Next
            'Debug.Print Public_From_second_level_page_return_first_level_page_tag_name & ", " & Public_From_second_level_page_return_first_level_page_position_index
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的標簽名稱值字符串）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_second_level_page_return_first_level_page_tag_name)
                    'Debug.Print testCrawlerModule.Public_From_second_level_page_return_first_level_page_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name"
                    testCrawlerModule.Public_From_second_level_page_return_first_level_page_position_index = Public_From_second_level_page_return_first_level_page_position_index: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（定位“當前第二層級頁面中返回對應的第一層級頁面的入口元素”的位置索引整數值）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_second_level_page_return_first_level_page_position_index)
                    'Debug.Print testCrawlerModule.Public_From_second_level_page_return_first_level_page_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_position_index = Public_From_second_level_page_return_first_level_page_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_position_index = Public_From_second_level_page_return_first_level_page_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select
        End If
    End If


    ''刷新待插入目標數據源頁面的 JavaScript 脚本字符串
    'If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    '    'Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value)
    '    Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    '    'Debug.Print Public_Inject_data_page_JavaScript_filePath
    'End If
    'If Public_Inject_data_page_JavaScript_filePath <> "" Then

    '    '判斷自定義的待插入目標數據源頁面的 JavaScript 脚本文檔是否存在
    '    Dim fso As Object, sFile As Object
    '    Set fso = CreateObject("Scripting.FileSystemObject")

    '    If fso.Fileexists(Public_Inject_data_page_JavaScript_filePath) Then

    '        'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

    '        '使用 OpenTextFile 方法打開一個指定的文檔並返回一個 TextStream 對象，該對象可以對文檔進行讀操作或追加寫入操作
    '        '函數語法：object.OpenTextFile(filename[,iomode[,create[,format]]])
    '        '參數 filename 為目標文檔的路徑全名字符串
    '        '參數 iomode 表示輸入和輸出方式，可以為兩個常數之一：ForReading、ForAppending
    '        '參數 Create 表示如果指定的 filename 不存在時，是否可以新創建一個新文檔，為 Boolean 值，若創建新文檔取 True 值，不創建則取 False 值，預設為 False 值
    '        '參數 Format 為三種 Tristate 值之一，預設為以 ASCII 格式打開文檔

    '        '設置打開文檔參數常量
    '        Const ForReading = 1: Rem 打開一個只讀文檔，不能對文檔進行寫操作
    '        Const ForWriting = 2: Rem 打開一個可讀可寫操作的文檔，注意，會清空刪除文檔中原有的内容
    '        Const ForAppending = 8: Rem 打開一個可寫操作的文檔，並將指針移動到文檔的末尾，執行在文檔尾部追加寫入操作，不會刪除文檔中原有的内容
    '        Const TristateUseDefault = -2: Rem 使用系統缺省的編碼方式打開文檔
    '        Const TristateTrue = -1: Rem 以 Unicode 編碼的方式打開文檔
    '        Const TristateFalse = 0: Rem 以 ASCII 編碼的方式打開文檔，注意，漢字會亂碼

    '        '以只讀方式打開文檔
    '        Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

    '        ''判斷如果不是文檔文本的尾端，則持續讀取數據拼接
    '        'Public_Inject_data_page_JavaScript = ""
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem 從打開的文檔中讀取一行字符串拼接，並在字符串結尾加上一個回車符號
    '        '    'Debug.Print sFile.ReadLine: Rem 讀取一行，不包括行尾的換行符
    '        'Loop
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem 從打開的文檔中讀取一個字符拼接
    '        '    'Debug.Print sFile.Read(1): Rem 讀取一個字符
    '        'Loop

    '        Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem 讀取文檔中的全部數據
    '        'Debug.Print sFile.ReadAll
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem 將 Unicode 編碼的字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        sFile.Close

    '    Else

    '        Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
    '        'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

    '    End If

    '    Set sFile = Nothing
    '    Set fso = Nothing

    'End If
    ''Debug.Print "Inject data page JavaScript filePath = " & "[ " & Public_Inject_data_page_JavaScript_filePath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Inject_data_page_JavaScript_filePath 值。
    ''Debug.Print "Inject data page JavaScript = " & "[ " & Public_Inject_data_page_JavaScript & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Inject_data_page_JavaScript 值。
    ''刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    'Select Case Public_Crawler_Strategy_module_name
    '    Case Is = "testCrawlerModule"
    '        testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本路徑全名）變量更新賦值
    '        'testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript_filePath)
    '        'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript_filePath
    '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
    '        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
    '        testCrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本字符串）變量更新賦值
    '        ''testCrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript)
    '        'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript
    '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
    '        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
    '    Case Is = "CFDACrawlerModule"
    '        'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名）變量更新賦值
    '        'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath)
    '        'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath
    '        'CFDACrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本字符串）變量更新賦值
    '        ''CFDACrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript)
    '        'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript
    '    Case Else
    '        MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
    '        'Exit Sub
    'End Select


    '判斷傳入的採集起始頁碼號是否合規
    'Debug.Print "Collection of data Start Page Number = " & "[ " & CStr(Public_Start_page_number) & " ]"
    If (Public_Start_page_number <> 0) And (Public_Start_page_number > 32767) Then

        PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
        If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopCollectDataButtonClickState
                Case True
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                Case False
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                Case Else
                    MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
            End Select
        End If
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

        MsgBox "傳入參數錯誤：採集起始頁碼超出有效範圍（Start_page_number=" & CStr(Public_Start_page_number) & " > 32767），採集起始頁碼不應大於短整型變量的最大值(32767)."

        Exit Sub

    End If

    If (Public_Start_page_number <> 0) And (Public_Start_page_number < 1) Then

        PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
        If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopCollectDataButtonClickState
                Case True
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                Case False
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                Case Else
                    MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
            End Select
        End If
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

        MsgBox "傳入參數錯誤：採集起始頁碼值小於一（Start_page_number=" & CStr(Public_Start_page_number) & " < 1）."

        Exit Sub

    End If

    '判斷傳入的採集終止頁碼號是否合規
    'Debug.Print "Collection of data End Page Number = " & "[ " & CStr(Public_End_page_number) & " ]"
    If (Public_End_page_number <> 0) And (Public_Max_page_number <> 0) And (Public_End_page_number > 32767) Then

        PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
        If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopCollectDataButtonClickState
                Case True
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                Case False
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                Case Else
                    MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
            End Select
        End If
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

        MsgBox "傳入參數錯誤：採集終止頁碼超出有效範圍（End_page_number=" & CStr(Public_End_page_number) & " > 32767），採集終止頁碼不應大於短整型變量的最大值(32767)."

        Exit Sub

    End If

    If (Public_End_page_number <> 0) And (Public_Max_page_number <> 0) And (Public_End_page_number > Public_Max_page_number) Then

        PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
        If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopCollectDataButtonClickState
                Case True
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                Case False
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                Case Else
                    MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
            End Select
        End If
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

        MsgBox "傳入參數錯誤：採集終止頁碼值大於允許加載的最大網頁碼（End_page_number=" & CStr(Public_End_page_number) & " > Max_page_number=" & CStr(Public_Max_page_number) & "）."

        Exit Sub

    End If

    If (Public_Start_page_number <> 0) And (Public_End_page_number <> 0) And (Public_Start_page_number > Public_End_page_number) Then

        PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
        If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopCollectDataButtonClickState
                Case True
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                Case False
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                Case Else
                    MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
            End Select
        End If
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

        MsgBox "傳入參數錯誤：採集起始頁碼大於終止頁碼（Start_page_number=" & CStr(Public_Start_page_number) & " > End_page_number=" & CStr(Public_End_page_number) & "）."

        Exit Sub

    End If


    '判斷目標數據源頁面層級結構
    If Public_Data_level = "2" Then

        '判斷傳入的當前第一層級頁面中的第二層級頁面採集起始序號是否合規
        'Debug.Print "Collection of data Start Entry Number = " & "[ " & CStr(Public_Start_entry_number) & " ]"
        If (Public_Start_entry_number <> 0) And (Public_Start_entry_number > 32767) Then

            PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
            If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
                Select Case PublicVariableStartORStopCollectDataButtonClickState
                    Case True
                        CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                    Case False
                        CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                    Case Else
                        MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
                End Select
            End If
            'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                    'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                    'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

            CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

            MsgBox "傳入參數錯誤：當前第一層級頁面中的第二層級頁面採集起始序號值超出有效範圍（Start_entry_number=" & CStr(Public_Start_entry_number) & " > 32767），當前第一層級頁面中的第二層級頁面採集起始序號值不應大於短整型變量的最大值(32767)."

            Exit Sub

        End If

        If (Public_Start_entry_number <> 0) And (Public_Start_entry_number < 1) Then

            PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
            If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
                Select Case PublicVariableStartORStopCollectDataButtonClickState
                    Case True
                        CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                    Case False
                        CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                    Case Else
                        MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
                End Select
            End If
            'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                    'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                    'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

            CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

            MsgBox "傳入參數錯誤：傳入的當前第一層級頁面中的第二層級頁面採集起始序號值小於一（Start_entry_number=" & CStr(Public_Start_entry_number) & " < 1）."

            Exit Sub

        End If

        If (Public_Start_entry_number <> 0) And (Public_Number_of_entrance_from_first_level_page_to_second_level_page <> 0) And (Public_Start_entry_number > Public_Number_of_entrance_from_first_level_page_to_second_level_page) Then

            PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
            If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
                Select Case PublicVariableStartORStopCollectDataButtonClickState
                    Case True
                        CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                    Case False
                        CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                    Case Else
                        MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
                End Select
            End If
            'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopCollectDataButtonClickState 值。
            '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                    'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                    'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                    'Exit Sub
            End Select

            CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
            CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

            MsgBox "傳入參數錯誤：傳入的當前第一層級頁面中的第二層級頁面採集起始序號值大於當前第一層級頁面中包含的第二層級頁面入口數目（Start_entry_number=" & CStr(Public_Start_entry_number) & " > Max_entry_number=" & CStr(Public_Number_of_entrance_from_first_level_page_to_second_level_page) & "）."

            Exit Sub

        End If

    End If


    '判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            '刷新控制面板窗體控件中包含的提示標簽顯示值
            If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "啓動採集數據.": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            End If

            Call testCrawlerModule.Start_or_Stop_Collect_Data(Public_Data_Receptors, Public_Data_Server_Url, Public_Start_page_number, Public_End_page_number, Public_Start_entry_number, Public_Data_level, Public_Current_page_number, Public_First_level_page_number_source_xpath, Public_First_level_page_skip_textbox_xpath, Public_First_level_page_skip_button_xpath, Public_First_level_page_data_source_xpath, Public_First_level_page_next_button_xpath, Public_First_level_page_back_button_xpath, Public_From_first_level_page_to_second_level_page_xpath, Public_Second_level_page_data_source_xpath, Public_From_second_level_page_return_first_level_page_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name)
            'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("Start_or_Stop_Collect_Data")

            ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'End If

            ''刷新控制面板窗體控件中包含的提示標簽顯示值
            'If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
            '    CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "數據採集完畢.": Rem 提示網頁載入狀態，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 CrawlerControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“CrawlerControlPanel.Controls("Web_page_load_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            'End If

            'Exit Sub

        Case Is = "CFDACrawlerModule"

            'Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, CFDACrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem 調用運行導入的爬蟲策略模塊中包含的“Function First_level_page_Extract_Page_Number()”函數，執行讀取頁碼信息的動作。
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("First_level_page_KeyWord_Query")

            'Exit Sub

        Case Else

            MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule 爬蟲策略."
            'Exit Sub

    End Select
    ''Debug.Print VBA.TypeName(Public_Current_page_number)
    'Debug.Print Public_Current_page_number
    'Debug.Print Public_Max_page_number
    'Debug.Print Public_Number_of_entrance_from_first_level_page_to_second_level_page


    '更改按鈕狀態和標志
    If Not PublicVariableStartORStopCollectDataButtonClickState Then
        PublicVariableStartORStopCollectDataButtonClickState = Not PublicVariableStartORStopCollectDataButtonClickState
        If Not (CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopCollectDataButtonClickState
                Case True
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Start Collect Data")
                Case False
                    CrawlerControlPanel.Controls("Start_or_Stop_Collect_Data_CommandButton").Caption = CStr("Stop Collect Data")
                Case Else
                    MsgBox "Start OR Stop Collect Data Button" & "\\n" & "Function StartORStopCollectData() Variable { PublicVariableStartORStopCollectDataButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopCollectDataButtonClickState)
            End Select
        End If
        '刷新載入的爬蟲策略模塊中的變量值，判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 testCrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem 為導入的爬蟲策略模塊 CFDACrawlerModule 中包含的（監測窗體中數據採集按钮控件的點擊狀態，布爾型）變量更新賦值
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
            Case Else
                MsgBox "輸入的自定義爬蟲策略模塊名稱錯誤，無法識別傳入的名稱（Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "），目前只製作完成 testCrawlerModule、CFDACrawlerModule、... 爬蟲策略."
                'Exit Sub
        End Select
    End If


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Load_data_source_page_CommandButton（載入目標數據源網頁按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Custom_name_of_data_page_TextBox（目標數據源網頁自定義命名標識輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 URL_of_data_page_TextBox（目標數據源網站網址輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Inject_data_page_JavaScript_TextBox（待插入目標數據源網頁的 JavaScript 代碼脚本輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Keyword_Query_CommandButton（關鍵詞檢索按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Keyword_Query_TextBox（檢索關鍵詞輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_textbox_xpath_TextBox（第一層級頁面中的檢索關鍵詞文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_key_word_query_button_xpath_TextBox（第一層級頁面中的關鍵詞檢索按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Extract_Page_Number_CommandButton（獲取頁碼信息按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_page_number_TextBox（開始頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Start_entry_number_TextBox（當前第一層級頁面中的第二層級頁面入口開始序號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 End_page_number_TextBox（結束頁碼號輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_number_source_xpath_TextBox（第一層級頁面中的頁碼信息源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_first_level_page_to_second_level_page_xpath_TextBox（第一層級頁面中的從當前第一層級頁面進入第二層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem 啓用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Start_Collect_Data_CommandButton（啓動採集按鈕），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Data_Server_Url_TextBox（采集結果存儲數據庫網址輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox1（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的複選框控件 Data_Receptors_CheckBox2（采集結果保存類型複選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的單選框控件 Data_level_OptionButton1（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的按鈕控件 Data_level_OptionButton2（網頁數據的層次結構標識單選框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_data_source_xpath_TextBox（第一層級頁面中的目標數據源源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_textbox_xpath_TextBox（第一層級頁面中的跳頁目標頁碼文本輸入框元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_skip_button_xpath_TextBox（第一層級頁面中的跳頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_next_button_xpath_TextBox（第一層級頁面中的下一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 First_level_page_back_button_xpath_TextBox（第一層級頁面中的上一頁按鈕元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 Second_level_page_data_source_xpath_TextBox（第二層級頁面中的目標數據源元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊
    CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem 禁用操作面板窗體 CrawlerControlPanel 中的文本輸入框控件 From_second_level_page_return_first_level_page_xpath_TextBox（第二層級頁面中的從當前第二層級頁面返回至對應第一層級頁面的入口元素的 XPath 值輸入框），False 表示禁用點擊，True 表示可以點擊

End Sub





'**************************************************************************************************************************************************************************************************************************************


'vb webbrowser 在原窗口打开弹出新窗口的链接
'原创 2012年12月05日 19:51:56
'
'代码1:
'
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Dim frm As Form1
'Set frm = New Form1
'frm.Visible = True
'Set ppDisp = frm.WebBrowser1.Object
'End Sub
'
'代码2:
'
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Cancel = True
'WebBrowser1.Navigate2 WebBrowser1.Document.activeElement.href
'End Sub
'
'代码3:
'
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'On Error Resume Next
'Dim frmWB As Form1
'Set frmWB = New Form1
'frmWB.WebBrowser1.RegisterAsBrowser = True
'Set ppDisp = frmWB.WebBrowser1.Object
'frmWB.Visible = True
'frmWB.Top = Form1.Top
'frmWB.Left = Form1.Left
'frmWB.Width = Form1.Width
'frmWB.Height = Form1.Height
'End Sub
'
'代码4: 这个最好用了
'
'Dim WithEvents Web_V1 As SHDocVwCtl.WebBrowser_V1
'
'PrivateSub Form_Load()
'    Set Web_V1 = WebBrowser1.Object
'End Sub
'
'PrivateSub Web_V1_NewWindow(ByVal URL AsString, ByVal Flags AsLong, ByVal TargetFrameName AsString, PostData As Variant, ByVal Headers AsString, Processed AsBoolean)
'    Processed = True
'    WebBrowser1.Navigate URL
'End Sub




'***************************************************************************************************************************************************************************************************************************************



'VB关于webbrowser相关操作大全
'日期:2011-2-17
'
'1、 WebBrowser的方法、属性、事件    2
'2、 提取网页源码    3
'3、 防止新窗口里头打开网页  4
'4、 新Webbrowser控件打开链接    5
'5、 去掉滚动条  5
'6、 禁止鼠标右键    6
'7、 如何获得网页的内容  6
'8、 多框架框架页面访问  7
'9、 获得浏览器信息  7
'10、    弹出Webbrowser消息窗口  8
'11、    向Webbrowser中写入HTML内容的几种方法    8
'12、    控制页面滚动    9
'13、    判断页面是否可以前进后退    9
'14、    如何获得网页中被选中部分的HTML  10
'15、    Navigate的参数调用  11
'16、    本地文件收藏夹操作  11
'17、    让Webbrowser全屏    12
'18、    选择网页上的内容    12
'19、    用IE来下载文件  13
'20、    Webbrowser确定窗口对话框    14
'21、    禁止WebBrowser控件中网页弹窗    14
'22、    取得源码调试正常运行错误    15
'23、    页面元素操作    15
'例0: 查看网页元素 15
'例1: 给username文本框内填充内容:    15
'例2: 找到提交按钮并点击 16
'例3: 难度的 16
'例4: 模拟鼠标点击来点击按钮 17
'例5: 根据ID直接CLICK 17
'例6: 给列表单选项赋值 17
'例7: 网页自动填写表单注册 18
'24、    网页按钮的终极控制  20
'22 ?执行网页中的脚本 21
'23、提取字符串或网页源代码中指定的资源（可利用这一函数做文章采集器）    23
'24 ?中文汉字转化为URL编码 25
'25 ?获取网页中的验证码 27
'26 ?WebBrowser控件中网页按钮的点击 28
'27 ?其它 28
'
'
'
'1 ? WebBrowser的方法?属性?事件
'
'WebBrowser的8个方法和13个属性，以及它们的功能：
'
'方法 说明
'　GoBack 相当于IE的"后退"按钮，使你在当前历史列表中后退一项
'
'　GoForward 相当于IE的"前进"按钮，使你在当前历史列表中前进一项
'　GoHome 相当于IE的"主页"按钮，连接用户默认的主页
'　GoSearch 相当于IE的"搜索"按钮，连接用户默认的搜索页面
'  Navigate 连接到指定的URL
'  Refresh 刷新当前页面
'　Refresh2 同上，只是可以指定刷新级别，所指定的刷新级别的值来自RefreshConstants枚举表，
'该表定义在ExDisp.h中，可以指定的不同值如下：
'REFRESH_NORMAL 执行简单的刷新，不将HTTP pragma: no-cache头发送给服务器
'REFRESH_IFEXPIRED 只有在网页过期后才进行简单的刷新
'REFRESH_CONTINUE 仅作内部使用。在MSDN里写着DO NOT USE! 请勿使用
'REFRESH_COMPLETELY 将包含pragma: no -cache头的请求发送到服务器
'
'　Stop 相当于IE的"停止"按钮，停止当前页面及其内容的载入
'
'属性 说明
'　Application 如果该对象有效，则返回掌管WebBrowser控件的应用程序实现的自动化对象(IDispatch)。如果在宿主对象中自动化对象无效，这个程序将返回WebBrowser
'控件的自动化对象
'　Parent 返回WebBrowser控件的父自动化对象，通常是一个容器，例如是宿主或IE窗口
'  Container 返回WebBrowser控件容器的自动化对象?通常该值与Parent属性返回的值相同
'　Document 为活动的文档返回自动化对象。如果HTML当前正被显示在WebBrowser中，则
'Document属性提供对DHTML Object Model的访问途径
'　TopLevelContainer 返回一个Boolean值，表明IE是否是WebBrowser控件顶层容器，是就返回true
'
'　Type 返回已被WebBrowser控件加载的对象的类型。例如：如果加载.doc文件，就会返
'回Microsoft Word Document
'  Left 返回或设置WebBrowser控件窗口的内部左边与容器窗口左边的距离
'  Top 返回或设置WebBrowser控件窗口的内部左边与容器窗口顶边的距离
'　Width 返回或设置WebBrowser窗口的宽度，以像素为单位
'　Height 返回或设置WebBrowser窗口的高度，以像素为单位
'　LocationName 返回一个字符串，该字符串包含着WebBrowser当前显示的资源的名称，如果资源
'是网页就是网页的标题；如果是文件或文件夹，就是文件或文件夹的名称
'  LocationURL 返回WebBrowser当前正在显示的资源的URL
'　Busy 返回一个Boolean值，说明WebBrowser当前是否正在加载URL，如果返回true
'就可以使用stop方法来撤销正在执行的访问操作
'
'
'
'事件 说明
'Private Events Description
'BeforeNavigate2 导航发生前激发，刷新时不激发
'CommandStateChange 当命令的激活状态改变时激发?它表明何时激活或关闭Back和Forward
'菜单项或按钮
'DocumentComplete 当整个文档完成是激发，刷新页面不激发
'DownloadBegin 当某项下载操作已经开始后激发，刷新也可激发此事件
'DownloadComplete 当某项下载操作已经完成后激发，刷新也可激发此事件
'NavigateComplete2 导航完成后激发，刷新时不激发
'NewWindow2 在创建新窗口以前激发
'OnFullScreen 当FullScreen属性改变时激发?该事件采用VARIENT_BOOL的一个输
'入参数来指示IE是全屏显示方式(VARIENT_TRUE)还是普通显示方式(VARIENT_FALSE)
'OnMenuBar 改变MenuBar的属性时激发，标示参数是VARIENT_BOOL类型的。
'VARIANT_TRUE是可见，VARIANT_ FALSE是隐藏
'OnQuit 无论是用户关闭浏览器还是开发者调用Quit方法，当IE退出时就会激发
'OnStatusBar 与OnMenuBar调用方法相同，标示状态栏是否可见。
'OnToolBar 调用方法同上，标示工具栏是否可见。
'OnVisible 控制窗口的可见或隐藏，也使用一个VARIENT_BOOL类型的参数
'StatusTextChange 如果要改变状态栏中的文字，这个事件就会被激发，但它并不理会程序是否有状态栏
'TitleChange Title有效或改变时激发
'2 ? 提取网页源码
'方法1: XMLHTTP对象
'Public Function HtmlStr$(URL$)     '提取网页源码函数
'  Dim XmlHttp
'  Set XmlHttp = CreateObject("Microsoft.XMLHTTP")
'  XmlHttp.Open "GET", URL, False
'  XmlHttp.Send
'  If XmlHttp.ReadyState = 4 Then HtmlStr = StrConv(XmlHttp.Responsebody, vbUnicode)
'End Function
'方法2: WEBBROWSER控件
'Public Function WebDaima(WebBrowser, BuFen) '获取WebBrowser控件中网页源代码
'  Select Case BuFen
'    Case "Body"    '只获取<body>与</body>之间的代码
'      WebDaima = WebBrowser.Document.body.innerHTML
'    Case "All"     '获取整个网页源代码
'      WebDaima = WebBrowser.Document.DocumentElement.outerhtml
'    Case Else
'      WebDaima = WebBrowser.Document.DocumentElement.outerhtml
'  End Select
'End Function
'Dim strWeb As String
'strWeb = WebDaima(frmIndex.WebBrowser1, "All") '获取整个网页源代码
'strWeb = WebDaima(frmIndex.WebBrowser1, "Body") '只获取body中源代码
'3 ? 防止新窗口里头打开网页
'代码1:
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Dim frm As Form1
'Set frm = New Form1
'frm.Visible = True
'Set ppDisp = frm.WebBrowser1.Object
'End Sub
'
'代码2:
'有这段代码， 有许多网页会出错，经常提示脚本错误，可以用silent属性为True来屏蔽，不过也有些不足！！！
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Cancel = True
'WebBrowser1.Navigate2 WebBrowser1.Document.activeElement.href
'End Sub
'
'代码3:
'
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'On Error Resume Next
'Dim frmWB As Form1
'Set frmWB = New Form1
'frmWB.WebBrowser1.RegisterAsBrowser = True
'Set ppDisp = frmWB.WebBrowser1.Object
'frmWB.Visible = True
'frmWB.Top = Form1.Top
'frmWB.Left = Form1.Left
'frmWB.Width = Form1.Width
'frmWB.Height = Form1.Height
'End Sub
'
'功能差不多，任选一个。
'
'4 ? 新Webbrowser控件打开链接
'
' Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'  Set ppDisp = WebPageAd.Object
'End Sub
'
'5 ? 去掉滚动条
'
'Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
'WebBrowser1.Document.body.Scroll = "no"
'End Sub
'实际上上面的效果不咋地，如果懂得HTML知识， 你可以在读取网页的时候，读取HTML源码， 查找替换， 再写入只需在 <body>   </body> 之间插入代码： <body   style= "overflow-x:hidden;overflow-y:hidden "> 即可。其中x表示水平滚动条，将其改为y的话就可以隐藏垂直滚动条。
'当然也有其他方法， 比如修改网页的尺寸呀？ 有的时候部分元素的居中改为左对齐也能有效果
'将WebBrower放在PictureBox控件中，用PictureBox的边框挡住WebBrower的边框。
'例如,将WebBrowser1放大点,将PictureBox变小点...PictureBox的appearance设置为0-flat，呵呵，OK~~
'
'6 ? 禁止鼠标右键
'
'Private Function M_Dom_oncontextmenu() As Boolean
'WebBrowser1.Document.oncontextmenu = False
'End Function
''引用Microsoft HTML OBject Library
'
'Dim WithEvents M_Dom As MSHTML.HTMLDocument
'Private Function M_Dom_oncontextmenu() As Boolean
'M_Dom_oncontextmenu = False
'End Function
'
'Private Sub WebBrowser1_DownloadComplete()
'Set M_Dom = WebBrowser1.Document
'End Sub
'
'
'
'7 ? 如何获得网页的内容
'先给个例子:
'innerHTML: 设置或获取位于对象起始和结束标签内的 HTML
'
'测试一下:
'
'<div id="d" style="background-color:#ff9966">这是一个层</div>
'<input type="button" value="获取innerHTML" onclick="getinnerHTML()">
'<input type="button" value="设置innerHTML" onclick="setinnerHTML()">
'<script language="javascript">
'Function getinnerHTML()
'{
'alert (Document.getElementById("d").innerHTML)
'}
'Function setinnerHTML()
'{
'Document.getElementById("d").innerHTML = "<div id='d' style='background-color:#449966'>这是一个层,嘿嘿</div>"
'}
'</script>
'
'8 ? 多框架框架页面访问
''下面两句可以访问到多框架内容
''.Document.ParentWindow.Frames.Length
''.Document.ParentWindow.Frames(1).Document.all.tags("a")
'
'        '等待多框架网页全部加载完毕， 否则出错
'        While .Busy Or .ReadyState <> 4 Or .Document.parentWindow.Frames.Length = 0
'            DoEvents
'        Wend
'
'9 ? 获得浏览器信息
'
'Private Sub Command1_Click()
'WebBrowser1.Navigate "http://www.applevb.com"
'End Sub
'Private Sub Command2_Click()
'Dim oWindow
'Dim oNav
'Set oWindow = WebBrowser1.Document.parentWindow
'Set oNav = oWindow.navigator
'Debug.Print oNav.userAgent
'Set oWindow = Nothing
'Set oNav = Nothing
'End Sub
'
'
'10 ? 弹出Webbrowser消息窗口
'
'Dim oWindow
'Set oWindow = WebBrowser1.Document.parentWindow
'oWindow.confirm "abcd"
'
'VB调用webbrowser技巧集2
'
'11 ? 向Webbrowser中写入HTML内容的几种方法
'
'向Webbrowser中写入HTML内容的几种方法
'
'首先在Form_Load中加入
'
'WebBrowser1.Navigate "about:blank"
'
'确保Webbrowser1可用
'
'
'方法1:
'
'Dim s As String
'Dim stream As IStream
'
's = ""
's = s + ""
's = s + ""
's = s + ""
'
'hello world
'
'"
's = s + ""
's = s + ""
'WebBrowser1.Document.Write s
'
'
'方法2:
'
'Dim o
'
'Set o = WebBrowser1.Document.Selection.createRange
'Debug.Print o
'If (Not o Is Nothing) Then
'o.pasteHTML "哈哈"
'Set o = Nothing
'End If
'
'
'方法3:
'
''插入文本框
'Dim o
'
'Set o = WebBrowser1.Document.Selection.createRange
'
'o.execCommand "InsertTextArea", False, "xxx"
'
'
'12 ? 控制页面滚动
'WebBrowser1.Document.parentWindow.scrollby 0, 30
'
'13 ? 判断页面是否可以前进后退
'
'Private Sub Command1_Click()
'WebBrowser1.GoForward
'End Sub
'
'Private Sub Command2_Click()
'WebBrowser1.GoBack
'End Sub
'
'Private Sub Form_Load()
'WebBrowser1.Navigate "http://www.applevb.com"
'End Sub
'
'Private Sub WebBrowser1_CommandStateChange(ByVal Command As Long, ByVal Enable As Boolean)
'If (Command = CSC_NAVIGATEBACK) Then
'Command2.Enabled = Enable
'End If
'If (Command = CSC_NAVIGATEFORWARD) Then
'Command1.Enabled = Enable
'End If
'End Sub
'
'
'14 ? 如何获得网页中被选中部分的HTML
'
'Private Sub Command1_Click()
'Dim objSelection
'Dim objTxtRange
'
'Set objSelection = WebBrowser1.Document.Selection
'If Not (objSelection Is Nothing) Then
'Set objTxtRange = objSelection.createRange
'If Not (objTxtRange Is Nothing) Then
'Debug.Print objTxtRange.HTMLText
'
'Set objTxtRange = Nothing
'End If
'Set objSelection = Nothing
'End If
'End Sub
'
'
'
'15 ? Navigate的参数调用
'请问: 在WebBrwoser控件里提供的Navigate或者Navigate2方法中提供了传递数据
'
'的参数，调用方式为：WebBrowser1.Navigate2(URL,[Flags],
'
'[TargetFrameName],[PostData],[Headers])
'其中PostData参数就是一个提交参数字符串，例如"name=aaa&password=123"，
'
'但问题是为什么这个方法并不是有效的，服务器端不能取得数据？
'如果这个方法是有效的话就不需要用一段html代码模拟这种调用了?
'
'下面代码能检测出程序post出去的消息
'
'Private Sub WebBrowser1_BeforeNavigate2(ByVal pDisp As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
'MsgBox PostData
'End Sub
'
'
'
'
'
'16 ? 本地文件收藏夹操作
'
'基本上用 specialfolder(6 ) 就可以得到收藏夹的路径, 然后你可以用dir去循环读入每个目录,然后dir里面的file, file的名字就是你要的收藏的名字, 路径可以自己根据从上面得到的路径去得到.
'如果你不用dir也可以用vb的dir控件.
'Private Type SHITEMID
'cb As Long
'abID As Byte
'End Type
'
'Public Type ITEMIDLIST
'mkid As SHITEMID
'End Type
'Public Function SpecialFolder(ByRef CSIDL As Long) As String
'locate the favorites folder
'Dim R As Long
'Dim sPath As String
'Dim IDL As ITEMIDLIST
'Const NOERROR = 0
'Const MAX_LENGTH = 260
'R = SHGetSpecialFolderLocation(MDIMain.hwnd, CSIDL, IDL)
'If R = NOERROR Then
'sPath = Space$(MAX_LENGTH)
'R = SHGetPathFromIDList(ByVal IDL.mkid.cb, ByVal sPath)
'If R Then
'SpecialFolder = Left$(sPath, InStr(sPath, vbNullChar) - 1)
'End If
'End If
'End Function
'
'
'17 ? 让Webbrowser全屏
'是的,webbrowser本生是一个控件, 你要它全屏,就是要它所在的窗体全屏,
'可以用setwindowlong取消窗体的 title,
'用Call ShowWindow(FindWindow(Shell_traywnd, ), 0) 隐藏tray,就是下边那个包含开始那一行.
'用Call ShowWindow(FindWindow(Shell_traywnd, ), 9) 恢复. 够详细了吧.
'
'然后在form1.windowstate = 2 就可以了.
'
'18 ? 选择网页上的内容
'Private Sub Command1_Click()
'请先选中一些内容
'Me.WebBrowser1.ExecWB OLECMDID_COPY, OLECMDEXECOPT_DODEFAULT
'MsgBox Clipboard.GetText
'End Sub
'
'
'19 ? 用IE来下载文件
'Private Declare Function DoFileDownload Lib shdocvw.dll (ByVal lpszFile As String) As Long
'
'
'Private Sub Command1_Click()
'
'Dim sDownload As String
'
'sDownload = StrConv(Text1.Text, vbUnicode)
'Call DoFileDownload(sDownload)
'
'End Sub
'
'保存webbrowser中的HTML内容
'Dim oPF As IPersistFile
'Set oPF = WebBrowser1.Document
'oPF.Save "TheFileNameHere.htm", False
'
'WebBrowser1.ExecWB怎么用
'
'下面是我测试的参数
'WB.ExecWB(4,1)
'
'4,1 保存网页
'4,2 保存网页(可以重新命名)
'6,1 直接打印
'6,2 直接打印
'7,1 打印预览
'7,2 打印预览
'8,1 选择参数
'8,2 选择参数
'10,1 查看页面属性
'10,2 查看页面属性
'17,1 全选
'17,2 全选
'22,1 重新载入当前页
'22,2 重新载入当前页
'
'
'20 ? Webbrowser确定窗口对话框
'某些网页出于各种考虑会弹出对话框要求信息确认，往往会中断我们的webbrowser过程，可以使用如下方法：
'1.加入Microsoft Html Object
'2.加入语句
'
'Private Sub WebBrowser1_NavigateComplete2(ByVal pDisp As Object, URL As Variant)
'Dim obj As HTMLDocument
'Set obj = pDisp.Document
'obj.parentWindow.execScript "function showModalDialog(){return;}" '对showModalDialog引起的对话框进行确定
'End Sub
'而confirm引发的对话确定框可用confirm替换showModalDialog即可，Alert等同理~
'
'WebBrowser取得网页源码Private Sub Command1_Click()
'WebBrowser1.Navigate "http://www.sdqx.gov.cn/sdcity.php"
'End Sub
'
'Private Sub WebBrowser1_DownloadComplete()
''页面下载完毕
'Dim doc, objhtml
'Set doc = WebBrowser1.Document
'
'Set objhtml = doc.body.createtextrange()
'If Not IsNull(objhtml) Then
'Text1.Text = objhtml.HTMLText
'End If
'
'End Sub
'
'
'
'21 ? 禁止WebBrowser控件中网页弹窗
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'  Cancel = True
'End Sub
'全部调试信息被禁止
'22 ? 取得源码调试正常运行错误
'我用WebBrowser取得网页源码，直接运行正常，但在编译后出错
'
'提示：实时错误"91" Object 变量或 with 块变量没有设置
'可能是没有下载完所致，
'
'Private Sub WebBrowser1_DownloadComplete()
'If WebBrowser.Busy = False Then
'Dim doc, objhtml
'Set doc = WebBrowser1.Document
'
'Set objhtml = doc.body.createtextrange()
'If Not IsNull(objhtml) Then
'Text1.Text = objhtml.HTMLText
'End If
'End If
'End Sub
'23 ? 页面元素操作
'1.根据标记名(tagname)的和元素名name来找到元素,
'2.给元素赋值或是执行相关的事件.
'
'例0: 查看网页元素
'  Dim a
'  For Each a In wbr.Document.All
'      Text1.Text = Text1.Text & TypeName(a) & vbCrLf
'  Next
'
'例1: 给username文本框内填充内容:
'Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
'Dim doc
'Dim tg
'Set doc = WebBrowser1.Document
'For i = 0 To doc.All.Length - 1
'If (LCase(doc.All(i).tagName)) = "input" Then
'If (LCase(doc.All(i).Name)) = "username" Then
'Set tg = doc.All(i)
'tg.Value = Text1.Text
'End If
'End If
'Next i
'End Sub
'
'
'
''文本框代码：<input id="WordInput" maxlength="40" type="text" />
'WebBrowser1.Document.getElementsByTagName("input")("WordInput").Value = "要在文本框输入的文字"
''此处WordInput为文本框的ID或Name属性值
'
'例2: 找到提交按钮并点击
'Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
'Dim doc
'Dim tg
'Set doc = WebBrowser1.Document
'For i = 0 To doc.All.Length - 1
'If (LCase(doc.All(i).tagName)) = "input" Then
'If (LCase(doc.All(i).Type)) = "submit" Then
'Set tg = doc.All(i)
'tg.Click
'End If
'End If
'Next i
'End Sub
'
'上面在MSDN2找到个答案还没试.IFRAME内的网页的方法不同,可能要用到窗口.试验后再说吧.
'
'例3: 难度的
'INPUT onclick="this.disabled=true;this.value='登录中……请稍候……';document.form1.submit();" type=submit value=" 登 录 "
'
'For i = 0 To vDoc.All.Length - 1
'用 i 来判断submit 为第几个，再点击它
'
'
'例4: 模拟鼠标点击来点击按钮
'Private Declare Function GetMessageExtraInfo Lib "user32" () As Long
'Private Declare Sub mouse_event Lib "user32" _
'                (ByVal dwFlags As Long, _
'                                     ByVal dx As Long, _
'                                     ByVal dy As Long, _
'                                     ByVal cButtons As Long, _
'                                     ByVal dwExtraInfo As Long)
'Private Const MOUSEEVENTF_LEFTDOWN As Long = &H2
'Private Const MOUSEEVENTF_LEFTUP As Long = &H4
'Sub clk()
''至于按钮的坐标值就是x,y，这个你得自己找了，因为窗口放在不同的位置，坐标是不一样的，你可以用getcursorpos取得，
''不过，就算你点了，又有什么用呢？点完了还是要验证码的！
'mouse_event MOUSEEVENTF_LEFTDOWN, x, y, 0, GetMessageExtraInfo
'mouse_event MOUSEEVENTF_LEFTUP, x, y, 0, GetMessageExtraInfo
'End Sub
'
'例5: 根据ID直接CLICK
'
''<BUTTON id="WordSearchBtn" class="btn">查询</button>
''此按钮的点击方法
'WebBrowser1.Document.getElementsByTagName("BUTTON")("WordSearchBtn").Click
'
'例6: 给列表单选项赋值
'
'Public Function SelectXq(WebBrowser, SelectName, SelectValue)
'  '参数
'  'WebBrowser:WebBrowser控件名称
'  'SelectName:网页中 列表/菜单 表单名称或ID值
'  'SelectValue:选中值
'  WebBrowser.doc.All.Item(SelectName).Value = SelectValue
'End Function
'函数调用方法:
'WebBrowser中网页Select表单代码如下:
'
'<SELECT id=ctl00_ContentPlaceHolder1_DropDownList1 name=ctl00$ContentPlaceHolder1$DropDownList1> <OPTION value=我就读的第一所学校的名称？ selected>我就读的第一所学校的名称？</OPTION> <OPTION value=我最喜欢的休闲运动是什么？>我最喜欢的休闲运动是什么？</OPTION> <OPTION value=我最喜欢的运动员是谁？>我最喜欢的运动员是谁？</OPTION> <OPTION value=我最喜欢的物品的名称？>我最喜欢的物品的名称？</OPTION> <OPTION value=我最喜欢的歌曲？>我最喜欢的歌曲？</OPTION> <OPTION value=我最喜欢的食物？>我最喜欢的食物？</OPTION> <OPTION value=我最爱的人的名字？>我最爱的人的名字？</OPTION> <OPTION value=我最爱的电影？>我最爱的电影？</OPTION> <OPTION value=我妈妈的生日？>我妈妈的生日？</OPTION></SELECT>
'
''让列表表单选中选项值为 我最爱的人的名字 的选项
'
'Call SelectXq(Form1.WebBrowser1, "ctl00_ContentPlaceHolder1_DropDownList1", "我最爱的人的名字？")
'
'
'例7: 网页自动填写表单注册
'  <form   method="POST"   action="result.asp">
'      <p>请填写下面表单注册（*项为必添项）</p>
'      <p>*姓名<input   type="text"   name="Name"   size="20"></p>
'      <p>*男<input   type="radio"   value="V1"   name="R1"></p>
'      <p>*女<input   type="radio"   value="V1"   name="R2"></p>
'      <p>*昵称<input   type="text"   name="NickName"   size="20"></p>
'   <p>*兴趣爱好<select name="aihao">
'     <option value="计算机">计算机</option>
'     <option value="游戏">游戏</option>
'     <option value="逛街">逛街</option>
'   </select></p>
'      <p>电子邮件<input   type="text"   name="EMail"   size="20"></p>
'      <p>*密码<input   type="password"   name="Password"   size="20"></p>
'      <p><input   type="submit"   value="提交"   name="B1">
'      <input   type="reset"   value="全部重写"   name="B2"></p>
'  </form>
'    填写表单并提交操作代码
'Private Sub Form_Load()
'  WebBrowser1.Navigate2 App.Path & "\test.htm"
'End Sub
'
'Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
'  Dim vDoc, vTag
'  Dim i As Integer
'  Set vDoc = WebBrowser1.Document
'  List1.Clear
'  For i = 0 To vDoc.All.Length - 1
'    If UCase(vDoc.All(i).tagName) = "INPUT" Or UCase(vDoc.All(i).tagName) = "SELECT" Then
'      Set vTag = vDoc.All(i)
'      If vTag.Type = "text" Or vTag.Type = "password" Or vTag.Type = "radio" Or vTag.Name = "aihao" Then
'        List1.AddItem vTag.Name
'        Select Case vTag.Name
'          Case "Name"
'            vTag.Value = "IMGod"
'          Case "R2"
'            vTag.Checked = True
'          Case "NickName"
'            vTag.Value = "IMGod"
'          Case "aihao"
'            vTag.Value = "逛街"
'          Case "Password"
'            vTag.Value = "IMGodpass"
'          Case "EMail"
'            vTag.Value = "IMGod@paradise.com"
'        End Select
'      ElseIf vTag.Type = "submit" Then
'        vTag.Click
'      End If
'    End If
'  Next i
'End Sub
'
'24 ? 网页按钮的终极控制
''一般来说,最简单最直接的操作网页表单提交方法就是
'WebBrowser1.Document.All("Namd").Value = "xxxx"      '填表
'WebBrowser1.Document.All("DengLu").Click        '按钮点击
''不过此方法需要知道该表单的各个元素的ID.一般来说,普通的网页都能直接从网页源文件中找到这些东西.
''假如整个表单都没能在源文件中找到的,那可以用
'    Text1 = WebBrowser1.Document.getElementById("BiaoID").innerHTML        '"BiaoID"为表单所在表格的ID
''这样Text1显示出来的就是你所要的表单的代码了.
''不过即使是得到隐藏的代码了,还是有可能碰到没ID没NAME没类型的按钮,这怎么办呢?
''不怕,通用方法来了.
''没ID我们就给它个ID嘛.
''在DocumentComplete里网页完全打开后
''处理网页源码,给你要点击的按钮起个名(加上ID)
''例如:
'    Text1 = <BUTTON style='PADDING-RIGHT: 2px; PADDING-LEFT: 2px; PADDING-BOTTOM: 2px; MARGIN-LEFT: 3px; LINE-HEIGHT: 100%; PADDING-TOP: 2px; HEIGHT: 20px' onclick=javascript:btnSeedFetcherClick.call(this)>确定</BUTTON>
''将其变为:
'    Text1 = <BUTTON  ID=abc style='PADDING-RIGHT: 2px; PADDING-LEFT: 2px; PADDING-BOTTOM: 2px; MARGIN-LEFT: 3px; LINE-HEIGHT: 100%; PADDING-TOP: 2px; HEIGHT: 20px' onclick=javascript:btnSeedFetcherClick.call(this)>确定</BUTTON>
''然后用
'    WebBrowser1.Document.body.innerHTML = Text1.Text        '将处理完的网页装入WebBrowser1
''然后就可以用回一开始说的最简单的方法来点击了
'    WebBrowser1.Document.All("abc").Click        '按钮点击
''怎么样,是不是很爽丫,这样就不用去思考还有没什么条件可以来定位这个按钮然后再点击了.
''当然,还有中方法是:
'    Dim OButton
'    OButton = WebB.Document.getElementsByTagName("BUTTON")
'    OButton.Click       '这样就点击了前边例子中的那个按钮了.
''这方法通用性也是很强,自己研磨一下你就能运用自如了.
'
'
'22 ?执行网页中的脚本
'Function js(scripts)
'  On Error GoTo 1
'  If scripts = "" Then Exit Function
'Set Document = WebBrowser1.Document
'  Document.parentWindow.execScript scripts, "javascript"
'Exit Function
'1
'  MsgBox "运行js脚本时发生错误!"
'End Function
'
'javascript:
'function findNode(findString,obj){
'var findId=true;
'var findStrings=findString.split(';');
'for(var i=0;i<obj.childNodes.length;i++){
'findId=true;
'if(obj.childNodes.length>0){
'var objs=findNode(findString,obj.childNodes[i]);
'if(objs!=null)return objs;
'}
'for(var k=0;k<findStrings.length;k++){
'var temp=findStrings[k].split('=');
'eval("var temp2=obj.childNodes[i]."+temp[0])
'if(temp2!=temp[1]){
'findId=false;
'break;
'}
'}
'if(findId){
'return obj.childNodes[i];
'}
'}
'return null;
'}
'例：<input onclick="window.location.href='resourceissue.jsf';" type="button" value="资源发布" style="cursor: pointer;"/>
'js "findNode('nodeName=INPUT;value=资源发布',document.documentElement).click()"
'
'注：如你打不的不是你的网站页面，可以用VB的JS函数先执行一下我写的这个javascript:findNode函数如：js "function findNode(findString,obj){...."
'上面findNode函数要去掉换行符，这里是为了直观才加上的换行符
'
'
'例： <IMG SRC="top.png" WIDTH="21" HEIGHT="18" BORDER="0" ALT="">
'js "findNode( 'nodeName=IMG;src=top.png;',document.documentElement).click() "
'例： <a href="top.html">xxxx</a>
'js "findNode( 'nodeName=IMG;src=top.png;#text=xxxx',document.documentElement).click() "
'
'
'我用alert(document.getElementById( "tdGetSeed ").innerHTML); 看了是：<form id=frmgetseed style="...." onsubmit="return false"><input id=btnGetSeed style="..." onclick=javascript:getSeedClick.call(this); type=image src="...gif"></form>
'
'所以用:
'Set Document = WebBrowser1.Document
'document.getElementById("btnGetSeed").click()
'是可以的
'现在你不用上面那么多代码了，只要一条就行，那就是：
'document.getElementById("btnGetSeed").click()
'或
'Set Document = WebBrowser1.Document
'Document.parentWindow.execScript "getSeedClick.call(document.getElementById('frmgetseed'))", "javascript "
'
'
'
'
'
'23 ?提取字符串或网页源代码中指定的资源 (可利用这一函数做文章采集器)
'　　1.函数代码：
'Public Function FindStrMulti$(Strall$, FirstStr$, EndStr$, SplitStr$) '提取字符串或网页源代码中所有指定代码
'  '参数
'  '总文本,起始字符串,终止字符串,分隔符
'  Dim i&, j&
'  j = 1
'  Do
'    i = InStr(j, Strall, FirstStr)
'    If i = 0 Then
'      Exit Do
'    End If
'    i = i + Len(FirstStr)
'    j = InStr(i, Strall, EndStr)
'    If j > 0 Then
'      FindStrMulti = IIf(Len(FindStrMulti) > 0, FindStrMulti & SplitStr, "") & Mid(Strall, i, j - i)
'    Else
'      Exit Do
'    End If
'  Loop
'End Function
'　　2.函数调用
'     截取字符串中的内容
'Dim str1 As String
'Dim str2 As String
'str1 = "<table><tr><td>要截取的内容</td></tr></table>"
'str2 = FindStrMulti(str1, "<td>", "</td>", "")
'MsgBox str2
''此时str2的值就为 要截取的内容
'    文章列表标题链接采集实例
'    网页代码
'<DIV id=content><SPAN class=navbar><STRONG><A href="/blog/">博客首页</A> &gt; 文章列表</STRONG></SPAN>
'<TABLE class=content_table width="100%">
'<TBODY>
'<TR>
'<TD>
'<H1>比目鱼博客文章列表</H1>
'<P>
'<UL>
'<LI><SPAN class=list-category>[文坛张望]</SPAN> <A class=list-title href="/blog/archives/119491210.shtml"><STRONG>谁会拿下2010年的诺贝尔文学奖？</STRONG></A> <SPAN class=list-date>(2010-10-01 22:38)</SPAN></LI>
'<LI><SPAN class=list-category>[视觉训练]</SPAN> <A class=list-title href="/blog/archives/119247165.shtml"><STRONG>书法练习二幅</STRONG></A> <SPAN class=list-date>(2010-09-29 01:51)</SPAN> </LI>
'<LI><SPAN class=list-category>[文坛张望]</SPAN> <A class=list-title href="/blog/archives/118604217.shtml"><STRONG>骆以军对话董启章</STRONG></A> <SPAN class=list-date>(2010-09-21 17:15)</SPAN> </LI>
'<LI><SPAN class=list-category>[视觉训练]</SPAN> <A class=list-title href="/blog/archives/118206492.shtml"><STRONG>夜临古画（六） </STRONG></A><SPAN class=list-date>(2010-09-17 01:46)</SPAN> </LI>
'<LI><SPAN class=list-category>[我也读书]</SPAN> <A class=list-title href="/blog/archives/117345094.shtml"><STRONG>Jennifer Egan 的《A Visit From the Goon Squad》</STRONG></A> <SPAN class=list-date>(2010-09-07 02:30)</SPAN> </LI>
'<LI><SPAN class=list-category>[我也读书]</SPAN> <A class=list-title href="/blog/archives/116446375.shtml"><STRONG>当我们谈论电子书的时候我们在谈论电子书阅读器</STRONG></A> <SPAN class=list-date>(2010-08-27 16:51)</SPAN> </LI>
'<LI><SPAN class=list-category>[IT互联网]</SPAN> <A class=list-title href="/blog/archives/116133972.shtml"><STRONG>"读写人"和"比目鱼"网站的手机版</STRONG></A> <SPAN class=list-date>(2010-08-24 02:04)</SPAN> </LI>
'</UL>
'<P></P>
'<P align=center>
'<P align=center><STRONG>1 <A href="/blog/list_all_2.shtml">2</A> <A href="/blog/list_all_3.shtml">3</A> <A href="/blog/list_all_4.shtml">4</A> <A href="/blog/list_all_5.shtml">5</A> <A href="/blog/list_all_6.shtml">6</A> <A href="/blog/list_all_7.shtml">7</A> <A href="/blog/list_all_8.shtml">8</A> <A href="/blog/list_all_2.shtml">&gt;&gt;</A> </STRONG></P>
'<P></P></TD></TR></TBODY></TABLE>
'<P>&nbsp;</P></DIV><!-- END CONTENT --><!-- BEGIN SITEBAR -->
'<DIV id=sidebar>
'<P>
' 　　从以上代码中获取<ul>与</ul>之间所有文章的标题链接，实现方法如下：
'Dim strWeb As String
'Dim i As Integer
'Dim strListArea As String
'Dim strLink '定义存放列表文章链接的数组
'strWeb = WebDaima(Me.WebBrowser1, "Body")  '获取网页body代码(具体查看WebDaima函数)
'strListArea = FindStrMulti(strWeb, "<H1>比目鱼博客文章列表</H1>", "</UL>", "") '截列表区域代码
''获取列表区域中文章链接，并存在在数组strLink中
'strLink = Split(FindStrMulti(strListArea, "href=" & Chr(34), Chr(34) & "><STRONG>", vbCrLf), vbCrLf)
'For i = 0 To UBound(strLink) '循环输出链接
'  Text1.Text = Text1.Text & strLink(i) & vbCrLf
'Next i
'24 ?中文汉字转化为URL编码
'函数代码:
''以下两个函数用于将文字转化为UTF8或GBK编码：(如在百度中搜索内容时，百度先将搜索词转化为UTF8的编码，再传送给服务器)
''调用：
''KeyWordUtf = UTF8EncodeURI(KeyWord) 或 KeyWordUtf = GBKEncodeURI(KeyWord)
'Public Function UTF8EncodeURI(szInput)
'  Dim wch, uch, szRet
'  Dim x
'  Dim nAsc, nAsc2, nAsc3
'  If szInput = "" Then
'    UTF8EncodeURI = szInput
'    Exit Function
'  End If
'  For x = 1 To Len(szInput)
'    wch = Mid(szInput, x, 1)
'    nAsc = AscW(wch)
'    If nAsc < 0 Then nAsc = nAsc + 65536
'      If (nAsc And &HFF80) = 0 Then
'        szRet = szRet & wch
'      Else
'        If (nAsc And &HF000) = 0 Then
'          uch = "%" & Hex(((nAsc \ 2 ^ 6)) Or &HC0) & Hex(nAsc And &H3F Or &H80)
'          szRet = szRet & uch
'        Else
'          uch = "%" & Hex((nAsc \ 2 ^ 12) Or &HE0) & "%" & _
'          Hex((nAsc \ 2 ^ 6) And &H3F Or &H80) & "%" & _
'          Hex(nAsc And &H3F Or &H80)
'          szRet = szRet & uch
'        End If
'      End If
'  Next
'  UTF8EncodeURI = szRet
'End Function
'Public Function GBKEncodeURI(szInput)
'  Dim i As Long
'  Dim x() As Byte
'  Dim szRet As String
'  szRet = ""
'  x = StrConv(szInput, vbFromUnicode)
'  For i = LBound(x) To UBound(x)
'    szRet = szRet & "%" & Hex(x(i))
'  Next
'  GBKEncodeURI = szRet
'End Function
'函数调用:
'MsgBox UTF8EncodeURI("中文汉字")
'MsgBox GBKEncodeURI("中文汉字")
'25 ?获取网页中的验证码
'函数代码:
'Public Function GetImg(WebBrowser, Img, sxz)
''参数
''WebBrowser:等获取验证码网页所在的WebBrowser控件
''Img:显示验证码的Image控件
''sxz:网页中验证码相应属性的属性值
'  Dim CtrlRange, x
'  For Each x In WebBrowser.Document.All
'    If UCase(x.tagName) = "IMG" Then
'      'x.src为验证码图片的属性,也可是其他属性 如 x.onload等
'      If InStr(x.src, sxz) > 0 Then
'        Set CtrlRange = WebBrowser.Document.body.createControlRange()
'        CtrlRange.Add (x)
'        CtrlRange.execCommand ("Copy")
'        Debug.Print "Copy"
'        Img.Picture = Clipboard.GetData
'      End If
'    End If
'  Next
'End Function
'函数调用:
''如获取网页http://www.pceggs.com/login.aspx中的验证码图片代码如下：
''<IMG id=valiCode style="CURSOR: pointer" alt=验证码 src="/VerifyCode_Login.aspx" border=0>
''获取验证码函数调用如下：
'Call GetImg(Form1.WebBrowser1, Form1.Image1, "VerifyCode_Login.aspx")
'26 ?WebBrowser控件中网页按钮的点击
'
'27 ?其它
'
'窗体透明控件不透明
'Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" ( _
'                ByVal hwnd As Long, _
'                ByVal nIndex As Long) As Long
'
'Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" ( _
'                ByVal hwnd As Long, _
'                ByVal nIndex As Long, _
'                ByVal dwNewLong As Long) As Long
'
'Private Declare Function SetLayeredWindowAttributes Lib "user32" ( _
'                ByVal hwnd As Long, _
'                ByVal crKey As Long, _
'                ByVal bAlpha As Byte, _
'                ByVal dwFlags As Long) As Long







'*********************************************************************************************************************************************************************************


'如何通过VBA高亮显示EXCEL活动单元格所在行和列

'Private Sub Worksheet_SelectionChange(ByVal Target As Range)
'    If Target.EntireColumn.Address = Target.Address Then
'        Cells.Interior.ColorIndex = xlNone
'        Exit Sub
'    End If
'    If Target.EntireRow.Address = Target.Address Then
'        Cells.Interior.ColorIndex = xlNone
'        Exit Sub
'    End If
'    Cells.Interior.ColorIndex = xlNone
'    Rows(Selection.Row & ":" & Selection.Row + Selection.Rows.Count - 1).Interior.ColorIndex = 35
'    Columns(Selection.Column).Resize(, Selection.Columns.Count).Interior.ColorIndex = 20
'End Sub
