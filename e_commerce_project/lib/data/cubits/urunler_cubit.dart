import 'package:flutter_bloc/flutter_bloc.dart';
import '../entity/urun_model.dart';

import '../repository/urunler_repository.dart';

class UrunCubit extends Cubit<List<Urun>> {
  UrunCubit(this.repository) : super([]);
  final UrunlerRepository repository;
  List<Urun> _allUrunler = [];

  Future<void> urunleriYukle() async {
    try {
      final urunler = await repository.urunleriYukle();
      _allUrunler = urunler;
      emit(urunler);
    } catch (e) {
      emit([]);
    }
  }

  void urunAra(String query) {
    if (query.isEmpty) {
      emit(_allUrunler);
      return;
    }

    final filteredUrunler = _allUrunler.where((urun) {
      final adLower = urun.ad.toLowerCase();
      final markaLower = urun.marka.toLowerCase();
      final kategoriLower = urun.kategori.toLowerCase();
      final searchLower = query.toLowerCase();

      return adLower.contains(searchLower) ||
          markaLower.contains(searchLower) ||
          kategoriLower.contains(searchLower);
    }).toList();

    emit(filteredUrunler);
  }
}
