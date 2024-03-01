import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:memo_app/Notes/notes.dart';
import 'package:memo_app/settings/cus_drawer.dart';
import 'package:memo_app/settings/settings.dart';
import 'package:memo_app/settings/tasks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Locales.init(['en', 'fa']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        title: 'Memo App',
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List screens = [
    const Tasks(),
    const AllNotes(),
    //const Transactions(),
    const Settings(),
  ];
  List items = ["Tasks", "Notes", "Setting"];
  int currentIndex = 0;
  List<IconData> icons = const [
    Icons.task_alt_rounded,
    Icons.event_note_sharp,
    Icons.account_balance,
    Icons.settings
  ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(.25),
        ),
        margin: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * .9,
        height: 80,
        child: Center(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: Container(
                width: 90,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentIndex == index
                      ? Colors.deepPurple.withOpacity(.6)
                      : Colors.transparent,
                ),
                child: SizedBox(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          icons[index],
                          color: currentIndex == index
                              ? Colors.white
                              : Colors.black45,
                          size: currentIndex == index ? 26 : 22,
                        ),
                        LocaleText(
                          items[index],
                          style: TextStyle(
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.black45,
                              fontWeight: currentIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
