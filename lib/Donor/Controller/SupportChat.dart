import 'dart:convert';

import 'package:charity/Donor/Model/ChatConversation.dart';
import 'package:charity/Donor/Model/SupportMessage.dart';
import 'package:charity/baseUrl.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SupportChatController extends GetxController {
  RxList<ChatConversationModel> conversations = <ChatConversationModel>[].obs;

  RxList<SupportMessageModel> messages = <SupportMessageModel>[].obs;

  RxBool isLoading = false.obs;

  int userId = 0;

  @override
  void onInit() {
    super.onInit();

    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt("userId") ?? 0;

    fetchConversations();
  }

  // ===================================================
  // GET CONVERSATIONS
  // ===================================================

  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Chat/GetConversations?userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        conversations.value = data
            .map((e) => ChatConversationModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to load conversations");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===================================================
  // GET MESSAGES
  // ===================================================

  Future<void> getMessages({
    required int conversationId,
    required int userId,
  }) async {
    try {
      isLoading.value = true;

      var response = await http.get(
        Uri.parse(
          "${BaseapiController.BaseURL}Chat/GetMessages?conversationId=$conversationId&userId=$userId",
        ),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        messages.value = data
            .map((e) => SupportMessageModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to load messages");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===================================================
  // SEND TEXT MESSAGE
  // ===================================================

  Future<void> sendTextMessage({
    required int conversationId,
    required int recipientId,
    required String text,
  }) async {
    try {
      await http.post(
        Uri.parse("${BaseapiController.BaseURL}Chat/SendMessage"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "ConversationId": conversationId,

          "SenderId": userId,

          "RecipientId": recipientId,

          "MessageType": "TEXT",

          "MessageText": text,
        }),
      );

      await getMessages(conversationId: conversationId, userId: userId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ===================================================
  // SEND YES / NO
  // ===================================================

  Future<void> sendYesNo({
    required int conversationId,
    required int recipientId,
    required String response,
  }) async {
    try {
      await http.post(
        Uri.parse("${BaseapiController.BaseURL}Chat/SendMessage"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "ConversationId": conversationId,

          "SenderId": userId,

          "RecipientId": recipientId,

          "MessageType": "YES_NO",

          "MessageText": response,

          "ResponseValue": response,
        }),
      );

      await getMessages(conversationId: conversationId, userId: userId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
