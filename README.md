# 🏢 ByteBridge – Kisvállalati Linux Infrastruktúra & Címtárszolgáltatás

[![OS](https://img.shields.io/badge/OS-Ubuntu%2024.04%20LTS-E95420?logo=ubuntu&logoColor=white)](#)
[![Web](https://img.shields.io/badge/Web-Apache2-D22128?logo=apache&logoColor=white)](#)
[![Auth](https://img.shields.io/badge/Directory-OpenLDAP-00599C)](#)
[![FTP](https://img.shields.io/badge/FTP-vsftpd-blue)](#)
[![Result](https://img.shields.io/badge/%C3%89rt%C3%A9kel%C3%A9s-100%25%20(25%2F25)-success)](#)

Egy fiktív digitális médiaügynökség (*ByteBridge Kft.*) számára tervezett és megvalósított, több virtuális gépből álló szerver-kliens architektúra **VMware Workstation** környezetben.

A projekt célja egy olyan központosított vállalati infrastruktúra létrehozása volt, ahol a webes szolgáltatások és a fájlmegosztás (FTP) egységes, többszintű jogosultságkezelését egy központi **OpenLDAP** címtár biztosítja, automatizált mentésekkel és távadminisztrációval kiegészítve.

---

## 📐 Rendszerarchitektúra és Hálózat

A rendszer izolált virtuális hálózaton (`192.168.10.0/24`) működik egy dedikált átjáró mögött:

| Gép / Szerepkör | Operációs rendszer | IP-cím | Futó szolgáltatások |
| :--- | :--- | :--- | :--- |
| **Gateway / Tűzfal** | Linux (Router/NAT) | `192.168.10.1` | Routing, NAT, Internetkapcsolat |
| **Központi Szerver** | Ubuntu Server 24.04 LTS | `192.168.10.10` | OpenLDAP, Apache2, vsftpd, OpenSSH, Cron |
| **Grafikus Kliens** | Ubuntu Desktop 24.04 LTS | `192.168.10.20` | Firefox, FileZilla, OpenSSH Client |

---

## 🛠️ Megvalósított Szolgáltatások

### 1. Központi Címtár (OpenLDAP – Port: 389)
* Központi felhasználó- és csoportkezelés (`internal`, `management`, `admin`).
* A webszerver és az FTP szerver autentikációja közvetlenül a címtárhoz kapcsolódik.

### 2. Többszintű Webszolgáltatás (Apache2 VirtualHosts – Port: 80)
Három különálló aldomain kiszolgálása eltérő jogosultsági szintekkel:
* **`www.bytebridge.lan`**: Publikus, bárki által elérhető céges bemutató oldal.
* **`belso.bytebridge.lan`**: LDAP-hitelesítéssel védett belső portál az összes munkatársnak (`internal` csoport).
* **`vezeto.bytebridge.lan`**: Szigorúan korlátozott felület, kizárólag a projektvezetők számára (`management` csoport).

### 3. Fájlmegosztás (vsftpd – Port: 21)
* **Publikus FTP (`/srv/ftp/publicftp`)**: Névtelen (anonymous) letöltési terület médiaanyagoknak (feltöltés tiltva).
* **Belső FTP (`/srv/ftp/staffftp`)**: Hitelesített munkatársak számára írható/olvasható munkaterület.
* **Vezetőségi FTP (`/srv/ftp/mgmtftp`)**: Korlátozott terület, kizárólag a kiemelt csoport számára írható és olvasható.

### 4. Automatizált Mentés és Menedzsment
* **Bash Backup Script (`/opt/scripts/backup.sh`)**: Automatikusan archiválja a weboldalak fájljait, az FTP könyvtárakat és elvégzi az LDAP címtár exportját.
* **Cron ütemezés**: Napi szintű automatikus lefutás naplózással (`backup.log`) és hibakezeléssel.
* **OpenSSH (Port: 22)**: Biztonságos távoli elérés az üzemeltetők számára.

---

## 🧪 Tesztelés & Eredmények

A rendszer a követelményrendszer összes pontját és biztonsági előírását teljesítette:
* Funkcionális, jogosultsági és hálózati tesztek: **25 / 25 pont (100%)**.
* A részletes tesztelési mátrix és a konfigurációs lépések megtalálhatók a csatolt dokumentációban.

📄 **[A teljes részletes rendszerterv és dokumentáció megtekintése (PDF)](ByteBridge_Dokumentacio.pdf)**
