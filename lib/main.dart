import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi/controllers/login_controller.dart';
import 'package:responsi/services/notification_service.dart';
import 'package:responsi/views/bindings/anime_binding.dart';
import 'package:responsi/views/pages/detail_page.dart';
import 'package:responsi/views/pages/login_page.dart';
import 'package:responsi/views/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk penyimpanan lokal favorit
  await Hive.initFlutter();
  await Hive.openBox('favorites');

  // Inisialisasi notifikasi lokal
  await NotificationService().init();

  // Pengecekan sesi login dari SharedPreferences
  final loginController = LoginController();
  final bool isLoggedIn = await loginController.isLoggedIn();

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Keripikroll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        primaryColor: const Color(0xFFE50914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      initialRoute: isLoggedIn ? '/main' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(
          name: '/main',
          page: () => const MainPage(),
          binding: AnimeBinding(),
        ),
        GetPage(name: '/detail', page: () => const DetailPage()),
      ],
    );
  }
}
