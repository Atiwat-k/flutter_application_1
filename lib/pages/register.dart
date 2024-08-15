import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/models/request/customerregisterPostRes.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController image = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

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

  String imsge = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text("ชื่อ-นมสกุล"),
                ],
              ),
              TextField(
                controller: fullname,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("หมายเลขโทรศัพท์"),
                  ),
                ],
              ),
              TextField(
                controller: phone,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("อีเมล์"),
                  ),
                ],
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("รหัสผ่าน"),
                  ),
                ],
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("ยืนยันรหัสผ่าน"),
                  ),
                ],
              ),
              TextField(
                controller: confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FilledButton(
                    onPressed: () {
                      register();
                    },
                    child: const Text('สมัครสมาชิก')),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text('หากมีบัญชีอยู่แล้ว?')),
                    TextButton(
                        onPressed: () {}, child: const Text('เข้าสู่ระบบ')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    if (password.text == "" || confirmPassword.text == "") {
      log('Password or confirm password field is null');
      // Optionally show a snackbar or dialog to inform the user
      return;
    }

    if (password.text != confirmPassword.text) {
      log('Passwords do not match');
      // Optionally show a snackbar or dialog to inform the user
      return;
    }

// Proceed with further processing, e.g., user registration

    CustomerregisterPostRes req = CustomerregisterPostRes(
      fullname: fullname.text,
      phone: phone.text,
      email: email.text,
      image: image.text,
      password: password.text,
    );

    var response = await http.post(
      Uri.parse("$API_ENDPOINT/customers/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(req.toJson()),
    );

    if (response.statusCode == 200) {
      log('Registration successful');
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    } else {
      log('Registration failed');
      // Optionally show an error message
    }
  }
}
