import 'package:flutter/material.dart';
import 'package:meowmedia/model/bookmark_model.dart';
import 'package:meowmedia/service/bookmark_service.dart';
import 'package:meowmedia/widget/category_tab_section.dart';
class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<BookmarkModel>> _bookmarks;

  @override
  void initState() {
    super.initState();
    _bookmarks = BookmarkService.getUserBookmarks();
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
        child: Column(
          children: [
            SizedBox(
      
              child: CategoryTabSection()),
          ],
        ),
      ),
    );
  }
}
