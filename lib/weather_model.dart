class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final String iconCode;
  final List<Forecast> forecast;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
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
      iconCode: json['weather'][0]['icon'],
      forecast: forecastList.map((e) => Forecast.fromJson(e)).toList(),
    );
  }
}

class Forecast {
  final DateTime date;
  final double temp;
  final String icon;

  Forecast({required this.date, required this.temp, required this.icon});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['dt_txt']),
      temp: json['main']['temp'] - 273.15,
      icon: json['weather'][0]['icon'],
    );
  }
}
