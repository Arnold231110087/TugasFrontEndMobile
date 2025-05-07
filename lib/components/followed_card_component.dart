import 'package:flutter/material.dart';

class FollowedCard extends StatelessWidget {
  final String username;
  final String time;
  final String message;
  final List<String> logos;
  final String profileImage;
  final String like;
  final String comment;

  const FollowedCard({
    super.key,
    required this.username,
    required this.time,
    required this.message,
    required this.logos,
    required this.profileImage,
    required this.like,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(profileImage)),
              SizedBox(width: 10),
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              Spacer(),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          if (logos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Wrap(
                spacing: 12,
                children: logos.map((logo) => Image.asset(logo, width: 50)).toList(),
              ),
            ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              SizedBox(width: 4),
              Text(
                like,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              SizedBox(width: 24),
              Icon(
                Icons.comment_outlined,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              SizedBox(width: 4),
              Text(
                '6',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}