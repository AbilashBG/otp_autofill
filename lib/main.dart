import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  @override
  void initState() {
    super.initState();
    initialFunctions();
  }

  void initialFunctions() {
    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
          (code) {
        print("otp dataa ${code}");
        int oneDot = code?.indexOf(".") ?? 0;
        int twoDot = code?.lastIndexOf(".") ?? 0;

        var finalotp = "${code?.substring(oneDot + 1, twoDot)}";
        print("$oneDot $twoDot ${code?.substring(oneDot + 1, twoDot)}");
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        // SampleStrategy(),
      ],
    );
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    final appSignature = await _otpInteractor.getAppSignature();

    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }

  @override
  void dispose() {
    controller.stopListen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: controller,
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              controller.clear();
              initialFunctions();
              setState(() {});
            }, child: Text("Resend Otp"),),
          ],
        ),
      ),
    );
  }
}

class SampleStrategy extends OTPStrategy {
  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 543212',
    );
  }
}
