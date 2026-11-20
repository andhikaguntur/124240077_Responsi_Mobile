import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi/models/anime.dart';
import 'package:responsi/services/anime_api_service.dart';
import 'package:responsi/services/notification_service.dart';

class AnimeController extends GetxController {
  final AnimeApiService _animeService = AnimeApiService();
  final Box _favBox = Hive.box('favorites');

  final isLoading = false.obs;
  final isDetailLoading = false.obs;
  final animes = <Anime>[].obs;
  final favoriteAnimes = <Anime>[].obs;
  final detailAnime = Rx<Anime?>(null);

  @override
  void onInit() {
    super.onInit();
    retrieveAnimes();
    loadFavorites();
  }

  // Mengambil daftar anime untuk Home Page
  Future<void> retrieveAnimes() async {
    try {
      isLoading.value = true;
      final data = await _animeService.fetchAnimes();
      animes.assignAll(data);
    } catch (e, stackTrace) {
      debugPrint('Error retrieveAnimes: $e\n$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  // Mengambil detail anime untuk Detail Page
  Future<void> retrieveDetail(int id, {Anime? initial}) async {
    if (initial != null) {
      detailAnime.value = initial;
    }
    try {
      isDetailLoading.value = true;
      final data = await _animeService.fetchAnimeDetail(id);
      detailAnime.value = data;
    } catch (e, stackTrace) {
      debugPrint('Error retrieveDetail: $e\n$stackTrace');
    } finally {
      isDetailLoading.value = false;
    }
  }

  // Memuat daftar anime favorit dari Hive
  void loadFavorites() {
    final List<Anime> items = [];
    for (var value in _favBox.values) {
      items.add(Anime.fromMap(Map.from(value)));
    }
    favoriteAnimes.assignAll(items);
  }

  // Cek status favorit suatu anime
  bool isFavorite(int id) {
    return favoriteAnimes.any((anime) => anime.id == id);
  }

  // Tambah / hapus favorit anime dengan notifikasi
  void toggleFavorite(Anime anime) {
    if (isFavorite(anime.id)) {
      _favBox.delete(anime.id);
      NotificationService().showNotification(
        id: 3,
        title: 'Favorit',
        body: 'Anime berhasil dihapus dari daftar favorit.',
      );
    } else {
      _favBox.put(anime.id, anime.toMap());
      NotificationService().showNotification(
        id: 2,
        title: 'Favorit',
        body: 'Anime berhasil ditambahkan ke daftar favorit.',
      );
    }
    loadFavorites();
  }

  // Hapus anime dari favorit dengan notifikasi
  void removeFavorite(int id) {
    _favBox.delete(id);
    loadFavorites();
    NotificationService().showNotification(
      id: 3,
      title: 'Favorit',
      body: 'Anime berhasil dihapus dari daftar favorit.',
    );
  }
}
