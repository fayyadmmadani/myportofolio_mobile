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

### Tugas 7

1. **Jelaskan apa yang dimaksud dengan *widget tree* pada Flutter dan bagaimana hubungan induk-anak (*parent-child*) bekerja antar-widget!**  
   *Widget tree* adalah struktur hierarki berformat pohon objek yang merepresentasikan seluruh elemen visual, struktur tata letak (*layout*), hingga aturan gaya (*styling*) pada aplikasi Flutter. Di Flutter, hampir segala sesuatu adalah widget, mulai dari elemen struktural tingkat atas seperti `MaterialApp` dan `Scaffold`, hingga komponen terkecil seperti `Text` dan `Icon`.  
   Hubungan induk-anak (*parent-child*) bekerja melalui mekanisme *constraints go down, sizes go up, parent sets position*:
   - **Parent to Child**: Widget induk meneruskan batasan ukuran (*layout constraints* berupa lebar dan tinggi minimum serta maksimum) ke widget anak di bawahnya.
   - **Child to Parent**: Widget anak menentukan ukuran geometrisnya sendiri di dalam batasan yang telah ditetapkan tersebut, lalu melaporkan ukurannya kembali ke widget induk.
   - **Penempatan**: Widget induk bertanggung jawab menentukan posisi koordinat spasial anak (misalnya perataan horizontal pada `Row` atau vertikal pada `Column`). Selain itu, jika *state* pada widget induk mengalami pembaruan, Flutter akan memicu proses pembangunan ulang (*rebuild*) pada cabang *child tree* di bawahnya.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**  
   Berikut adalah seluruh widget yang digunakan dalam proyek ini:
   - `MyApp` (`StatelessWidget`): Widget akar (*root bootstrap*) yang menginisialisasi konfigurasi tema dasar dan menentukan halaman awal aplikasi.
   - `MaterialApp`: Widget pembungkus tingkat atas yang menyediakan fungsionalitas Material Design global, termasuk navigasi, lokalisasi, dan skema tema (`ThemeData`).
   - `MyHomePage` (`StatelessWidget`): Halaman beranda utama yang menampung kartu profil informasi dan kisi tombol aksi portofolio.
   - `Scaffold`: Kerangka struktur tata letak visual dasar yang menyediakan slot standar seperti `AppBar`, `body`, dan fasilitator `SnackBar`.
   - `AppBar`: Bilah navigasi di bagian atas layar aplikasi yang menampilkan judul `MyPortfolio`.
   - `Text`: Menampilkan string teks pada antarmuka dengan konfigurasi tipografi seperti ketebalan font (*fontWeight*), ukuran (*fontSize*), dan warna (*color*).
   - `SingleChildScrollView`: Widget pembungkus yang memungkinkan seluruh konten pada `body` dapat digulir (*scrollable*), sekaligus mencegah terjadinya galat *overflow* pada layar beresolusi pendek.
   - `Padding`: Memberikan jarak ruang kosong di sekeliling widget anaknya.
   - `Column`: Menyusun widget-widget anaknya secara linear vertikal (dari atas ke bawah).
   - `Center`: Memosisikan widget anak tepat di tengah-tengah ruang yang tersedia.
   - `SizedBox`: Memberikan jarak pemisah dengan dimensi statis (tinggi/lebar) antar-elemen widget.
   - `InfoCard` (`StatelessWidget`): Widget kustom modular untuk menampilkan identitas (NPM, Name, Class).
   - `Card`: Menampilkan bidang kartu permukaan bergaya Material dengan kelengkungan sudut dan elevasi bayangan (*shadow*).
   - `Container`: Wadah fleksibel untuk mengatur dimensi ukuran (`width: double.infinity`) dan *inner padding*.
   - `GridView.count`: Menampilkan daftar kartu menu dalam tata letak kisi (*grid*) dua dimensi dengan pembagian jumlah kolom tertentu (`crossAxisCount: 3`).
   - `ItemCard` (`StatelessWidget`): Widget kustom modular yang merepresentasikan tombol aksi portofolio.
   - `Material`: Menyediakan kanvas Material Design untuk pewarnaan latar tombol (`color: item.color`) serta kelengkungan sudut (`borderRadius`).
   - `InkWell`: Menambahkan interaktivitas sentuhan dengan efek animasi percikan tinta (*ripple effect*) ketika tombol kartu diklik.
   - `Icon`: Menampilkan simbol grafis vektor dari pustaka Material Icons yang relevan dengan aksi menu.
   - `SnackBar`: Menampilkan bilah notifikasi interaktif sementara di bagian bawah layar saat tombol ditekan.

3. **Apa fungsi dari widget `MaterialApp`? Jelaskan mengapa widget ini umumnya digunakan sebagai *root widget* pada aplikasi Flutter!**  
   Widget `MaterialApp` berfungsi sebagai gerbang utama penyedia layanan arsitektur Material Design pada aplikasi. Widget ini menginisialisasi subsistem penting seperti:
   - Sistem perutean dan navigasi (*Navigator*).
   - Tema global aplikasi (*ThemeData* dan *ColorScheme*) yang dapat diakses oleh komponen turunannya melalui `Theme.of(context)`.
   - Pengaturan lokalisasi, bahasa, dan arah pembacaan teks (*LTR/RTL*).
   - Penyedia akses `MediaQuery` untuk dimensi perangkat dan `ScaffoldMessenger` untuk manajemen pesan pop-up.  
   Widget ini umumnya digunakan sebagai *root widget* karena sebagian besar widget bawaan Flutter (seperti `Scaffold`, `AppBar`, `Card`, `InkWell`, dan dialog modal) mewajibkan keberadaan *InheritedWidget* Material di atas hierarki *tree*-nya. Tanpa adanya `MaterialApp` sebagai akar, pemanggilan widget-widget Material tersebut akan menimbulkan *runtime exception* karena ketiadaan konteks tema dan perutean yang valid.

4. **Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita sebaiknya memilih `StatelessWidget` dan kapan harus menggunakan `StatefulWidget`?**  
   - **Perbedaan**:
     - `StatelessWidget` bersifat statis dan *immutable* (tidak dapat diubah). Seluruh properti dan konfigurasinya bernilai final saat diinisialisasi dan tidak memiliki memori internal untuk mempertahankan perubahan status selama masa hidupnya. Re-render hanya terjadi jika widget induknya membangun ulang (*rebuild*) widget tersebut.
     - `StatefulWidget` bersifat dinamis dan memiliki objek `State` pendamping yang persisten (*mutable*). Objek `State` ini dapat menyimpan data dan status yang dapat dimutasi secara independen melalui pemanggilan `setState()`, yang memicu Flutter untuk merender ulang bagian UI yang terkait saja.
   - **Kriteria Pemilihan**:
     - Pilih `StatelessWidget` jika tampilan UI hanya mengonsumsi konfigurasi statis yang dioper dari luar dan tidak mengalami perubahan kondisi selama berinteraksi (misalnya teks statis, ikon, kartu info identitas, atau tombol navigasi sederhana).
     - Pilih `StatefulWidget` jika komponen antarmuka membutuhkan penyimpanan status dinamis yang berubah akibat interaksi pengguna atau proses asinkronus (misalnya form input teks, *switch/checkbox*, *counter*, animasi interaktif, atau konsumsi data dari API).

5. **Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode `build`?**  
   - **Definisi**: `BuildContext` adalah referensi atau penanda posisi unik dari suatu widget di dalam hierarki *widget tree*. Setiap widget memiliki instance `BuildContext` tersendiri yang dikaitkan saat widget diubah menjadi objek elemen (*Element*).
   - **Urgensi & Peran**: `BuildContext` sangat penting karena menjadi sarana komunikasi bagi sebuah widget untuk menelusuri pohon widget ke atas guna mengakses data dari widget leluhurnya (*ancestor widgets* / *InheritedWidget*). Contohnya adalah mengambil skema warna tema (`Theme.of(context)`), ukuran layar (`MediaQuery.of(context)`), hingga menampilkan pesan notifikasi (`ScaffoldMessenger.of(context)`).
   - **Penggunaan dalam `build(BuildContext context)`**: Flutter meneruskan parameter `context` ke dalam metode `build` sebagai pintu masuk bagi pengembang untuk merender UI yang responsif dan kontekstual terhadap lingkungan induknya, memastikan widget anak berada di posisi yang benar di dalam pohon hierarki.

6. **Jelaskan konsep *hot reload* di Flutter dan apa perbedaannya dengan *hot restart*! Kapan kita tidak bisa hanya mengandalkan *hot reload* dan harus melakukan *hot restart* atau *full restart*?**  
   - **Hot Reload**: Fitur pengembangan cepat Flutter yang menyuntikkan (*inject*) berkas kode sumber yang baru disimpan langsung ke dalam memori Dart Virtual Machine (VM) yang sedang aktif tanpa mematikan aplikasi. Flutter hanya mengeksekusi ulang metode `build()` pada *tree* yang terdampak, sehingga perubahan visual langsung terlihat seketika (sub-detik) dengan tetap mempertahankan status aplikasi saat itu (*preserves app state*).
   - **Perbedaan dengan Hot Restart**:
     - *Hot Reload* tidak mengatur ulang variabel atau status aplikasi (*state-preserving*).
     - *Hot Restart* menghancurkan seluruh memori status aplikasi, mengatur ulang seluruh variabel ke nilai awal, dan mengeksekusi kembali aplikasi dari fungsi `main()`.
   - **Kapan Harus Hot Restart atau Full Restart**:
     - **Harus Hot Restart**: Ketika mengubah inisialisasi variabel global/statis, memodifikasi konstruktor kelas, mengubah logika di dalam `initState()` pada `StatefulWidget`, atau merombak skema navigasi utama.
     - **Harus Full Restart / Rebuild**: Ketika menambahkan dependensi atau aset baru pada `pubspec.yaml`, memodifikasi berkas konfigurasi *native platform* (seperti `AndroidManifest.xml`, `build.gradle`, atau runner iOS), atau ketika terjadi perubahan pada kode C/C++ pada *engine*.

### AI Disclosure

Tools: Gemini

Strategi Prompting:
- **Arsitektur Pewarnaan Modular**: Meminta panduan implementasi pewarnaan kartu tombol aksi yang bersih melalui modifikasi model data `ItemHomepage` tanpa menggunakan percabangan `if-else` manual.
- **Restrukturisasi Layout & Solusi Overflow**: Meminta arahan dalam mengubah susunan `InfoCard` menjadi vertikal dengan lebar penuh (`double.infinity`), menambahkan 3 tombol aksi portofolio tambahan, serta menerapkan mitigasi galat *render overflow* menggunakan `SingleChildScrollView` dan isolasi `physics` pada `GridView`.
- **Penyusunan Refleksi Teori & Dokumentasi**: Mengarahkan formulasi jawaban reflektif konseptual Flutter secara komprehensif serta penataan berkas `README.md` yang konsisten dengan standar repositori proyek myportofolio.

Keterbatasan AI yang ditemukan:
- AI tidak dapat mengevaluasi antarmuka secara visual langsung pada emulator atau chrome, sehingga kenyamanan tata letak, kesesuaian kontras palet warna, serta kelancaran aplikasi sebaiknya diuji dan diverifikasi secara mandiri.
