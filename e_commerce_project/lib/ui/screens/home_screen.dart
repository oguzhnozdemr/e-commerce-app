import 'package:e_commerce_project/data/cubits/urunler_cubit.dart';
import 'package:e_commerce_project/data/entity/urun_model.dart';
import 'package:e_commerce_project/data/entity/sepet_model.dart';
import 'package:e_commerce_project/data/service/sepet_service.dart';
import 'package:e_commerce_project/ui/screens/basket_screen.dart';
import 'package:e_commerce_project/ui/screens/detail_screen.dart';
import 'package:e_commerce_project/ui/screens/favorites_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../companents/WaveClipper.dart';
import '../companents/product_card.dart';

import '../tools/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final SepetService _sepetService = SepetService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<UrunCubit>().urunleriYukle();
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const Center(child: Text("kullanici123"));
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 150,
            color: mainColor,
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Merhaba",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          top: 110,
          right: 20,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Teslimat adresi",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Evim",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Icon(Icons.home, size: 45),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 170.0, left: 16, right: 16),
          child: Container(
            height: 50,
            width: double.infinity,
            child: CupertinoSearchTextField(
              decoration: BoxDecoration(color: Colors.white),
              placeholder: "Ara",
              onChanged: (searchText) {
                context.read<UrunCubit>().urunAra(searchText);
              },
              onSubmitted: (searchText) {
                context.read<UrunCubit>().urunAra(searchText);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 230),
          child: BlocBuilder<UrunCubit, List<Urun>>(
            builder: (context, urunler) {
              if (urunler.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Ürün bulunamadı",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                padding: const EdgeInsets.all(10),
                itemCount: urunler.length,
                itemBuilder: (context, index) {
                  final urun = urunler[index];
                  return ProductCard(
                    title: urun.ad,
                    imageUrl:
                        "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                    price: urun.fiyat.toDouble(),
                    urun: urun,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(data: urun.id),
                        ),
                      );
                    },
                    onAddToCart: () async {
                      final sepet = SepetModel(
                        ad: urun.ad,
                        resim: urun.resim,
                        kategori: urun.kategori,
                        fiyat: urun.fiyat,
                        marka: urun.marka,
                        siparisAdeti: 1,
                        kullaniciAdi: "kullanici123",
                      );

                      final success = await _sepetService.sepeteEkle(sepet);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${urun.ad} sepete eklendi"),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Ürün sepete eklenirken bir hata oluştu"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BasketScreen()),
              );
            },
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            child: Icon(Icons.shopping_cart, size: 28),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          SizedBox(height: 3),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(icon: CupertinoIcons.home, label: "Ana Sayfa", index: 0),
              _navItem(
                  icon: CupertinoIcons.heart, label: "Favoriler", index: 1),
              _navItem(icon: CupertinoIcons.person, label: "Profil", index: 2),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: isSelected ? Colors.indigo : Colors.grey),
          SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
