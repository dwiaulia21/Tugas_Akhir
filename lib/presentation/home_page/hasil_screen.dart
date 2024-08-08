import 'package:flutter/material.dart';

class HasilScreen extends StatelessWidget {
  final Map<int, String> userAnswers;
  final Map<String, double> hasilDiagnosa;

  const HasilScreen({
    Key? key,
    required this.userAnswers,
    required this.hasilDiagnosa,
  }) : super(key: key);

  List<Map<String, String>> getSolusi(String jenisDiare) {
    switch (jenisDiare) {
      case 'Diare Tanpa Dehidrasi':
        return [
          {'title': 'Hidrasi', 'desc': 'Minum cairan elektrolit untuk mencegah dehidrasi.'},
          {'title': 'Istirahat', 'desc': 'Pastikan Anda beristirahat yang cukup.'},
          {'title': 'Makanan Sehat', 'desc': 'Konsumsi makanan yang mudah dicerna.'},
        ];
      case 'Diare Dehidrasi Ringan/Sedang':
        return [
          {'title': 'Oralit', 'desc': 'Minum oralit untuk menggantikan cairan tubuh.'},
          {'title': 'Pantau Kondisi', 'desc': 'Pantau kondisi tubuh dan segera cari bantuan medis jika memburuk.'},
          {'title': 'Diet BRAT', 'desc': 'Konsumsi pisang, nasi, saus apel, dan roti panggang.'},
        ];
      case 'Diare Dehidrasi Berat':
        return [
          {'title': 'Bantuan Medis', 'desc': 'Segera cari bantuan medis untuk penanganan lebih lanjut.'},
          {'title': 'Infus Cairan', 'desc': 'Anda mungkin memerlukan infus cairan untuk rehidrasi.'},
          {'title': 'Rawat Inap', 'desc': 'Anda mungkin perlu dirawat inap untuk pemantauan intensif.'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: GradientPainter(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Hasil Diagnosa',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ...hasilDiagnosa.entries.map((entry) {
                  String jenisDiare = entry.key;
                  double persen = entry.value;
                  List<Map<String, String>> solusi = getSolusi(jenisDiare);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jenisDiare,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Kemungkinan: ${persen.toStringAsFixed(2)}%',
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 10),
                          ...solusi.map((sol) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sol['title']!,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                                  ),
                                  Text(
                                    sol['desc']!,
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue,
          Colors.white,
        ],
        stops: [0.5, 0.5],
      ).createShader(rect);

    final Path path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.4,
        size.width,
        size.height * 0.2,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
