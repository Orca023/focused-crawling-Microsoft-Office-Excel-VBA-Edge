VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} CrawlerControlPanel 
   Caption         =   "Crawler control panel"
   ClientHeight    =   12144
   ClientLeft      =   48
   ClientTop       =   372
   ClientWidth     =   12168
   OleObjectBlob   =   "CrawlerControlPanel.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  '����������
End
Attribute VB_Name = "CrawlerControlPanel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'Author: �w��
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
'Date: �q�ڱ���


'The codes were enhanced for both VBA7 (64-bit) and others (32-bit) by Long Vh.
#If VBA7 Then

    Private Declare PtrSafe Sub sleep Lib "kernel64" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 64 λܛ��ʹ���@�l�Z����
    Private Declare PtrSafe Function timeGetTime Lib "winmm.dll" () As Long: Rem 64 λܛ��ʹ���@�l�Z����
    
    '�� SendMessage ���������� SendMessage �� Windows ϵ�y API ������ʹ��ǰ���������Ȼ�����ʹ�á�
    Private Declare PtrSafe Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 64 λܛ��ʹ���@�l�Z����

#Else

    Private Declare Sub sleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 32 λܛ��ʹ���@�l�Z�������� sleep ���������� sleep �� Windows API ������ʹ��ǰ�����������Ȼ����ʹ�á��@�l�Z���Ǟ�����ʹ�� sleep �������_�ӕrʹ�õģ���������в�ʹ�� sleep ���������Ԅh���@�l�Z�䡣���� sleep ��ʹ�÷����ǣ�sleep 3000  '3000 ��ʾ 3000 ���롣���� sleep �ӕr�Ǻ��뼉�ģ����_�ȱ��^�ߣ��������ӕr�r�������������ʹ����ϵ�y���r�o��푑��Ñ������������L�ӕr���m��ʹ�á�
    Private Declare Function timeGetTime Lib "winmm.dll" () As Long: Rem 32 λܛ��ʹ���@�l�Z�������� timeGetTime ���������� timeGetTime �� Windows API ������ʹ��ǰ�����������Ȼ����ʹ�á��@�l�Z���Ǟ�����ʹ�� timeGetTime �������_�ӕrʹ�õģ���������в���Ҫʹ�� timeGetTime ����Ҳ���Ԅh���@�l�Z�䡣���� timeGetTime ���ص����_�C���F�ڵĺ��딵������֧�� 1 ������g���r�g��һֱ���ӡ�

    '�� SendMessage ���������� SendMessage �� Windows ϵ�y API ������ʹ��ǰ���������Ȼ�����ʹ�á�
    Private Declare Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 32 λܛ��ʹ���@�l�Z�������� SendMessage ���������� SendMessage �� Windows ϵ�y API ������ʹ��ǰ���������Ȼ�����ʹ�á�

#End If
Private Const WM_SYSCOMMAND = &H112: Rem ����������ʹ�õĳ���ֵ
Private Const SC_MINIMIZE = &HF020&: Rem ����������ʹ�õĳ���ֵ
'ʹ�ú���ʾ��
'SendMessage IEA.hwnd, WM_SYSCOMMAND, SC_MINIMIZE, 0: Rem ��g�[�����ڰl����Ϣ����С���g�[�����ڣ��@��ʹ�õ� Windows ϵ�y�� API ��������ģ�K�^���Ďחl�Z�������^


'���ʹ��ȫ��׃�� public �ķ������F�����Ñ����w�Y߅��ȫ��׃���xֵ��ʽ���£�
Option Explicit: Rem �Z�� Option Explicit ��ʾǿ��Ҫ��׃����Ҫ������ʹ�ã���ȫ��׃�������Կ�Խ���������^��֮�gʹ�õģ����ڱO�y���w�а�ť�ؼ��c����B��
Public PublicCurrentWorkbookName As String: Rem ���xһ��ȫ���ͣ�Public���ַ�����׃����PublicCurrentWorkbookName������춴�Ů�ǰ�����������Q
Public PublicCurrentWorkbookFullName As String: Rem ���xһ��ȫ���ͣ�Public���ַ�����׃����PublicCurrentWorkbookFullName������춴�Ů�ǰ��������ȫ����������·�������Q��
Public PublicCurrentSheetName As String: Rem ���xһ��ȫ���ͣ�Public���ַ�����׃����PublicCurrentSheetName������춴�Ů�ǰ����������Q


Public Public_Browser_Name As String: Rem ��ʾ�Д�ʹ�õı��R�g�[���N�����ȡֵ��("InternetExplorer", "Edge", "Chrome", "Firefox")������հײ�����ԓ�������A�Oֵ��ʾʹ�� "Edge" �g�[�����dָ���W�
Public Public_Browser_page_window_object As Object: Rem ���xһ��ȫ���ͣ�Public������׃����IWebBrowser2������춴�Şg�[�����d��Ŀ�˔���Դ��洰�ڌ���ľ����������m�������


Public PublicVariableStartORStopCollectDataButtonClickState As Boolean: Rem ���xһ��ȫ���ͣ�Public�������ͱ�����PublicVariableStartORStopCollectDataButtonClickState����춱O�y���w�Д����񼯰�ť�ؼ����c����B�����Ƿ������M�вɼ��Ġ�B��ʾ


Public Public_Current_page_number As Integer: Rem �@ȡ�����d�뮔ǰ퓴aֵ�Ĵ惦
Public Public_Max_page_number As Integer: Rem �@ȡ�������S�d�����퓴aֵ�Ĵ惦
Public Public_Number_of_entrance_from_first_level_page_to_second_level_page As Integer  'Max_Entry_number As Integer: Rem ��ǰ��һ�Ӽ�����У��M�댦���ڶ��Ӽ��������Ԫ�ؔ�Ŀ�����@ȡ�����d�����lĿֵ�Ĵ惦

Public Public_Data_Server_Url As String: Rem ��춴惦�ɼ��Y���Ĕ�����������Wַ���ַ���׃��
Public Public_Data_Receptors As String: Rem ��춴惦�ɼ��Y������������}�x��ֵ���ַ���׃��
Public Public_Key_Word As String: Rem �����P�I�~�z�������r��������P�I�~���ַ���׃��
Public Public_Start_page_number As Integer: Rem �_ʼ�ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃��
Public Public_Start_entry_number As Integer: Rem �_ʼ�ɼ��ĵڶ��Ӽ��W퓵�퓴a̖��������׃��
Public Public_End_page_number As Integer: Rem �Y���ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃��
Public Public_Data_level As String: Rem Ŀ�˔���Դ�W퓌Ӽ��Y�����ַ�����׃����ȡ "1" ֵ��ʾֻ�ɼ���ǰ��еĔ�����ȡ "2" ��ʾ߀���Ԅ��M��ڶ��Ӽ�����xȡ����
Public Public_Delay_length_input As Long: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L�Ļ��Aֵ����λ����
Public Public_Delay_length_random_input As Single: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L���S�C����������λ����Aֵ�İٷֱ�
Public Public_Delay_length As Long: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L����λ����


'��λĿ�˔���Դ�W��и�Ԫ�ص� XPath ֵ׃��
Public Public_Crawler_Strategy_module_name As String: Rem ��������x����ģ�K���Զ��x����ֵ�ַ���
Public Public_Custom_name_of_data_page As String: Rem Ŀ�˔���Դ�Wվ�����Զ��x��ӛ����ֵ�ַ���
Public Public_URL_of_data_page As String: Rem Ŀ�˔���Դ�Wվ���ľWַ URL ֵ�ַ���
Public Public_First_level_page_number_source_xpath As String: Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
Public Public_First_level_page_data_source_xpath As String: Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ���
Public Public_First_level_page_KeyWord_query_textbox_xpath As String: Rem ��λ���P�I�~�z����ݔ���� XPath ֵ�ַ���
Public Public_First_level_page_KeyWord_query_button_xpath As String: Rem ��λ���P�I�~�z�������o�� XPath ֵ�ַ���
Public Public_First_level_page_skip_textbox_xpath As String: Rem ��λ����퓡�ݔ���� XPath ֵ�ַ���
Public Public_First_level_page_skip_button_xpath As String: Rem ��λ����퓡����o�� XPath ֵ�ַ���
Public Public_First_level_page_next_button_xpath As String: Rem ��λ����һ퓡����o�� XPath ֵ�ַ���
Public Public_First_level_page_back_button_xpath As String: Rem ��λ����һ퓡����o�� XPath ֵ�ַ���
Public Public_From_first_level_page_to_second_level_page_xpath As String: Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
'Public Public_Second_level_page_number_source_xpath As String: Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
Public Public_Second_level_page_data_source_xpath As String: Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ���
Public Public_From_second_level_page_return_first_level_page_xpath As String: Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
Public Public_Inject_data_page_JavaScript As String: Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���
Public Public_Inject_data_page_JavaScript_filePath As String: Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��

Public Public_First_level_page_number_source_tag_name As String: Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
Public Public_First_level_page_number_source_position_index As Integer: Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
Public Public_First_level_page_data_source_tag_name As String: Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
Public Public_First_level_page_data_source_position_index As Integer: Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
Public Public_First_level_page_KeyWord_query_textbox_tag_name As String: Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
Public Public_First_level_page_KeyWord_query_textbox_position_index As Integer: Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
Public Public_First_level_page_KeyWord_query_button_tag_name As String: Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
Public Public_First_level_page_KeyWord_query_button_position_index As Integer: Rem ��λ���P�I�~�z�������o��λ����������ֵ
Public Public_First_level_page_skip_textbox_tag_name As String: Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
Public Public_First_level_page_skip_textbox_position_index As Integer: Rem ��λ����퓡�ݔ����λ����������ֵ
Public Public_First_level_page_skip_button_tag_name As String: Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
Public Public_First_level_page_skip_button_position_index As Integer: Rem ��λ����퓡����o��λ����������ֵ
Public Public_First_level_page_next_button_tag_name As String: Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
Public Public_First_level_page_next_button_position_index As Integer: Rem ��λ����һ퓡����o��λ����������ֵ
Public Public_First_level_page_back_button_tag_name As String: Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
Public Public_First_level_page_back_button_position_index As Integer: Rem ��λ����һ퓡����o��λ����������ֵ
Public Public_From_first_level_page_to_second_level_page_tag_name As String: Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
Public Public_From_first_level_page_to_second_level_page_position_index As Integer: Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
'Public Public_Second_level_page_number_source_tag_name As String: Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
'Public Public_Second_level_page_number_source_position_index As Integer: Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
Public Public_Second_level_page_data_source_tag_name As String: Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
Public Public_Second_level_page_data_source_position_index As Integer: Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
Public Public_From_second_level_page_return_first_level_page_tag_name As String: Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
Public Public_From_second_level_page_return_first_level_page_position_index As Integer: Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ


Public Sub UserForm_Initialize()
'���w���_ǰ�¼����o���w�ؼ��е�ȫ��׃���x��ֵ������ UserForm_Initialize �������Ǵ��w�ؼ����_���\�г�ʼ��

    '�Z�� On Error Resume Next ��ʹ�����ծa���e�`���Z��֮����Z���^�m����
    On Error Resume Next

    CrawlerControlPanel.PublicCurrentWorkbookName = ThisWorkbook.name: Rem �@�î�ǰ�����������Q��Ч����ͬ춡� = ActiveWorkbook.Name ��
    CrawlerControlPanel.PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem �@�î�ǰ��������ȫ����������·�������Q��
    CrawlerControlPanel.PublicCurrentSheetName = ActiveSheet.name: Rem �@�î�ǰ����������Q


    '�o�O�y���w�Д����񼯰�ť�ؼ����c����B׃���x��ֵ��ʼ��
    PublicVariableStartORStopCollectDataButtonClickState = True: Rem ������׃������춱O�y���w�Д����񼯰�ť�ؼ����c����B�����Ƿ������M�вɼ��Ġ�B��ʾ

    '�o��ǰ퓴a��Ϣ�x��ֵ��ʼ��
    Public_Current_page_number = 0: Rem �@ȡ�����d�뮔ǰ퓴aֵ�Ĵ惦
    Public_Max_page_number = 0: Rem �@ȡ�������S�d�����퓴aֵ�Ĵ惦
    Public_Number_of_entrance_from_first_level_page_to_second_level_page = 0  'Max_Entry_number = 0: Rem ��ǰ��һ�Ӽ�����У��M�댦���ڶ��Ӽ��������Ԫ�ؔ�Ŀ�����@ȡ�����d�����lĿֵ�Ĵ惦

    Public_Browser_Name = "": Rem ��ʾ�Д�ʹ�õı��R�g�[���N�����ȡֵ��("InternetExplorer", "Edge", "Chrome", "Firefox")������հײ�����ԓ�������A�Oֵ��ʾʹ�� "Edge" �g�[�����dָ���W�

    '�鶨λ����Ԫ�ص� XPath �ַ���׃���x��ֵ
    Public_Crawler_Strategy_module_name = "": Rem ��������x����ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K���������磺testCrawlerModule
    Public_Custom_name_of_data_page = "": Rem Ŀ�˔���Դ�Wվ���Զ��x��ӛ����ֵ�ַ��������磺testContainDataWebPage
    Public_URL_of_data_page = "": Rem Ŀ�˔���Դ�Wվ���ľWַ URL ֵ�ַ��������磺http://127.0.0.1:8000/a.html
    Public_First_level_page_number_source_xpath = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ��������磺/html/body/div/centre/label ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-label
    Public_First_level_page_data_source_xpath = "": Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ��������磺/html/body/div/centre/div/table ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-table
    Public_First_level_page_KeyWord_query_textbox_xpath = "": Rem ��λ���P�I�~�z����ݔ���� XPath ֵ�ַ��������磺/html/body/div/centre/input[1] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-input
    Public_First_level_page_KeyWord_query_button_xpath = "": Rem ��λ���P�I�~�z�������o�� XPath ֵ�ַ��������磺/html/body/div/centre/button[1] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-button
    Public_First_level_page_skip_textbox_xpath = "": Rem ��λ����퓡�ݔ���� XPath ֵ�ַ��������磺/html/body/div/centre/input[2] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����1-input
    Public_First_level_page_skip_button_xpath = "": Rem ��λ����퓡����o�� XPath ֵ�ַ��������磺/html/body/div/centre/button[2] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����1-button
    Public_First_level_page_next_button_xpath = "": Rem ��λ����һ퓡����o�� XPath ֵ�ַ��������磺/html/body/div/centre/a[2] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����1-a
    Public_First_level_page_back_button_xpath = "": Rem ��λ����һ퓡����o�� XPath ֵ�ַ��������磺/html/body/div/centre/a[1] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-a
    Public_From_first_level_page_to_second_level_page_xpath = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ��������磺/html/body/div/centre/div/table ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-table
    'Public_Second_level_page_number_source_xpath = "": Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
    Public_Second_level_page_data_source_xpath = "": Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ��������磺/html/body/div/centre/div/table ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����0-table
    Public_From_second_level_page_return_first_level_page_xpath = "": Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��� XPath ֵ�ַ��������磺/html/body/div/centre/a[3] ��ᘌ� InternetExplorer �g�[�� byTagName �ķ�����2-a
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���
    Public_Inject_data_page_JavaScript = "": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���
    'Public_Inject_data_page_JavaScript_filePath = "C:/Criss/vba/Automatic/test/test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
    Public_Inject_data_page_JavaScript_filePath = "": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��

    '�鶨λ����Ԫ�صĘ˺����Q��λ�������ַ���׃���x��ֵ
    Public_First_level_page_number_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    Public_First_level_page_number_source_position_index = CInt(-1): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    Public_First_level_page_data_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    Public_First_level_page_data_source_position_index = CInt(-1): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
    Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
    Public_First_level_page_KeyWord_query_textbox_position_index = CInt(-1): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
    Public_First_level_page_KeyWord_query_button_tag_name = "": Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
    Public_First_level_page_KeyWord_query_button_position_index = CInt(-1): Rem ��λ���P�I�~�z�������o��λ����������ֵ
    Public_First_level_page_skip_textbox_tag_name = "": Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
    Public_First_level_page_skip_textbox_position_index = CInt(-1): Rem ��λ����퓡�ݔ����λ����������ֵ
    Public_First_level_page_skip_button_tag_name = "": Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
    Public_First_level_page_skip_button_position_index = CInt(-1): Rem ��λ����퓡����o��λ����������ֵ
    Public_First_level_page_next_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    Public_First_level_page_next_button_position_index = CInt(-1): Rem ��λ����һ퓡����o��λ����������ֵ
    Public_First_level_page_back_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    Public_First_level_page_back_button_position_index = CInt(-1): Rem ��λ����һ퓡����o��λ����������ֵ
    Public_From_first_level_page_to_second_level_page_tag_name = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    Public_From_first_level_page_to_second_level_page_position_index = CInt(-1): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
    'Public_Second_level_page_number_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    'Public_Second_level_page_number_source_position_index = CInt(-1): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    Public_Second_level_page_data_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    Public_Second_level_page_data_source_position_index = CInt(-1): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
    Public_From_second_level_page_return_first_level_page_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    Public_From_second_level_page_return_first_level_page_position_index = CInt(-1): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ

    If Public_Browser_Name = "InternetExplorer" Then

        ''Dim i As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
        'Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M

        ''��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
        'Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
        ''Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
        ''Public_First_level_page_number_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index

        ''��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
        'Public_First_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-")
        ''Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
        ''Public_First_level_page_data_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_data_source_tag_name & ", " & Public_First_level_page_data_source_position_index

        ''��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
        'Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
        ''Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
        ''Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index

        ''��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
        'Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
        ''Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
        ''Public_First_level_page_KeyWord_query_button_tag_name = "": Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index

        ''��λ����퓡�ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡�ݔ����λ����������ֵ
        'Public_First_level_page_skip_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-")
        ''Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡�ݔ����λ����������ֵ
        ''Public_First_level_page_skip_textbox_tag_name = "": Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & CStr(tempArr(i)): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_skip_textbox_tag_name & ", " & Public_First_level_page_skip_textbox_position_index

        ''��λ����퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡����o��λ����������ֵ
        'Public_First_level_page_skip_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-")
        ''Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡����o��λ����������ֵ
        ''Public_First_level_page_skip_button_tag_name = "": Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & CStr(tempArr(i)): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_skip_button_tag_name & ", " & Public_First_level_page_skip_button_position_index

        ''��λ����һ퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        ''tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
        'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
        'Public_First_level_page_next_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
        ''Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
        ''Public_First_level_page_next_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_next_button_tag_name & ", " & Public_First_level_page_next_button_position_index

        ''��λ����һ퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
        'Public_First_level_page_back_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-")
        ''Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
        ''Public_First_level_page_back_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_First_level_page_back_button_tag_name & ", " & Public_First_level_page_back_button_position_index

        ''��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
        'Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
        ''Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
        ''Public_From_first_level_page_to_second_level_page_tag_name = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index

        '''��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
        ''ReDim tempArr(0): Rem ��Ք��M
        ''tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        '''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        ''Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
        ''Public_Second_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        '''tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-")
        '''Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
        '''Public_Second_level_page_number_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        '''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '''        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        '''    Else
        '''        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
        '''    End If
        '''Next
        '''Debug.Print Public_Second_level_page_number_source_tag_name & ", " & Public_Second_level_page_number_source_position_index

        ''��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
        'Public_Second_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-")
        ''Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
        ''Public_Second_level_page_data_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_Second_level_page_data_source_tag_name & ", " & Public_Second_level_page_data_source_position_index

        ''��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
        'ReDim tempArr(0): Rem ��Ք��M
        'tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
        ''Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        'Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ
        'Public_From_second_level_page_return_first_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-")
        ''Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ
        ''Public_From_second_level_page_return_first_level_page_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        ''    If i = CInt(LBound(tempArr) + CInt(1)) Then
        ''        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''    Else
        ''        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
        ''    End If
        ''Next
        ''Debug.Print Public_From_second_level_page_return_first_level_page_tag_name & ", " & Public_From_second_level_page_return_first_level_page_position_index

    End If


    '�鶨λ����Ԫ�ص� XPath �ַ���׃���x��ֵ
    'Public_Custom_name_of_data_page = "": Rem Ŀ�˔���Դ�Wվ���Զ��x��ӛ����ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox") Is Nothing) Then
    '    'Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    'End If
    'Public_URL_of_data_page = "": Rem Ŀ�˔���Դ�Wվ���ľWַ URL ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("URL_of_data_page_TextBox") Is Nothing) Then
    '    'Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    'End If
    'Public_First_level_page_number_source_xpath = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    '    '    Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
    '    '    'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    '    '    'Public_First_level_page_number_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
    '    'End If
    'End If
    'Public_First_level_page_data_source_xpath = "": Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
    '    '    Public_First_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-")
    '    '    'Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
    '    '    'Public_First_level_page_data_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_data_source_tag_name & ", " & Public_First_level_page_data_source_position_index
    '    'End If
    'End If
    'Public_First_level_page_KeyWord_query_textbox_xpath = "": Rem ��λ���P�I�~�z����ݔ���� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
    '    '    Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
    '    '    'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
    '    '    'Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index
    '    'End If
    'End If
    'Public_First_level_page_KeyWord_query_button_xpath = "": Rem ��λ���P�I�~�z�������o�� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
    '    '    Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
    '    '    'Public_First_level_page_KeyWord_query_button_tag_name = "": Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index
    '    'End If
    'End If
    'Public_First_level_page_skip_textbox_xpath = "": Rem ��λ����퓡�ݔ���� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����퓡�ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡�ݔ����λ����������ֵ
    '    '    Public_First_level_page_skip_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-")
    '    '    'Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡�ݔ����λ����������ֵ
    '    '    'Public_First_level_page_skip_textbox_tag_name = "": Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & CStr(tempArr(i)): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_skip_textbox_tag_name & ", " & Public_First_level_page_skip_textbox_position_index
    '    'End If
    'End If
    'Public_First_level_page_skip_button_xpath = "": Rem ��λ����퓡����o�� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡����o��λ����������ֵ
    '    '    Public_First_level_page_skip_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡����o��λ����������ֵ
    '    '    'Public_First_level_page_skip_button_tag_name = "": Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & CStr(tempArr(i)): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_skip_button_tag_name & ", " & Public_First_level_page_skip_button_position_index
    '    'End If
    'End If
    'Public_First_level_page_next_button_xpath = "": Rem ��λ����һ퓡����o�� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����һ퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
    '    '    tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
    '    '    Public_First_level_page_next_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
    '    '    'Public_First_level_page_next_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_next_button_tag_name & ", " & Public_First_level_page_next_button_position_index
    '    'End If
    'End If
    'Public_First_level_page_back_button_xpath = "": Rem ��λ����һ퓡����o�� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����һ퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
    '    '    Public_First_level_page_back_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-")
    '    '    'Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
    '    '    'Public_First_level_page_back_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_back_button_tag_name & ", " & Public_First_level_page_back_button_position_index
    '    'End If
    'End If
    'Public_From_first_level_page_to_second_level_page_xpath = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox") Is Nothing) Then
    '    'Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
    '    '    Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
    '    '    'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
    '    '    'Public_From_first_level_page_to_second_level_page_tag_name = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index
    '    'End If
    'End If
    ''Public_Second_level_page_number_source_xpath = "": Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
    ''If Not (CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox") Is Nothing) Then
    ''    'Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    ''    Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    ''    'If Public_Browser_Name = "InternetExplorer" Then
    ''    '    '��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    ''    '    ReDim tempArr(0): Rem ��Ք��M
    ''    '    tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    ''    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    ''    '    Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    ''    '    Public_Second_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    ''    '    'tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-")
    ''    '    'Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    ''    '    'Public_Second_level_page_number_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    ''    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    ''    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    ''    '    '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    ''    '    '    Else
    ''    '    '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    ''    '    '    End If
    ''    '    'Next
    ''    '    'Debug.Print Public_Second_level_page_number_source_tag_name & ", " & Public_Second_level_page_number_source_position_index
    ''    'End If
    ''End If
    'Public_Second_level_page_data_source_xpath = "": Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox") Is Nothing) Then
    '    'Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
    '    '    Public_Second_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-")
    '    '    'Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
    '    '    'Public_Second_level_page_data_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_Second_level_page_data_source_tag_name & ", " & Public_Second_level_page_data_source_position_index
    '    'End If
    'End If
    'Public_From_second_level_page_return_first_level_page_xpath = "": Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox") Is Nothing) Then
    '    'Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    '    '    ReDim tempArr(0): Rem ��Ք��M
    '    '    tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ
    '    '    Public_From_second_level_page_return_first_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    'tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-")
    '    '    'Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ
    '    '    'Public_From_second_level_page_return_first_level_page_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    '    Else
    '    '    '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_From_second_level_page_return_first_level_page_tag_name & ", " & Public_From_second_level_page_return_first_level_page_position_index
    '    'End If
    'End If
    ''Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���
    'Public_Inject_data_page_JavaScript = "": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���
    ''If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    ''    'Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    ''    Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    ''End If
    ''Public_Inject_data_page_JavaScript_filePath = "C:/Criss/vba/Automatic/test/test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
    'Public_Inject_data_page_JavaScript_filePath = "": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
    'If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    '    'Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    'Debug.Print Public_Inject_data_page_JavaScript_filePath
    'End If
    'If Public_Inject_data_page_JavaScript_filePath <> "" Then

    '    '�Д��Զ��x�Ĵ�����Ŀ�˔���Դ���� JavaScript �ű��ęn�Ƿ����
    '    Dim fso As Object, sFile As Object
    '    Set fso = CreateObject("Scripting.FileSystemObject")

    '    If fso.Fileexists(Public_Inject_data_page_JavaScript_filePath) Then

    '        'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

    '        'ʹ�� OpenTextFile �������_һ��ָ�����ęn�K����һ�� TextStream ����ԓ������Ԍ��ęn�M���x������׷�ӌ������
    '        '�����Z����object.OpenTextFile(filename[,iomode[,create[,format]]])
    '        '���� filename ��Ŀ���ęn��·��ȫ���ַ���
    '        '���� iomode ��ʾݔ���ݔ����ʽ�����Ԟ�ɂ�����֮һ��ForReading��ForAppending
    '        '���� Create ��ʾ���ָ���� filename �����ڕr���Ƿ��������һ�����ęn���� Boolean ֵ���􄓽����ęnȡ True ֵ���������tȡ False ֵ���A�O�� False ֵ
    '        '���� Format �����N Tristate ֵ֮һ���A�O���� ASCII ��ʽ���_�ęn

    '        '�O�ô��_�ęn��������
    '        Const ForReading = 1: Rem ���_һ��ֻ�x�ęn�����܌��ęn�M�Ќ�����
    '        Const ForWriting = 2: Rem ���_һ�����x�Ɍ��������ęn��ע�⣬����Մh���ęn��ԭ�е�����
    '        Const ForAppending = 8: Rem ���_һ���Ɍ��������ęn���K��ָ��Ƅӵ��ęn��ĩβ���������ęnβ��׷�ӌ�������������h���ęn��ԭ�е�����
    '        Const TristateUseDefault = -2: Rem ʹ��ϵ�yȱʡ�ľ��a��ʽ���_�ęn
    '        Const TristateTrue = -1: Rem �� Unicode ���a�ķ�ʽ���_�ęn
    '        Const TristateFalse = 0: Rem �� ASCII ���a�ķ�ʽ���_�ęn��ע�⣬�h�֕��y�a

    '        '��ֻ�x��ʽ���_�ęn
    '        Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

    '        ''�Д���������ęn�ı���β�ˣ��t���m�xȡ����ƴ��
    '        'Public_Inject_data_page_JavaScript = ""
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem �Ĵ��_���ęn���xȡһ���ַ���ƴ�ӣ��K���ַ����Yβ����һ����܇��̖
    '        '    'Debug.Print sFile.ReadLine: Rem �xȡһ�У���������β�ēQ�з�
    '        'Loop
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem �Ĵ��_���ęn���xȡһ���ַ�ƴ��
    '        '    'Debug.Print sFile.Read(1): Rem �xȡһ���ַ�
    '        'Loop

    '        Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem �xȡ�ęn�е�ȫ������
    '        'Debug.Print sFile.ReadAll
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem �� Unicode ���a���ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        sFile.Close

    '    Else

    '        Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
    '        'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

    '    End If

    '    Set sFile = Nothing
    '    Set fso = Nothing

    'End If


    Public_Data_Server_Url = "": Rem ��춴惦�ɼ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://username:password@localhost:9001/?keyword=aaa")
    'If Not (CrawlerControlPanel.Controls("Data_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    'End If

    Public_Data_Receptors = "": Rem ��춴惦�ɼ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Database_and_Excel"��"Excel" ֵ������ȡֵ��CStr("Excel")
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (CrawlerControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
        Public_Data_Receptors = ""
        '��v����а�������Ԫ�ء�
        Dim element_i
        For Each element_i In Data_Receptors_Frame.Controls
            '�Д��}�x��ؼ����x�Р�B
            If element_i.Value Then
                If Public_Data_Receptors = "" Then
                    Public_Data_Receptors = CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                Else
                    Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                End If
            End If
        Next
        Set element_i = Nothing
        'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
        'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = ""
        'Else
        'End If
    End If

    Public_Key_Word = "": Rem �����P�I�~�z�������r��������P�I�~���ַ���׃��
    'If Not (CrawlerControlPanel.Controls("Keyword_Query_TextBox") Is Nothing) Then
    '    'Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    'End If

    Public_Start_page_number = CInt(0): Rem �_ʼ�ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃�������� CInt() ��ʾǿ���D�Q�������
    'If Not (CrawlerControlPanel.Controls("Start_page_number_TextBox") Is Nothing) Then
    '    'Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q�������
    '    Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q�������
    'End If

    Public_Start_entry_number = CInt(0): Rem �_ʼ�ɼ��ĵڶ��Ӽ��W퓵�퓴a̖��������׃�������� CInt() ��ʾǿ���D�Q�������
    'If Not (CrawlerControlPanel.Controls("Start_entry_number_TextBox") Is Nothing) Then
    '    'Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q�������
    '    Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q�������
    'End If

    Public_End_page_number = CInt(0): Rem �Y���ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃�������� CInt() ��ʾǿ���D�Q�������
    'If Not (CrawlerControlPanel.Controls("End_page_number_TextBox") Is Nothing) Then
    '    'Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q�������
    '    Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q�������
    'End If

    Public_Delay_length_input = CLng(0): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L���ͣ�����ȡֵ��CLng(1500)
    Public_Delay_length_random_input = CSng(0): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c�ͣ�����ȡֵ��CSng(0.2)
    'If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
    '    'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
    '    Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
    'End If
    'If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
    '    'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
    '    Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
    'End If
    'Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng(0)  'CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(0)  'CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����

    Public_Data_level = "0": Rem Ŀ�˔���Դ�W퓌Ӽ��Y�����ַ�����׃����ȡ "1" ֵ��ʾֻ�ɼ���ǰ��еĔ�����ȡ "2" ��ʾ߀���Ԅ��M��ڶ��Ӽ�����xȡ���������� CStr() ��ʾ�D�Q���ַ�����ͣ�����ȡֵ��CStr(2)
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '��v����а�������Ԫ�ء�
        'Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '�Д����x��ؼ����x�Р�B
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If

End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
'���w�P�]ǰ�¼���������I�Γ����Ͻǡ�̖����
'���� Cancel �� > 0 ��ֵ�r����ʾ��ֹ�P�]�����İl�����������S�Ñ��c�����w���Ͻǵ� �� ̖��Ҳ�����Sʹ�á����ơ��ˆ��еġ��P�]�����
'���� CloseMode ��ʾ�P�]��ģʽ��

    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣

    If Public_Browser_Name = "InternetExplorer" Then
        'If CloseMode = 0 Then Cancel = 1: Rem �����S�P�]���w���򌑳� cancel=true �@�ӵ���ʽҲ���ԣ�ȡ true ֵ�rֵ�� 1��
        Public_Browser_page_window_object.quit: Rem �P�] IE �g�[������
        'Public_Browser_page_window_object.document.parentwindow.execscript "javascript:window.opener=null;window.open('','_self');window.close();": Rem �P�] IE �g�[������
        Set Public_Browser_page_window_object = Nothing: Rem ���׃��ጷ��ڴ�
    ElseIf (Public_Browser_Name = "Edge") Or (Public_Browser_Name = "Chrome") Or (Public_Browser_Name = "Firefox") Then
        Public_Browser_page_window_object.quit: Rem �P�] Edge �g�[������
        Set Public_Browser_page_window_object = Nothing: Rem ���׃��ጷ��ڴ�
    Else
    End If

End Sub

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


'��춴惦�ɼ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Database_and_Excel"��"Excel" ֵ������ȡֵ��CStr("Excel")
Private Sub Data_Receptors_CheckBox1_Click()
    Public_Data_Receptors = ""
    '��v����а�������Ԫ�ء�
    Dim element_i
    For Each element_i In Data_Receptors_Frame.Controls
        '�Д��}�x��ؼ����x�Р�B
        If element_i.Value Then
            If Public_Data_Receptors = "" Then
                Public_Data_Receptors = CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
            Else
                Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
            End If
        End If
    Next
    Set element_i = Nothing
    'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = ""
    'Else
    'End If
End Sub

Private Sub Data_Receptors_CheckBox2_Click()
    Public_Data_Receptors = ""
    '��v����а�������Ԫ�ء�
    Dim element_i
    For Each element_i In Data_Receptors_Frame.Controls
        '�Д��}�x��ؼ����x�Р�B
        If element_i.Value Then
            If Public_Data_Receptors = "" Then
                Public_Data_Receptors = CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
            Else
                Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
            End If
        End If
    Next
    Set element_i = Nothing
    'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    Public_Data_Receptors = ""
    'Else
    'End If
End Sub


'���x��������I�Γ��¼���Ŀ�˔���Դ�W퓌Ӽ��Y�����ַ�����׃����ȡ "1" ֵ��ʾֻ�ɼ���ǰ��еĔ�����ȡ "2" ��ʾ߀���Ԅ��M��ڶ��Ӽ�����xȡ���������� CStr() ��ʾ�D�Q���ַ�����ͣ�����ȡֵ��CStr(2)
Private Sub Data_level_OptionButton1_Click()
    '�Д����x��ؼ����x�Р�B
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'End If
    '�Д����x��ؼ����x�Р�B
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'End If
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '��v����а�������Ԫ�ء�
        Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '�Д����x��ؼ����x�Р�B
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
End Sub
Private Sub Data_level_OptionButton2_Click()
    '�Д����x��ؼ����x�Р�B
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton1").Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'End If
    '�Д����x��ؼ����x�Р�B
    'If CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Value Then
    '    Public_Data_level = CStr(CrawlerControlPanel.Controls("Data_level_Frame").Controls("Data_level_OptionButton2").Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    'End If
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '��v����а�������Ԫ�ء�
        Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '�Д����x��ؼ����x�Р�B
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
End Sub


Private Sub Load_data_source_page_CommandButton_Click()
'������I�Γ����d��Ŀ�˔���Դ�W퓣�Load�������o�¼���
'�Ñ����w�\���ᣬ������I�Γ���Load������o�������@�γ��򡣣�߀���Լ����Ñ����w�[���Z�䣬�t���\���У������@ʾ�Ñ����w�����{���ӳ��� ��LoadWebPage(WebURL)�� ��

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��

    'Call UserForm_Initialize: Rem ���w��ʼ���x��ֵ

    Application.CutCopyMode = False: Rem �˳��r�����@ʾԃ�����Ƿ���ռ��N�匦Ԓ��
    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣

    'ˢ��Ŀ�˔���Դ�Wվ���Զ��x��ӛ����ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox") Is Nothing) Then
        'Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
        Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    End If
    'Debug.Print "Custom name of data web = " & "[ " & Public_Custom_name_of_data_page & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Custom_name_of_data_page ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Custom_name_of_data_page = Public_Custom_name_of_data_page: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�Ŀ�˔���Դ�Wվ�����Զ��x��ӛ����ֵֵ�ַ�����׃�������xֵ
            'testCrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text)
            'testCrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Custom_name_of_data_page)
            'Debug.Print testCrawlerModule.Public_Custom_name_of_data_page
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Custom_name_of_data_page = Public_Custom_name_of_data_page"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Custom_name_of_data_page = Public_Custom_name_of_data_page"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Custom_name_of_data_page = Public_Custom_name_of_data_page: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ�Ŀ�˔���Դ�Wվ�����Զ��x��ӛ����ֵֵ�ַ�����׃�������xֵ
            'CFDACrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text)
            'CFDACrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Custom_name_of_data_page)
            'Debug.Print CFDACrawlerModule.Public_Custom_name_of_data_page
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select

    'ˢ��Ŀ�˔���Դ�Wվ���Wַ URL �ַ���ֵ
    If Not (CrawlerControlPanel.Controls("URL_of_data_page_TextBox") Is Nothing) Then
        'Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
        Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    End If
    'Debug.Print "URL of data page = " & "[ " & Public_URL_of_data_page & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_URL_of_data_page ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_URL_of_data_page = Public_URL_of_data_page: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�Ŀ�˔���Դ�Wվ���ľWֵַ�ַ�����׃�������xֵ
            'testCrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text)
            'testCrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_URL_of_data_page)
            'Debug.Print testCrawlerModule.Public_URL_of_data_page
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_URL_of_data_page = Public_URL_of_data_page: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ�Ŀ�˔���Դ�Wվ���ľWֵַ�ַ�����׃�������xֵ
            'CFDACrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text)
            'CFDACrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_URL_of_data_page)
            'Debug.Print CFDACrawlerModule.Public_URL_of_data_page
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select

    'ˢ�´�����Ŀ�˔���Դ���� JavaScript �ű��ַ���
    If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
        'Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value)
        Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
        'Debug.Print Public_Inject_data_page_JavaScript_filePath
    End If
    If Public_Inject_data_page_JavaScript_filePath <> "" Then

        '�Д��Զ��x�Ĵ�����Ŀ�˔���Դ���� JavaScript �ű��ęn�Ƿ����
        Dim fso As Object, sFile As Object
        Set fso = CreateObject("Scripting.FileSystemObject")

        If fso.FileExists(Public_Inject_data_page_JavaScript_filePath) Then

            'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

            'ʹ�� OpenTextFile �������_һ��ָ�����ęn�K����һ�� TextStream ����ԓ������Ԍ��ęn�M���x������׷�ӌ������
            '�����Z����object.OpenTextFile(filename[,iomode[,create[,format]]])
            '���� filename ��Ŀ���ęn��·��ȫ���ַ���
            '���� iomode ��ʾݔ���ݔ����ʽ�����Ԟ�ɂ�����֮һ��ForReading��ForAppending
            '���� Create ��ʾ���ָ���� filename �����ڕr���Ƿ��������һ�����ęn���� Boolean ֵ���􄓽����ęnȡ True ֵ���������tȡ False ֵ���A�O�� False ֵ
            '���� Format �����N Tristate ֵ֮һ���A�O���� ASCII ��ʽ���_�ęn

            '�O�ô��_�ęn��������
            Const ForReading = 1: Rem ���_һ��ֻ�x�ęn�����܌��ęn�M�Ќ�����
            Const ForWriting = 2: Rem ���_һ�����x�Ɍ��������ęn��ע�⣬����Մh���ęn��ԭ�е�����
            Const ForAppending = 8: Rem ���_һ���Ɍ��������ęn���K��ָ��Ƅӵ��ęn��ĩβ���������ęnβ��׷�ӌ�������������h���ęn��ԭ�е�����
            Const TristateUseDefault = -2: Rem ʹ��ϵ�yȱʡ�ľ��a��ʽ���_�ęn
            Const TristateTrue = -1: Rem �� Unicode ���a�ķ�ʽ���_�ęn
            Const TristateFalse = 0: Rem �� ASCII ���a�ķ�ʽ���_�ęn��ע�⣬�h�֕��y�a

            '��ֻ�x��ʽ���_�ęn
            Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

            ''�Д���������ęn�ı���β�ˣ��t���m�xȡ����ƴ��
            'Public_Inject_data_page_JavaScript = ""
            'Do While Not sFile.AtEndOfStream
            '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem �Ĵ��_���ęn���xȡһ���ַ���ƴ�ӣ��K���ַ����Yβ����һ����܇��̖
            '    'Debug.Print sFile.ReadLine: Rem �xȡһ�У���������β�ēQ�з�
            'Loop
            'Do While Not sFile.AtEndOfStream
            '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem �Ĵ��_���ęn���xȡһ���ַ�ƴ��
            '    'Debug.Print sFile.Read(1): Rem �xȡһ���ַ�
            'Loop

            Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem �xȡ�ęn�е�ȫ������
            'Debug.Print sFile.ReadAll
            'Debug.Print Public_Inject_data_page_JavaScript

            'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem �� Unicode ���a���ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
            'Debug.Print Public_Inject_data_page_JavaScript

            sFile.Close

        Else

            Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
            'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

        End If

        Set sFile = Nothing
        Set fso = Nothing

    End If
    'Debug.Print "Inject data page JavaScript filePath = " & "[ " & Public_Inject_data_page_JavaScript_filePath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Inject_data_page_JavaScript_filePath ֵ��
    'Debug.Print "Inject data page JavaScript = " & "[ " & Public_Inject_data_page_JavaScript & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Inject_data_page_JavaScript ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű�·��ȫ����׃�������xֵ
            'testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript_filePath)
            'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript_filePath
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
            testCrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű��ַ�����׃�������xֵ
            ''testCrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript)
            'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ����׃�������xֵ
            'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath)
            'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath
            'CFDACrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű��ַ�����׃�������xֵ
            ''CFDACrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript)
            'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select

    '[A1] = URL1: Rem �@�l�Z����출yԇ���{ʽ�ꮅ��Ʉh����Ч������ Excel ��ǰ��ӹ������е� A1 ��Ԫ�����@ʾ׃�� URL1 ��ֵ��
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" �D�Q�����ڸ�ʽ�@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber �D�Q����ͨ�����@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ

    'CrawlerControlPanel.Hide: Rem �[���Ñ����w

    'ˢ���Զ��x���ӕr�ȴ��r�L
    'Public_Delay_length_input = CLng(1500): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'CFDACrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_input
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_random_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'CFDACrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_random_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_random_input
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K testCrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length)
            'Debug.Print CFDACrawlerModule.Public_Delay_length
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select


    ''Dim Public_Browser_Name As String: Rem ��׃���� ParamArray OtherArgs() ��ʾ�Д�ʹ�õı��R�g�[���N�
    ''Public_Browser_Name = "InternetExplorer": Rem ��׃���� ParamArray OtherArgs() ��ʾ�Д�ʹ�õı��R�g�[���N�����ȡֵ��("InternetExplorer", "Edge", "Chrome", "Firefox")������հײ�����ԓ�������A�Oֵ��ʾʹ�� "InternetExplorer" �g�[�����dָ���W�
    'Application.Run (Public_Crawler_Strategy_module_name & "." & "LoadWebPage(""" & Public_URL_of_data_page & """, """ & Public_Browser_Name & """)"): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
    'Application.Evaluate ("Call " & Public_Crawler_Strategy_module_name & "." & "LoadWebPage(""" & Public_URL_of_data_page & """, """ & Public_Browser_Name & """)"): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
    'Application.Evaluate (Public_Crawler_Strategy_module_name & "." & "LoadWebPage(""" & Public_URL_of_data_page & """, """ & Public_Browser_Name & """)"): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
    ''ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    'Select Case Public_Crawler_Strategy_module_name
    '    Case Is = "testCrawlerModule"
    '        Set testCrawlerModule.Public_Browser_page_window_object = Public_Browser_page_window_object: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��{�ô��_Ŀ�˔���Դ���Ğg�[������׃�������xֵ
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Browser_page_window_object)
    '        'Application.Evaluate "Set " & Public_Crawler_Strategy_module_name & ".Public_Browser_page_window_object = Public_Browser_page_window_object"
    '        'Application.Run "Set " & Public_Crawler_Strategy_module_name & ".Public_Browser_page_window_object = Public_Browser_page_window_object"
    '    Case Is = "CFDACrawlerModule"
    '        'Set CFDACrawlerModule.Public_Browser_page_window_object = Public_Browser_page_window_object: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��{�ô��_Ŀ�˔���Դ���Ğg�[������׃�������xֵ
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Browser_page_window_object)
    '    Case Else
    '        MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    '        'Exit Sub
    'End Select
    '�Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            '�Д�ʹ�õı��R�g�[���N�����ȡֵ��("InternetExplorer", "Edge", "Chrome", "Firefox")������հײ�����ԓ�������A�Oֵ��ʾʹ�� "Edge" �g�[�����dָ���W�
            Select Case Public_Browser_Name

                Case Is = "InternetExplorer"

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "���b�ڵȴ��Ę��� ��": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                    End If

                    'Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Inject_data_page_JavaScript, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
                    Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("LoadWebPage")
                    Set Public_Browser_page_window_object = testCrawlerModule.Public_Browser_page_window_object

                    'ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                        Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    End If

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If Public_Browser_page_window_object.ReadyState = 4 Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Data source page loading success, Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "����Դ�����d�e�` Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ��
                        End If
                    End If

                    'Exit Sub

                Case "Edge", "Chrome", "Firefox"

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "���b�ڵȴ��Ę��� ��": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                    End If

                    'Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Inject_data_page_JavaScript, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
                    Call testCrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("LoadWebPage")
                    Set Public_Browser_page_window_object = testCrawlerModule.Public_Browser_page_window_object

                    'ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                        Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    End If

                    'Debug.Print CStr(Public_Browser_page_window_object.jsEval("window.location.href")): Rem ʹ�� jsEval() ����ȡ����ǰ���_�W퓵ľWַ��
                    'Debug.Print CBool(Public_Browser_page_window_object.isLive): Rem ʹ�� .isLive() �Д��g�[�����ڌ����Ƿ�߀�������\�С�
                    'Debug.Print "Data source web page ( " & Public_Custom_name_of_data_page & " ) loading state = " & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)): Rem ���������ڴ�ӡ�W퓼��d��B���^���ӕr�ȴ� 3000 ���루3 ��犣����Ƿ��܉򌢾W�ȫ���d��ɹ�������W��d��ɹ����t��B�a���@ʾ��objBrowser.Readystate=4��
                    ''ReadyState ����N��B:
                    ''0:(Uninitialized) the send( ) method has not yet been invoked.
                    ''1:(Loading) the send( ) method has been invoked,request in progress.
                    ''2:(Loaded) the send( ) method has completed,entire response received.
                    ''3:(Interactive) the response is being parsed.
                    ''4:(Completed) the response has been parsed,is ready for harvesting.
                    ''0-��δ��ʼ��������ʾ߀�]���{�� send() ����
                    ''1-�����룩���{�� send() ��������ʾ������������l��Ո��
                    ''2-��������ɣ����� send() �ш�����ɣ���ʾ�ѽ����յ����������ص�ȫ��푑�����
                    ''3-������������ʾ�g�[�����ڽ������������ص�푑�����
                    ''4-����ɣ��g�[�������������ص�푑����ݽ�����ɣ���ʾ�Ñ������{�þW��е�Ԫ����

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "complete") Or (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "interactive") Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Data source page loading success, Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "����Դ�����d�e�` Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ��
                        End If
                    End If

                    'Exit Sub

                'Case "Chrome"
                'Case "Firefox"
                Case Else

                    MsgBox "�{�Þg�[�����ݔ���e�`��Browser Name = " & CStr(Public_Browser_Name) & "����ֻ��ȡ�ַ��� InternetExplorer��Edge��Chrome��Firefox ֮һ."
                    Exit Sub

            End Select

        Case Is = "CFDACrawlerModule"

            'Call CFDACrawlerModule.LoadWebPage(Public_URL_of_data_page, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function LoadWebPage()�����������_Ŀ�˔���Դ�W퓡�: Rem �@�� LoadWebPage �����ķ���ֵ�� InternetExplorer �g�[�����dĿ�˔���Դ�����Ĵ��ڌ���Ч������ InternetExplorer �g�[�����d��ָ�� URL �ľW퓣�Ȼ����d��W퓵� HTML �ű�����ȡĿ����Ϣ��Private �P�I�ֱ�ʾ���^��ֻ�ڱ�ģ�K����Ч��public �P�I�ֱ�ʾ���^��������ģ�K�ж���Ч
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("LoadWebPage")
            'Set Public_Browser_page_window_object = CFDACrawlerModule.Public_Browser_page_window_object

            ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'End If

            'Exit Sub

        Case Else

            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule ���x����."
            'Exit Sub

    End Select
    'Public_Browser_page_window_object.Quit: Rem �P�] InternetExplorer.Application �g�[������
    'Debug.Print "Data source web page ( " & Public_Custom_name_of_data_page & " ) loading state = " & Public_Browser_page_window_object.ReadyState: Rem ���������ڴ�ӡ�W퓼��d��B���^���ӕr�ȴ� 3000 ���루3 ��犣����Ƿ��܉򌢾W�ȫ���d��ɹ�������W��d��ɹ����t��B�a���@ʾ��IEA.Readystate=4��
    'Debug.Print Public_Browser_page_window_object.LocationURL: Rem ͨ�^��.LocationURL������ȡ����ǰ���_�W퓵ľWַ��
    'Debug.Print VBA.TypeName(Public_Browser_page_window_object)


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��

End Sub

Private Sub Keyword_Query_CommandButton_Click()
'������I�Γ����P�I�~�z�������o�¼�

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��

    '[A1] = URL1: Rem �@�l�Z����출yԇ���{ʽ�ꮅ��Ʉh����Ч������ Excel ��ǰ��ӹ������е� A1 ��Ԫ�����@ʾ׃�� URL1 ��ֵ��
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" �D�Q�����ڸ�ʽ�@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber �D�Q����ͨ�����@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ

    'CrawlerControlPanel.Hide: Rem �[���Ñ����w
    'Call UserForm_Initialize: Rem ���w��ʼ���x��ֵ

    Application.CutCopyMode = False: Rem �˳��r�����@ʾԃ�����Ƿ���ռ��N�匦Ԓ��
    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣


    'Dim i As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
    Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M

    'ˢ�¶�λ���P�I�~�z����ݔ���� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox") Is Nothing) Then

        'Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "Key word query textbox xpath = " & "[ " & Public_First_level_page_KeyWord_query_textbox_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_KeyWord_query_textbox_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z����ݔ���� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���P�I�~�z����ݔ���� XPath ֵ�ַ�����׃�������xֵ
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath)
                'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
            Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
            'Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z����ݔ����λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_position_index: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���P�I�~�z����ݔ����λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

        End If

    End If

    'ˢ�¶�λ���P�I�~�z�������o�� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then

        'Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "Key word query button xpath = " & "[ " & Public_First_level_page_KeyWord_query_button_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_KeyWord_query_button_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z�������o�� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���P�I�~�z�������o�� XPath ֵ�ַ�����׃�������xֵ
                'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath)
                'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_xpath
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
            Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
            'Public_First_level_page_KeyWord_query_button_tag_name = "": Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z�������o��λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name
                    'CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���P�I�~�z�������o��λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_position_index)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_KeyWord_query_button_position_index
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

        End If

    End If


    'ˢ���Զ��x���ӕr�ȴ��r�L
    'Public_Delay_length_input = CLng(1500): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'CFDACrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_input
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_random_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'CFDACrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_random_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_random_input
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K testCrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length)
            'Debug.Print CFDACrawlerModule.Public_Delay_length
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select


    '�xȡݔ����Ђ���ęz���P�I�~�ַ���
    If Not (CrawlerControlPanel.Controls("Keyword_Query_TextBox") Is Nothing) Then
        'Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Value)
        Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    End If
    'Debug.Print "Key Word = " & "[ " & Public_Key_Word & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Key_Word ֵ��
    ''ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    'Select Case Public_Crawler_Strategy_module_name
    '    Case Is = "testCrawlerModule"
    '        testCrawlerModule.Public_Key_Word = Public_Key_Word: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��z���P�I�~�ַ�����׃�������xֵ
    '        'testCrawlerModule.Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text)
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Key_Word)
    '        'Debug.Print testCrawlerModule.Public_Key_Word
    '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '    Case Is = "CFDACrawlerModule"
    '        'CFDACrawlerModule.Public_Key_Word = Public_Key_Word: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��z���P�I�~�ַ�����׃�������xֵ
    '        'CFDACrawlerModule.Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Key_Word)
    '        'Debug.Print CFDACrawlerModule.Public_Key_Word
    '    Case Else
    '        MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    '        'Exit Sub
    'End Select


    '�Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            '�Д�ʹ�õı��R�g�[���N�����ȡֵ��("InternetExplorer", "Edge", "Chrome", "Firefox")������հײ�����ԓ�������A�Oֵ��ʾʹ�� "Edge" �g�[�����dָ���W�
            Select Case Public_Browser_Name

                Case Is = "InternetExplorer"

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "���b�ڵȴ��Ę��� ��": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                    End If

                    Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_Current_page_number, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Sub First_level_page_KeyWord_Query()�����^�̣������P�I�~�z��������
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("First_level_page_KeyWord_Query")

                    ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                    '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    'End If

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If Public_Browser_page_window_object.ReadyState = 4 Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Key-Word query page loading success, Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "�P�I�~�z�������d�e�` Status=" & CStr(Public_Browser_page_window_object.ReadyState) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ��
                        End If
                    End If

                    'Exit Sub

                Case "Edge", "Chrome", "Firefox"

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "���b�ڵȴ��Ę��� ��": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                    End If

                    Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_Current_page_number, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Sub First_level_page_KeyWord_Query()�����^�̣������P�I�~�z��������
                    'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("First_level_page_KeyWord_Query")

                    ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
                    '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
                    'End If

                    'Debug.Print CStr(Public_Browser_page_window_object.jsEval("window.location.href")): Rem ʹ�� jsEval() ����ȡ����ǰ���_�W퓵ľWַ��
                    'Debug.Print CBool(Public_Browser_page_window_object.isLive): Rem ʹ�� .isLive() �Д��g�[�����ڌ����Ƿ�߀�������\�С�
                    'Debug.Print "Data source web page ( " & Public_Custom_name_of_data_page & " ) loading state = " & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)): Rem ���������ڴ�ӡ�W퓼��d��B���^���ӕr�ȴ� 3000 ���루3 ��犣����Ƿ��܉򌢾W�ȫ���d��ɹ�������W��d��ɹ����t��B�a���@ʾ��objBrowser.Readystate=4��
                    ''ReadyState ����N��B:
                    ''0:(Uninitialized) the send( ) method has not yet been invoked.
                    ''1:(Loading) the send( ) method has been invoked,request in progress.
                    ''2:(Loaded) the send( ) method has completed,entire response received.
                    ''3:(Interactive) the response is being parsed.
                    ''4:(Completed) the response has been parsed,is ready for harvesting.
                    ''0-��δ��ʼ��������ʾ߀�]���{�� send() ����
                    ''1-�����룩���{�� send() ��������ʾ������������l��Ո��
                    ''2-��������ɣ����� send() �ш�����ɣ���ʾ�ѽ����յ����������ص�ȫ��푑�����
                    ''3-������������ʾ�g�[�����ڽ������������ص�푑�����
                    ''4-����ɣ��g�[�������������ص�푑����ݽ�����ɣ���ʾ�Ñ������{�þW��е�Ԫ����

                    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                    If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                        If (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "complete") Or (CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) = "interactive") Then
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "Key-Word query page loading success, Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                        Else
                            CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "�P�I�~�z�������d�e�` Status=" & CStr(Public_Browser_page_window_object.jsEval("window.document.readyState", dbgMsg:=False)) & ".": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ��
                        End If
                    End If

                    'Exit Sub

                'Case "Chrome"
                'Case "Firefox"
                Case Else

                    MsgBox "�{�Þg�[�����ݔ���e�`��Browser Name = " & CStr(Public_Browser_Name) & "����ֻ��ȡ�ַ��� InternetExplorer��Edge��Chrome��Firefox ֮һ."
                    Exit Sub

            End Select

        Case Is = "CFDACrawlerModule"

            'Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, CFDACrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Sub First_level_page_KeyWord_Query()�����^�̣������P�I�~�z��������
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("First_level_page_KeyWord_Query")

            ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'End If

            'Exit Sub

        Case Else

            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule ���x����."
            'Exit Sub

    End Select
    'Debug.Print VBA.TypeName(Public_Browser_page_window_object)

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��

End Sub

Private Sub Extract_Page_Number_CommandButton_Click()
'������I�Γ����xȡ퓴a��Ϣ�����o�¼�

    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    'CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.End_page_number_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

    '[A1] = URL1: Rem �@�l�Z����출yԇ���{ʽ�ꮅ��Ʉh����Ч������ Excel ��ǰ��ӹ������е� A1 ��Ԫ�����@ʾ׃�� URL1 ��ֵ��
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" �D�Q�����ڸ�ʽ�@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber �D�Q����ͨ�����@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ

    'CrawlerControlPanel.Hide: Rem �[���Ñ����w
    'Call UserForm_Initialize: Rem ���w��ʼ���x��ֵ

    Application.CutCopyMode = False: Rem �˳��r�����@ʾԃ�����Ƿ���ռ��N�匦Ԓ��
    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣


    'Dim i As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
    Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M

    'ˢ�¶�λ��퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then

        'Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "Page number source xpath = " & "[ " & Public_First_level_page_number_source_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_number_source_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ��퓴a��ϢԴԪ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_number_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ��퓴a��ϢԴԪ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'CFDACrawlerModule.Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print CFDACrawlerModule.Public_First_level_page_number_source_xpath
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
            Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
            'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
            'Public_First_level_page_number_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ��퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    testCrawlerModule.Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ��퓴a��ϢԴԪ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ��퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_number_source_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_number_source_tag_name
                    'CFDACrawlerModule.Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ��퓴a��ϢԴԪ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_First_level_page_number_source_position_index)
                    'Debug.Print CFDACrawlerModule.Public_First_level_page_number_source_position_index
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

        End If

    End If

    'ˢ�¶�λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then

        'Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "Entrance from first level page to second level page xpath = " & "[ " & Public_From_first_level_page_to_second_level_page_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_From_first_level_page_to_second_level_page_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath)
                'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath)
                'Debug.Print CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_xpath
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then

            '��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
            Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
            'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
            'Public_From_first_level_page_to_second_level_page_tag_name = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                Case Is = "CFDACrawlerModule"
                    'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule)
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name)
                    'Debug.Print CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name
                    'CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ���λ���Į�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_position_index)
                    'Debug.Print CFDACrawlerModule.Public_From_first_level_page_to_second_level_page_position_index
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

        End If

    End If


    'ˢ���Զ��x���ӕr�ȴ��r�L
    'Public_Delay_length_input = CLng(1500): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_input = Public_Delay_length_input: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'CFDACrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_input
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_random_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'CFDACrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length_random_input)
                'Debug.Print CFDACrawlerModule.Public_Delay_length_random_input
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K testCrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Delay_length)
            'Debug.Print CFDACrawlerModule.Public_Delay_length
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select


    '�Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
            If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "���b�ڞg�[�Ę��� ��": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
            End If

            Call testCrawlerModule.First_level_page_Extract_Page_Number(Public_Current_page_number, Public_First_level_page_number_source_xpath, Public_From_first_level_page_to_second_level_page_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function First_level_page_Extract_Page_Number()�������������xȡ퓴a��Ϣ�Ą�����
            'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("First_level_page_Extract_Page_Number")

            ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'End If

            'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
            If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "��ǰ퓴a��Ϣ�Ѹ���": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
            End If

            'Exit Sub

        Case Is = "CFDACrawlerModule"

            'Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, CFDACrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function First_level_page_Extract_Page_Number()�������������xȡ퓴a��Ϣ�Ą�����
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("First_level_page_KeyWord_Query")

            'Exit Sub

        Case Else

            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule ���x����."
            'Exit Sub

    End Select
    ''Debug.Print VBA.TypeName(Public_Current_page_number)
    'Debug.Print Public_Current_page_number
    'Debug.Print Public_Max_page_number
    'Debug.Print Public_Number_of_entrance_from_first_level_page_to_second_level_page

    'ˢ����퓴a����һ�Ӽ���棩ݔ���
    If Not (CrawlerControlPanel.Controls("Start_page_number_TextBox") Is Nothing) Then
        'CrawlerControlPanel.Controls("Start_page_number_TextBox").Value = CStr(Public_Current_page_number): Rem �o�ı�ݔ���ؼ��� .Value �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
        CrawlerControlPanel.Controls("Start_page_number_TextBox").Text = CStr(Public_Current_page_number): Rem �o�ı�ݔ���ؼ��� .Text �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
    End If

    'ˢ����퓴a���ڶ��Ӽ���棩ݔ���
    If Not (CrawlerControlPanel.Controls("Start_entry_number_TextBox") Is Nothing) Then
        'CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value = CStr(1): Rem �o�ı�ݔ���ؼ��� .Value �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
        CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text = CStr(1): Rem �o�ı�ݔ���ؼ��� .Text �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
    End If

    'ˢ�½Kֹ퓴a����һ�Ӽ���棩ݔ���
    If Not (CrawlerControlPanel.Controls("End_page_number_TextBox") Is Nothing) Then
        'CrawlerControlPanel.Controls("End_page_number_TextBox").Value = CStr(Public_Max_page_number): Rem �o�ı�ݔ���ؼ��� .Value �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
        CrawlerControlPanel.Controls("End_page_number_TextBox").Text = CStr(Public_Max_page_number): Rem �o�ı�ݔ���ؼ��� .Text �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
    End If

    'ˢ����ʾ�˺�����ǰ��һ�Ӽ�����а������M��ڶ��Ӽ��������Ԫ�صĔ�����
    If Not (CrawlerControlPanel.Controls("Max_entry_Label") Is Nothing) Then
        CrawlerControlPanel.Controls("Max_entry_Label").Caption = "(" & CStr(Public_Number_of_entrance_from_first_level_page_to_second_level_page) & ")": Rem �o�ı�ݔ���ؼ��� .Caption �����xֵ������ CStr() ��ʾǿ���D�Q���ַ�����
    End If


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    'CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

End Sub

Private Sub Start_or_Stop_Collect_Data_CommandButton_Click()
'������I�Γ����_ʼ����ֹ�ɼ����������o�¼�

    'Call UserForm_Initialize: Rem ���w��ʼ���x��ֵ
    Application.CutCopyMode = False: Rem �˳��r�����@ʾԃ�����Ƿ���ռ��N�匦Ԓ��
    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣


    '���İ��o��B�͘�־
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
    'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
            'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
        Case Is = "CFDACrawlerModule"
            'CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(CFDACrawlerModule)
            'Debug.Print VBA.TypeName(CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
            'Debug.Print CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select
    '�Д��Ƿ��������^�̲��^�m��������Ą���
    If PublicVariableStartORStopCollectDataButtonClickState Then

        ''ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
        'If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
        '    CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "�������^�̱���ֹ.": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
        'End If

        ''Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
        ''ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        'Select Case Public_Crawler_Strategy_module_name
        '    Case Is = "testCrawlerModule"
        '        testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
        '        'Debug.Print VBA.TypeName(testCrawlerModule)
        '        'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
        '        'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
        '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
        '        'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
        '    Case Is = "CFDACrawlerModule"
        '        'CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
        '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
        '        'Debug.Print VBA.TypeName(CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
        '        'Debug.Print CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
        '    Case Else
        '        MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
        '        'Exit Sub
        'End Select

        'ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
        If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
        End If

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

        Exit Sub

    End If


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.End_page_number_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_level_OptionButton1.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_level_OptionButton2.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = False: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��


    Dim i, j As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
    Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M


    'ˢ���Զ��x���ӕr�ȴ��r�L
    'Public_Delay_length_input = CLng(1500): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
    If Not (CrawlerControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
        Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_input = Public_Delay_length_input
                'testCrawlerModule.Public_Delay_length_input = CLng(CrawlerControlPanel.Controls("Delay_input_TextBox").Text): Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
    If Not (CrawlerControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
        Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_random_input ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃�������xֵ
                'testCrawlerModule.Public_Delay_length_random_input = CSng(CrawlerControlPanel.Controls("Delay_random_input_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length_random_input)
                'Debug.Print testCrawlerModule.Public_Delay_length_random_input
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If
    Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length ֵ��
    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name
        Case Is = "testCrawlerModule"
            testCrawlerModule.Public_Delay_length = Public_Delay_length: Rem �錧������x����ģ�K testCrawlerModule �а����ģ����^�S�C��֮����ӕr�ȴ��r�L���L���ͣ�׃�������xֵ
            'Debug.Print VBA.TypeName(testCrawlerModule)
            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Delay_length)
            'Debug.Print testCrawlerModule.Public_Delay_length
            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Delay_length = Public_Delay_length"
        Case Is = "CFDACrawlerModule"
        Case Else
            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
            'Exit Sub
    End Select

    '��춴惦�ɼ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://username:password@localhost:9001/?keyword=aaa")
    If Not (CrawlerControlPanel.Controls("Data_Server_Url_TextBox") Is Nothing) Then
        'Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����

        'Debug.Print "Data Server Url = " & "[ " & Public_Data_Server_Url & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Data_Server_Url ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Data_Server_Url = Public_Data_Server_Url: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���춴惦�ɼ��Y���Ĕ�����������Wַ���ַ���׃����׃�������xֵ
                'testCrawlerModule.Public_Data_Server_Url = CStr(CrawlerControlPanel.Controls("Data_Server_Url_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_Server_Url)
                'Debug.Print testCrawlerModule.Public_Data_Server_Url
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_Server_Url = Public_Data_Server_Url"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_Server_Url = Public_Data_Server_Url"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If

    '��춴惦�ɼ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Database_and_Excel"��"Excel" ֵ������ȡֵ��CStr("Excel")
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (CrawlerControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
        Public_Data_Receptors = ""
        '��v����а�������Ԫ�ء�
        Dim element_i
        For Each element_i In Data_Receptors_Frame.Controls
            '�Д��}�x��ؼ����x�Р�B
            If element_i.Value Then
                If Public_Data_Receptors = "" Then
                    Public_Data_Receptors = CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                Else
                    Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                End If
            End If
        Next
        Set element_i = Nothing
        'If (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
        'ElseIf (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
        '    Public_Data_Receptors = CStr(CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
        'ElseIf (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (CrawlerControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
        '    Public_Data_Receptors = ""
        'Else
        'End If

        'Debug.Print "Public_Data_Receptors = " & "[ " & Public_Data_Receptors & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Data_Receptors ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Data_Receptors = Public_Data_Receptors: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���춴惦�ɼ��Y������������}�x��ֵ���ַ���׃����׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_Receptors)
                'Debug.Print testCrawlerModule.Public_Data_Receptors
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_Receptors = Public_Data_Receptors"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_Receptors = Public_Data_Receptors"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If

    ''�����P�I�~�z�������r��������P�I�~���ַ���׃��
    'If Not (CrawlerControlPanel.Controls("Keyword_Query_TextBox") Is Nothing) Then
    '    'Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    'Debug.Print "Key Word = " & "[ " & Public_Key_Word & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Key_Word ֵ��
    '    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    '    Select Case Public_Crawler_Strategy_module_name
    '        Case Is = "testCrawlerModule"
    '            testCrawlerModule.Public_Key_Word = Public_Key_Word: Rem �錧������x����ģ�K testCrawlerModule �а����ģ������P�I�~�z�������r��������P�I�~���ַ���׃����׃�������xֵ
    '            'testCrawlerModule.Public_Key_Word = CStr(CrawlerControlPanel.Controls("Keyword_Query_TextBox").Text)
    '            'Debug.Print VBA.TypeName(testCrawlerModule)
    '            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Key_Word)
    '            'Debug.Print testCrawlerModule.Public_Data_Receptors
    '            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Key_Word = Public_Key_Word"
    '        Case Is = "CFDACrawlerModule"
    '        Case Else
    '            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    '            'Exit Sub
    '    End Select
    'End If

    '�_ʼ�ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃�������� CInt() ��ʾǿ���D�Q�������
    If Not (CrawlerControlPanel.Controls("Start_page_number_TextBox") Is Nothing) Then
        'If CStr(CrawlerControlPanel.Controls("Start_page_number_TextBox").Value) = "" Then
        '    Public_Start_page_number = CInt(0)
        'Else
        '    Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q�������
        'End If
        If CStr(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text) = "" Then
            Public_Start_page_number = CInt(0)
        Else
            Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q�������
        End If

        'Debug.Print "Start page number = " & "[ " & Public_Start_page_number & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Start_page_number ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Start_page_number = Public_Start_page_number: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��_ʼ�ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃����׃�������xֵ
                'testCrawlerModule.Public_Start_page_number = CInt(CrawlerControlPanel.Controls("Start_page_number_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Start_page_number)
                'Debug.Print testCrawlerModule.Public_Start_page_number
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Start_page_number = Public_Start_page_number"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Start_page_number = Public_Start_page_number"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If

    '�_ʼ�ɼ��ĵڶ��Ӽ��W퓵�퓴a̖��������׃�������� CInt() ��ʾǿ���D�Q�������
    If Not (CrawlerControlPanel.Controls("Start_entry_number_TextBox") Is Nothing) Then
        'If CStr(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value) = "" Then
        '    Public_Start_entry_number = CInt(0)
        'Else
        '    Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q�������
        'End If
        If CStr(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text) = "" Then
            Public_Start_entry_number = CInt(0)
        Else
            Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q�������
        End If

        'Debug.Print "Start entry number = " & "[ " & Public_Start_entry_number & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Start_entry_number ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Start_entry_number = Public_Start_entry_number: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��_ʼ�ɼ��ĵڶ��Ӽ��W퓵�퓴a̖��������׃����׃�������xֵ
                'testCrawlerModule.Public_Start_entry_number = CInt(CrawlerControlPanel.Controls("Start_entry_number_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Start_entry_number)
                'Debug.Print testCrawlerModule.Public_Start_entry_number
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Start_entry_number = Public_Start_entry_number"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Start_entry_number = Public_Start_entry_number"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If

    '�Y���ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃�������� CInt() ��ʾǿ���D�Q�������
    If Not (CrawlerControlPanel.Controls("End_page_number_TextBox") Is Nothing) Then
        'If CStr(CrawlerControlPanel.Controls("End_page_number_TextBox").Value) = "" Then
        '    Public_End_page_number = CInt(0)
        'Else
        '    Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q�������
        'End If
        If CStr(CrawlerControlPanel.Controls("End_page_number_TextBox").Text) = "" Then
            Public_End_page_number = CInt(0)
        Else
            Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q�������
        End If

        'Debug.Print "End page number = " & "[ " & Public_End_page_number & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_End_page_number ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_End_page_number = Public_End_page_number: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��Y���ɼ��ĵ�һ�Ӽ��W퓵�퓴a̖��������׃����׃�������xֵ
                'testCrawlerModule.Public_End_page_number = CInt(CrawlerControlPanel.Controls("End_page_number_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_End_page_number)
                'Debug.Print testCrawlerModule.Public_End_page_number
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_End_page_number = Public_End_page_number"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_End_page_number = Public_End_page_number"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If

    'Ŀ�˔���Դ�W퓌Ӽ��Y�����ַ�����׃����ȡ "1" ֵ��ʾֻ�ɼ���ǰ��еĔ�����ȡ "2" ��ʾ߀���Ԅ��M��ڶ��Ӽ�����xȡ���������� CStr() ��ʾ�D�Q���ַ�����ͣ�����ȡֵ��CStr(2)
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (CrawlerControlPanel.Controls("Data_level_Frame") Is Nothing) Then
        '��v����а�������Ԫ�ء�
        'Dim element_i
        For Each element_i In Data_level_Frame.Controls
            '�Д����x��ؼ����x�Р�B
            If element_i.Value Then
                Public_Data_level = CStr(element_i.Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                Exit For
            End If
        Next
        Set element_i = Nothing

        'Debug.Print "Data level = " & "[ " & Public_Data_level & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Data_level ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Data_level = Public_Data_level: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�Ŀ�˔���Դ�W퓌Ӽ��Y�����ַ�����׃����׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_level)
                'Debug.Print testCrawlerModule.Public_Data_level
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If


    '[A1] = URL1: Rem �@�l�Z����출yԇ���{ʽ�ꮅ��Ʉh����Ч������ Excel ��ǰ��ӹ������е� A1 ��Ԫ�����@ʾ׃�� URL1 ��ֵ��
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" �D�Q�����ڸ�ʽ�@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber �D�Q����ͨ�����@ʾ������ format �Ǹ�ʽ���ַ�������������Ҏ��ݔ���ַ����ĸ�ʽ

    'CrawlerControlPanel.Hide: Rem �[���Ñ����w


    ''ˢ��Ŀ�˔���Դ�Wվ���Զ��x��ӛ����ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox") Is Nothing) Then
    '    'Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
    '    Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    'End If
    ''Debug.Print "Custom name of data web = " & "[ " & Public_Custom_name_of_data_page & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Custom_name_of_data_page ֵ��
    '''ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    ''Select Case Public_Crawler_Strategy_module_name
    ''    Case Is = "testCrawlerModule"
    ''        testCrawlerModule.Public_Custom_name_of_data_page = Public_Custom_name_of_data_page: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�Ŀ�˔���Դ�Wվ���ľWֵַ�ַ�����׃�������xֵ
    ''        'testCrawlerModule.Public_Custom_name_of_data_page = CStr(CrawlerControlPanel.Controls("Custom_name_of_data_page_TextBox").Value)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Data_level)
    ''        'Debug.Print testCrawlerModule.Public_Data_level
    ''        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
    ''        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Data_level = Public_Data_level"
    ''    Case Is = "CFDACrawlerModule"
    ''    Case Else
    ''        MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    ''        'Exit Sub
    ''End Select

    ''ˢ��Ŀ�˔���Դ�Wվ���Wַ URL �ַ���ֵ
    'If Not (CrawlerControlPanel.Controls("URL_of_data_page_TextBox") Is Nothing) Then
    '    'Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
    '    Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    'End If
    ''Debug.Print "URL of data page = " & "[ " & Public_URL_of_data_page & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_URL_of_data_page ֵ��
    '''ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    ''Select Case Public_Crawler_Strategy_module_name
    ''    Case Is = "testCrawlerModule"
    ''        testCrawlerModule.Public_URL_of_data_page = Public_URL_of_data_page: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�Ŀ�˔���Դ�Wվ���ľWַ URL ֵ�ַ�����׃�������xֵ
    ''        'testCrawlerModule.Public_URL_of_data_page = CStr(CrawlerControlPanel.Controls("URL_of_data_page_TextBox").Value)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule)
    ''        'Debug.Print VBA.TypeName(testCrawlerModule.Public_URL_of_data_page)
    ''        'Debug.Print testCrawlerModule.Public_URL_of_data_page
    ''        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
    ''        'Application.Run Public_Crawler_Strategy_module_name & ".Public_URL_of_data_page = Public_URL_of_data_page"
    ''    Case Is = "CFDACrawlerModule"
    ''    Case Else
    ''        MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    ''        'Exit Sub
    ''End Select

    '��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page number source xpath = " & "[ " & Public_First_level_page_number_source_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_number_source_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_number_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
            Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
            'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
            'Public_First_level_page_number_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name"
                    testCrawlerModule.Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_number_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_position_index = Public_First_level_page_number_source_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page data source xpath = " & "[ " & Public_First_level_page_data_source_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_data_source_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_data_source_xpath = Public_First_level_page_number_source_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_data_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_number_source_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_number_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_number_source_xpath = Public_First_level_page_number_source_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
            Public_First_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_data_source_xpath, delimiter:="-")
            'Public_First_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
            'Public_First_level_page_data_source_tag_name = "": Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_data_source_tag_name & ", " & Public_First_level_page_data_source_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_data_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_data_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_tag_name = Public_First_level_page_data_source_tag_name"
                    testCrawlerModule.Public_First_level_page_data_source_position_index = Public_First_level_page_data_source_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_data_source_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_data_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_position_index = Public_First_level_page_data_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_data_source_position_index = Public_First_level_page_data_source_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ���P�I�~�z����ݔ���� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page KeyWord query textbox xpath = " & "[ " & Public_First_level_page_KeyWord_query_textbox_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_KeyWord_query_textbox_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z����ݔ���� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_xpath = Public_First_level_page_KeyWord_query_textbox_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
            Public_First_level_page_KeyWord_query_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_textbox_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z����ݔ����λ����������ֵ
            'Public_First_level_page_KeyWord_query_textbox_tag_name = "": Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_textbox_tag_name & ", " & Public_First_level_page_KeyWord_query_textbox_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z����ݔ���Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_tag_name = Public_First_level_page_KeyWord_query_textbox_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z����ݔ����λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_textbox_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_textbox_position_index = Public_First_level_page_KeyWord_query_textbox_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ���P�I�~�z�������o�� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page KeyWord query button xpath = " & "[ " & Public_First_level_page_KeyWord_query_button_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_KeyWord_query_button_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z�������o�� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_key_word_query_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_xpath = Public_First_level_page_KeyWord_query_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
            Public_First_level_page_KeyWord_query_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_KeyWord_query_button_xpath, delimiter:="-")
            'Public_First_level_page_KeyWord_query_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ���P�I�~�z�������o��λ����������ֵ
            'Public_First_level_page_KeyWord_query_button_tag_name = "": Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ���P�I�~�z�������o�Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_KeyWord_query_button_tag_name & ", " & Public_First_level_page_KeyWord_query_button_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z�������o�Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_tag_name = Public_First_level_page_KeyWord_query_button_tag_name"
                    testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ���P�I�~�z�������o��λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_KeyWord_query_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_KeyWord_query_button_position_index = Public_First_level_page_KeyWord_query_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����퓡�ݔ���� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page skip textbox xpath = " & "[ " & Public_First_level_page_skip_textbox_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_skip_textbox_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_skip_textbox_xpath = Public_First_level_page_skip_textbox_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����퓡�ݔ���� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_skip_textbox_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_textbox_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_textbox_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_skip_textbox_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_xpath = Public_First_level_page_skip_textbox_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_xpath = Public_First_level_page_skip_textbox_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����퓡�ݔ���Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡�ݔ����λ����������ֵ
            Public_First_level_page_skip_textbox_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_skip_textbox_xpath, delimiter:="-")
            'Public_First_level_page_skip_textbox_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡�ݔ����λ����������ֵ
            'Public_First_level_page_skip_textbox_tag_name = "": Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & CStr(tempArr(i)): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����퓡�ݔ���Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_skip_textbox_tag_name & ", " & Public_First_level_page_skip_textbox_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����퓡�ݔ���Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_textbox_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_textbox_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_tag_name = Public_First_level_page_skip_textbox_tag_name"
                    testCrawlerModule.Public_First_level_page_skip_textbox_position_index = Public_First_level_page_skip_textbox_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����퓡�ݔ����λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_textbox_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_textbox_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_position_index = Public_First_level_page_skip_textbox_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_textbox_position_index = Public_First_level_page_skip_textbox_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����퓡����o�� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page skip button xpath = " & "[ " & Public_First_level_page_skip_button_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_skip_button_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_skip_button_xpath = Public_First_level_page_skip_button_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����퓡����o�� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_skip_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_skip_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_skip_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_xpath = Public_First_level_page_skip_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_xpath = Public_First_level_page_skip_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡����o��λ����������ֵ
            Public_First_level_page_skip_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_skip_button_xpath, delimiter:="-")
            'Public_First_level_page_skip_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����퓡����o��λ����������ֵ
            'Public_First_level_page_skip_button_tag_name = "": Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & CStr(tempArr(i)): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����퓡����o�Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_skip_button_tag_name & ", " & Public_First_level_page_skip_button_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����퓡����o�Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_tag_name = Public_First_level_page_skip_button_tag_name"
                    testCrawlerModule.Public_First_level_page_skip_button_position_index = Public_First_level_page_skip_button_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����퓡����o��λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_skip_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_skip_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_position_index = Public_First_level_page_skip_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_skip_button_position_index = Public_First_level_page_skip_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����һ퓡����o�� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page next button xpath = " & "[ " & Public_First_level_page_next_button_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_next_button_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_next_button_xpath = Public_First_level_page_next_button_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����һ퓡����o�� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_next_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_next_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_next_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_next_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_xpath = Public_First_level_page_next_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_xpath = Public_First_level_page_next_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����һ퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
            tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
            Public_First_level_page_next_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_next_button_xpath, delimiter:="-")
            'Public_First_level_page_next_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
            'Public_First_level_page_next_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_next_button_tag_name & ", " & Public_First_level_page_next_button_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����һ퓡����o�Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_next_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_next_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_tag_name = Public_First_level_page_next_button_tag_name"
                    testCrawlerModule.Public_First_level_page_next_button_position_index = Public_First_level_page_next_button_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����һ퓡����o��λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_next_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_next_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_position_index = Public_First_level_page_next_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_next_button_position_index = Public_First_level_page_next_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����һ퓡����o�� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox") Is Nothing) Then
        'Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "First level page back button xpath = " & "[ " & Public_First_level_page_back_button_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_First_level_page_back_button_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_First_level_page_back_button_xpath = Public_First_level_page_back_button_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����һ퓡����o�� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_First_level_page_back_button_xpath = CStr(CrawlerControlPanel.Controls("First_level_page_back_button_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_back_button_xpath)
                'Debug.Print testCrawlerModule.Public_First_level_page_back_button_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_xpath = Public_First_level_page_back_button_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_xpath = Public_First_level_page_back_button_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����һ퓡����o�Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
            Public_First_level_page_back_button_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_First_level_page_back_button_xpath, delimiter:="-")
            'Public_First_level_page_back_button_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����һ퓡����o��λ����������ֵ
            'Public_First_level_page_back_button_tag_name = "": Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            '    Else
            '        Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����һ퓡����o�Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_First_level_page_back_button_tag_name & ", " & Public_First_level_page_back_button_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����һ퓡����o�Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_back_button_tag_name)
                    'Debug.Print testCrawlerModule.Public_First_level_page_back_button_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_tag_name = Public_First_level_page_back_button_tag_name"
                    testCrawlerModule.Public_First_level_page_back_button_position_index = Public_First_level_page_back_button_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����һ퓡����o��λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_First_level_page_back_button_position_index)
                    'Debug.Print testCrawlerModule.Public_First_level_page_back_button_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_position_index = Public_First_level_page_back_button_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_First_level_page_back_button_position_index = Public_First_level_page_back_button_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox") Is Nothing) Then
        'Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "From first level page to second level page xpath = " & "[ " & Public_From_first_level_page_to_second_level_page_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_From_first_level_page_to_second_level_page_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_first_level_page_to_second_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath)
                'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_xpath = Public_From_first_level_page_to_second_level_page_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
            Public_From_first_level_page_to_second_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_From_first_level_page_to_second_level_page_xpath, delimiter:="-")
            'Public_From_first_level_page_to_second_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ
            'Public_From_first_level_page_to_second_level_page_tag_name = "": Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_From_first_level_page_to_second_level_page_tag_name & ", " & Public_From_first_level_page_to_second_level_page_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_tag_name = Public_From_first_level_page_to_second_level_page_tag_name"
                    testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ��һ�Ӽ�������M�댦���ĵڶ��Ӽ��������Ԫ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index)
                    'Debug.Print testCrawlerModule.Public_From_first_level_page_to_second_level_page_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_first_level_page_to_second_level_page_position_index = Public_From_first_level_page_to_second_level_page_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    ''��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ���
    'If Not (CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox") Is Nothing) Then
    '    'Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
    '    'Debug.Print "Second level page number source xpath = " & "[ " & Public_Second_level_page_number_source_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Second_level_page_number_source_xpath ֵ��
    '    'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    '    Select Case Public_Crawler_Strategy_module_name
    '        Case Is = "testCrawlerModule"
    '            testCrawlerModule.Public_Second_level_page_number_source_xpath = Public_Second_level_page_number_source_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��� XPath ֵ�ַ�����׃�������xֵ
    '            'testCrawlerModule.Public_Second_level_page_number_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_number_source_xpath_TextBox").Text)
    '            'Debug.Print VBA.TypeName(testCrawlerModule)
    '            'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_number_source_xpath)
    '            'Debug.Print testCrawlerModule.Public_Second_level_page_number_source_xpath
    '            'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_xpath = Public_Second_level_page_number_source_xpath"
    '            'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_xpath = Public_Second_level_page_number_source_xpath"
    '        Case Is = "CFDACrawlerModule"
    '        Case Else
    '            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    '            'Exit Sub
    '    End Select

    '    If Public_Browser_Name = "InternetExplorer" Then
    '        '��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
    '        ReDim tempArr(0): Rem ��Ք��M
    '        tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '        Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    '        Public_Second_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '        'tempArr = VBA.Split(Public_Second_level_page_number_source_xpath, delimiter:="-")
    '        'Public_Second_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ
    '        'Public_Second_level_page_number_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '        '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '        '    Else
    '        '        Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ���
    '        '    End If
    '        'Next
    '        'Debug.Print Public_Second_level_page_number_source_tag_name & ", " & Public_Second_level_page_number_source_position_index
    '        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    '        Select Case Public_Crawler_Strategy_module_name
    '            Case Is = "testCrawlerModule"
    '                testCrawlerModule.Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
    '                'Debug.Print VBA.TypeName(testCrawlerModule)
    '                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_number_source_tag_name)
    '                'Debug.Print testCrawlerModule.Public_Second_level_page_number_source_tag_name
    '                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name"
    '                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_tag_name = Public_Second_level_page_number_source_tag_name"
    '                testCrawlerModule.Public_Second_level_page_number_source_position_index = Public_Second_level_page_number_source_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ������퓴a��ϢԴԪ�ء���λ����������ֵ��׃�������xֵ
    '                'Debug.Print VBA.TypeName(testCrawlerModule)
    '                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_number_source_position_index)
    '                'Debug.Print testCrawlerModule.Public_Second_level_page_number_source_position_index
    '                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_position_index = Public_Second_level_page_number_source_position_index"
    '                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_number_source_position_index = Public_Second_level_page_number_source_position_index"
    '            Case Is = "CFDACrawlerModule"
    '            Case Else
    '                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    '                'Exit Sub
    '        End Select
    '    End If
    'End If

    '��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox") Is Nothing) Then
        'Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "Second level page data source xpath = " & "[ " & Public_Second_level_page_data_source_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Second_level_page_data_source_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_Second_level_page_data_source_xpath = Public_Second_level_page_data_source_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_Second_level_page_data_source_xpath = CStr(CrawlerControlPanel.Controls("Second_level_page_data_source_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_data_source_xpath)
                'Debug.Print testCrawlerModule.Public_Second_level_page_data_source_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_xpath = Public_Second_level_page_data_source_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_xpath = Public_Second_level_page_data_source_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
            Public_Second_level_page_data_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_Second_level_page_data_source_xpath, delimiter:="-")
            'Public_Second_level_page_data_source_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ
            'Public_Second_level_page_data_source_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_Second_level_page_data_source_tag_name & ", " & Public_Second_level_page_data_source_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_data_source_tag_name)
                    'Debug.Print testCrawlerModule.Public_Second_level_page_data_source_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_tag_name = Public_Second_level_page_data_source_tag_name"
                    testCrawlerModule.Public_Second_level_page_data_source_position_index = Public_Second_level_page_data_source_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ������Ŀ�˔���ԴԪ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_Second_level_page_data_source_position_index)
                    'Debug.Print testCrawlerModule.Public_Second_level_page_data_source_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_position_index = Public_Second_level_page_data_source_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_Second_level_page_data_source_position_index = Public_Second_level_page_data_source_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If

    '��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��� XPath ֵ�ַ���
    If Not (CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox") Is Nothing) Then
        'Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ����͡����� CStr() ��ʾǿ���D�Q���ַ�����
        'Debug.Print "From second level page return first level page xpath = " & "[ " & Public_From_second_level_page_return_first_level_page_xpath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_From_second_level_page_return_first_level_page_xpath ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath = Public_From_second_level_page_return_first_level_page_xpath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��� XPath ֵ�ַ�����׃�������xֵ
                'testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath = CStr(CrawlerControlPanel.Controls("From_second_level_page_return_first_level_page_xpath_TextBox").Text)
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath)
                'Debug.Print testCrawlerModule.Public_From_second_level_page_return_first_level_page_xpath
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_xpath = Public_From_second_level_page_return_first_level_page_xpath"
                'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_xpath = Public_From_second_level_page_return_first_level_page_xpath"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        If Public_Browser_Name = "InternetExplorer" Then
            '��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����λ����������ֵ
            ReDim tempArr(0): Rem ��Ք��M
            tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-", limit:=2, Compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ
            Public_From_second_level_page_return_first_level_page_tag_name = CStr(tempArr(UBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            'tempArr = VBA.Split(Public_From_second_level_page_return_first_level_page_xpath, delimiter:="-")
            'Public_From_second_level_page_return_first_level_page_position_index = CInt(tempArr(LBound(tempArr))): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ
            'Public_From_second_level_page_return_first_level_page_tag_name = "": Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            '    Else
            '        Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name & "-" & CStr(tempArr(i)): Rem ��λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ���
            '    End If
            'Next
            'Debug.Print Public_From_second_level_page_return_first_level_page_tag_name & ", " & Public_From_second_level_page_return_first_level_page_position_index
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء��Ę˺����Qֵ�ַ�����׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_second_level_page_return_first_level_page_tag_name)
                    'Debug.Print testCrawlerModule.Public_From_second_level_page_return_first_level_page_tag_name
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_tag_name = Public_From_second_level_page_return_first_level_page_tag_name"
                    testCrawlerModule.Public_From_second_level_page_return_first_level_page_position_index = Public_From_second_level_page_return_first_level_page_position_index: Rem �錧������x����ģ�K testCrawlerModule �а����ģ���λ����ǰ�ڶ��Ӽ�����з��،����ĵ�һ�Ӽ��������Ԫ�ء���λ����������ֵ��׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.Public_From_second_level_page_return_first_level_page_position_index)
                    'Debug.Print testCrawlerModule.Public_From_second_level_page_return_first_level_page_position_index
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_position_index = Public_From_second_level_page_return_first_level_page_position_index"
                    'Application.Run Public_Crawler_Strategy_module_name & ".Public_From_second_level_page_return_first_level_page_position_index = Public_From_second_level_page_return_first_level_page_position_index"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select
        End If
    End If


    ''ˢ�´�����Ŀ�˔���Դ���� JavaScript �ű��ַ���
    'If Not (CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    '    'Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value)
    '    Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    '    'Debug.Print Public_Inject_data_page_JavaScript_filePath
    'End If
    'If Public_Inject_data_page_JavaScript_filePath <> "" Then

    '    '�Д��Զ��x�Ĵ�����Ŀ�˔���Դ���� JavaScript �ű��ęn�Ƿ����
    '    Dim fso As Object, sFile As Object
    '    Set fso = CreateObject("Scripting.FileSystemObject")

    '    If fso.Fileexists(Public_Inject_data_page_JavaScript_filePath) Then

    '        'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

    '        'ʹ�� OpenTextFile �������_һ��ָ�����ęn�K����һ�� TextStream ����ԓ������Ԍ��ęn�M���x������׷�ӌ������
    '        '�����Z����object.OpenTextFile(filename[,iomode[,create[,format]]])
    '        '���� filename ��Ŀ���ęn��·��ȫ���ַ���
    '        '���� iomode ��ʾݔ���ݔ����ʽ�����Ԟ�ɂ�����֮һ��ForReading��ForAppending
    '        '���� Create ��ʾ���ָ���� filename �����ڕr���Ƿ��������һ�����ęn���� Boolean ֵ���􄓽����ęnȡ True ֵ���������tȡ False ֵ���A�O�� False ֵ
    '        '���� Format �����N Tristate ֵ֮һ���A�O���� ASCII ��ʽ���_�ęn

    '        '�O�ô��_�ęn��������
    '        Const ForReading = 1: Rem ���_һ��ֻ�x�ęn�����܌��ęn�M�Ќ�����
    '        Const ForWriting = 2: Rem ���_һ�����x�Ɍ��������ęn��ע�⣬����Մh���ęn��ԭ�е�����
    '        Const ForAppending = 8: Rem ���_һ���Ɍ��������ęn���K��ָ��Ƅӵ��ęn��ĩβ���������ęnβ��׷�ӌ�������������h���ęn��ԭ�е�����
    '        Const TristateUseDefault = -2: Rem ʹ��ϵ�yȱʡ�ľ��a��ʽ���_�ęn
    '        Const TristateTrue = -1: Rem �� Unicode ���a�ķ�ʽ���_�ęn
    '        Const TristateFalse = 0: Rem �� ASCII ���a�ķ�ʽ���_�ęn��ע�⣬�h�֕��y�a

    '        '��ֻ�x��ʽ���_�ęn
    '        Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

    '        ''�Д���������ęn�ı���β�ˣ��t���m�xȡ����ƴ��
    '        'Public_Inject_data_page_JavaScript = ""
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem �Ĵ��_���ęn���xȡһ���ַ���ƴ�ӣ��K���ַ����Yβ����һ����܇��̖
    '        '    'Debug.Print sFile.ReadLine: Rem �xȡһ�У���������β�ēQ�з�
    '        'Loop
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem �Ĵ��_���ęn���xȡһ���ַ�ƴ��
    '        '    'Debug.Print sFile.Read(1): Rem �xȡһ���ַ�
    '        'Loop

    '        Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem �xȡ�ęn�е�ȫ������
    '        'Debug.Print sFile.ReadAll
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem �� Unicode ���a���ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        sFile.Close

    '    Else

    '        Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
    '        'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

    '    End If

    '    Set sFile = Nothing
    '    Set fso = Nothing

    'End If
    ''Debug.Print "Inject data page JavaScript filePath = " & "[ " & Public_Inject_data_page_JavaScript_filePath & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Inject_data_page_JavaScript_filePath ֵ��
    ''Debug.Print "Inject data page JavaScript = " & "[ " & Public_Inject_data_page_JavaScript & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Inject_data_page_JavaScript ֵ��
    ''ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    'Select Case Public_Crawler_Strategy_module_name
    '    Case Is = "testCrawlerModule"
    '        testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű�·��ȫ����׃�������xֵ
    '        'testCrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript_filePath)
    '        'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript_filePath
    '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
    '        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
    '        testCrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem �錧������x����ģ�K testCrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű��ַ�����׃�������xֵ
    '        ''testCrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(testCrawlerModule)
    '        'Debug.Print VBA.TypeName(testCrawlerModule.Public_Inject_data_page_JavaScript)
    '        'Debug.Print testCrawlerModule.Public_Inject_data_page_JavaScript
    '        'Application.Evaluate Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
    '        'Application.Run Public_Crawler_Strategy_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
    '    Case Is = "CFDACrawlerModule"
    '        'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ����׃�������xֵ
    '        'CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath)
    '        'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript_filePath
    '        'CFDACrawlerModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ�������Ŀ�˔���Դ���� JavaScript �ű��ַ�����׃�������xֵ
    '        ''CFDACrawlerModule.Public_Inject_data_page_JavaScript = CStr(CrawlerControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule)
    '        'Debug.Print VBA.TypeName(CFDACrawlerModule.Public_Inject_data_page_JavaScript)
    '        'Debug.Print CFDACrawlerModule.Public_Inject_data_page_JavaScript
    '    Case Else
    '        MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
    '        'Exit Sub
    'End Select


    '�Д�����Ē���ʼ퓴a̖�Ƿ��Ҏ
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
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

        MsgBox "���녢���e�`������ʼ퓴a������Ч������Start_page_number=" & CStr(Public_Start_page_number) & " > 32767��������ʼ퓴a������춶�����׃�������ֵ(32767)."

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
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

        MsgBox "���녢���e�`������ʼ퓴aֵС�һ��Start_page_number=" & CStr(Public_Start_page_number) & " < 1��."

        Exit Sub

    End If

    '�Д�����Ē񼯽Kֹ퓴a̖�Ƿ��Ҏ
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
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

        MsgBox "���녢���e�`���񼯽Kֹ퓴a������Ч������End_page_number=" & CStr(Public_End_page_number) & " > 32767�����񼯽Kֹ퓴a������춶�����׃�������ֵ(32767)."

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
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

        MsgBox "���녢���e�`���񼯽Kֹ퓴aֵ������S���d�����W퓴a��End_page_number=" & CStr(Public_End_page_number) & " > Max_page_number=" & CStr(Public_Max_page_number) & "��."

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
        'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select

        CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
        CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

        MsgBox "���녢���e�`������ʼ퓴a��춽Kֹ퓴a��Start_page_number=" & CStr(Public_Start_page_number) & " > End_page_number=" & CStr(Public_End_page_number) & "��."

        Exit Sub

    End If


    '�Д�Ŀ�˔���Դ���Ӽ��Y��
    If Public_Data_level = "2" Then

        '�Д�����Į�ǰ��һ�Ӽ�����еĵڶ��Ӽ�������ʼ��̖�Ƿ��Ҏ
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
            'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                    'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                    'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

            CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

            MsgBox "���녢���e�`����ǰ��һ�Ӽ�����еĵڶ��Ӽ�������ʼ��ֵ̖������Ч������Start_entry_number=" & CStr(Public_Start_entry_number) & " > 32767������ǰ��һ�Ӽ�����еĵڶ��Ӽ�������ʼ��ֵ̖������춶�����׃�������ֵ(32767)."

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
            'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                    'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                    'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

            CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

            MsgBox "���녢���e�`������Į�ǰ��һ�Ӽ�����еĵڶ��Ӽ�������ʼ��ֵ̖С�һ��Start_entry_number=" & CStr(Public_Start_entry_number) & " < 1��."

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
            'Debug.Print "Start or Stop Collect Data Button Click State = " & "[ " & PublicVariableStartORStopCollectDataButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopCollectDataButtonClickState ֵ��
            'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
            Select Case Public_Crawler_Strategy_module_name
                Case Is = "testCrawlerModule"
                    testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                    'Debug.Print VBA.TypeName(testCrawlerModule)
                    'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                    'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                    'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                    'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                Case Is = "CFDACrawlerModule"
                Case Else
                    MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                    'Exit Sub
            End Select

            CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
            CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

            MsgBox "���녢���e�`������Į�ǰ��һ�Ӽ�����еĵڶ��Ӽ�������ʼ��ֵ̖��춮�ǰ��һ�Ӽ�����а����ĵڶ��Ӽ������ڔ�Ŀ��Start_entry_number=" & CStr(Public_Start_entry_number) & " > Max_entry_number=" & CStr(Public_Number_of_entrance_from_first_level_page_to_second_level_page) & "��."

            Exit Sub

        End If

    End If


    '�Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
    Select Case Public_Crawler_Strategy_module_name

        Case Is = "testCrawlerModule"

            'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
            If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
                CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "���Ӓ񼯔���.": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
            End If

            Call testCrawlerModule.Start_or_Stop_Collect_Data(Public_Data_Receptors, Public_Data_Server_Url, Public_Start_page_number, Public_End_page_number, Public_Start_entry_number, Public_Data_level, Public_Current_page_number, Public_First_level_page_number_source_xpath, Public_First_level_page_skip_textbox_xpath, Public_First_level_page_skip_button_xpath, Public_First_level_page_data_source_xpath, Public_First_level_page_next_button_xpath, Public_First_level_page_back_button_xpath, Public_From_first_level_page_to_second_level_page_xpath, Public_Second_level_page_data_source_xpath, Public_From_second_level_page_return_first_level_page_xpath, testCrawlerModule.Public_Browser_page_window_object, Public_Browser_Name)
            'ThisWorkbook.VBProject.VBComponents("testCrawlerModule").Controls("Start_or_Stop_Collect_Data")

            ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'If Not (CrawlerControlPanel.Controls("delay") Is Nothing) Then
            '    Call CrawlerControlPanel.delay(CrawlerControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'End If

            ''ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
            'If Not (CrawlerControlPanel.Controls("Web_page_load_status_Label") Is Nothing) Then
            '    CrawlerControlPanel.Controls("Web_page_load_status_Label").Caption = "�������ꮅ.": Rem ��ʾ�W��d���B���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w CrawlerControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰CrawlerControlPanel.Controls("Web_page_load_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
            'End If

            'Exit Sub

        Case Is = "CFDACrawlerModule"

            'Call testCrawlerModule.First_level_page_KeyWord_Query(Public_Key_Word, Public_First_level_page_KeyWord_query_textbox_xpath, Public_First_level_page_KeyWord_query_button_xpath, CFDACrawlerModule.Public_Browser_page_window_object, Public_Browser_Name): Rem �{���\�Ќ�������x����ģ�K�а����ġ�Function First_level_page_Extract_Page_Number()�������������xȡ퓴a��Ϣ�Ą�����
            ''ThisWorkbook.VBProject.VBComponents("CFDACrawlerModule").Controls("First_level_page_KeyWord_Query")

            'Exit Sub

        Case Else

            MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule ���x����."
            'Exit Sub

    End Select
    ''Debug.Print VBA.TypeName(Public_Current_page_number)
    'Debug.Print Public_Current_page_number
    'Debug.Print Public_Max_page_number
    'Debug.Print Public_Number_of_entrance_from_first_level_page_to_second_level_page


    '���İ��o��B�͘�־
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
        'ˢ���d������x����ģ�K�е�׃��ֵ���Д�ʹ�õ����xģ�K���Q������ȡֵ��("testCrawlerModule", "CFDACrawlerModule")
        Select Case Public_Crawler_Strategy_module_name
            Case Is = "testCrawlerModule"
                testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K testCrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(testCrawlerModule)
                'Debug.Print VBA.TypeName(testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print testCrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
                'Application.Evaluate Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
                'Application.Run Public_Crawler_Strategy_module_name & ".PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState"
            Case Is = "CFDACrawlerModule"
                'CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState = PublicVariableStartORStopCollectDataButtonClickState: Rem �錧������x����ģ�K CFDACrawlerModule �а����ģ��O�y���w�Д����񼯰�ť�ؼ����c����B�������ͣ�׃�������xֵ
                'Debug.Print VBA.TypeName(CFDACrawlerModule)
                'Debug.Print VBA.TypeName(CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState)
                'Debug.Print CFDACrawlerModule.PublicVariableStartORStopCollectDataButtonClickState
            Case Else
                MsgBox "ݔ����Զ��x���x����ģ�K���Q�e�`���o���R�e��������Q��Crawler Strategy module name = " & CStr(Public_Crawler_Strategy_module_name) & "����Ŀǰֻ�u����� testCrawlerModule��CFDACrawlerModule��... ���x����."
                'Exit Sub
        End Select
    End If


    CrawlerControlPanel.Load_data_source_page_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Load_data_source_page_CommandButton���d��Ŀ�˔���Դ�W퓰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Custom_name_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Custom_name_of_data_page_TextBox��Ŀ�˔���Դ�W��Զ��x�������Rݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.URL_of_data_page_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� URL_of_data_page_TextBox��Ŀ�˔���Դ�Wվ�Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Inject_data_page_JavaScript_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Inject_data_page_JavaScript_TextBox��������Ŀ�˔���Դ�W퓵� JavaScript ���a�ű�ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Keyword_Query_CommandButton���P�I�~�z�����o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Keyword_Query_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Keyword_Query_TextBox���z���P�I�~ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_textbox_xpath_TextBox����һ�Ӽ�����еęz���P�I�~�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_key_word_query_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_key_word_query_button_xpath_TextBox����һ�Ӽ�����е��P�I�~�z�����oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Extract_Page_Number_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Extract_Page_Number_CommandButton���@ȡ퓴a��Ϣ���o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_page_number_TextBox���_ʼ퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Start_entry_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Start_entry_number_TextBox����ǰ��һ�Ӽ�����еĵڶ��Ӽ��������_ʼ��̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.End_page_number_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� End_page_number_TextBox���Y��퓴a̖ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_number_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_number_source_xpath_TextBox����һ�Ӽ�����е�퓴a��ϢԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.From_first_level_page_to_second_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_first_level_page_to_second_level_page_xpath_TextBox����һ�Ӽ�����еďĮ�ǰ��һ�Ӽ�����M��ڶ��Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    'CrawlerControlPanel.Start_or_Stop_Collect_Data_CommandButton.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Start_Collect_Data_CommandButton�����Ӓ񼯰��o����False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Data_Server_Url_TextBox���ɼ��Y���惦������Wַݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox1���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��}�x��ؼ� Data_Receptors_CheckBox2���ɼ��Y����������}�x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_level_OptionButton1.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еĆ��x��ؼ� Data_level_OptionButton1���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Data_level_OptionButton2.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �еİ��o�ؼ� Data_level_OptionButton2���W퓔����ČӴνY�����R���x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_data_source_xpath_TextBox����һ�Ӽ�����е�Ŀ�˔���ԴԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_skip_textbox_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_textbox_xpath_TextBox����һ�Ӽ�����е����Ŀ��퓴a�ı�ݔ���Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_skip_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_skip_button_xpath_TextBox����һ�Ӽ�����е���퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_next_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_next_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.First_level_page_back_button_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� First_level_page_back_button_xpath_TextBox����һ�Ӽ�����е���һ퓰��oԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.Second_level_page_data_source_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� Second_level_page_data_source_xpath_TextBox���ڶ��Ӽ�����е�Ŀ�˔���ԴԪ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    CrawlerControlPanel.From_second_level_page_return_first_level_page_xpath_TextBox.Enabled = True: Rem ���ò�����崰�w CrawlerControlPanel �е��ı�ݔ���ؼ� From_second_level_page_return_first_level_page_xpath_TextBox���ڶ��Ӽ�����еďĮ�ǰ�ڶ��Ӽ���淵����������һ�Ӽ��������Ԫ�ص� XPath ֵݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��

End Sub





'**************************************************************************************************************************************************************************************************************************************


'vb webbrowser ��ԭ���ڴ򿪵����´��ڵ�����
'ԭ�� 2012��12��05�� 19:51:56
'
'����1:
'
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Dim frm As Form1
'Set frm = New Form1
'frm.Visible = True
'Set ppDisp = frm.WebBrowser1.Object
'End Sub
'
'����2:
'
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Cancel = True
'WebBrowser1.Navigate2 WebBrowser1.Document.activeElement.href
'End Sub
'
'����3:
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
'����4: ����������
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



'VB����webbrowser��ز�����ȫ
'����:2011-2-17
'
'1�� WebBrowser�ķ��������ԡ��¼�    2
'2�� ��ȡ��ҳԴ��    3
'3�� ��ֹ�´�����ͷ����ҳ  4
'4�� ��Webbrowser�ؼ�������    5
'5�� ȥ��������  5
'6�� ��ֹ����Ҽ�    6
'7�� ��λ����ҳ������  6
'8�� ���ܿ��ҳ�����  7
'9�� ����������Ϣ  7
'10��    ����Webbrowser��Ϣ����  8
'11��    ��Webbrowser��д��HTML���ݵļ��ַ���    8
'12��    ����ҳ�����    9
'13��    �ж�ҳ���Ƿ����ǰ������    9
'14��    ��λ����ҳ�б�ѡ�в��ֵ�HTML  10
'15��    Navigate�Ĳ�������  11
'16��    �����ļ��ղؼв���  11
'17��    ��Webbrowserȫ��    12
'18��    ѡ����ҳ�ϵ�����    12
'19��    ��IE�������ļ�  13
'20��    Webbrowserȷ�����ڶԻ���    14
'21��    ��ֹWebBrowser�ؼ�����ҳ����    14
'22��    ȡ��Դ������������д���    15
'23��    ҳ��Ԫ�ز���    15
'��0: �鿴��ҳԪ�� 15
'��1: ��username�ı������������:    15
'��2: �ҵ��ύ��ť����� 16
'��3: �Ѷȵ� 16
'��4: ģ��������������ť 17
'��5: ����IDֱ��CLICK 17
'��6: ���б�ѡ�ֵ 17
'��7: ��ҳ�Զ���д��ע�� 18
'24��    ��ҳ��ť���ռ�����  20
'22 ?ִ����ҳ�еĽű� 21
'23����ȡ�ַ�������ҳԴ������ָ������Դ����������һ���������²ɼ�����    23
'24 ?���ĺ���ת��ΪURL���� 25
'25 ?��ȡ��ҳ�е���֤�� 27
'26 ?WebBrowser�ؼ�����ҳ��ť�ĵ�� 28
'27 ?���� 28
'
'
'
'1 ? WebBrowser�ķ���?����?�¼�
'
'WebBrowser��8��������13�����ԣ��Լ����ǵĹ��ܣ�
'
'���� ˵��
'��GoBack �൱��IE��"����"��ť��ʹ���ڵ�ǰ��ʷ�б��к���һ��
'
'��GoForward �൱��IE��"ǰ��"��ť��ʹ���ڵ�ǰ��ʷ�б���ǰ��һ��
'��GoHome �൱��IE��"��ҳ"��ť�������û�Ĭ�ϵ���ҳ
'��GoSearch �൱��IE��"����"��ť�������û�Ĭ�ϵ�����ҳ��
'  Navigate ���ӵ�ָ����URL
'  Refresh ˢ�µ�ǰҳ��
'��Refresh2 ͬ�ϣ�ֻ�ǿ���ָ��ˢ�¼�����ָ����ˢ�¼����ֵ����RefreshConstantsö�ٱ�
'�ñ�����ExDisp.h�У�����ָ���Ĳ�ֵͬ���£�
'REFRESH_NORMAL ִ�м򵥵�ˢ�£�����HTTP pragma: no-cacheͷ���͸�������
'REFRESH_IFEXPIRED ֻ������ҳ���ں�Ž��м򵥵�ˢ��
'REFRESH_CONTINUE �����ڲ�ʹ�á���MSDN��д��DO NOT USE! ����ʹ��
'REFRESH_COMPLETELY ������pragma: no -cacheͷ�������͵�������
'
'��Stop �൱��IE��"ֹͣ"��ť��ֹͣ��ǰҳ�漰�����ݵ�����
'
'���� ˵��
'��Application ����ö�����Ч���򷵻��ƹ�WebBrowser�ؼ���Ӧ�ó���ʵ�ֵ��Զ�������(IDispatch)������������������Զ���������Ч��������򽫷���WebBrowser
'�ؼ����Զ�������
'��Parent ����WebBrowser�ؼ��ĸ��Զ�������ͨ����һ��������������������IE����
'  Container ����WebBrowser�ؼ��������Զ�������?ͨ����ֵ��Parent���Է��ص�ֵ��ͬ
'��Document Ϊ����ĵ������Զ����������HTML��ǰ������ʾ��WebBrowser�У���
'Document�����ṩ��DHTML Object Model�ķ���;��
'��TopLevelContainer ����һ��Booleanֵ������IE�Ƿ���WebBrowser�ؼ������������Ǿͷ���true
'
'��Type �����ѱ�WebBrowser�ؼ����صĶ�������͡����磺�������.doc�ļ����ͻ᷵
'��Microsoft Word Document
'  Left ���ػ�����WebBrowser�ؼ����ڵ��ڲ����������������ߵľ���
'  Top ���ػ�����WebBrowser�ؼ����ڵ��ڲ�������������ڶ��ߵľ���
'��Width ���ػ�����WebBrowser���ڵĿ�ȣ�������Ϊ��λ
'��Height ���ػ�����WebBrowser���ڵĸ߶ȣ�������Ϊ��λ
'��LocationName ����һ���ַ��������ַ���������WebBrowser��ǰ��ʾ����Դ�����ƣ������Դ
'����ҳ������ҳ�ı��⣻������ļ����ļ��У������ļ����ļ��е�����
'  LocationURL ����WebBrowser��ǰ������ʾ����Դ��URL
'��Busy ����һ��Booleanֵ��˵��WebBrowser��ǰ�Ƿ����ڼ���URL���������true
'�Ϳ���ʹ��stop��������������ִ�еķ��ʲ���
'
'
'
'�¼� ˵��
'Private Events Description
'BeforeNavigate2 ��������ǰ������ˢ��ʱ������
'CommandStateChange ������ļ���״̬�ı�ʱ����?��������ʱ�����ر�Back��Forward
'�˵����ť
'DocumentComplete �������ĵ�����Ǽ�����ˢ��ҳ�治����
'DownloadBegin ��ĳ�����ز����Ѿ���ʼ�󼤷���ˢ��Ҳ�ɼ������¼�
'DownloadComplete ��ĳ�����ز����Ѿ���ɺ󼤷���ˢ��Ҳ�ɼ������¼�
'NavigateComplete2 ������ɺ󼤷���ˢ��ʱ������
'NewWindow2 �ڴ����´�����ǰ����
'OnFullScreen ��FullScreen���Ըı�ʱ����?���¼�����VARIENT_BOOL��һ����
'�������ָʾIE��ȫ����ʾ��ʽ(VARIENT_TRUE)������ͨ��ʾ��ʽ(VARIENT_FALSE)
'OnMenuBar �ı�MenuBar������ʱ��������ʾ������VARIENT_BOOL���͵ġ�
'VARIANT_TRUE�ǿɼ���VARIANT_ FALSE������
'OnQuit �������û��ر���������ǿ����ߵ���Quit��������IE�˳�ʱ�ͻἤ��
'OnStatusBar ��OnMenuBar���÷�����ͬ����ʾ״̬���Ƿ�ɼ���
'OnToolBar ���÷���ͬ�ϣ���ʾ�������Ƿ�ɼ���
'OnVisible ���ƴ��ڵĿɼ������أ�Ҳʹ��һ��VARIENT_BOOL���͵Ĳ���
'StatusTextChange ���Ҫ�ı�״̬���е����֣�����¼��ͻᱻ���������������������Ƿ���״̬��
'TitleChange Title��Ч��ı�ʱ����
'2 ? ��ȡ��ҳԴ��
'����1: XMLHTTP����
'Public Function HtmlStr$(URL$)     '��ȡ��ҳԴ�뺯��
'  Dim XmlHttp
'  Set XmlHttp = CreateObject("Microsoft.XMLHTTP")
'  XmlHttp.Open "GET", URL, False
'  XmlHttp.Send
'  If XmlHttp.ReadyState = 4 Then HtmlStr = StrConv(XmlHttp.Responsebody, vbUnicode)
'End Function
'����2: WEBBROWSER�ؼ�
'Public Function WebDaima(WebBrowser, BuFen) '��ȡWebBrowser�ؼ�����ҳԴ����
'  Select Case BuFen
'    Case "Body"    'ֻ��ȡ<body>��</body>֮��Ĵ���
'      WebDaima = WebBrowser.Document.body.innerHTML
'    Case "All"     '��ȡ������ҳԴ����
'      WebDaima = WebBrowser.Document.DocumentElement.outerhtml
'    Case Else
'      WebDaima = WebBrowser.Document.DocumentElement.outerhtml
'  End Select
'End Function
'Dim strWeb As String
'strWeb = WebDaima(frmIndex.WebBrowser1, "All") '��ȡ������ҳԴ����
'strWeb = WebDaima(frmIndex.WebBrowser1, "Body") 'ֻ��ȡbody��Դ����
'3 ? ��ֹ�´�����ͷ����ҳ
'����1:
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Dim frm As Form1
'Set frm = New Form1
'frm.Visible = True
'Set ppDisp = frm.WebBrowser1.Object
'End Sub
'
'����2:
'����δ��룬 �������ҳ�����������ʾ�ű����󣬿�����silent����ΪTrue�����Σ�����Ҳ��Щ���㣡����
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'Cancel = True
'WebBrowser1.Navigate2 WebBrowser1.Document.activeElement.href
'End Sub
'
'����3:
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
'���ܲ�࣬��ѡһ����
'
'4 ? ��Webbrowser�ؼ�������
'
' Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'  Set ppDisp = WebPageAd.Object
'End Sub
'
'5 ? ȥ��������
'
'Private Sub WebBrowser1_DocumentComplete(ByVal pDisp As Object, URL As Variant)
'WebBrowser1.Document.body.Scroll = "no"
'End Sub
'ʵ���������Ч����զ�أ��������HTML֪ʶ�� ������ڶ�ȡ��ҳ��ʱ�򣬶�ȡHTMLԴ�룬 �����滻�� ��д��ֻ���� <body>   </body> ֮�������룺 <body   style= "overflow-x:hidden;overflow-y:hidden "> ���ɡ�����x��ʾˮƽ�������������Ϊy�Ļ��Ϳ������ش�ֱ��������
'��ȻҲ������������ �����޸���ҳ�ĳߴ�ѽ�� �е�ʱ�򲿷�Ԫ�صľ��и�Ϊ�����Ҳ����Ч��
'��WebBrower����PictureBox�ؼ��У���PictureBox�ı߿�סWebBrower�ı߿�
'����,��WebBrowser1�Ŵ��,��PictureBox��С��...PictureBox��appearance����Ϊ0-flat���Ǻǣ�OK~~
'
'6 ? ��ֹ����Ҽ�
'
'Private Function M_Dom_oncontextmenu() As Boolean
'WebBrowser1.Document.oncontextmenu = False
'End Function
''����Microsoft HTML OBject Library
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
'7 ? ��λ����ҳ������
'�ȸ�������:
'innerHTML: ���û��ȡλ�ڶ�����ʼ�ͽ�����ǩ�ڵ� HTML
'
'����һ��:
'
'<div id="d" style="background-color:#ff9966">����һ����</div>
'<input type="button" value="��ȡinnerHTML" onclick="getinnerHTML()">
'<input type="button" value="����innerHTML" onclick="setinnerHTML()">
'<script language="javascript">
'Function getinnerHTML()
'{
'alert (Document.getElementById("d").innerHTML)
'}
'Function setinnerHTML()
'{
'Document.getElementById("d").innerHTML = "<div id='d' style='background-color:#449966'>����һ����,�ٺ�</div>"
'}
'</script>
'
'8 ? ���ܿ��ҳ�����
''����������Է��ʵ���������
''.Document.ParentWindow.Frames.Length
''.Document.ParentWindow.Frames(1).Document.all.tags("a")
'
'        '�ȴ�������ҳȫ��������ϣ� �������
'        While .Busy Or .ReadyState <> 4 Or .Document.parentWindow.Frames.Length = 0
'            DoEvents
'        Wend
'
'9 ? ����������Ϣ
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
'10 ? ����Webbrowser��Ϣ����
'
'Dim oWindow
'Set oWindow = WebBrowser1.Document.parentWindow
'oWindow.confirm "abcd"
'
'VB����webbrowser���ɼ�2
'
'11 ? ��Webbrowser��д��HTML���ݵļ��ַ���
'
'��Webbrowser��д��HTML���ݵļ��ַ���
'
'������Form_Load�м���
'
'WebBrowser1.Navigate "about:blank"
'
'ȷ��Webbrowser1����
'
'
'����1:
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
'����2:
'
'Dim o
'
'Set o = WebBrowser1.Document.Selection.createRange
'Debug.Print o
'If (Not o Is Nothing) Then
'o.pasteHTML "����"
'Set o = Nothing
'End If
'
'
'����3:
'
''�����ı���
'Dim o
'
'Set o = WebBrowser1.Document.Selection.createRange
'
'o.execCommand "InsertTextArea", False, "xxx"
'
'
'12 ? ����ҳ�����
'WebBrowser1.Document.parentWindow.scrollby 0, 30
'
'13 ? �ж�ҳ���Ƿ����ǰ������
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
'14 ? ��λ����ҳ�б�ѡ�в��ֵ�HTML
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
'15 ? Navigate�Ĳ�������
'����: ��WebBrwoser�ؼ����ṩ��Navigate����Navigate2�������ṩ�˴�������
'
'�Ĳ��������÷�ʽΪ��WebBrowser1.Navigate2(URL,[Flags],
'
'[TargetFrameName],[PostData],[Headers])
'����PostData��������һ���ύ�����ַ���������"name=aaa&password=123"��
'
'��������Ϊʲô���������������Ч�ģ��������˲���ȡ�����ݣ�
'��������������Ч�Ļ��Ͳ���Ҫ��һ��html����ģ�����ֵ�����?
'
'��������ܼ�������post��ȥ����Ϣ
'
'Private Sub WebBrowser1_BeforeNavigate2(ByVal pDisp As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
'MsgBox PostData
'End Sub
'
'
'
'
'
'16 ? �����ļ��ղؼв���
'
'�������� specialfolder(6 ) �Ϳ��Եõ��ղؼе�·��, Ȼ���������dirȥѭ������ÿ��Ŀ¼,Ȼ��dir�����file, file�����־�����Ҫ���ղص�����, ·�������Լ����ݴ�����õ���·��ȥ�õ�.
'����㲻��dirҲ������vb��dir�ؼ�.
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
'17 ? ��Webbrowserȫ��
'�ǵ�,webbrowser������һ���ؼ�, ��Ҫ��ȫ��,����Ҫ�����ڵĴ���ȫ��,
'������setwindowlongȡ������� title,
'��Call ShowWindow(FindWindow(Shell_traywnd, ), 0) ����tray,�����±��Ǹ�������ʼ��һ��.
'��Call ShowWindow(FindWindow(Shell_traywnd, ), 9) �ָ�. ����ϸ�˰�.
'
'Ȼ����form1.windowstate = 2 �Ϳ�����.
'
'18 ? ѡ����ҳ�ϵ�����
'Private Sub Command1_Click()
'����ѡ��һЩ����
'Me.WebBrowser1.ExecWB OLECMDID_COPY, OLECMDEXECOPT_DODEFAULT
'MsgBox Clipboard.GetText
'End Sub
'
'
'19 ? ��IE�������ļ�
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
'����webbrowser�е�HTML����
'Dim oPF As IPersistFile
'Set oPF = WebBrowser1.Document
'oPF.Save "TheFileNameHere.htm", False
'
'WebBrowser1.ExecWB��ô��
'
'�������Ҳ��ԵĲ���
'WB.ExecWB(4,1)
'
'4,1 ������ҳ
'4,2 ������ҳ(������������)
'6,1 ֱ�Ӵ�ӡ
'6,2 ֱ�Ӵ�ӡ
'7,1 ��ӡԤ��
'7,2 ��ӡԤ��
'8,1 ѡ�����
'8,2 ѡ�����
'10,1 �鿴ҳ������
'10,2 �鿴ҳ������
'17,1 ȫѡ
'17,2 ȫѡ
'22,1 �������뵱ǰҳ
'22,2 �������뵱ǰҳ
'
'
'20 ? Webbrowserȷ�����ڶԻ���
'ĳЩ��ҳ���ڸ��ֿ��ǻᵯ���Ի���Ҫ����Ϣȷ�ϣ��������ж����ǵ�webbrowser���̣�����ʹ�����·�����
'1.����Microsoft Html Object
'2.�������
'
'Private Sub WebBrowser1_NavigateComplete2(ByVal pDisp As Object, URL As Variant)
'Dim obj As HTMLDocument
'Set obj = pDisp.Document
'obj.parentWindow.execScript "function showModalDialog(){return;}" '��showModalDialog����ĶԻ������ȷ��
'End Sub
'��confirm�����ĶԻ�ȷ�������confirm�滻showModalDialog���ɣ�Alert��ͬ��~
'
'WebBrowserȡ����ҳԴ��Private Sub Command1_Click()
'WebBrowser1.Navigate "http://www.sdqx.gov.cn/sdcity.php"
'End Sub
'
'Private Sub WebBrowser1_DownloadComplete()
''ҳ���������
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
'21 ? ��ֹWebBrowser�ؼ�����ҳ����
'Private Sub WebBrowser1_NewWindow2(ppDisp As Object, Cancel As Boolean)
'  Cancel = True
'End Sub
'ȫ��������Ϣ����ֹ
'22 ? ȡ��Դ������������д���
'����WebBrowserȡ����ҳԴ�룬ֱ���������������ڱ�������
'
'��ʾ��ʵʱ����"91" Object ������ with �����û������
'������û�����������£�
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
'23 ? ҳ��Ԫ�ز���
'1.���ݱ����(tagname)�ĺ�Ԫ����name���ҵ�Ԫ��,
'2.��Ԫ�ظ�ֵ����ִ����ص��¼�.
'
'��0: �鿴��ҳԪ��
'  Dim a
'  For Each a In wbr.Document.All
'      Text1.Text = Text1.Text & TypeName(a) & vbCrLf
'  Next
'
'��1: ��username�ı������������:
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
''�ı�����룺<input id="WordInput" maxlength="40" type="text" />
'WebBrowser1.Document.getElementsByTagName("input")("WordInput").Value = "Ҫ���ı������������"
''�˴�WordInputΪ�ı����ID��Name����ֵ
'
'��2: �ҵ��ύ��ť�����
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
'������MSDN2�ҵ����𰸻�û��.IFRAME�ڵ���ҳ�ķ�����ͬ,����Ҫ�õ�����.�������˵��.
'
'��3: �Ѷȵ�
'INPUT onclick="this.disabled=true;this.value='��¼�С������Ժ򡭡�';document.form1.submit();" type=submit value=" �� ¼ "
'
'For i = 0 To vDoc.All.Length - 1
'�� i ���ж�submit Ϊ�ڼ������ٵ����
'
'
'��4: ģ��������������ť
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
''���ڰ�ť������ֵ����x,y���������Լ����ˣ���Ϊ���ڷ��ڲ�ͬ��λ�ã������ǲ�һ���ģ��������getcursorposȡ�ã�
''��������������ˣ�����ʲô���أ������˻���Ҫ��֤��ģ�
'mouse_event MOUSEEVENTF_LEFTDOWN, x, y, 0, GetMessageExtraInfo
'mouse_event MOUSEEVENTF_LEFTUP, x, y, 0, GetMessageExtraInfo
'End Sub
'
'��5: ����IDֱ��CLICK
'
''<BUTTON id="WordSearchBtn" class="btn">��ѯ</button>
''�˰�ť�ĵ������
'WebBrowser1.Document.getElementsByTagName("BUTTON")("WordSearchBtn").Click
'
'��6: ���б�ѡ�ֵ
'
'Public Function SelectXq(WebBrowser, SelectName, SelectValue)
'  '����
'  'WebBrowser:WebBrowser�ؼ�����
'  'SelectName:��ҳ�� �б�/�˵� �����ƻ�IDֵ
'  'SelectValue:ѡ��ֵ
'  WebBrowser.doc.All.Item(SelectName).Value = SelectValue
'End Function
'�������÷���:
'WebBrowser����ҳSelect����������:
'
'<SELECT id=ctl00_ContentPlaceHolder1_DropDownList1 name=ctl00$ContentPlaceHolder1$DropDownList1> <OPTION value=�ҾͶ��ĵ�һ��ѧУ�����ƣ� selected>�ҾͶ��ĵ�һ��ѧУ�����ƣ�</OPTION> <OPTION value=����ϲ���������˶���ʲô��>����ϲ���������˶���ʲô��</OPTION> <OPTION value=����ϲ�����˶�Ա��˭��>����ϲ�����˶�Ա��˭��</OPTION> <OPTION value=����ϲ������Ʒ�����ƣ�>����ϲ������Ʒ�����ƣ�</OPTION> <OPTION value=����ϲ���ĸ�����>����ϲ���ĸ�����</OPTION> <OPTION value=����ϲ����ʳ�>����ϲ����ʳ�</OPTION> <OPTION value=������˵����֣�>������˵����֣�</OPTION> <OPTION value=����ĵ�Ӱ��>����ĵ�Ӱ��</OPTION> <OPTION value=����������գ�>����������գ�</OPTION></SELECT>
'
''���б��ѡ��ѡ��ֵΪ ������˵����� ��ѡ��
'
'Call SelectXq(Form1.WebBrowser1, "ctl00_ContentPlaceHolder1_DropDownList1", "������˵����֣�")
'
'
'��7: ��ҳ�Զ���д��ע��
'  <form   method="POST"   action="result.asp">
'      <p>����д�����ע�ᣨ*��Ϊ�����</p>
'      <p>*����<input   type="text"   name="Name"   size="20"></p>
'      <p>*��<input   type="radio"   value="V1"   name="R1"></p>
'      <p>*Ů<input   type="radio"   value="V1"   name="R2"></p>
'      <p>*�ǳ�<input   type="text"   name="NickName"   size="20"></p>
'   <p>*��Ȥ����<select name="aihao">
'     <option value="�����">�����</option>
'     <option value="��Ϸ">��Ϸ</option>
'     <option value="���">���</option>
'   </select></p>
'      <p>�����ʼ�<input   type="text"   name="EMail"   size="20"></p>
'      <p>*����<input   type="password"   name="Password"   size="20"></p>
'      <p><input   type="submit"   value="�ύ"   name="B1">
'      <input   type="reset"   value="ȫ����д"   name="B2"></p>
'  </form>
'    ��д�����ύ��������
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
'            vTag.Value = "���"
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
'24 ? ��ҳ��ť���ռ�����
''һ����˵,�����ֱ�ӵĲ�����ҳ���ύ��������
'WebBrowser1.Document.All("Namd").Value = "xxxx"      '���
'WebBrowser1.Document.All("DengLu").Click        '��ť���
''�����˷�����Ҫ֪���ñ��ĸ���Ԫ�ص�ID.һ����˵,��ͨ����ҳ����ֱ�Ӵ���ҳԴ�ļ����ҵ���Щ����.
''������������û����Դ�ļ����ҵ���,�ǿ�����
'    Text1 = WebBrowser1.Document.getElementById("BiaoID").innerHTML        '"BiaoID"Ϊ�����ڱ���ID
''����Text1��ʾ�����ľ�������Ҫ�ı��Ĵ�����.
''������ʹ�ǵõ����صĴ�����,�����п�������ûIDûNAMEû���͵İ�ť,����ô����?
''����,ͨ�÷�������.
''ûID���Ǿ͸�����ID��.
''��DocumentComplete����ҳ��ȫ�򿪺�
''������ҳԴ��,����Ҫ����İ�ť�����(����ID)
''����:
'    Text1 = <BUTTON style='PADDING-RIGHT: 2px; PADDING-LEFT: 2px; PADDING-BOTTOM: 2px; MARGIN-LEFT: 3px; LINE-HEIGHT: 100%; PADDING-TOP: 2px; HEIGHT: 20px' onclick=javascript:btnSeedFetcherClick.call(this)>ȷ��</BUTTON>
''�����Ϊ:
'    Text1 = <BUTTON  ID=abc style='PADDING-RIGHT: 2px; PADDING-LEFT: 2px; PADDING-BOTTOM: 2px; MARGIN-LEFT: 3px; LINE-HEIGHT: 100%; PADDING-TOP: 2px; HEIGHT: 20px' onclick=javascript:btnSeedFetcherClick.call(this)>ȷ��</BUTTON>
''Ȼ����
'    WebBrowser1.Document.body.innerHTML = Text1.Text        '�����������ҳװ��WebBrowser1
''Ȼ��Ϳ����û�һ��ʼ˵����򵥵ķ����������
'    WebBrowser1.Document.All("abc").Click        '��ť���
''��ô��,�ǲ��Ǻ�ˬѾ,�����Ͳ���ȥ˼������ûʲô������������λ�����ťȻ���ٵ����.
''��Ȼ,�����з�����:
'    Dim OButton
'    OButton = WebB.Document.getElementsByTagName("BUTTON")
'    OButton.Click       '�����͵����ǰ�������е��Ǹ���ť��.
''�ⷽ��ͨ����Ҳ�Ǻ�ǿ,�Լ���ĥһ�����������������.
'
'
'22 ?ִ����ҳ�еĽű�
'Function js(scripts)
'  On Error GoTo 1
'  If scripts = "" Then Exit Function
'Set Document = WebBrowser1.Document
'  Document.parentWindow.execScript scripts, "javascript"
'Exit Function
'1
'  MsgBox "����js�ű�ʱ��������!"
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
'����<input onclick="window.location.href='resourceissue.jsf';" type="button" value="��Դ����" style="cursor: pointer;"/>
'js "findNode('nodeName=INPUT;value=��Դ����',document.documentElement).click()"
'
'ע������򲻵Ĳ��������վҳ�棬������VB��JS������ִ��һ����д�����javascript:findNode�����磺js "function findNode(findString,obj){...."
'����findNode����Ҫȥ�����з���������Ϊ��ֱ�۲ż��ϵĻ��з�
'
'
'���� <IMG SRC="top.png" WIDTH="21" HEIGHT="18" BORDER="0" ALT="">
'js "findNode( 'nodeName=IMG;src=top.png;',document.documentElement).click() "
'���� <a href="top.html">xxxx</a>
'js "findNode( 'nodeName=IMG;src=top.png;#text=xxxx',document.documentElement).click() "
'
'
'����alert(document.getElementById( "tdGetSeed ").innerHTML); �����ǣ�<form id=frmgetseed style="...." onsubmit="return false"><input id=btnGetSeed style="..." onclick=javascript:getSeedClick.call(this); type=image src="...gif"></form>
'
'������:
'Set Document = WebBrowser1.Document
'document.getElementById("btnGetSeed").click()
'�ǿ��Ե�
'�����㲻��������ô������ˣ�ֻҪһ�����У��Ǿ��ǣ�
'document.getElementById("btnGetSeed").click()
'��
'Set Document = WebBrowser1.Document
'Document.parentWindow.execScript "getSeedClick.call(document.getElementById('frmgetseed'))", "javascript "
'
'
'
'
'
'23 ?��ȡ�ַ�������ҳԴ������ָ������Դ (��������һ���������²ɼ���)
'����1.�������룺
'Public Function FindStrMulti$(Strall$, FirstStr$, EndStr$, SplitStr$) '��ȡ�ַ�������ҳԴ����������ָ������
'  '����
'  '���ı�,��ʼ�ַ���,��ֹ�ַ���,�ָ���
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
'����2.��������
'     ��ȡ�ַ����е�����
'Dim str1 As String
'Dim str2 As String
'str1 = "<table><tr><td>Ҫ��ȡ������</td></tr></table>"
'str2 = FindStrMulti(str1, "<td>", "</td>", "")
'MsgBox str2
''��ʱstr2��ֵ��Ϊ Ҫ��ȡ������
'    �����б�������Ӳɼ�ʵ��
'    ��ҳ����
'<DIV id=content><SPAN class=navbar><STRONG><A href="/blog/">������ҳ</A> &gt; �����б�</STRONG></SPAN>
'<TABLE class=content_table width="100%">
'<TBODY>
'<TR>
'<TD>
'<H1>��Ŀ�㲩�������б�</H1>
'<P>
'<UL>
'<LI><SPAN class=list-category>[��̳����]</SPAN> <A class=list-title href="/blog/archives/119491210.shtml"><STRONG>˭������2010���ŵ������ѧ����</STRONG></A> <SPAN class=list-date>(2010-10-01 22:38)</SPAN></LI>
'<LI><SPAN class=list-category>[�Ӿ�ѵ��]</SPAN> <A class=list-title href="/blog/archives/119247165.shtml"><STRONG>�鷨��ϰ����</STRONG></A> <SPAN class=list-date>(2010-09-29 01:51)</SPAN> </LI>
'<LI><SPAN class=list-category>[��̳����]</SPAN> <A class=list-title href="/blog/archives/118604217.shtml"><STRONG>���Ծ��Ի�������</STRONG></A> <SPAN class=list-date>(2010-09-21 17:15)</SPAN> </LI>
'<LI><SPAN class=list-category>[�Ӿ�ѵ��]</SPAN> <A class=list-title href="/blog/archives/118206492.shtml"><STRONG>ҹ�ٹŻ������� </STRONG></A><SPAN class=list-date>(2010-09-17 01:46)</SPAN> </LI>
'<LI><SPAN class=list-category>[��Ҳ����]</SPAN> <A class=list-title href="/blog/archives/117345094.shtml"><STRONG>Jennifer Egan �ġ�A Visit From the Goon Squad��</STRONG></A> <SPAN class=list-date>(2010-09-07 02:30)</SPAN> </LI>
'<LI><SPAN class=list-category>[��Ҳ����]</SPAN> <A class=list-title href="/blog/archives/116446375.shtml"><STRONG>������̸�۵������ʱ��������̸�۵������Ķ���</STRONG></A> <SPAN class=list-date>(2010-08-27 16:51)</SPAN> </LI>
'<LI><SPAN class=list-category>[IT������]</SPAN> <A class=list-title href="/blog/archives/116133972.shtml"><STRONG>"��д��"��"��Ŀ��"��վ���ֻ���</STRONG></A> <SPAN class=list-date>(2010-08-24 02:04)</SPAN> </LI>
'</UL>
'<P></P>
'<P align=center>
'<P align=center><STRONG>1 <A href="/blog/list_all_2.shtml">2</A> <A href="/blog/list_all_3.shtml">3</A> <A href="/blog/list_all_4.shtml">4</A> <A href="/blog/list_all_5.shtml">5</A> <A href="/blog/list_all_6.shtml">6</A> <A href="/blog/list_all_7.shtml">7</A> <A href="/blog/list_all_8.shtml">8</A> <A href="/blog/list_all_2.shtml">&gt;&gt;</A> </STRONG></P>
'<P></P></TD></TR></TBODY></TABLE>
'<P>&nbsp;</P></DIV><!-- END CONTENT --><!-- BEGIN SITEBAR -->
'<DIV id=sidebar>
'<P>
' ���������ϴ����л�ȡ<ul>��</ul>֮���������µı������ӣ�ʵ�ַ������£�
'Dim strWeb As String
'Dim i As Integer
'Dim strListArea As String
'Dim strLink '�������б��������ӵ�����
'strWeb = WebDaima(Me.WebBrowser1, "Body")  '��ȡ��ҳbody����(����鿴WebDaima����)
'strListArea = FindStrMulti(strWeb, "<H1>��Ŀ�㲩�������б�</H1>", "</UL>", "") '���б��������
''��ȡ�б��������������ӣ�������������strLink��
'strLink = Split(FindStrMulti(strListArea, "href=" & Chr(34), Chr(34) & "><STRONG>", vbCrLf), vbCrLf)
'For i = 0 To UBound(strLink) 'ѭ���������
'  Text1.Text = Text1.Text & strLink(i) & vbCrLf
'Next i
'24 ?���ĺ���ת��ΪURL����
'��������:
''���������������ڽ�����ת��ΪUTF8��GBK���룺(���ڰٶ�����������ʱ���ٶ��Ƚ�������ת��ΪUTF8�ı��룬�ٴ��͸�������)
''���ã�
''KeyWordUtf = UTF8EncodeURI(KeyWord) �� KeyWordUtf = GBKEncodeURI(KeyWord)
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
'��������:
'MsgBox UTF8EncodeURI("���ĺ���")
'MsgBox GBKEncodeURI("���ĺ���")
'25 ?��ȡ��ҳ�е���֤��
'��������:
'Public Function GetImg(WebBrowser, Img, sxz)
''����
''WebBrowser:�Ȼ�ȡ��֤����ҳ���ڵ�WebBrowser�ؼ�
''Img:��ʾ��֤���Image�ؼ�
''sxz:��ҳ����֤����Ӧ���Ե�����ֵ
'  Dim CtrlRange, x
'  For Each x In WebBrowser.Document.All
'    If UCase(x.tagName) = "IMG" Then
'      'x.srcΪ��֤��ͼƬ������,Ҳ������������ �� x.onload��
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
'��������:
''���ȡ��ҳhttp://www.pceggs.com/login.aspx�е���֤��ͼƬ�������£�
''<IMG id=valiCode style="CURSOR: pointer" alt=��֤�� src="/VerifyCode_Login.aspx" border=0>
''��ȡ��֤�뺯���������£�
'Call GetImg(Form1.WebBrowser1, Form1.Image1, "VerifyCode_Login.aspx")
'26 ?WebBrowser�ؼ�����ҳ��ť�ĵ��
'
'27 ?����
'
'����͸���ؼ���͸��
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


'���ͨ��VBA������ʾEXCEL���Ԫ�������к���

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
