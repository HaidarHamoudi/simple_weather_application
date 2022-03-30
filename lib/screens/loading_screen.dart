import 'package:simple_weather_application/screens/location_screen.dart';
import 'package:simple_weather_application/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var weatherData;
var hourlyData;
var dailyData;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  Future getLocationData() async {
    WeatherModel weatherModel = WeatherModel();
    weatherData = await weatherModel.getLocationWeather();
    hourlyData = await weatherModel.getHourlyWeather();
    dailyData = await weatherModel.getDailyWeather();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(
            locationWeather: weatherData,
            hourlyWeather: hourlyData,
            dailyWeather: dailyData,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitChasingDots(
          color: Color(0xFFc41a43),
          size: 100.0,
        ),
      ),
    );
  }
}
