import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("Setting"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Language tile
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple.withOpacity(.6),
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: Colors.grey)
                    ]),
                child: ListTile(
                  leading: const Icon(
                    Icons.language,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: const LocaleText(
                    "Language",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  subtitle: LocaleText(context.currentLocale.toString(),
                      style: const TextStyle(color: Colors.white)),
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -2),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 1),
                            title: const LocaleText("Language"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Locales.change(context, 'kha');
                                    Navigator.pop(context);
                                  },
                                  title: const Text("THAI"),
                                  leading: const Icon(Icons.language),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 14,
                                  ),
                                ),
                                ListTile(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Locales.change(context, 'en');
                                    Navigator.pop(context);
                                  },
                                  title: const Text("English"),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 14,
                                  ),
                                  leading: const Icon(Icons.language),
                                ),
                              ],
                            ),
                          )),
                  contentPadding: const EdgeInsets.all(8.0),
                  trailing: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
              //Themes tile
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple.withOpacity(.6),
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: Colors.grey)
                    ]),
                child: ListTile(
                  leading: const Icon(
                    Icons.color_lens,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: const LocaleText(
                    "themes",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  subtitle: const LocaleText("themesdetails",
                      style: TextStyle(color: Colors.white)),
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -2),
                  contentPadding: const EdgeInsets.all(8.0),
                  trailing: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
              //Account
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple.withOpacity(.6),
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: Colors.grey)
                    ]),
                child: ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: const LocaleText(
                    "accounts",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  subtitle: const LocaleText("accdetails",
                      style: TextStyle(color: Colors.white)),
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -2),
                  contentPadding: const EdgeInsets.all(8.0),
                  trailing: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
