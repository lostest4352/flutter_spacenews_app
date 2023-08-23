import 'package:flutter/material.dart';

import 'package:flutter_api_1/models/posts_model.dart';

class NewsPage extends StatefulWidget {
  final Posts posts;
  const NewsPage({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article no: ${widget.posts.id}"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.posts.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Divider(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Text(widget.posts.body),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
