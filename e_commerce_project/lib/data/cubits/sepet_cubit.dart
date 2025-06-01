import 'package:flutter_bloc/flutter_bloc.dart';
import '../entity/sepet_model.dart';
import '../service/sepet_service.dart';

class SepetCubit extends Cubit<List<SepetModel>> {
  final SepetService _sepetService;
  final String _kullaniciAdi;

  SepetCubit(this._sepetService, this._kullaniciAdi) : super([]);

  Future<void> sepetiYukle() async {
    try {
      final sepet = await _sepetService.sepettekiUrunleriGetir(_kullaniciAdi);
      emit(sepet);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> urunEkle(SepetModel urun) async {
    try {
      await _sepetService.sepeteEkle(urun);
      await sepetiYukle();
    } catch (e) {
      emit(state);
    }
  }

  Future<void> urunSil(int sepetId) async {
    try {
      await _sepetService.sepettenUrunSil(sepetId, _kullaniciAdi);
      await sepetiYukle();
    } catch (e) {
      emit(state);
    }
  }

  Future<void> urunGuncelle(SepetModel urun) async {
    try {
      await _sepetService.sepetUrunGuncelle(urun);
      await sepetiYukle();
    } catch (e) {
      emit(state);
    }
  }
}
