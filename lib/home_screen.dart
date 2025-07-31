// ========== lib/home_screen.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/settings_provider.dart';
// ignore: unused_import
import 'package:weather_app/weather_model.dart';
import 'package:weather_app/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late SettingsProvider _settingsProvider;
  late WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  Future<void> _loadLastCity() async {
    final lastCity = await context.read<WeatherProvider>().getLastCity();
    if (lastCity != null) {
      _controller.text = lastCity;
      await _refresh();
    }
  }

  Future<void> _refresh() async {
    if (_controller.text.isNotEmpty) {
      await _weatherProvider.fetchWeather(_controller.text);
      _settingsProvider.setLastCity(_controller.text);
    }
  }

  String _formatTemperature(double temp) {
    if (!_settingsProvider.isCelsius) {
      temp = (temp * 9 / 5) + 32;
    }
    return '${temp.toStringAsFixed(1)}°${_settingsProvider.isCelsius ? 'C' : 'F'}';
  }

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _weatherProvider = Provider.of<WeatherProvider>(context);

    String backgroundAsset = '';
    if (_weatherProvider.weather != null) {
      final bgType = _weatherProvider.weather!.getWeatherBackground();
      backgroundAsset = 'assets/backgrounds/$bgType.jpg';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundAsset),
            fit: BoxFit.cover,
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
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
                  child: _weatherProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _weatherProvider.error != null
                          ? Center(child: Text(_weatherProvider.error!))
                          : _weatherProvider.weather == null
                              ? const Center(child: Text('Search for a city'))
                              : ListView(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/${_weatherProvider.weather!.iconCode}.png',
                                          height: 100,
                                          width: 100,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _formatTemperature(_weatherProvider
                                              .weather!.temperature),
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _weatherProvider.weather!.condition
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _buildDetailCard(
                                              context,
                                              'Humidity',
                                              '${_weatherProvider.weather!.humidity}%',
                                              Icons.water_drop,
                                            ),
                                            const SizedBox(width: 20),
                                            _buildDetailCard(
                                              context,
                                              'Wind',
                                              '${_weatherProvider.weather!.windSpeed.toStringAsFixed(1)} m/s',
                                              Icons.air,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        Text(
                                          '3-DAY FORECAST',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ..._weatherProvider.weather!.forecast
                                            .map(
                                          (f) => Card(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withOpacity(0.7),
                                            child: ListTile(
                                              leading: SvgPicture.asset(
                                                'assets/icons/${f.icon}.svg',
                                                height: 40,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              title: Text(
                                                DateFormat('EEEE')
                                                    .format(f.date),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
                                              subtitle: Text(
                                                f.condition,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
                                              trailing: Text(
                                                _formatTemperature(f.temp),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
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

  Widget _buildDetailCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon,
                size: 30, color: Theme.of(context).colorScheme.onBackground),
            const SizedBox(height: 5),
            Text(title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                )),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('Dark Mode'),
                    const Spacer(),
                    Switch(
                      value: settings.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        settings.setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Temperature Unit'),
                    const Spacer(),
                    ToggleButtons(
                      isSelected: [
                        settings.isCelsius,
                        !settings.isCelsius,
                      ],
                      onPressed: (index) {
                        settings.toggleTemperatureUnit();
                      },
                      children: const [
                        Text('°C'),
                        Text('°F'),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
