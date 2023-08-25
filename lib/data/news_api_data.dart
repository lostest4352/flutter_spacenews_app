import 'dart:convert';

import 'package:flutter_api_1/models/news_model.dart';
import 'package:http/http.dart' as http;

Future<(List<News>, List<int>)> getListFromNews() async {
  final url = Uri.parse("https://saurav.tech/NewsAPI/everything/cnn.json");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponses = jsonDecode(response.body);
    List<News> allNews = [];
    List<int> articleLength = [];
    final articleResponse = jsonResponses["articles"];
    for (final article in articleResponse) {
      final newsValue = News.fromMap(article as Map<String, dynamic>);
      allNews.add(newsValue);
      articleLength.add(newsValue.author.length);
    }

    return (allNews, articleLength);
  } else {
    throw Exception(response);
  }
}
