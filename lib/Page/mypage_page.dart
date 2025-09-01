import 'package:aa/Page/main_page.dart';
import 'package:aa/Widget/calendar_bottomsheet.dart';
import 'package:flutter/material.dart';

class MyPagePage extends StatefulWidget {
  const MyPagePage({super.key});

  @override
  State<MyPagePage> createState() => _MyPagePageState();
}

class _MyPagePageState extends State<MyPagePage> {
  final TextEditingController _smokingStartController = TextEditingController();
  final TextEditingController _quittingStartController =
      TextEditingController();
  final TextEditingController _smokeAmountController = TextEditingController();

  @override
  void dispose() {
    _smokingStartController.dispose();
    _quittingStartController.dispose();
    _smokeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "흡연 시작일",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _smokingStartController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ex) xxxx년 xx월 xx일",
                        ),
                        onTap: () {
                          CalendarBottomSheet.show(context, (selectedDate) {
                            setState(() {
                              _smokingStartController.text =
                                  "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일";
                            });
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "금연 시작일",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _quittingStartController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ex) xxxx년 xx월 xx일",
                        ),
                        onTap: () {
                          CalendarBottomSheet.show(context, (selectedDate) {
                            setState(() {
                              _quittingStartController.text =
                                  "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일";
                            });
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "평균 흡연량",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBFBFBF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _smokeAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ex) xx 개비",
                        ),
                        onChanged: (value) {
                          final number = value.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          if (number.isNotEmpty) {
                            _smokeAmountController.value = TextEditingValue(
                              text: "$number개비",
                              selection: TextSelection.collapsed(
                                offset: number.length,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 100),
                    Container(
                      width: 400,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          print("흡연 시작일: ${_smokingStartController.text}");
                          print("금연 시작일: ${_quittingStartController.text}");
                          print("평균 흡연량: ${_smokeAmountController.text}");

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('수정하기'),
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
