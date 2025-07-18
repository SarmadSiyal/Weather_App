import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _refresh() async {
    if (_controller.text.isNotEmpty) {
      await context.read<WeatherProvider>().fetchWeather(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        backgroundColor: Color(0xFFCBF1F5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3FDFD), Color(0xFFCBF1F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _refresh(),
                  ),
                ),
                onSubmitted: (_) => _refresh(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: weatherProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : weatherProvider.error != null
                          ? Center(child: Text(weatherProvider.error!))
                          : weatherProvider.weather == null
                              ? const Center(child: Text('Search for a city'))
                              : ListView(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/${weatherProvider.weather!.iconCode}.png',
                                          height: 100,
                                        ),
                                        Text(
                                          '${weatherProvider.weather!.temperature.toStringAsFixed(1)} °C',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            weatherProvider.weather!.condition),
                                        Text(
                                            'Humidity: ${weatherProvider.weather!.humidity}%'),
                                        const SizedBox(height: 20),
                                        const Text(
                                          '3-Day Forecast',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 10),
                                        ...weatherProvider.weather!.forecast
                                            .map(
                                          (f) => Card(
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/icons/${f.icon}.png',
                                                height: 40,
                                              ),
                                              title: Text(DateFormat('EEEE')
                                                  .format(f.date)),
                                              trailing: Text(
                                                  '${f.temp.toStringAsFixed(1)} °C'),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
