// ========== lib/weather_service.dart ==========
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather_model.dart';

class WeatherService {
  static const _apiKey = 'f146dc10f967fa0ca838e5266d4a6858';

  static Future<WeatherModel> fetchWeather(String city) async {
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey';

    final weatherRes = await http.get(Uri.parse(weatherUrl));
    if (weatherRes.statusCode == 404) {
      throw Exception(
          'City "$city" not found. Please check the spelling and try again.');
    } else if (weatherRes.statusCode != 200) {
      throw Exception(
          'Failed to load weather data (Error ${weatherRes.statusCode})');
    }

    final forecastRes = await http.get(Uri.parse(forecastUrl));
    if (forecastRes.statusCode != 200) {
      throw Exception('Failed to load forecast');
    }

    final weatherData = json.decode(weatherRes.body);
    final forecastData = json
        .decode(forecastRes.body)['list']
        .where((e) => e['dt_txt'].toString().contains('12:00:00'))
        .take(3)
        .toList();

    return WeatherModel.fromJson(weatherData, forecastData);
  }
}
