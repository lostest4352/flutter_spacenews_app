// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class News {
  int newsId;
  String title;
  String url;
  String image_url;
  String news_site;
  String summary;
  String published_at;
  String updated_at;
  String content;
  News({
    required this.newsId,
    required this.title,
    required this.url,
    required this.image_url,
    required this.news_site,
    required this.summary,
    required this.published_at,
    required this.updated_at,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'newsId': newsId,
      'title': title,
      'url': url,
      'image_url': image_url,
      'news_site': news_site,
      'summary': summary,
      'published_at': published_at,
      'updated_at': updated_at,
      'content': content,
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      newsId: map['newsId']?.toInt() ?? 0,
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      image_url: map['image_url'] ?? '',
      news_site: map['news_site'] ?? '',
      summary: map['summary'] ?? '',
      published_at: map['published_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) => News.fromMap(json.decode(source));
}
