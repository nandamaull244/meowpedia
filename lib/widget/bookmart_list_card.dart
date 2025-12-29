import 'package:flutter/material.dart';
import 'package:meowmedia/model/bookmark_model.dart';
import 'package:meowmedia/screen/bookmark_detail.dart';
import 'package:meowmedia/service/bookmark_service.dart';


class BookmartListCard extends StatelessWidget {
  final BookmarkModel bookmark;
  final VoidCallback onBookmarkChanged;

  const BookmartListCard({
    super.key,
    required this.bookmark,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                NewsDetailScreenBookmark(bookmark: bookmark),
          ),
        );

        // 🔥 KIRIM SINYAL KE PARENT
        if (result == true) {
          onBookmarkChanged();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              bookmark.berita.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              bookmark.berita.kategoriNama,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bookmark.berita.judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}

