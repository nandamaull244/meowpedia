import 'package:flutter/material.dart';
import 'package:meowmedia/model/news_model.dart';
import 'package:meowmedia/screen/news_detail_user.dart';
import 'package:meowmedia/services/auth_service.dart';
import '../data/news_dummy.dart';
import 'news_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<NewsModel> userPosts = List.from(dummyNews);

  void _deletePost(NewsModel news) {
    setState(() {
      userPosts.remove(news);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon:
                Icon(Icons.logout_rounded, color: Theme.of(context).primaryColor),
            onPressed: () {
              // Logout logic here
              AuthService.logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Profile Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/logo.jpeg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vinna123',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'vinna asomethink jr',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 📰 Posts
              Text(
                'My Posts',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userPosts.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final news = userPosts[index];

                  return InkWell(
                    onTap: () async {
                      final deleted = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailScreenUser(
                            news: news,
                          ),
                        ),
                      );

                      if (deleted == true) {
                        _deletePost(news);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        news.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
