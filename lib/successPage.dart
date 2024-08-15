import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SuccessPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneNumberController;
  final TextEditingController smsCodeController;


  SuccessPage({required this.phoneNumberController, required this.smsCodeController});

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      phoneNumberController.clear();
      smsCodeController.clear();
      Navigator.pop(context); // 현재 페이지 닫기
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('로그인 성공', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout,
            color: Colors.white),
            onPressed: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('로그인에 성공했습니다!'),
      ),
    );
  }
}
