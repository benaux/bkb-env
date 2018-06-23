Mac os x: change hostname


sudo scutil --set ComputerName "newname"
sudo scutil --set LocalHostName "newname"
sudo scutil --set HostName "newname"


sudo dscacheutil -flushcache
