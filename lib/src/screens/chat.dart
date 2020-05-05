import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lendy/src/blocs/ChatBloc.dart';

class Chat extends StatefulWidget {

  final ChatBloc bloc;
  final String chatID;

  @override
  _ChatState createState() => _ChatState();

  Chat({Key key, @required this.bloc, @required this.chatID});

}

class _ChatState extends State<Chat> {


  @override
  void initState() {
    super.initState();

    widget.bloc.chatID=widget.chatID;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder(
      stream: widget.bloc.messagesStream,
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        } else{
          List<DocumentSnapshot> items = snapshot.data.documents;
          var messages =
          items.map((i) => ChatMessage.fromJson(i.data)).toList();
          return DashChat(
            inverted: false,
            onSend: onSend,
            sendOnEnter: true,
            textInputAction: TextInputAction.send,
            user: widget.bloc.chatUser,
            inputDecoration:
            InputDecoration.collapsed(hintText: "Add message here..."),
            dateFormat: DateFormat('yyyy-MMM-dd'),
            timeFormat: DateFormat('HH:mm'),
            messages: messages,
            showUserAvatar: false,
            showAvatarForEveryMessage: false,
            scrollToBottom: false,
            onPressAvatar: (ChatUser user) {
              print("OnPressAvatar: ${user.name}");
            },
            onLongPressAvatar: (ChatUser user) {
              print("OnLongPressAvatar: ${user.name}");
            },
            inputMaxLines: 5,
            messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
            alwaysShowSend: true,
            inputTextStyle: TextStyle(fontSize: 16.0),
            inputContainerStyle: BoxDecoration(
              border: Border.all(width: 0.0),
              color: Colors.white,
            ),
            onLoadEarlier: () {
              print("laoding...");
            },
            shouldShowLoadEarlier: false,
            showTraillingBeforeSend: true,
            trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
//                    File result = await ImagePicker.pickImage(
//                      source: ImageSource.gallery,
//                      imageQuality: 80,
//                      maxHeight: 400,
//                      maxWidth: 400,
//                    );
//
//                    if (result != null) {
//                      final StorageReference storageRef =
//                      FirebaseStorage.instance.ref().child("chat_images");
//
//                      StorageUploadTask uploadTask = storageRef.putFile(
//                        result,
//                        StorageMetadata(
//                          contentType: 'image/jpg',
//                        ),
//                      );
//                      StorageTaskSnapshot download =
//                      await uploadTask.onComplete;
//
//                      String url = await download.ref.getDownloadURL();
//
//                      ChatMessage message =
//                      ChatMessage(text: "", user: user, image: url);
//
//                      var documentReference = Firestore.instance
//                          .collection('messages')
//                          .document(DateTime.now()
//                          .millisecondsSinceEpoch
//                          .toString());
//
//                      Firestore.instance.runTransaction((transaction) async {
//                        await transaction.set(
//                          documentReference,
//                          message.toJson(),
//                        );
//                      });
//                    }
                  },
                )
              ],
          );
        }
        return Container();
      },
    ),
    );

  }

  onSend(ChatMessage message) {

    widget.bloc.sendMessage(widget.chatID, message);

//  var fire = Firestore.instance;

//  QuerySnapshot snap =  await fire.collectionGroup("messages").where("owner", arrayContains: "haseeb").getDocuments();
//  QuerySnapshot snap = await fire.collection("chats").document("1").collection('messages').where("owner", arrayContains: "haseeb").getDocuments();
//    CollectionReference snap = await fire.collection("chats").document("1").collection('messages');
//    print("ID IS:" + snap[0].documentID.toString());

//    print("ID IS:" + snap.documents[0].documentID.toString());
  }

}
