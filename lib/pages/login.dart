//import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/models/request/customer_login_post_req.dart';
import 'package:flutter_application_1/models/response/CustomerLoginPostRes.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = "";
  int x = 0;
  // String phoneNo = "1234";
  // String pessword = "123";
  // TextEditingController phoneNoCtl = TextEditingController();
  // TextEditingController pesswordCt1 = TextEditingController();

  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  // Initstate ทำงานเมื่อเปิดหน้านี้
  // 1.initsate จะทำงานครั้งเดียวเมื่อเปิดหน้านี้
  // 2.มันจะไม่ทำงานเมื่อเรียก setState
  // 3.qมันไม่สามารถทำงานเป็น asnync function ได้
  String url = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Configguration config = Configguration();

    Configguration.getConfig().then(
      (value) {
        log(value['apiEndpoint']);
        setState(() {
          url = value['apiEndpoint'];
        });
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
              onDoubleTap: () {
                log("image double tap");
              },
              child: Image.asset('assets/images/logo.png')),
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'หมายเลขโทรศัพท์',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: phoneNoCtl,
                        // onChanged: (value) {
                        //  phoneNo = value;
                        // },
                        keyboardType: TextInputType.phone,

                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      )
                    ],
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'รหัสผ่าน',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: passwordCtl,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1))),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      register();
                    },
                    child: const Text('ลงทะเบียนใหม่')),
                FilledButton(onPressed: login, child: const Text('เข้าสู้ระบบ'))
              ],
            ),
          ),
          Text(text),
        ]),
      ),
    );
  }

//   void login() {
//     log("this is login button");
//     x++;
//     text = 'login time: $x';
//     setState(() {});
//   }

//   void register() {
//     // log("this is register");
//     // text = 'rgister naa';

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const RegisterPage(),
//         ));
//   }
// }

  void login() {
    // log(phoneNoCtl.text);
    // log(pesswordCt1.text);

    // if (phoneNo == phoneNoCtl.text && pessword == pesswordCt1.text) {
    //   log("รหัสผ่านถูกต้ม");
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const ShowTripPage(),
    //       ));
    // } else {
    //   log("รหัสผ่านไม่ถูกต้ม");
    // }

    // http.get(Uri.parse("http://192.168.45.158:3000/customers/login")).then(
    //   (value) {
    //     log(value.body);
    //   },
    // ).catchError((error) {
    //   log('Error $error');
    // });

    // call login api

    // var data = {"phone": "0817399999", "password": "1111"};

    //var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phoneNoCtl.text, password: passwordCtl.text);
    http
        .post(Uri.parse("$API_ENDPOINT/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req))
        .then((value) {
      log(value.body);
      CustomerLoginPostResponse customerLoginPostResponse =
          customerLoginPostResponseFromJson(value.body);
      log(customerLoginPostResponse.customer.fullname);
      log(customerLoginPostResponse.customer.email);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowTripPage(
              idx: customerLoginPostResponse.customer.idx,
            ),
          ));
    }).catchError((error) {
      log('Error $error');
    });
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }
}
