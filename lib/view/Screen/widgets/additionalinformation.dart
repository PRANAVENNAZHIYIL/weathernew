import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final String data;
  final IconData icon;
  final String temperature;
  const AdditionalInfo({
    super.key,
    required this.data,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          Text(
            data,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            temperature,
            style: const TextStyle(),
          ),
        ],
      ),
    );
  }
}
