import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/models/response/customer_idx_res.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  late Future<void> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;

  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> loadData;
  late CustomerIdxGetResponse customer;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    log('Customer id: ${widget.idx}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ปิด')),
                          FilledButton(
                              onPressed: delete, child: const Text('ยืนยัน'))
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            fullnameCtl.text = customer.fullname;
            phoneCtl.text = customer.phone;
            emailCtl.text = customer.email;
            imageCtl.text = customer.image;
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Image.network(customer.image),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ชื่อ-สกุล'),
                          TextField(
                            controller: fullnameCtl,
                          ),
                          const Text('หมายเลขโทรศัพท์'),
                          TextField(
                            controller: phoneCtl,
                          ),
                          const Text('อีเมล'),
                          TextField(
                            controller: emailCtl,
                          ),
                          const Text('image'),
                          TextField(
                            controller: imageCtl,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: FilledButton(
                                    onPressed: update,
                                    child: const Text('บันทึกข้อมูล')),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> loadDataAsync() async {
    //var config = await Configguration.getConfig();
    //var url = config['apiEndpoint'];
    var res =
        await http.get(Uri.parse('$API_ENDPOINT/customers/${widget.idx}'));
    log(res.body);
    customer = customerIdxGetResponseFromJson(res.body);
  }

  // Future<void> loadDataAsync() async {
  //   var config = await Configguration.getConfig();
  //   var url = config['apiEndpoint'];
  //   var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
  //   log(res.body);
  //   customerIdxGetResponse = customerIdxGetResponseFromJson(res.body);
  //   log(jsonEncode(customerIdxGetResponse));
  //   nameCt.text = customerIdxGetResponse.fullname;
  //   phoneCtl.text = customerIdxGetResponse.phone;
  //   emailCtl.text = customerIdxGetResponse.email;
  //   imageCtl.text = customerIdxGetResponse.image;
  // }
  void update() async {
    //var config = await Configguration.getConfig();
    //var url = config['apiEndpoint'];

    var json = {
      "fullname": fullnameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text
    };
    // Not using the model, use jsonEncode() and jsonDecode()
    try {
      var res = await http.put(
          Uri.parse('$API_ENDPOINT/customers/${widget.idx}'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(json));
      log(res.body);
      var result = jsonDecode(res.body);
      // Need to know json's property by reading from API Tester
      log(result['message']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + err.toString()),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }

  void delete() async {
    var config = await Configguration.getConfig();
    var url = config['apiEndpoint'];

    var res =
        await http.delete(Uri.parse('$API_ENDPOINT/customers/${widget.idx}'));
    log(res.statusCode.toString());

    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text('ปิด'))
          ],
        ),
      ).then((s) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }
}
