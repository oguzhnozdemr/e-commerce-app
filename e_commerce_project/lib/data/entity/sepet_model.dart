class SepetModel {
  final int? sepetId;
  final String ad;
  final String resim;
  final String kategori;
  final int fiyat;
  final String marka;
  final int siparisAdeti;
  final String kullaniciAdi;

  SepetModel({
    this.sepetId,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
    required this.siparisAdeti,
    required this.kullaniciAdi,
  });

  Map<String, dynamic> toJson() {
    return {
      'ad': ad,
      'resim': resim,
      'kategori': kategori,
      'fiyat': fiyat.toString(),
      'marka': marka,
      'siparisAdeti': siparisAdeti.toString(),
      'kullaniciAdi': kullaniciAdi,
    };
  }

  factory SepetModel.fromJson(Map<String, dynamic> json) {
    return SepetModel(
      sepetId: json['sepetId'] != null
          ? int.parse(json['sepetId'].toString())
          : null,
      ad: json['ad'] ?? '',
      resim: json['resim'] ?? '',
      kategori: json['kategori'] ?? '',
      fiyat: int.parse(json['fiyat'].toString()),
      marka: json['marka'] ?? '',
      siparisAdeti: int.parse(json['siparisAdeti'].toString()),
      kullaniciAdi: json['kullaniciAdi'] ?? '',
    );
  }
}
