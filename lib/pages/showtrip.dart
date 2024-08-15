import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/models/response/trip_get_res.dart';
import 'package:flutter_application_1/pages/proFile.dart';
import 'package:flutter_application_1/pages/trip.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ShowTripPage extends StatefulWidget {
  int idx = 0;
  ShowTripPage({super.key, required this.idx});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  // 1. Use loadDataAsync

  late Future<void> loadData; // ฟังก์ชัน ที่สร้าง

  String url = '';
  List<TripsGetResponses> tripGetResponses = [];
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Configguration config = Configguration();

    // Configguration.getConfig().then(
    //   (value) {
    //     log(value['apiEndpoint']);
    //     url = value['apiEndpoint'];
    //     // getTrips(); จะใช้อีกวิธีในการโหลดข้อมูล
    //   },
    // ).catchError((err) {
    //   log(err.toString());
    // });

    // 4. Assign loadData
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    log('Customer id: ${widget.idx}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx),
                    ));
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("ปลายทาง"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FilledButton(
                    onPressed: () => getTrips(null),
                    child: const Text('ทั้งหมด')),
                const SizedBox(width: 8), // Adjust the width as needed
                FilledButton(
                    onPressed: () => getTrips('เอเชีย'),
                    child: const Text('เอเชีย')),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: () => getTrips('ยุโรป'),
                    child: const Text('ยุโรป')),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: () => getTrips('เอเชียตะวันออกเฉียงใต้'),
                    child: const Text('อาเซียน')),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: () => getTrips('ประเทศไทย'),
                    child: const Text('ประเทศไทย')),
              ],
            ),
          ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         Card(
          //           child: Padding(
          //             padding: const EdgeInsets.all(15.0),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 const Text(
          //                   "วัดพระเเก้ว กรุงเทพฯ",
          //                   style: TextStyle(
          //                       fontSize: 18, fontWeight: FontWeight.bold),
          //                 ),
          //                 const SizedBox(height: 8.0),
          //                 Row(
          //                   children: [
          //                     Image.asset(
          //                       'assets/images/logo.png',
          //                       width: 150,
          //                     ),
          //                     const SizedBox(width: 5.0),
          //                     Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         const Text("ประเทศไทย"),
          //                         const Text("ระยะทาง 10 km"),
          //                         const Text("ราคา 10,000 บาท"),
          //                         FilledButton(
          //                             onPressed: () {},
          //                             child: const Text('รายละเลีอดเพิ่มเติม')),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Expanded(
          //   child: ListView(
          //     children: tripGetResponse
          //         .map((trip) => Card(
          //               child: Text(trip.name),
          //             ))
          //         .toList(),
          //   ),
          // ),

          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  // เปลี่ยนเป็น FuturBuildder
                  future: loadData, // เพิ่ม future: และ loadData
                  builder: (context, snapshot) {
                    //เพิ่ม  snapshot มา ในวงเล็บ builder

                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      ); // โค้ด เวลาดีเลย์
                    }
                    return Column(
                      children: tripGetResponses
                          .map((trip) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Color.fromARGB(255, 237, 251, 254),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trip.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Image.network(
                                              trip.coverimage,
                                              width: 150,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Center(
                                                  child: Text(
                                                    'Cannot load image',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 39, 38, 38),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 5.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("ประเทศ${trip.country}"),
                                                Text(
                                                    "ระยะเวลา ${trip.duration} วัน"),
                                                Text("ราคา ${trip.price} บาท"),
                                                FilledButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TripPage(
                                                                    idx: trip
                                                                        .idx),
                                                          ));
                                                    },
                                                    child: const Text(
                                                        'รายละเอียดเพิ่มเติม')),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  void getTrips(String? zone) async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripsGetResponseFromJson(res.body);
      List<TripsGetResponses> filteredTrip = [];

      if (zone != null) {
        for (var trip in tripGetResponses) {
          if (trip.destinationZone == zone) {
            filteredTrip.add(trip);
          }
        }
        tripGetResponses = filteredTrip;
      }

      setState(() {});
    });
    log(tripGetResponses.length.toString());
  }

// asyne load data
  Future<void> loadDataAsync() async {
//  Configguration.getConfig().then(
//       (value) {
//         log(value['apiEndpoint']);
//         url = value['apiEndpoint'];
//         // getTrips(); จะใช้อีกวิธีในการโหลดข้อมูล
//       },
//     ).catchError((err) {
//       log(err.toString());
//     });
    await Future.delayed(const Duration(seconds: 2));
    var config = await Configguration
        .getConfig(); //สร้าง  ตัวแปร config มาเก็บ Configguration และใส่ await

    url = config['apiEndpoint'];

    var data = await http.get(Uri.parse('$API_ENDPOINT/trips'));
    log(data.body); // แสดงข้อมูล ไม่ใส่ก็ได้

    tripGetResponses = tripsGetResponseFromJson(data.body);

    log(tripGetResponses.length.toString()); // แสดงข้อมูล ไม่ใส่ก็ได้
  }
}

gotoTrippage(int idx) {}
