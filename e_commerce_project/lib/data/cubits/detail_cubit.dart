import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/urun_model.dart';
import '../repository/urunler_repository.dart';

class DetailCubit extends Cubit<Urun?> {
  DetailCubit() : super(null);

  void urunGetir(List<Urun> urunler, int id) {
    try {
      final urun = urunler.firstWhere(
        (element) => element.id == id,
        orElse: () => Urun(
          id: 0,
          ad: '',
          fiyat: 0,
          resim: '',
          kategori: '',
          marka: '',
        ),
      );
      emit(urun);
    } catch (e) {
      emit(null);
    }
  }
}
