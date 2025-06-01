import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/urun_model.dart';

class UrunlerRepository {
  static const String baseUrl = "http://kasimadalan.pe.hu/urunler";

  Future<List<Urun>> urunleriYukle() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/tumUrunleriGetir.php"));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == 1) {
          final List<dynamic> urunler = responseData['urunler'];
          return urunler.map((urun) => Urun.fromJson(urun)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
