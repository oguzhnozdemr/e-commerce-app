import 'package:flutter_bloc/flutter_bloc.dart';
import '../entity/urun_model.dart';
import '../database/database_helper.dart';

class FavoritesCubit extends Cubit<List<Urun>> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  FavoritesCubit() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    emit(favorites);
  }

  Future<void> toggleFavorite(Urun urun) async {
    final isFavorite = await _dbHelper.isFavorite(urun.id);

    if (isFavorite) {
      await _dbHelper.deleteFavorite(urun.id);
    } else {
      await _dbHelper.insertFavorite(urun);
    }

    await _loadFavorites();
  }

  Future<bool> isFavorite(Urun urun) async {
    return await _dbHelper.isFavorite(urun.id);
  }
}
