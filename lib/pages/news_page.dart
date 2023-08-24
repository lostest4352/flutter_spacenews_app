import 'package:flutter/material.dart';
import 'package:flutter_api_1/models/news_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article no: ${widget.news.title}"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                "Author: ${widget.news.author}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Divider(
              height: 25,
            ),
            Image.network(widget.news.urlToImage),
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
