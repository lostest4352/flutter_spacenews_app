import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_1/models/news_model.dart';
import 'package:http/http.dart' as http;

class SpaceNews extends ChangeNotifier {
  testd() {
    notifyListeners();
  }
}

Future<List<News>> getListFromNews(int offset) async {

  // int offset = 0;
  int limit = 10;

  final url = Uri.parse("https://api.spaceflightnewsapi.net/v4/articles/?limit=$limit&offset=$offset");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<News> allNews = [];
    // List<int> articleLength = [];
    //
    final jsonResponses = jsonDecode(utf8.decode(response.bodyBytes));

    final articleResponse = jsonResponses["results"];
    for (final article in articleResponse) {
      final newsValue = News.fromMap(article as Map<String, dynamic>);
      allNews.add(newsValue);
      // articleLength.add(newsValue.title.length);
    }

    

    return allNews;
  } else {
    throw Exception(response);
  }
}
