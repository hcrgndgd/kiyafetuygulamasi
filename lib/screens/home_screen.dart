import 'package:flutter/material.dart';
import 'package:wardrobe_app/screens/settings_screen.dart';
import 'package:wardrobe_app/services/weather_services.dart';
import 'wardrobe_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // <-- Yeni eklendi

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _weatherData;
  String? _cityName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _loading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String city = placemarks.first.locality ?? "Bilinmeyen Konum";

      final weatherService = WeatherService();
      final data = await weatherService.fetchWeather(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weatherData = data;
        _cityName = city;
        _loading = false;
      });
    } catch (e) {
      print("Hava durumu alınamadı: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? iconUrl;
    if (_weatherData != null) {
      final iconCode = _weatherData!['weather'][0]['icon'];
      iconUrl = "http://openweathermap.org/img/wn/$iconCode@2x.png";
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple.shade800,
        title: const Text(
          "Ana Sayfa",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 220,
              child: Card(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.all(20),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child:
                        _loading
                            ? const CircularProgressIndicator()
                            : _weatherData == null
                            ? const Text("Hava durumu verisi alınamadı.")
                            : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Bugünkü Hava Durumu',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_cityName != null) ...[
                                  const SizedBox(height: 5),
                                  Text(
                                    _cityName!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (iconUrl != null)
                                      Image.network(
                                        iconUrl,
                                        width: 50,
                                        height: 50,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${_weatherData!['main']['temp'].round()}°C - ${_weatherData!['weather'][0]['description']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //öneri butonu
        },
        backgroundColor: const Color.fromRGBO(106, 27, 154, 1),
        child: const Icon(Icons.question_mark, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple.shade200,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                FluentIcons.image_32_filled,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WardrobeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
