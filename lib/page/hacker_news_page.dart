import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_app/bloc/hacker_news_bloc.dart';
import 'package:flutter_hacker_news_app/datamodel/story.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HackerNewsPage extends StatefulWidget {
  @override
  _HackerNewsPageState createState() => _HackerNewsPageState();
}

class _HackerNewsPageState extends State<HackerNewsPage> {
  HackerNewsBloc _bloc;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreTopStoriesIfNeed);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of<HackerNewsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hacker News')),
      body: StreamBuilder(
        stream: _bloc.topStories,
        builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
          if (snapshot.hasData) return _buildTopStories(topStories: snapshot.data);
          if (snapshot.hasError) return Center(child: Text('${snapshot.error}'));
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _loadMoreTopStoriesIfNeed() {
    final offsetToEnd = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
    final threshold = MediaQuery.of(context).size.height / 3;
    final shouldLoadMore = offsetToEnd < threshold;
    if (shouldLoadMore) {
      _bloc.loadMoreTopStories();
    }
  }

  Widget _buildTopStories({List<Story> topStories}) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _bloc.hasMoreStories() ? topStories.length + 1 : topStories.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == topStories.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildStoryCardView(story: topStories[index]);
      },
    );
  }

  Widget _buildStoryCardView({Story story}) {
    return Card(
      child: ListTile(
        title: Text(story.title),
        subtitle: Text(story.author),
        trailing: Text(story.score.toString()),
        onTap: () => _launchUrl(story.url),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
