import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, required this.onDateSelected});

  final ValueChanged<DateTime> onDateSelected;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selected != null && selected != _selectedDate) {
      setState(() => _selectedDate = selected);
    }

    if (_selectedDate != null) {
      widget.onDateSelected(_selectedDate!); // Käytä non-null-arvoa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(DateFormat('dd.MM.yyyy').format(_selectedDate!)),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}