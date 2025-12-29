import 'package:flutter/material.dart';
import 'package:meowmedia/model/bookmark_model.dart';
import 'package:meowmedia/service/bookmark_service.dart';
import 'package:meowmedia/widget/bookmart_list_card.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<BookmarkModel>> _bookmarks;

  @override
  void initState() {
    super.initState();
    _fetchBookmarks();
  }

  void _fetchBookmarks() {
    _bookmarks = BookmarkService.getUserBookmarks();
  }

  // 🔥 dipanggil dari luar
  void refresh() {
    setState(() {
      _fetchBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Bookmarks',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: FutureBuilder<List<BookmarkModel>>(
        future: _bookmarks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bookmarks = snapshot.data ?? [];
          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: BookmartListCard(
                  bookmark: bookmarks[index],
                  onBookmarkChanged: () {
                    setState(() {
                      _bookmarks = BookmarkService.getUserBookmarks();
                    });
                  },
                ),
              );
            },

          );
        },
      ),
    );
  }
}
