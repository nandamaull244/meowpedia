import 'package:flutter/material.dart';
import 'package:meowmedia/model/bookmark_model.dart';
import 'package:meowmedia/screen/bookmark_screen.dart';
import 'package:meowmedia/service/bookmark_service.dart';

class NewsDetailScreenBookmark extends StatefulWidget {
  final BookmarkModel bookmark;

  const NewsDetailScreenBookmark({
    super.key,
    required this.bookmark,
  });

  @override
  State<NewsDetailScreenBookmark> createState() =>
      _NewsDetailScreenBookmarkState();
}

class _NewsDetailScreenBookmarkState
    extends State<NewsDetailScreenBookmark> {
  bool isBookmarked = true; // karena ini dari bookmark

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.bookmark.berita.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.bookmark.berita.kategoriNama,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.bookmark.berita.judul,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.bookmark,
                          color:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          // 🔥 UNBOOKMARK
                          await BookmarkService.removeBookmark(
                            widget.bookmark.berita.id,
                          );

                          if (!mounted) return;

                          // 🔥 KIRIM SINYAL KE HALAMAN SEBELUMNYA
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text(
                        widget.bookmark.berita.full_name,
                        style:
                            Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.bookmark.berita.tanggal.toString(),
                        style:
                            Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    widget.bookmark.berita.isi,
                    style:
                        Theme.of(context).textTheme.bodyMedium,
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

