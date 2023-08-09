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

  // @override
  // void initState() {
  //   super.initState();
  //   tileClicked.value = List.filled(5, false);   
  // }

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
          ListenableBuilder(
            listenable: tileClicked,
            builder: (context, child) {
              //
              List selectedItems = [];
              for (final boolItem in tileClicked.value) {
                if (boolItem == true) {
                  selectedItems.add(boolItem);
                }
              }
              return Card(
                child: (selectedItems.isNotEmpty)
                    ? ListTile(
                        title: Text("${selectedItems.length} items selected"),
                      )
                    : null,
              );
            },
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: tileClicked,
              builder: (context, child) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // Fill only when its empty otherwise there is null error. It'll try to fill the value of tiles not clicked yet and there's error
                    if (tileClicked.value.isEmpty) {
                      // tileClicked.value = List.filled(5, false);

                      // Longer form of above code
                      List<bool> listTileBool = [];
                      for (int i = 0; i < 5; i++) {
                        listTileBool.add(false);
                        tileClicked.value = listTileBool;
                      }
                    }

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
                          List trueItems = [];
                          for (final boolItem in tileClicked.value) {
                            if (boolItem == true) {
                              trueItems.add(boolItem);
                            }
                          }
                          debugPrint(
                              "selected items length: ${trueItems.length.toString()}");
                        }
                      },
                      title: const Text("title"),
                      subtitle: const Text("subtitle"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade800,
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
