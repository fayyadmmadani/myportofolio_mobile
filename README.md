# My Portofolio Mobile

[![CI](https://github.com/fayyadmmadani/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/fayyadmmadani/myportofolio_mobile/actions/workflows/main.yaml)

### Nama: Fayyad Mohammad Madani

### NPM: 2506622720

### Kelas: PBP A

---

## Tautan Repositori & Backend
- **Repositori Backend (Django REST Framework)**: [myportofolio](https://github.com/fayyadmmadani/myportofolio)
- **URL Backend Deployment (PWS)**: [Deployment PWS](https://fayyad-mohammad-myportofolio.pws.cs.ui.ac.id/)

---

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

3. Generate kode serialisasi model JSON:
> **Catatan Penting**: Karena berkas `*.g.dart` diabaikan oleh `.gitignore`, Anda wajib menjalankan perintah berikut sebelum kompilasi atau menjalankan aplikasi:

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Jalankan aplikasi dengan menentukan base URL backend via `--dart-define`:

- **Menghubungkan ke Backend Lokal (Peramban Chrome / Desktop)**:
```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

- **Menghubungkan ke Backend Lokal (Android Emulator)**:
```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

- **Menghubungkan ke Backend Production (PWS)**:
```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://fayyad-mohammad-myportofolio.pws.cs.ui.ac.id/
```

### Menjalankan Analisis Kode

```bash
flutter analyze
```

### Menjalankan Pengujian Otomatis (Unit & Widget Test)

```bash
flutter test
```

---

### Tugas 9

1. **Mengapa kita menggunakan `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` alih-alih mengirim objek `Map<String, dynamic>` mentah langsung dari widget? Jelaskan satu bug yang dicegah atau dapat dicegah oleh pendekatan ini pada model bagianmu.**

   - **Keuntungan Tipe Data Kuat (*Strong Typing*) & *Maintainability*:**
     Mengirim `Map<String, dynamic>` mentah secara langsung dari widget membuat kode rawan *typo* pada *key* string (misalnya salah menulis `'category'` menjadi `'categry'`) dan tidak memiliki perlindungan pemeriksaan tipe saat *compile-time*. Dengan mendefinisikan kelas model `Experience` yang beranotasi `@JsonSerializable`, seluruh pemetaan atribut dikontrol secara deklaratif dan otomatis menghasilkan kode deserialisasi/serialisasi yang konsisten dan bebas *human error*.
   - **Otomasi Konvensi Penamaan (`FieldRename.snake`):**
     Dart mengadopsi standar `camelCase` (seperti `categoryDisplay`, `startedAt`, `isOngoing`), sedangkan Django REST Framework secara idomatis menggunakan `snake_case` (seperti `category_display`, `started_at`, `is_ongoing`). Anotasi `fieldRename: FieldRename.snake` secara otomatis mengonversi konvensi penamaan kedua platform tanpa memerlukan penulisan *key mapping* manual yang berulang.
   - **Perlindungan Integritas Payload Server (`@JsonKey(includeToJson: false)`):**
     Anotasi `@JsonKey(includeToJson: false)` mencegah *field* yang semata-mata dihasilkan oleh server—seperti `id` (UUID *primary key*), `started_at` (`auto_now_add=True`), `category_display` (*read-only serializer method*), dan `is_ongoing` (*computed property*)—ikut terkirim dalam *payload* `POST` atau `PUT`.
   - **Bug Spesifik yang Dicegah pada Model `Experience`:**
     Pada backend Django, `ExperienceSerializer` menetapkan `read_only_fields = ["id", "started_at", "is_ongoing", "category_display"]`. Jika widget mengirimkan `Map` mentah yang menyertakan `'id': null` atau `'started_at': null`, DRF dapat menolak *payload* dengan galat `400 Bad Request` ("This field is read-only" atau format tanggal tidak valid). Selain itu, mengirim `is_ongoing` sebagai boolean mentah dapat menimbulkan inkonsistensi terhadap model Django yang menghitung status tersebut berdasarkan apakah `ended_at` bernilai `null` atau tidak. Pendekatan `@JsonKey(includeToJson: false)` menjamin *payload* JSON yang dikirim ke endpoint DRF hanya memuat field masukan pengguna yang valid (`title`, `description`, `category`, `thumbnail`, `ended_at`).

2. **Mengapa `Future` yang diteruskan ke `FutureBuilder` harus diinisialisasi di dalam `initState()` alih-alih langsung di dalam `build()`, dan mengapa `ApiClient` sebaiknya melempar `ApiException` daripada mengembalikan `null` pada respons HTTP non-2xx?**

   - **Inisialisasi `Future` di `initState()` vs `build()`:**
     Metode `build()` pada Flutter dapat dipanggil berulang kali secara dinamis—misalnya saat orientasi layar berubah, animasi berjalan, *soft keyboard* muncul/sembunyi, atau ketika ada *state* induk yang memicu pembaruan *widget tree*. Jika pemanggilan `apiClient.getExperiences()` diletakkan langsung di dalam `build()`, maka setiap kali widget me-*rebuild*, `Future` baru akan tercipta dan memicu permintaan HTTP baru ke backend secara terus-menerus (*infinite network request cycle*). Akibatnya, UI akan berkedip (*flicker* kembali ke kondisi loading), performa aplikasi menurun drastis, dan server terbebani *request* berlebih. Dengan menginisialisasi `Future` satu kali di `initState()`, permintaan jaringan hanya dieksekusi saat layar pertama kali dipasang, dan *refresh* hanya terjadi secara terkontrol saat pengguna sengaja memicunya (misalnya melalui `RefreshIndicator`).
   - **Melempar `ApiException` daripada Mengembalikan `null`:**
     Mengembalikan `null` ketika respons HTTP non-2xx menyebabkan ambiguitas fatal: pemanggil tidak dapat membedakan apakah `null` berarti daftar memang kosong, ataukah terjadi kegagalan jaringan, otentikasi kedaluwarsa (`401 Unauthorized`), hak akses ditolak (`403 Forbidden`), entri tidak ditemukan (`404 Not Found`), atau galat internal server (`500 Internal Server Error`). Dengan melempar `ApiException(statusCode, body)`, aplikasi dapat:
     1. Menangkap status kode secara presisi dan mengambil tindakan terarah (misalnya menghapus token dan memicu alur login kembali jika menerima status `401`).
     2. Menampilkan pesan galat deskriptif ke pengguna via `SnackBar`.
     3. Memungkinkan `FutureBuilder` mendeteksi kondisi `snapshot.hasError` dan menyajikan widget penanganan galat beserta tombol aksi `Retry`.

3. **Bandingkan `SessionAuthentication` milik Django (dari Tutorial 04/07) dengan `TokenAuthentication` milik DRF (dari Tutorial 10). Mengapa `myportofolio_mobile` menggunakan `TokenAuthentication` sementara `SessionAuthentication` tetap diaktifkan pada backend Django?**

   - **Perbandingan Konseptual:**
     - **`SessionAuthentication` (Stateful / Cookie-based):**
       Bergantung pada *cookie* sesi (`sessionid`) yang disimpan di peramban web dan dicocokkan dengan tabel sesi di basis data Django. Mekanisme ini memerlukan perlindungan anti-pemalsuan *request* lintas situs (*Cross-Site Request Forgery* / CSRF Token).
     - **`TokenAuthentication` (Stateless / Bearer-like Token):**
       Setiap pengguna memiliki token acak persisten berformat *string* heksadesimal. Klien menyertakan token ini secara eksplisit pada setiap permintaan HTTP di *header* `Authorization: Token <key>`. Karena tidak menggunakan *cookie*, mekanisme ini kebal terhadap serangan CSRF konvensional dan sangat cocok untuk interaksi RESTful API.
   - **Alasan `myportofolio_mobile` Menggunakan `TokenAuthentication`:**
     Aplikasi *mobile* Flutter bukan peramban web; sistem *mobile* tidak mengelola *cookie store* atau *cookie lifecycle* secara otomatis layaknya peramban, dan penanganan CSRF *cookie/header handshake* pada platform seluler sangat tidak praktis dan rawan galat. Token berbasis *header* `Authorization` sangat ringan, mudah disimpan di memori aplikasi (`AuthState`), dan dapat dikirimkan secara konsisten ke backend tanpa tergantung pada sesi peramban.
   - **Alasan `SessionAuthentication` Tetap Diaktifkan pada Backend:**
     Backend Django melayani dua jenis antarmuka sekaligus: antarmuka web HTML (halaman administrasi Django `/admin/` dan *browsable API* Django REST Framework `/api-auth/`) serta antarmuka REST API seluler. `SessionAuthentication` wajib tetap aktif agar administrator dan pengembang dapat login secara interaktif melalui peramban web pada Django Admin dan menguji API secara langsung di peramban tanpa perlu menyuntikkan token manual.

4. **Jelaskan peran job `build` (`very_good_workflows`) dan `build_apk` dalam pipeline `.github/workflows/main.yaml` milikmu (termasuk pemeriksaan apa saja yang dijalankan `very_good_workflows` di balik layar). Mengapa berkas `*.g.dart` dimasukkan ke `.gitignore` meskipun CI membutuhkannya untuk menganalisis dan membangun aplikasi?**

   - **Peran Job `build` (`very_good_workflows`):**
     Job `build` bertindak sebagai gerbang kendali mutu (*quality gate*) utama yang terstandardisasi untuk kode Dart/Flutter. Di balik layar, *reusable workflow* `very_good_workflows` mengeksekusi tahapan pemeriksaan ketat secara otomatis:
     1. Menyiapkan lingkungan Flutter sesuai konfigurasi *channel* stabil.
     2. Menjalankan *setup script*: `dart run build_runner build --delete-conflicting-outputs` untuk men-generate berkas serialisasi.
     3. Memeriksa format kode (`dart format --output=none --set-exit-if-changed .`) untuk menjamin kepatuhan gaya penulisan kode resmi.
     4. Menjalankan analisis statis (`flutter analyze --fatal-infos --fatal-warnings`) untuk mendeteksi potensi *bug*, *deprecated API*, dan pelanggaran *linter*.
     5. Menjalankan seluruh pengujian otomatis (`flutter test --coverage`) untuk memverifikasi fungsionalitas dan menghasilkan laporan cakupan (*test coverage*), mengecualikan `**/*.g.dart` dari perhitungan cakupan.
   - **Peran Job `build_apk`:**
     Job `build_apk` dijalankan setelah job `build` lulus (`needs: build`). Job ini bertugas mengompilasi kode sumber menjadi berkas biner mandiri Android Release APK (`flutter build apk --release`) dan mengunggah artefak hasil *build* (`app-release-apk`) menggunakan `actions/upload-artifact@v4` agar dapat diunduh langsung untuk pengujian distribusi.
   - **Mengapa `*.g.dart` Dimasukkan ke `.gitignore`:**
     Berkas `*.g.dart` adalah berkas hasil turunan (*generated code*) yang dibuat secara deterministik oleh perkakas `build_runner` dari berkas model sumbernya. Memasukkan berkas hasil generasi ke dalam *version control* dianggap sebagai *anti-pattern* karena:
     1. Menyebabkan *git diff* membengkak dengan ribuan baris kode otomatis yang menyulitkan proses *code review*.
     2. Menimbulkan konflik penggabungan (*merge conflicts*) yang sering dan sulit diselesaikan ketika beberapa *branch* diubah secara simultan.
     3. Berpotensi menimbulkan inkonsistensi jika ada pengembang yang lupa memperbarui berkas `.g.dart` setelah memodifikasi model.
     
     Meskipun diabaikan oleh Git, pipeline CI tetap dapat menganalisis dan membangun aplikasi dengan sempurna karena workflow telah dikonfigurasi dengan langkah `setup: dart run build_runner build --delete-conflicting-outputs` (pada job `build`) dan `- run: dart run build_runner build --delete-conflicting-outputs` (pada job `build_apk`), sehingga berkas `.g.dart` selalu dihasilkan ulang secara segar dan terverifikasi di dalam lingkungan *runner* CI.

---

### AI Disclosure

**Tools yang Digunakan**: Gemini

**Strategi Prompting**:
- **Sinkronisasi Schema Data Backend & Mobile**: Bagaimana menentukan model `Experience` di Flutter yang selaras dengan `ExperienceSerializer` di Django (`snake_case` mapping, nullable handling pada `ended_at`, serta pemisahan field read-only server menggunakan `@JsonKey(includeToJson: false)`).
- **Pengembangan Pengujian Otomatis Bermakna (Rubrik Nilai 4)**: Bagaimana mengembangkan *unit test suite* komprehensif menggunakan `MockClient` untuk menguji skenario positif (GET list, POST auth) dan skenario negatif (penanganan `ApiException` pada status 401).

**Keterbatasan AI & Perbaikan Manual**:
- **Penanganan Sintaks Deprecated & Analyzer Issue**: AI awalnya menggunakan atribut `Colors.black85` yang tidak didefinisikan di Flutter SDK versi stabil terbaru (digantikan manual menjadi `Colors.black87`), serta parameter lama `value` pada `DropdownButtonFormField` (diperbaiki manual menjadi `initialValue`) dan `activeColor` pada `SwitchListTile` (diperbaiki manual menjadi `activeThumbColor`) agar `flutter analyze` bersih dari issues.
- **Konfigurasi Host Header Pengujian**: Verifikasi endpoint backend sempat mengalami penolakan `DisallowedHost` dari Django untuk host `testserver`, yang diselesaikan dengan pengujian request langsung menggunakan host valid (`localhost`).
