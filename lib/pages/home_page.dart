import 'package:flutter/material.dart';

import '../widgets/list_value_notifier.dart';

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
