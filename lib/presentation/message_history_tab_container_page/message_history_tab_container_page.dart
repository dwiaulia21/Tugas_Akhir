import 'dart:convert';
import 'package:awull_s_application3/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageHistoryTabContainerPage extends StatefulWidget {
  final Map<int, String> userAnswers;
  final Map<String, double> hasilDiagnosa;
  final Map<String, String> solusiDiagnosa;

  const MessageHistoryTabContainerPage({
    Key? key,
    required this.userAnswers,
    required this.hasilDiagnosa,
    required this.solusiDiagnosa,
  }) : super(key: key);

  @override
  _MessageHistoryTabContainerPageState createState() =>
      _MessageHistoryTabContainerPageState();
}

class _MessageHistoryTabContainerPageState
    extends State<MessageHistoryTabContainerPage> {
  late Future<List<dynamic>> _history;

  @override
  void initState() {
    super.initState();
    _history = _fetchHistory();
  }

  Future<List<dynamic>> _fetchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('id_user');

      if (token == null || token.isEmpty || userId == null) {
        throw Exception('User not logged in or user ID is missing');
      }

      final response = await http.get(
        Uri.parse(
            'http://192.168.206.111/cekginjal/riwayat_api.php?id_user=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 'success') {
          return decodedResponse['history'];
        } else {
          throw Exception('API Error: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message History'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _history,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load history'),
                  SizedBox(height: 10),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history found'));
          } else {
            final history = snapshot.data!;

            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Diagnosa: ${item['diagnosa']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tanggal: ${item['date']}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
