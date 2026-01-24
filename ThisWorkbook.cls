VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

' Excel 文檔打開時的操作
Private Sub Workbook_Open()

    On Error Resume Next

    ''遍歷所有模塊，並移除不符合條件的已存在模塊
    'Dim moduleName
    'moduleName = Array("clsBrowser", "clsCore", "clsJsConverter", "DatabaseDispatchModule", "DatabaseControlPanel", "DatabaseModule", "CrawlerDispatchModule", "CrawlerControlPanel")
    'Dim i As Integer, j As Integer
    'Dim flagBoolean As Boolean
    'flagBoolean = True
    'For i = 1 To ThisWorkbook.VBProject.VBComponents.Count
    '    flagBoolean = True
    '    For j = LBound(moduleName) To UBound(moduleName)
    '        If CStr(ThisWorkbook.VBProject.VBComponents(i).Name) = moduleName(j) Then
    '            flagBoolean = False
    '            Exit For
    '        End If
    '    Next j
    '    If (CStr(ThisWorkbook.VBProject.VBComponents(i).Name) = "ThisWorkbook") Then
    '        flagBoolean = False
    '    End If
    '    For j = 1 To ThisWorkbook.Worksheets.Count
    '        If CStr(ThisWorkbook.VBProject.VBComponents(i).Name) = CStr(ThisWorkbook.Worksheets(j).Name) Then
    '            flagBoolean = False
    '            Exit For
    '        End If
    '    Next j
    '    If flagBoolean Then
    '        'Debug.Print ThisWorkbook.VBProject.VBComponents(i).Name
    '        ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(i): Rem 移除模塊
    '    End If
    'Next i

    'ThisWorkbook.Save

    Call DatabaseDispatchModule.initial  '調用鏈接操控數據庫調度模組的自定義子過程變量初始化賦初值
    Call DatabaseDispatchModule.MenuSetup  '調用鏈接操控數據庫調度模組的自定義子過程創建自定義菜單欄

    Call CrawlerDispatchModule.initial  '調用網絡爬蟲調度模組的自定義子過程變量初始化賦初值
    Call CrawlerDispatchModule.MenuSetup  '調用網絡爬蟲調度模組的自定義子過程創建自定義菜單欄

End Sub


' Excel 文檔關閉前的操作
Private Sub Workbook_BeforeClose(Cancel As Boolean)

    On Error Resume Next

    'Call DatabaseDispatchModule.callRemoveModule  '調用鏈接操控數據庫調度模組的自定義子過程移除清理程序自動導入的模塊
    ''Call DatabaseDispatchModule.callKillProcess  '調用鏈接操控數據庫調度模組的自定義子過程關閉清理程序自動創建的進程
    ''ThisWorkbook.Save

    'Call CrawlerDispatchModule.callRemoveModule  '調用網絡爬蟲調度模組的自定義子過程移除清理程序自動導入的模塊
    ''Call CrawlerDispatchModule.callKillProcess  '調用網絡爬蟲調度模組的自定義子過程關閉清理程序自動創建的進程
    ''ThisWorkbook.Save

    'ThisWorkbook.Save

End Sub

