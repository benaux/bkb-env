# Fritzbox

## Restore Fritz OS on Fritzbox 7340

aka “Reflashing”

- go back from Freetz to fritz box 
- official restore tool didn’t work
- used rukernel tool and Fritzbox 7340 image
- on fritzbox: set IP to 192.168.178.1

- ethernet cable between windows and fritzbox, no internet


- on windows:
* disable firewall and virus scanner
* disable media sensing (reboot necessary)
* didnt installed telnet (was not nessecary)
* nothing worked (couldn’t find fritzbox) until I booted fritzbox during the rukernel tool searched for the router