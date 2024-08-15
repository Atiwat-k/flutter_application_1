import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/models/response/TripIdxGetResponse.dart';

import 'package:http/http.dart' as http;
import '../config/config.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  // Create late variables
  late TripIdxGetResponse tripIdxGetResponse;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    // Call async function
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // Loding data with FutureBuilder
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Load Done
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  tripIdxGetResponse.name,
                  style: const TextStyle(
                    fontSize: 15.0, // ขนาดฟอนต์
                    //fontWeight: FontWeight.bold, // หนักหรือบาง
                    color: Color.fromARGB(255, 0, 0, 0), // สีของข้อความ
                    letterSpacing: 0.5, // การเว้นระยะห่างระหว่างตัวอักษร
                    wordSpacing: 1, // การเว้นระยะห่างระหว่างคำ
                    fontFamily: 'Roboto', // ฟอนต์ที่ใช้
                  ),
                ),
                Text(tripIdxGetResponse.country),
                Image.network(
                  tripIdxGetResponse.coverimage,
                  width: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Cannot load image',
                        style: TextStyle(
                          color: Color.fromARGB(255, 39, 38, 38),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tripIdxGetResponse.price.toString()),
                    Text(tripIdxGetResponse.destinationZone)
                  ],
                ),
                Text(tripIdxGetResponse.detail),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FilledButton(
                      onPressed: () {}, child: const Text('จองโลด')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Async function for api call
  Future<void> loadDataAsync() async {
    var config = await Configguration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
