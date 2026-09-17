belso@internalserver:~$ cat /home/bytebridgebelso/backup.sh
#!/bin/bash

#változók
web_forras="/var/www/bytebridge"
ftp_forras="/srv/ftp"
home_forras="/home/bytebridgebelso"
cel_mappa="/var/backups/bytebridge"
datum=$(date +%Y%m%d%H%M)
log="/var/log/backup_log.txt"


#mappa létrehozása ha véletlen törlődött volna
mkdir -p $cel_mappa
echo "[$datum] Mentés indítása...">> $log

#kimentjük a címtár adatait egy szöveges fájlba
slapcat > $cel_mappa/ldapmentes$datum.ldif 2>> $log

#tömörített fájlba tesszük a web,ftp,home mentést
tar -czf $cel_mappa/teljesmentes$datum.tar.gz $web_forras $ftp_forras $home_forras

#ellenőrzés,jogok
if [ $? -eq 0 ]; then
    echo "[$datum] SIKER: Mentés elkészült." >> $log
    #rendszergazda letudja tölteni
    chown -R root:5000 $cel_mappa
    chmod -R 660 $cel_mappa
    find $cel_mappa -type d -exec chmod 770 {} \;
else
    echo "[$datum] HIBA: Valami elromlott!"  >> $log
    exit 1
fi

#csak az utolsó 5 mentést tároljuk
ls -t $cel_mappa/*.tar.gz | tail -n +6 | xargs rm -f 2>/dev/null
ls -t $cel_mappa/*.ldif | tail -n +6 | xargs rm -f 2>/dev/null
