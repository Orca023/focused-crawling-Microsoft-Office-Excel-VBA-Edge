Attribute VB_Name = "CrawlerDispatchModule"

'Author: 趙健
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
'Date: 歲在丙申


' 語句 Option Explicit 需要放置在所有 Sub 之前；當 Option Explicit 語句出現在模塊中時，必須使用 Dim、Private、Public、ReDim或Static 語句顯式聲明所有變量；如果使用了未事先聲明的變量名稱，則會在編譯時出現錯誤。如果沒有使用 Option Explicit 語句，則所有未聲明的變量都將為 Variant 類型。
Option Explicit

'關閉屏幕更新，可以加快運算速度
'Application.ScreenUpdate = False
'當VBA程序運行結束時再將該值還原為True設置
'Application.ScreenUpdate = True
'關閉單元格自動計算改爲手動按 F9 鍵才能計算，可以加快運算速度
'Application.Calculation = xlCalculationManual
'當VBA程序運行結束時再將單元格還原爲自動計算模式
'Application.Calculation = xlCalculationAutomatic


'Public shellPIDarr(0 To 9) As Integer  '公共變量記錄新建的服務器進程的 PID 值，用於退出時中止進程
'Public shellPIDindex As Integer
'shellPIDindex = 0
Public shellPIDdict As Object  '公共變量記錄新建的服務器進程的 PID 值，用於退出時中止進程
Public importModuleNamedict As Object  '公共變量記錄新導入的模塊的名字值，用於退出時移除導入模塊
Sub initial()
    Set shellPIDdict = CreateObject("Scripting.Dictionary")
    'Debug.Print shellPIDdict.Count
    Set importModuleNamedict = CreateObject("Scripting.Dictionary")
    'Debug.Print importModuleNamedict.Count
End Sub


Sub MenuSetup()

    '語句 On Error Resume Next 會使程序按照產生錯誤的語句之後的語句繼續執行
    On Error Resume Next
    
    ''Application.CommandBars("Worksheet Menu Bar").Add(Name, Position, MenuBar, Temporary)
    ''這裡的 CommandBars 是 Application 對象的屬性，返回一個 CommandBars 對象，CommandBars(index) 這種標記法則返回一個具體的 CommandBar 對象。index 可以是 CommandBar 對象的編號，也可以是 CommandBar 對象的名稱。Excel 的功能表列名稱是"Worksheet Menu Bar"，編號是 1。常用的工具列有"Standard"，編號 3；"Formatting"， 編號 4。滑鼠右鍵點工作表區域出來的快顯功能表名稱是"Cell"，編號是 36。用名稱和用編號訪問 CommandBar 對象是等價的。
    'Dim ToolBar As CommandBar  '工具欄
    'Set ToolBar = Application.CommandBars.Add()  '創建工具欄（空白）
    ''ToolBar.Reset  '還原為預設工具欄
    'ToolBar.Name = "Toolbars"  '參數是給自訂的工具列起的名稱。已經存在的名字不能重複使用，否則會報錯(Run-Time error 5，無效的參數)。
    'ToolBar.Position = msoBarTop '參數不僅決定自訂工具列的位置，還決定自訂工具列的類型。這個參數是 MsoBarPosition 枚舉常量裡的一個。msoBarLeft, msoBarTop, msoBarRight, msoBarBottom 四個值表示 自訂工具列出現在 Excel 視窗的上、下、左、右四個位置，是 docked 的。msoBarFloating 表示新工具列 不是 docked 的，浮在表單上方。msoBarPopup 則表示創建的是快顯功能表。msoBarMenuBar 這個值 Windows 用不到，只用在 Macintosh 作業系統。
    ''ToolBar.MenuBar = False  '參數是個布林值，決定創建的新命令列是功能表列還是工具列，因為 Windows 的傳統是一個程式只有一個功能表列。當指定為 True 時，自訂的功能表列將替換 Excel 預設的功能表列，最好不要做這件事情。這個參數預設是 False，也就意味著新創建的命令列是工具列或者快顯功能表。
    ''ToolBar.Temporary = True  '參數是個布林值。True 決定 Excel 程式關閉再打開後這個新命令列就沒用了。這個參數預設值是 False，也就是說自訂的命令列將一直跟隨 Excel 程式存在。比如 Adobe 公司的 PDF Maker 工具列。
    'ToolBar.Enabled = True  '把新工具列的 Visible 屬性設為 True，使生成的新工具列直接顯示出來。
    'ToolBar.Visible = True  '把新工具列的 Visible 屬性設為 True，使生成的新工具列直接顯示出來。

    '獲取菜單欄句柄
    Dim menuBar As CommandBar
    Set menuBar = Application.CommandBars("Worksheet Menu Bar")
    'menuBar.Reset  '還原為預設菜單欄


    '插入爬蟲 menuCrawler 操作菜單
    '判斷是否自定義的菜單已存在，菜單不允許重名，如果已存在，則先刪除
    'Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Delete
    Dim ctl As CommandBarControl
    For Each ctl In Application.CommandBars("Worksheet Menu Bar").Controls
        If ctl.Caption = "聚焦爬蟲 Focused Crawler" Then ctl.Delete
    Next ctl

    Dim menuCrawler As CommandBarPopup  '頂層菜單，CommandBarPopup 表示下拉菜單類型
    Set menuCrawler = menuBar.Controls.Add(Type:=msoControlPopup, Temporary:=True)  '參數 Type:=msoControlPopup 表示下拉菜單類型；參數 Temporary:=True 表示臨時新增菜單，Excel 關閉後會自動刪除。
    menuCrawler.Caption = "聚焦爬蟲 Focused Crawler"  '自定義的頂層菜單名
    menuCrawler.TooltipText = "定向網頁數據采集爬蟲"  '菜單提示文字

    'Dim menuCrawlerStrategyServer As CommandBarButton  '一級子菜單，CommandBarButton 表示按鈕類型。 'CommandBarPopup  '一級子菜單，CommandBarPopup 表示下拉菜單類型
    'Set menuCrawlerStrategyServer = menuCrawler.Controls.Add(Type:=msoControlButton)  '參數 Type:=msoControlButton 表示按鈕類型。
    'menuCrawlerStrategyServer.Caption = "數據采集策略伺服器 Strategy server"  '自定義的一級子菜單名
    ''menuCrawlerStrategyServer.Caption = "數據采集策略伺服器 Strategy server(&S)"  '自定義的一級子菜單名，參數 (&S) 表示配置的啓動快捷鍵，括號中的 &S 表示快捷鍵：Ctrl + Shift + S
    'menuCrawlerStrategyServer.TooltipText = "對應不同的數據源網站，提供相應的數據采集策略的伺服器"  '菜單提示文字
    'menuCrawlerStrategyServer.Style = msoButtonIconAndCaption  '菜單樣式（圖標加文字）
    'menuCrawlerStrategyServer.FaceId = 263  '圖標代號
    ''menuCrawlerStrategyServer.ShortcutText = "Ctrl + Shift + S"  '提示快捷鍵的顯示字符串：Ctrl + Shift + S
    'menuCrawlerStrategyServer.OnAction = "runCrawlerStrategyServer"  '左鍵單擊後執行的宏名稱字符串
    'menuCrawlerStrategyServer.BeginGroup = True  '添加分割綫

    Dim menuCrawlerPanel As CommandBarPopup  '一級子菜單，CommandBarPopup 表示下拉菜單類型
    Set menuCrawlerPanel = menuCrawler.Controls.Add(Type:=msoControlPopup)  '參數 Type:=msoControlPopup 表示下拉菜單類型。
    menuCrawlerPanel.Caption = "人機交互介面 operation panel"  '自定義的一級子菜單名
    menuCrawlerPanel.TooltipText = "定向爬蟲的人機交互介面操作面板"  '菜單提示文字

    Dim menuCrawlerPanelTest As CommandBarButton  '二級子菜單，CommandBarButton 表示按鈕類型
    Set menuCrawlerPanelTest = menuCrawlerPanel.Controls.Add(Type:=msoControlButton)  '參數 Type:=msoControlButton 表示按鈕類型。
    menuCrawlerPanelTest.Caption = "示例工程 test" '自定義的二級子菜單名
    'menuCrawlerPanelTest.Caption = "示例工程 test(&T)" '自定義的二級子菜單名，參數 (&T) 表示配置的啓動快捷鍵，括號中的 &T 表示快捷鍵：Ctrl + Shift + T
    menuCrawlerPanelTest.TooltipText = "定向爬蟲示例工程 test 的人機交互介面操作面板"  '菜单提示文字
    menuCrawlerPanelTest.Style = msoButtonIconAndCaption  '菜單樣式（圖標加文字）
    menuCrawlerPanelTest.FaceId = 263  '圖標代號
    'menuCrawlerPanelTest.ShortcutText = "Ctrl + Shift + T"  '提示快捷鍵的顯示字符串：Ctrl + Shift + T
    menuCrawlerPanelTest.OnAction = "testCrawlerStrategy"  '左鍵單擊後執行的宏名稱字符串
    menuCrawlerPanelTest.BeginGroup = True  '添加分割綫

End Sub

Sub runCrawlerStrategyServer()

    '聲明變量
    Dim codeScript As String, shellPIDvalue As Integer

    '檢查是否已經開啓過服務器，如果已經開啓則退出當前過程，如果未開啓過則執行開啓服務器
    If shellPIDdict.Exists("CrawlerStrategyServer") Then

        Dim oWMT As Object, oProcess As Object
        Set oWMT = GetObject("winmgmts:")
        For Each oProcess In oWMT.InstancesOf("Win32_Process")
            If oProcess.ProcessID = shellPIDdict.Item("CrawlerStrategyServer") Then
                Debug.Print "running Crawler Strategy server PID: " & oProcess.ProcessID
                'Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls ("數據采集策略服務器 Strategy server").Caption = "數據采集策略服務器 Strategy server(running)"  '變更顯示文字
                ''Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls ("數據采集策略服務器 Strategy server").Font.ColorIndex = 15  '變更顯示字體
                ''Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls ("數據采集策略服務器 Strategy server").Enabled = False  '禁用
                Exit Sub
            End If
        Next
        Set oWMT = Nothing
        Set oProcess = Nothing

        codeScript = "C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Nodejs/Nodejs-22.20.0/node.exe C:/Criss/vba/Automatic/CrawlerStrategyServer/CrawlerStrategyServer.js"  '開啓服務器的命令行控制臺 cmd 命令全名
        shellPIDvalue = ShellAndWait(codeScript, False)  '自定義函數，調用 Windows 的 shell 語句控制臺命令行（cmd）執行 Bash 語句或運行可執行檔（.exe）；
        '第二個參數預設值為 True，曲 True 值表示阻塞進程同步執行，同時讀取控制臺返回值，如果取 False 值，則不會阻塞進程異步執行，並且無法讀取控制臺輸出的返回值字符串，返回值只是對應的進程的 PID（ process identifier）。
        Debug.Print "running Crawler Strategy server PID: " & shellPIDvalue
        'Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls("數據采集策略服務器 Strategy server").Caption = "數據采集策略服務器 Strategy server(running)"   '變更顯示文字
        ''Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls("數據采集策略服務器 Strategy server").Font.ColorIndex = 15   '變更顯示字體
        ''Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls("數據采集策略服務器 Strategy server").Enabled = False   '禁用

        '寫入公共變量記錄新建的服務器進程的 PID 值，用於退出時中止進程
        If shellPIDdict.Exists("CrawlerStrategyServer") Then
            shellPIDdict.Item("CrawlerStrategyServer") = shellPIDvalue
        Else
            shellPIDdict.Add "CrawlerStrategyServer", shellPIDvalue
        End If

    Else

        codeScript = "C:/focused-crawling-Microsoft-Office-Excel-VBA-Edge/Nodejs/Nodejs-22.20.0/node.exe C:/Criss/vba/Automatic/CrawlerStrategyServer/CrawlerStrategyServer.js"  '開啓服務器的命令行控制臺 cmd 命令全名
        shellPIDvalue = ShellAndWait(codeScript, False)  '自定義函數，調用 Windows 的 shell 語句控制臺命令行（cmd）執行 Bash 語句或運行可執行檔（.exe）；
        '第二個參數預設值為 True，曲 True 值表示阻塞進程同步執行，同時讀取控制臺返回值，如果取 False 值，則不會阻塞進程異步執行，並且無法讀取控制臺輸出的返回值字符串，返回值只是對應的進程的 PID（ process identifier）。
        Debug.Print "running Crawler Strategy server PID: " & shellPIDvalue
        'Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls("數據采集策略服務器 Strategy server").Caption = "數據采集策略服務器 Strategy server(running)"   '變更顯示文字
        ''Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls("數據采集策略服務器 Strategy server").Font.ColorIndex = 15   '變更顯示字體
        ''Application.CommandBars("Worksheet Menu Bar").Controls("聚焦爬蟲 Focused Crawler").Controls("數據采集策略服務器 Strategy server").Enabled = False   '禁用

        '寫入公共變量記錄新建的服務器進程的 PID 值，用於退出時中止進程
        If shellPIDdict.Exists("CrawlerStrategyServer") Then
            shellPIDdict.Item("CrawlerStrategyServer") = shellPIDvalue
        Else
            shellPIDdict.Add "CrawlerStrategyServer", shellPIDvalue
        End If

    End If
    'Debug.Print shellPIDdict.Item("CrawlerStrategyServer")

End Sub

Sub testCrawlerStrategy()

    On Error Resume Next

    '自定義的待導入的爬蟲策略模塊
    Dim moduleName As String, modulePath As String, moduleFileName As String, moduleFile As String
    moduleName = "testCrawlerModule"  '爬蟲策略模塊的自定義命名
    modulePath = "C:\Criss\vba\Automatic\CrawlerStrategyServer\test"  '爬蟲策略模塊的保存路徑
    moduleFileName = "testCrawlerModule.bas"  '爬蟲策略模塊的文檔名
    moduleFile = modulePath & "\" & moduleFileName  '爬蟲策略模塊文檔的路徑全名

    Dim i As Integer  '用於 for 循環中記錄已經執行的循環次數變量

    '使用 Is Nothing 方法判斷指定名字的模塊是否已經存在，注意需要寫上語句 On Error Resume Next，不然當沒有找到指定的模塊時會報錯
    If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

        '判斷自定義的爬蟲模塊是否保存在指定的路徑
        Dim FSO As Object
        Set FSO = CreateObject("Scripting.FileSystemObject")
        If FSO.FolderExists(modulePath) And FSO.FileExists(moduleFile) Then

            'Debug.Print "Crawler Strategy ( " & moduleName & " ) source file: " & moduleFile

            '調用自定義子過程導入模塊
            Call importModule(moduleFile, moduleName)

        Else

            Debug.Print "Crawler Strategy ( " & moduleName & " ) error, Source file is Nothing."

            'If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then
            '    MsgBox "Crawler Strategy ( " & moduleName & " ) error, Source file ( " & moduleFile & " ) is Nothing."
            'End If

            Exit Sub

        End If
        Set FSO = Nothing


        ''從硬盤文檔導入模塊
        'With ThisWorkbook.VBProject.VBComponents.Import(moduleFile)
        '    .Name = moduleName  '對導入的模塊自定義重命名
        'End With

        '移除指定模塊 moduleName
        'ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(moduleName)
        '導出指定模塊 moduleName 至指定文檔 moduleFile
        'ThisWorkbook.VBProject.VBComponents(moduleName).Export moduleFile
        '模塊重命名
        'ThisWorkbook.VBProject.VBComponents("A").Name = "B"


        '寫入公共變量記錄新導入的模塊的名字值，用於退出時移除導入的模塊
        If importModuleNamedict.Exists(moduleName) Then
            importModuleNamedict.Item(moduleName) = moduleName
        Else
            importModuleNamedict.Add moduleName, moduleName
        End If

        '執行導入模塊 testCrawlerModule 中的自定義子過程 Sub testCrawler()，函數 .Evaluate () 表示將字符串解析為代碼並執行
        'Application.Run "testCrawlerModule.testCrawler"
        Application.Run moduleName & "." & Split(moduleName, "Module")(0)
        'Call testCrawlerModule.testCrawler
        'Application.Evaluate ("Call testCrawlerModule.testCrawler()")  '執行導入模塊中的自定義子過程 testCrawler，函數 .Evaluate () 表示將字符串解析為代碼並執行
        'Application.Evaluate ("Call " & moduleName & "." & Split(moduleName, "Module")(0) & "()")  '執行導入模塊中的自定義子過程 testCrawler，函數 .Evaluate () 表示將字符串解析為代碼並執行

        ''判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        'Select Case moduleName

        '    Case "testCrawlerModule"

        '        Call testCrawlerModule.testCrawler  '執行導入模塊中的自定義子過程 testCrawler，函數
        '        'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case "CFDACrawlerModule"

        '        'Call CFDACrawlerModule.testCrawler  '執行導入模塊中的自定義子過程 testCrawler，函數
        '        ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case Else

        '        'Exit Sub

        'End Select

        'CrawlerControlPanel.Show  '顯示自定義的操作面板窗體控件
        'CrawlerControlPanel.Hide  '隱藏自定義的操作面板窗體控件
        'Unload CrawlerControlPanel
        'Load UserForm: CrawlerControlPanel
        'For i = 0 To CrawlerControlPanel.Controls.Count - 1
        '    DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。
        'Next i

        'Exit Sub

        'Call testCrawlerStrategy

    Else

        '執行導入模塊 testCrawlerModule 中的自定義子過程 Sub testCrawler()，函數 .Evaluate () 表示將字符串解析為代碼並執行
        'Application.Run "testCrawlerModule.testCrawler"
        Application.Run moduleName & "." & Split(moduleName, "Module")(0)
        'Call testCrawlerModule.testCrawler
        'Application.Evaluate ("Call testCrawlerModule.testCrawler()")  '執行導入模塊中的自定義子過程 testCrawler，函數 .Evaluate () 表示將字符串解析為代碼並執行
        'Application.Evaluate ("Call " & moduleName & "." & Split(moduleName, "Module")(0) & "()")  '執行導入模塊中的自定義子過程 testCrawler，函數 .Evaluate () 表示將字符串解析為代碼並執行

        ''判斷使用的爬蟲模塊名稱，可以取值：("testCrawlerModule", "CFDACrawlerModule")
        'Select Case moduleName

        '    Case "testCrawlerModule"

        '        Call testCrawlerModule.testCrawler  '執行導入模塊中的自定義子過程 testCrawler，函數
        '        'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case "CFDACrawlerModule"

        '        'Call CFDACrawlerModule.testCrawler  '執行導入模塊中的自定義子過程 testCrawler，函數
        '        ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case Else

        '        'Exit Sub

        'End Select

        'CrawlerControlPanel.Show  '顯示自定義的操作面板窗體控件
        'CrawlerControlPanel.Hide  '隱藏自定義的操作面板窗體控件
        'Unload CrawlerControlPanel
        'Load UserForm: CrawlerControlPanel
        'For i = 0 To CrawlerControlPanel.Controls.Count - 1
        '    DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。
        'Next i

        'Exit Sub

    End If

End Sub


'調用 Windows 的 shell 語句控制臺命令行（cmd）執行 Bash 語句或運行可執行檔（.exe）
Public Function ShellAndWait(codeScript As String, ParamArray OtherArgs()) As String

    ''循環讀取傳入的全部可變參數的值
    'Dim OtherArgsValues As String
    'Dim i As Integer
    'For i = 0 To UBound(OtherArgs)
    '    OtherArgsValues = OtherArgsValues & "/n" & OtherArgs(i)
    'Next
    'Debug.Print OtherArgsValues
    
    Dim Branch As Boolean
    If UBound(OtherArgs) > -1 Then

        Branch = OtherArgs(0)

    Else

        Branch = True

    End If


    If Branch = True Then

        Dim oShell As Object, oExec As Object
        Set oShell = CreateObject("WScript.Shell")  '首先使用CreateObject()函數將應用程式的輸出重定向StdOut到管道;
        'codeScript = codeScript & ""
        Set oExec = oShell.Exec(codeScript)

        Dim ResultString As String
        ResultString = ""
        ResultString = oExec.StdOut.ReadAll  '然後讀取輸出管道中的值，這樣運行，Excel 會阻塞進程，等待命令行窗口運行完畢，並讀取命令行的運行結果，然後再繼續執行後續代碼；
        'Debug.Print ResultString  '使用提示框打印管道讀取值;

        ShellAndWait = ResultString  '賦值給函數的返回值;

        Set oShell = Nothing
        Set oExec = Nothing

    Else

        codeScript = "C:\WINDOWS\system32\cmd.exe /c " & codeScript  '獲得網路配置信息，參數：/k 表示使控制臺窗口駐留顯示，否則運行完畢後窗口會直接關閉，如果換做參數：/c 表示運行完畢後關閉窗口;
        Dim ResultInteger As Integer
        ResultInteger = 0
        ResultInteger = Shell(codeScript, vbMinimizedNoFocus)  '函數 Shell 的返回值為對應的進程的 PID（ process identifier），參數：vbHide 表示隱藏控制臺命令行黑色窗口運行，還可以取 vbHide 或 0，vbNormalFocus 或 1，vbMinimizedFocus 或 2，vbMaximizedFocus 或 3，vbNormalNoFocus 或 4，vbMinimizedNoFocus 或 6 等值
        '注意，Shell 函數返回值是進程 ID，與 Excel 程序是并行運行，不會阻塞 Excel 程序，Excel 不會等待命令行運行完畢，便會繼續執行後面的代碼；
        '可以使用CreateObject("WScript.Shell")函數將應用程式的輸出重定向StdOut到管道，這樣就會阻塞 Excel 程序，直到等待命令行運行完畢才會繼續運行，并且可以返回命令行運行結果和錯誤信息；
        'Shell("C:\windows\system32\control.exe", vbHide)  '打開 Windows 的控制面板，參數：vbHide 表示不要閃過控制臺命令行黑色窗口；
        'https://docs.microsoft.com/zh-cn/office/vba/Language/Reference/User-Interface-Help/shell-function
        'Debug.Print ResultInteger  '使用提示框打印管道讀取值;

        ShellAndWait = ResultInteger  '賦值給函數的返回值;

    End If

End Function
''使用示例:
'Sub ShellWait()
'    Dim codeScript As String, Result As String
'    codeScript = "ipconfig.exe /all"
'    Result = ShellAndWait(codeScript, True)
'    Debug.Print Result
'End Sub


'關閉正在運行的進程
Public Sub killProcess(integerPID As Integer)

    Dim oWMT As Object, oProcess As Object
    Set oWMT = GetObject("winmgmts:")
    For Each oProcess In oWMT.InstancesOf("Win32_Process")

        If oProcess.ProcessID = integerPID Then

            'If oProcess.Terminate() = 0 Then
            '    Exit Sub
            'Else
            '    oProcess.Terminate (0)
            'End If
            'Debug.Print shellPIDdict.Item("CrawlerStrategyServer")
            'Debug.Print oProcess.Description
            'Debug.Print oProcess.Terminate()
            'oProcess.Terminate (False)

            Dim codeStr As String, result As String
            codeStr = "C:\windows\system32\taskkill.exe /pid " & oProcess.ProcessID & " -t -f"
            result = ShellAndWait(codeStr, True)
            'Debug.Print Result
            'Debug.Print "Process ( PID = " & integerPID & " ) be closed."
            'Exit For
            Exit Sub

        End If

    Next

    Set oWMT = Nothing
    Set oProcess = Nothing

End Sub


'導入指定的模塊文檔，並自定義重命名導入的模塊
Public Sub importModule(moduleFile As String, moduleName As String)

    On Error Resume Next

    ''自定義的待導入的爬蟲策略模塊
    'Dim moduleName As String, modulePath As String, moduleFileName As String, moduleFile As String
    'moduleName = "testCrawlerModule"  '爬蟲策略模塊的自定義命名
    'modulePath = "C:\Criss\vba\Automatic\test"  '爬蟲策略模塊的保存路徑
    'moduleFileName = "testCrawlerModule.bas"  '爬蟲策略模塊的文檔名
    'moduleFile = modulePath & "\" & moduleFileName  '爬蟲策略模塊文檔的路徑全名

    '判斷自定義的爬蟲模塊是否保存在指定的路徑
    Dim FSO As Object
    Set FSO = CreateObject("Scripting.FileSystemObject")
    'If fso.Folderexists(modulePath) And fso.Fileexists(moduleFile) Then
    If FSO.FileExists(moduleFile) Then

        '使用 Is Nothing 方法判斷指定名字的模塊是否已經存在，注意需要寫上語句 On Error Resume Next，不然當沒有找到指定的模塊時會報錯
        If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

            '從硬盤文檔導入模塊
            With ThisWorkbook.VBProject.VBComponents.Import(moduleFile)
                .name = moduleName  '對導入的模塊自定義重命名
            End With

        Else

            '首先移除指定模塊 moduleName
            ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(moduleName)  '移除指定模塊 moduleName
            '導出指定模塊 moduleName 至指定文檔 moduleFile
            'ThisWorkbook.VBProject.VBComponents(moduleName).Export moduleFile
            '模塊重命名
            'ThisWorkbook.VBProject.VBComponents("A").Name = "B"

            '然後再次使用 Is Nothing 方法判斷指定名字的模塊是否已經存在，注意需要寫上語句 On Error Resume Next，不然當沒有找到指定的模塊時會報錯
            If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

                '從硬盤文檔導入模塊
                With ThisWorkbook.VBProject.VBComponents.Import(moduleFile)
                    .name = moduleName  '對導入的模塊自定義重命名
                End With

            Else

                Debug.Print "imported Module ( " & moduleName & " ) error, Module ( " & moduleName & " ) already exists, and unable to remove update."
                'Exit Sub

            End If

        End If

        'Debug.Print "import Module ( " & moduleName & " ) source file: " & moduleFile

    Else

        Debug.Print "import Module ( " & moduleName & " ) error, Source file ( " & moduleFile & " ) is Nothing."

    End If

    Set FSO = Nothing

End Sub


'移除指定的已存在模塊
Public Sub removeModule(moduleName As String)

    On Error Resume Next

    '使用 Is Nothing 方法判斷指定名字的模塊是否已經存在，注意需要寫上語句 On Error Resume Next，不然當沒有找到指定的模塊時會報錯
    If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

        Debug.Print "Module ( " & moduleName & " ) is Nothing."

    Else

        ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(moduleName)  '移除模塊

        '模塊移除之後，再次使用 Is Nothing 方法判斷指定名字的模塊是否已經存在，注意需要寫上語句 On Error Resume Next，不然當沒有找到指定的模塊時會報錯
        If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

            'Debug.Print "Module ( " & moduleName & " ) be removed."

        Else

            Debug.Print "remove Module ( " & moduleName & " ) error, Module ( " & moduleName & " ) cannot be remove."
            'Exit Sub

        End If

    End If

End Sub


'退出前的清理動作
Public Sub callRemoveModule()

    On Error Resume Next

    '判斷是否有程序自動導入的模塊
    If importModuleNamedict.Count > 0 Then

        Dim i As Integer
        For i = 0 To UBound(importModuleNamedict.Keys())

            '如果記錄名字的模塊存在，則移除模塊並且刪除字典中對應的記錄條目，如果記錄名字的模塊不存在，則直接刪除字典中對應的記錄條目
            If ThisWorkbook.VBProject.VBComponents(importModuleNamedict.Item(importModuleNamedict.Keys()(i))) Is Nothing Then

                Debug.Print "Module ( " & importModuleNamedict.Item(importModuleNamedict.Keys()(i)) & " ) is Nothing."
                importModuleNamedict.Remove (importModuleNamedict.Keys()(i))  '操作字典移除指定的條目

            Else

                removeModule (importModuleNamedict.Item(importModuleNamedict.Keys()(i)))  '使用自定義子過程移除指定模塊

                '模塊移除之後，再次使用 Is Nothing 方法判斷指定名字的模塊是否已經存在，注意需要寫上語句 On Error Resume Next，不然當沒有找到指定的模塊時會報錯
                If ThisWorkbook.VBProject.VBComponents(importModuleNamedict.Item(importModuleNamedict.Keys()(i))) Is Nothing Then

                    'Debug.Print "Module ( " & importModuleNamedict.Item(importModuleNamedict.Keys()(i)) & " ) be removed."
                    importModuleNamedict.Remove (importModuleNamedict.Keys()(i))  '操作字典移除指定的條目

                Else

                    Debug.Print "remove Module ( " & importModuleNamedict.Item(importModuleNamedict.Keys()(i)) & " ) error, Module ( " & importModuleNamedict.Item(importModuleNamedict.Keys()(i)) & " ) cannot be removed."
                    'Exit For

                End If

            End If

        Next

    Else

        Debug.Print "No imported Crawler Strategy module needs to be removed."

    End If

End Sub

'退出前的清理動作
Public Sub callKillProcess()

    On Error Resume Next

    '判斷是否有程序自動創建的進程
    If shellPIDdict.Count > 0 Then

        '使用自定義的子過程關閉指定 PID 的進程
        Dim i As Integer
        For i = 0 To UBound(shellPIDdict.Keys())
            Call killProcess(shellPIDdict.Item(shellPIDdict.Keys()(i)))
            'Debug.Print "Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) be closed."
        Next


        '檢查指定 PID 的進程是否已經被關閉（不存在），如果還存在，則控制臺提示關閉失敗，如果不存在則刪除記錄字典中對應的條目
        Dim oWMT As Object, oProcess As Object
        Set oWMT = GetObject("winmgmts:")

        Dim codeStr As String, result As String

        Dim flag As Boolean
        'Dim i As Integer
        For i = 0 To UBound(shellPIDdict.Keys())

            flag = True

            For Each oProcess In oWMT.InstancesOf("Win32_Process")

                If oProcess.ProcessID = shellPIDdict.Item(shellPIDdict.Keys()(i)) Then

                    'Debug.Print oProcess.Description
                    'Debug.Print oProcess.Terminate()
                    'oProcess.Terminate (False)

                    'codeStr = "C:\windows\system32\taskkill.exe /pid " & oProcess.ProcessID & " -t -f"
                    'Result = ShellAndWait(codeStr, True)
                    'Debug.Print Result
                    'Debug.Print "Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys(i)) & " ) be closed."

                    'Call killProcess(shellPIDdict.Item(shellPIDdict.Keys()(i)))
                    'Debug.Print "Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) be closed."

                    'shellPIDdict.Remove (shellPIDdict.Keys()(i))  '操作字典移除指定的條目

                    Debug.Print "close Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) error, Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) cannot be closed."

                    flag = False

                    Exit For

                End If

            Next

            If flag Then

                Debug.Print "Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) be closed."
                shellPIDdict.Remove (shellPIDdict.Keys()(i))  '操作字典移除指定的條目

            End If

        Next

        Set oWMT = Nothing
        Set oProcess = Nothing

    Else

        Debug.Print "No created Process needs to be closed."

    End If

End Sub


Public Function IsExeRunning(exeName As String) As Boolean
    If testing Then Exit Function
    On Error GoTo ErrorHandler
    
    Dim flag As Boolean
    Dim strComputer As String
    Dim objWMI As Object, objProcessSet As Object, objProcess As Object
    
    Dim strUserName As String
    Dim strUserDomain As String
    
    strComputer = "."
    Set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
    Set objProcessSet = objWMI.ExecQuery("SELECT Name FROM Win32_Process WHERE Name = '" & exeName & "'")
    'MsgBox objProcessSet.count
    
    
    'MsgBox Environ$("username")
    For Each objProcess In objProcessSet
        objProcess.GetOwner strUserName, strUserDomain
        'MsgBox strUserName
        If strUserName = Environ$("username") Then
            flag = True
            Exit For
        End If
        'MsgBox "Process " & objProcess.Name & " is owned by " & strUserDomain & "\" & strUserName & "."
    Next
    
    'If objProcessSet.count > 0 Then
    '    flag = True
    'Else
    '    flag = False
    'End If
    
'    For Each Process In objProcessSet
'        If Process.Name = exeName Then
'            flag = True
'            Exit For
'        End If
'    Next

ErrorHandler:
    Set objProcessSet = Nothing
    Set objWMI = Nothing
    
    If Err.Number <> 0 Then
        IsExeRunning = True
    Else
        IsExeRunning = flag
    End If
End Function

Public Function CntExeRunning(exeName As String) As Integer
    If testing Then Exit Function
    'On Error GoTo ErrorHandler
    On Error Resume Next
    'Dim flag As Boolean
    Dim cnt As Integer
    'cnt = 0
    Dim strComputer As String
    
    Dim objWMI As Object
    Dim objProcessSet As Object
    'Dim objProcess As Object
    
    Dim strUserName As String
    Dim strUserDomain As String
    
    strComputer = "."
    Set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
    Set objProcessSet = objWMI.ExecQuery("SELECT Name FROM Win32_Process WHERE Name = '" & exeName & "'")
    'MsgBox objProcessSet.count
    
    cnt = objProcessSet.Count
    
    
'ErrorHandler:

    If Err.Number <> 0 Then
        'Do nothing as always error
        'MyMsgBox Err.Number & " " & Err.Description, 10
        'cnt = 0
    End If
    
    'MyMsgBox cnt & "", 10
    
    Set objProcessSet = Nothing
    Set objWMI = Nothing
    
    CntExeRunning = cnt
End Function

Public Function KillExeRunning(exeName As String) As Boolean
    If testing Then Exit Function
    On Error Resume Next
    Dim flag As Boolean
    flag = False

    Dim strComputer As String
    Dim objWMI As Object, objProcessSet As Object, objProcess As Object

    Dim strUserName As String
    Dim strUserDomain As String

    strComputer = "."
    Set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
    Set objProcessSet = objWMI.ExecQuery("SELECT Name FROM Win32_Process WHERE Name = '" & exeName & "'")
    
    If objProcessSet.Count > 0 Then
    
        For Each objProcess In objProcessSet
        
            objProcess.GetOwner strUserName, strUserDomain
            'MsgBox strUserName
            If strUserName = Environ$("username") Then
            End If
            'MsgBox "Process " & objProcess.Name & " is owned by " & strUserDomain & "\" & strUserName & "."
            
            If objProcess.name = exeName Then
                Dim errReturnCode As Integer
                errReturnCode = objProcess.Terminate()
                'MsgBox errReturnCode
                If errReturnCode = 0 Then
                    flag = True
                End If
            End If
        Next
    End If
    
    Set objProcessSet = Nothing
    Set objWMI = Nothing
    
    KillExeRunning = flag
End Function


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

