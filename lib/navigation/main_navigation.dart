import 'package:flutter/material.dart';
import 'package:meowmedia/screen/bookmark_screen.dart';
import 'package:meowmedia/screen/homescreen.dart';
import 'package:meowmedia/screen/profile_screen.dart';
import 'package:meowmedia/screen/search_screen.dart';
import 'package:meowmedia/screen/upload_screen.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}


class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final GlobalKey<BookmarkScreenState> _bookmarkKey =
      GlobalKey<BookmarkScreenState>();

  late final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const UploadScreen(),
    BookmarkScreen(key: _bookmarkKey),
    const ProfileScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // 🔥 trigger refresh saat masuk tab bookmark
          if (index == 3) {
            _bookmarkKey.currentState?.refresh();
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

