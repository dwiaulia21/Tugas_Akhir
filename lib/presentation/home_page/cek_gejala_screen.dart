import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awull_s_application3/presentation/message_history_tab_container_page/message_history_tab_container_page.dart';
import 'package:awull_s_application3/presentation/home_page/hasil_screen.dart'; // Tambahkan ini

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
  Set<int> answeredGejalaIndexes = {};
  Map<String, double> hasilDiagnosa = {};

  @override
  void initState() {
    super.initState();
    fetchGejala();
  }

  Future<void> fetchGejala() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.235.111/cekginjal/api.php/gejala'));
      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final cleanedResponse = responseBody.trim().replaceAll('\uFEFF', '');
        final decodedData = jsonDecode(cleanedResponse);

        if (decodedData is List) {
          setState(() {
            gejalaList = List<String>.from(decodedData);
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

  Future<void> submitJawaban(int index, String jawaban) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.235.111/cekginjal/api.php/submit'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'jawaban': jawaban}),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData.containsKey('next_gejala')) {
          setState(() {
            userAnswers[index] = jawaban;
            answeredGejalaIndexes.add(index);

            if (answeredGejalaIndexes.length >= gejalaList.length) {
              if (decodedData['hasil'] != null) {
                hasilDiagnosa = Map<String, double>.from(decodedData['hasil']);
                calculateResults();
                saveToDatabase(); // Panggil fungsi simpan ke database setelah perhitungan selesai
              } else {
                calculateResults();
              }
            }
          });
        } else {
          setState(() {
            errorMessage = 'Respon tidak sesuai: ${response.body}';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Gagal mengirim jawaban: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal mengirim jawaban: $e';
      });
    }
  }

  void saveToDatabase() async {
    final payload = json.encode({
      'id_user': '123', // Ganti dengan ID pengguna yang sesuai
      'userAnswers': userAnswers,
      'hasilDiagnosa': hasilDiagnosa
    });

    print('Payload: $payload'); // Tambahkan ini untuk logging

    try {
      final response = await http.post(
        Uri.parse('http://192.168.235.111/cekginjal/api.php/save_history'),
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
              hasilDiagnosa: hasilDiagnosa, solusiDiagnosa: {},
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
    List<int> ginjalAkut = [1, 2, 3, 4, 5, 6];
    List<int> ginjalKronis = [7, 8, 9, 10, 11, 12];
    List<int> batuGinjal = [13, 14, 15, 16, 17];
    List<int> infeksiGinjal = [18, 19];
    List<int> kankerGinjal = [20, 21, 22];
    List<int> gagalGinjal = [23, 24, 25, 26, 27];

    double hasilGinjalAkut = calculatePercentage(ginjalAkut);
    double hasilGinjalKronis = calculatePercentage(ginjalKronis);
    double hasilBatuGinjal = calculatePercentage(batuGinjal);
    double hasilInfeksiGinjal = calculatePercentage(infeksiGinjal);
    double hasilKankerGinjal = calculatePercentage(kankerGinjal);
    double hasilGagalGinjal = calculatePercentage(gagalGinjal);

    hasilDiagnosa = {
      'Ginjal Akut': hasilGinjalAkut,
      'Ginjal Kronis': hasilGinjalKronis,
      'Batu Ginjal': hasilBatuGinjal,
      'Infeksi Ginjal': hasilInfeksiGinjal,
      'Kanker Ginjal': hasilKankerGinjal,
      'Gagal Ginjal': hasilGagalGinjal,
    };

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
      appBar: AppBar(
        title: Text('Cek Gejala Ginjal'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: gejalaList.length,
                    itemBuilder: (context, index) {
                      if (answeredGejalaIndexes.contains(index)) {
                        return Container();
                      }
                      return Column(
                        children: [
                          Text(
                            'Apakah Anda mengalami ${gejalaList[index]}?',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  submitJawaban(index, 'ya');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: Text('Ya', style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  submitJawaban(index, 'tidak');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: Text('Tidak', style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}