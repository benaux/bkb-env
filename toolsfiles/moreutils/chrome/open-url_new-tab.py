#!/usr/bin/env python3

import pychrome
import sys
browser = pychrome.Browser(url="http://127.0.0.1:9222")
tab = browser.new_tab()
tab.start()
tab.Network.enable()
tab.Page.navigate(url=sys.argv[1])
