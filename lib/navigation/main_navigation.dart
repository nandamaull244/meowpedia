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
  final GlobalKey<HomeScreenState> _homeKey = 
      GlobalKey<HomeScreenState>();
  final GlobalKey<ProfileScreenState> _profileKey =
    GlobalKey<ProfileScreenState>();

  late final List<Widget> _pages = [
    HomeScreen(key: _homeKey),
    const SearchScreen(),
    const SizedBox(),
    BookmarkScreen(key: _bookmarkKey),
    ProfileScreen(key: _profileKey),
  ];

  // function untuk go to home
  void goToHome({bool refresh = false}) {
    setState(() {
      _currentIndex = 0;
    });

    if (refresh) {
      _homeKey.currentState?.refresh();
    }
  }

  // function untuk go to bookmark
  void goToBookmark({bool refresh = false}) {
    setState(() {
      _currentIndex = 3;
    });

    if (refresh) {
      _bookmarkKey.currentState?.refresh();
    }
  }

  // go to upload
  Future<void> goToUpload() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const UploadScreen(),
      ),
    );
    // kalau upload berhasil
    if (result == true) {
      setState(() => _currentIndex = 0);
      _homeKey.currentState?.refresh();
      _profileKey.currentState?.refresh();
    }
  }


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
          if (index == 0) {
            goToHome(refresh: true);
          } else if (index == 2) {
            goToUpload(); // 🔥 UPLOAD
          } else if (index == 3) {
            goToBookmark(refresh: true);
          } else {
            setState(() => _currentIndex = index);
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
