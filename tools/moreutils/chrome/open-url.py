#!/usr/local/bin/python3

import sys
import PyChromeDevTools

#chrome = PyChromeDevTools.ChromeInterface()

chrome = PyChromeDevTools.ChromeInterface(host="127.0.0.1",port=9222)
#kBy default it uses localhost:9222.

#To send a command to Chrome, just invoke the corresponding method on the ChromeInterface object, and pass the desired parameters. For example, to visit a page write:

chrome.Page.navigate(url=sys.argv[1])

