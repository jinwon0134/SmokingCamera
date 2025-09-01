import 'package:flutter/material.dart';

class CalendarBottomSheet {
  static void show(BuildContext context, Function(DateTime) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Text('날짜 선택', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    onSelected(date);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
