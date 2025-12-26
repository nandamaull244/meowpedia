import 'package:flutter/material.dart';
import '../data/news_dummy.dart';
import 'news_list_view.dart';

class CategoryTabSection extends StatelessWidget {
  const CategoryTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final paddingTop = mediaQuery.padding.top;
    final paddingBottom = mediaQuery.padding.bottom;
    final navBarHeight = 252.0;

    final availableHeight =
        screenHeight - paddingTop - paddingBottom - navBarHeight;

    return DefaultTabController(
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ TAB BAR
          TabBar(
            tabAlignment: TabAlignment.start,
            dividerHeight: 0,
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Care Tips'),
              Tab(text: 'Funny News'),
              Tab(text: 'Health'),
              Tab(text: 'Cat Adoption'),
            ],
          ),

          const SizedBox(height: 12),

          // 📃 TAB CONTEN

          SizedBox(
            height: availableHeight,
            child: TabBarView(
              children: [
                NewsListView(newsList: dummyNews),
                NewsListView(
                  newsList:
                      dummyNews.where((e) => e.category == 'Care Tips').toList(),
                ),
                NewsListView(
                  newsList:
                      dummyNews.where((e) => e.category == 'Funny News').toList(),
                ),
                NewsListView(
                  newsList:
                      dummyNews.where((e) => e.category == 'Health').toList(),
                ),
                NewsListView(
                  newsList:
                      dummyNews.where((e) => e.category == 'Cat Adoption').toList(),
                ),
              ],
            ),
          )


        ],
      ),
    );
  }
}
