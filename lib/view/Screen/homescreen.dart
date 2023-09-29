import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  late Future<WeatherResponse?> reload;

  //final DataIntegration data = DataIntegration();
  @override
  void initState() {
    reload = getCurreentWeather();
    super.initState();
  }

  // double? temp;
  // bool isloading = false;
  Future<WeatherResponse?> getCurreentWeather() async {
    try {
      // setState(() {
      //   isloading = true;
      // });
      String cityname = 'Kerala';
      final result = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityname&appid=e8dd0128155bc972c671748bbfdfd77a"));
      // print(result.body);
      final data = jsonDecode(result.body);
      report = WeatherResponse.fromJson(data);

      if (int.parse(data['cod']) != 200) {
        throw data['message'];
      }
      // setState(() {
      //
      //   temp = data['list'][0]["main"]['temp'];

      //   isloading = false;
      // });
      return report;
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
                    reload = getCurreentWeather();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
          title: const Text(
            "Weather App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
            future: reload,
            builder: (context, snapshot) {
              print(snapshot);
              print(snapshot.runtimeType);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 4,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        report!.city.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                                  " ${report!.list[0].main.temp} K",
                                  style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  report!.list[0].weather[0].main == 'Clear' ||
                                          report!.list[0].weather[0].main ==
                                              'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 60,
                                ),
                                Text(
                                  report!.list[0].weather[0].main,
                                  style: const TextStyle(fontSize: 30),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Hourly Forecast",
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
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            final time =
                                DateTime.parse(report!.list[index].dtTxt);
                            return Row(
                              children: [
                                HourlyForecastItem(
                                  temperature:
                                      "${report!.list[index].main.temp}",
                                  time: DateFormat.j().format(time),
                                  icon: report!.list[index].weather[0].main ==
                                              'Clear' ||
                                          report!.list[index].weather[0].main ==
                                              'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfo(
                          data: 'Humidity',
                          icon: Icons.water_drop,
                          temperature: '${report!.list[0].main.humidity}',
                        ),
                        AdditionalInfo(
                          data: 'Wind speed',
                          icon: Icons.air,
                          temperature: '${report!.list[0].wind.speed}',
                        ),
                        AdditionalInfo(
                          data: 'Pressure',
                          icon: Icons.hot_tub_outlined,
                          temperature: '${report!.list[0].main.temp}',
                        ),
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
