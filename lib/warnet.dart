import 'pelanggan.dart';
class Warnet {
  String kodeTransaksi;
  Pelanggan pelanggan;
  String jenisPelanggan;
  DateTime jamMasuk;
  DateTime jamKeluar;
  double tarif;

  Warnet({
    required this.kodeTransaksi,
    required this.pelanggan,
    required this.jenisPelanggan,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.tarif,
  });

  Duration get lama => jamKeluar.difference(jamMasuk);

  double get totalBayar {
    double diskon = 0;
    double lamaJam = lama.inHours.toDouble();

    if (jenisPelanggan == 'VIP' && lamaJam > 2) {
      diskon = tarif * 0.02; // Diskon 2% untuk VIP
    } else if (jenisPelanggan == 'GOLD' && lamaJam > 2) {
      diskon = tarif * 0.05; // Diskon 5% untuk GOLD
    }

    return (lamaJam * tarif) - diskon;
  }
}
