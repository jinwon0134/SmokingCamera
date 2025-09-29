import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool agreePrivacy = false;
  bool agreeTerms = false;
  bool isEmailVerified = false;
  bool codeSent = false;

  // 이메일 인증번호 전송
  Future<void> sendEmailCode() async {
    if (emailController.text.isEmpty) return;

    final url = Uri.parse(
      'http://<SERVER_IP>:8080/api/sendEmailCode',
    ); // 서버 IP 변경
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": emailController.text}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("인증 코드가 이메일로 전송되었습니다.")));
      setState(() => codeSent = true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("메일 전송 실패: ${response.body}")));
    }
  }

  // 이메일 인증번호 확인
  Future<void> verifyEmailCode() async {
    if (codeController.text.isEmpty) return;

    final url = Uri.parse(
      'http://<SERVER_IP>:8080/api/verifyEmailCode',
    ); // 서버 IP 변경
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text,
        "code": codeController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("이메일 인증 완료!")));
      setState(() => isEmailVerified = true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("인증 실패: ${response.body}")));
      setState(() => isEmailVerified = false);
    }
  }

  // 회원가입
  Future<void> register() async {
    if (!isEmailVerified) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("이메일 인증이 필요합니다.")));
      return;
    }
    if (!agreePrivacy || !agreeTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("약관에 모두 동의해야 합니다.")));
      return;
    }

    final url = Uri.parse('http://<SERVER_IP>:8080/api/register'); // 서버 IP 변경
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text,
        "password": pwController.text,
        "phone": phoneController.text,
        "age": ageController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("회원가입 완료! 로그인 해주세요.")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("회원가입 실패: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: Border(bottom: BorderSide(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                width: 330,
                child: Column(
                  children: [
                    // 이메일
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "이메일 입력",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 인증번호 입력
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFBFBFBF)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "인증번호 입력",
                              ),
                              onSubmitted: (_) => verifyEmailCode(),
                              onChanged: (value) {
                                if (value.length == 6) verifyEmailCode();
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: sendEmailCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            codeSent ? "재전송" : "인증번호 전송",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 비밀번호
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "비밀번호 입력",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 전화번호
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "휴대전화번호 입력",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 나이
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "나이 입력",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    const SizedBox(height: 20),
                    // 체크박스
                    Row(
                      children: [
                        Checkbox(
                          value: agreePrivacy,
                          onChanged: (val) {
                            setState(() => agreePrivacy = val ?? false);
                          },
                        ),
                        Text("개인정보 수집에 동의합니다."),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: agreeTerms,
                          onChanged: (val) {
                            setState(() => agreeTerms = val ?? false);
                          },
                        ),
                        Text("이용약관에 동의합니다."),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // 회원가입 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("회원가입 완료"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
