import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants.dart';
import 'today_info.dart';

class HomeScreen extends StatefulWidget {
  late  String currentLocation;
   HomeScreen({Key? key, required this.currentLocation}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _weatherData;
  TextEditingController searchfield = TextEditingController();
  List citysearch = [];
  List allCityList = [];

  ///get current location

  ///api
  Future<Map<String, dynamic>> _fetchWeatherData(String city) async {
    const apiKey = '55b07ab9a8a059147d857d682b9f5abb';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorMessage =
          'Failed to load weather data: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }

  @override
  void initState() {
    print(widget.currentLocation);
    print('currentLocation');
    super.initState();
    _weatherData = _fetchWeatherData(widget.currentLocation);
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ///search bar
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: kprimaryColor)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Center(
                      child: TextFormField(
                        controller: searchfield,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: kprimaryColor, fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          icon: Icon(Icons.search, color: kprimaryColor),
                          contentPadding: EdgeInsets.only(
                            bottom: 12,
                          ),
                          hintText: 'Search City',
                          hintStyle:
                              TextStyle(color: kprimaryColor, fontSize: 16),
                        ),
                        onFieldSubmitted: (value) {
                          setState(() {
                            widget.currentLocation = value;
                            _weatherData = _fetchWeatherData(value);
                            searchfield.clear();
                          });
                        },
                      ),
                    ),
                  )),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _weatherData,
              builder: (context, snapshot) {
                if (_weatherData == null) {
                  return Padding(
                     padding:  EdgeInsets.only(top: height*.1),

                child: Column(
                      children: [
                        CircularProgressIndicator(color: kprimaryColor),
                        Text('Please wait....')
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Padding(
                    padding:  EdgeInsets.only(top: height*.1),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: kprimaryColor),
                        Text('Please wait....')
                      ],
                    ),
                  );
                } else if (widget.currentLocation.isEmpty) {
                  return Padding(
                    padding:  EdgeInsets.only(top: height*.1),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: kprimaryColor),
                        Text('Please wait....')
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final weatherData = snapshot.data;
                  if (weatherData == null || weatherData.isEmpty) {
                    return Center(
                      child: Text(
                        'Error: Unable to fetch weather data for ${widget.currentLocation}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  print('1111111111111111111111');
                  print(weatherData);
                  print('1111111111111111111111');
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * .04,
                        ),

                        ///today section
                        TodayInfo(
                          weather: weatherData,
                          currentLocation: widget.currentLocation,
                        ),
                        SizedBox(height: height * .04),

                        ///temp,humidity, weather
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kcontentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Temperature ',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                    Text(
                                      ': ',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                    Text(
                                      '${weatherData['main']['temp']}°C',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Humidity ',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                    Text(
                                      ': ',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                    Text(
                                      '${weatherData['main']['humidity']}%',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Weather ',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                    Text(
                                      ': ',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                    Text(
                                      '${weatherData['weather'][0]['description']}',
                                      style: TextStyle(fontSize: width * .04),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
