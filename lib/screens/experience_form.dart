import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _category = "internship";
  String _thumbnail = "";
  String _description = "";
  DateTime? _endDate;
  final TextEditingController _endDateController = TextEditingController();
  bool _isOngoing = false;
  bool _isSubmitting = false;

  final List<Map<String, String>> _categories = const [
    {'value': 'internship', 'label': 'Internship (Magang)'},
    {'value': 'research', 'label': 'Research (Riset)'},
    {'value': 'volunteer', 'label': 'Volunteer (Relawan)'},
    {'value': 'part-time', 'label': 'Part-Time (Paruh Waktu)'},
    {'value': 'full-time', 'label': 'Full-Time (Purna Waktu)'},
    {'value': 'freelance', 'label': 'Freelance'},
  ];

  @override
  void dispose() {
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthState>();
    if (!auth.isLoggedIn) {
      final loggedIn = await ensureLoggedIn(context);
      if (!loggedIn || !mounted) return;
    }

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final newExperience = Experience(
      title: _title.trim(),
      description: _description.trim(),
      category: _category,
      thumbnail: _thumbnail.trim(),
      endedAt: _isOngoing ? null : _endDate,
    );

    try {
      final created = await context.read<ApiClient>().createExperience(
        newExperience,
        token: token,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pengalaman Berhasil Ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Judul: ${created.title}'),
                  Text(
                    'Kategori: ${created.categoryDisplay ?? created.category}',
                  ),
                  Text('Status: ${created.isOngoing ? "Ongoing" : "Finished"}'),
                  if (created.thumbnail.isNotEmpty)
                    Text('Thumbnail: ${created.thumbnail}'),
                  Text('Deskripsi: ${created.description}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  _formKey.currentState!.reset();
                  setState(() {
                    _title = "";
                    _category = "internship";
                    _thumbnail = "";
                    _description = "";
                    _endDate = null;
                    _endDateController.clear();
                    _isOngoing = false;
                  });
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi telah berakhir. Silakan login kembali.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan pengalaman: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Judul Pengalaman
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Software Engineer Intern",
                    labelText: "Judul Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value ?? "";
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

              // 2. Kategori Pengalaman
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['value'],
                      child: Text(cat['label']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // 3. Thumbnail URL (Opsional)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "https://example.com/image.png",
                    labelText: "Thumbnail URL (Opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value ?? "";
                    });
                  },
                ),
              ),

              // 4. Masih Berlangsung Switch
              SwitchListTile(
                title: const Text("Pengalaman Masih Berlangsung?"),
                value: _isOngoing,
                activeThumbColor: Colors.indigo,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool value) {
                  setState(() {
                    _isOngoing = value;
                    if (value) {
                      _endDate = null;
                      _endDateController.clear();
                    }
                  });
                },
              ),

              // 5. Tanggal Berakhir (jika tidak ongoing)
              if (!_isOngoing)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Pilih tanggal berakhir",
                      labelText: "Tanggal Berakhir",
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onTap: () => _selectEndDate(context),
                  ),
                ),

              // 6. Deskripsi Pengalaman
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Ceritakan tanggung jawab atau pencapaian Anda",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 4,
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // 7. Tombol Simpan
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Simpan Pengalaman",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
