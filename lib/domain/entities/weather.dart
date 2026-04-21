class Weather {
  final double temperature;
  final int weatherCode;
  final double humidity;
  final double windSpeed;
  final double apparentTemperature;
  final bool isDay;
  final double maxTemp;
  final double minTemp;
  final String locationName;
  final DateTime time;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  Weather({
    required this.temperature,
    required this.weatherCode,
    required this.humidity,
    required this.windSpeed,
    required this.apparentTemperature,
    required this.isDay,
    required this.maxTemp,
    required this.minTemp,
    required this.locationName,
    required this.time,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'weatherCode': weatherCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'apparentTemperature': apparentTemperature,
      'isDay': isDay,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'locationName': locationName,
      'time': time.toIso8601String(),
      'hourlyForecast': hourlyForecast.map((x) => x.toMap()).toList(),
      'dailyForecast': dailyForecast.map((x) => x.toMap()).toList(),
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      temperature: map['temperature']?.toDouble() ?? 0.0,
      weatherCode: map['weatherCode']?.toInt() ?? 0,
      humidity: map['humidity']?.toDouble() ?? 0.0,
      windSpeed: map['windSpeed']?.toDouble() ?? 0.0,
      apparentTemperature: map['apparent_temperature']?.toDouble() ?? 0.0,
      isDay: map['isDay'] ?? true,
      maxTemp: map['maxTemp']?.toDouble() ?? 0.0,
      minTemp: map['minTemp']?.toDouble() ?? 0.0,
      locationName: map['locationName'] ?? '',
      time: DateTime.parse(map['time']),
      hourlyForecast: List<HourlyWeather>.from(
        map['hourlyForecast']?.map((x) => HourlyWeather.fromMap(x)) ?? [],
      ),
      dailyForecast: List<DailyWeather>.from(
        map['dailyForecast']?.map((x) => DailyWeather.fromMap(x)) ?? [],
      ),
    );
  }
}

class HourlyWeather {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'temperature': temperature,
      'weatherCode': weatherCode,
    };
  }

  factory HourlyWeather.fromMap(Map<String, dynamic> map) {
    return HourlyWeather(
      time: DateTime.parse(map['time']),
      temperature: map['temperature']?.toDouble() ?? 0.0,
      weatherCode: map['weatherCode']?.toInt() ?? 0,
    );
  }
}

class DailyWeather {
  final DateTime time;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  DailyWeather({
    required this.time,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'weatherCode': weatherCode,
    };
  }

  factory DailyWeather.fromMap(Map<String, dynamic> map) {
    return DailyWeather(
      time: DateTime.parse(map['time']),
      maxTemp: map['maxTemp']?.toDouble() ?? 0.0,
      minTemp: map['minTemp']?.toDouble() ?? 0.0,
      weatherCode: map['weatherCode']?.toInt() ?? 0,
    );
  }
}
