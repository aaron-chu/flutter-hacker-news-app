import 'dart:convert';

import 'package:flutter_hacker_news_app/datamodel/story.dart';
import 'package:http/http.dart' as http;

class HackerNewsRepository {
  final _httpClient = http.Client();

  Future<Story> loadStory(int id) async {
    final response = await _httpClient.get('https://hacker-news.firebaseio.com/v0/item/$id.json');
    if (response.statusCode != 200) return null;

    print('loadStory: ${json.decode(response.body)}');
    return Story.fromJson(json.decode(response.body));
  }

  Future<List<int>> loadTopStoryIds() async {
    final response = await _httpClient.get('https://hacker-news.firebaseio.com/v0/topstories.json');
    if (response.statusCode != 200) return <int>[];

    print("loadTopStoryIds: ${json.decode(response.body)}");
    return List<int>.from(json.decode(response.body));
  }

  void dispose() {
    _httpClient.close();
  }
}
