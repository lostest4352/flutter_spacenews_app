import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final int selectedLength;
  const ListPage({
    Key? key,
    required this.selectedLength,
  }) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Page"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.selectedLength.toString()),
          ),

        ],
      ),
    );
  }
}