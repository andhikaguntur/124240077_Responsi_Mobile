import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsi/controllers/anime_controller.dart';
import 'package:responsi/models/anime.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final AnimeController controller = Get.find<AnimeController>();
  late Anime initialAnime;

  @override
  void initState() {
    super.initState();
    initialAnime = Get.arguments as Anime;
    controller.retrieveDetail(initialAnime.id, initial: initialAnime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          'Detail Anime',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }

        final currentAnime = controller.detailAnime.value ?? initialAnime;
        final isFav = controller.isFavorite(currentAnime.id);
        final heroImage = currentAnime.coverImage ?? currentAnime.posterImage;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image sebagai Hero Image
              if (heroImage != null && heroImage.isNotEmpty)
                Image.network(
                  heroImage,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  headers: const {'User-Agent': 'Mozilla/5.0'},
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 240,
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE50914),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: Colors.grey.shade900,
                    child: const Icon(
                      Icons.movie,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                Container(
                  height: 240,
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(Icons.movie, size: 60, color: Colors.grey),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Anime
                    Text(
                      currentAnime.titles,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          currentAnime.averageRating != null
                              ? currentAnime.averageRating.toString()
                              : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Rating Umur & Jumlah Episode
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Rating Umur: ${currentAnime.ageRating ?? '-'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Episode: ${currentAnime.episodeCount != null ? currentAnime.episodeCount.toString() : '-'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tombol Nonton & Tombol Favorit
                    Row(
                      children: [
                        // Tombol Nonton
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Memutar anime: ${currentAnime.titles}',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Nonton',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE50914),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Tombol Tambah ke Favorit dengan perbedaan UI
                        ElevatedButton.icon(
                          onPressed: () {
                            controller.toggleFavorite(currentAnime);
                          },
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.white : Colors.white70,
                          ),
                          label: Text(
                            isFav ? 'Favorit' : 'Tambah',
                            style: TextStyle(
                              color: isFav ? Colors.white : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav
                                ? const Color(0xFFE50914)
                                : const Color(0xFF2A2A2A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isFav
                                    ? const Color(0xFFE50914)
                                    : Colors.white24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sinopsis Anime
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentAnime.cleanSynopsis,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
