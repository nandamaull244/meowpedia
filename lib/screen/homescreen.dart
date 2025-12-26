import 'package:flutter/material.dart';
import 'package:meowmedia/screen/choosed_topic_screen.dart';
import 'package:meowmedia/screen/search_screen.dart';
import 'package:meowmedia/widget/category_tab_section.dart';
import 'package:meowmedia/widget/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SearchBarWidget(
              controller: _searchController,
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
              onFilterTap: () async{
              final result = await Navigator.push<Set<String>>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChooseTopicsScreen(),
                ),
              );

              if (result != null) {
                print(result); // topic terpilih
              }
              },
            ),
            const SizedBox(height: 20),
              CategoryTabSection(),
            ],
          ),
        )
      ),
    );
  }
}