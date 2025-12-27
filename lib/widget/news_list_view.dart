import 'package:flutter/material.dart';
import 'package:meowmedia/model/berita_model.dart';
import 'package:meowmedia/widget/news_card_widget.dart';

class NewsListView extends StatelessWidget {
  final List<BeritaModel> newsList;

  const NewsListView({
    super.key,
    required this.newsList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: NewsCard(news: newsList[index]),
        );
      },
    );
  }
}
