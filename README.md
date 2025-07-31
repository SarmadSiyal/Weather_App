# Weather Forecast App

A Flutter application that displays current weather and 3-day forecast using OpenWeatherMap API.

## Features

- Current weather conditions (temperature, humidity, wind speed)
- 3-day weather forecast
- City search functionality
- Dark/Light mode toggle
- Temperature unit conversion (°C/°F)
- Dynamic background images based on weather
- Error handling for invalid cities
- Persistent last-searched city

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/weather-app.git
   cd weather-app

# Get an API key
- Register at OpenWeatherMap
- Get your free API key
- Replace the placeholder in lib/weather_service.dart:
- static const _apiKey = 'f146dc10f967fa0ca838e5266d4a6858';
- 
# Add required assets
- Download weather icons (PNG format) from OpenWeatherMap
- Place them in assets/icons/ director
- Add background images in assets/backgrounds/ (sunny.jpg, rainy.jpg, etc.)

# Run the app
- flutter pub get
- flutter run

# API Usage Notes
- Uses OpenWeatherMap's Current Weather and 5-day Forecast APIs
- Free tier allows 60 calls/minute
- Temperature converted from Kelvin to Celsius/Fahrenheit
- Forecast shows daily weather at 12:00 PM

# Dependencies
- http: ^0.13.5 - For API calls
- provider: ^6.1.1 - State management
- intl: ^0.18.1 - Date formatting
- shared_preferences: ^2.2.2 - Local storage
