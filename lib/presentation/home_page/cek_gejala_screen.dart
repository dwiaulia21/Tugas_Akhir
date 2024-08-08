import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awull_s_application3/presentation/message_history_tab_container_page/message_history_tab_container_page.dart';
import 'package:awull_s_application3/presentation/home_page/hasil_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CekGejalaScreen extends StatefulWidget {
  const CekGejalaScreen({Key? key}) : super(key: key);

  @override
  State<CekGejalaScreen> createState() => _CekGejalaScreenState();
}

class _CekGejalaScreenState extends State<CekGejalaScreen> {
  bool isLoading = true;
  String errorMessage = '';
  List<String> gejalaList = [];
  Map<int, String> userAnswers = {};
  int currentPage = 0;
  Map<String, double> hasilDiagnosa = {};
  final PageController _pageController = PageController();
  int? userId;

  @override
  void initState() {
    super.initState();
    fetchGejala();
    getPref();
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('id_user');
  }

  Future<void> fetchGejala() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.206.111/cekginjal/api.php/gejala'));
      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final cleanedResponse = responseBody.trim().replaceAll('\uFEFF', '');
        final decodedData = jsonDecode(cleanedResponse);

        if (decodedData is List) {
          setState(() {
            gejalaList = List<String>.from(decodedData.map((e) => e['gejala']));
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Respon tidak sesuai: $cleanedResponse';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Gagal memuat gejala: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data: $e';
        isLoading = false;
      });
    }
  }

  String createJsonPayload(String jawaban, int idGejala) {
    try {
      final payload = jsonEncode(
          {'jawaban': jawaban, 'id_gejala': idGejala, 'id_user': userId});
      return payload;
    } catch (e) {
      print('JSON encoding error: $e');
      return '';
    }
  }

  Future<void> submitJawaban(int index, String jawaban) async {
    final payload = createJsonPayload(jawaban, index + 1);
    if (payload.isEmpty) {
      setState(() {
        errorMessage = 'Gagal mengirim jawaban: Invalid JSON data';
      });
      return;
    }

    print('Submitting payload: $payload');

    try {
      final response = await http.post(
        Uri.parse('http://192.168.206.111/cekginjal/api.php/submit'),
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print('Response data: $decodedData');

        setState(() {
          userAnswers[index] = jawaban;

          // Move to the next question
          if (currentPage < gejalaList.length - 1) {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            currentPage += 1;
          } else {
            // If all questions have been answered
            if (decodedData['hasil'] != null) {
              hasilDiagnosa = Map<String, double>.from(decodedData['hasil']);
            }
            calculateResults();
            saveToDatabase(); // Simpan ke database setelah perhitungan selesai
          }
        });
      } else {
        print(
            'Failed to submit: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: ${response.body}');

        setState(() {
          errorMessage = 'Gagal mengirim jawaban: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      print('Exception during submission: $e');

      setState(() {
        errorMessage = 'Gagal mengirim jawaban: $e';
      });
    }
  }

  void saveToDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id_user');

    // Konversi userAnswers dan hasilDiagnosa ke tipe data yang valid untuk JSON
    final Map<int, String> validUserAnswers =
        userAnswers.map((key, value) => MapEntry(key, value.toString()));
    final Map<String, double> validHasilDiagnosa =
        hasilDiagnosa.map((key, value) => MapEntry(key, value.toDouble()));
    final Map<String, String> stringUserAnswers =
        validUserAnswers.map((key, value) => MapEntry(key.toString(), value));

    final Map<String, double> stringDiagnosa = validHasilDiagnosa;
    // Debug log untuk memeriksa tipe data dalam userAnswers dan hasilDiagnosa
    validUserAnswers.forEach((key, value) {
      print('User Answer Key: $key, Value: $value, Type: ${value.runtimeType}');
    });

    validHasilDiagnosa.forEach((key, value) {
      print('Diagnosa Key: $key, Value: $value, Type: ${value.runtimeType}');
    });

    // Buat map data
    final Map<String, dynamic> data = {
      'id_user': userId,
      'user_answer': stringUserAnswers,
      'diagnosa': stringDiagnosa,
    };

    // Debug log untuk memeriksa tipe data dalam map
    data.forEach((key, value) {
      print('Key: $key, Value: $value, Type: ${value.runtimeType}');
    });

    // Gunakan jsonEncode untuk mengonversi map ke JSON string
    try {
      final payload = jsonEncode(data);
      print('Payload: $payload'); // Tambahkan ini untuk logging

      final response = await http.post(
        Uri.parse('http://192.168.206.111/cekginjal/api.php/save_history'),
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      if (response.statusCode == 200) {
        print('Data berhasil disimpan ke database.');

        // Navigate to MessageHistoryTabContainerPage after saving to database
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageHistoryTabContainerPage(
              userAnswers: userAnswers,
              hasilDiagnosa: hasilDiagnosa,
              solusiDiagnosa: {},
            ),
          ),
        );
      } else {
        print('Gagal menyimpan data ke database: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception saat menyimpan data ke database: $e');
    }
  }

  void calculateResults() {
    List<int> diareTanpaDehidrasi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    List<int> diareDehidrasiRinganSedang = [
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20
    ];
    List<int> diareDehidrasiBerat = [21, 22, 23, 24, 25, 26];

    double hasilDiareTanpaDehidrasi = calculatePercentage(diareTanpaDehidrasi);
    double hasilDiareDehidrasiRinganSedang =
        calculatePercentage(diareDehidrasiRinganSedang);
    double hasilDiareDehidrasiBerat = calculatePercentage(diareDehidrasiBerat);

    hasilDiagnosa = {
      'Diare Tanpa Dehidrasi': hasilDiareTanpaDehidrasi,
      'Diare Dehidrasi Ringan/Sedang': hasilDiareDehidrasiRinganSedang,
      'Diare Dehidrasi Berat': hasilDiareDehidrasiBerat,
    };

    print('Hasil Diare Tanpa Dehidrasi: $hasilDiareTanpaDehidrasi');
    print(
        'Hasil Diare Dehidrasi Ringan/Sedang: $hasilDiareDehidrasiRinganSedang');
    print('Hasil Diare Dehidrasi Berat: $hasilDiareDehidrasiBerat');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilScreen(
          userAnswers: userAnswers,
          hasilDiagnosa: hasilDiagnosa,
        ),
      ),
    );
  }

  double calculatePercentage(List<int> penyakit) {
    int nilai = 0;
    userAnswers.forEach((index, jawaban) {
      if (jawaban == 'ya' && penyakit.contains(index + 1)) {
        nilai += 1;
      }
    });
    return (nilai / penyakit.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter:
            GradientPainter(), // Use GradientPainter to match the background
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : PageView.builder(
                    itemCount: gejalaList.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(70),
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color inside container
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Apakah Anda mengalami ${gejalaList[index]}?',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => submitJawaban(index, 'ya'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .green, // Green color for 'ya' button
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    textStyle: TextStyle(fontSize: 18),
                                  ),
                                  child: Text('Ya'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      submitJawaban(index, 'tidak'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .red, // Red color for 'tidak' button
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    textStyle: TextStyle(fontSize: 18),
                                  ),
                                  child: Text('Tidak'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
