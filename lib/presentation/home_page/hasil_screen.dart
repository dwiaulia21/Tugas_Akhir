import 'package:flutter/material.dart';

class HasilScreen extends StatelessWidget {
  final Map<int, String> userAnswers;
  final Map<String, double> hasilDiagnosa;

  HasilScreen({required this.userAnswers, required this.hasilDiagnosa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Diagnosa'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hasil Diagnosa:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...hasilDiagnosa.entries.map((entry) {
              return Text(
                '${entry.key}: ${entry.value.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 18),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Jawaban Anda:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...userAnswers.entries.map((entry) {
              return Text(
                'Gejala ${entry.key + 1}: ${entry.value}',
                style: TextStyle(fontSize: 18),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}