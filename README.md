# 🚆 GrandStation - Sistem Pemesanan Tiket Kereta Api

Aplikasi web modern untuk pemesanan tiket kereta api dengan antarmuka responsif, dibangun dengan Java EE, JSP, dan PostgreSQL.

## ✨ Fitur Utama

### 👤 User
- ✅ **Register & Login** - Pendaftaran akun dan autentikasi aman
- ✅ **Pencarian Jadwal** - Cari kereta berdasarkan rute, tanggal, dan stasiun asal/tujuan
- ✅ **Booking Online** - Pemesanan tiket dengan sistem kursi real-time
- ✅ **Manajemen Pesanan** - Lihat, lacak, dan kelola semua pesanan
- ✅ **Pembayaran Online** - Dukungan Transfer Bank, Kartu Kredit, E-Wallet
- ✅ **Galeri** - Lihat foto stasiun dan kereta
- ✅ **Hubungi Kami** - Form kontak langsung ke admin
- ✅ **Request Jadwal** - Minta jadwal kereta yang tidak tersedia (auto-logged)

### 👨‍💼 Admin
- ✅ **Dashboard Admin** - Ringkasan statistik booking, kereta, stasiun
- ✅ **Approve/Reject Booking** - Kelola pesanan dengan status real-time
- ✅ **Manajemen Stasiun** - CRUD stasiun kereta (Create, Read, Update, Delete)
- ✅ **Manajemen Kereta** - CRUD kereta dengan info kelas dan kapasitas
- ✅ **Manajemen Jadwal** - CRUD jadwal dengan waktu dan harga dinamis
- ✅ **Kelola Galeri** - CRUD foto galeri stasiun dan kereta
- ✅ **Kelola Pesanan** - Lihat semua booking dan filter status
- ✅ **Request User** - Kelola permintaan jadwal dari user/guest dan buat jadwal baru

## 🛠️ Teknologi & Requirements

| Komponen | Versi | Status |
|----------|-------|--------|
| **Java JDK** | 17+ | ✅ Required |
| **Jakarta EE** | 10 | ✅ Required |
| **Apache Maven** | 3.8+ | ✅ Required |
| **PostgreSQL** | 13+ | ✅ Required |
| **Apache Tomcat** | 10.1.x | ✅ Required |
| **Tailwind CSS** | 3.x | ✅ Included (CDN) |
| **Space Grotesk Font** | Latest | ✅ Included (CDN) |

## 🚀 Quick Start

### 1️⃣ Prerequisites Check
```bash
# Verify Java 17+
java -version

# Verify Maven 3.8+
mvn -version

# Verify PostgreSQL 13+
psql --version
```

### 2️⃣ Clone Repository
```bash
git clone https://github.com/FdrAnsyah/UAS_GrandStation.git
cd UAS_GrandStation
```

### 3️⃣ Database Setup
```bash
# Login to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE grandstation;

# Exit psql
\q

# Import schema & data
psql -U postgres -d grandstation -f database_complete.sql
```

### 4️⃣ Build Project
```bash
# Clean and package
mvn clean package

# Or with skip tests
mvn clean package -DskipTests
```

### 5️⃣ Deploy to Tomcat
See [PANDUAN_DEPLOYMENT.md](PANDUAN_DEPLOYMENT.md) for detailed IDE-specific instructions.

### 6️⃣ Access Application
```
🏠 Homepage: http://localhost:8080/UAS_GrandStation/
📊 Admin: http://localhost:8080/UAS_GrandStation/admin-manage
👤 Login: http://localhost:8080/UAS_GrandStation/login
```

## 📝 Default Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | `admin@grandstation.com` | `admin123` |
| User | `user@grandstation.com` | `user123` |

> ⚠️ **Warning:** Ganti password di production! Hash password menggunakan bcrypt atau algoritma aman lainnya.

## 📁 Project Structure

```
UAS_GrandStation/
├── src/main/java/
│   ├── controller/          # Servlet controllers
│   ├── dao/                 # Data Access Objects
│   ├── model/               # Entity models
│   └── util/                # Utility classes
├── src/main/webapp/
│   ├── admin-content/       # Admin pages
│   ├── admin-*.jsp          # Admin layouts
│   ├── *.jsp                # User pages
│   └── WEB-INF/
│       └── web.xml          # Deployment descriptor
├── pom.xml                  # Maven configuration
├── database_complete.sql    # Database schema & data
├── PANDUAN_DEPLOYMENT.md    # Deployment guide
└── README.md                # This file
```

## 🗄️ Database Schema

### Core Tables
- **users** - User & admin accounts
- **stations** - Stasiun kereta
- **trains** - Data kereta api
- **schedules** - Jadwal keberangkatan
- **bookings** - Pesanan tiket
- **payments** - Data pembayaran
- **schedule_requests** - Permintaan jadwal dari user
- **gallery_items** - Foto galeri

### Key Features
- Foreign key constraints untuk integritas data
- Indexes pada kolom yang sering dicari
- DEFAULT values dan CHECK constraints
- CASCADE delete untuk hubungan parent-child
- Timestamps (created_at, updated_at, last_requested_at)

## 📖 User Guide

### Untuk Pengguna Biasa (User)
1. Daftar akun melalui halaman Register
2. Login dengan email dan password
3. Cari jadwal kereta di halaman Schedules
4. Pilih kereta dan isi data penumpang
5. Lakukan pembayaran
6. Terima konfirmasi booking

### Untuk Administrator
1. Login dengan akun admin
2. Akses dashboard dari sidebar
3. Kelola stasiun, kereta, jadwal
4. Approve/reject booking dari user
5. Kelola galeri foto
6. Monitor request jadwal dan buat jadwal baru

## 🐛 Troubleshooting

### Database Connection Error
- Pastikan PostgreSQL berjalan: `psql -U postgres`
- Verifikasi `database_complete.sql` sudah diimport
- Cek parameter koneksi di kode aplikasi

### Tomcat Deploy Error
- Bersihkan folder `work` di Tomcat
- Hapus file `.war` lama di folder `webapps`
- Rebuild project: `mvn clean package`

### Page Not Found (404)
- Verifikasi nama context: `/UAS_GrandStation`
- Pastikan Tomcat telah me-reload aplikasi
- Check Tomcat logs di `logs/catalina.out`

## 📞 Support & Contact

Untuk pertanyaan atau laporan bug:
- Email: `admin@grandstation.com`
- Hubungi melalui form "Hubungi Kami" di aplikasi

## 📄 License

Project ini adalah assignment akademik. Silakan gunakan untuk keperluan pembelajaran.

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
