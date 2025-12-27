import 'package:flutter/material.dart';
import '../service/kategori_service.dart';
import '../service/berita_service.dart';
import '../model/kategori_model.dart';
import '../model/berita_model.dart';
import 'news_list_view.dart';

class CategoryTabSection extends StatefulWidget {
  const CategoryTabSection({super.key});

  @override
  State<CategoryTabSection> createState() => _CategoryTabSectionState();
}

class _CategoryTabSectionState extends State<CategoryTabSection> {
  final _kategoriService = KategoriService();
  final _beritaService = BeritaService();

  List<KategoriModel> kategoriList = [];
  List<BeritaModel> allBerita = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final kategori = await _kategoriService.getKategori();
    final berita = await _beritaService.getAllBerita();

    if (!mounted) return;

    setState(() {
      kategoriList = kategori;
      allBerita = berita;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final paddingTop = mediaQuery.padding.top;
    final paddingBottom = mediaQuery.padding.bottom;
    const navBarHeight = 252.0;

    final availableHeight =
        screenHeight - paddingTop - paddingBottom - navBarHeight;

    return DefaultTabController(
      length: kategoriList.length + 1, // + All
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TAB BAR
          TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            tabs: [
              const Tab(text: 'All'),
              ...kategoriList.map(
                (e) => Tab(text: e.nama),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// TAB CONTENT
          SizedBox(
            height: availableHeight,
            child: TabBarView(
              children: [
                /// ALL
                NewsListView(newsList: allBerita),

                /// PER KATEGORI
                ...kategoriList.map(
                  (kategori) => NewsListView(
                    newsList: allBerita
                        .where(
                          (b) =>
                              b.kategoriNama ==
                              kategori.nama,
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
