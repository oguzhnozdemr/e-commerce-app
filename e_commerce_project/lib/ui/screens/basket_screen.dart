import 'package:flutter/material.dart';
import '../../data/entity/sepet_model.dart';
import '../../data/service/sepet_service.dart';
import '../screens/detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final SepetService _sepetService = SepetService();
  List<SepetModel> sepetUrunleri = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _sepetUrunleriniGetir();
  }

  Future<void> _sepetUrunleriniGetir() async {
    setState(() {
      isLoading = true;
    });

    final urunler = await _sepetService.sepettekiUrunleriGetir("kullanici123");

    setState(() {
      sepetUrunleri = urunler;
      isLoading = false;
    });
  }

  Future<void> _adetGuncelle(SepetModel urun, int yeniAdet) async {
    // Eğer mevcut adet 1 ise ve yeni adet 0 olacaksa, ürünü sepetten sil
    if (urun.siparisAdeti == 1 && yeniAdet == 0) {
      final success = await _sepetService.sepettenUrunSil(
        urun.sepetId!,
        urun.kullaniciAdi,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${urun.ad} sepetten silindi"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        await _sepetUrunleriniGetir();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ürün silinirken bir hata oluştu"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Normal güncelleme işlemi
    if (yeniAdet < 1) return;

    print("Ürün güncelleniyor - Sepet ID: ${urun.sepetId}");
    print("Mevcut adet: ${urun.siparisAdeti}, Yeni adet: $yeniAdet");

    final guncelUrun = SepetModel(
      sepetId: urun.sepetId,
      ad: urun.ad,
      resim: urun.resim,
      kategori: urun.kategori,
      fiyat: urun.fiyat,
      marka: urun.marka,
      siparisAdeti: yeniAdet,
      kullaniciAdi: urun.kullaniciAdi,
    );

    try {
      final success = await _sepetService.sepetUrunGuncelle(guncelUrun);

      if (success) {
        print("Ürün başarıyla güncellendi");
        await _sepetUrunleriniGetir();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${urun.ad} adedi güncellendi"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        print("Ürün güncellenemedi");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ürün adedi güncellenirken bir hata oluştu"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Güncelleme sırasında hata: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bir hata oluştu: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  int _toplamFiyatHesapla() {
    return sepetUrunleri.fold(
        0, (toplam, urun) => toplam + (urun.fiyat * urun.siparisAdeti));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sepetim",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sepetUrunleri.isEmpty
              ? const Center(child: Text("Sepetiniz boş"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: sepetUrunleri.length,
                        itemBuilder: (context, index) {
                          final urun = sepetUrunleri[index];
                          final toplamFiyat = urun.fiyat * urun.siparisAdeti;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      data: urun.sepetId!,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Ürün Resmi
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Icon(
                                                Icons.image_not_supported),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Ürün Bilgileri
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            urun.ad,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${urun.fiyat} ₺",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  _adetGuncelle(urun,
                                                      urun.siparisAdeti - 1);
                                                },
                                              ),
                                              Text(
                                                "${urun.siparisAdeti}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  _adetGuncelle(urun,
                                                      urun.siparisAdeti + 1);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Sağ Taraf
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.red),
                                          onPressed: () async {
                                            final success = await _sepetService
                                                .sepettenUrunSil(
                                              urun.sepetId!,
                                              urun.kullaniciAdi,
                                            );

                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "${urun.ad} sepetten silindi"),
                                                  backgroundColor: Colors.green,
                                                  duration: const Duration(
                                                      seconds: 2),
                                                ),
                                              );
                                              _sepetUrunleriniGetir();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Ürün silinirken bir hata oluştu"),
                                                  backgroundColor: Colors.red,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          "$toplamFiyat ₺",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Alt Bilgi Kartı
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Gönderim Ücreti"),
                              Text("0 ₺"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Toplam",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${_toplamFiyatHesapla()} ₺",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Sepeti onaylama işlemi
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Sepeti Onayla",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
