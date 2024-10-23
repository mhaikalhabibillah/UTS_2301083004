import 'package:flutter/material.dart';
import 'pelanggan.dart';
import 'warnet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaksi Warnet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransaksiWarnetPage(),
    );
  }
}

class TransaksiWarnetPage extends StatefulWidget {
  @override
  _TransaksiWarnetPageState createState() => _TransaksiWarnetPageState();
}

class _TransaksiWarnetPageState extends State<TransaksiWarnetPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  String _jenisPelanggan = 'REGULAR'; // Jenis pelanggan default
  TimeOfDay? _jamMasuk;
  TimeOfDay? _jamKeluar;

  double _tarifPerJam = 5000;

  void _selectJamMasuk(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _jamMasuk = picked);
  }

  void _selectJamKeluar(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _jamKeluar = picked);
  }

  void _prosesTransaksi() {
    if (_formKey.currentState!.validate() &&
        _jamMasuk != null &&
        _jamKeluar != null) {
      Pelanggan pelanggan = Pelanggan(
        kode: _kodeController.text,
        nama: _namaController.text,
      );

      DateTime now = DateTime.now();
      DateTime jamMasuk = DateTime(now.year, now.month, now.day, _jamMasuk!.hour, _jamMasuk!.minute);
      DateTime jamKeluar = DateTime(now.year, now.month, now.day, _jamKeluar!.hour, _jamKeluar!.minute);

      Warnet transaksi = Warnet(
        kodeTransaksi: 'TRX001',
        pelanggan: pelanggan,
        jenisPelanggan: _jenisPelanggan,
        jamMasuk: jamMasuk,
        jamKeluar: jamKeluar,
        tarif: _tarifPerJam,
      );

      double total = transaksi.totalBayar;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hasil Transaksi'),
          content: Text('Total Bayar: Rp. ${total.toStringAsFixed(0)}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi Warnet'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Transaksi'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
              },
            ),
            ListTile(
              title: Text('Informasi Lainnya'),
              onTap: () {
                // Tambahkan navigasi ke halaman lain jika diperlukan
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _kodeController,
                decoration: InputDecoration(labelText: 'Kode Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode Pelanggan harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pelanggan harus diisi';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenisPelanggan,
                decoration: InputDecoration(labelText: 'Jenis Pelanggan'),
                onChanged: (String? newValue) {
                  setState(() {
                    _jenisPelanggan = newValue!;
                  });
                },
                items: ['REGULAR', 'VIP', 'GOLD']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ListTile(
                title: Text(_jamMasuk == null
                    ? 'Pilih Jam Masuk'
                    : 'Jam Masuk: ${_jamMasuk!.format(context)}'),
                onTap: () => _selectJamMasuk(context),
              ),
              ListTile(
                title: Text(_jamKeluar == null
                    ? 'Pilih Jam Keluar'
                    : 'Jam Keluar: ${_jamKeluar!.format(context)}'),
                onTap: () => _selectJamKeluar(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _prosesTransaksi,
                child: Text('Proses Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

