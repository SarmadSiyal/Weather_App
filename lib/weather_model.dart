// ========== lib/weather_model.dart ==========
class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final List<Forecast> forecast;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    required this.forecast,
  });

  factory WeatherModel.fromJson(
      Map<String, dynamic> json, List<dynamic> forecastList) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'] - 273.15,
      condition: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      forecast: forecastList.map((e) => Forecast.fromJson(e)).toList(),
    );
  }

  String getWeatherBackground() {
    final condition = this.condition.toLowerCase();
    if (condition.contains('clear')) return 'sunny';
    if (condition.contains('cloud')) return 'cloudy';
    if (condition.contains('rain') || condition.contains('drizzle'))
      return 'rainy';
    if (condition.contains('snow')) return 'snow';
    if (condition.contains('thunder')) return 'storm';
    return 'default';
  }
}

class Forecast {
  final DateTime date;
  final double temp;
  final String icon;
  final String condition;

  Forecast({
    required this.date,
    required this.temp,
    required this.icon,
    required this.condition,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['dt_txt']),
      temp: json['main']['temp'] - 273.15,
      icon: json['weather'][0]['icon'],
      condition: json['weather'][0]['description'],
    );
  }
}
