import 'package:flutter/material.dart';
import 'package:meowmedia/model/berita_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final BeritaModel berita;

  const NewsDetailScreen({
    super.key,
    required this.berita,
  });

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
                berita.imageUrl,
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
                    berita.kategoriNama,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    berita.judul,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Source & time
                  Row(
                    children: [
                      Image.network(berita.imageUrl, width: 20),
                      const SizedBox(width: 8),
                      Text(
                        berita.full_name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        berita.tanggal.toIso8601String(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Dummy content
                  Text(
                    berita.isi,
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
