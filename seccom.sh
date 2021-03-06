#!/bin/bash
#
cd ~/
if ! [ -e msg ]
then
mkdir msg
touch msg/msg_1.aesmsg
if ! whereis gpg; then sudo apt install gpg -y; fi
if ! whereis wipe; then sudo apt install wipe -y; fi
fi

trap "" SIGINT
echo
echo
echo "Willkommen im SecureCommunications Terminal"
echo "Wähle einen Menüpunkt"

msg_scan() {
msgnum=$(ls -l ~/msg/*aesmsg* | wc -l)
echo "$msgnum Nachrichten auf Server:"
echo
dat=1
echo Entschlüssele Nachrichten...
while [ $dat -le $msgnum ]
do
cat msg/msg_$dat.aesmsg | gpg --decrypt --no-symkey-cache --pinentry-mode=loopback --passphrase=$secpwd 2>&1 | grep -vi 'gpg:'
let dat++
done
}

sub_1() {
echo -n "Bitte Wähle deine Nutzerkennung: "
read user
if [ -z $user ]; then echo "Leere Eingabe nicht zulässig!" && sub_1; fi
echo -n "Benutzerkennwort (masked): "
read -s userpw
if [ -z $userpw ]; then echo "Leere Eingabe nicht zulässig!" && sub_1; fi
userid=$(echo "$userpw $user" | sha256sum | head -c 5)
user=$(echo "$user ($userid)")
echo "Eingeloggt als: $user"
echo -n "Bitte nenne den vereinbarten PSK [Chatroom] (masked): "
read -s secpwd
if [ -z $secpwd ]; then echo "Leere Eingabe nicht zulässig!" && sub_1; fi
chatroom
}

menu_3() {
userpw=0
userid=0
secpwd=0
user=0
clear && main_screen
}

menu_1() {
echo
echo "Nachricht: "
read msgtxt
cmsg=$(ls -l ~/msg/*aesmsg* | wc -l)
let cmsg++
date=$(date +%H:%M)
echo "$user @ $date:  $msgtxt" | gpg --pinentry-mode=loopback --symmetric --cipher-algo AES-256 --no-symkey-cache --passphrase=$secpwd > ~/msg/msg_$cmsg.aesmsg
chatroom
}

menu_2() {
clear && msg_scan && chatroom
}

chatroom() {
clear
msg_scan
echo
echo "Nachrichten-Menü"
echo "1 - Nachricht schreiben"
echo "2 - Nachrichten abrufen"
echo "3 - Logout & Zurück zum Hauptmenü"
echo -n "Eingabe: " && read choice2
choice2=$(echo $choice2 | head -c 1)
if [ -z $choice2 ]; then echo "Leere Eingabe nicht zulässig!" && chatroom; fi
if echo $choice2 | grep -viE [1-3]; then clear && tput setaf 1 && echo "Fehler bei der Eingabe, bitte erneut versuchen!" && tput sgr0 && chatroom; fi
menu_$choice2
}

sub_2() {
wipe -q msg/*
touch msg/msg_1.aesmsg
sleep 5
clear
main_screen
}

main_screen() {
echo
echo
echo "1 Chatroom betreten"
echo "2 Alle Nachrichten sicher löschen"
echo
echo -n "Eingabe: "
read choice
choice=$(echo $choice | head -c 1)
if echo $choice | grep -viE [1-3]; then clear && tput setaf 1 && echo "Fehler bei der Eingabe, bitte erneut versuchen!" && tput sgr0 && main_screen; fi
sub_$choice
}

### MAIN
main_screen
