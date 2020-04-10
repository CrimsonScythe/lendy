import 'dart:async';
import 'package:lendy/src/blocs/validators.dart';

enum NavBarItem {EXPLORE, LISTINGS, CHAT, PROFILE}

class HomeBloc extends Object with Validators {

 final _navBarController = StreamController<NavBarItem>.broadcast();
 NavBarItem defaultItem = NavBarItem.EXPLORE;

 Stream<NavBarItem> get itemStream => _navBarController.stream;

 


 void onItemTapped(int i){
   switch (i) {
     case 0:
       _navBarController.sink.add(NavBarItem.EXPLORE);
       break;
     case 1:
       _navBarController.sink.add(NavBarItem.LISTINGS);
       break;
     case 2:
       _navBarController.sink.add(NavBarItem.CHAT);
       break;
     case 3:
       _navBarController.sink.add(NavBarItem.PROFILE);
       break;

   }
 }



  reset() {
//    _daily.drain();
//    _weekly.drain();
//    _monthly.drain();
//    _deposit.drain();
//    _showProgress.drain();
  }

  dispose() async {
    // TODO: call close somewhere !
    _navBarController.close();
  }
}
