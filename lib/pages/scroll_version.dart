import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_1/change_notifiers/bool_notifier.dart';
import 'package:flutter_api_1/data/news_api_data.dart';
import 'package:flutter_api_1/models/news_model.dart';
import 'package:flutter_api_1/pages/app_drawer.dart';
import 'package:flutter_api_1/pages/list_page.dart';
import 'package:flutter_api_1/pages/news_page.dart';

class ScrollHome extends StatefulWidget {
  const ScrollHome({super.key});

  @override
  State<ScrollHome> createState() => _ScrollHomeState();
}

class _ScrollHomeState extends State<ScrollHome>
    with SingleTickerProviderStateMixin {
  final boolNotifier = BoolNotifier();

  late Future<List<News>> newsFromApi;

  // The api called page limit offset. Eg 10 offset meant after 10 items.
  int offset = 0;

  final TextEditingController textEditingController = TextEditingController();

  bool isVisible = true;

  ScrollController scrollController = ScrollController();

  //
  List<News>? newsList = [];

  @override
  void initState() {
    super.initState();
    textEditingController.text = ((offset ~/ 10) + 1).toString();
    newsFromApi = getListFromNews(offset);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        getMoreNews();
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void getMoreNews() async {
    offset = offset + 10;
    newsFromApi = getListFromNews(offset);
    final moreNews = await newsFromApi;

    setState(() {
      newsList?.addAll(moreNews);
      boolNotifier.tileClicked =
          List<bool>.filled(newsList?.length ?? 0, false);
    });
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
        title: const Text("News App"),
        actions: [
          IconButton(
            tooltip: 'Go back to Page 1',
            onPressed: () {
              setState(() {
                newsList = [];
                offset = 0;
                newsFromApi = getListFromNews(offset);
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const AppDrawer(),
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
                    // newsList = (newsList == null) ? snapshot.data : newsList;

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if ((newsList ?? []).isEmpty) {
                      if (snapshot.data != null) {
                        newsList?.addAll(snapshot.data!);
                        boolNotifier.tileClicked =
                            List<bool>.filled(newsList?.length ?? 0, false);
                      }
                    }

                    int itemlength = (newsList?.length ?? 0);
                    return RefreshIndicator(
                      onRefresh: () {
                        // newsFromApi = getListFromNews(offset);
                        // setState(() {});
                        //
                        // changePage(offset);
                        setState(() {
                          newsList = [];
                          offset = 0;
                          newsFromApi = getListFromNews(offset);
                        });
                        return newsFromApi;
                      },
                      child: AnimatedOpacity(
                        opacity: isVisible ? 1.0 : 0,
                        duration: const Duration(milliseconds: 700),
                        child: Column(
                          children: [
                            Flexible(
                              child: ListView.separated(
                                controller: scrollController,
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                itemCount: itemlength + 1,
                                itemBuilder: (context, index) {
                                  if (index < itemlength) {
                                    if (boolNotifier.tileClicked.isEmpty) {
                                      List<bool> listTileBool = [];
                                      for (int i = 0; i < itemlength; i++) {
                                        listTileBool.add(false);
                                        boolNotifier.tileClicked = listTileBool;
                                      }
                                    }

                                    return ListTile(
                                      selected: true,
                                      selectedTileColor: (boolNotifier
                                                      .tileClicked.length >=
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
                                          boolNotifier
                                              .changeListTileState(index);

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
                                                      newsList?[index] as News,
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      title: Text(
                                        newsList?[index].title ?? "no data",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        newsList?[index].summary ?? "no data",
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              newsList?[index].image_url ?? "",
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
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
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
