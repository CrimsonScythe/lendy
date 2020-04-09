import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendy/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PostsBloc{

  final _repository = Repository();

  final _showProgress = BehaviorSubject<bool>();

  FirebaseUser firebaseUser;

  PostsBloc();

  Stream<bool> get showProgress => _showProgress.stream;

  void upload(pID) {
    print(_repository.user_ID);
    _showProgress.sink.add(true);
//    _repository
//    .uploadPic(_repository.user_ID, pID)
//    .then((value) {
//      _showProgress.sink.add(false);
//    });
  }


}