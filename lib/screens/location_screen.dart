import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:simple_weather_application/screens/settings_screen.dart';
import 'package:simple_weather_application/services/weather.dart';
import 'package:simple_weather_application/utilities/alert_box_widget.dart';
import 'package:simple_weather_application/utilities/item.dart';
import 'package:simple_weather_application/utilities/weather_info_reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:simple_weather_application/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../dark_theme/dark_theme_provider.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({
    this.locationWeather,
    this.hourlyWeather,
    this.dailyWeather,
  });

  final locationWeather;
  final hourlyWeather;
  final dailyWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  bool showSpinner = false;
  var decodedData;
  var temperature;
  var condition;
  var cityName;
  var msg;
  var weatherIcon;
  var newTemp;
  int day = new DateTime.now().weekday;
  int date = new DateTime.now().day;
  int month = new DateTime.now().month;
  int year = new DateTime.now().year;
  String? monthWord;
  String? dayWord;
  var getFeelsLike;
  int? feelsLike;
  var visibility;
  int? pressure;
  var getMaxTemp;
  int? maxTemp;
  var windSpeed;
  int? humidity;
  double? visibilityValue;
  String? typedCity;
  String? newTypedCity;
  List<String> items = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  List? hourlyDataList;
  int? hourlySize;
  List tempList = [];
  String weatherIconUrl = 'https://openweathermap.org/img/wn/';
  List<String> iconList = [];
  List<String> dateList = [];
  var dailyweather;
  List<Item>? _data1;
  List dailyMinTempList = [];
  List dailyMaxTempList = [];

  List<String> dailyIconList = [];
  List<int> dailyEpochDateList = [];
  List? dailyDataList;
  int? dailySize;
  List<int> dailyWeekDayDateList = [];
  List<int> dailyDayDateList = [];
  List<int> dailyMonthDateList = [];
  List dailyHumidity = [];
  List dailyDescription = [];
  List dailyPressure = [];
  List dailyFeelslike = [];

  var weekday = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  var weekday1 = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun'
  };
  var monthValue = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
    updateHourlyData(widget.hourlyWeather);
    updateDailyData(widget.dailyWeather);
    _data1 = generateItems(7);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateDailyData(dynamic dailyData) {
    dailyDataList = dailyData['list'];
    dailySize = dailyDataList?.length;
    for (int i = 0; i < dailySize!; i++) {
      dailyMinTempList.add(dailyData['list'][i]["main"]['temp_min']);
      dailyMaxTempList.add(dailyData['list'][i]["main"]['temp_max']);
      dailyIconList.add(dailyData['list'][i]['weather'][0]['icon']);
      dailyEpochDateList.add(dailyData['list'][i]['dt']);
      dailyDayDateList.add(
          DateTime.fromMillisecondsSinceEpoch(dailyEpochDateList[i] * 6320)
              .day
              .toInt());
      dailyWeekDayDateList.add(
          DateTime.fromMillisecondsSinceEpoch(dailyEpochDateList[i] * 6320)
              .weekday
              .toInt());
      dailyMonthDateList.add(
          DateTime.fromMillisecondsSinceEpoch(dailyEpochDateList[i] * 1000)
              .month
              .toInt());
      dailyHumidity.add(dailyData['list'][i]["main"]['humidity']);
      dailyDescription.add(dailyData['list'][i]['weather'][0]['main']);
      dailyPressure.add(dailyData['list'][i]["main"]['pressure']);
      dailyFeelslike.add(dailyData['list'][i]["main"]['feels_like']);
    }
  }

  void updateHourlyData(dynamic hourlyData) {
    hourlyDataList = hourlyData['list'];
    hourlySize = hourlyDataList?.length;
    tempList.add(hourlyData['list'][0]['main']['temp']);
    for (int i = 0; i < hourlySize!; i++) {
      tempList.add(hourlyData['list'][i]['main']['temp']);
      iconList.add(hourlyData['list'][i]['weather'][0]['icon']);
      String date = hourlyData['list'][i]['dt_txt'];
      date = date.substring(11, 16);
      dateList.add(date);
    }
  }

  Future<void> _data() async {
    setState(() {
      refreshData();
    });
  }

  void refreshData() async {
    setState(() {
      updateUI(widget.locationWeather);
      tempList = [];
      iconList = [];
      dateList = [];
      updateHourlyData(widget.hourlyWeather);

      dailyIconList = [];
      dailyDescription = [];
      dailyFeelslike = [];
      dailyHumidity = [];
      dailyMaxTempList = [];
      dailyMinTempList = [];
      dailyDayDateList = [];
      dailyMonthDateList = [];
      dailyPressure = [];
      dailyWeekDayDateList = [];

      updateDailyData(widget.dailyWeather);
      _data1 = generateItems(7);
    });
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        newTemp = 0;
        weatherIcon = 'Error';
        msg = 'Unable to get weather data';
        cityName = '';
        feelsLike = 0;
        visibilityValue = 0;
        pressure = 0;
        maxTemp = 0;
        windSpeed = 0;
        humidity = 0;

        return;
      }
      temperature = (weatherData['main']['temp']);
      newTemp = (temperature).toInt();

      condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      monthWord = monthValue[month];
      dayWord = weekday[day];
      getFeelsLike = weatherData['main']['feels_like'];
      feelsLike = getFeelsLike.toInt();

      year = year;

      visibility = weatherData['visibility'];

      visibilityValue = visibility / 1000;

      pressure = weatherData['main']['pressure'];
      getMaxTemp = weatherData['main']['temp_max'];

      maxTemp = getMaxTemp.toInt();

      windSpeed = weatherData['wind']['speed'];
      humidity = weatherData['main']['humidity'];

      msg = weatherData['weather'][0]['main'];

      weatherIcon = weatherModel.getWeatherIcon(condition);

      showSpinner = false;
    });
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure'),
            content: Text('Do you want to exit the app?'),
            actions: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: AlertBoxWidget(
                  text: 'No',
                ),
              ),
              GestureDetector(
                onTap: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: AlertBoxWidget(
                  text: 'Yes',
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  List<Item> generateItems(int numberOfItems) {
    return List.generate(numberOfItems, (int index) {
      return Item(
        headerValue: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    child: Image(
                      image: NetworkImage(
                          '$weatherIconUrl${dailyIconList[index]}@4x.png',
                          scale: 2),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${weekday1[dailyWeekDayDateList[index]]}, ${dailyDayDateList[index]} ${monthValue[dailyMonthDateList[index]]}',
                    style: kExpansionPanelTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${dailyMinTempList[index].toInt()}°',
                    style: kExpansionPanelTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${dailyMaxTempList[index].toInt()}°',
                    style: kExpansionPanelTextStyle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
        expandedValue: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Humidity',
                    style: kExpansionPanelTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 38.0,
                  ),
                  Text(
                    '${dailyHumidity[index]}%',
                    style: kExpansionPanelTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: kExpansionPanelTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    '${dailyDescription[index]}',
                    style: kExpansionPanelTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Pressure',
                    style: kExpansionPanelTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  Text(
                    '${dailyPressure[index]} hPa',
                    style: kExpansionPanelTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Feels Like',
                    style: kExpansionPanelTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 35.0,
                  ),
                  Text(
                    '${dailyFeelslike[index].toInt()}°',
                    style: kExpansionPanelTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return ModalProgressHUD(
      progressIndicator: SpinKitCircle(
        color: Color(0xFFc41a43),
        size: 100.0,
      ),
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kBlackColor,
            title: Text(
              'Simple_Weather_App',
              style:
                  kCityTextStyle.copyWith(fontSize: 20.0, color: kWhiteColor),
            ),
            actions: [
              Switch(
                  value: themeChange.darkTheme,
                  activeColor: Color(0xFFc41a43),
                  onChanged: (value) {
                    setState(() {
                      themeChange.darkTheme = value;
                    });
                  }),
            ]),
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: RefreshIndicator(
                onRefresh: _data,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: buildWeatherDetailsColumn(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildWeatherDetailsColumn() {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              '$cityName',
              style: kCityTextStyle,
              textAlign: TextAlign.left,
            ),
            Text(
              '$dayWord $date $monthWord $year',
              style: kDateTextStyle,
            )
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Container(
          child: Center(
            child: weatherModel.getWeatherIcon(condition),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$newTemp',
              style: kTempTextStyle,
            ),
            Text(
              '°',
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Text(
          '$msg',
          style: kWeatherDescriptionTextStyle,
        ),
        SizedBox(
          height: 60.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeatherInfo(
              topText: '$feelsLike°',
              bottomText: 'Feels Like',
            ),
            WeatherInfo(
              topText: '$visibilityValue km',
              bottomText: 'Visibility',
            ),
          ],
        ),
        SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeatherInfo(
              topText: '$pressure hPa',
              bottomText: 'Pressure',
            ),
            WeatherInfo(
              topText: '$maxTemp°',
              bottomText: 'Max Temp',
            ),
          ],
        ),
        SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeatherInfo(
              topText: '$windSpeed km/hr',
              bottomText: 'Wind',
            ),
            WeatherInfo(
              topText: '$humidity%',
              bottomText: 'Humidity',
            ),
          ],
        ),
        buildTempAndWeatherIconContainer(),
        Column(
          children: [
            buildWeatherExpansionPanelList(),
          ],
        ),
      ],
    );
  }

  Container buildTempAndWeatherIconContainer() {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 9,
        itemBuilder: (context, index) {
          return Container(
            width: 90.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tempList[index].toInt().toString() + '°',
                    style: kTextStyleColorBlack),
                Container(
                  height: 50.0,
                  width: 50.0,
                  child: Image(
                    image: NetworkImage(
                        '$weatherIconUrl${iconList[index]}@4x.png',
                        scale: 2),
                  ),
                ),
                Text(dateList[index], style: kTextStyleColorBlack)
              ],
            ),
          );
        },
      ),
    );
  }

  ExpansionPanelList buildWeatherExpansionPanelList() {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      dividerColor: Colors.grey.shade100,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data1?[index].isExpanded = !isExpanded;
        });
      },
      children: _data1!.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: item.headerValue,
            );
          },
          body: ListTile(
            focusColor: Colors.blueAccent,
            title: item.expandedValue,
          ),
          isExpanded: item.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      elevation: 5.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: kWhiteColor,
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'Weather_UnifiSolutions_Test',
                  style: kCityTextStyle.copyWith(
                    fontSize: 20.0,
                    color: Color(0xFFc41a43),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              Navigator.of(context).push(_createRoute());
            },
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SettingsScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var curve = Curves.ease;

      var begin = Offset(5.0, 1.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
