// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class DataIntegration {
//   dynamic temp = "";
//   Future getCurreentWeather() async {
//     try {
//       String cityname = 'Goa';
//       final result = await http.get(Uri.parse(
//           "https://api.openweathermap.org/data/2.5/forecast?q=$cityname&appid=e8dd0128155bc972c671748bbfdfd77a"));
//       // print(result.body);
//       final data = jsonDecode(result.body);
//       if (int.parse(data['cod']) != 200) {
//         throw 'unexpected error occcurred';
//       }
//       temp = data['list'][0]["main"]['temp'];

//       print(data['list'][0]['main']['temp']);
//     } catch (e) {
//       throw e.toString();
//     }
//   }
// }
