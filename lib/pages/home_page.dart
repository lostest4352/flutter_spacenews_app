import 'package:flutter/material.dart';
import 'package:flutter_api_1/services/bool_change_notifier.dart';


class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool tilePressed = false;

  final boolNotifier = BoolNotifier();

  // List<bool> buttonsClicked = [];
  // ListValueNotifier<List<bool>> tileClicked = ListValueNotifier<List<bool>>([]);

  // void changeListTileState(int index) {
  //   tileClicked.value[index] = !tileClicked.value[index];
  //   tileClicked.notifyListeners();
  // }

  // @override
  // void dispose() {
  //   tileClicked.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
      ),
      body: ListenableBuilder(
        listenable: boolNotifier,
        builder: (context, child) {
          //
          List selectedItems = [];
          for (final boolItem in boolNotifier.tileClicked) {
            if (boolItem == true) {
              selectedItems.add(boolItem);
            }
          }
          return Column(
            children: [
              Card(
                child: (selectedItems.isNotEmpty)
                    ? ListTile(
                        title: Text("${selectedItems.length} items selected"),
                      )
                    : null,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // Fill only when its empty otherwise there is null error. It'll try to fill the value of tiles not clicked yet and there's error
                    if (boolNotifier.tileClicked.isEmpty) {
                      // tileClicked.value = List.filled(5, false);

                      // Longer form of above code
                      List<bool> listTileBool = [];
                      for (int i = 0; i < 5; i++) {
                        listTileBool.add(false);
                        boolNotifier.tileClicked = listTileBool;
                      }
                    }

                    return ListTile(
                      selected: true,
                      selectedTileColor:
                          (index < boolNotifier.tileClicked.length &&
                                  boolNotifier.tileClicked[index])
                              ? Colors.grey.shade800
                              : null,
                      onLongPress: () {
                        // changeListTileState(index);
                        boolNotifier.changeListTileState(index);
                      },
                      onTap: () {
                        if (boolNotifier.tileClicked.contains(true)) {
                          // changeListTileState(index);
                          boolNotifier.changeListTileState(index);

                          List itemsContainingTrue = [];
                          for (final boolItem in boolNotifier.tileClicked) {
                            if (boolItem == true) {
                              itemsContainingTrue.add(boolItem);
                            }
                          }
                          debugPrint(
                              "selected items length: ${itemsContainingTrue.length.toString()}");
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
