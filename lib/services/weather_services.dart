import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = '27ce7719d0f7b7971645467db1adef72';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>?> fetchWeather(double latitude, double longitude) async {
    final Uri url = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric&lang=tr',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Hava durumu alınamadı. Kod: ${response.statusCode}');
      }
    } catch (e) {
      print('İstek hatası: $e');
    }
    return null;
  }
}
