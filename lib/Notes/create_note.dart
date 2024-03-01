import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:memo_app/main.dart';
import 'package:memo_app/widgets/dropdown.dart';
import 'package:memo_app/widgets/textfield.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../sqlite.dart';
import 'note_model.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  var dropValue = 0;
  @override
  Widget build(BuildContext context) {
    final dt = DateTime.now();

    //Gregorian Date format
    final gregorianDate = DateFormat('yyyy-MM-dd (HH:mm a)').format(dt);
    Jalali persianDate = dt.toJalali();

    //Persian Date format
    String shamsiDate() {
      final f = persianDate.formatter;
      return '${f.yyyy}/${f.mm}/${f.dd}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("create_note"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          gregorianDate,
                          style: const TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(shamsiDate()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: CustDropDown(
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                UnderlineInputField(
                  hint: "title",
                  controller: titleCtrl,
                ),
                IntrinsicHeight(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 250,
                      maxHeight: 500,
                    ),
                    child: UnderlineInputField(
                      hint: "content",
                      controller: contentCtrl,
                      maxChar: 500,
                      max: null,
                      expand: true,
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const LocaleText("Cancel")),
                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            db
                                .createNote(
                                  Notes(
                                    noteTitle: titleCtrl.text,
                                    noteContent: contentCtrl.text,
                                    category: dropValue == 0
                                        ? "work"
                                        : dropValue == 1
                                            ? "payment"
                                            : dropValue == 2
                                                ? "received"
                                                : dropValue == 3
                                                    ? "meeting"
                                                    : "other",
                                  ),
                                )
                                .whenComplete(() => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyHomePage())));
                          }
                        },
                        child: const LocaleText("create")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
