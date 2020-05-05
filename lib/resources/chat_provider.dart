import 'package:dash_chat/dash_chat.dart';

class ChatProvider {

   List<ChatUser> createChatUsers(List<String> uID, List<String> name, List<String> purl) {
     List<ChatUser> chatUsers = [];
     chatUsers.add(ChatUser(uid: uID[0], name: name[0], avatar: purl[0]));
     chatUsers.add(ChatUser(uid: uID[1], name: name[1], avatar: purl[1]));

     return chatUsers;

  }

}