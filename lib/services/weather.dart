import 'package:simple_weather_application/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:simple_weather_application/utilities/api.dart';

const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const openWeatherForecastURL =
    'https://api.openweathermap.org/data/2.5/forecast';

const openWeatherDailyForecastURL =
    'https://api.openweathermap.org/data/2.5/onecall';

class WeatherModel {
  static var lat = 25.276987;
  static var lng = 55.296249;

  Icon getWeatherIcon(int condition) {
    if (condition < 300) {
      return Icon(
        Meteocons.cloud_flash_alt,
        size: 70.0,
      );
    } else if (condition < 400) {
      return Icon(
        Meteocons.drizzle,
        size: 70.0,
      );
    } else if (condition < 600) {
      return Icon(
        Meteocons.windy_rain,
        size: 70.0,
      );
    } else if (condition < 700) {
      return Icon(
        Meteocons.snow_alt,
        size: 70.0,
      );
    } else if (condition < 800) {
      return Icon(
        Meteocons.fog_cloud,
        size: 70.0,
      );
    } else if (condition == 800) {
      return Icon(
        Meteocons.sun,
        size: 70.0,
      );
    } else if (condition <= 804) {
      return Icon(
        Meteocons.clouds,
        size: 70.0,
      );
    } else {
      return Icon(
        Meteocons.cloud_sun_inv,
        size: 70.0,
      );
    }
  }

  Future<dynamic> getCityWeather(String cityName) async {
    String cityName = "Dubai";
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=$cityName&appid=${Api.kOpenWeatherAPIKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=$lat&lon=$lng&appid=${Api.kOpenWeatherAPIKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getHourlyWeather() async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherForecastURL?lat=$lat&lon=$lng&appid=${Api.kOpenWeatherAPIKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getCityHourlyWeather(String cityName) async {
    String cityName = "Dubai";
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherForecastURL?q=$cityName&appid=${Api.kOpenWeatherAPIKey}&units=metric');
    var weatherData = networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getDailyWeather() async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherForecastURL?lat=$lat&lon=$lng&cnt=7&exclude=daily&appid=${Api.kOpenWeatherAPIKey}&units=metric');
    var weatherData = networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getDailyWeatherCity(String cityName) async {
    String cityName = "Dubai";
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherDailyForecastURL?q=$cityName&cnt=7&appid=${Api.kOpenWeatherAPIKey}&units=metric');
    var weatherData = networkHelper.getData();
    return weatherData;
  }
}
