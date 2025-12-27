import 'package:flutter/material.dart';
import 'package:meowmedia/model/news_model.dart';
import 'package:meowmedia/model/user_model.dart';
import 'package:meowmedia/screen/auth/login_screen.dart';
import 'package:meowmedia/screen/news_detail_user.dart';
import 'package:meowmedia/service/auth_service.dart';
import '../data/news_dummy.dart';

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

  Future<void> _logout() async {
  await AuthService().logout();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false, // hapus semua halaman sebelumnya
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout_rounded,
                color: Theme.of(context).primaryColor),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: AuthService().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final user = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 PROFILE HEADER
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/logo.jpeg'),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 📰 POSTS TITLE
                  Text(
                    'My Posts',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 12),

                  // 📰 POSTS GRID
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userPosts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (context, index) {
                      final news = userPosts[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () async {
                          final deleted = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NewsDetailScreenUser(news: news),
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
            );
          },
        ),
      ),
    );
  }
}
