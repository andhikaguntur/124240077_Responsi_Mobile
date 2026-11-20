import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class AnimeApiService {
  static const String baseUrl =
      'https://kitsu.io/api/edge/anime/?page[limit]=20&page[offset]=0';

  // Mengambil daftar anime dari Kitsu API
  Future<List<Anime>> fetchAnimes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List data = body['data'] ?? [];
      return data
          .map((item) => Anime.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat anime dari Kitsu API: ${response.statusCode}');
    }
  }

  // Mengambil data detail anime berdasarkan ID
  Future<Anime> fetchAnimeDetail(int id) async {
    final response = await http.get(
      Uri.parse('https://kitsu.io/api/edge/anime/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final itemData = body['data'] as Map<String, dynamic>;
      return Anime.fromJson(itemData);
    } else {
      throw Exception('Gagal memuat detail anime dengan ID $id: ${response.statusCode}');
    }
  }
}
