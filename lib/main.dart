import 'dart:io';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_1/widgets/list_value_notifier.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.mandyRed,
          appBarBackground: (Colors.grey[850]),
        ),
        themeMode: ThemeMode.system,
        home: const MyHome(),
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  ListValueNotifier<List<bool>> buttonsClicked =
      ListValueNotifier<List<bool>>([]);

  // List<bool> buttonsC = [];

  void changeButtonState(int index) {
    // setState(() {
    buttonsClicked.value[index] = !buttonsClicked.value[index];
    buttonsClicked.notifyListeners();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: const Text("title"),
                  subtitle: const Text("subtitle"),
                  leading: CircleAvatar(
                    child: Text((index + 1).toString()),
                  ),
                  trailing: ListenableBuilder(
                    listenable: buttonsClicked,
                    builder: (context, snapshot) {
                      if (buttonsClicked.value.isEmpty) {
                        buttonsClicked.value = List.filled(5, false);
                      }
                      return IconButton(
                        onPressed: () {
                          changeButtonState(index);
                        },
                        // icon: const Icon(Icons.check_box_outline_blank));
                        icon: (buttonsClicked.value[index] == false)
                            ? const Icon(Icons.check_box_outline_blank)
                            : const Icon(Icons.check_box),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
