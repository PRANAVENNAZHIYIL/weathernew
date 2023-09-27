import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp_3/model/weathermodel.dart';
import 'package:weatherapp_3/view/Screen/widgets/additionalinformation.dart';
import 'package:weatherapp_3/view/Screen/widgets/weatherforecast.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late WeatherResponse? report;

  // final DataIntegration data = DataIntegration();
  @override
  void initState() {
    getCurreentWeather();
    super.initState();
  }

  double? temp;
  bool isloading = false;
  Future getCurreentWeather() async {
    try {
      setState(() {
        isloading = true;
      });
      String cityname = 'Kerala';
      final result = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityname&appid=e8dd0128155bc972c671748bbfdfd77a"));
      // print(result.body);
      final data = jsonDecode(result.body);

      if (int.parse(data['cod']) != 200) {
        throw 'unexpected error occcurred';
      }
      setState(() {
        report = WeatherResponse.fromJson(data);
        temp = data['list'][0]["main"]['temp'];

        isloading = false;
      });

      print(data['list'][0]['main']['temp']);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    getCurreentWeather();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
          title: const Text(
            "Weather App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(
                strokeWidth: 5,
              ))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17)),
                        elevation: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  " ${report!.list[0].main.temp}° K",
                                  style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.cloud,
                                  size: 60,
                                ),
                                const Text(
                                  "Rain",
                                  style: TextStyle(fontSize: 30),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Weather Forecast",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                HourlyForecastItem(
                                  temperature:
                                      "${report!.list[index].main.temp}",
                                  time: '10:00',
                                  icon: Icons.cloud,
                                ),
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    const Text(
                      "Additional information",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfo(
                          data: 'Humidity',
                          icon: Icons.water_drop,
                          temperature: '20',
                        ),
                        AdditionalInfo(
                          data: 'Wind speed',
                          icon: Icons.wind_power,
                          temperature: '20',
                        ),
                        AdditionalInfo(
                          data: 'Pressure',
                          icon: Icons.ramen_dining,
                          temperature: '20',
                        ),
                      ],
                    )
                  ],
                ),
              ));
  }
}
