import 'package:flutter/material.dart';

import '../widgets/list_value_notifier.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool tilePressed = false;

  // List<bool> buttonsClicked = [];
  ListValueNotifier<List<bool>> tileClicked = ListValueNotifier<List<bool>>([]);

  void changeListTileState(int index) {
    tileClicked.value[index] = !tileClicked.value[index];
    tileClicked.notifyListeners();
  }

  @override
  void dispose() {
    tileClicked.dispose();
    super.dispose();
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
                // Fill only when its empty otherwise there is null error
                if (tileClicked.value.isEmpty) {
                  tileClicked.value = List.filled(5, false);
                }
                return ListenableBuilder(
                  listenable: tileClicked,
                  builder: (context, snapshot) {
                    return ListTile(
                      selected: true,
                      selectedTileColor: (tileClicked.value[index] != true)
                          ? null
                          : Colors.grey.shade800,
                      onLongPress: () {
                        changeListTileState(index);
                      },
                      onTap: () {
                        if (tileClicked.value.contains(true)) {
                          changeListTileState(index);
                        }
                      },
                      title: const Text("title"),
                      subtitle: const Text("subtitle"),
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
