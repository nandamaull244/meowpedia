import 'package:flutter/material.dart';
import 'package:meowmedia/widget/category_tab_section.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
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
