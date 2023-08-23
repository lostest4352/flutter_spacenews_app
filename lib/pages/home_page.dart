import 'package:flutter/material.dart';
import 'package:flutter_api_1/change_notifiers/bool_notifier.dart';
import 'package:flutter_api_1/pages/list_page.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final boolNotifier = BoolNotifier();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    //
    Color selectedColor = (theme.brightness == Brightness.dark)
        ? Colors.grey.shade800
        : Colors.blueGrey.shade100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
      ),
      drawer: Drawer(),
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
                        leading: IconButton(
                          onPressed: () {
                            boolNotifier.changeAllTileState();
                          },
                          icon: (boolNotifier.tileClicked.contains(false))
                              ? const Icon(Icons.check_box_outline_blank)
                              : const Icon(Icons.check_box_outlined),
                        ),
                        title: const Text("Select/Unselect All"),
                        subtitle:
                            Text("${selectedItems.length} items selected"),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ListPage(
                                    selectedItems: selectedItems,
                                  );
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  cacheExtent: 5,
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    // Fill only when its empty otherwise there is null error. It'll try to fill the value of tiles not clicked yet and there's error
                    if (boolNotifier.tileClicked.isEmpty) {
                      // boolNotifier.tileClicked = List.filled(5, false);

                      // Longer form of above code
                      List<bool> listTileBool = [];
                      for (int i = 0; i < 50; i++) {
                        listTileBool.add(false);
                        boolNotifier.tileClicked = listTileBool;
                      }
                    }

                    return ListTile(
                      selected: true,
                      selectedTileColor:
                          // > instead of >= if issue
                          (boolNotifier.tileClicked.length >= index &&
                                  boolNotifier.tileClicked[index])
                              // ? Colors.grey.shade800
                              ? selectedColor
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
                        backgroundColor: Colors.blue.shade800,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
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
