# UML Diagrams - Diary Runners

Dokumentasi diagram UML lengkap untuk aplikasi **Diary Runners**.

---

## 1. Use Case Diagram

```mermaid
flowchart LR
    subgraph System["📱 Diary Runners App"]
        UC1((Login))
        UC2((Register))
        UC3((Logout))
        UC4((Lihat Dashboard))
        UC5((Buat Training Plan))
        UC6((Rekam Aktivitas Lari))
        UC7((Jelajah Rute))
        UC8((Lihat Event))
        UC9((Kelola Profil))
        UC10((Pengaturan))
        UC11((Hubungkan Smartwatch))
        UC12((Lihat Statistik))
        UC13((Upload Foto Galeri))
    end

    User["👤 Runner/Pengguna"]
    SW["⌚ Smartwatch"]
    GPS["📍 GPS Service"]

    User --> UC1
    User --> UC2
    User --> UC3
    User --> UC4
    User --> UC5
    User --> UC6
    User --> UC7
    User --> UC8
    User --> UC9
    User --> UC10
    User --> UC12
    User --> UC13

    UC6 --> GPS
    UC7 --> GPS
    UC11 --> SW
    UC6 -.->|extend| UC11

    UC1 -.->|include| UC4
    UC2 -.->|include| UC4
    UC9 -.->|include| UC12
```

### Penjelasan Use Case

| Use Case | Aktor | Deskripsi |
|----------|-------|-----------|
| **UC1: Login** | Pengguna | User memasukkan nama dan email untuk masuk ke aplikasi |
| **UC2: Register** | Pengguna | User baru mendaftar dengan mengisi nama dan email |
| **UC3: Logout** | Pengguna | User keluar dari akun dan kembali ke Welcome Screen |
| **UC4: Lihat Dashboard** | Pengguna | Melihat ringkasan aktivitas, jadwal latihan, dan statistik di Home |
| **UC5: Buat Training Plan** | Pengguna | Membuat rencana latihan dengan kalender dan workout schedule |
| **UC6: Rekam Aktivitas Lari** | Pengguna, GPS | Merekam aktivitas lari dengan GPS tracking, timer, dan pace |
| **UC7: Jelajah Rute** | Pengguna, GPS | Mencari dan melihat rute lari populer dengan detail elevasi |
| **UC8: Lihat Event** | Pengguna | Melihat daftar event/kompetisi lari mendatang |
| **UC9: Kelola Profil** | Pengguna | Melihat dan mengedit profil, data fisik, foto |
| **UC10: Pengaturan** | Pengguna | Mengatur notifikasi, bahasa, tema, dan keamanan |
| **UC11: Hubungkan Smartwatch** | Pengguna, Smartwatch | Menghubungkan perangkat wearable untuk sync data |
| **UC12: Lihat Statistik** | Pengguna | Melihat statistik lari (jarak, durasi, pace, log lari) |
| **UC13: Upload Foto Galeri** | Pengguna | Mengunggah foto lari ke galeri profil |

---

## 2. Activity Diagram

### 2.1 Activity Diagram - Login/Register Flow

```mermaid
flowchart TD
    A([Start]) --> B{Sudah Login?}
    B -->|Ya| C[Tampilkan Main Screen]
    B -->|Tidak| D[Tampilkan Welcome Screen]
    
    D --> E{Pilih Aksi}
    E -->|Login| F[Tampilkan Form Login]
    E -->|Register| G[Tampilkan Form Register]
    
    F --> H[Input Nama & Email]
    G --> I[Input Nama & Email]
    
    H --> J{Validasi Input}
    I --> K{Validasi Input}
    
    J -->|Valid| L[Simpan ke SharedPreferences]
    J -->|Invalid| F
    
    K -->|Valid| L
    K -->|Invalid| G
    
    L --> M[Set Status Login = True]
    M --> C
    
    C --> N([End])
```

#### Penjelasan Aktivitas Login/Register:

| Step | Aktivitas | Penjelasan |
|------|-----------|------------|
| 1 | **Cek Status Login** | Aplikasi mengecek SharedPreferences apakah user sudah login sebelumnya |
| 2 | **Tampilkan Welcome/Main** | Jika sudah login → Main Screen, jika belum → Welcome Screen |
| 3 | **Pilih Login/Register** | User memilih untuk masuk atau daftar baru |
| 4 | **Input Data** | User mengisi nama dan email |
| 5 | **Validasi** | Sistem memvalidasi input tidak kosong |
| 6 | **Simpan Data** | Data disimpan ke SharedPreferences (isLoggedIn, userName, userEmail) |
| 7 | **Navigasi ke Main** | User diarahkan ke halaman utama aplikasi |

---

### 2.2 Activity Diagram - Rekam Aktivitas Lari

```mermaid
flowchart TD
    A([Start]) --> B[Buka Record Screen]
    B --> C[Inisialisasi GPS]
    
    C --> D{GPS Aktif?}
    D -->|Tidak| E[Tampilkan Peringatan]
    E --> F[Aktifkan GPS]
    F --> D
    
    D -->|Ya| G[Tampilkan Map & Lokasi]
    G --> H[Tap Tombol Start]
    
    H --> I[Mulai Timer]
    I --> J[Tracking GPS Real-time]
    J --> K[Hitung Jarak & Pace]
    
    K --> L{User Tap Pause?}
    L -->|Ya| M[Pause Timer & Tracking]
    M --> N{Lanjutkan?}
    N -->|Ya| I
    N -->|Tidak| O[Tap Stop]
    
    L -->|Tidak| P{User Tap Stop?}
    P -->|Tidak| J
    P -->|Ya| O
    
    O --> Q[Tampilkan Ringkasan]
    Q --> R[Simpan Aktivitas]
    R --> S([End])
```

#### Penjelasan Aktivitas Rekam Lari:

| Step | Aktivitas | Penjelasan |
|------|-----------|------------|
| 1 | **Buka Record Screen** | User masuk ke halaman rekam aktivitas |
| 2 | **Inisialisasi GPS** | Sistem mengaktifkan layanan lokasi dan GPS |
| 3 | **Cek GPS** | Validasi apakah GPS sudah aktif dan mendapat sinyal |
| 4 | **Tampilkan Map** | Menampilkan peta dengan lokasi user saat ini |
| 5 | **Tap Start** | User menekan tombol mulai untuk memulai rekam |
| 6 | **Mulai Timer** | Timer mulai berjalan menghitung durasi lari |
| 7 | **Tracking GPS** | Sistem melacak posisi user secara real-time |
| 8 | **Hitung Jarak & Pace** | Kalkulasi jarak tempuh dan pace per kilometer |
| 9 | **Pause/Resume** | User bisa pause dan lanjutkan tracking |
| 10 | **Stop & Simpan** | User menyelesaikan lari, data disimpan ke log |

---

### 2.3 Activity Diagram - Lihat Profil

```mermaid
flowchart TD
    A([Start]) --> B[Buka Profile Screen]
    B --> C{User Sudah Login?}
    
    C -->|Tidak| D[Tampilkan Guest View]
    D --> E{Pilih Aksi}
    E -->|Login| F[Navigasi ke Login Screen]
    E -->|Register| G[Navigasi ke Register Screen]
    F --> H[Proses Login]
    G --> H
    H --> B
    
    C -->|Ya| I[Load Data dari SharedPreferences]
    I --> J[Tampilkan Profil User]
    
    J --> K[Pilih Tab]
    K -->|Statistik| L[Tampilkan Total Jarak, Durasi, Lari]
    K -->|Log Lari| M[Tampilkan Riwayat Aktivitas]
    K -->|Galeri| N[Tampilkan Foto & Personal Best]
    
    L --> O{Aksi Lain?}
    M --> O
    N --> O
    
    O -->|Settings| P[Buka Pengaturan]
    O -->|Edit Profil| Q[Edit Data Profil]
    O -->|Selesai| R([End])
```

#### Penjelasan Aktivitas Lihat Profil:

| Step | Aktivitas | Penjelasan |
|------|-----------|------------|
| 1 | **Buka Profile** | User navigasi ke halaman profil |
| 2 | **Cek Login State** | Sistem cek apakah user sudah login via AuthService |
| 3 | **Guest View** | Jika belum login, tampilkan prompt untuk login/register |
| 4 | **Load Data** | Ambil nama dan email dari SharedPreferences |
| 5 | **Tampilkan Profil** | Menampilkan foto, nama, email, dan stat fisik |
| 6 | **Tab Statistik** | Total jarak, durasi, jumlah lari |
| 7 | **Tab Log Lari** | Riwayat aktivitas lari dengan detail |
| 8 | **Tab Galeri** | Foto-foto lari dan catatan Personal Best |

---

## 3. Sequence Diagram

### 3.1 Sequence Diagram - Login Process

```mermaid
sequenceDiagram
    actor User
    participant WS as Welcome Screen
    participant LS as Login Screen
    participant AS as AuthService
    participant SP as SharedPreferences
    participant MS as Main Screen

    User->>WS: Buka Aplikasi
    WS->>AS: isLoggedIn()
    AS->>SP: getBool('isLoggedIn')
    SP-->>AS: false
    AS-->>WS: false
    WS-->>User: Tampilkan Welcome Screen

    User->>WS: Tap "LOGIN"
    WS->>LS: Navigate to Login Screen
    LS-->>User: Tampilkan Form Login

    User->>LS: Input nama & email
    User->>LS: Tap "MASUK"
    
    LS->>AS: login(name, email)
    AS->>SP: setBool('isLoggedIn', true)
    AS->>SP: setString('userName', name)
    AS->>SP: setString('userEmail', email)
    SP-->>AS: Success
    AS-->>LS: Login Success

    LS->>MS: Navigate & Remove Previous
    MS-->>User: Tampilkan Home Screen
```

#### Penjelasan Sequence Login:

| Step | Interaksi | Penjelasan |
|------|-----------|------------|
| 1 | User → App | User membuka aplikasi Diary Runners |
| 2 | App → AuthService | Aplikasi mengecek status login |
| 3 | AuthService → SharedPreferences | Query data login dari local storage |
| 4 | SharedPreferences → AuthService | Return false (belum login) |
| 5 | App → User | Tampilkan Welcome Screen dengan tombol Login/Register |
| 6 | User → Login Screen | User tap tombol LOGIN |
| 7 | User → Form | User mengisi nama dan email |
| 8 | Login Screen → AuthService | Panggil method login() |
| 9 | AuthService → SharedPreferences | Simpan status dan data user |
| 10 | App → Main Screen | Navigasi ke Main Screen setelah login berhasil |

---

### 3.2 Sequence Diagram - Logout Process

```mermaid
sequenceDiagram
    actor User
    participant MS as More Screen
    participant DLG as Confirm Dialog
    participant AS as AuthService
    participant SP as SharedPreferences
    participant WS as Welcome Screen

    User->>MS: Tap Menu "Keluar"
    MS->>DLG: showDialog()
    DLG-->>User: "Anda yakin ingin keluar?"

    alt User Konfirmasi
        User->>DLG: Tap "Keluar"
        DLG->>MS: return true
        MS->>AS: logout()
        AS->>SP: clear()
        SP-->>AS: Data Cleared
        AS-->>MS: Logout Success
        MS->>WS: pushAndRemoveUntil()
        WS-->>User: Tampilkan Welcome Screen
    else User Batal
        User->>DLG: Tap "Batal"
        DLG->>MS: return false
        MS-->>User: Tetap di More Screen
    end
```

#### Penjelasan Sequence Logout:

| Step | Interaksi | Penjelasan |
|------|-----------|------------|
| 1 | User → More Screen | User tap menu "Keluar" |
| 2 | App → Dialog | Tampilkan dialog konfirmasi |
| 3 | User → Konfirmasi | User memilih "Keluar" atau "Batal" |
| 4 | AuthService → SharedPreferences | Hapus semua data login dengan clear() |
| 5 | App → Welcome Screen | Navigasi kembali ke Welcome dan hapus semua route |

---

### 3.3 Sequence Diagram - View Profile

```mermaid
sequenceDiagram
    actor User
    participant PS as Profile Screen
    participant AS as AuthService
    participant SP as SharedPreferences

    User->>PS: Navigasi ke Profile
    PS->>PS: initState()
    PS->>AS: isLoggedIn()
    AS->>SP: getBool('isLoggedIn')
    SP-->>AS: true/false

    alt Sudah Login
        AS-->>PS: true
        PS->>AS: getUserName()
        AS->>SP: getString('userName')
        SP-->>AS: "John Doe"
        AS-->>PS: "John Doe"
        
        PS->>AS: getUserEmail()
        AS->>SP: getString('userEmail')
        SP-->>AS: "john@email.com"
        AS-->>PS: "john@email.com"
        
        PS->>PS: setState()
        PS-->>User: Tampilkan Profil dengan Data User
    else Belum Login
        AS-->>PS: false
        PS-->>User: Tampilkan Guest View
    end
```

#### Penjelasan Sequence View Profile:

| Step | Interaksi | Penjelasan |
|------|-----------|------------|
| 1 | User → Profile Screen | User membuka halaman profil |
| 2 | initState() | Screen melakukan inisialisasi |
| 3 | Check Login | Cek status login dari AuthService |
| 4 | Load User Data | Jika login, ambil nama dan email dari SharedPreferences |
| 5 | setState() | Update UI dengan data yang sudah diload |
| 6 | Render | Tampilkan profil atau guest view |

---

### 3.4 Sequence Diagram - Create Training Plan

```mermaid
sequenceDiagram
    actor User
    participant TS as Training Screen
    participant CAL as Calendar Widget
    participant WK as Workout List

    User->>TS: Buka Tab Latihan
    TS->>CAL: Render Calendar
    CAL-->>User: Tampilkan Kalender Bulan Ini

    User->>TS: Tap "Buat Rencana"
    TS-->>User: Tampilkan Form Plan

    User->>TS: Pilih Jarak (5K/10K/Half/Full)
    User->>TS: Pilih Level (Pemula/Menengah/Lanjut)
    User->>TS: Pilih Hari Latihan
    User->>TS: Set Tanggal Race
    User->>TS: Set Target Waktu
    User->>TS: Tap "Generate Plan"

    TS->>TS: _generateSpecificPlan()
    TS->>TS: Kalkulasi Workout per Hari
    TS->>CAL: Add Events to Calendar
    CAL-->>User: Tampilkan Marker Workout

    User->>CAL: Tap Tanggal dengan Marker
    CAL->>WK: _getEventsForDay()
    WK-->>User: Tampilkan Detail Workout
```

#### Penjelasan Sequence Training Plan:

| Step | Interaksi | Penjelasan |
|------|-----------|------------|
| 1 | User → Training Screen | Buka tab Latihan di bottom nav |
| 2 | Render Calendar | Tampilkan kalender dengan tanggal yang bisa diklik |
| 3 | Buat Rencana | User memulai pembuatan training plan baru |
| 4 | Input Parameter | Pilih jarak, level, hari latihan, tanggal race, target waktu |
| 5 | Generate Plan | Sistem menghitung dan membuat jadwal workout |
| 6 | Update Calendar | Marker workout ditambahkan ke tanggal yang sesuai |
| 7 | Lihat Detail | User tap tanggal untuk melihat detail workout hari itu |

---

## 📋 Ringkasan Diagram

| Diagram | Jumlah | Fokus |
|---------|--------|-------|
| **Use Case** | 1 | 13 Use Cases dengan 3 Aktor |
| **Activity** | 3 | Login/Register, Rekam Lari, Lihat Profil |
| **Sequence** | 4 | Login, Logout, View Profile, Training Plan |

---

*Dokumentasi UML - Diary Runners v1.0.0*
