import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/secret.dart';
import 'additional_info_item.dart';
import 'hourly_fore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {

    try{
      String cityName = "Chittaurgarh,india";
      final res = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKEY"));
      final data = jsonDecode(res.body);

      if (data["cod"] != "200") {
        throw "error ha";
      }

      return data;

    }catch (e) {
      throw "unexpected error occurred";
    }



  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {
            setState(() {
              weather = getCurrentWeather();
            });
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data["list"][0];

          final currentTemp = (currentWeatherData["main"]["temp"]-273.15).toStringAsFixed(2);
          final currentSky =currentWeatherData["weather"][0]["main"];
          IconData currentIcon = currentSky == "Clouds" ? Icons.cloud
              : currentSky == "Rain" ? Icons.water_drop_outlined
              : currentSky == "Clear" ? Icons.clear_all
              : Icons.sunny;

          final currentHumidity = currentWeatherData["main"]["humidity"];
          final currentWindSpeed = currentWeatherData["wind"]["speed"];
          final currentPressure = currentWeatherData["main"]["pressure"];



          return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              //Main Card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 22),
                    child: Column(
                      children: [
                        Text("$currentTemp° C",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
                         Icon(
                          currentIcon,
                          size: 55
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                         Text("$currentSky")
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {

                    final time = DateTime.parse(data["list"][index+1]["dt_txt"]);

                    return HourlyFore(time: DateFormat.j().format(time),
                        icon: data["list"][index+1]["weather"][0]["main"] == "Clouds" ? Icons.cloud
                            : data["list"][index+1]["weather"][0]["main"] == "Rain" ? Icons.water_drop_outlined
                            : data["list"][index+1]["weather"][0]["main"] == "Clear" ? Icons.clear_all
                            : Icons.sunny,
                        temp: "${(data["list"][index+1]["main"]["temp"]-273.15).toStringAsFixed(2)}° C");
                  },),
              ),

              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: "$currentHumidity",
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: "Wind Speed",
                    value: "$currentWindSpeed",
                  ),
                  AdditionalInfoItem(
                    icon: Icons.line_weight,
                    label: "Pressure",
                    value: "$currentPressure",
                  )
                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}
