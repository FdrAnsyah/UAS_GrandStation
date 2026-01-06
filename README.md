# 🚆 GrandStation - Sistem Pemesanan Tiket Kereta Api

Aplikasi web berbasis Java EE untuk sistem pemesanan tiket kereta api yang modern dan responsif.

## 📸 Screenshot
![Home](docs/screenshot-home.png)
*Homepage dengan pencarian jadwal kereta*

## ✨ Fitur Utama

### 👤 User
- ✅ Register & Login
- ✅ Pencarian jadwal kereta berdasarkan rute dan tanggal
- ✅ Booking tiket online
- ✅ Manajemen pesanan
- ✅ Proses pembayaran (Transfer Bank, Kartu Kredit, E-Wallet)
- ✅ Riwayat pembayaran

### 👨‍💼 Admin
- ✅ Dashboard admin
- ✅ Approve/Reject booking
- ✅ Manajemen stasiun (CRUD)
- ✅ Manajemen kereta (CRUD)
- ✅ Manajemen jadwal (CRUD)
- ✅ Lihat semua booking & pembayaran

## 🛠️ Teknologi

- **Backend:** Java 17, Jakarta EE 10
- **Frontend:** JSP, Tailwind CSS
- **Database:** PostgreSQL 13+
- **Build Tool:** Maven 3.8+
- **Server:** Apache Tomcat 10.1.x
- **IDE Support:** NetBeans, VS Code, IntelliJ IDEA

## 🚀 Quick Start

### Prerequisites
```bash
# Java 17+
java -version

# Maven 3.8+
mvn -version

# PostgreSQL 13+
psql --version
```

### Installation

1. **Clone Repository**
```bash
git clone https://github.com/YOUR_USERNAME/UAS_GrandStation.git
cd UAS_GrandStation
```

2. **Setup Database**
```bash
# Buat database
psql -U postgres
CREATE DATABASE grandstation;
\q

# Import database
psql -U postgres -d grandstation -f database_complete.sql
```

3. **Konfigurasi Database**
Edit `src/main/webapp/META-INF/context.xml`:
```xml
<Resource name="jdbc/GrandStationDB"
          ...
          username="postgres"
          password="YOUR_PASSWORD_HERE"
          url="jdbc:postgresql://localhost:5432/grandstation"/>
```

4. **Build Project**
```bash
mvn clean package
```

5. **Deploy ke Tomcat**
- Copy `target/UAS_GrandStation.war` ke `tomcat/webapps/`
- Start Tomcat
- Akses: http://localhost:8080/UAS_GrandStation/

### Default Login
```
Admin:
Email: admin@grandstation.com
Password: admin123

User:
Email: user@grandstation.com
Password: user123
```

## 📖 Dokumentasi Lengkap

Lihat **[PANDUAN_DEPLOYMENT.md](PANDUAN_DEPLOYMENT.md)** untuk:
- Setup lengkap di NetBeans IDE
- Setup lengkap di Visual Studio Code
- Setup lengkap di IntelliJ IDEA
- Troubleshooting common issues

## 📁 Struktur Project

```
UAS_GrandStation/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/     # Servlets
│       │   ├── dao/            # Database Access Layer
│       │   ├── model/          # Entity Models
│       │   └── util/           # Utilities
│       └── webapp/
│           ├── META-INF/
│           │   └── context.xml # Database config
│           ├── WEB-INF/
│           │   └── web.xml     # Web config
│           ├── images/         # Assets
│           └── *.jsp           # View pages
├── database_complete.sql       # Complete DB schema & data
├── PANDUAN_DEPLOYMENT.md       # Deployment guide
├── pom.xml                     # Maven config
└── README.md                   # This file
```

## 🧪 Testing

Setelah deployment, test fitur berikut:

**User Flow:**
- [ ] Register akun baru
- [ ] Login
- [ ] Search jadwal kereta
- [ ] Book tiket
- [ ] Proses pembayaran
- [ ] Lihat riwayat booking

**Admin Flow:**
- [ ] Login sebagai admin
- [ ] Approve/Reject booking
- [ ] CRUD stasiun, kereta, jadwal

## 🤝 Kontribusi

Project ini adalah tugas UAS mata kuliah PBO (Pemrograman Berorientasi Objek).

**Tim Pengembang:**
- [Nama Anggota 1] - NIM
- [Nama Anggota 2] - NIM
- [Nama Anggota 3] - NIM

## 📝 License

This project is licensed under the MIT License.

## 🐛 Issues & Support

Jika menemukan bug atau butuh bantuan:
1. Cek [PANDUAN_DEPLOYMENT.md](PANDUAN_DEPLOYMENT.md) terlebih dahulu
2. Lihat section [Troubleshooting](PANDUAN_DEPLOYMENT.md#troubleshooting)
3. Buat issue baru di GitHub

## 🙏 Acknowledgments

- Dosen Pengampu: [Nama Dosen]
- Tailwind CSS untuk UI framework
- PostgreSQL Team
- Apache Tomcat Team

---

**Developed with ❤️ for UAS PBO Semester 3**

*Last updated: January 6, 2026*
