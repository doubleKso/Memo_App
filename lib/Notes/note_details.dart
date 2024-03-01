import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:memo_app/Notes/note_model.dart';
import 'package:memo_app/widgets/dropdown.dart';
import 'package:memo_app/widgets/textfield.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../sqlite.dart';

class NoteDetails extends StatefulWidget {
  final Notes? details;
  const NoteDetails({super.key, this.details});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final db = DatabaseHelper();
  bool isUpdate = false;
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  var dropValue = 0;

  late DatabaseHelper handler;
  late Future<List<Notes>> notes;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    notes = handler.getNotes();
    handler.initDB().whenComplete(() async {
      setState(() {
        notes = getList();
      });
    });
  }

  //Method to get data from database
  Future<List<Notes>> getList() async {
    return await handler.getNotes();
  }

  //Method to refresh data on pulling the list
  Future<void> _onRefresh() async {
    setState(() {
      notes = getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.parse(widget.details!.createdAt.toString());

    //Gregorian Date format
    final gregorianDate = DateFormat('yyyy/MM/dd - HH:mm a').format(dt);
    Jalali persianDate = dt.toJalali();

    //Persian Date format
    String shamsiDate() {
      final f = persianDate.formatter;
      return '${f.yyyy}/${f.mm}/${f.dd}';
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          isUpdate
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isUpdate = !isUpdate;
                        db.updateNotes(Notes(
                            noteTitle: titleCtrl.text,
                            noteContent: contentCtrl.text,
                            category: dropValue == 0
                                ? "Work"
                                : dropValue == 1
                                    ? "Payment"
                                    : dropValue == 2
                                        ? "Received"
                                        : dropValue == 3
                                            ? "Meeting"
                                            : "Others",
                            noteId: widget.details!.noteId));
                      });
                    },
                    icon: const Icon(
                      Icons.check,
                      size: 18,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isUpdate = !isUpdate;
                        titleCtrl.text = widget.details!.noteTitle;
                        contentCtrl.text = widget.details!.noteContent;
                        _onRefresh();
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                    ),
                  ),
                ),
        ],
        title: Text(widget.details!.noteTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: LocaleText(
                "Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              dense: true,
              title: Container(
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.3)),
                child: Text(
                  gregorianDate,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              subtitle: Text(
                shamsiDate(),
                style: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: LocaleText(
                    "Category",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                isUpdate
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: CustDropDown(
                          defaultSelectedIndex: widget.details?.category ==
                                  "Work"
                              ? 0
                              : widget.details?.category == "Payment"
                                  ? 1
                                  : widget.details?.category == "Received"
                                      ? 2
                                      : widget.details?.category == "Meeting"
                                          ? 3
                                          : 0,
                          items: const [
                            CustDropdownMenuItem(
                              value: 0,
                              child: LocaleText("Work"),
                            ),
                            CustDropdownMenuItem(
                              value: 1,
                              child: LocaleText("Payment"),
                            ),
                            CustDropdownMenuItem(
                              value: 2,
                              child: LocaleText("Received"),
                            ),
                            CustDropdownMenuItem(
                              value: 3,
                              child: LocaleText("Meeting"),
                            ),
                          ],
                          hintText: Locales.string(context, "Category"),
                          borderRadius: 5,
                          onChanged: (val) {
                            setState(() {
                              dropValue = val;
                            });
                          },
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        height: 40,
                        width: MediaQuery.of(context).size.width * .95,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.purple.withOpacity(.2)),
                        child: LocaleText(
                          widget.details!.category ?? "",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
              ],
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              visualDensity: const VisualDensity(vertical: -4),
              dense: true,
              title: const LocaleText(
                "Title",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: isUpdate
                  ? UnderlineInputField(hint: "title", controller: titleCtrl)
                  : Text(
                      widget.details!.noteTitle,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
              trailing: Container(
                width: 35,
                decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: () {
                      db.deleteNote(widget.details!.noteId.toString());
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  dense: true,
                  title: const LocaleText(
                    "Content",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  subtitle: isUpdate
                      ? UnderlineInputField(
                          hint: "content", controller: contentCtrl)
                      : Text(
                          widget.details!.noteContent,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black38),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
