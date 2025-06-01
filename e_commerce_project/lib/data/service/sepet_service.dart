import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/sepet_model.dart';

class SepetService {
  static const String baseUrl = "http://kasimadalan.pe.hu/urunler";

  Future<bool> sepeteEkle(SepetModel sepet) async {
    try {
      final requestBody = {
        'ad': sepet.ad,
        'resim': sepet.resim,
        'kategori': sepet.kategori,
        'fiyat': sepet.fiyat.toString(),
        'marka': sepet.marka,
        'siparisAdeti': sepet.siparisAdeti.toString(),
        'kullaniciAdi': sepet.kullaniciAdi,
      };

      final response = await http.post(
        Uri.parse("$baseUrl/sepeteUrunEkle.php"),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] == 1 || responseData['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<SepetModel>> sepettekiUrunleriGetir(String kullaniciAdi) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/sepettekiUrunleriGetir.php"),
        body: {'kullaniciAdi': kullaniciAdi},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == 1) {
          final List<dynamic> urunler = responseData['urunler_sepeti'];
          return urunler.map((urun) => SepetModel.fromJson(urun)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> sepettenUrunSil(int sepetId, String kullaniciAdi) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/sepettenUrunSil.php"),
        body: {
          'sepetId': sepetId.toString(),
          'kullaniciAdi': kullaniciAdi,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] == 1 || responseData['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sepetUrunGuncelle(SepetModel sepet) async {
    try {

      final silmeBasarili =
          await sepettenUrunSil(sepet.sepetId!, sepet.kullaniciAdi);
      if (!silmeBasarili) return false;

      return await sepeteEkle(sepet);
    } catch (e) {
      return false;
    }
  }
}
