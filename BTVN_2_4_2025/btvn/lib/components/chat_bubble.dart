import 'package:btvn/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String? message;
  final bool isCurrentUser;
  final String? imageUrl;

  const ChatBubble({
    super.key,
    this.message,
    required this.isCurrentUser,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final bubbleColor = isCurrentUser
        ? (isDarkMode ? Colors.green.shade600 : Colors.grey.shade500)
        : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          if (message != null && message!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                message!,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
