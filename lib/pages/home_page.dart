import 'package:flutter/material.dart';
import 'package:flutter_api_1/change_notifiers/bool_notifier.dart';
import 'package:flutter_api_1/pages/list_page.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool tilePressed = false;

  final boolNotifier = BoolNotifier();

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
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ListPage(selectedLength: selectedItems.length,);
                              },
                            ));
                          },
                          icon: const Icon(Icons.arrow_circle_right),
                        ),
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
                          (boolNotifier.tileClicked.length > index &&
                                  boolNotifier.tileClicked[index])
                              ? Colors.grey.shade800
                              : null,
                      onLongPress: () {
                        boolNotifier.changeListTileState(index);
                      },
                      onTap: () {
                        if (boolNotifier.tileClicked.contains(true)) {
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
