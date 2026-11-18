# My Portofolio Mobile

### Nama: Fayyad Mohammad Madani

### NPM: 2506622720

### Kelas: PBP A

## Cara Menjalankan Project

1. Clone repository ini:

```bash
git clone <url-repo-ini>
cd myportofolio_mobile
```

2. Unduh seluruh dependensi yang dibutuhkan:

```bash
flutter pub get
```

3. Jalankan aplikasi (pastikan emulator atau peramban Chrome aktif):

```bash
flutter run
```

### Menjalankan Analisis Kode

```bash
flutter analyze
```

### Menjalankan Test

```bash
flutter test
```

### Tugas 8

1. **Jelaskan perbedaan antara `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Metode  
   apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa  
   pengguna kembali ke halaman utama.**
   - **`Navigator.push()`**: Menambahkan (_push_) sebuah _route_ (halaman baru) ke bagian paling atas tumpukan  
     (_stack_) navigasi. Halaman sebelumnya tetap tersimpan di dalam memori di bawahnya, sehingga pengguna dapat  
     kembali ke halaman asal menggunakan tombol _Back_ bawaan sistem atau navigasi kembali programatis.
   - **`Navigator.pushReplacement()`**: Menghapus _route_ yang sedang aktif di puncak _stack_ dan langsung
     menggantikannya dengan _route_ baru. Stack navigasi tidak bertambah panjang, sehingga mencegah penumpukan  
     halaman yang berulang (sangat ideal untuk navigasi menu drawer agar memori aplikasi tetap efisien).
   - **`Navigator.pop()`**: Menghapus (_pop_) _route_ teratas dari _stack_ dan mengembalikan pengguna ke halaman  
     yang tepat berada di bawahnya pada _stack_.
   - **Metode pada Kartu Aksi**: Membuka formulir dari kartu aksi menggunakan **`Navigator.push()`**. Tujuannya  
     agar pengguna dapat kembali ke halaman utama cukup dengan menekan tombol _Back_ perangkat atau tombol kembali  
     peramban.
   - **Opsi Home di Drawer**: Opsi Home menggunakan **`Navigator.pushReplacement()`** untuk menggantikan halaman  
     formulir yang sedang aktif dengan instance `MyHomePage()`, sehingga tumpukan _route_ tidak membengkak dan alur  
     kembali tetap bersih.
   2. **Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` membantu menjaga struktur halaman tetap konsisten?  
      Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.**
      - **Konsistensi Struktur**: `Scaffold` bertindak sebagai kerangka arsitektur visual standar Material Design  
        yang membagi tata letak menjadi zona-zona terprediksi (`appBar` di atas, `drawer` di samping, dan `body` di  
        tengah). Dengan menggunakan `AppBar` dan `Drawer` yang seragam di setiap halaman (`MyHomePage`,
        `ProjectFormPage`, dan `ExperienceFormPage`), pengguna disajikan hierarki visual, ikon menu hamburger, serta  
        alur navigasi yang konsisten di mana pun mereka berada di dalam aplikasi.
      - **Contoh Konsistensi Warna Tema**: Penggunaan warna `Colors.indigo` yang konsisten diterapkan sebagai warna  
        dasar pada:
        - Header `Drawer` (`BoxDecoration(color: Colors.indigo)` di `LeftDrawer`).
        - Latar belakang `AppBar` pada halaman formulir proyek dan formulir pengalaman (`backgroundColor:
Colors.indigo`).
        - Latar belakang tombol utama Simpan (`ElevatedButton` dengan `WidgetStateProperty.all(Colors.indigo)`).

   3. **Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget
      penggulir ketika ruang layar terbatas.**
      - **Alasan Pemilihan Tata Letak**: Formulir disusun secara vertikal menggunakan widget `Column` di dalam
        `Form` karena alur pengisian data manusiawi bergerak secara linier dari atas ke bawah (Nama $\rightarrow$  
        Instansi $\rightarrow$ Tipe $\rightarrow$ Rentang Waktu $\rightarrow$ Deskripsi $\rightarrow$ Simpan).
      - **Peran Widget Pengatur Jarak (`Padding` / `SizedBox`)**: Memberikan margin visual yang rapi dan memisahkan  
        setiap kolom masukan agar tidak berhimpitan, sehingga pengguna dapat membedakan batas-batas bidang sentuh  
        formulir dengan nyaman (_touch targets_ yang ergonomis).
      - **Peran Widget Penggulir (`SingleChildScrollView`)**: Sangat krusial untuk mencegah galat _RenderFlex
        overflowed_. Ketika pengguna mengetik, papan ketik virtual (_soft keyboard_) akan muncul dari bawah dan
        menyita lebih dari separuh tinggi layar. `SingleChildScrollView` memastikan area formulir dapat digulir ke  
        atas dan tombol Simpan tetap dapat dijangkau meskipun ruang pandang layar menjadi sangat sempit.

   4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat tombol Simpan ditekan? Berikan satu  
      contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum  
      cukup.**
      - **Peran Komponen Form**:
        - `GlobalKey<FormState>`: Kunci identitas unik yang memberikan akses langsung ke _state_ internal dari
          widget `Form` (`FormState`).
        - `validate()`: Fungsi pada `FormState` yang dipanggil ketika tombol Simpan ditekan untuk memicu eksekusi  
          seluruh fungsi `validator` pada setiap bidang input (`TextFormField`) di dalam form secara serempak.
        - `validator`: Logika fungsi evaluasi pada masing-masing field yang menerima input pengguna (`String?
value`) dan mengembalikan string pesan kesalahan jika data tidak sesuai aturan, atau `null` jika data valid.
      - **Contoh Nilai yang Ditolak**: Nilai berupa string kosong atau hanya berisi spasi (`"   "`). Aturan validasi  
        `value == null || value.trim().isEmpty` akan mendeteksi nilai tersebut dan mengembalikan pesan error seperti  
        _"Nama instansi/perusahaan tidak boleh kosong!"_.
      - **Mengapa Input/Keyboard Saja Belum Cukup**: Mengatur tipe keyboard (seperti `keyboardType:
TextInputType.emailAddress` atau `number`) hanya sekadar mempermudah pengguna memilih karakter pada papan  
        ketik, bukan mencegah masukan yang keliru. Pengguna tetap dapat memasukkan teks kosong, spasi acak, atau
        karakter tidak sah melalui _copy-paste_. Oleh karena itu, logika validasi sisi aplikasi (`validator`) tetap  
        mutlak diperlukan untuk menjamin integritas data sebelum diproses.

   ***

   ### Pembaruan AI Disclosure (Tugas 8)

   Tools yang Digunakan: Gemini

   Strategi Prompting:
   - **Perencanaan Waktu & Dekonstruksi Tugas**: Meminta pembagian waktu pengerjaan yang terstruktur (time-boxed 60  
     menit) per fase untuk Tugas 8 agar fokus pengerjaan tetap efisien dan sistematis.
   - **Rancangan Entitas Model Baru**: Mengarahkan formulasi field formulir `ExperienceFormPage` dengan penambahan  
     logika kondisional status "Masih Berlangsung" (`_isOngoing`) menggunakan `CheckboxListTile` yang secara dinamis  
     menyembunyikan/menonaktifkan input tanggal selesai.
   - **Formulasi Pertanyaan Reflektif**: Meminta bantuan sintesis konseptual untuk 4 pertanyaan reflektif Tugas 8  
     berbasis implementasi kode aktual pada repositori.

   Keterbatasan AI & Perbaikan Manual:
   - Tampilan perlu diperbaiki secara manual dengan melihat langsung aplikasi yang berjalan
