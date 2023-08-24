import 'dart:convert';

import 'package:flutter_api_1/models/news_model.dart';
import 'package:http/http.dart' as http;

Future<List<News>> getListFromNews() async {
  final url = Uri.parse("https://saurav.tech/NewsAPI/everything/cnn.json");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponses = jsonDecode(response.body);
    // List<News> newsList = jsonResponses.map((newsData) {
    //   return News.fromMap(newsData);
    // }).toList();
    List<News> allNews = [];
    final articleResponse = jsonResponses["articles"];
    for (final article in articleResponse) {
      final newsValue = News.fromMap(article as Map<String, dynamic>);
      allNews.add(newsValue);
    }

    return allNews;
  } else {
    throw Exception(response);
  }
}
