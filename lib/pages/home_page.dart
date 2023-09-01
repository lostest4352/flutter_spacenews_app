import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_1/change_notifiers/bool_notifier.dart';
import 'package:flutter_api_1/data/news_api_data.dart';
import 'package:flutter_api_1/models/news_model.dart';
import 'package:flutter_api_1/pages/list_page.dart';
import 'package:flutter_api_1/pages/news_page.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final boolNotifier = BoolNotifier();

  late Future<List<News>> newsFromApi;

  int offset = 0;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = ((offset ~/ 10) + 1).toString();
    newsFromApi = getListFromNews(offset);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    //
    Color selectedColor = (theme.brightness == Brightness.dark)
        ? Colors.grey.shade800
        : Colors.blueGrey.shade100;

    // Same as (offset / 10).toInt() +1
    int pageNo = (offset ~/ 10) + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Page $pageNo"),
        actions: [
          IconButton(
            tooltip: 'Go back to Page 1',
            onPressed: () {
              offset = 0;
              newsFromApi = getListFromNews(offset);
              // pageNo dont work here for some reason unless pressed twice
              textEditingController.text = ((offset ~/ 10) + 1).toString();
              setState(() {});
              boolNotifier.tileClicked =
                  List.filled(boolNotifier.tileClicked.length, false);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const Drawer(),
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
                child: FutureBuilder(
                  future: newsFromApi,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      return const Center(
                        child: Text("No Internet Connection"),
                      );
                    }
                    //
                    int itemlength = (snapshot.data?.length ?? 0);
                    return RefreshIndicator(
                      onRefresh: () {
                        newsFromApi = getListFromNews(offset);
                        setState(() {});
                        return newsFromApi;
                      },

                      // Replaced Sliver with Listview if issues happen and remove CustomScrollView
                      child: CustomScrollView(
                        slivers: [
                          SliverList.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: itemlength,
                            itemBuilder: (context, index) {
                              // Fill only when its empty otherwise there is null error. It'll try to fill the value of tiles not clicked yet and there's error
                              // This is where list is made so before this list is to be empty
                              if (boolNotifier.tileClicked.isEmpty) {
                                // boolNotifier.tileClicked = List.filled(itemlength, false);

                                // Longer form of above code
                                List<bool> listTileBool = [];
                                for (int i = 0; i < itemlength; i++) {
                                  listTileBool.add(false);
                                  boolNotifier.tileClicked = listTileBool;
                                }
                              }

                              return ListTile(
                                selected: true,
                                selectedTileColor:
                                    // > instead of >= if issue
                                    // total length of the tileClicked list which has either true or false and never null because if it was null, listtile wouldnt be made in the first place
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
                                    // This code till debugPrint was made only to debug print and no other uses
                                    List itemsContainingTrue = [];
                                    for (final boolItem
                                        in boolNotifier.tileClicked) {
                                      if (boolItem == true) {
                                        itemsContainingTrue.add(boolItem);
                                      }
                                    }
                                    debugPrint(
                                        "selected items length: ${itemsContainingTrue.length.toString()}");
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return NewsPage(
                                            news: snapshot.data?[index] as News,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                title: Text(
                                  snapshot.data?[index].title ?? "no data",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  snapshot.data?[index].summary ?? "no data",
                                  style: const TextStyle(color: Colors.blue),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: ClipRRect(
                                  child: Image.network(
                                    snapshot.data?[index].image_url ?? "",
                                    height: 100,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint(error.toString());
                                      return Container();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          SliverToBoxAdapter(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    IconButton(
                                      tooltip: "Previous Page",
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        if (offset > 0) {
                                          offset -= 10;
                                          newsFromApi = getListFromNews(offset);
                                          textEditingController.text =
                                              ((offset ~/ 10) + 1).toString();
                                          setState(() {});
                                          boolNotifier.tileClicked =
                                              List.filled(
                                            boolNotifier.tileClicked.length,
                                            false,
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 8,
                                          right: 8,
                                          left: 8),
                                      child: Text("Page"),
                                    ),
                                    SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: textEditingController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2,
                                        bottom: 8,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          final convertedValue = int.parse(
                                              textEditingController.text);
                                          if (convertedValue != 0) {
                                            offset = (convertedValue - 1) * 10;
                                            textEditingController.text =
                                                ((offset ~/ 10) + 1).toString();
                                            newsFromApi =
                                                getListFromNews(offset);
                                            setState(() {});
                                            boolNotifier.tileClicked =
                                                List.filled(
                                              boolNotifier.tileClicked.length,
                                              false,
                                            );
                                          }
                                        },
                                        icon: const Text("Go"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      tooltip: "Next Page",
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        offset += 10;
                                        newsFromApi = getListFromNews(offset);
                                        textEditingController.text =
                                            ((offset ~/ 10) + 1).toString();
                                        setState(() {});
                                        boolNotifier.tileClicked = List.filled(
                                            boolNotifier.tileClicked.length,
                                            false);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
