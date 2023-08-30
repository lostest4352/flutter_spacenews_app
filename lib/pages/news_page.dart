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
    final formattedTime = formatTimestamp(widget.news.published_at);

    return Scaffold(
      appBar: AppBar(
        title: Text("By: ${widget.news.news_site}"),
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SelectableText(
                  widget.news.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date Published: $formattedTime",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Center(
                child: Wrap(
                  children: [
                    const Text("News link:"),
                    SelectableText(
                      widget.news.url,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(widget.news.image_url),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(widget.news.summary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
