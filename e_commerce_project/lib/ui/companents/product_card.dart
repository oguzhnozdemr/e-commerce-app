import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/entity/urun_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/cubits/favorites_cubit.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final double price;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final Urun? urun;

  const ProductCard({
    required this.title,
    required this.imageUrl,
    required this.price,
    this.onTap,
    this.onAddToCart,
    this.urun,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.3;

    return SizedBox(
      height: cardHeight,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ürün görseli (2/3)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: AspectRatio(
                      aspectRatio: 3 / 3,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image Error: $error');
                          print('Image URL: ${widget.imageUrl}');
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(height: 4),
                                Text(
                                  'Resim yüklenemedi',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Yazı ve buton alanı (1/3)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('🚲', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                'Ücretsiz Teslimat',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₺${widget.price.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                              InkWell(
                                onTap: widget.onAddToCart,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Favori butonu
              if (widget.urun != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoritesCubit, List<Urun>>(
                    builder: (context, favorites) {
                      return FutureBuilder<bool>(
                        future: context
                            .read<FavoritesCubit>()
                            .isFavorite(widget.urun!),
                        builder: (context, snapshot) {
                          final isFavorite = snapshot.data ?? false;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                context
                                    .read<FavoritesCubit>()
                                    .toggleFavorite(widget.urun!);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
