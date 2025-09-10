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

  @override
  void dispose() {
    _avgController.dispose();
    super.dispose();
  }

  void _saveAndReturn() {
    final avgText = _avgController.text.trim();
    final avg = int.tryParse(avgText);
    if (_smokingStartDate == null || _quitStartDate == null || avg == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 항목을 정확히 입력해 주세요')));
      return;
    }
    // 간단 검사: 금연 시작일은 흡연 시작일 이후 또는 같은 날이어야 함
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
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('금연정보입력', style: TextStyle(color: Colors.grey[600])),
            ),
            const SizedBox(height: 12),
            // 흡연 시작일
            InkWell(
              onTap: () => _pickDate(
                context,
                _smokingStartDate,
                (d) => setState(() => _smokingStartDate = d),
              ),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '흡연 시작일',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_fmtDate(_smokingStartDate)),
              ),
            ),
            const SizedBox(height: 12),
            // 금연 시작일
            InkWell(
              onTap: () => _pickDate(
                context,
                _quitStartDate,
                (d) => setState(() => _quitStartDate = d),
              ),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '금연 시작일',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_fmtDate(_quitStartDate)),
              ),
            ),
            const SizedBox(height: 12),
            // 평균 흡연량
            TextFormField(
              controller: _avgController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '평균 흡연량 (개비/일)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: '예) 20',
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('수정하기', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
