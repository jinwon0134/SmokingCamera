import 'package:flutter/material.dart';

class UserInfo {
  final DateTime smokingStartDate;
  final DateTime quitStartDate;
  final int avgCigsPerDay;

  UserInfo({
    required this.smokingStartDate,
    required this.quitStartDate,
    required this.avgCigsPerDay,
  });
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DateTime? _smokingStartDate;
  DateTime? _quitStartDate;
  final TextEditingController _avgController = TextEditingController();
  bool _isEditing = false; // Listener 중복 방지
  final String unit = '개비/일';

  @override
  void initState() {
    super.initState();

    _avgController.addListener(() {
      if (_isEditing) return;
      _isEditing = true;

      String text = _avgController.text;

      // 숫자만 남기기
      String numeric = text.replaceAll(RegExp(r'[^0-9]'), '');

      // 숫자가 있으면 단위 붙임, 없으면 빈 문자열
      String newText = numeric.isEmpty ? '' : '$numeric$unit';

      // 커서 위치 숫자 끝으로
      _avgController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: numeric.length),
      );

      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _avgController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
    BuildContext context,
    DateTime? initial,
    ValueChanged<DateTime> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) onPicked(picked);
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return 'xxxx년 xx월 xx일';
    return '${d.year}년 ${d.month}월 ${d.day}일';
  }

  void _saveAndReturn() {
    final avgText = _avgController.text.replaceAll(unit, '').trim();
    final avg = int.tryParse(avgText);
    if (_smokingStartDate == null || _quitStartDate == null || avg == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 항목을 정확히 입력해 주세요')));
      return;
    }
    if (_quitStartDate!.isBefore(_smokingStartDate!)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('금연 시작일이 흡연 시작일보다 빠릅니다')));
      return;
    }

    final info = UserInfo(
      smokingStartDate: _smokingStartDate!,
      quitStartDate: _quitStartDate!,
      avgCigsPerDay: avg,
    );
    Navigator.pop(context, info);
  }

  void _restartQuit() {
    setState(() {
      _quitStartDate = DateTime.now();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('금연 시작일이 오늘로 초기화되었습니다')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("흡연 시작일", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _pickDate(
                context,
                _smokingStartDate,
                (d) => setState(() => _smokingStartDate = d),
              ),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_fmtDate(_smokingStartDate)),
              ),
            ),
            const SizedBox(height: 25),
            Text("금연 시작일", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _pickDate(
                context,
                _quitStartDate,
                (d) => setState(() => _quitStartDate = d),
              ),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_fmtDate(_quitStartDate)),
              ),
            ),
            const SizedBox(height: 30),
            Text("평균 흡연량", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextFormField(
              controller: _avgController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: '예) xx 개비/일',
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _restartQuit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  '금연 재시작',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndReturn,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
