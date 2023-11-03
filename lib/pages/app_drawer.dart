import 'package:flutter/material.dart';
import 'package:flutter_api_1/pages/home_page.dart';
import 'package:flutter_api_1/pages/scroll_version.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                Spacer(),
                Text(
                  "Api App",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "With Space News",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const MyHome();
                },
              ));
            },
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text(
              'Page Version',
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ScrollHome();
                },
              ));
            },
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text(
              'Infinite Scroll Version',
            ),
          ),
        ],
      ),
    );
  }
}
