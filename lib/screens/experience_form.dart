import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _company = "";
  String _experienceType = "Pekerjaan";
  String _description = "";
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _isOngoing = false;

  final List<String> _typeList = [
    'Pekerjaan',
    'Magang',
    'Organisasi',
    'Kepanitiaan',
    'Proyek Bebas',
  ];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience Form'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TextFormField Posisi / Role
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Judul Pengalaman",
                    labelText: "Judul Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Judul pengalaman tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // 2. TextFormField Instansi / Perusahaan
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Instansi/Perusahaan",
                    labelText: "Nama Instansi/Perusahaan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _company = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama instansi/perusahaan tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // 3. DropdownButtonFormField Tipe Pengalaman
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Tipe Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _experienceType,
                  items: _typeList
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _experienceType = newValue!;
                    });
                  },
                ),
              ),

              // 4. TextFormField Deskripsi Pengalaman (maxLines: 4)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Pengalaman",
                    labelText: "Deskripsi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi pengalaman tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Mulai (showDatePicker) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Pilih tanggal mulai",
                    labelText: "Tanggal Mulai",
                    suffixIcon: const Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _selectStartDate(context),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tanggal mulai tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Checkbox Masih Berlangsung ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CheckboxListTile(
                  title: const Text("Masih berlangsung sampai saat ini"),
                  value: _isOngoing,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (bool? value) {
                    setState(() {
                      _isOngoing = value ?? false;
                      if (_isOngoing) {
                        _endDate = null;
                        _endDateController.text = "Sekarang";
                      } else {
                        _endDateController.clear();
                      }
                    });
                  },
                ),
              ),

              // === Tanggal Selesai (showDatePicker, hanya aktif jika tidak berlangsung) ===
              if (!_isOngoing)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Pilih tanggal selesai",
                      labelText: "Tanggal Selesai",
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onTap: () => _selectEndDate(context),
                    validator: (String? value) {
                      if (!_isOngoing &&
                          (value == null || value.trim().isEmpty)) {
                        return "Tanggal selesai tidak boleh kosong jika sudah berakhir!";
                      }
                      if (_startDate != null &&
                          _endDate != null &&
                          _endDate!.isBefore(_startDate!)) {
                        return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                      }
                      return null;
                    },
                  ),
                ),

              // 5. Tombol ElevatedButton (Simpan) -> showDialog AlertDialog jika valid
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Experience berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Judul Pengalaman: $_title'),
                                    Text('Nama Instansi/Perusahaan: $_company'),
                                    Text(
                                      'Kategori Pengalaman: $_experienceType',
                                    ),
                                    Text('Deskripsi: $_description'),
                                    Text(
                                      'Periode: ${_startDateController.text} s.d. ${_isOngoing ? "Sekarang (Masih Berlangsung)" : _endDateController.text}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    _startDateController.clear();
                                    _endDateController.clear();
                                    setState(() {
                                      _startDate = null;
                                      _endDate = null;
                                      _isOngoing = false;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
