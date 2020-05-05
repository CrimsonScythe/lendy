import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:lendy/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc extends Object{

  final _repository = Repository();

  final _showProgress = BehaviorSubject<bool>();

  final _messages = BehaviorSubject<QuerySnapshot>();

  ChatUser chatUser, otherUser;

  String chatID;



  Stream<bool> get showProgress => _showProgress.stream;

  Stream<QuerySnapshot> get messagesStream => _repository.getMessages(chatID);

  Stream<QuerySnapshot> get chatsStream => _repository.getChats(_repository.userName).asStream();

//  Stream<QuerySnapshot> messagesStream(chatID) {
//    _repository.getMessages(chatID);
//    return getMessages(chatID);
//  }



  void createChatUsers (u2ID, name2, purl2) {

    var user = _repository.createChatUsers(
        [_repository.user_ID, u2ID],
        [_repository.userName, name2],
        [_repository.userProfileUrl, purl2]
    );

    chatUser = user[0];
    otherUser = user[1];

  }

  String createChat(u2ID, u2Name, prodID, prodName, prodUrl) {

    _showProgress.sink.add(true);

    _repository.createChat(_repository.user_ID, _repository.userName, u2ID, u2Name, prodID, prodUrl, prodName)
    .then((value){
      _showProgress.sink.add(false);
    });

    String chatID = _repository.user_ID.toString()+u2ID.toString()+prodID.toString();

    return chatID;

  }

//  Stream<QuerySnapshot> getMessages(chatID) {
//
//    _repository.getMessages(chatID)
//        .then((value){
//          if (value != null) {
//            _messages.sink.add(value);
//          }
//    });
//
//    return _messages.stream;
//
//  }

  void sendMessage(chatID, message) {

    _repository.sendMessage(chatID, message);

  }

  String extractName(snapshot, i) {

    var list = snapshot.data.documents[i].data["owner"];
    var index = list.indexOf(_repository.userName);
    index = 1 - index;
    return list[index];

  }

}