import 'package:aa/Page/Login.page/find_idpassword_page.dart';
import 'package:aa/Page/Login.page/find_password_page.dart';
import 'package:aa/Page/main_page.dart';
import 'package:aa/Page/Login.page/register_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  Future<void> login() async {
    if (idController.text.isEmpty || pwController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("아이디와 비밀번호를 입력해주세요")));
      return;
    }

    final url = Uri.parse(
      'http://localhost:8080/api/login',
    ); // Spring Boot 로그인 API
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": idController.text,
          "password": pwController.text,
        }),
      );

      if (response.statusCode == 200) {
        // 로그인 성공 → MainPage 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("로그인 실패: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("서버 연결 실패: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              width: 330,
              child: Column(
                children: [
                  // 아이디 입력
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFBFBFBF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "아이디",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 비밀번호 입력
                  Container(
                    width: 400,
                    height: 50,
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
                        hintText: "비밀번호",
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 로그인 버튼
                  Container(
                    width: 400,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: login, // 서버 연동 함수
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('로그인'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 아이디/비밀번호 찾기 + 회원가입 링크
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FindIdPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '아이디 찾기',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7A7A7A)),
                  ),
                ),
                Text(" | ", style: const TextStyle(color: Color(0xFF636161))),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FindIdPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7A7A7A)),
                  ),
                ),
                Text(" | ", style: const TextStyle(color: Color(0xFF636161))),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7A7A7A)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
