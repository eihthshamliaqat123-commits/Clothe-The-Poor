import 'package:charity/Donor/Controller/SupportChat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportMessagesScreen extends StatefulWidget {
  final int conversationId;
  final int userId;
  final int donorRequestId;

  const SupportMessagesScreen({
    super.key,
    required this.conversationId,
    required this.userId,
    required this.donorRequestId,
  });

  @override
  State<SupportMessagesScreen> createState() => _SupportMessagesScreenState();
}

class _SupportMessagesScreenState extends State<SupportMessagesScreen> {
  final controller = Get.put(SupportChatController());

  @override
  void initState() {
    super.initState();

    controller.getMessages(
      conversationId: widget.conversationId,
      userId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support Chat")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.messages.isEmpty) {
          return const Center(child: Text("No Messages"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.messages.length,

                itemBuilder: (_, index) {
                  var msg = controller.messages[index];

                  bool isImage =
                      (msg.messageType ?? "").toUpperCase() == "IMAGE";

                  return Container(
                    margin: const EdgeInsets.all(10),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        if (isImage)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),

                            child: Image.network(
                              msg.imageUrl ?? "",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        if (!isImage)
                          Container(
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Text(msg.messageText ?? ""),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.sendYesNo(
                        conversationId: widget.conversationId,
                        recipientId: widget.userId,
                        response: "YES",
                      );
                    },

                    child: const Text("YES"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.sendYesNo(
                        conversationId: widget.conversationId,
                        recipientId: widget.userId,
                        response: "NO",
                      );
                    },

                    child: const Text("NO"),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
