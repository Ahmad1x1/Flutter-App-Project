import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Siswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
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
  final List<String> _siswa = ['Budi', 'Siti']; // Data awal

  Future<void> _tambahSiswa() async {
    final String? nama = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: const AddStudentSheet(),
      ),
    );

    if (!mounted) return;

    if (nama != null && nama.trim().isNotEmpty) {
      setState(() => _siswa.add(nama.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Siswa')),
      body: _siswa.isEmpty
          ? const Center(child: Text('Belum ada siswa'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _siswa.length,
              itemBuilder: (context, i) => Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(_siswa[i]),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahSiswa,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddStudentSheet extends StatefulWidget {
  const AddStudentSheet({super.key});

  @override
  State<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<AddStudentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();

  @override
  void dispose() {
    _namaC.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _namaC.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16, bottom: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _namaC,
              decoration: const InputDecoration(
                labelText: 'Nama Siswa',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) return 'Nama tidak boleh kosong';
                if (v.length < 3) return 'Minimal 3 karakter';
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
