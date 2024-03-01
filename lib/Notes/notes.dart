import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import '../../sqlite.dart';
import 'create_note.dart';
import 'note_details.dart';
import 'note_model.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final searchCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String keyword = "";

  late DatabaseHelper handler;
  late Future<List<Notes>> notes;
  final db = DatabaseHelper();

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

  var filterTitle = ["All", "Work", "Payment", "Received", "Meeting"];
  var filterData = ["%", "Work", "Payment", "Received", "Meeting"];
  int currentFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateNote()));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Filter buttons
            SizedBox(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filterTitle.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: currentFilterIndex == index
                            ? Colors.deepPurple.withOpacity(.1)
                            : Colors.transparent,
                      ),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              currentFilterIndex = index;
                              notes =
                                  db.filterMemo(filterData[currentFilterIndex]);
                            });
                          },
                          child: LocaleText(filterTitle[index])),
                    );
                  }),
            ),

            //Search TextField
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8)),
              child: TextFormField(
                controller: searchCtrl,
                onChanged: (value) {
                  setState(() {
                    keyword = searchCtrl.text;
                    notes = db.searchMemo(keyword);
                  });
                },
                decoration: InputDecoration(
                    hintText: Locales.string(context, "Search"),
                    icon: const Icon(Icons.search),
                    border: InputBorder.none),
              ),
            ),

            //Notes to show
            Expanded(
              child: SafeArea(
                child: FutureBuilder<List<Notes>>(
                  future: notes,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Notes>> snapshot) {
                    //in case whether data is pending
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        //To show a circular progress indicator
                        child: CircularProgressIndicator(),
                      );
                      //If snapshot has error
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/photos/empty.png.png", width: 250),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      //a final variable (item) to hold the snapshot data
                      final items = snapshot.data ?? <Notes>[];
                      return Scrollbar(
                        //The refresh indicator
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              final dt = DateTime.parse(
                                  items[index].createdAt.toString());
                              final noteDate =
                                  DateFormat('yyyy-MM-dd (HH:mm a)').format(dt);
                              //Dismissible widget is to delete a data on pushing a record from left to right
                              return Dismissible(
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade900,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      LocaleText(
                                        "delete",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                key: ValueKey<int>(items[index].noteId!),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  await handler
                                      .deleteNote(
                                          items[index].noteId.toString())
                                      .whenComplete(
                                        () => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 900),
                                            content: const LocaleText(
                                              "deletemsg",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      );
                                  setState(() {
                                    items.remove(items[index]);
                                    _onRefresh();
                                  });
                                },
                                child: InkWell(
                                  onTap: () {
                                    //To hold the data in text fields for update method
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteDetails(
                                          details: items[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    padding: const EdgeInsets.all(8),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: items[index].noteStatus == 1
                                            ? Colors.deepPurple.withOpacity(.6)
                                            : Colors.green,
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 1, color: Colors.grey)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              items[index].noteTitle,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors.white),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                    child: LocaleText(
                                                      items[index].category!,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.deepPurple,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 13.0),
                                            child: Text(
                                              items[index].noteContent,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(noteDate,
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (5 / 3),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
