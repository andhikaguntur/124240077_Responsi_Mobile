import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:responsi/controllers/anime_controller.dart';
import 'package:responsi/controllers/login_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LoginController _loginController = LoginController();
  final AnimeController _animeController = Get.find<AnimeController>();
  String _username = '';
  String _locationText = 'Lokasi belum dilacak';
  bool _isLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _trackLocation();
  }

  void _loadUsername() async {
    final user = await _loginController.getUsername();
    setState(() {
      _username = user;
    });
  }

  // Melacak lokasi pengguna (LBS)
  Future<void> _trackLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationText = 'Layanan GPS tidak aktif';
          _isLocationLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationText = 'Izin lokasi ditolak';
            _isLocationLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationText = 'Izin lokasi ditolak permanen';
          _isLocationLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      setState(() {
        _locationText =
            'Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}';
        _isLocationLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationText = 'Gagal melacak lokasi';
        _isLocationLoading = false;
      });
    }
  }

  void _handleLogout() async {
    await _loginController.logout();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar Pengguna
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF333333),
                child: Icon(Icons.person, size: 60, color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // Username dari SharedPreferences
              Text(
                _username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Jumlah Anime Favorit dari Hive
              Obx(() {
                final count = _animeController.favoriteAnimes.length;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Anime Favorit: $count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Lokasi Pengguna (LBS)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFFE50914),
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Lokasi Pengguna (LBS)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _isLocationLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFE50914),
                            ),
                          )
                        : Text(
                            _locationText,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: _isLocationLoading ? null : _trackLocation,
                      child: const Text(
                        'Perbarui Lokasi',
                        style: TextStyle(
                          color: Color(0xFFE50914),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
