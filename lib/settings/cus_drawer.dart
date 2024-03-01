import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:memo_app/Notes/trash.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List icons = [Icons.account_circle, Icons.delete_rounded, Icons.color_lens];

  List items = [
    "Profile",
    "Trash",
    "Themes",
  ];
  List pages = [
    const Trash(),
    const Trash(),
    const Trash(),
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerTheme:
                      const DividerThemeData(color: Colors.transparent),
                ),
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Photos/todo_bg.jpg"))),
                  child: Text("Memo"),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pages[index]));
                      },
                      leading: Icon(icons[index]),
                      title: LocaleText(items[index]),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
