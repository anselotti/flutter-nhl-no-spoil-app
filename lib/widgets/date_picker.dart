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
      initialDate: _selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selected != null && selected != _selectedDate) {
      setState(() => _selectedDate = selected);
    }

    if (_selectedDate != null) {
      widget.onDateSelected(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: _previousDate, icon: const Icon(Icons.arrow_back)),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(DateFormat('dd.MM.yyyy').format(_selectedDate!)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
          IconButton(
              onPressed: _nextDate, icon: const Icon(Icons.arrow_forward)),
        ],
      ),
    );
  }

  void _previousDate() {
    setState(() {
      _selectedDate = _selectedDate!.subtract(const Duration(days: 1));
    });
    widget.onDateSelected(_selectedDate!);
  }

  void _nextDate() {
    setState(() {
      _selectedDate = _selectedDate!.add(const Duration(days: 1));
    });
    widget.onDateSelected(_selectedDate!);
  }
}
