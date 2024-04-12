import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/ui/widgets/gradient_text.dart';
import 'package:ct484_project/ui/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({
    super.key,
  });

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 0, 12),
            child: GradientText(
              "Photos Share",
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade800,
                ],
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(220, 220, 220, 1),
            height: 0,
          ),
          Expanded(
            child: StreamBuilder(
              stream: context.read<PostService>().getPosts(),
              builder: (context, snapshot) {
                List posts = snapshot.data?.docs ?? [];

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    Post post = posts[index].data();
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        PostCard(
                          post: post,
                          postId: posts[index].id,
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
