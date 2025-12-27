import 'package:flutter/material.dart';
import 'package:meowmedia/model/berita_model.dart';
import 'package:meowmedia/service/bookmark_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final BeritaModel berita;

  const NewsDetailScreen({
    super.key,
    required this.berita,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final bookmarked =
        await BookmarkService.isBookmarked(widget.berita.id);

    if (!mounted) return;

    setState(() {
      isBookmarked = bookmarked;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🖼️ Banner image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.berita.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 📄 Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    widget.berita.kategoriNama,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.berita.judul,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            key: ValueKey(isBookmarked),
                            color: isBookmarked ? Colors.black : Colors.grey,
                          ),
                        ),
                        onPressed: () async {
                          if (isBookmarked) {
                            await BookmarkService.removeBookmark(
                                widget.berita.id);
                          } else {
                            await BookmarkService.addBookmark(
                                widget.berita.id);
                          }

                          if (!mounted) return;
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Source & time
                  Row(
                    children: [
                      Image.network(widget.berita.imageUrl, width: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.berita.full_name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.berita.tanggal.toIso8601String(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Content
                  Text(
                    widget.berita.isi,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
