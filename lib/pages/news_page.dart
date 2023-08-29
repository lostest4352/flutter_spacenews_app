import 'package:flutter/material.dart';
import 'package:flutter_api_1/models/news_model.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  final News news;
  const NewsPage({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String formatTimestamp(String timestamp) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
    final outputFormat = DateFormat("yyyy-MM-dd 'at' hh:mm a");

    final parsedDate = inputFormat.parse(timestamp);
    return outputFormat.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = formatTimestamp(widget.news.publishedAt);

    return Scaffold(
      appBar: AppBar(
        title: Text("By: ${widget.news.author}"),
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SelectableText(
                  widget.news.title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Date Published: $formattedTime"),
              ),
            ),
            const Divider(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(widget.news.urlToImage),
            ),
            InteractiveViewer(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(widget.news.description),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
