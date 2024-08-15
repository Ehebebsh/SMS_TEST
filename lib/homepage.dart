import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_test/successPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'firebase auth sms 인증 예제 ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: '휴대폰 번호'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _verifyPhoneNumber();
                },
                child: Text('인증번호 발송'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _smsCodeController,
                decoration: InputDecoration(labelText: 'SMS 코드'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _signInWithPhoneNumber(context);
                },
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
        print('인증 실패');
    };

    PhoneCodeSent codeSent =
        (String verificationId, int? resendToken) {
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
    }
  }

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCodeController.text,
      );
      await _auth.signInWithCredential(credential);


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SuccessPage(
                phoneNumberController: _phoneNumberController,
                smsCodeController: _smsCodeController,
              ),
        ),
      );
    } catch (e) {
      print('에러발생');
    }
  }
}
