SURGA TANI (Survei Harga Pertanian)
<p align="center">
<img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS-brightgreen.svg" alt="Platform">
<img src="https://img.shields.io/badge/Flutter-3.x-blue.svg" alt="Flutter">
<img src="https://img.shields.io/badge/License-MIT-blueviolet.svg" alt="License">
</p>

SURGA TANI adalah aplikasi mobile yang dibangun menggunakan Flutter untuk melakukan survei dan pencatatan harga komoditi pertanian. Aplikasi ini dirancang untuk petugas lapangan agar dapat dengan mudah mendokumentasikan harga di berbagai subsektor pertanian secara efisien dan akurat.

📸 Tampilan Aplikasi
Dashboard Utama

Daftar Riwayat

Form Input







Detail & Edit

Pratinjau PDF

[Gambar Halaman Edit]

[Gambar Pratinjau PDF]

✨ Fitur Utama
🎛️ Dashboard Multi-Kategori: Antarmuka utama untuk memilih subsektor yang akan disurvei:

🌾 Tanaman Pangan

🍎 Hortikultura

🐄 Peternakan

🌴 Perkebunan

📝 Form Input Dinamis: Setiap kategori memiliki formulir pencatatan yang dirancang khusus sesuai dengan struktur datanya, termasuk item dengan sub-item (untuk Peternakan).

➕ Daftar Komoditi Fleksibel: Pengguna dapat menambahkan item komoditi baru di luar daftar default saat melakukan pencatatan.

📷 Dokumentasi Foto: Kemampuan untuk mengunggah beberapa foto sebagai bukti dokumentasi untuk setiap catatan.

💾 Penyimpanan Data Lokal: Semua data pencatatan disimpan secara aman di perangkat menggunakan database Hive yang cepat dan efisien.

📄 Cetak ke PDF: Setiap catatan dapat diekspor menjadi laporan PDF yang rapi, lengkap dengan kop, detail data, tanda tangan, dan lampiran foto.

🎨 Ikon Aplikasi Kustom: Identitas visual yang unik untuk aplikasi SURGA TANI.

🛠️ Teknologi & Library yang Digunakan
Framework: Flutter

Bahasa: Dart

Database Lokal: Hive

Manajemen State: Provider & State Management lokal (StatefulWidget)

Pembuatan PDF: pdf & printing

Pemilih Gambar: image_picker

Notifikasi: top_snackbar_flutter

Ikon Aplikasi: flutter_launcher_icons

Format Tanggal: intl

🚀 Cara Menjalankan Proyek
Untuk menjalankan proyek ini di lingkungan lokal Anda, ikuti langkah-langkah berikut:

1. Prasyarat

Pastikan Anda sudah menginstal Flutter SDK di komputer Anda.

Sebuah emulator Android atau iOS, atau perangkat fisik.

2. Clone Repositori

git clone https://github.com/[NamaUsernameAnda]/surga_tani.git
cd surga_tani

3. Instal Dependensi
Jalankan perintah ini untuk mengunduh semua package yang dibutuhkan.

flutter pub get

4. Generate File untuk Hive
Aplikasi ini menggunakan build_runner untuk men-generate adapter Hive. Jalankan perintah ini:

dart run build_runner build --delete-conflicting-outputs

5. Jalankan Aplikasi
Hubungkan perangkat atau jalankan emulator, lalu jalankan perintah:

flutter run

📂 Struktur Proyek
Proyek ini disusun dengan arsitektur modular untuk memisahkan setiap kategori dengan rapi.

lib/
├── models/         # Berisi semua model data Hive untuk setiap kategori
├── providers/      # State management (khusus untuk form Tanaman Pangan)
├── screens/        # Berisi semua file UI (halaman)
│   ├── home_screen.dart          # Halaman Dashboard Utama
│   ├── record_list_screen.dart   # Halaman generik untuk daftar riwayat
│   ├── form_[kategori]_screen.dart  # Form input untuk setiap kategori
│   └── detail_[kategori]_screen.dart # Halaman detail & edit untuk setiap kategori
├── services/       # Logika bisnis (seperti PdfService)
├── utils/          # Tema aplikasi, konstanta, dll.
└── main.dart       # Titik masuk utama aplikasi

🤝 Kontribusi
Kontribusi untuk pengembangan proyek ini sangat kami hargai. Jika Anda ingin berkontribusi, silakan lakukan fork pada repositori ini dan buat pull request untuk setiap perubahan yang Anda usulkan.

Fork repositori ini.

Buat branch baru (git checkout -b fitur/FiturBaru).

Commit perubahan Anda (git commit -m 'Menambahkan FiturBaru').

Push ke branch Anda (git push origin fitur/FiturBaru).

Buka sebuah Pull Request.

📄 Hak Cipta & Lisensi
Hak Cipta © 2025, [Nama Anda atau Nama Perusahaan Anda].

Proyek ini dilisensikan di bawah Lisensi MIT. Lihat file LICENSE untuk detail lebih lanjut.