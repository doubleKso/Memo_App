import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../sqlite.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  var items = ["Notes", "Work", "Payment", "Meeting", "Received"];

  int? totalNotes;
  int? totalWorks;
  int? totalPayments;
  int? totalReceived;
  int? totalMeetings;

  int currentIndex = 0;
  late DatabaseHelper handler;
  final db = DatabaseHelper();
  //Total Users count

  Future<int?> total() async {
    int? count = await handler.totalNotes();
    setState(() => totalNotes = count!);
    return totalNotes;
  }

  Future<int?> totalWork() async {
    int? count = await handler.totalCategory();
    setState(() => totalWorks = count!);
    return totalWorks;
  }

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    total();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("Task"),
      ),
      body: const Scaffold(
        body: Center(
          child: Text("Coming Soon..."),
        ),
      ),
    );
  }
}
