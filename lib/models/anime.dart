class Anime {
  final int id;
  final String titles;
  final String? posterImage;
  final String? coverImage;
  final String? ageRating;
  final double? averageRating;
  final int? episodeCount;
  final String? synopsis;

  Anime({
    required this.id,
    required this.titles,
    this.posterImage,
    this.coverImage,
    this.ageRating,
    this.averageRating,
    this.episodeCount,
    this.synopsis,
  });

  // Konversi JSON dari Kitsu API ke model Anime
  factory Anime.fromJson(Map<String, dynamic> json) {
    final item = (json.containsKey('data') && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final attributes = (item['attributes'] as Map<String, dynamic>?) ?? {};
    final titlesMap = attributes['titles'] as Map<String, dynamic>?;
    final posterMap = attributes['posterImage'] as Map<String, dynamic>?;
    final coverMap = attributes['coverImage'] as Map<String, dynamic>?;

    return Anime(
      id: int.tryParse(item['id']?.toString() ?? '') ?? 0,
      titles: titlesMap?['en_jp'] ??
          attributes['canonicalTitle'] ??
          titlesMap?['en'] ??
          titlesMap?['ja_jp'] ??
          'Untitled',
      posterImage: posterMap?['small'] ??
          posterMap?['medium'] ??
          posterMap?['original'] ??
          posterMap?['tiny'],
      coverImage: coverMap?['large'] ??
          coverMap?['original'] ??
          coverMap?['small'] ??
          coverMap?['tiny'],
      ageRating: attributes['ageRating']?.toString(),
      averageRating: attributes['averageRating'] != null
          ? double.tryParse(attributes['averageRating'].toString())
          : null,
      episodeCount: attributes['episodeCount'] is int
          ? attributes['episodeCount'] as int
          : int.tryParse(attributes['episodeCount']?.toString() ?? ''),
      synopsis: attributes['synopsis']?.toString() ??
          attributes['description']?.toString() ??
          '',
    );
  }

  // Menyimpan data anime ke Hive Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titles': titles,
      'posterImage': posterImage,
      'coverImage': coverImage,
      'ageRating': ageRating,
      'averageRating': averageRating,
      'episodeCount': episodeCount,
      'synopsis': synopsis,
    };
  }

  // Membaca data anime dari Hive Map
  factory Anime.fromMap(Map map) {
    return Anime(
      id: map['id'] ?? 0,
      titles: map['titles'] ?? '',
      posterImage: map['posterImage'],
      coverImage: map['coverImage'],
      ageRating: map['ageRating'],
      averageRating: map['averageRating'] != null
          ? double.tryParse(map['averageRating'].toString())
          : null,
      episodeCount: map['episodeCount'] is int
          ? map['episodeCount'] as int
          : int.tryParse(map['episodeCount']?.toString() ?? ''),
      synopsis: map['synopsis'] ?? '',
    );
  }

  // Membersihkan tag HTML dari sinopsis
  String get cleanSynopsis {
    if (synopsis == null || synopsis!.trim().isEmpty) {
      return 'Tidak ada sinopsis.';
    }
    return synopsis!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
