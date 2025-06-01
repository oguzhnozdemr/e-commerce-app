class Urun {
  static const String baseUrl = "http://kasimadalan.pe.hu/urunler/resimler/";

  final int id;
  final String ad;
  final String resim;
  final String kategori;
  final int fiyat;
  final String marka;

  Urun({
    required this.id,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
  });

  String get resimUrl => "$baseUrl$resim";

  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: json['id'],
      ad: json['ad'],
      resim: json['resim'],
      kategori: json['kategori'],
      fiyat: json['fiyat'],
      marka: json['marka'],
    );
  }
}
