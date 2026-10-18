import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap field input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();

  // Field status kehadiran
  String? _statusKehadiran;
  final List<String> _pilihanKehadiran = ['Hadir', 'Izin', 'Sakit'];

  // Status loading saat data sedang dikirim
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _lokasiController.dispose();
    _mataKuliahController.dispose();
    super.dispose();
  }

  // 2 & 4. Fungsi untuk mengirim data dinamis ke collection 'praktikum' di Firestore
  Future<void> simpanData() async {
    await FirebaseFirestore.instance.collection('praktikum').add({
      'nama': _namaController.text.trim(),
      'nim': _nimController.text.trim(),
      'lokasi': _lokasiController.text.trim(),
      'mata_kuliah': _mataKuliahController.text.trim(),
      'status': _statusKehadiran,
      'waktu': FieldValue.serverTimestamp(),
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw 'Koneksi ke Firebase timeout (10 detik). Pastikan konfigurasi Firebase di firebase_options.dart sudah sesuai dengan project kamu.';
      },
    );
  }

  // Handler proses submit form
  Future<void> _handleSubmit() async {
    // 5. Validasi agar data tidak dapat dikirim jika field wajib masih kosong
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await simpanData();

      if (!mounted) return;

      // 6. Tampilkan notifikasi keberhasilan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 6. Kosongkan kembali seluruh field input
      _formKey.currentState?.reset();
      _namaController.clear();
      _nimController.clear();
      _lokasiController.clear();
      _mataKuliahController.clear();
      setState(() {
        _statusKehadiran = null;
      });
    } catch (e) {
      if (!mounted) return;

      // 7. Jika proses penyimpanan gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim data: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Firebase'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Form Input Presensi Praktikum',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan lengkapi seluruh data di bawah ini',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(height: 32),

                    // 1. TextFormField Nama
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Mahasiswa *',
                        hintText: 'Masukan Nama Anda',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 1. TextFormField NIM
                    TextFormField(
                      controller: _nimController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'NIM *',
                        hintText: 'Masukkan NIM Anda',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'NIM wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 1. TextFormField Lokasi
                    TextFormField(
                      controller: _lokasiController,
                      decoration: InputDecoration(
                        labelText: 'Lokasi *',
                        hintText: 'Contoh: Universitas Esa Unggul',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lokasi wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 1. TextFormField Mata Kuliah
                    TextFormField(
                      controller: _mataKuliahController,
                      decoration: InputDecoration(
                        labelText: 'Mata Kuliah *',
                        hintText: 'Contoh: Pemrograman Flutter',
                        prefixIcon: const Icon(Icons.menu_book_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mata Kuliah wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3. Field Keterangan Kehadiran (Hadir, Izin, Sakit)
                    DropdownButtonFormField<String>(
                      initialValue: _statusKehadiran,
                      decoration: InputDecoration(
                        labelText: 'Keterangan Kehadiran *',
                        prefixIcon: const Icon(Icons.event_available_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      hint: const Text('Pilih Keterangan Kehadiran'),
                      items: _pilihanKehadiran.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _statusKehadiran = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keterangan kehadiran wajib dipilih';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Tombol Simpan ke Firebase
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_outlined),
                        label: Text(
                          _isLoading ? 'Menyimpan...' : 'Simpan ke Firebase',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}