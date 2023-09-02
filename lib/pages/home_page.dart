import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  final boolNotifier = BoolNotifier();

  late Future<List<News>> newsFromApi;

  // The api called page limit offset. Eg 10 offset meant after 10 items.
  int offset = 0;

  final TextEditingController textEditingController = TextEditingController();

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    textEditingController.text = ((offset ~/ 10) + 1).toString();
    newsFromApi = getListFromNews(offset);
  }

  // Divided offset, which is after certain amount of value. It starts from 0 so added 1 to have proper index(for user)
  void changePage(int offsetValue) {
    setState(() {
      offset = offsetValue;
      newsFromApi = getListFromNews(offset);
      textEditingController.text = ((offset ~/ 10) + 1).toString();
      isVisible = false;
    });
    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        isVisible = true;
      });
    });
    boolNotifier.unselectAll();
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
              changePage(0);
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
                        // newsFromApi = getListFromNews(offset);
                        // setState(() {});
                        //
                        changePage(offset);
                        return newsFromApi;
                      },

                      // Replaced Sliver with Listview if issues happen and remove CustomScrollView
                      child: AnimatedOpacity(
                        opacity: isVisible ? 1.0 : 0,
                        duration: const Duration(milliseconds: 700),
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
                                      (boolNotifier.tileClicked.length >=
                                                  index &&
                                              boolNotifier.tileClicked[index])
                                          ? selectedColor
                                          : null,
                                  onLongPress: () {
                                    boolNotifier.changeListTileState(index);
                                  },
                                  onTap: () {
                                    if (boolNotifier.tileClicked
                                        .contains(true)) {
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
                                              news:
                                                  snapshot.data?[index] as News,
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
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          snapshot.data?[index].image_url ?? "",
                                      height: 100,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
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
                                            changePage(offset - 10);
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
                                        width: 55,
                                        height: 45,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          controller: textEditingController,
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
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
                                              // -1 to match the index. Input here starts with real life startin number 1 but programmming starts with 0, and api follows that rule so converting back to coding logic
                                              changePage(
                                                  (convertedValue - 1) * 10);
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
                                          changePage(offset + 10);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
