import 'dart:convert';

import 'package:flutter_api_1/unused/posts_model.dart';
import 'package:http/http.dart' as http;

// Future<Posts> getDataFromJson() async {
//   final url = Uri.parse("https://jsonplaceholder.typicode.com/users/1/posts");
//   final response = await http.get(url);
//   if (response.statusCode == 200) {
//     List jsonResponse = jsonDecode(response.body);
//     return Posts.fromJson(jsonResponse[1]);
//   } else {
//     throw Exception("An error occured");
//   }
// }

Future<List<Posts>> getListFromJson() async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/users/1/posts");
  final response = await http.get(url);
  List<Posts> postsList = [];
  if (response.statusCode == 200) {
    List jsonResponses = jsonDecode(response.body);
    for (final jsonResponse in jsonResponses) {
      final singleResponse = Posts.fromMap(jsonResponse);
      postsList.add(singleResponse);
    }
    return postsList;
    // List jsonResponse = jsonDecode(response.body);
    // List<Posts> postsList = jsonResponse.map((data) => Posts.fromJson(data)).toList();
    // return postsList;
  } else {
    throw Exception("List error occured");
  }
}
