# 📚 PANDUAN DEPLOYMENT GRANDSTATION
## Sistem Pemesanan Tiket Kereta Api

---

## 📋 Daftar Isi
1. [Persiapan Awal](#persiapan-awal)
2. [Setup Database PostgreSQL](#setup-database-postgresql)
3. [Deployment di NetBeans IDE](#deployment-di-netbeans-ide)
4. [Deployment di Visual Studio Code](#deployment-di-visual-studio-code)
5. [Deployment di JetBrains IntelliJ IDEA](#deployment-di-jetbrains-intellij-idea)
6. [Testing Aplikasi](#testing-aplikasi)
7. [Troubleshooting](#troubleshooting)

---

## 🔧 Persiapan Awal

### Software yang Dibutuhkan
1. **Java Development Kit (JDK) 17 atau lebih tinggi**
   - Download: https://www.oracle.com/java/technologies/downloads/
   - Atau gunakan OpenJDK: https://adoptium.net/

2. **Apache Maven 3.8+**
   - Download: https://maven.apache.org/download.cgi
   - Atau install via package manager

3. **PostgreSQL 13+**
   - Download: https://www.postgresql.org/download/
   - Catat username dan password saat instalasi

4. **Apache Tomcat 10.1.x**
   - Download: https://tomcat.apache.org/download-10.cgi
   - Ekstrak ke folder pilihan Anda

5. **IDE (Pilih salah satu):**
   - NetBeans 17+ (Recommended untuk Java EE)
   - Visual Studio Code + Extensions
   - IntelliJ IDEA Community/Ultimate

### Verifikasi Instalasi
```bash
# Cek Java
java -version
# Output: java version "17.x.x" atau lebih tinggi

# Cek Maven
mvn -version
# Output: Apache Maven 3.x.x

# Cek PostgreSQL
psql --version
# Output: psql (PostgreSQL) 13.x atau lebih tinggi
```

---

## 🗄️ Setup Database PostgreSQL

### Langkah 1: Buat Database
1. Buka **pgAdmin** atau gunakan terminal PostgreSQL:
```sql
-- Via pgAdmin: Klik kanan Databases → Create → Database
-- Nama database: grandstation

-- Atau via terminal:
psql -U postgres
CREATE DATABASE grandstation;
```

### Langkah 2: Import Database
1. Buka file `database_complete.sql` yang sudah disediakan
2. Jalankan script via pgAdmin atau terminal:

**Via pgAdmin:**
- Klik kanan database `grandstation` → Query Tool
- Buka file `database_complete.sql`
- Klik tombol Execute (▶️)

**Via Terminal:**
```bash
psql -U postgres -d grandstation -f database_complete.sql
```

### Langkah 3: Verifikasi Database
```sql
-- Cek tabel yang sudah dibuat
\dt

-- Cek data users
SELECT * FROM users;

-- Cek data stasiun
SELECT * FROM stations;

-- Cek jadwal kereta
SELECT * FROM schedules;
```

### Langkah 4: Konfigurasi Koneksi
Edit file `src/main/webapp/META-INF/context.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context>
    <Resource name="jdbc/GrandStationDB"
              auth="Container"
              type="javax.sql.DataSource"
              maxTotal="20"
              maxIdle="5"
              maxWaitMillis="10000"
              username="postgres"
              password="YOUR_PASSWORD_HERE"
              driverClassName="org.postgresql.Driver"
              url="jdbc:postgresql://localhost:5432/grandstation"/>
</Context>
```
⚠️ **PENTING:** Ganti `YOUR_PASSWORD_HERE` dengan password PostgreSQL Anda!

---

## 🟢 Deployment di NetBeans IDE

### Langkah 1: Install NetBeans
1. Download NetBeans 17+ dari https://netbeans.apache.org/
2. Pilih versi "Jakarta EE" atau "All" bundle
3. Install dan jalankan NetBeans

### Langkah 2: Konfigurasi Tomcat di NetBeans
1. Buka NetBeans → Menu **Tools** → **Servers**
2. Klik **Add Server...**
3. Pilih **Apache Tomcat** → Next
4. Browse ke folder instalasi Tomcat Anda
5. Set username dan password (admin/admin)
6. Klik **Finish**

### Langkah 3: Import Project
1. **File** → **Open Project**
2. Browse ke folder `UAS_GrandStation`
3. NetBeans akan mendeteksi sebagai Maven project
4. Klik **Open Project**

### Langkah 4: Konfigurasi Database di NetBeans
1. Buka tab **Services** (Ctrl+5)
2. Klik kanan **Databases** → **New Connection...**
3. Driver: **PostgreSQL**
4. Host: `localhost`, Port: `5432`, Database: `grandstation`
5. Username: `postgres`, Password: (password Anda)
6. Klik **Test Connection** → harus sukses
7. Klik **OK**

### Langkah 5: Build Project
1. Klik kanan project **UAS_GrandStation**
2. Pilih **Clean and Build**
3. Tunggu Maven download dependencies
4. Build harus sukses (BUILD SUCCESS)

### Langkah 6: Deploy & Run
1. Klik kanan project → **Run**
2. Atau tekan **F6**
3. NetBeans akan otomatis deploy ke Tomcat
4. Browser akan terbuka otomatis ke: `http://localhost:8080/UAS_GrandStation/`

---

## 🔵 Deployment di Visual Studio Code

### Langkah 1: Install Extensions
Buka VS Code → Extensions (Ctrl+Shift+X), install:
1. **Extension Pack for Java** (Microsoft)
2. **Maven for Java** (Microsoft)
3. **Tomcat for Java** (Wei Shen)
4. **PostgreSQL** (Chris Kolkman) - Optional

### Langkah 2: Open Project
1. **File** → **Open Folder**
2. Pilih folder `UAS_GrandStation`
3. VS Code akan mendeteksi Maven project

### Langkah 3: Konfigurasi Tomcat
1. Tekan **Ctrl+Shift+P**
2. Ketik: **Tomcat: Add Tomcat Server**
3. Browse ke folder instalasi Tomcat
4. Server akan muncul di **TOMCAT SERVERS** panel

### Langkah 4: Build Project
**Via Terminal (Ctrl+`):**
```bash
# Build project
mvn clean package

# Output:
# [INFO] BUILD SUCCESS
# [INFO] Total time: xx.xxx s
```

### Langkah 5: Deploy ke Tomcat
1. Buka **Explorer** (Ctrl+Shift+E)
2. Klik kanan `target/UAS_GrandStation.war`
3. Pilih **Run on Tomcat Server**

**Atau via Terminal:**
```bash
# Copy WAR ke Tomcat
copy target\UAS_GrandStation.war C:\path\to\tomcat\webapps\

# Start Tomcat
cd C:\path\to\tomcat\bin
.\startup.bat
```

### Langkah 6: Akses Aplikasi
Buka browser: `http://localhost:8080/UAS_GrandStation/`

---

## 🔴 Deployment di JetBrains IntelliJ IDEA

### Langkah 1: Import Project
1. **File** → **Open**
2. Pilih folder `UAS_GrandStation`
3. IntelliJ akan auto-detect sebagai Maven project
4. Klik **Trust Project**

### Langkah 2: Konfigurasi Tomcat
1. **Run** → **Edit Configurations...**
2. Klik **+** → **Tomcat Server** → **Local**
3. Di tab **Server**:
   - Application server: Browse ke Tomcat installation
   - HTTP port: 8080
4. Di tab **Deployment**:
   - Klik **+** → **Artifact...**
   - Pilih `UAS_GrandStation:war exploded`
   - Application context: `/UAS_GrandStation`
5. Klik **OK**

### Langkah 3: Konfigurasi Database
1. Buka tab **Database** (View → Tool Windows → Database)
2. Klik **+** → **Data Source** → **PostgreSQL**
3. Host: `localhost`, Port: `5432`
4. Database: `grandstation`
5. User: `postgres`, Password: (password Anda)
6. Klik **Test Connection** → harus sukses
7. Klik **OK**

### Langkah 4: Build Project
1. **Build** → **Build Project** (Ctrl+F9)
2. Atau klik ikon hammer 🔨
3. Maven akan download dependencies

### Langkah 5: Run Aplikasi
1. Klik ikon **Play** (▶️) di toolbar
2. Atau tekan **Shift+F10**
3. Tomcat akan start dan deploy aplikasi
4. Browser terbuka otomatis

---

## ✅ Testing Aplikasi

### User Credentials untuk Testing
```
Admin:
- Email: admin@grandstation.com
- Password: admin123

User Demo:
- Email: user@grandstation.com
- Password: user123

Customer 1:
- Email: customer1@gmail.com
- Password: password123
```

### Fitur yang Harus Ditest

#### 1. **User Flow**
- [ ] Register akun baru
- [ ] Login dengan akun user
- [ ] Cari jadwal kereta
- [ ] Booking tiket
- [ ] Lihat daftar booking
- [ ] Proses pembayaran
- [ ] Logout

#### 2. **Admin Flow**
- [ ] Login dengan akun admin
- [ ] Lihat dashboard admin
- [ ] Approve/Reject booking
- [ ] Manage stasiun (Create, Read, Update, Delete)
- [ ] Manage kereta (CRUD)
- [ ] Manage jadwal (CRUD)
- [ ] Lihat semua bookings

#### 3. **Test URLs**
```
Homepage:
http://localhost:8080/UAS_GrandStation/

Login:
http://localhost:8080/UAS_GrandStation/login

Register:
http://localhost:8080/UAS_GrandStation/register

Admin Panel:
http://localhost:8080/UAS_GrandStation/index.jsp?halaman=admin

Booking List:
http://localhost:8080/UAS_GrandStation/bookings
```

---

## 🐛 Troubleshooting

### Problem 1: Port 8080 Already in Use
**Error:** `Port 8080 is already in use`

**Solusi:**
```bash
# Windows - Kill process di port 8080
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F

# Atau ubah port Tomcat
# Edit: tomcat/conf/server.xml
# Cari: <Connector port="8080" ...
# Ubah ke: <Connector port="8081" ...
```

### Problem 2: Database Connection Failed
**Error:** `Cannot connect to database`

**Solusi:**
1. Pastikan PostgreSQL running:
   ```bash
   # Windows
   services.msc → PostgreSQL → Start

   # Linux/Mac
   sudo systemctl start postgresql
   ```

2. Cek password di `context.xml` sudah benar
3. Cek database `grandstation` sudah ada
4. Test connection via pgAdmin

### Problem 3: Class Not Found Exception
**Error:** `ClassNotFoundException: org.postgresql.Driver`

**Solusi:**
1. Cek `pom.xml` ada dependency PostgreSQL:
   ```xml
   <dependency>
       <groupId>org.postgresql</groupId>
       <artifactId>postgresql</artifactId>
       <version>42.7.1</version>
   </dependency>
   ```

2. Rebuild project:
   ```bash
   mvn clean install
   ```

### Problem 4: NoSuchMethodError di JSP
**Error:** `NoSuchMethodError: model.Booking.getKodeBooking()`

**Solusi:**
1. Clean Tomcat work directory:
   ```bash
   # Stop Tomcat
   # Hapus folder: tomcat/work/Catalina/localhost/UAS_GrandStation
   # Start Tomcat lagi
   ```

2. Rebuild project:
   ```bash
   mvn clean package -DskipTests
   ```

### Problem 5: 404 Not Found
**Error:** `HTTP Status 404 – Not Found`

**Solusi:**
1. Pastikan WAR file ada di `tomcat/webapps/`
2. Cek context path: `/UAS_GrandStation` (bukan `/UAS_GrandStation/`)
3. Tunggu Tomcat selesai deploy (lihat log)
4. Cek URL: `http://localhost:8080/UAS_GrandStation/index.jsp`

### Problem 6: Maven Build Failed
**Error:** `BUILD FAILURE`

**Solusi:**
1. Update Maven:
   ```bash
   mvn -version
   ```

2. Clear Maven cache:
   ```bash
   mvn dependency:purge-local-repository
   mvn clean install
   ```

3. Cek Java version:
   ```bash
   java -version
   # Harus Java 17+
   ```

### Problem 7: Tomcat Permission Denied (Linux/Mac)
**Error:** `Permission denied`

**Solusi:**
```bash
# Berikan execute permission
chmod +x tomcat/bin/*.sh

# Start Tomcat
./tomcat/bin/startup.sh
```

---

## 📞 Kontak & Support

Jika masih ada masalah:
1. Cek log Tomcat: `tomcat/logs/catalina.out`
2. Cek log aplikasi di IDE console
3. Hubungi kelompok untuk diskusi

---

## 📝 Catatan Penting

⚠️ **SECURITY WARNING:**
- Password di database masih **plain text** untuk demo
- Di production, gunakan **BCrypt** untuk hash password
- Ganti semua default password
- Jangan expose database ke internet

⚠️ **BEFORE PRODUCTION:**
- Update password users
- Enable HTTPS
- Setup proper firewall
- Backup database regularly
- Update dependencies ke versi terbaru

---

## 🎉 Selamat!

Aplikasi GrandStation sudah siap digunakan!

**Happy Coding! 🚀**

---

*Last updated: January 6, 2026*
*Version: 1.0.0*
