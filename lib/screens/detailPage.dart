import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, String> emergencyDetail;

  const DetailPage(this.emergencyDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(emergencyDetail['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(emergencyDetail['image']!),
            const SizedBox(height: 20),
            Text(
              emergencyDetail['details']!,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}