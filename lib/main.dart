import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_app/bloc/hacker_news_bloc.dart';
import 'package:flutter_hacker_news_app/page/hacker_news_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<HackerNewsBloc>(
        builder: (context) => HackerNewsBloc(),
        dispose: (context, bloc) => bloc.dispose(),
        child: HackerNewsPage(),
      ),
    );
  }
}
