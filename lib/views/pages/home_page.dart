import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsi/controllers/anime_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AnimeController controller = Get.find<AnimeController>();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          'Keripikroll!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }

        if (controller.animes.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada anime yang ditemukan.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFE50914),
          onRefresh: () => controller.retrieveAnimes(),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.animes.length,
            itemBuilder: (context, index) {
              final anime = controller.animes[index];

              return GestureDetector(
                onTap: () => Get.toNamed('/detail', arguments: anime),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster Image
                      Expanded(
                        child:
                            anime.posterImage != null &&
                                anime.posterImage!.isNotEmpty
                            ? Image.network(
                                anime.posterImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                headers: const {'User-Agent': 'Mozilla/5.0'},
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFE50914),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Colors.grey.shade900,
                                      child: const Center(
                                        child: Icon(
                                          Icons.movie,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              )
                            : Container(
                                color: Colors.grey.shade900,
                                child: const Center(
                                  child: Icon(
                                    Icons.movie,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                      // Info Anime di Card Bawah
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul Anime
                            Text(
                              anime.titles,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Rating Umur - Episode
                            Text(
                              '${anime.ageRating ?? 'All'} - ${anime.episodeCount != null ? '${anime.episodeCount} episodes' : '-'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Rating Angka
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  anime.averageRating != null
                                      ? anime.averageRating.toString()
                                      : '-',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
