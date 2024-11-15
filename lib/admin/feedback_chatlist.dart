import 'package:flutter/material.dart';

import 'feedback_chatscreen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback & Support'),

      ),
      body: ListView.builder(
        itemCount: 10, // Number of chats
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpYj7k68KtncfzaCLfsn3EH8atwWxaSmX9TA&s'),
            ),
            title: Text('User $index'),
            subtitle: Text('Hello'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(userId: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
