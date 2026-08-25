import 'package:charity/Donor/Controller/SupportChat.dart';
import 'package:charity/Donor/Screens/SupportMessageScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportConversationsScreen extends StatelessWidget {
  SupportConversationsScreen({super.key});

  final controller = Get.put(SupportChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support Chats")),

      body: Obx(() {
        if (controller.conversations.isEmpty) {
          return const Center(child: Text("No Conversations"));
        }

        return ListView.builder(
          itemCount: controller.conversations.length,

          itemBuilder: (_, index) {
            var c = controller.conversations[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: ListTile(
                title: Text(c.otherUserName),

                subtitle: Text(c.lastMessage ?? ""),

                trailing: c.unreadCount > 0
                    ? CircleAvatar(radius: 12, child: Text("${c.unreadCount}"))
                    : null,

                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                  int userId = prefs.getInt("userId") ?? 0;

                  Get.to(
                    () => SupportMessagesScreen(
                      conversationId: c.conversationId,
                      userId: userId,
                      donorRequestId: c.donorRequestId ?? 0,
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
