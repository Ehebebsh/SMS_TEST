# 📲 Firebase SMS 인증 Flutter 앱

이 프로젝트는 **firebase_auth** 패키지를 사용하여 SMS 인증 기능을 구현한 Flutter 앱이다. 이 앱은 사용자가 전화번호를 입력하면 Firebase를 통해 SMS 인증 코드를 받아 인증하는 기능을 제공한다.

## 🛠️ 1. 실행 과정

### 1.1 패키지 설치
<details>
<summary>필수 패키지 설치</summary>
<div markdown="1">

SMS 인증을 구현하기 위해 **firebase_auth**와 **firebase_core** 패키지를 사용한다. 아래 링크를 통해 패키지를 설치할 수 있다:

- **패키지 링크**: [firebase_auth](https://pub.dev/packages/firebase_auth)

```yaml
dependencies:
  firebase_core: latest_version
  firebase_auth: latest_version
```
</div> </details>

### 1.2 Firebase 설정
<details> <summary>Firebase 설정 및 연동</summary> <div markdown="1">
Firebase 프로젝트 생성: Firebase 콘솔에서 새 프로젝트를 생성한다.
앱에 Firebase 추가: 프로젝트에 Android 및 iOS 앱을 추가하고, google-services.json(Android) 또는 GoogleService-Info.plist(iOS)를 다운로드하여 프로젝트에 포함시킨다.
Firebase 초기화: Flutter 앱에서 Firebase를 초기화해야 한다.
  
```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```
</div> </details>

### 1.3 SMS 인증 기능 구현
<details> <summary>SMS 인증 구현 예제 코드</summary> <div markdown="1">
아래 코드는 사용자가 전화번호를 입력하고, 인증 코드를 받아 Firebase 인증을 완료하는 방법을 보여준다.

```dart
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
```
</div> </details>

### 1.4 Firebase 콘솔 설정
  **참고 블로그**: [블로그](https://velog.io/@gwi060722/Firebase-auth-sms%EC%9D%B8%EC%A6%9D-%EB%B0%A9%EB%B2%95)
</div> </details>
