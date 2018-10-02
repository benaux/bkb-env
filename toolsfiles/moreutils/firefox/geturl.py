#!/usr/local/bin/python3

import os, sys, json, lz4.block

def get_firefox_profile_dir():
    if sys.platform in ['linux', 'linux2']:
        import subprocess
        cmd = "ls -d /home/$USER/.mozilla/firefox/*.default/"
        p = subprocess.Popen([cmd], shell=True, stdout=subprocess.PIPE)
        FF_PRF_DIR = p.communicate()[0][0:-2]
        FF_PRF_DIR_DEFAULT = str(FF_PRF_DIR,'utf-8')
    elif sys.platform == 'darwin':
        import subprocess
        cmd = "ls -d /Users/$USER/Library/Application\\ Support/Firefox/Profiles/*.default/"
        p = subprocess.Popen([cmd], shell=True, stdout=subprocess.PIPE)
        FF_PRF_DIR = p.communicate()[0][0:-2]
        FF_PRF_DIR_DEFAULT = str(FF_PRF_DIR,'utf-8')
    elif sys.platform == 'win32':
        import os
        import glob
        APPDATA = os.getenv('APPDATA')
        FF_PRF_DIR = "%s\\Mozilla\\Firefox\\Profiles\\" % APPDATA
        PATTERN = FF_PRF_DIR + "*default*"
        FF_PRF_DIR_DEFAULT = glob.glob(PATTERN)[0]
 
    return FF_PRF_DIR_DEFAULT
 
profile_folder = get_firefox_profile_dir()

file = profile_folder + "/sessionstore-backups/recovery.jsonlz4"
f = open(file, "rb")
magic = f.read(8)
jdata = json.loads(lz4.block.decompress(f.read()).decode("utf-8"))
#print str(jdata["windows"][0]["selected"])
#id = jdata["windows"][0]["selected"]
f.close()
tablist = []
for win in jdata.get("windows"):
    for tab in win.get("tabs"):
        i = tab.get("index") - 1
        urls = tab.get("entries")[i].get("url")
        tablist = urls

#print tablist
sys.stdout.write(tablist)
#!/usr/local/bin/python3

import sys
 
