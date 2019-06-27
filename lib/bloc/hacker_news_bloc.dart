import 'dart:async';
import 'dart:convert';
import 'package:flutter_hacker_news_app/datamodel/story.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'base_bloc.dart';

class HackerNewsBloc extends Bloc {
  static const int INIT_PAGE_SIZE = 10;
  static const int PAGE_SIZE = 3;

  final _topStoryIds = List<int>();
  final _topStories = List<Story>();

  var _isLoadingMoreTopStories = false;
  var currentStoryIndex = 0;

  StreamController<List<Story>> _topStoriesStreamController = StreamController();

  Stream<List<Story>> get topStories => _topStoriesStreamController.stream;

  HackerNewsBloc() {
    _loadInitTopStories();
  }

  void _loadInitTopStories() async {
    _topStoryIds.addAll(await _loadTopStoryIds());

    loadMoreTopStories(pageSize: INIT_PAGE_SIZE);
  }

  void loadMoreTopStories({int pageSize = PAGE_SIZE}) async {
    if (_isLoadingMoreTopStories) return;

    _isLoadingMoreTopStories = true;
    final storySize = min(currentStoryIndex + pageSize, _topStoryIds.length);
    for (int index = currentStoryIndex; index < storySize; index++) {
      _topStories.add(await _loadStory(_topStoryIds[index]));
    }
    currentStoryIndex = storySize;
    _topStoriesStreamController.add(_topStories);
    _isLoadingMoreTopStories = false;
  }

  bool hasMoreStories() => currentStoryIndex < _topStoryIds.length;

  Future<Story> _loadStory(int id) async {
    final response = await http.get('https://hacker-news.firebaseio.com/v0/item/$id.json');
    if (response.statusCode != 200) return null;

    print('_loadStory: ${json.decode(response.body)}');
    return Story.fromJson(json.decode(response.body));
  }

  Future<List<int>> _loadTopStoryIds() async {
    final response = await http.get('https://hacker-news.firebaseio.com/v0/topstories.json');
    if (response.statusCode != 200) return <int>[];

    print("_loadTopStoryIds: ${json.decode(response.body)}");
    return List<int>.from(json.decode(response.body));
  }

  @override
  void dispose() {
    _topStoriesStreamController.close();
    super.dispose();
  }
}
