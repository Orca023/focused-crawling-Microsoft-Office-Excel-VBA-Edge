Attribute VB_Name = "CrawlerDispatchModule"

'Author: ��������
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
'Date: ��ʮ����


' �Z�� Option Explicit ��Ҫ���������� Sub ֮ǰ���� Option Explicit �Z����F��ģ�K�Еr�����ʹ�� Dim��Private��Public��ReDim��Static �Z���@ʽ������׃�������ʹ����δ��������׃�����Q���t���ھ��g�r���F�e�`������]��ʹ�� Option Explicit �Z�䣬�t����δ����׃�������� Variant ��͡�
Option Explicit

'�P�]��Ļ���£����Լӿ��\���ٶ�
'Application.ScreenUpdate = False
'��VBA�����\�нY���r�ٌ�ԓֵ߀ԭ��True�O��
'Application.ScreenUpdate = True
'�P�]��Ԫ���Ԅ�Ӌ��Ġ��քӰ� F9 �I����Ӌ�㣬���Լӿ��\���ٶ�
'Application.Calculation = xlCalculationManual
'��VBA�����\�нY���r�ٌ���Ԫ��߀ԭ���Ԅ�Ӌ��ģʽ
'Application.Calculation = xlCalculationAutomatic


'Public shellPIDarr(0 To 9) As Integer  '����׃��ӛ��½��ķ������M�̵� PID ֵ������˳��r��ֹ�M��
'Public shellPIDindex As Integer
'shellPIDindex = 0
Public shellPIDdict As Object  '����׃��ӛ��½��ķ������M�̵� PID ֵ������˳��r��ֹ�M��
Public importModuleNamedict As Object  '����׃��ӛ������ģ�K������ֵ������˳��r�Ƴ�����ģ�K
Sub initial()
    Set shellPIDdict = CreateObject("Scripting.Dictionary")
    'Debug.Print shellPIDdict.Count
    Set importModuleNamedict = CreateObject("Scripting.Dictionary")
    'Debug.Print importModuleNamedict.Count
End Sub


Sub MenuSetup()

    '�Z�� On Error Resume Next ��ʹ�����ծa���e�`���Z��֮����Z���^�m����
    On Error Resume Next
    
    ''Application.CommandBars("Worksheet Menu Bar").Add(Name, Position, MenuBar, Temporary)
    ''�@�e�� CommandBars �� Application ����Č��ԣ�����һ�� CommandBars ����CommandBars(index) �@�N��ӛ���t����һ�����w�� CommandBar ����index ������ CommandBar ����ľ�̖��Ҳ������ CommandBar ��������Q��Excel �Ĺ��ܱ������Q��"Worksheet Menu Bar"����̖�� 1�����õĹ�������"Standard"����̖ 3��"Formatting"�� ��̖ 4���������I�c������^�����Ŀ��@���ܱ����Q��"Cell"����̖�� 36�������Q���þ�̖�L�� CommandBar �����ǵȃr�ġ�
    'Dim ToolBar As CommandBar  '���ߙ�
    'Set ToolBar = Application.CommandBars.Add()  '�������ߙڣ��հף�
    ''ToolBar.Reset  '߀ԭ���A�O���ߙ�
    'ToolBar.Name = "Toolbars"  '�����ǽo��ӆ�Ĺ�����������Q���ѽ����ڵ����ֲ������}ʹ�ã���t�����e(Run-Time error 5���oЧ�ą���)��
    'ToolBar.Position = msoBarTop '�������H�Q����ӆ�����е�λ�ã�߀�Q����ӆ�����е���͡��@�������� MsoBarPosition ö�e�����e��һ����msoBarLeft, msoBarTop, msoBarRight, msoBarBottom �Ă�ֵ��ʾ ��ӆ�����г��F�� Excel ҕ�����ϡ��¡������Ă�λ�ã��� docked �ġ�msoBarFloating ��ʾ�¹����� ���� docked �ģ����ڱ���Ϸ���msoBarPopup �t��ʾ�������ǿ��@���ܱ�msoBarMenuBar �@��ֵ Windows �ò�����ֻ���� Macintosh ���Iϵ�y��
    ''ToolBar.MenuBar = False  '�����ǂ�����ֵ���Q�����������������ǹ��ܱ���߀�ǹ����У���� Windows �Ă��y��һ����ʽֻ��һ�����ܱ��С���ָ���� True �r����ӆ�Ĺ��ܱ��Ќ���Q Excel �A�O�Ĺ��ܱ��У���ò�Ҫ���@�����顣�@�������A�O�� False��Ҳ����ζ���������������ǹ����л��߿��@���ܱ�
    ''ToolBar.Temporary = True  '�����ǂ�����ֵ��True �Q�� Excel ��ʽ�P�]�ٴ��_���@���������о͛]���ˡ��@�������A�Oֵ�� False��Ҳ�����f��ӆ�������Ќ�һֱ���S Excel ��ʽ���ڡ����� Adobe ��˾�� PDF Maker �����С�
    'ToolBar.Enabled = True  '���¹����е� Visible �����O�� True��ʹ���ɵ��¹�����ֱ���@ʾ����
    'ToolBar.Visible = True  '���¹����е� Visible �����O�� True��ʹ���ɵ��¹�����ֱ���@ʾ����

    '�@ȡ�ˆΙھ��
    Dim menuBar As CommandBar
    Set menuBar = Application.CommandBars("Worksheet Menu Bar")
    'menuBar.Reset  '߀ԭ���A�O�ˆΙ�


    '�������x menuCrawler �����ˆ�
    '�Д��Ƿ��Զ��x�Ĳˆ��Ѵ��ڣ��ˆβ����S����������Ѵ��ڣ��t�Ȅh��
    'Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Delete
    Dim ctl As CommandBarControl
    For Each ctl In Application.CommandBars("Worksheet Menu Bar").Controls
        If ctl.Caption = "�۽����x Focused Crawler" Then ctl.Delete
    Next ctl

    Dim menuCrawler As CommandBarPopup  '플ӲˆΣ�CommandBarPopup ��ʾ�����ˆ����
    Set menuCrawler = menuBar.Controls.Add(Type:=msoControlPopup, Temporary:=True)  '���� Type:=msoControlPopup ��ʾ�����ˆ���ͣ����� Temporary:=True ��ʾ�R�r�����ˆΣ�Excel �P�]����Ԅӄh����
    menuCrawler.Caption = "�۽����x Focused Crawler"  '�Զ��x��플Ӳˆ���
    menuCrawler.TooltipText = "����W퓔����ɼ����x"  '�ˆ���ʾ����

    Dim menuCrawlerStrategyServer As CommandBarButton  'һ���ӲˆΣ�CommandBarButton ��ʾ���o��͡� 'CommandBarPopup  'һ���ӲˆΣ�CommandBarPopup ��ʾ�����ˆ����
    Set menuCrawlerStrategyServer = menuCrawler.Controls.Add(Type:=msoControlButton)  '���� Type:=msoControlButton ��ʾ���o��͡�
    menuCrawlerStrategyServer.Caption = "�����ɼ����Է����� Strategy server"  '�Զ��x��һ���Ӳˆ���
    'menuCrawlerStrategyServer.Caption = "�����ɼ����Է����� Strategy server(&S)"  '�Զ��x��һ���Ӳˆ��������� (&S) ��ʾ���õĆ��ӿ���I����̖�е� &S ��ʾ����I��Ctrl + Shift + S
    menuCrawlerStrategyServer.TooltipText = "������ͬ�Ĕ���Դ�Wվ���ṩ�����Ĕ����ɼ����Եķ�����"  '�ˆ���ʾ����
    menuCrawlerStrategyServer.Style = msoButtonIconAndCaption  '�ˆΘ�ʽ���D�˼����֣�
    menuCrawlerStrategyServer.FaceId = 263  '�D�˴�̖
    'menuCrawlerStrategyServer.ShortcutText = "Ctrl + Shift + S"  '��ʾ����I���@ʾ�ַ�����Ctrl + Shift + S
    menuCrawlerStrategyServer.OnAction = "runCrawlerStrategyServer"  '���I�Γ�����еĺ����Q�ַ���
    menuCrawlerStrategyServer.BeginGroup = True  '��ӷָ�Q

    Dim menuCrawlerPanel As CommandBarPopup  'һ���ӲˆΣ�CommandBarPopup ��ʾ�����ˆ����
    Set menuCrawlerPanel = menuCrawler.Controls.Add(Type:=msoControlPopup)  '���� Type:=msoControlPopup ��ʾ�����ˆ���͡�
    menuCrawlerPanel.Caption = "�˙C�������� operation panel"  '�Զ��x��һ���Ӳˆ���
    menuCrawlerPanel.TooltipText = "�������x���˙C��������������"  '�ˆ���ʾ����

    Dim menuCrawlerPanelTest As CommandBarButton  '�����ӲˆΣ�CommandBarButton ��ʾ���o���
    Set menuCrawlerPanelTest = menuCrawlerPanel.Controls.Add(Type:=msoControlButton)  '���� Type:=msoControlButton ��ʾ���o��͡�
    menuCrawlerPanelTest.Caption = "ʾ������ test" '�Զ��x�Ķ����Ӳˆ���
    'menuCrawlerPanelTest.Caption = "ʾ������ test(&T)" '�Զ��x�Ķ����Ӳˆ��������� (&T) ��ʾ���õĆ��ӿ���I����̖�е� &T ��ʾ����I��Ctrl + Shift + T
    menuCrawlerPanelTest.TooltipText = "�������xʾ������ test ���˙C��������������"  '�˵���ʾ����
    menuCrawlerPanelTest.Style = msoButtonIconAndCaption  '�ˆΘ�ʽ���D�˼����֣�
    menuCrawlerPanelTest.FaceId = 263  '�D�˴�̖
    'menuCrawlerPanelTest.ShortcutText = "Ctrl + Shift + T"  '��ʾ����I���@ʾ�ַ�����Ctrl + Shift + T
    menuCrawlerPanelTest.OnAction = "testCrawlerStrategy"  '���I�Γ�����еĺ����Q�ַ���
    menuCrawlerPanelTest.BeginGroup = True  '��ӷָ�Q

End Sub

Sub runCrawlerStrategyServer()

    '��׃��
    Dim codeScript As String, shellPIDvalue As Integer

    '�z���Ƿ��ѽ��_���^������������ѽ��_���t�˳���ǰ�^�̣����δ�_���^�t�����_��������
    If shellPIDdict.Exists("CrawlerStrategyServer") Then

        Dim oWMT As Object, oProcess As Object
        Set oWMT = GetObject("winmgmts:")
        For Each oProcess In oWMT.InstancesOf("Win32_Process")
            If oProcess.ProcessID = shellPIDdict.Item("CrawlerStrategyServer") Then
                Debug.Print "running Crawler Strategy server PID: " & oProcess.ProcessID
                'Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls ("�����ɼ����Է����� Strategy server").Caption = "�����ɼ����Է����� Strategy server(running)"  '׃���@ʾ����
                ''Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls ("�����ɼ����Է����� Strategy server").Font.ColorIndex = 15  '׃���@ʾ���w
                ''Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls ("�����ɼ����Է����� Strategy server").Enabled = False  '����
                Exit Sub
            End If
        Next
        Set oWMT = Nothing
        Set oProcess = Nothing

        codeScript = "node C:\Criss\vba\Automatic\test\CrawlerStrategyServer\server.js"  '�_���������������п����_ cmd ����ȫ��
        shellPIDvalue = ShellAndWait(codeScript, False)  '�Զ��x�������{�� Windows �� shell �Z������_�����У�cmd������ Bash �Z����\�пɈ��Йn��.exe����
        '�ڶ��������A�Oֵ�� True���� True ֵ��ʾ�����M��ͬ�����У�ͬ�r�xȡ�����_����ֵ�����ȡ False ֵ���t���������M�̮������У��K�ҟo���xȡ�����_ݔ���ķ���ֵ�ַ���������ֵֻ�ǌ������M�̵� PID�� process identifier����
        Debug.Print "running Crawler Strategy server PID: " & shellPIDvalue
        'Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls("�����ɼ����Է����� Strategy server").Caption = "�����ɼ����Է����� Strategy server(running)"   '׃���@ʾ����
        ''Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls("�����ɼ����Է����� Strategy server").Font.ColorIndex = 15   '׃���@ʾ���w
        ''Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls("�����ɼ����Է����� Strategy server").Enabled = False   '����

        '���빫��׃��ӛ��½��ķ������M�̵� PID ֵ������˳��r��ֹ�M��
        If shellPIDdict.Exists("CrawlerStrategyServer") Then
            shellPIDdict.Item("CrawlerStrategyServer") = shellPIDvalue
        Else
            shellPIDdict.Add "CrawlerStrategyServer", shellPIDvalue
        End If

    Else

        codeScript = "node C:\Criss\vba\Automatic\test\CrawlerStrategyServer\server.js"  '�_���������������п����_ cmd ����ȫ��
        shellPIDvalue = ShellAndWait(codeScript, False)  '�Զ��x�������{�� Windows �� shell �Z������_�����У�cmd������ Bash �Z����\�пɈ��Йn��.exe����
        '�ڶ��������A�Oֵ�� True���� True ֵ��ʾ�����M��ͬ�����У�ͬ�r�xȡ�����_����ֵ�����ȡ False ֵ���t���������M�̮������У��K�ҟo���xȡ�����_ݔ���ķ���ֵ�ַ���������ֵֻ�ǌ������M�̵� PID�� process identifier����
        Debug.Print "running Crawler Strategy server PID: " & shellPIDvalue
        'Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls("�����ɼ����Է����� Strategy server").Caption = "�����ɼ����Է����� Strategy server(running)"   '׃���@ʾ����
        ''Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls("�����ɼ����Է����� Strategy server").Font.ColorIndex = 15   '׃���@ʾ���w
        ''Application.CommandBars("Worksheet Menu Bar").Controls("�۽����x Focused Crawler").Controls("�����ɼ����Է����� Strategy server").Enabled = False   '����

        '���빫��׃��ӛ��½��ķ������M�̵� PID ֵ������˳��r��ֹ�M��
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

    '�Զ��x�Ĵ���������x����ģ�K
    Dim moduleName As String, modulePath As String, moduleFileName As String, moduleFile As String
    moduleName = "testCrawlerModule"  '���x����ģ�K���Զ��x����
    modulePath = "C:\Criss\vba\Automatic\CrawlerStrategyServer\test"  '���x����ģ�K�ı���·��
    moduleFileName = "testCrawlerModule.bas"  '���x����ģ�K���ęn��
    moduleFile = modulePath & "\" & moduleFileName  '���x����ģ�K�ęn��·��ȫ��

    Dim i As Integer  '��� for ѭ�h��ӛ��ѽ����е�ѭ�h�Δ�׃��

    'ʹ�� Is Nothing �����Д�ָ�����ֵ�ģ�K�Ƿ��ѽ����ڣ�ע����Ҫ�����Z�� On Error Resume Next����Ȼ���]���ҵ�ָ����ģ�K�r�����e
    If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

        '�Д��Զ��x�����xģ�K�Ƿ񱣴���ָ����·��
        Dim fso As Object
        Set fso = CreateObject("Scripting.FileSystemObject")
        If fso.FolderExists(modulePath) And fso.FileExists(moduleFile) Then

            'Debug.Print "Crawler Strategy ( " & moduleName & " ) source file: " & moduleFile

            '�{���Զ��x���^�̌���ģ�K
            Call importModule(moduleFile, moduleName)

        Else

            Debug.Print "Crawler Strategy ( " & moduleName & " ) error, Source file is Nothing."

            'If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then
            '    MsgBox "Crawler Strategy ( " & moduleName & " ) error, Source file ( " & moduleFile & " ) is Nothing."
            'End If

            Exit Sub

        End If
        Set fso = Nothing


        ''��Ӳ�P�ęn����ģ�K
        'With ThisWorkbook.VBProject.VBComponents.Import(moduleFile)
        '    .Name = moduleName  '�������ģ�K�Զ��x������
        'End With

        '�Ƴ�ָ��ģ�K moduleName
        'ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(moduleName)
        '����ָ��ģ�K moduleName ��ָ���ęn moduleFile
        'ThisWorkbook.VBProject.VBComponents(moduleName).Export moduleFile
        'ģ�K������
        'ThisWorkbook.VBProject.VBComponents("A").Name = "B"


        '���빫��׃��ӛ������ģ�K������ֵ������˳��r�Ƴ������ģ�K
        If importModuleNamedict.Exists(moduleName) Then
            importModuleNamedict.Item(moduleName) = moduleName
        Else
            importModuleNamedict.Add moduleName, moduleName
        End If

        '���Ќ���ģ�K testCrawlerModule �е��Զ��x���^�� Sub testCrawler()������ .Evaluate () ��ʾ���ַ�����������a�K����
        'Application.Run "testCrawlerModule.testCrawler"
        Application.Run moduleName & "." & Split(moduleName, "Module")(0)
        'Call testCrawlerModule.testCrawler
        'Application.Evaluate ("Call testCrawlerModule.testCrawler()")  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������ .Evaluate () ��ʾ���ַ�����������a�K����
        'Application.Evaluate ("Call " & moduleName & "." & Split(moduleName, "Module")(0) & "()")  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������ .Evaluate () ��ʾ���ַ�����������a�K����

        ''�Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        'Select Case moduleName

        '    Case "testCrawlerModule"

        '        Call testCrawlerModule.testCrawler  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������
        '        'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case "CFDACrawlerModule"

        '        'Call CFDACrawlerModule.testCrawler  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������
        '        ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case Else

        '        'Exit Sub

        'End Select

        'CrawlerControlPanel.Show  '�@ʾ�Զ��x�Ĳ�����崰�w�ؼ�
        'CrawlerControlPanel.Hide  '�[���Զ��x�Ĳ�����崰�w�ؼ�
        'Unload CrawlerControlPanel
        'Load UserForm: CrawlerControlPanel
        'For i = 0 To CrawlerControlPanel.Controls.Count - 1
        '    DoEvents: Rem �Z�� DoEvents ��ʾ����ϵ�y CPU ���ƙ�߀�o����ϵ�y��Ҳ�����ڴ�ѭ�h�A�Σ��Ñ�����ͬ�r������X���������ã������ǌ��������ֱ��ѭ�h�Y����
        'Next i

        'Exit Sub

        'Call testCrawlerStrategy

    Else

        '���Ќ���ģ�K testCrawlerModule �е��Զ��x���^�� Sub testCrawler()������ .Evaluate () ��ʾ���ַ�����������a�K����
        'Application.Run "testCrawlerModule.testCrawler"
        Application.Run moduleName & "." & Split(moduleName, "Module")(0)
        'Call testCrawlerModule.testCrawler
        'Application.Evaluate ("Call testCrawlerModule.testCrawler()")  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������ .Evaluate () ��ʾ���ַ�����������a�K����
        'Application.Evaluate ("Call " & moduleName & "." & Split(moduleName, "Module")(0) & "()")  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������ .Evaluate () ��ʾ���ַ�����������a�K����

        ''�Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        'Select Case moduleName

        '    Case "testCrawlerModule"

        '        Call testCrawlerModule.testCrawler  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������
        '        'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case "CFDACrawlerModule"

        '        'Call CFDACrawlerModule.testCrawler  '���Ќ���ģ�K�е��Զ��x���^�� testCrawler������
        '        ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("testCrawler")

        '        'Exit Sub

        '    Case Else

        '        'Exit Sub

        'End Select

        'CrawlerControlPanel.Show  '�@ʾ�Զ��x�Ĳ�����崰�w�ؼ�
        'CrawlerControlPanel.Hide  '�[���Զ��x�Ĳ�����崰�w�ؼ�
        'Unload CrawlerControlPanel
        'Load UserForm: CrawlerControlPanel
        'For i = 0 To CrawlerControlPanel.Controls.Count - 1
        '    DoEvents: Rem �Z�� DoEvents ��ʾ����ϵ�y CPU ���ƙ�߀�o����ϵ�y��Ҳ�����ڴ�ѭ�h�A�Σ��Ñ�����ͬ�r������X���������ã������ǌ��������ֱ��ѭ�h�Y����
        'Next i

        'Exit Sub

    End If

End Sub


'�{�� Windows �� shell �Z������_�����У�cmd������ Bash �Z����\�пɈ��Йn��.exe��
Public Function ShellAndWait(codeScript As String, ParamArray OtherArgs()) As String

    ''ѭ�h�xȡ�����ȫ����׃������ֵ
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
        Set oShell = CreateObject("WScript.Shell")  '����ʹ��CreateObject()���������ó�ʽ��ݔ���ض���StdOut���ܵ�;
        'codeScript = codeScript & ""
        Set oExec = oShell.Exec(codeScript)

        Dim ResultString As String
        ResultString = ""
        ResultString = oExec.StdOut.ReadAll  'Ȼ���xȡݔ���ܵ��е�ֵ���@���\�У�Excel �������M�̣��ȴ������д����\���ꮅ���K�xȡ�����е��\�нY����Ȼ�����^�m�������m���a��
        'Debug.Print ResultString  'ʹ����ʾ���ӡ�ܵ��xȡֵ;

        ShellAndWait = ResultString  '�xֵ�o�����ķ���ֵ;

        Set oShell = Nothing
        Set oExec = Nothing

    Else

        codeScript = "C:\WINDOWS\system32\cmd.exe /c " & codeScript  '�@�þW·������Ϣ��������/k ��ʾʹ�����_�����v���@ʾ����t�\���ꮅ�ᴰ�ڕ�ֱ���P�]������Q��������/c ��ʾ�\���ꮅ���P�]����;
        Dim ResultInteger As Integer
        ResultInteger = 0
        ResultInteger = Shell(codeScript, vbMinimizedNoFocus)  '���� Shell �ķ���ֵ�錦�����M�̵� PID�� process identifier����������vbHide ��ʾ�[�ؿ����_�����к�ɫ�����\�У�߀����ȡ vbHide �� 0��vbNormalFocus �� 1��vbMinimizedFocus �� 2��vbMaximizedFocus �� 3��vbNormalNoFocus �� 4��vbMinimizedNoFocus �� 6 ��ֵ
        'ע�⣬Shell ��������ֵ���M�� ID���c Excel �����ǲ����\�У��������� Excel ����Excel �����ȴ��������\���ꮅ������^�m��������Ĵ��a��
        '����ʹ��CreateObject("WScript.Shell")���������ó�ʽ��ݔ���ض���StdOut���ܵ����@�Ӿ͕����� Excel ����ֱ���ȴ��������\���ꮅ�ŕ��^�m�\�У����ҿ��Է����������\�нY�����e�`��Ϣ��
        'Shell("C:\windows\system32\control.exe", vbHide)  '���_ Windows �Ŀ�����壬������vbHide ��ʾ��Ҫ�W�^�����_�����к�ɫ���ڣ�
        'https://docs.microsoft.com/zh-cn/office/vba/Language/Reference/User-Interface-Help/shell-function
        'Debug.Print ResultInteger  'ʹ����ʾ���ӡ�ܵ��xȡֵ;

        ShellAndWait = ResultInteger  '�xֵ�o�����ķ���ֵ;

    End If

End Function
''ʹ��ʾ��:
'Sub ShellWait()
'    Dim codeScript As String, Result As String
'    codeScript = "ipconfig.exe /all"
'    Result = ShellAndWait(codeScript, True)
'    Debug.Print Result
'End Sub


'�P�]�����\�е��M��
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


'����ָ����ģ�K�ęn���K�Զ��x�����������ģ�K
Public Sub importModule(moduleFile As String, moduleName As String)

    On Error Resume Next

    ''�Զ��x�Ĵ���������x����ģ�K
    'Dim moduleName As String, modulePath As String, moduleFileName As String, moduleFile As String
    'moduleName = "testCrawlerModule"  '���x����ģ�K���Զ��x����
    'modulePath = "C:\Criss\vba\Automatic\test"  '���x����ģ�K�ı���·��
    'moduleFileName = "testCrawlerModule.bas"  '���x����ģ�K���ęn��
    'moduleFile = modulePath & "\" & moduleFileName  '���x����ģ�K�ęn��·��ȫ��

    '�Д��Զ��x�����xģ�K�Ƿ񱣴���ָ����·��
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    'If fso.Folderexists(modulePath) And fso.Fileexists(moduleFile) Then
    If fso.FileExists(moduleFile) Then

        'ʹ�� Is Nothing �����Д�ָ�����ֵ�ģ�K�Ƿ��ѽ����ڣ�ע����Ҫ�����Z�� On Error Resume Next����Ȼ���]���ҵ�ָ����ģ�K�r�����e
        If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

            '��Ӳ�P�ęn����ģ�K
            With ThisWorkbook.VBProject.VBComponents.Import(moduleFile)
                .name = moduleName  '�������ģ�K�Զ��x������
            End With

        Else

            '�����Ƴ�ָ��ģ�K moduleName
            ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(moduleName)  '�Ƴ�ָ��ģ�K moduleName
            '����ָ��ģ�K moduleName ��ָ���ęn moduleFile
            'ThisWorkbook.VBProject.VBComponents(moduleName).Export moduleFile
            'ģ�K������
            'ThisWorkbook.VBProject.VBComponents("A").Name = "B"

            'Ȼ���ٴ�ʹ�� Is Nothing �����Д�ָ�����ֵ�ģ�K�Ƿ��ѽ����ڣ�ע����Ҫ�����Z�� On Error Resume Next����Ȼ���]���ҵ�ָ����ģ�K�r�����e
            If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

                '��Ӳ�P�ęn����ģ�K
                With ThisWorkbook.VBProject.VBComponents.Import(moduleFile)
                    .name = moduleName  '�������ģ�K�Զ��x������
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

    Set fso = Nothing

End Sub


'�Ƴ�ָ�����Ѵ���ģ�K
Public Sub removeModule(moduleName As String)

    On Error Resume Next

    'ʹ�� Is Nothing �����Д�ָ�����ֵ�ģ�K�Ƿ��ѽ����ڣ�ע����Ҫ�����Z�� On Error Resume Next����Ȼ���]���ҵ�ָ����ģ�K�r�����e
    If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

        Debug.Print "Module ( " & moduleName & " ) is Nothing."

    Else

        ThisWorkbook.VBProject.VBComponents.Remove ThisWorkbook.VBProject.VBComponents(moduleName)  '�Ƴ�ģ�K

        'ģ�K�Ƴ�֮�ᣬ�ٴ�ʹ�� Is Nothing �����Д�ָ�����ֵ�ģ�K�Ƿ��ѽ����ڣ�ע����Ҫ�����Z�� On Error Resume Next����Ȼ���]���ҵ�ָ����ģ�K�r�����e
        If ThisWorkbook.VBProject.VBComponents(moduleName) Is Nothing Then

            'Debug.Print "Module ( " & moduleName & " ) be removed."

        Else

            Debug.Print "remove Module ( " & moduleName & " ) error, Module ( " & moduleName & " ) cannot be remove."
            'Exit Sub

        End If

    End If

End Sub


'�˳�ǰ���������
Public Sub callRemoveModule()

    On Error Resume Next

    '�Д��Ƿ��г����Ԅӌ����ģ�K
    If importModuleNamedict.Count > 0 Then

        Dim i As Integer
        For i = 0 To UBound(importModuleNamedict.Keys())

            '���ӛ����ֵ�ģ�K���ڣ��t�Ƴ�ģ�K�K�҄h���ֵ��Ќ�����ӛ䛗lĿ�����ӛ����ֵ�ģ�K�����ڣ��tֱ�ӄh���ֵ��Ќ�����ӛ䛗lĿ
            If ThisWorkbook.VBProject.VBComponents(importModuleNamedict.Item(importModuleNamedict.Keys()(i))) Is Nothing Then

                Debug.Print "Module ( " & importModuleNamedict.Item(importModuleNamedict.Keys()(i)) & " ) is Nothing."
                importModuleNamedict.Remove (importModuleNamedict.Keys()(i))  '�����ֵ��Ƴ�ָ���ėlĿ

            Else

                removeModule (importModuleNamedict.Item(importModuleNamedict.Keys()(i)))  'ʹ���Զ��x���^���Ƴ�ָ��ģ�K

                'ģ�K�Ƴ�֮�ᣬ�ٴ�ʹ�� Is Nothing �����Д�ָ�����ֵ�ģ�K�Ƿ��ѽ����ڣ�ע����Ҫ�����Z�� On Error Resume Next����Ȼ���]���ҵ�ָ����ģ�K�r�����e
                If ThisWorkbook.VBProject.VBComponents(importModuleNamedict.Item(importModuleNamedict.Keys()(i))) Is Nothing Then

                    'Debug.Print "Module ( " & importModuleNamedict.Item(importModuleNamedict.Keys()(i)) & " ) be removed."
                    importModuleNamedict.Remove (importModuleNamedict.Keys()(i))  '�����ֵ��Ƴ�ָ���ėlĿ

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

'�˳�ǰ���������
Public Sub callKillProcess()

    On Error Resume Next

    '�Д��Ƿ��г����Ԅӄ������M��
    If shellPIDdict.Count > 0 Then

        'ʹ���Զ��x�����^���P�]ָ�� PID ���M��
        Dim i As Integer
        For i = 0 To UBound(shellPIDdict.Keys())
            Call killProcess(shellPIDdict.Item(shellPIDdict.Keys()(i)))
            'Debug.Print "Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) be closed."
        Next


        '�z��ָ�� PID ���M���Ƿ��ѽ����P�]�������ڣ������߀���ڣ��t�����_��ʾ�P�]ʧ������������ڄt�h��ӛ��ֵ��Ќ����ėlĿ
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

                    'shellPIDdict.Remove (shellPIDdict.Keys()(i))  '�����ֵ��Ƴ�ָ���ėlĿ

                    Debug.Print "close Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) error, Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) cannot be closed."

                    flag = False

                    Exit For

                End If

            Next

            If flag Then

                Debug.Print "Process ( PID = " & shellPIDdict.Item(shellPIDdict.Keys()(i)) & " ) be closed."
                shellPIDdict.Remove (shellPIDdict.Keys()(i))  '�����ֵ��Ƴ�ָ���ėlĿ

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
    
    If err.Number <> 0 Then
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

    If err.Number <> 0 Then
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


'VBA Base64 ���a������
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

'VBA Base64 ��a������
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

Public Sub delay(T As Long): Rem ����һ���Զ��x���_�ӕr���^�̣����������Ҫ�ӕr���ܕrֱ���{�á��÷��飺delay(T);��T������Ҫ�ӕr�ĕr�L����λ�Ǻ��룬ȡֵ��󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ���@��ֵ�Ĺ����� 0 �� 2^32 ֮�g����s�� 49.71 �ա��P�I�� Private ��ʾ���^��������ֻ�ڱ�ģ�K��Ч���P�I�� Public ��ʾ���^��������������ģ�K����Ч
    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣
    Dim time1 As Long
    time1 = timeGetTime: Rem ���� timeGetTime ��ʾϵ�y�r�g��ԓ�r�g���ϵ�y�_�����������^�ĕr�g����λ���룩�����m�n��ӛ䛡�
    Do
        If Not (CrawlerControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
            If timeGetTime - time1 < T Then
                CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ " & CStr(timeGetTime - time1) & " ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
            End If
            If timeGetTime - time1 >= T Then
                CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ 0 ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
            End If
        End If

        DoEvents: Rem �Z�� DoEvents ��ʾ����ϵ�y CPU ���ƙ�߀�o����ϵ�y��Ҳ�����ڴ�ѭ�h�A�Σ��Ñ�����ͬ�r������X���������ã������ǌ��������ֱ��ѭ�h�Y����

    Loop While timeGetTime - time1 < T

    If Not (CrawlerControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
        If timeGetTime - time1 < T Then
            CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ " & CStr(timeGetTime - time1) & " ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
        End If
        If timeGetTime - time1 >= T Then
            CrawlerControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ 0 ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
        End If
    End If

End Sub

