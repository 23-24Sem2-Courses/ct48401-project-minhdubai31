import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AVATAR AND NAME
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              SizedBox(
                width: 35,
                height: 35,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "User name",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const AspectRatio(
          aspectRatio: 4 / 5,
          child: Image(
            image: AssetImage('assets/mylove.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        // POST FOOTER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Tap detected");
                          },
                          child: const Icon(
                            Ionicons.heart_outline,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Tap detected");
                          },
                          child: const Icon(
                            Ionicons.chatbox_outline,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "1.024 likes",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    ),
                  )
                ],
              ),
              // POST CONTENT
              const Text(
                "This is the content of the post!",
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  print("Tap");
                },
                child: const Text(
                  "View all 4 comments",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
