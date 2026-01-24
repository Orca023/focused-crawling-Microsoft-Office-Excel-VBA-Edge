#!/usr/bin/python3
# -*- coding: utf-8 -*-


# Author: 弘毅（Orca）
# Phone: 18604537694
# Electronic-Mailbox: 85664552@qq.com
# QQ: 85664552
# WhatsApp-Messenger: +8618604537694
# wechat: orca387642
# Date： 2020-02-20
# Notes:


# import platform  # 加載Python原生的與平臺屬性有關的模組;
import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
# import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型;
# import subprocess  # 加載Python原生的創建子進程模組;
import string  # 加載Python原生的字符串處理模組;
import datetime, time  # 加載Python原生的日期數據處理模組;
import json  # import the module of json. 加載Python原生的Json處理模組;
# import re  # 加載Python原生的正則表達式對象
# from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
import struct  # 用於讀、寫、操作二進制本地硬盤文檔;
import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
import threading  # 加載Python原生的支持多綫程（執行緒）模組;
from socketserver import ThreadingMixIn  #, ForkingMixIn
import inspect, ctypes  # 用於强制終止綫程;
# import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
# import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
# # https: // docs.python.org/3/library/http.server.html
# from http import cookiejar  # 用於處理請求Cookie;
import socket  # 加載Python原生的套接字模組socket、配置服務器支持 IPv6 格式地址;
# import ssl  # 用於處理請求證書驗證;
import base64  # 加載加、解密模組;
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)
# import math  # 導入 Python 原生包「math」，用於數學計算;
import warnings
# 棄用控制臺打印警告信息;
def fxn():
    warnings.warn("deprecated", DeprecationWarning)  # 棄用控制臺打印警告信息;
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fxn()
with warnings.catch_warnings(record=True) as w:
    # Cause all warnings to always be triggered.
    warnings.simplefilter("always")
    # Trigger a warning.
    fxn()
    # Verify some things
    assert len(w) == 1
    assert issubclass(w[-1].category, DeprecationWarning)
    assert "deprecated" in str(w[-1].message)

# 導入第三方擴展包，需要事先已經在操作系統控制臺命令行安裝配置成功;
# 先升級 pip 擴展包管理工具：root@localhost:~# python -m pip install --upgrade pip
# 再安裝第三方擴展包：root@localhost:~# pip install emcee -i https://mirrors.aliyun.com/pypi/simple/
# import numpy  # as np
# import pandas  # as pd
# import matplotlib  # as mpl
# import matplotlib.pyplot as matplotlib_pyplot
# import matplotlib.font_manager as matplotlib_font_manager  # 導入第三方擴展包「matplotlib」中的字體管理器，用於設置生成圖片中文字的字體;
# https://docs.sympy.org/latest/tutorial/preliminaries.html#installation
# import sympy  # 導入第三方擴展包「sympy」，用於符號計算;
# https://www.scipy.org/docs.html
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於實現 beta 分佈概率密度函數;
# import scipy.stats as scipy_stats
# from scipy import optimize as scipy_optimize  # 導入第三方擴展包「scipy」中的最優化模組「optimize」，用於方程擬合;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合插值函數;
# from scipy import special as scipy_special  # 導入第三方擴展包「scipy」中的最優化模組「special」，用於使用「special」模組中的「comb()」函數計算組合數;

# https://mariadb.com/
# https://mariadb.com/docs/skysql/connect/programming-languages/python/
# https://mariadb.com/resources/blog/how-to-connect-python-programs-to-mariadb/
# https://mariadb.com/kb/zh-cn/mariadb/
# https://www.w3cschool.cn/article/23356719.html
# https://www.w3cschool.cn/mariadb/mariadb_installation.html
# https://github.com/mariadb-developers/mariadb-connector-python-samples
# https://mariadb.com/developers/resources/language/python/
import mariadb  # as em  # 導入第三方擴展包「mariadb」，用於鏈接 MariaDB 數據庫服務器，需要事先安裝配置成功： pip3 install mariadb -i https://mirrors.aliyun.com/pypi/simple/;



# # 匯入自定義路由模組脚本文檔「./Router.py」;
# # os.getcwd() # 獲取當前工作目錄路徑;
# # os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# # os.path.join(os.path.abspath("."), 'Router.py')  # 拼接路徑字符串;
# # pathlib.Path(os.path.join(os.path.abspath("."), Router.py)  # 返回路徑對象;
# # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# import Interface as Interface  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Router.py」;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
# File_Monitor = Router.Interface_File_Monitor
# http_Server = Router.Interface_http_Server
# http_Client = Router.Interface_http_Client
# check_json_format = Router.check_json_format
# win_file_is_Used = Router.win_file_is_Used
# clear_Directory = Router.clear_Directory
# formatByte = Router.formatByte

# # 匯入自定義統計描述模組脚本文檔「./Statis_Descript.py」;
# # # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」;
# from Statis_Descript import Transformation as Transformation  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的數據歸一化、數據變換函數「Transformation()」，用於將原始數據歸一化處理;
# from Statis_Descript import outliers_clean as outliers_clean  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的離群值檢查（含有粗大誤差的數據）函數「outliers_clean()」，用於檢查原始數據歸中的離群值;



# 控制臺升級 pip 工具到最新的版本 ( >= 10.0.0)：
# root@localhost:~# python3 -m pip install --upgrade pip
# https://mariadb.com/
# https://mariadb.com/docs/skysql/connect/programming-languages/python/
# https://mariadb.com/resources/blog/how-to-connect-python-programs-to-mariadb/
# https://mariadb.com/kb/zh-cn/mariadb/
# https://www.w3cschool.cn/article/23356719.html
# https://www.w3cschool.cn/mariadb/mariadb_installation.html
# https://github.com/mariadb-developers/mariadb-connector-python-samples
# https://mariadb.com/developers/resources/language/python/
# import mariadb  # as em  # 導入第三方擴展包「mariadb」，用於鏈接 MariaDB 數據庫服務器，需要事先安裝配置成功： pip3 install mariadb -i https://mirrors.aliyun.com/pypi/simple/;
# 示例函數，處理從客戶端 GET 或 POST 請求的信息，然後返回處理之後的結果JSON對象字符串數據;
def do_Request_Router(request_Dict):
    # request_Dict = {
    #     "Client_IP": Client_IP,
    #     "request_Url": request_Url,
    #     # "request_Path": request_Path,
    #     "require_Authorization": self.request_Key,
    #     "require_Cookie": self.Cookie_value,
    #     # "Server_Authorization": Key,
    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
    #     "request_body_string": request_form_value
    # }

    # print(type(request_Dict))
    # print(request_Dict)

    request_POST_String = ""  # request_Dict["request_body_string"];  # 客戶端發送 post 請求時的請求體數據;
    request_Url = ""  # request_Dict["request_Url"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
    request_Path = ""  # request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
    request_Url_Query_String = ""  # request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
    request_Url_Query_Dict = {}  # 客戶端請求 url 中的查詢字符串值解析字典 {"a": 1, "b": 2};
    request_Authorization = ""  # request_Dict["require_Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
    request_Cookie = ""  # request_Dict["require_Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
    request_Key = ""
    request_Nikename = ""  # request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
    request_Password = ""  # request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
    # request_time = ""  # request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
    # request_Date = ""  # request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
    request_IP = ""  # request_Dict["Client_IP"];  # 客戶端發送請求的 IP 地址字符串;
    # request_Method = ""  # request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
    request_Host = ""  # request_Dict["Host"];  # 客戶端發送請求的服務器主機域名或 IP 地址值字符串 "127.0.0.1"、"localhost";
    # request_Protocol = ""  # request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "http:"、"https:";
    request_User_Agent = ""  # request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
    request_From = ""  # request_Dict["From"];  # 客戶端發送請求的來源值字符串;

    # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
    if request_Dict.__contains__("Host"):
        # print(request_Dict["Host"])
        request_Host = request_Dict["Host"]
    if request_Dict.__contains__("request_Url"):
        # print(request_Dict["request_Url"])
        request_Url = request_Dict["request_Url"]
        # request_Url = request_Url.decode('utf-8')
    # if request_Dict.__contains__("request_Path"):
    #     # print(request_Dict["request_Path"])
    #     request_Path = request_Dict["request_Path"]
    #     # request_Path = request_Path.decode('utf-8')
    # if request_Dict.__contains__("request_Url_Query_String"):
    #     # print(request_Dict["request_Url_Query_String"])
    #     request_Url_Query_String = request_Dict["request_Url_Query_String"]
    #     # request_Url_Query_String = request_Url_Query_String.decode('utf-8')
    if request_Dict.__contains__("Client_IP"):
        # print(request_Dict["Client_IP"])
        request_IP = request_Dict["Client_IP"]
    if request_Dict.__contains__("require_Authorization"):
        # print(request_Dict["require_Authorization"])
        request_Authorization = request_Dict["require_Authorization"]
    if request_Dict.__contains__("require_Cookie"):
        # print(request_Dict["require_Cookie"])
         request_Cookie = request_Dict["require_Cookie"]
    if request_Dict.__contains__("request_body_string"):
        # print(request_Dict["request_body_string"])
        request_POST_String = request_Dict["request_body_string"]
        # request_POST_String = request_POST_String.decode('utf-8')
    # if request_Dict.__contains__("time"):
    #     print(request_Dict["time"])
    #     request_time = request_Dict["time"]

    # # print(request_Authorization)
    # # 使用請求頭信息「self.headers["Authorization"]」簡單驗證訪問用戶名和密碼，"Basic username:password";
    # if request_Authorization != None and request_Authorization != "":
    #     # print("request Headers Authorization: ", request_Authorization)
    #     # print("request Headers Authorization: ", request_Authorization.split(" ", -1)[0], base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False))
    #     # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
    #     # print(type(base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False)))

    #     # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
    #     if request_Authorization.find("Basic", 0, int(len(request_Authorization)-1)) != -1 and request_Authorization.split(" ", -1)[0] == "Basic" and len(request_Authorization.split("Basic ", -1)) > 1 and request_Authorization.split("Basic ", -1)[1] != "":
    #         request_Key = str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
    #         request_Authorization = "Basic " + str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "Basic username:password";
    #         request_Nikename = request_Key.split(":", -1)[0]
    #         request_Password = request_Key.split(":", -1)[1]
    #     # print(type(request_Key))
    #     # print(request_Key)

    # # print(request_Cookie)
    # # 使用請求頭信息「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼，"Session_ID=request_Key->username:password";
    # if request_Cookie != None and request_Cookie != "":
    #     Cookie_value = request_Cookie
    #     # print("request Headers Cookie: ", self.headers["Cookie"])
    #     # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
    #     # request_Key = eval("'" + str(Cookie_value.split("=", -1)[1]) + "'", {'request_Key' : ''})  # exec('request_Key="username:password"', {'request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

    #     # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
    #     if Cookie_value.find("=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.find("Session_ID=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.split("=", -1)[0] == "Session_ID":
    #         Session_ID = str(base64.b64decode(Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
    #     else:
    #         Session_ID = str(base64.b64decode(Cookie_value, altchars=None, validate=False), encoding="utf-8")

    #     # print(type(Session_ID))
    #     # print(Session_ID)

    #     request_Key = Session_ID.split("request_Key->", -1)[1]
    #     request_Cookie = "Session_ID=" + Session_ID  # "Session_ID=request_Key->username:password";
    #     request_Nikename = request_Key.split(":", -1)[0]
    #     request_Password = request_Key.split(":", -1)[1]

    #     # # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
    #     # if Session_ID != None and Session_ID != "" and type(Session_ID) == str and Session.__contains__(Session_ID) == True and Session[Session_ID] != None:
    #     #     request_Key = str(Session[Session_ID])
    #     #     # print(type(request_Key))
    #     #     # print(request_Key)
    #     # else:
    #     #     # request_Key = ":"
    #     #     request_Key = ""

    #     # print(type(request_Key))
    #     # print(request_Key)
    #     # print(Key)


    if request_Url != "":
        if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
            request_Path = str(request_Url.split("?", -1)[0])
        elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
            request_Path = str(request_Url.split("#", -1)[0])
        else:
            request_Path = str(request_Url)

        if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
            request_Url_Query_String = str(request_Url.split("?", -1)[1])
            if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])

    # print(request_Url_Query_String)
    if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
        if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
            # for i in range(0, len(request_Url_Query_String.split("&", -1))):
            for query_item in request_Url_Query_String.split("&", -1):
                if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                    temp_split_Array = query_item.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                    request_Url_Query_Dict[query_item] = ""
        else:
            if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                temp_split_Array = request_Url_Query_String.split("=", -1)
                temp_split_value = ""
                if len(temp_split_Array) > 1:
                    for i in range(1, len(temp_split_Array)):
                        if int(i) == int(1):
                            temp_split_value = temp_split_value + str(temp_split_Array[i])
                        if int(i) > int(1):
                            temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
            else:
                # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                request_Url_Query_Dict[request_Url_Query_String] = ""
    # print(request_Url_Query_Dict)

    # urllib.parse.urlparse(self.path)
    # urllib.parse.urlparse(self.path).path
    # parse_qs(urllib.parse.urlparse(self.path).query)
    fileName = ""  # "/Python2MariaDBServer.py" 自定義的待替換的文件路徑全名;
    dbUser = ""  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
    dbPass = ""  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
    # UserPass = dbUser + ":" + dbPass  # 'admin_test20220703:admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
    dbName = ""  # 'testWebData'  # ['admin', 'testWebData']  # 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，MariaDB 要求數據庫名稱首字母必須為大寫單數;
    dbTableName = ""  # 'test20220703'  # ['test20220703'];  # MariaDB 數據庫包含的數據集合（表格）;
    global Key  # 變量 Key 為全局變量;
    # 使用函數 isinstance(request_Url_Query_Dict, dict) 判斷傳入的參數 request_Url_Query_Dict 是否為 dict 字典（JSON）格式對象;
    if isinstance(request_Url_Query_Dict, dict):
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if (request_Url_Query_Dict.__contains__("fileName")):
            fileName = str(request_Url_Query_Dict["fileName"])
        if (request_Url_Query_Dict.__contains__("dbUser")):
            dbUser = str(request_Url_Query_Dict["dbUser"])
        if (request_Url_Query_Dict.__contains__("dbPass")):
            dbPass = str(request_Url_Query_Dict["dbPass"])
        if dbUser != "" or dbPass != "":
            UserPass = dbUser + ":" + dbPass  # 'admin_test20220703:admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        if (request_Url_Query_Dict.__contains__("UserPass")):
            UserPass = str(request_Url_Query_Dict["UserPass"])
        if (request_Url_Query_Dict.__contains__("dbName")):
            dbName = str(request_Url_Query_Dict["dbName"])
        if (request_Url_Query_Dict.__contains__("dbTableName")):
            dbTableName = str(request_Url_Query_Dict["dbTableName"])
        if (request_Url_Query_Dict.__contains__("Key")):
            Key = str(request_Url_Query_Dict["Key"])

    # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
    request_data_Dict = {}  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
    # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
    # if check_json_format(request_POST_String):
    #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
    #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
    # # print(request_data_Dict)

    response_data_Dict = {}  # 函數返回值，聲明一個空字典;
    response_data_String = ""
    return_file_creat_time = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))
    # print(return_file_creat_time)

    response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)};
    # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)};
    # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)};
    # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)};
    response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)};
    response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)};
    # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)};
    # response_data_Dict["request_Password"] = str(request_Password)  # {"request_Password": str(request_Password)};
    response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)};
    # response_data_Dict["Server_Authorization"] = str(key)  # "username:password"，{"Server_Authorization": str(key)};
    response_data_Dict["Server_say"] = str("")  # {"Server_say": str(request_POST_String)};
    response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)};
    # print(response_data_Dict)

    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
    # # 使用加號（+）拼接字符串;
    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
    # # print(response_data_String)

    # webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
    web_path = "";  # str(os.path.join(os.path.abspath("."), str(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
    file_data = "";  # 用於保存從硬盤讀取文檔中的數據;
    dir_list_Arror = [];  # 用於保存從硬盤讀取文件夾中包含的子文檔和子文件夾名稱清單的字符串數組;

    if request_Path == "/":
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:8001/?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), "index.html"))  # 拼接本地當前目錄下的請求文檔名;
        file_data = ""

        directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

        # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組，使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if os.path.exists(webPath) and pathlib.Path(webPath).is_dir():
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(webPath, os.R_OK) and os.access(webPath, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(webPath, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(webPath, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(webPath, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(webPath, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(webPath, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(webPath)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = f'Error: {str(webPath)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(webPath)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(webPath))
            # if len(os.listdir(webPath)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(webPath), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:
        else:
            print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 不存在或無法識別.")

            response_data_Dict["Server_say"] = "服務器的運行路徑: " + str(webPath) + " 無法識別."
            response_data_Dict["error"] = "Folder = { " + str(webPath) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/index.html":
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:8001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        file_data = ""

        directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

        # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組，使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if os.path.exists(webPath) and pathlib.Path(webPath).is_dir():
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(webPath, os.R_OK) and os.access(webPath, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(webPath, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(webPath, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(webPath, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(webPath, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(webPath, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(webPath)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = f'Error: {str(webPath)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(webPath)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(webPath))
            # if len(os.listdir(webPath)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(webPath), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:
                # print(directoryHTML)
        else:
            print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 不存在或無法識別.")

            response_data_Dict["Server_say"] = "服務器的運行路徑: " + str(webPath) + " 無法識別."
            response_data_Dict["error"] = "Folder = { " + str(webPath) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/uploadFile":
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:8001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

        if fileName == "":
            print("Upload file name empty { " + str(fileName) + " }.")
            response_data_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " + str(fileName) + " } 爲空."
            response_data_Dict["error"] = "File name = { " + str(fileName) + " } empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        # print(fileName)
        web_path = ""
        if fileName[0] == '/' or fileName[0] == '\\':
            web_path = str(os.path.join(str(webPath), str(fileName[1:len(fileName)])))  # 拼接待替換寫入的目標文檔名（絕對路徑），如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
        else:
            web_path = str(os.path.join(str(webPath), str(fileName)))  # 拼接待替換寫入的目標文檔名（絕對路徑）;
        # print(web_path)

        file_data = str(request_POST_String)  # 向目標文檔中寫入的内容字符串;
        # file_data_bytes = file_data.encode("utf-8")
        # file_data_len = len(bytes(file_data, "utf-8"))
        # file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象 file_data_integer_Array = json.loads(file_data, encoding='utf-8');
        # file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
        # file_data = file_data.encode('utf-8')
        # file_data_bytes_Array = []  # 字符串轉換後的二進制字節流數組;
        # for i in range(0, int(len(file_data_integer_Array))):
        #     # itemBytes = bytes(int(file_data_integer_Array[i]), "utf-8")
        #     # itemBytes = str(file_data_integer_Array[i]).encode('utf-8')  # 字符串轉二進制字節流;
        #     itemBytes = struct.pack('B', int(file_data_integer_Array[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
        #     # itemBytes.decode("utf-8")  # 二進制字節流轉字符串;
        #     # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
        #     # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
        #     file_data_bytes_Array.append(itemBytes)

        # 同步寫入或創建硬盤目標文檔：首先判斷指定的待寫入文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("目標寫入文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(fileName) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            # 刪除指定的待寫入文檔;
            try:
                os.remove(web_path)  # 刪除文檔
            except OSError as error:
                print(f'Error: {str(web_path)} : {error.strerror}')
                print("目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據.")
                response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 已存在且無法刪除，以重新創建更新數據."
                response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String

            # # 判斷指定的待寫入文檔，是否已經從硬盤刪除;
            # if os.path.exists(web_path) and os.path.isfile(web_path):
            #     print("目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據.")
            #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據."
            #     response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String

        else:

            # 截取目標寫入目錄;
            writeDirectory = ""
            # print(fileName)
            if isinstance(fileName, str) and fileName.find("/", 0, int(len(fileName)-1)) != -1:
                tempArray = []
                tempArray = fileName.split("/", -1)
                if len(tempArray) <= 2:
                    writeDirectory = "/"
                else:
                    for i in range(0, int(len(tempArray) - int(1))):
                        if i == 0:
                            writeDirectory = str(tempArray[i])
                        else:
                            writeDirectory = writeDirectory + "/" + str(tempArray[i])
            elif isinstance(fileName, str) and fileName.find("\\", 0, int(len(fileName)-1)) != -1:
                tempArray = []
                tempArray = fileName.split("\\", -1)
                if len(tempArray) <= 2:
                    writeDirectory = "\\"
                else:
                    for i in range(0, int(len(tempArray) - int(1))):
                        if i == 0:
                            writeDirectory = str(tempArray[i])
                        else:
                            writeDirectory = writeDirectory + "\\" + str(tempArray[i])
            else:
                writeDirectory = "/"
            # print(writeDirectory)
            AbsolutewriteDirectory = ""
            if writeDirectory[0] == '/' or writeDirectory[0] == '\\':
                AbsolutewriteDirectory = str(os.path.join(str(webPath), str(writeDirectory[1:len(writeDirectory)])))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名，如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
            else:
                AbsolutewriteDirectory = str(os.path.join(str(webPath), str(writeDirectory)))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名;
            # print(AbsolutewriteDirectory)

            # 判斷目標寫入目錄（文件夾）是否存在，如果不存在則創建;
            # 使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            if os.path.exists(AbsolutewriteDirectory) and pathlib.Path(AbsolutewriteDirectory).is_dir():
                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(AbsolutewriteDirectory, os.R_OK) and os.access(AbsolutewriteDirectory, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(AbsolutewriteDirectory, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(AbsolutewriteDirectory, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(AbsolutewriteDirectory)} : {error.strerror}')
                        print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法修改為可讀可寫權限.")
                        response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = f'Error: {str(writeDirectory)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
            else:
                try:
                    # print(AbsolutewriteDirectory)
                    os.makedirs(AbsolutewriteDirectory, mode=0o777, exist_ok=True)
                    # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                    # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
                except FileExistsError as error:
                    # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
                    print(f'Error: {str(AbsolutewriteDirectory)} : {error.strerror}')
                    print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法創建.")
                    response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法創建."
                    response_data_Dict["error"] = f'Error: {str(writeDirectory)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            # # 判斷指定的寫入目錄（文件夾）是否創建成功;
            # if not (os.path.exists(AbsolutewriteDirectory) and pathlib.Path(AbsolutewriteDirectory).is_dir()):
            #     print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法創建.")
            #     response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法創建."
            #     response_data_Dict["error"] = f'Directory: ( {str(writeDirectory)} ) cannot be created.'
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String


        # # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔，以字符串形式寫入純文本文檔;
        # fd = open(web_path, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
        # # fd = open(web_path, mode="wb+")
        # try:
        #     numBytes = fd.write(file_data)  # 寫入字符串，返回值為寫入的字符數目;
        #     # file_data_bytes = file_data.encode("utf-8")
        #     # file_data_len = len(bytes(file_data, "utf-8"))
        #     # fd.write(file_data_bytes)
        #     response_data_Dict["Server_say"] = "向文檔: " + str(fileName) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
        #     # response_data_Dict["Server_say"] = "向文檔: " + str(web_path) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
        #     response_data_Dict["error"] = ""
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     # return response_data_String
        # except FileNotFoundError:
        #     print("目標替換文檔 [ " + str(web_path) + " ] 創建失敗.")
        #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 創建失敗."
        #     response_data_Dict["error"] = "File [ " + str(fileName) + " ] creation failed."
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     return response_data_String
        # except PersmissionError:
        #     print("目標替換文檔 [ " + str(web_path) + " ] 沒有打開權限.")
        #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 沒有打開權限."
        #     response_data_Dict["error"] = "File [ " + str(fileName) + " ]  unable to write."
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     return response_data_String
        # finally:
        #     fd.close()
        # # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


        # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔，以字節流形式寫入二進制文檔;
        fd = open(web_path, mode="wb+", buffering=-1)
        # fd = open(web_path, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
        try:
            file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象 file_data_integer_Array = json.loads(file_data, encoding='utf-8');
            # file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
            # file_data = file_data.encode('utf-8')
            numBytes = int(0)  # 寫入的縂字節數;
            # file_data_bytes_Array = []  # 字符串轉換後的二進制字節流數組;
            for i in range(0, int(len(file_data_integer_Array))):
                # itemBytes = bytes(int(file_data_integer_Array[i]), "utf-8")
                # itemBytes = str(file_data_integer_Array[i]).encode('utf-8')  # 字符串轉二進制字節流;
                itemBytes = struct.pack('B', int(file_data_integer_Array[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
                # itemBytes.decode("utf-8")  # 二進制字節流轉字符串;
                # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
                # file_data_bytes_Array.append(itemBytes)
                numWriteBytes = fd.write(itemBytes)  # 寫入一個二進制字節;
                numBytes = int(numBytes) + int(numWriteBytes)  # 纍計寫入文檔的字節數目;

            response_data_Dict["Server_say"] = "向文檔: " + str(fileName) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
            # response_data_Dict["Server_say"] = "向文檔: " + str(web_path) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
            response_data_Dict["error"] = ""
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            # return response_data_String
        except FileNotFoundError:
            print("目標替換文檔 [ " + str(web_path) + " ] 創建失敗.")
            response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 創建失敗."
            response_data_Dict["error"] = "File [ " + str(fileName) + " ] creation failed."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String
        except PersmissionError:
            print("目標替換文檔 [ " + str(web_path) + " ] 沒有打開權限.")
            response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 沒有打開權限."
            response_data_Dict["error"] = "File [ " + str(fileName) + " ]  unable to write."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String
        finally:
            fd.close()
        # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        return response_data_String

    elif request_Path == "/deleteFile":
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:8001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py

        if fileName == "":
            print("Upload file name empty { " + str(fileName) + " }.")
            response_data_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " + str(fileName) + " } 爲空."
            response_data_Dict["error"] = "File name = { " + str(fileName) + " } empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        if fileName != "":

            # print(fileName)
            web_path = ""
            if fileName[0] == '/' or fileName[0] == '\\':
                web_path = str(os.path.join(str(webPath), str(fileName[1:len(fileName)])))  # 拼接待替換寫入的目標文檔名（絕對路徑），如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
            else:
                web_path = str(os.path.join(str(webPath), str(fileName)))  # 拼接待替換寫入的目標文檔名（絕對路徑）;
            # print(web_path)

            file_data = str(request_POST_String)  # 客戶端 POST 請求的内容字符串;

            if os.path.exists(web_path) and os.path.isfile(web_path):

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path)} : {error.strerror}')
                        print("目標待刪除文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                        response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = "File = { " + str(fileName) + " } cannot modify to read and write permission."

                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                # 刪除指定的文檔;
                try:
                    os.remove(web_path)  # 刪除文檔
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的待刪除文檔 [ " + str(web_path) + " ] 無法刪除.")
                    response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法刪除."
                    response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

                # # 判斷指定的待刪除文檔，是否已經從硬盤刪除;
                # if os.path.exists(web_path) and os.path.isfile(web_path):
                #     print("指定的待刪除文檔 [ " + str(web_path) + " ] 無法被刪除.")
                #     response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法被刪除."
                #     response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                #     # 使用加號（+）拼接字符串;
                #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                #     # print(response_data_String)
                #     return response_data_String

            elif os.path.exists(web_path) and pathlib.Path(web_path).is_dir():

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path)} : {error.strerror}')
                        print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法修改為可讀可寫權限.")
                        response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                # 刪除指定的目錄（文件夾）;
                try:
                    shutil.rmtree(web_path, ignore_errors=True)  # 遞歸刪除文件夾及文件夾裏的所有内容（子文檔和子文件夾），參數 ignore_errors=True 表示忽略錯誤;
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法刪除.")
                    response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法刪除."
                    response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

                # # 檢查指定的待刪除目錄（文件夾）是否已經從硬盤移除;
                # if os.path.exists(web_path) and pathlib.Path(web_path).is_dir():
                #     print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法被刪除.")
                #     response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法被刪除."
                #     response_data_Dict["error"] = f'Directory: ( {str(fileName)} ) cannot be deleted.'
                #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                #     # 使用加號（+）拼接字符串;
                #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                #     # print(response_data_String)
                #     return response_data_String

            else:

                print("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + str(web_path) + " 不存在或者無法識別.")
                response_data_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " + str(fileName) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(fileName) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String


        # # web_path_index_Html = str(os.path.join(str(webPath), "index.html"))  # 拼接服務器返回的響應值文檔名（絕對路徑）;
        # # file_data = Base.string(request_POST_String);
        # # 截取目標寫入目錄;
        # currentDirectory = ""
        # # print(fileName)
        # if isinstance(fileName, str) and fileName.find("/", 0, int(len(fileName)-1)) != -1:
        #     tempArray = []
        #     tempArray = fileName.split("/", -1)
        #     if len(tempArray) <= 2:
        #         currentDirectory = "/"
        #     else:
        #         for i in range(0, int(len(tempArray) - int(1))):
        #             if i == 0:
        #                 currentDirectory = str(tempArray[i])
        #             else:
        #                 currentDirectory = currentDirectory + "/" + str(tempArray[i])
        # elif isinstance(fileName, str) and fileName.find("\\", 0, int(len(fileName)-1)) != -1:
        #     tempArray = []
        #     tempArray = fileName.split("\\", -1)
        #     if len(tempArray) <= 2:
        #         currentDirectory = "\\"
        #     else:
        #         for i in range(0, int(len(tempArray) - int(1))):
        #             if i == 0:
        #                 currentDirectory = str(tempArray[i])
        #             else:
        #                 currentDirectory = currentDirectory + "\\" + str(tempArray[i])
        # else:
        #     currentDirectory = "/"
        # # print(currentDirectory)
        # if currentDirectory[0] == '/' or currentDirectory[0] == '\\':
        #     web_path = str(os.path.join(str(webPath), str(currentDirectory[1:len(currentDirectory)])))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名，如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
        # else:
        #     web_path = str(os.path.join(str(webPath), str(currentDirectory)))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名;
        # # print(web_path)

        return response_data_String

    elif request_Path == "/createCollection":

        sql_text = ""
        # sql_text = 'CREATE TABLE dbTableName(column_name_1 column_type_1 NOT NULL AUTO_INCREMENT, column_name_2 column_type_2 NOT NULL, PRIMARY KEY (column_name_1))'
        # sql_text = (
        #     'CREATE TABLE ' + dbTableName + '('
        #         column_name_1 + ' ' + column_type_1 + ' NOT NULL AUTO_INCREMENT,'
        #         column_name_2 + ' ' + column_type_2 + ' NOT NULL,'
        #         column_name_3 + ' ' + column_type_3 + ' NOT NULL,'
        #         column_name_4 + ' ' + column_type_4 + ','
        #         PRIMARY KEY ( column_name_1 )  # 指定主鍵;
        #     ')'
        # )

        if dbTableName == "":
            sql_text = request_POST_String

        if dbTableName != "":
            sql_text = 'CREATE TABLE ' + dbTableName + request_POST_String

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/dropCollection":

        sql_text = ""
        # sql_text = 'DROP TABLE dbTableName'
        # sql_text = (
        #     'DROP TABLE ' + dbTableName + '('
        #         column_name_1 + ' ' + column_type_1 + ' NOT NULL AUTO_INCREMENT,'
        #         column_name_2 + ' ' + column_type_2 + ' NOT NULL,'
        #         column_name_3 + ' ' + column_type_3 + ' NOT NULL,'
        #         column_name_4 + ' ' + column_type_4 + ','
        #         PRIMARY KEY ( column_name_1 )  # 指定主鍵;
        #     ')'
        # )

        if dbTableName == "":
            sql_text = request_POST_String

        if dbTableName != "":
            # sql_text = 'DROP TABLE ' + dbTableName
            sql_text = f'DROP TABLE {dbTableName}'

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/insertOne":

        sql_text = ""
        # sql_text = 'INSERT INTO dbTableName(column_name_1,column_name_2,column_name_3,column_name_4) VALUES(column_value_1,column_value_2,column_value_3,column_value_4)'
        # sql_text = (
        #     'INSERT INTO ' + dbTableName + '('
        #         column_name_1 + ','
        #         column_name_2 + ','
        #         column_name_3 + ','
        #         column_name_4
        #     ') VALUES ('
        #         column_value_1 + ','
        #         column_value_2 + ','
        #         column_value_3 + ','
        #         column_value_4
        #     ')'
        # )

        if dbTableName == "":
            sql_text = request_POST_String

        if dbTableName != "":
            # sql_text = 'INSERT INTO ' + dbTableName + request_POST_String
            sql_text = f'INSERT INTO {dbTableName} {request_POST_String}'

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/insertMany":

        request_POST_Array = []
        request_POST_Array = json.loads(request_POST_String)

        sql_text = ""
        # sql_text = 'INSERT INTO dbTableName(column_name_1,column_name_2,column_name_3,column_name_4) VALUES(%s,%s,%s,%s)'
        # Cursor.executemany('INSERT INTO dbTableName(column_name_1,column_name_2,column_name_3,column_name_4) VALUES(%s,%s,%s,%s)', [(column_value_11,column_value_12,column_value_13,column_value_14),(column_value_21,column_value_22,column_value_23,column_value_24),(column_value_31,column_value_32,column_value_33,column_value_34)])

        if dbTableName == "":
            sql_text = request_POST_Array[0]

        if dbTableName != "":
            # sql_text = 'INSERT INTO ' + dbTableName + request_POST_Array[0]
            sql_text = f'INSERT INTO {dbTableName}{request_POST_Array[0]}'

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.executemany(sql_text, request_POST_Array[1])  # Cursor.executemany('INSERT INTO dbTableName(column_name_1,column_name_2,column_name_3,column_name_4) VALUES(%s,%s,%s,%s)', [(column_value_11,column_value_12,column_value_13,column_value_14),(column_value_21,column_value_22,column_value_23,column_value_24),(column_value_31,column_value_32,column_value_33,column_value_34)])
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/delete":

        sql_text = ""
        # sql_text = 'DELETE FROM dbTableName WHERE column_name_1=column_value_1 AND column_name_2=column_value_2'

        if dbTableName == "":
            sql_text = request_POST_String

        if dbTableName != "":
            # sql_text = 'DELETE FROM ' + dbTableName + ' WHERE ' + request_POST_String
            sql_text = f'DELETE FROM {dbTableName} WHERE {request_POST_String}'

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/update":

        sql_text = ""
        # sql_text = 'UPDATE dbTableName SET column_name_1=new_column_value_1,column_name_2=new_column_value_2,column_name_3=new_column_value_3,column_name_4=new_column_value_4 WHERE column_name_1=column_value_1 AND column_name_2=column_value_2'

        if dbTableName == "":
            sql_text = request_POST_String

        if dbTableName != "":
            # sql_text = 'UPDATE ' + dbTableName + ' ' + request_POST_String
            sql_text = f'UPDATE {dbTableName} {request_POST_String}'

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/find":

        sql_text = ""
        # sql_text = 'SELECT * FROM dbTableName WHERE column_name_1=? AND column_name_2=?'
        # sql_text = 'SELECT column_value_1,column_value_2 FROM dbTableName WHERE column_name_1=? AND column_name_2=?'

        if dbTableName != "":
            # sql_text = 'SELECT * FROM ' + dbTableName
            sql_text = f'SELECT * FROM {dbTableName}'

        if dbTableName == "":
            sql_text = request_POST_String

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    elif request_Path == "/countDocuments":

        sql_text = ""
        # sql_text = 'SELECT COUNT(*) FROM dbTableName'
        # sql_text = 'SELECT COUNT(*) FROM dbTableName WHERE column_name_1=column_value_1 AND column_name_2=column_value_2'

        if dbTableName != "":
            # sql_text = 'SELECT COUNT(*) FROM ' + dbTableName
            sql_text = f'SELECT COUNT(*) FROM {dbTableName}'

        if dbTableName == "":
            sql_text = request_POST_String

        # # Connect to MariaDB Platform;
        # try:
        #     # 建立數據庫鏈接
        #     Connection = mariadb.connect(
        #         user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        #         host = "192.0.2.1",
        #         port = 3306,
        #         database = "employees"
        #     )
        #     # # 獲取鏈接結果;
        #     # if not Connection:
        #     #     print("Error connecting to MariaDB Platform.")
        #     #     sys.exit(1)
        # except mariadb.Error as err:
        #     print(f"Error connecting to MariaDB Platform: {err}")
        #     sys.exit(1)

        # # 獲取游標對象 Get Cursor;
        # Cursor = Connection.cursor()

        # 捕捉异常，对于您的任何 SQL 操作（查询、更新、删除或插入记录），您都应该尝试捕获错误，以便您可以验证您的操作是否按预期执行，并且您在出现任何问题时都知道。要捕获错误，请使用 Error 类：
        try:
            # 執行 SQL 語句;
            Cursor.execute(sql_text)
            # 提交到數據庫執行;
            Connection.commit()
            # 獲取執行結果;
            # print(Cursor.fetchall())
            # response_data_String = Cursor.fetchone()
            response_data_String = Cursor.fetchall()
            # for one in response_data_String:
            #     print(one)
        except mariadb.Error as err: 
            print(f"Error: {err}")
            response_data_String = f"Error: {err}"
            # 發生錯誤時回滾;
            Connection.rollback()
        # 如果try上述代码的子句中的查询失败，MariaDB Server 会返回一个 SQL 异常，该异常在except 中被捕获并打印到 stdout。当您使用数据库时，这种捕获异常的编程最佳实践尤其重要，因为您需要确保信息的完整性。

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()

        return response_data_String

    else:

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        web_path_index_Html = str(os.path.join(str(webPath), "index.html"))
        file_data = ""

        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 同步讀取硬盤文檔，返回字符串;
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(request_Path) + " } cannot modify to read and write permission."
                    # response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String


            # # 用讀取字符串的形式讀取純文本文檔;
            # fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # # fd = open(web_path, mode="rb+")
            # try:
            #     file_data = fd.read()
            #     # file_data = fd.read().decode("utf-8")
            #     # data_Bytes = file_data.encode("utf-8")
            #     # fd.write(data_Bytes)
            # except FileNotFoundError:
            #     print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
            #     # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            #     response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
            #     # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
            #     response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String
            # except PersmissionError:
            #     print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
            #     # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
            #     response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 沒有打開權限."
            #     # response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
            #     response_data_Dict["error"] = "File = { " + str(request_Path) + " } unable to read."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String
            # except Exception as error:
            #     if("[WinError 32]" in str(error)):
            #         print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
            #         print(f'Error: {str(web_path)} : {error.strerror}')
            #         # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法讀取數據."
            #         # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'
            #         # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #         # 使用加號（+）拼接字符串;
            #         # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #         # print(response_data_String)
            #         return response_data_String
            #     else:
            #         print(f'Error: {str(web_path)} : {error.strerror}')
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
            #         response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #         # 使用加號（+）拼接字符串;
            #         # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #         # print(response_data_String)
            #         return response_data_String
            # finally:
            #     fd.close()
            # # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


            # 用讀取字節流數組的形式讀取二進制文檔;
            fd = open(web_path, mode="rb+", buffering=-1)
            # fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            try:
                file_data_bytes_String = fd.read()
                # file_data_bytes_String.decode("utf-8")  # 二進制字節流轉字符串;
                file_data_integer_Tuple = struct.unpack('B' * len(file_data_bytes_String), file_data_bytes_String)
                # bytes(int(file_data_integer_Tuple[i]), "utf-8")
                # struct.pack('B', int(file_data_integer_Tuple[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
                # str(file_data_integer_Tuple[i]).encode("utf-8")  # 字符串轉二進制字節流;
                file_data_integer_Array = []
                for i in range(0, int(len(file_data_integer_Tuple))):
                    file_data_integer_Array.append(int(file_data_integer_Tuple[i]))
                file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
                # file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象;
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                response_data_Dict["error"] = "File = { " + str(request_Path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


            response_data_String = str(file_data)
            # # 替換 .html 文檔中指定的位置字符串;
            # if file_data != "":
            #     # response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            # else:
            #     # response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            #     response_data_Dict["Server_say"] = "文檔: " + str(request_Path) + " 爲空."
            #     # response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            #     response_data_Dict["error"] = "File ( " + str(request_Path) + " ) empty."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String

            return response_data_String

        elif os.path.exists(web_path) and pathlib.Path(web_path).is_dir():

            directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

            # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(request_Path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(web_path)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(web_path))
            # if len(os.listdir(web_path)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(web_path), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:

            # 同步讀取硬盤 .html 文檔，返回字符串;
            if os.path.exists(web_path_index_Html) and os.path.isfile(web_path_index_Html):

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path_index_Html, os.R_OK) and os.access(web_path_index_Html, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path_index_Html, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path_index_Html, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path_index_Html, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path_index_Html, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path_index_Html, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        print("請求的文檔 [ " + str(web_path_index_Html) + " ] 無法修改為可讀可寫權限.")

                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } cannot modify to read and write permission."

                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                fd = open(web_path_index_Html, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
                # fd = open(web_path_index_Html, mode="rb+")
                try:
                    file_data = fd.read()
                    # file_data = fd.read().decode("utf-8")
                    # data_Bytes = file_data.encode("utf-8")
                    # fd.write(data_Bytes)
                except FileNotFoundError:
                    print("請求的文檔 [ " + str(web_path_index_Html) + " ] 不存在.")
                    response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別."
                    response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unrecognized."
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                except PersmissionError:
                    print("請求的文檔 [ " + str(web_path_index_Html) + " ] 沒有打開權限.")
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 沒有打開權限."
                    response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unable to read."
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                except Exception as error:
                    if("[WinError 32]" in str(error)):
                        print("請求的文檔 [ " + str(web_path_index_Html) + " ] 無法讀取數據.")
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 無法讀取數據."
                        response_data_Dict["error"] = f'Error: {str(web_path_index_Html)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
                    else:
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 讀取數據發生錯誤."
                        response_data_Dict["error"] = f'Error: {str(web_path_index_Html)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
                finally:
                    fd.close()
                # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

            else:

                print("請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別.")

                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unrecognized."

                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String


            # 替換 .html 文檔中指定的位置字符串;
            if file_data != "":
                response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            else:
                response_data_Dict["Server_say"] = "文檔: " + str(web_path_index_Html) + " 爲空."
                response_data_Dict["error"] = "File ( " + str(web_path_index_Html) + " ) empty."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String

            return response_data_String

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
            response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        # return response_data_String


# Python 自定義類時，類名第一個字母需要大寫，并且不能有參數;
class http_Server:
    # 可變參數
    # def Function(*args, **kwargs)  Function(a, b, c, a=1, b=2, c=3)
    # a --int
    # *args --tuple  args == (a, b, c)
    # **kwargs -- dict  kwargs == {'a': 1, 'b': 2, 'c': 3}

    # 在 Python 類 class 中的 def __init__(self) 函數，可以用於配置需要從類外部傳入的參數，預設會將實例化類時傳入的參數複製到這個函數中，並，在類啓動時先運行一下這個函數;
    def __init__(self, **kwargs):

        # 檢查函數需要用到的 Python 原生模組是否已經載入(import)，如果還沒載入，則執行載入操作;
        imported_package_list = dir(list)
        if not("os" in imported_package_list):
            import os  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("sys" in imported_package_list):
            import sys  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("signal" in imported_package_list):
            import signal  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("stat" in imported_package_list):
            import stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("platform" in imported_package_list):
            import platform  # 加載Python原生的與平臺屬性有關的模組;
        if not("subprocess" in imported_package_list):
            import subprocess  # 加載Python原生的創建子進程模組;
        if not("string" in imported_package_list):
            import string  # 加載Python原生的字符串處理模組;
        if not("datetime" in imported_package_list):
            import datetime  # 加載Python原生的日期數據處理模組;
        if not("time" in imported_package_list):
            import time  # 加載Python原生的日期數據處理模組;
        if not("json" in imported_package_list):
            import json  # import the module of json. 加載Python原生的Json處理模組;
        if not("re" in imported_package_list):
            import re  # 加載Python原生的正則表達式對象
        # if not("tempfile" in imported_package_list):
        #     import tempfile  # from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
        if not("pathlib" in imported_package_list):
            import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
        # if not("shutil" in imported_package_list):
        #     import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
        if not("multiprocessing" in imported_package_list):
            import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
        if not("threading" in imported_package_list):
            import threading  # 加載Python原生的支持多綫程（執行緒）模組;
        if not("inspect" in imported_package_list):
            import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型，以及用於强制終止綫程;
        if not("ctypes" in imported_package_list):
            import ctypes  # 用於强制終止綫程;
        if not("socketserver" in imported_package_list):
            import socketserver  # from socketserver import ThreadingMixIn  #, ForkingMixIn
        if not("urllib" in imported_package_list):
            import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
        if not("http.client" in imported_package_list):
            import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
        if not("http.server" in imported_package_list):
            # from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
            import http.server
            # https: // docs.python.org/3/library/http.server.html
        if not("cookiejar" in imported_package_list):
            from http import cookiejar  # 用於處理請求Cookie;
        if not("ssl" in imported_package_list):
            import ssl  # 用於處理請求證書驗證;
        if not("base64" in imported_package_list):
            import base64  # 加載加、解密模組;

        # # 檢查函數需要用到的 Python 第三方模組是否已經安裝成功(pip install)，如果還沒安裝，則執行安裝操作;
        # if "os" in dir(list):
        #     installed_package_list = os.popen("pip list").read()
        # if isinstance(installed_package_list, list) and not("Flask" in installed_package_list):
        #     os_popen_read = os.popen("pip install Flask --trusted-host -i https://pypi.tuna.tsinghua.edu.cn/simple").read()
        #     print(os_popen_read)

        # 配置預設值;
        # os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
        # os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
        self.host = "0.0.0.0"
        self.port = int(8000)  # 監聽埠號 1 ~ 65535;
        self.Is_multi_thread = False
        self.Key = ""  # "username:password"
        self.Session = {}
        self.do_Function = self.temp_default_doFunction  # None 或匿名函數 lambda arguments: arguments
        # 用於判斷監聽創建子進程池數目的參數;
        self.number_Worker_process = int(0)  # 子進程數目默認 0 個;

        # 讀取傳入的服務器主機 IP 參數;
        if "host" in kwargs:
            self.host = str(kwargs["host"])  # "localhost" "0.0.0.0" "127.0.0.1"

        # 讀取傳入的服務器監聽端口號碼參數;
        if "port" in kwargs:
            self.port = int(kwargs["port"])  # 8000 監聽埠號 1 ~ 65535;

        # 讀取傳入的判斷監聽服務器是否使用多綫程啓動參數;
        if "Is_multi_thread" in kwargs:
            # True 多綫程啓動服務器，False 單綫程啓動服務器;
            self.Is_multi_thread = bool(kwargs["Is_multi_thread"])

        # 讀取傳入的預設的網站訪問密碼字符串;
        if "Key" in kwargs:
            self.Key = str(kwargs["Key"])  # "username:password" 訪問網站簡單驗證用戶名和密碼;

        # 用於判斷監聽創建子進程池數目的參數  and isinstance(number_Worker_process, str);
        if "number_Worker_process" in kwargs:
            self.number_Worker_process = int(kwargs["number_Worker_process"])  # 子進程數目默認 0 個;

        if "do_Function" in kwargs and inspect.isfunction(kwargs["do_Function"]):
            self.do_Function = kwargs["do_Function"]

        # 具體處理數據的函數;
        # self.do_Function = None
        if "do_Function_obj" in kwargs and isinstance(kwargs["do_Function_obj"], dict) and any(kwargs["do_Function_obj"]):
            # isinstance(do_Function_obj, dict) type(do_Function_obj) == dict do_Function_obj != {} any(do_Function_obj)
            for key in kwargs["do_Function_obj"]:
                # isinstance(do_Function_obj[key], FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                if key == "do_Function" and inspect.isfunction(kwargs["do_Function_obj"][key]):
                    self.do_Function = kwargs["do_Function_obj"][key]

        # 傳入服務器 Session 參數;
        # self.Session = {}
        if "Session" in kwargs and isinstance(kwargs["Session"], dict):
            # isinstance(return_obj, dict) type(return_obj) == dict return_obj != {} any(return_obj)
            self.Session = kwargs["Session"]
        elif "Session" in kwargs and isinstance(kwargs["Session"], str) and self.check_json_format(kwargs["Session"]):
            self.Session = json.loads(kwargs["Session"])

        self.total_worker_called_number = {}  # 預設的全局變量，記錄進程池中每個子進程被調用運算具體處理數據的纍加總次數;

    # 預設的可能被推入子進程執行功能的函數，可以在類實例化的時候輸入參數修改;
    def temp_default_doFunction(self, arguments):
        return arguments

    # 自定義封裝的函數check_json_format(raw_msg)用於判斷是否為JSON格式的字符串;
    def check_json_format(self, raw_msg):
        """
        用於判斷一個字符串是否符合 JSON 格式
        :param self:
        :return:
        """
        if isinstance(raw_msg, str):  # 首先判斷傳入的參數是否為一個字符串，如果不是直接返回false值
            try:
                json.loads(raw_msg)  # , encoding='utf-8'
                return True
            except ValueError:
                return False
        else:
            return False

    # 進程池中的執行函數;
    def pool_func(self, request_data_JSON, do_Function):
        # request_data_JSON == {
        #     "Client_IP": Client_IP,
        #     "request_Url": request_Url,
        #     # "request_Path": request_Path,
        #     "require_Authorization": self.request_Key,
        #     "require_Cookie": self.Cookie_value,
        #     # "Server_Authorization": Key,
        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
        #     "request_body_string": request_form_value
        # }
        # print(type(request_data_JSON))
        # print(request_data_JSON)

        Client_IP = request_data_JSON["Client_IP"]
        request_Url = request_data_JSON["request_Url"]
        # request_Url = request_Url.decode('utf-8')
        # request_Path = request_data_JSON["request_Path"]
        # request_Path = request_Path.decode('utf-8')
        require_Authorization = request_data_JSON["require_Authorization"]
        require_Cookie = request_data_JSON["require_Cookie"]
        # Server_Authorization = request_data_JSON["Server_Authorization"]
        request_body_string = request_data_JSON["request_body_string"]
        # request_body_string = request_body_string.decode('utf-8')

        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
        if do_Function != None and hasattr(do_Function, '__call__'):
            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
            do_Function_return = do_Function(request_data_JSON)  # 最終發送的響應體字符串;

            if isinstance(do_Function_return, dict):
                # print("子進程函數 do_Function() 處理數據的返回值是一個 JSON 對象，不符合 http 協議傳送的合法類型字符串.")
                # response_Body_String = json.dumps(do_Function_return)  # 最終發送的響應體字符串;
                # # check_json_format(response_Body_JSON);
                # # String = json.dumps(JSON); JSON = json.loads(String);
                response_Body_String = request_body_string  # 最終發送的響應體字符串;

            elif isinstance(do_Function_return, str):
                response_Body_String = do_Function_return

            else:
                print("子進程函數 do_Function() 處理數據的返回值無法識別.")
                response_Body_JSON = {
                    "Client_IP": Client_IP,  # 127.0.0.1
                    "request_Url": request_Url,  # "/"
                    # "request_Path": request_Path,  # "/"
                    "require_Authorization": require_Authorization,  # "username:password",
                    "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                    # "Server_Authorization": Server_Authorization,  # "username:password",
                    "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                    "Server_say": do_Function_return
                }
                # check_json_format(response_Body_JSON);
                # String = json.dumps(JSON); JSON = json.loads(String);
                response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                # return do_Function_return  
                  
        else:
            # response_Body_JSON = {
            #     "Client_IP": Client_IP,  # 127.0.0.1
            #     "request_Url": request_Url,  # "/"
            #     # "request_Path": request_Path,  # "/"
            #     "require_Authorization": require_Authorization,  # "username:password",
            #     "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
            #     # "Server_Authorization": Server_Authorization,  # "username:password",
            #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
            #     "Server_say": request_body_string
            # }
            # # check_json_format(response_Body_JSON);
            # # String = json.dumps(JSON); JSON = json.loads(String);
            # response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
            response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;
    
        result_JSON = {
            "process_pid": multiprocessing.current_process().pid,  # 推入該次調用子進程的 pid 號碼;
            "thread_ident": threading.current_thread().ident,  # 推入該次調用子進程中執行緒的 id 號碼;
            "response_Body_String": response_Body_String
        }

        return result_JSON

    # 子進程中的初始化預設值（默認值）配置函數;
    def initializer(self):
        """Ignore SIGINT in child workers. 忽略子進程中的信號."""
        # 忽略子進程中的信號，不然鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，會報 Traceback (most recent call last) 和 KeyboardInterrupt 的錯誤;
        # 忽略子進程中的信號，不然鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，會報 Traceback (most recent call last) 和 KeyboardInterrupt 的錯誤;
        signal.signal(signal.SIGINT, signal.SIG_IGN)

    # 自定義的，進程池啓動子進程時用於引用的回調函數 apply_async_func_return = pool.apply_async(func=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), callback=cb)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
    def pool_call_back(self, apply_async_func_return):

        # if isinstance(apply_async_func_return, dict):
        #     # apply_async_func_return = apply_async_func_return.get(timeout=None)
        #     # 判斷某個JSON對象中是否存在某個key值，使用：JSON.has_key(key) 或者 key in JSON 方法;
        #     if "response_Body_String" in apply_async_func_return:
        #         response_Body_String = apply_async_func_return["response_Body_String"]
        #     else:
        #         print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["response_Body_String"] 無法識別.')
        #         response_Body_String = json.dumps(apply_async_func_return)
        #         # response_Body_String = request_body_string

        #     if "process_pid" in apply_async_func_return:
        #         processing_return_pid = apply_async_func_return["process_pid"]
        #     else:
        #         print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["process_pid"] 無法識別.')
        #         processing_return_pid = ""

        #     if "thread_ident" in apply_async_func_return:
        #         processing_return_thread_ident = apply_async_func_return["thread_ident"]
        #     else:
        #         print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["thread_ident"] 無法識別.')
        #         processing_return_thread_ident = ""

        # elif isinstance(apply_async_func_return, str):
        #     print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
        #     response_Body_String = apply_async_func_return
        #     processing_return_pid = ""
        #     processing_return_thread_ident = ""
        #     # return apply_async_func_return

        # else:
        #     print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
        #     response_Body_JSON = {
        #         "Client_IP": Client_IP,  # 127.0.0.1
        #         "request_Url": request_Url,  # "/"
        #         # "request_Path": request_Path,  # "/"
        #         "require_Authorization": require_Authorization,  # "username:password",
        #         "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
        #         # "Server_Authorization": Server_Authorization,  # "username:password",
        #         "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
        #         "Server_say": apply_async_func_return
        #     }
        #     # check_json_format(response_Body_JSON);
        #     # String = json.dumps(JSON); JSON = json.loads(String);
        #     response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
        #     # response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;
        #     processing_return_pid = ""
        #     processing_return_thread_ident = ""
        #     # return apply_async_func_return

        # # 記錄每個被調用的子進程的纍加總次數;
        # if isinstance(total_worker_called_number, dict):
        #     if str(processing_return_pid) in total_worker_called_number:
        #         # isinstance(total_worker_called_number, dict) and str(apply_async_func_return.get(timeout=None)[1]) in total_worker_called_number
        #         total_worker_called_number[str(processing_return_pid)] = int(total_worker_called_number[str(processing_return_pid)]) + int(1)
        #     else:
        #         total_worker_called_number[str(processing_return_pid)] = int(1)

        # return (response_Body_String, processing_return_pid)
        return apply_async_func_return

    # 自定義的，進程池子進程運行出現異常時的回調函數;
    def error_pool_call_back(self, error):
        print(error)
        return error

    def Server(self, host, port, Is_multi_thread, Key, Session, do_Function, number_Worker_process, process_Pool, pool_func, pool_call_back, error_pool_call_back, total_worker_called_number):

        # 服務器接收到請求信息後的執行函數;
        def dispatch_func(request_data_JSON, do_Function):
            # request_data_JSON == {
            #     "Client_IP": Client_IP,
            #     "request_Url": request_Url,
            #     # "request_Path": request_Path,
            #     "require_Authorization": self.request_Key,
            #     "require_Cookie": self.Cookie_value,
            #     # "Server_Authorization": Key,
            #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
            #     "request_body_string": request_form_value
            # }

            # print(type(request_data_JSON))
            # print(request_data_JSON)

            request_Url = request_data_JSON["request_Url"]
            # request_Url = request_Url.decode('utf-8')
            # request_Path = request_data_JSON["request_Path"]
            # request_Path = request_Path.decode('utf-8')
            Client_IP = request_data_JSON["Client_IP"]
            require_Authorization = request_data_JSON["require_Authorization"]
            require_Cookie = request_data_JSON["require_Cookie"]
            # Server_Authorization = request_data_JSON["Server_Authorization"]
            request_body_string = request_data_JSON["request_body_string"]
            # request_body_string = request_body_string.decode('utf-8')

            if number_Worker_process > 0 and process_Pool != None:
                # 函數 process_Pool.apply_async(func=, args=(,), kwds={}, callback=, error_callback=) 中的執行函數 func 和 callback 只能接受最外層的函數，不能是嵌套的内層函數;
                apply_async_func_return = process_Pool.apply_async(func=pool_func, args=(request_data_JSON, do_Function), kwds={}, callback=pool_call_back, error_callback=error_pool_call_back)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
                # args == (
                #     request_data_JSON == {
                #         "Client_IP": Client_IP,
                #         "request_Url": request_Url,
                #         # "request_Path": request_Path,
                #         "require_Authorization": self.request_Key,
                #         "require_Cookie": self.Cookie_value,
                #         # "Server_Authorization": Key,
                #         "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                #         "request_body_string": request_form_value
                #     },
                #     do_Function
                # )
                # print(apply_async_func_return.get(timeout=None))
                # print(apply_async_func_return.ready())
                # print(apply_async_func_return.successful())

                Data_JSON = apply_async_func_return.get(timeout=None)

                if isinstance(Data_JSON, dict):
                    # Data_JSON = apply_async_func_return.get(timeout=None)
                    # 判斷某個JSON對象中是否存在某個key值，使用：JSON.has_key(key) 或者 key in JSON 方法;
                    if "response_Body_String" in Data_JSON:
                        response_Body_String = Data_JSON["response_Body_String"]
                    else:
                        print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["response_Body_String"] 無法識別.')
                        response_Body_String = json.dumps(Data_JSON)
                        # response_Body_String = request_body_string

                    if "process_pid" in Data_JSON:
                        processing_return_pid = Data_JSON["process_pid"]
                    else:
                        print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["process_pid"] 無法識別.')
                        processing_return_pid = ""

                    if "thread_ident" in Data_JSON:
                        processing_return_thread_ident = Data_JSON["thread_ident"]
                    else:
                        print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["thread_ident"] 無法識別.')
                        processing_return_thread_ident = ""

                elif isinstance(Data_JSON, str):
                    print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
                    response_Body_String = Data_JSON
                    processing_return_pid = ""
                    processing_return_thread_ident = ""
                    # return apply_async_func_return

                else:
                    print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
                    response_Body_JSON = {
                        "Client_IP": Client_IP,  # 127.0.0.1
                        "request_Url": request_Url,  # "/"
                        # "request_Path": request_Path,  # "/"
                        "require_Authorization": require_Authorization,  # "username:password",
                        "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                        # "Server_Authorization": Server_Authorization,  # "username:password",
                        "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        "Server_say": Data_JSON
                    }
                    # check_json_format(response_Body_JSON);
                    # String = json.dumps(JSON); JSON = json.loads(String);
                    response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                    # response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;
                    processing_return_pid = ""
                    processing_return_thread_ident = ""
                    # return apply_async_func_return

                # 記錄每個被調用的子進程的纍加總次數;
                if isinstance(total_worker_called_number, dict):
                    if str(processing_return_pid) in total_worker_called_number:
                        # isinstance(total_worker_called_number, dict) and str(apply_async_func_return.get(timeout=None)[1]) in total_worker_called_number
                        total_worker_called_number[str(processing_return_pid)] = int(total_worker_called_number[str(processing_return_pid)]) + int(1)
                    else:
                        total_worker_called_number[str(processing_return_pid)] = int(1)

            if number_Worker_process <= 0 or process_Pool == None:

                # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                if do_Function != None and hasattr(do_Function, '__call__'):
                    # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                    # response_Body_String = do_Function(request_data_JSON)  # 最終發送的響應體字符串;
                    # processing_return_pid = multiprocessing.current_process().pid

                    do_Function_return = do_Function(request_data_JSON)  # 最終發送的響應體字符串;
                    if isinstance(do_Function_return, dict):
                        # print("子進程函數 do_Function() 處理數據的返回值是一個 JSON 對象，不符合 http 協議能夠傳送的合法類型字符串.")
                        # response_Body_String = json.dumps(do_Function_return)  # 最終發送的響應體字符串;
                        # # check_json_format(response_Body_JSON);
                        # # String = json.dumps(JSON); JSON = json.loads(String);
                        response_Body_String = request_body_string  # 最終發送的響應體字符串;

                    elif isinstance(do_Function_return, str):
                        response_Body_String = do_Function_return

                    else:
                        print("子進程函數 do_Function() 處理數據的返回值無法識別.")
                        response_Body_JSON = {
                            "Client_IP": Client_IP,  # 127.0.0.1
                            "request_Url": request_Url,  # "/"
                            # "request_Path": request_Path,  # "/"
                            "require_Authorization": require_Authorization,  # "username:password",
                            "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                            # "Server_Authorization": Server_Authorization,  # "username:password",
                            "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                            "Server_say": do_Function_return
                        }
                        # check_json_format(response_Body_JSON);
                        # String = json.dumps(JSON); JSON = json.loads(String);
                        response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                        # return do_Function_return

                else:
                    # response_Body_JSON = {
                    #     "Client_IP": Client_IP,  # 127.0.0.1
                    #     "request_Url": request_Url,  # "/"
                    #     # "request_Path": request_Path,  # "/"
                    #     "require_Authorization": require_Authorization,  # "username:password",
                    #     "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                    #     # "Server_Authorization": Server_Authorization,  # "username:password",
                    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                    #     "Server_say": request_body_string
                    # }
                    # # check_json_format(response_Body_JSON);
                    # # String = json.dumps(JSON); JSON = json.loads(String);
                    # response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                    response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;

                processing_return_pid = multiprocessing.current_process().pid
                processing_return_thread_ident = threading.current_thread().ident

                # 記錄每個被調用的子進程的纍加總次數;
                if isinstance(total_worker_called_number, dict):
                    if str(processing_return_pid) in total_worker_called_number:
                        # isinstance(total_worker_called_number, dict) and str(apply_async_func_return.get(timeout=None)[1]) in total_worker_called_number
                        total_worker_called_number[str(processing_return_pid)] = int(total_worker_called_number[str(processing_return_pid)]) + int(1)
                    else:
                        total_worker_called_number[str(processing_return_pid)] = int(1)

            return (response_Body_String, processing_return_pid)

        # BaseHTTPRequestHandler 官網源碼: https://github.com/python/cpython/blob/3.6/Lib/http/server.py
        class Resquest(BaseHTTPRequestHandler):

            request_Key = ""
            Cookie_value = ""
            Session_ID = ""
            response_Body_String_len = 0
            processing_return_pid = multiprocessing.current_process().pid

            # # BaseHTTPRequestHandler.handle(self)
            # def handle(self):
            #     """
            #     Handle multiple requests if necessary.
            #     """
            #     self.close_connection = True
            #     self.handle_one_request()
            #     while not self.close_connection:
            #         self.handle_one_request()

            # # BaseHTTPRequestHandler.handle_one_request(self)
            # def handle_one_request(self):
            #     """
            #     Handle a single HTTP request.
            #     You normally don't need to override this method; see the class __doc__ string for information on how to handle specific HTTP commands such as GET and POST.
            #     """
            #     try:
            #         self.raw_requestline = self.rfile.readline(65537)
            #         if len(self.raw_requestline) > 65536:
            #             self.requestline = ''
            #             self.request_version = ''
            #             self.command = ''
            #             self.send_error(HTTPStatus.REQUEST_URI_TOO_LONG)
            #             return
            #         if not self.raw_requestline:
            #             self.close_connection = True
            #             return
            #         if not self.parse_request():
            #             # An error code has been sent, just exit
            #             return
            #         mname = 'do_' + self.command
            #         if not hasattr(self, mname):
            #             self.send_error(HTTPStatus.NOT_IMPLEMENTED, "Unsupported method (%r)" % self.command)
            #             return
            #         method = getattr(self, mname)
            #         method()
            #         self.wfile.flush() #actually send the response if not already done.
            #     except socket.timeout as e:
            #         #a read or a write timed out.  Discard this connection
            #         self.log_error("Request timed out: %r", e)
            #         self.close_connection = True
            #         return

            # BaseHTTPRequestHandler.log_message(self, format, *args)
            def log_message(self, format, *args):
                """
                Log an arbitrary message.
                This is used by all other logging functions.  Override it if you have specific logging wishes.
                The first argument, FORMAT, is a format string for the message to be logged.  If the format string contains any % escapes requiring parameters, they should be specified as subsequent arguments (it's just like printf!).
                The client ip and current date/time are prefixed to every message.
                """
                # log_text = "Main process-" + str(multiprocessing.current_process().pid) + " listening server Worker thread-" + str(threading.current_thread().ident) + " doFunction Worker process-" + str(self.processing_return_pid) + " " + "%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), format % args)
                log_text = "listening server Worker thread-" + str(threading.current_thread().ident) + " doFunction Worker process-" + str(self.processing_return_pid) + " " + "%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), format % args)
                # sys.stderr.write("%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), format%args))
                sys.stderr.write(log_text)
                # print(log_text)

            # 配置多綫程響應監聽到的請求;
            # def process_request_thread(self, request, client_address):
            #     try:
            #         self.finish_request(request, client_address)
            #         self.shutdown_request(request)
            #     except:
            #         self.handle_error(request, client_address)
            #         self.shutdown_request(request)

            # def process_request(self, request, client_address):
            #     thread = threading.Thread(target=self.process_request_thread, args=(request, client_address))
            #     thread.daemon = True
            #     # threadName = thread.getName()  # 返回綫程thread的名字;
            #     # # threads.append(thread)  # 添加綫程thread到綫程列表threads;
            #     thread.start()

            # 配通過密碼驗證之後置響應頭;
            def do_HEAD(self):
                # print("response verified Header:")
                statusMessage_CN = "請求成功"
                statusMessage_EN = "OK."
                statusMessage = str(base64.b64encode(bytes(statusMessage_CN, encoding="utf-8"), altchars=None), encoding="utf-8") + " " + statusMessage_EN
                self.send_response(200, message=statusMessage)  # , message=None;
                # self.send_header('Www-Authenticate', 'Basic realm=\"domain name -> username:password\"')  # 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                self.send_header("Allow", "GET, POST, HEAD, PATCH")  # 服務器能接受的請求方式;
                # 服務器發送響應數據的類型及編碼方式
                self.send_header('Content-Type', 'text/html; charset=utf-8')  # self.send_header('Content-Type', 'text/html, text/plain; charset=utf-8')
                self.send_header('Content-Length', self.response_Body_String_len)  # 服務器發送的響應數據長度 response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                self.send_header('Content-Language', 'zh-Hant-TW; q=0.8, zh-Hant; q=0.7, zh-Hans-CN; q=0.7, zh-Hans; q=0.5, en-US, en; q=0.3')  # 服務器發送響應的自然語言類型;
                # self.send_header('Content-Encoding', 'gzip')  # 服務器發送響應的壓縮類型;
                # self.send_header('Expires', '100-continue header')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Cache-Control', 'no-cache')  # 'max-age=0' 或 no-store, must-revalidate 設置不允許瀏覽器緩存，必須刷新數據;
                # self.send_header('Pragma', 'no-cache')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Connection', 'close')  # 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                server_info = "Python_http.server(HTTPServer+BaseHTTPRequestHandler)"
                # server_info = "Python " + str(platform.python_version()) + "_http.server(HTTPServer+BaseHTTPRequestHandler)_" + str(platform.system())  # platform.platform()，platform.python_compiler() 獲取當前 Python 解釋器的信息;
                # print(server_info)
                self.send_header('Server', server_info)  # web 服務器名稱版本信息;
                # self.send_header('Refresh', '1;url=http://localhost:8000/')  # 服務端要求客戶端1秒鐘後刷新頁面，然後訪問指定的頁面路徑;
                # self.send_header('Content-Disposition', 'attachment; filename=Test.zip')  # 服務端要求客戶端以下載文檔的方式打開該文檔;
                # self.send_header('Transfer-Encoding', 'chunked')  # 以數據流形式分塊發送響應數據到客戶端;
                # self.send_header('Date', datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 服務端向客戶端返回響應的時間;
                self.send_header("Access-Control-Allow-Methods", "GET, POST, HEAD, PATCH")
                self.send_header('Access-Control-Allow-Origin', '*')  # 設置允許跨域訪問;
                self.send_header('Access-Control-Allow-Headers', 'content-type, Accept')
                self.send_header('Access-Control-Allow-Credentials', 'true')
                # self.send_header('Content-MD5', 'Q2hlY2sgSW50ZWdyaXR5IQ==')  # 返回實體 MD5 加密的校驗值;
                # Set-Cookie:name=value [ ;expires=date][ ;domain=domain][ ;path=path][ ;secure];
                # 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
                # 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
                # 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
                # 參數value部分，通常是一個name = value格式的字串，通常性的使用方式是以name = value的格式來指定cookie的值；
                # 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
                after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")  # 計算 30 日之後的日期;
                # print(after_30_Days)  # 打印30天之後的日期 datetime.datetime.now().date().strftime("%Y-%m-%d %H:%M:%S.%f")，datetime.date.today();
                cookieName = 'Session_ID=' + str(base64.b64encode(bytes('request_Key->' + str(self.request_Key), encoding="utf-8"), altchars=None), encoding="utf-8")
                # cookie_string = 'session_id=' + str(self.request_Key.split(":", -1)[0], encoding="utf-8") + ',request_Key->' + str(self.request_Key, encoding="utf-8") + '; expires=' + str(after_30_Days, encoding="utf-8") + '; domain=abc.com; path=/; HTTPOnly;'  # 拼接 cookie 字符串值;
                cookie_string = cookieName + '; expires=' + str(after_30_Days) + '; path=/;'  # 拼接 cookie 字符串值;
                # print(cookie_string)
                self.send_header('Set-Cookie', cookie_string)  # 設置 Cookie;
                self.end_headers()

            # 配置未驗證之前的響應頭（發送驗證賬號密碼輸入框）;
            def do_AUTHHEAD(self):
                # print("response verifying Header:")
                statusMessage_CN = "服務器要求客戶端身份驗證出具賬號密碼"
                statusMessage_EN = "Unauthorized."
                statusMessage = str(base64.b64encode(bytes(statusMessage_CN, encoding="utf-8"), altchars=None), encoding="utf-8") + " " + statusMessage_EN
                self.send_response(401, message=statusMessage)  # , message=None;
                self.send_header('Www-Authenticate', 'Basic realm=\"domain name -> username:password\"')  # 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                self.send_header("Allow", "GET, POST, HEAD, PATCH")  # 服務器能接受的請求方式;
                self.send_header('Content-Type', 'text/plain, text/html; charset=utf-8')  # 服務器發送響應數據的類型及編碼方式
                self.send_header('Content-Length', self.response_Body_String_len)  # 服務器發送的響應數據長度 response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                self.send_header('Content-Language', 'zh-tw,zh-cn,en-us; q=0.9')  # 服務器發送響應的自然語言類型;
                self.send_header('Content-Encoding', 'gzip')  # 服務器發送響應的壓縮類型;
                self.send_header('Expires', '100-continue header')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Cache-Control', 'no-cache')  # 'max-age=0' 或 no-store, must-revalidate 設置不允許瀏覽器緩存，必須刷新數據;
                # self.send_header('Pragma', 'no-cache')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Connection', 'close')  # 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                server_info = "Python_http.server(HTTPServer+BaseHTTPRequestHandler)"
                # server_info = "Python " + str(platform.python_version()) + "_http.server(HTTPServer+BaseHTTPRequestHandler)_" + str(platform.system())  # platform.platform()，platform.python_compiler() 獲取當前 Python 解釋器的信息;
                # print(server_info)
                self.send_header('Server', server_info)  # web 服務器名稱版本信息;
                # self.send_header('Refresh', '1;url=http://localhost:8000/')  # 服務端要求客戶端1秒鐘後刷新頁面，然後訪問指定的頁面路徑;
                # self.send_header('Content-Disposition', 'attachment; filename=Test.zip')  # 服務端要求客戶端以下載文檔的方式打開該文檔;
                # self.send_header('Transfer-Encoding', 'chunked')  # 以數據流形式分塊發送響應數據到客戶端;
                # self.send_header('Date', datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 服務端向客戶端返回響應的時間;
                self.send_header("Access-Control-Allow-Methods", "GET, POST, HEAD, PATCH")
                self.send_header('Access-Control-Allow-Origin', '*')  # 設置允許跨域訪問;
                self.send_header('Access-Control-Allow-Headers', 'content-type, Accept')
                self.send_header('Access-Control-Allow-Credentials', 'true')
                # self.send_header('Content-MD5', 'Q2hlY2sgSW50ZWdyaXR5IQ==')  # 返回實體 MD5 加密的校驗值;
                # Set-Cookie:name=value [ ;expires=date][ ;domain=domain][ ;path=path][ ;secure];
                # 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
                # 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
                # 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
                # 參數value部分，通常是一個name = value格式的字串，通常性的使用方式是以name = value的格式來指定cookie的值；
                # 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
                after_1_Days = (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%d %H:%M:%S.%f")  # 計算 30 日之後的日期;
                # print(after_1_Days)  # 打印30天之後的日期 datetime.datetime.now().date().strftime("%Y-%m-%d %H:%M:%S.%f")，datetime.date.today();
                cookieName = 'Session_ID=' + str(base64.b64encode(bytes('request_Key->' + str(self.request_Key), encoding="utf-8"), altchars=None), encoding="utf-8")
                # cookie_string = 'session_id=' + str(self.request_Key.split(":", -1)[0], encoding="utf-8") + ',request_Key->' + str(self.request_Key, encoding="utf-8") + '; expires=' + str(after_30_Days, encoding="utf-8") + '; domain=abc.com; path=/; HTTPOnly;'  # 拼接 cookie 字符串值;
                cookie_string = cookieName + '; expires=' + str(after_1_Days) + '; path=/;'  # 拼接 cookie 字符串值;
                # print(cookie_string)
                self.send_header('Set-Cookie', cookie_string)  # 設置 Cookie;
                self.end_headers()

            # Handler for the GET requests;
            def do_GET(self):
                # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                # print("\nrequest Command: ", self.command)  # 打印請求類型 "POST" or "GET";
                # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                # print("request Headers:")
                # print(self.headers)  # 換行打印請求頭;
                # print(type(request_headers))  # 打印請求頭的數據類型;
                # print("request Cookie: ", self.headers["Cookie"])  # 打印客戶端請求頭中的 Cookie 參數值;
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization";
                # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))
                # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                # self.request_Key = str(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                # print(type(self.request_Key))
                # print("request Nikename: [", self.request_Key.split(":", -1)[0], "], request Password: [", self.request_Key.split(":", -1)[1],"].")

                # print("當前進程ID: ", multiprocessing.current_process().pid)
                # print("當前進程名稱: ", multiprocessing.current_process().name)
                # print("當前綫程ID: ", threading.current_thread().ident)
                # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
                # global threads  # 自定義的全局變量綫程列表;
                # threads.append(threading.current_thread())  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;

                # global Key, Session

                # # 配置只接收目標為根目錄 / 的訪問;
                # if self.path != "/":
                #     self.send_error(404, "Page not Found!")
                #     return

                # 使用請求頭信息「self.headers["Authorization"]」和「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼;
                if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                    # print("request Headers Authorization: ", self.headers["Authorization"])
                    # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                    # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                    # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))

                    # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
                    if self.headers["Authorization"].find("Basic", 0, int(len(self.headers["Authorization"])-1)) != -1 and self.headers["Authorization"].split(" ", -1)[0] == "Basic" and len(self.headers["Authorization"].split("Basic ", -1)) > 1 and self.headers["Authorization"].split("Basic ", -1)[1] != "":
                        self.request_Key = str(base64.b64decode(self.headers["Authorization"].split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.request_Key = ""
                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    pass
                elif self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                    self.Cookie_value = self.headers['Cookie']
                    # print("request Headers Cookie: ", self.headers["Cookie"])
                    # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
                    # self.request_Key = eval("'" + str(self.Cookie_value.split("=", -1)[1]) + "'", {'self.request_Key' : ''})  # exec('self.request_Key="username:password"', {'self.request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

                    # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                    if self.Cookie_value.find("=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.find("Session_ID=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.split("=", -1)[0] == "Session_ID":
                        self.Session_ID = str(base64.b64decode(self.Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.Session_ID = str(base64.b64decode(self.Cookie_value, altchars=None, validate=False), encoding="utf-8")

                    # print(type(self.Session_ID))
                    # print(self.Session_ID)

                    # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / self.Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
                    if self.Session_ID != None and self.Session_ID != "" and type(self.Session_ID) == str and Session.__contains__(self.Session_ID) == True and Session[self.Session_ID] != None:
                        self.request_Key = str(Session[self.Session_ID])
                        # print(type(self.request_Key))
                        # print(self.request_Key)
                    else:
                        # self.request_Key = ":"
                        self.request_Key = ""

                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    # print(Key)
                    pass
                else:
                    # self.request_Key = ":"
                    self.request_Key = ""

                    if Key != "":

                        response_data = {
                            "Server_say": "No request Headers Authorization or Cookie received.",
                            "require_Authorization": Key
                        }
                        response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                        # self.send_header('Content-Length', len(bytes(response_data, "utf-8")))
                        self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                        self.do_AUTHHEAD()
                        self.wfile.write(response_data.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return


                # 判斷字符串中是否包含指定字符，也可以是用 "char" in String 語句判斷，判斷客戶端傳入的請求頭中Authorization參數值中是否包含 ":" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                if self.request_Key != "" and self.request_Key.find(":", 0, int(len(self.request_Key)-1)) != -1:
                    request_Nikename = self.request_Key.split(":", -1)[0]
                    request_Password = self.request_Key.split(":", -1)[1]
                    # print("request Nikename: [ ", self.request_Key.split(":", -1)[0], " ], request Password: [ ", self.request_Key.split(":", -1)[1]," ].")
                else:
                    request_Nikename = self.request_Key
                    request_Password = ""


                if Key != "" and (request_Nikename != Key.split(":", -1)[0] or request_Password != Key.split(":", -1)[1]):

                    response_data = {
                        "Server_say": "request Header Authorization [ " + request_Nikename + " ] not authenticated.",
                        "require_Authorization": Key
                    }
                    response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                    self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                    self.do_AUTHHEAD()
                    self.wfile.write(response_data.encode('utf-8'))
                    # self.wfile.flush()
                    # self.wfile.close()
                    return

                else:

                    # 路由，判斷請求URL字符串，如果請求的URL是："/"，則做如下處理;
                    if self.path == "/":
                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)
 
                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        #     "request_body_string": ""
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        # request_data_JSON["request_body_string"] = str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        request_data_JSON["request_body_string"] = ""
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                                "request_body_string": "",
                                "Server_say": "GET method require successful."
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # request_data_JSON = {
                        #     "Client_say": "Browser GET request test."
                        # }
                        # # print("Client say: ", request_data_JSON)

                        # response_Body_JSON = {
                        #     "request Nikename": request_Nikename,
                        #     "request Passwork": request_Password,
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    elif self.path == "/index.html":
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)
 
                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        #     "request_body_string": ""
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        # request_data_JSON["request_body_string"] = str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        request_data_JSON["request_body_string"] = ""
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                                "Server_say": "GET method require successful."
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # request_data_JSON = {
                        #     "Client_say": "Browser GET request test."
                        # }
                        # # print("Client say: ", request_data_JSON)

                        # response_Body_JSON = {
                        #     "request Nikename": request_Nikename,
                        #     "request Passwork": request_Password,
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    else:
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)
 
                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        #     "request_body_string": ""
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        # request_data_JSON["request_body_string"] = str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        request_data_JSON["request_body_string"] = ""
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                                "request_body_string": "",
                                "Server_say": "GET method require successful."
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # request_data_JSON = {
                        #     "Client_say": "Browser GET request test."
                        # }
                        # # print("Client say: ", request_data_JSON)

                        # response_Body_JSON = {
                        #     "request Nikename": request_Nikename,
                        #     "request Passwork": request_Password,
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

            # Handler for the POST requests;
            def do_POST(self):
                # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                # print("\nrequest Command: ", self.command)  # 打印請求類型 "POST" or "GET";
                # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                # print("request Headers:")
                # print(self.headers)  # 換行打印請求頭;
                # print(type(request_headers))  # 打印請求頭的數據類型;
                # print("request Cookie: ", self.headers["Cookie"])  # 打印客戶端請求頭中的 Cookie 參數值;
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization";
                # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))
                # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                # self.request_Key = str(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                # print(type(self.request_Key))
                # print("request Nikename: [ ", self.request_Key.split(":", -1)[0], " ], request Password: [ ", self.request_Key.split(":", -1)[1]," ].")

                # print("當前進程ID: ", multiprocessing.current_process().pid)
                # print("當前進程名稱: ", multiprocessing.current_process().name)
                # print("當前綫程ID: ", threading.current_thread().ident)
                # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
                # global threads  # 自定義的全局變量綫程列表;
                # threads.append(threading.current_thread())  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;

                # global Key, Session

                # # 配置只接收目標為根目錄 / 的訪問;
                # if self.path != "/":
                #     self.send_error(404, "Page not Found!")
                #     return

                # 使用請求頭信息「self.headers["Authorization"]」和「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼;
                if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                    # print("request Headers Authorization: ", self.headers["Authorization"])
                    # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                    # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                    # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))

                    # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
                    if self.headers["Authorization"].find("Basic", 0, int(len(self.headers["Authorization"])-1)) != -1 and self.headers["Authorization"].split(" ", -1)[0] == "Basic" and len(self.headers["Authorization"].split("Basic ", -1)) > 1 and self.headers["Authorization"].split("Basic ", -1)[1] != "":
                        self.request_Key = str(base64.b64decode(self.headers["Authorization"].split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.request_Key = ""
                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    pass
                elif self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                    self.Cookie_value = self.headers['Cookie']
                    # print("request Headers Cookie: ", self.headers["Cookie"])
                    # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
                    # self.request_Key = eval("'" + str(self.Cookie_value.split("=", -1)[1]) + "'", {'self.request_Key' : ''})  # exec('self.request_Key="username:password"', {'self.request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

                    # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                    if self.Cookie_value.find("=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.find("Session_ID=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.split("=", -1)[0] == "Session_ID":
                        self.Session_ID = str(base64.b64decode(self.Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.Session_ID = str(base64.b64decode(self.Cookie_value, altchars=None, validate=False), encoding="utf-8")
                    # print(type(self.Session_ID))
                    # print(self.Session_ID)

                    # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / self.Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
                    if self.Session_ID != None and self.Session_ID != "" and type(self.Session_ID) == str and Session.__contains__(self.Session_ID) == True and Session[self.Session_ID] != None:
                        self.request_Key = str(Session[self.Session_ID])
                        # print(type(self.request_Key))
                        # print(self.request_Key)
                    else:
                        # self.request_Key = ":"
                        self.request_Key = ""

                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    # print(Key)
                    pass
                else:
                    # self.request_Key = ":"
                    self.request_Key = ""
                    if Key != "":
                        response_data = {
                            "Server_say": "No request Headers Authorization or Cookie received.",
                            "require_Authorization": Key
                        }
                        response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                        # self.send_header('Content-Length', len(bytes(response_data, "utf-8")))
                        self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                        self.do_AUTHHEAD()
                        self.wfile.write(response_data.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return


                # 判斷字符串中是否包含指定字符，也可以是用 "char" in String 語句判斷，判斷客戶端傳入的請求頭中Authorization參數值中是否包含 ":" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                if self.request_Key != "" and self.request_Key.find(":", 0, int(len(self.request_Key)-1)) != -1:
                    request_Nikename = self.request_Key.split(":", -1)[0]
                    request_Password = self.request_Key.split(":", -1)[1]
                    # print("request Nikename: [ ", self.request_Key.split(":", -1)[0], " ], request Password: [ ", self.request_Key.split(":", -1)[1]," ].")
                else:
                    request_Nikename = self.request_Key
                    request_Password = ""


                if Key != "" and (request_Nikename != Key.split(":", -1)[0] or request_Password != Key.split(":", -1)[1]):

                    response_data = {
                        "Server_say": "request Header Authorization [ " + request_Nikename + " ] not authenticated.",
                        "require_Authorization": Key
                    }
                    response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                    self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                    self.do_AUTHHEAD()
                    self.wfile.write(response_data.encode('utf-8'))
                    # self.wfile.flush()
                    # self.wfile.close()
                    return

                else:

                    # 路由，判斷請求URL字符串，如果請求的URL是："/"，則做如下處理;
                    if self.path == "/":
                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # request_form_value 是客戶端以 POST 方法發送的請求躰表單 form 中的原始數據（以 utf-8 編碼），request_form 是原始數據（以 utf-8 編碼）使用 json.loads(request_form_value) 函數轉換後的 JSON 對象數據，response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)

                        # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                        # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                        request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')

                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     "request_body_string": request_form_value
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        request_data_JSON["request_body_string"] = request_form_value
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # request_data_JSON["request_body_string"] = request_form_value,
                                "Server_say": request_form_value
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
                        # if check_json_format(request_form_value):
                        #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
                        #     request_data_JSON = json.loads(request_form_value)  # , encoding='utf-8'
                        # else:
                        #     request_data_JSON = {
                        #         "Client_say": request_form_value
                        #     }

                        # # print("request POST Form:", request_form_value)  # 換行打印請求體;
                        # # 換行打印請求體;
                        # # print("Client say: ", request_data_JSON["Client_say"])

                        # response_Body_JSON = {
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))
                        # self.response_Body_String_len = len(response_Body_String)

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode("utf-8"))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    elif self.path == "/index.html":
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # request_form_value 是客戶端以 POST 方法發送的請求躰表單 form 中的原始數據（以 utf-8 編碼），request_form 是原始數據（以 utf-8 編碼）使用 json.loads(request_form_value) 函數轉換後的 JSON 對象數據，response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)

                        # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                        # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                        request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')

                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     "request_body_string": request_form_value
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        request_data_JSON["request_body_string"] = request_form_value
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # request_data_JSON["request_body_string"] = request_form_value,
                                "Server_say": request_form_value
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
                        # if check_json_format(request_form_value):
                        #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
                        #     request_data_JSON = json.loads(request_form_value)  # , encoding='utf-8'
                        # else:
                        #     request_data_JSON = {
                        #         "Client_say": request_form_value
                        #     }

                        # # print("request POST Form:", request_form_value)  # 換行打印請求體;
                        # # 換行打印請求體;
                        # # print("Client say: ", request_data_JSON["Client_say"])

                        # response_Body_JSON = {
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))
                        # self.response_Body_String_len = len(response_Body_String)

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode("utf-8"))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    else:
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # request_form_value 是客戶端以 POST 方法發送的請求躰表單 form 中的原始數據（以 utf-8 編碼），request_form 是原始數據（以 utf-8 編碼）使用 json.loads(request_form_value) 函數轉換後的 JSON 對象數據，response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)

                        # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                        # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                        request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')

                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     "request_body_string": request_form_value
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        request_data_JSON["request_body_string"] = request_form_value
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # request_data_JSON["request_body_string"] = request_form_value,
                                "Server_say": request_form_value
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
                        # if check_json_format(request_form_value):
                        #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
                        #     request_data_JSON = json.loads(request_form_value)  # , encoding='utf-8'
                        # else:
                        #     request_data_JSON = {
                        #         "Client_say": request_form_value
                        #     }

                        # # print("request POST Form:", request_form_value)  # 換行打印請求體;
                        # # 換行打印請求體;
                        # # print("Client say: ", request_data_JSON["Client_say"])

                        # response_Body_JSON = {
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))
                        # self.response_Body_String_len = len(response_Body_String)

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode("utf-8"))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

        # 使用 socketserver 庫的 ThreadingMixIn 方法（socketserver.ThreadingMixIn）配置啓動多綫程服務器；也可以使用socketserver.ForkingMixIn方法配置多進程服務器;
        # class ThreadedHTTPServer(socketserver.ForkingMixIn, HTTPServer):
        class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
            # Handle requests in a separate thread.
            ThreadingMixIn.daemon_threads = True  # 預設值為 False，將之改爲 True 值，從而設定當主綫程强制退出時，子綫程同步强制終止;
            address_family = socket.AF_INET6  # 配置服務器支持監聽 IPv6 版 IP 地址;
            pass

        # 使用 socketserver 庫的 HTTPServerV6 方法(HTTPServer)配置服務器支持監聽 IPv6 版 IP 地址;
        class HTTPServerV6(HTTPServer):
            address_family = socket.AF_INET6  # 配置服務器支持監聽 IPv6 版 IP 地址;
            pass
        # server = HTTPServerV6((monitoring, Resquest), MyHandler)
        # server.serve_forever()

        # 也可以不用 socketserver 庫裏的對象，自定義一個 ThreadingMinxIn 類;
        # class ThreadingMixIn:
 
        #     daemon_threads = True  # 預設值為 False，將之改爲 True 值，從而設定當主綫程强制退出時，子綫程同步强制終止;
 
        #     def process_request_thread(self, request, client_address):      
        #         try:
        #             self.finish_request(request, client_address)
        #             self.shutdown_request(request)
        #         except:
        #             self.handle_error(request, client_address)
        #             self.shutdown_request(request)
 
        #     def process_request(self, request, client_address):
 
        #         t = threading.Thread(target = self.process_request_thread, args = (request, client_address))
        #         t.daemon = self.daemon_threads
        #         # threads.append(t)  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;
        #         t.start()

        # 啓動服務器;
        # https://docs.python.org/zh-tw/3.6/library/multiprocessing.html
        def start_Server(host, port, Resquest, ThreadedHTTPServer, HTTPServerV6, HTTPServer, Is_multi_thread):
            # print("當前進程ID: ", multiprocessing.current_process().pid)
            # print("當前進程名稱: ", multiprocessing.current_process().name)
            # print("當前綫程ID: ", threading.current_thread().ident)
            # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;

            # print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/" % (host, port))
            # print('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.')
            # print('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.')
            # print("Keyboard Enter [ Ctrl ] + [ c ] to close.")
            # print("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.")

            # host = "0.0.0.0"  # 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
            # port = 8000  # 監聽埠號
            # 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
            monitoring = (host, port)

            # server = None
            # type(Is_multi_thread) == bool
            if Is_multi_thread:
                # Create a web server and define the handler to manage the incoming request;
                server = ThreadedHTTPServer(monitoring, Resquest)
                # threading.Thread(target=server.serve_forever).start()
                # threading.Event().wait()
            else:
                server = HTTPServerV6(monitoring, Resquest)  # 修改參數之後，支持 IPv6 版地址;
                # server = HTTPServer(monitoring, Resquest)  # 原始服務器包，支持 IPv4 版地址;

            try:
                # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
                server.serve_forever()  # Wait forever for incoming htto requests;
            except Exception as error:
                print(error)
            # except KeyboardInterrupt:
            #     # KeyboardInterrupt 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
            #     print('[ Ctrl ] + [ c ] received, shutting down the web server.')

            #     # for t in range(threading.enumerate()):
            #     #     print(t.getName())
            #     #     print(t.ident)
            #     #     # t.join()  # .join([time]) 等待至线程中止。这阻塞调用线程直至线程的join();
            #     #     # 使用 ctypes 庫强制殺掉正在運行的進程;
            #     #     if t.getName() != "MainThread":
            #     #         if not inspect.isclass(SystemExit):
            #     #             SystemExit = type(SystemExit)
            #     #         res = ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), ctypes.py_object(SystemExit))
            #     #         # print(res)
            #     #         if res == 0:
            #     #             raise ValueError("invalid thread id")
            #     #         elif res != 1:
            #     #             # """if it returns a number greater than one, you're in trouble,
            #     #             # # and you should call it again with exc=NULL to revert the effect"""
            #     #             ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), None)
            #     #             raise SystemError("PyThreadState_SetAsyncExc failed")
            #     #         # print(threading.active_count())

            #     # 關閉正在運行的服務器;
            #     if server:
            #         server.shutdown()
            #         # server.socket.close()

            #     print("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " exit.")

            # # finally:
            # #     """退出 try 時總會執行的語句，無論是否出錯都會繼續執行的語句;處理單獨綫程中的請求;处理单独线程中的请求。"""

            return server

        server = start_Server(host, port, Resquest, ThreadedHTTPServer, HTTPServerV6, HTTPServer, Is_multi_thread)
        return server

    # 配置啓動服務器參數;
    def start(self, host, port, Is_multi_thread, Key, Session, do_Function, number_Worker_process, initializer, pool_func, pool_call_back, error_pool_call_back, total_worker_called_number, check_json_format):
        # print("當前進程ID: ", multiprocessing.current_process().pid)
        # print("當前進程名稱: ", multiprocessing.current_process().name)
        # print("當前綫程ID: ", threading.current_thread().ident)
        # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;

        print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/" % (host, port))
        # print('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.')
        # print('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.')
        # print("Keyboard Enter [ Ctrl ] + [ c ] to close.")
        print("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.")

        # 創建子進程池;
        process_Pool = None
        if number_Worker_process > 0:
            try:
                # start number_Worker_process worker processes, number_Worker_process = os.cpu_count();
                print("Master process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " create process pool with spawning " + str(number_Worker_process) + " Worker process ...")
                process_Pool = multiprocessing.Pool(processes=number_Worker_process, initializer=initializer, initargs=(), maxtasksperchild=None)
                # 創建進程池，使用 Pool 類執行提交給它的任務，注意要設置參數 initializer，配置爲等於自定義的初始化函數 initializer()，作用是消除鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，子進程被終止的報錯信息;
                # class multiprocessing.Pool([processes[, initializer[, initargs[, maxtasksperchild[, context]]]]])
                #     一個進程池物件，它控制可以提交作業的工作進程池。它支援帶有超時和回檔的非同步結果，以及一個並行的 map 實現;
                #     processes 是要使用的工作進程數目。如果 processes 為 None，則使用 os.cpu_count() 返回的值;
                #     如果 initializer 不為 None，則每個工作進程將會在啟動時調用 initializer(*initargs);
                #     maxtasksperchild 是一個工作進程在它退出或被一個新的工作進程代替之前能完成的任務數量，為了釋放未使用的資源。預設的 maxtasksperchild 是 None，意味著工作進程壽與池齊;
                #     context 可被用於指定啟動的工作進程的上下文。通常一個進程池是使用函數 multiprocessing.Pool() 或者一個上下文物件的 Pool() 方法創建的。在這兩種情況下， context 都是適當設置的;
                # 注意，進程池物件的方法只有創建它的進程能夠調用;
                # 備註 通常來說，Pool 中的 Worker 進程的生命週期和進程池的工作隊列一樣長。一些其他系統中（如 Apache, mod_wsgi 等）也可以發現另一種模式，他們會讓工作進程在完成一些任務後退出，清理、釋放資源，然後啟動一個新的進程代替舊的工作進程。 Pool 的 maxtasksperchild 參數給用戶提供了這種能力;
                # class multiprocessing.pool.AsyncResult
                #     Pool.apply_async() 和 Pool.map_async() 返回對象所屬的類;
                #     get([timeout])
                #         用於獲取執行結果。如果 timeout 不是 None 並且在 timeout 秒內仍然沒有執行完得到結果，則拋出 multiprocessing.TimeoutError 異常。如果遠端調用發生異常，這個異常會通過 get() 重新拋出。
                #     wait([timeout])
                #         阻塞，直到返回結果，或者 timeout 秒後超時。
                #     ready()
                #         用於判斷執行狀態，是否已經完成。
                #     successful()
                #         Return whether the call completed without raising an exception. Will raise AssertionError if the result is not ready.

                # # 推入函數在進程池中啓動一個子進程，process_Pool.apply(func=, args=(,), kwds={})，同步函數會阻塞主進程直到返回結果，其中的執行函數 func 只能接受最外層的函數，不能是嵌套的内層函數;
                # apply_func_return = process_Pool.apply(func=pool_func, args=(read_file_do_Function, "", "", do_Function, "", "", "", "", time_sleep), kwds={})  # 同步函數，會阻塞主進程等待直到返回結果;
                # # print(apply_func_return)
                # if isinstance(apply_func_return, list):
                #     prcess_pid = int(apply_func_return[1])
                #     thread_ident = int(apply_func_return[2])
                #     # 記錄每個被調用的子進程的纍加總次數;
                #     if str(apply_func_return[1]) in total_worker_called_number:
                #         print(total_worker_called_number)
                #         # total_worker_called_number[str(apply_func_return[1])] = int(total_worker_called_number[str(apply_func_return[1])]) + int(1)
                #     else:
                #         total_worker_called_number[str(apply_func_return[1])] = int(0)
                # process_Pool.close()
                # process_Pool.join()
                # process_Pool.terminate()
            except Exception as error:
                print(error)

        server = None
        try:
            # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
            server = self.Server(host, port, Is_multi_thread, Key, Session, do_Function, number_Worker_process, process_Pool, pool_func, pool_call_back, error_pool_call_back, total_worker_called_number)
        except KeyboardInterrupt:
            # KeyboardInterrupt 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
            print('[ Ctrl ] + [ c ] received, shutting down the web server.')

            print("綫程池(threading): " + str(threading.active_count()) + " " + str(threading.enumerate()))
            # worker_queues, worker_free, worker_pipe_queues
            arr = []
            if isinstance(total_worker_called_number, dict) and any(total_worker_called_number):
                for key in total_worker_called_number:
                    if key == str(multiprocessing.current_process().pid):
                        arr.append("listening Server process-" + str(key) + " [ " + str(total_worker_called_number[key]) + " ]")
                    else:
                        arr.append("Worker process-" + str(key) + " [ " + str(total_worker_called_number[key]) + " ]")
            if len(arr) > 0:
                print(", ".join(arr))

            if process_Pool != None:
                # process_Pool.close()
                # process_Pool.join()
                process_Pool.terminate()
                # print(process_Pool)

            # 關閉正在運行的服務器;
            if server:
                server.shutdown()
                # server.socket.close()

            # for t in threading.enumerate():
            #     print(t.getName())
            #     print(t.ident)
            #     # t.join()  # .join([time]) 等待至线程中止。这阻塞调用线程直至线程的join();
            #     # 使用 ctypes 庫强制殺掉正在運行的進程;
            #     if t.getName() != "MainThread":
            #         if not inspect.isclass(SystemExit):
            #             SystemExit = type(SystemExit)
            #         res = ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), ctypes.py_object(SystemExit))
            #         # print(res)
            #         if res == 0:
            #             raise ValueError("invalid thread id")
            #         elif res != 1:
            #             # """if it returns a number greater than one, you're in trouble,
            #             # # and you should call it again with exc=NULL to revert the effect"""
            #             ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), None)
            #             raise SystemError("PyThreadState_SetAsyncExc failed")
            #         # print(threading.active_count())

            print("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " exit.")

        # finally:
        #     """退出 try 時總會執行的語句，無論是否出錯都會繼續執行的語句;處理單獨綫程中的請求;处理单独线程中的请求。"""

        return (server, process_Pool, total_worker_called_number)

    # 配置啓動服務器參數;
    def run(self):
        return self.start(self.host, self.port, self.Is_multi_thread, self.Key, self.Session, self.do_Function, self.number_Worker_process, self.initializer, self.pool_func, self.pool_call_back, self.error_pool_call_back, self.total_worker_called_number, self.check_json_format)



# 配置當 interface_Function = Interface_http_Server 時的預設值;
webPath = str(os.path.abspath("."))  # "C:/Criss/DatabaseServer/MariaDB/Python2MariaDB/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
host = "::0"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
port = int(3307)  # 監聽埠號 1 ~ 65535;
# monitoring = (host, port)
Key = ""  # "username:password"
Session = {
    "request_Key->username:password": Key
}
Is_multi_thread = True
do_Function = do_Request_Router  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_GET_root_directory 用於接收執行功能的函數;
do_Function_obj = {
    "do_Function": do_Function
}
number_Worker_process = int(0)  # int(2)

dbHost = '127.0.0.1'  # "::0"、"::1"、"::" 設定為 '0.0.0.0' 表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
dbPort = int(3306)  # 監聽埠號 1 ~ 65535;
dbName = 'test'
dbUser = 'root'  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
dbPass = ''  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
dbSSL_CA = "/path/to/skysql_chain.pem"

# 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# print(type(sys.argv))
# print(sys.argv)
if len(sys.argv) > 1:
    for i in range(len(sys.argv)):
        # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
        if i > 0:
            # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
            if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:

                # 用於接收執行功能的函數 do_Function = "do_data";
                if sys.argv[i].split("=", -1)[0] == "do_Function":
                    # do_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    do_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_Function_name_str, str) and do_Function_name_str != "":
                        if do_Function_name_str == "do_Request" and inspect.isfunction(do_Request_Router):
                            do_Function_name_str_Request = "do_Request"
                            do_Function_Request = do_Request_Router
                            # do_Function = do_Request
                        # else:
                    # print("do Function:", do_Function)
                # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                elif sys.argv[i].split("=", -1)[0] == "number_Worker_process":
                    number_Worker_process = int(sys.argv[i].split("=", -1)[1])  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                    # print("number Worker processes:", number_Worker_process)
                # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
                if sys.argv[i].split("=", -1)[0] == "webPath":
                    webPath = str(sys.argv[i].split("=", -1)[1])  # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
                    # print("webPath:", webPath)
                # http 服務器監聽的IP地址 host = "0.0.0.0";
                elif sys.argv[i].split("=", -1)[0] == "host":
                    host = str(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的IP地址 host = "0.0.0.0";
                    # print("host:", host)
                # http 服務器監聽的埠號 port = int(3307);
                elif sys.argv[i].split("=", -1)[0] == "port":
                    port = int(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的埠號 port = int(3307);
                    # print("port:", port)
                # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                elif sys.argv[i].split("=", -1)[0] == "Is_multi_thread":
                    Is_multi_thread = bool(sys.argv[i].split("=", -1)[1])  # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                    # print("multi thread:", Is_multi_thread)
                # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 Key = "username:password";
                elif sys.argv[i].split("=", -1)[0] == "Key":
                    Key = str(sys.argv[i].split("=", -1)[1])  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                    # print("Key:", Key)
                # 用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                elif sys.argv[i].split("=", -1)[0] == "Session":
                    Session_name_str = sys.argv[i].split("=", -1)[1]

                    # # 使用自定義函數check_json_format(raw_msg)判斷傳入參數sys.argv[1]是否為JSON格式的字符串
                    # if check_json_format(str(sys.argv[i].split("=", -1)[1])):
                    #     Session = json.loads(sys.argv[i].split("=", -1)[1], encoding='utf-8')  # 將讀取到的傳入參數字符串轉換爲JSON對象，用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                    # else:
                    #     print("控制臺傳入的 Session 參數 JSON 字符串無法轉換為 JSON 對象: " + sys.argv[i])

                    # isinstance(JSON, dict) 判斷是否為 JSON 對象類型數據;
                    if isinstance(Session_name_str, str) and Session_name_str != "" and Session_name_str == "Session" and isinstance(Session, dict):
                        Session = Session
                    # print("Session:", Session)

                # MariaDB Server 數據庫服務器監聽的IP地址 dbHost = "127.0.0.1";
                elif sys.argv[i].split("=", -1)[0] == "dbHost":
                    dbHost = str(sys.argv[i].split("=", -1)[1])  # MariaDB Server 數據庫服務器監聽的IP地址 dbHost = "127.0.0.1";
                    # print("MariaDB server host:", dbHost)
                # MariaDB Server 數據庫服務器監聽的埠號 dbPort = int(3306);
                elif sys.argv[i].split("=", -1)[0] == "dbPort":
                    dbPort = int(sys.argv[i].split("=", -1)[1])  # MariaDB Server 數據庫服務器監聽的埠號 dbPort = int(3306);
                    # print("MariaDB server port:", dbPort)
                # MariaDB Server 數據庫自定義的名稱 dbName = "test";
                elif sys.argv[i].split("=", -1)[0] == "dbName":
                    dbName = str(sys.argv[i].split("=", -1)[1])  # MariaDB Server 數據庫自定義的名稱 dbName = "test";
                    # print("MariaDB server name:", dbName)
                # MariaDB Server 數據庫服務器自定義的鏈接用戶名 dbUser = 'root'  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
                elif sys.argv[i].split("=", -1)[0] == "dbUser":
                    dbUser = str(sys.argv[i].split("=", -1)[1])  # MariaDB Server 數據庫服務器自定義的鏈接用戶名 dbUser = 'root'  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
                    # print("MariaDB server User:", dbUser)
                # MariaDB Server 數據庫服務器自定義的鏈接密碼 dbPass = ''  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
                elif sys.argv[i].split("=", -1)[0] == "dbPass":
                    dbPass = str(sys.argv[i].split("=", -1)[1])  # MariaDB Server 數據庫服務器自定義的鏈接密碼 dbPass = ''  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
                    # print("MariaDB server Pass:", dbPass)
                # MariaDB Server 數據庫服務器自定義的 https 鏈接證書文檔的存儲路徑 dbSSL_CA = "/path/to/skysql_chain.pem";
                elif sys.argv[i].split("=", -1)[0] == "dbSSL_CA":
                    dbSSL_CA = str(sys.argv[i].split("=", -1)[1])  # MariaDB Server 數據庫服務器自定義的 https 鏈接證書文檔的存儲路徑 dbSSL_CA = "/path/to/skysql_chain.pem";
                    # print("MariaDB server SSL Certification Authority:", dbSSL_CA)

                else:
                    print(sys.argv[i], "unrecognized.")



# 函數使用示例;
# 控制臺命令行使用:
# C:\>C:\Criss\Python\Python38\python.exe C:/Criss/DatabaseServer/MariaDB/Python2MariaDB/src/Python2MariaDBServer.py
# C:\>C:\Criss\DatabaseServer\MariaDB\Python2MariaDB\Scripts\python.exe C:/Criss/DatabaseServer/MariaDB/Python2MariaDB/src/Python2MariaDBServer.py
# 啓動運行;
# 參數 C:\Criss\DatabaseServer\MariaDB\Python2MariaDB\Scripts\python.exe 表示使用隔離環境 Python2MariaDB 中的 python.exe 啓動運行;
# 使用示例，自定義類 http Server for MariaDB 服務器使用説明;
if __name__ == '__main__':
    # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
    try:
        # https://mariadb.com/kb/zh-cn/mariadb-mariadb/

        # 使用 Linux-Ubuntu 系統控制臺命令行安裝 MariaDB 數據庫服務器：
        # root@localhost:~# apt install mariadb-server
        # 安裝成功後，MariaDB 數據庫服務器的二進制可執行檔啓動文件，保存在 Ubuntu 22.04 系統的的「/etc/init.d/」目錄下，名爲「mariadb」。
        # 啓動 MariaDB 數據庫服務器：
        # root@localhost:~# /etc/init.d/mariadb start
        # 控制臺命令行返回值爲：
        # 「* Starting MariaDB database server mariadbd [ OK ]」
        # 重新啓動正在運行的 MariaDB 數據庫服務器：
        # root@localhost:~# /etc/init.d/mariadb restart
        # 控制臺命令行返回值爲：
        # 「* Stopping MariaDB database server mariadbd [ OK ]」
        # 「* Starting MariaDB database server mariadbd [ OK ]」
        # 中止正在運行的 MariaDB 數據庫服務器：
        # root@localhost:~# /etc/init.d/mariadb stop
        # 控制臺命令行返回值爲：
        # 「* Stopping MariaDB database server mariadbd [ OK ]」
        # 查看 MariaDB 數據庫服務器的運行狀態：
        # root@localhost:~# /etc/init.d/mariadb status
        # 控制臺命令行返回值爲：
        # 「* MariaDB is stopped.」
        # 「* /usr/bin/mysqladmin Ver 9.1 Distrib 10.6.12-MariaDB, for debian-linux-gnu on aarch64」
        # 「Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.」
        # 「Server version 10.6.12-MariaDB-Oubuntu0.22.04.1」
        # 「Protocol version 10」
        # 「Connection Localhost via UNIX socket」
        # 「UNIX socket /run/mysqld/mysqld.sock」
        # 「Uptime: 31 sec」
        # 「Threads: 1 Questions: 61 Slow queries: 0 Opens: 33 Open tables: 26 Queries per second avg: 1.967」

        # 使用 Window10 系統控制臺命令行「cmd」工具安裝 MariaDB 數據庫服務器：
        # C:\>wget https://mirrors.xtom.com.hk/mariadb//mariadb-11.2.2/winx64-packages/mariadb-11.2.2-winx64.msi
        # C:\> ./mariadb-11.2.2-winx64.msi
        # 使用 Window10 系統控制臺命令行「cmd」工具啓動 MariaDB 數據庫服務器（窗口關閉後，服務器仍在後臺運行）：
        # C:\>net start mariadb
        # 控制臺命令行返回值爲：
        # 「MariaDB 服務正在啓動 ..」
        # 「MariaDB 服務已經啓動成功。」
        # 或者另一種方式，使用 Window10 系統控制臺命令行「cmd」工具啓動 MariaDB 數據庫服務器（窗口關閉後，服務器仍在後臺運行）：
        # C:\>mysqld.exe --standalone
        # 控制臺命令行返回值爲：「空」
        # 或者另一種方式，指定使用自定義的配置文檔啓動，使用 Window10 系統控制臺命令行「cmd」工具啓動 MariaDB 數據庫服務器（窗口關閉後，服務器仍在後臺運行）：
        # C:\>mysqld.exe --defaults-file=C:/Criss/DatabaseServer/MariaDB/MariaDB4Criss.ini --standalone
        # 控制臺命令行返回值爲：「空」
        # 使用 Window10 系統控制臺命令行「cmd」工具停止 MariaDB 數據庫服務器：
        # C:\>net stop mariadb
        # 控制臺命令行返回值爲：
        # 「MariaDB 服務正在停止...」
        # 「MariaDB 服務已成功停止。」
        # 或者另一種方式，使用 Window10 系統控制臺命令行「cmd」工具停止 MariaDB 數據庫服務器：
        # C:\>taskkill /IM mysqld.exe /F
        # 控制臺命令行返回值爲：
        # 「成功: 已終止進程 "mysqld.exe"，其 PID 爲 11232。」
        # 使用 Window10 系統控制臺命令行「cmd」工具查看 MariaDB 數據庫服務器運行狀態：
        # C:\>netstat -ano|findstr 3306
        # 控制臺命令行返回值爲：
        # 「TCP    0.0.0.0:3306           0.0.0.0:0              LISTENING       11232」
        # 「TCP    [::]:3306              [::]:0                 LISTENING       11232」

        # # Python 使用 shell 語句從操作系統控制臺命令行調用其它語言;
        # # node 環境;
        # # test.js  待執行的JS的檔;
        # # %s %s  傳遞給JS檔的參數;
        # # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
        # shell_to = os.popen('node %s %s %s %s %s' % (to_script, output_file, monitor_dir, do_Function, monitor_file))  # 執行shell命令，拿到輸出結果;
        # # print(shell_to.readlines());
        # result = shell_to.read()  # 取出執行結果
        # print(result)
        # # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
        # # let arg1 = process.argv[2];  // 解析出JS參數;
        # # let arg2 = process.argv[3];


        # Python 使用 shell 語句運行操作系統控制臺命令行程式，查看 MariaDB 數據庫服務器的運行狀態，是否在正常運行;
        shell_text = 'mariadb status'  # 查看 MariaDB 數據庫服務器的運行狀態;
        shell_to = os.popen(shell_text)  # 執行shell命令，拿到輸出結果;
        # print(shell_to.readlines());
        shell_return = shell_to.read()  # 取出執行結果
        # print(shell_return)
        # 若 MariaDB 數據庫服務器未正常運行，則從新開啓;
        if shell_return == '* MariaDB is stopped.':
            try:
                shell_text = 'mariadb start'  # 啓動 MariaDB 數據庫服務器;
                shell_to = os.popen(shell_text)  # 執行shell命令，拿到輸出結果;
                # print(shell_to.readlines());
                shell_return = shell_to.read()  # 取出執行結果
                # print(shell_return)
                # 若 MariaDB 數據庫服務器未能正常啓動，則中止當前正在執行的進程退出當前程式;
                if shell_return != '* Starting MariaDB database server mariadbd [ OK ]':
                    print(f"Error starting MariaDB database server mariadbd.")
                    sys.exit(1)
            except mariadb.Error as err:
                print(f"Error starting MariaDB database server mariadbd: {err}")
                sys.exit(1)


        # dbHost = '127.0.0.1'  # "::0"、"::1"、"::" 設定為 '0.0.0.0' 表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
        # dbPort = int(3306)  # 監聽埠號 1 ~ 65535;
        # dbName = 'test'
        # dbUser = 'root'  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        # dbPass = ''  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
        # dbSSL_CA = "/path/to/skysql_chain.pem"

        # Connect to MariaDB Platform;
        Connection = None
        try:
            # 建立數據庫鏈接
            Connection = mariadb.connect(
                user = dbUser,  # 'admin_test20220703'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
                password = dbPass,  # 'admin'  # ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  # 鏈接 MariaDB 數據庫的驗證賬號密碼;
                host = dbHost,  # "::0"、"::1"、"::" 設定為 '0.0.0.0' 表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
                port = dbPort,  # 監聽埠號 1 ~ 65535;
                # database = dbName,
                # ssl_ca = dbSSL_CA,
                autocommit = False  # 關閉自動提交到數據庫執行 Disable Auto-Commit;
            )
            # # 關閉自動提交到數據庫執行 Disable Auto-Commit;
            # Connection.autocommit = False  # 關閉自動提交到數據庫執行 Disable Auto-Commit;
        except mariadb.Error as err:
            print(f"Error connecting to MariaDB Platform: {err}")
            sys.exit(1)

        # # 獲取鏈接結果;
        # if not Connection:
        #     print("Error connecting to MariaDB Platform.")
        #     sys.exit(1)

        # 獲取游標對象 Get Cursor;
        Cursor = Connection.cursor()

        # # 完成对数据库的使用后，请确保关闭此连接，以避免将未使用的连接保持打开状态，从而浪费资源。您可以使用以下close()方法关闭连接：
        # # Close Cursor
        # Cursor.close()
        # # Close Connection
        # Connection.close()


        # webPath = str(os.path.abspath("."))  # "C:/Criss/DatabaseServer/MariaDB/Python2MariaDB/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
        # host = "::0"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
        # port = int(3307)  # 監聽埠號 1 ~ 65535;
        # # monitoring = (host, port)
        # Key = ""  # "username:password"
        # Session = {
        #     "request_Key->username:password": Key
        # }
        # Is_multi_thread = True
        # do_Function = do_Request_Router
        # do_Function_obj = {
        #     "do_Function": do_Function
        # }
        # number_Worker_process = int(2)

        http_Server4Mariadb = http_Server(
            host = host,
            port = port,
            Is_multi_thread = Is_multi_thread,
            Key = Key,
            Session = Session,
            # do_Function_obj = do_Function_obj,
            do_Function = do_Function,
            number_Worker_process = number_Worker_process
        )
        # http_Server4Mariadb = http_Server()
        http_Server4Mariadb.run()

    except Exception as error:
        print(error)

