import 'package:e_commerce_project/data/cubits/detail_cubit.dart';
import 'package:e_commerce_project/data/cubits/urunler_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/urun_model.dart';
import '../../data/entity/sepet_model.dart';
import '../../data/service/sepet_service.dart';
import '../../data/cubits/favorites_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final int data; // urun id
  const DetailScreen({super.key, required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int adet = 1;
  // URL'nin geçerli olup olmadığını kontrol eden fonksiyon
  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  // Resim URL'ini doğru field'dan almak için
  String? getImageUrl(Urun urun) {
    // Önce resimUrl'i kontrol et, yoksa resim field'ını kullan
    if (urun.resimUrl != null && urun.resimUrl!.isNotEmpty) {
      return urun.resimUrl;
    } else if (urun.resim != null && urun.resim!.isNotEmpty) {
      return urun.resim;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final urunler = context.read<UrunCubit>().state;
    context.read<DetailCubit>().urunGetir(urunler, widget.data);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<DetailCubit, Urun?>(
          builder: (context, urun) => Text(
            urun != null && urun.ad.isNotEmpty ? urun.ad : "Ürün Detayı",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          BlocBuilder<FavoritesCubit, List<Urun>>(
            builder: (context, favorites) {
              final urun = context.read<DetailCubit>().state;
              if (urun == null) return const SizedBox.shrink();

              return FutureBuilder<bool>(
                future: context.read<FavoritesCubit>().isFavorite(urun),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;

                  return IconButton(
                    onPressed: () {
                      context.read<FavoritesCubit>().toggleFavorite(urun);
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DetailCubit, Urun?>(builder: (context, urun) {
        if (urun == null || urun.id == 0) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Ürün Bulunamadı",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final imageUrl = getImageUrl(urun);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Yıldızlar
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 30),
                    Icon(Icons.star, color: Colors.amber, size: 30),
                    Icon(Icons.star, color: Colors.amber, size: 30),
                    Icon(Icons.star, color: Colors.amber, size: 30),
                    Icon(Icons.star, color: Colors.grey, size: 30),
                  ],
                ),
              ),

              // Ürün Resmi
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isValidImageUrl(imageUrl)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("Resim yükleme hatası: $error");
                            print("URL: $imageUrl");
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Resim yüklenemedi",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Resim mevcut değil",
                              style: TextStyle(color: Colors.grey),
                            ),
                            if (imageUrl != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "URL: $imageUrl",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
              ),

              // Ürün Bilgileri
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${urun.fiyat ?? 0} ₺",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      urun.ad ?? "Ürün Adı",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (adet > 1) {
                              setState(() {
                                adet--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$adet',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                adet++;
                              });
                            },
                            icon: Icon(Icons.add))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BlocBuilder<DetailCubit, Urun?>(
        builder: (context, urun) {
          if (urun == null || urun.id == 0) {
            return const SizedBox.shrink();
          }

          final toplamFiyat = (urun.fiyat ?? 0) * adet;

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Toplam Fiyat",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          '$toplamFiyat ₺',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        if (adet > 1)
                          Text(
                            "${urun.fiyat} ₺ x $adet adet",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        final sepetService = SepetService();
                        final sepet = SepetModel(
                          ad: urun.ad,
                          resim: urun.resim,
                          kategori: urun.kategori,
                          fiyat: urun.fiyat,
                          marka: urun.marka,
                          siparisAdeti: adet,
                          kullaniciAdi: "kullanici123",
                        );

                        final success = await sepetService.sepeteEkle(sepet);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${urun.ad} sepete eklendi\nAdet: $adet - Toplam: $toplamFiyat ₺"),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Ürün sepete eklenirken bir hata oluştu"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 20),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Sepete Ekle",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
