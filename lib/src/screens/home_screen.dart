import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lendy/resources/firestore_provider.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/ChatBloc.dart';
import 'package:lendy/src/blocs/ExploreBloc.dart';
import 'package:lendy/src/blocs/HomeBloc.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';
import 'package:lendy/src/blocs/ListingsBloc.dart';
import 'package:lendy/src/screens/explore_screen.dart';
import '../blocs/PostsBloc.dart';
import 'borrowing_screen.dart';
import 'chat_screen.dart';
import 'lending_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

//  HomeScreen({Key key, @required this.uID}) : super(key: key);

}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  HomeBloc _homeBloc;
  ListingsBloc _listingsBloc = new ListingsBloc();

  ItemBloc bloc = new ItemBloc();
  ExploreBloc _exploreBloc = new ExploreBloc();
  ChatBloc _chatBloc = new ChatBloc();

//  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener((){
      if (_tabController.index==1){
        _listingsBloc.changefabStream(false);
      }
    });

    _homeBloc = new HomeBloc();
//    _tabController = new TabController(length: 2, vsync: );
  }

  @override
  void dispose() {
    super.dispose();
    _homeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _homeBloc.itemStream,
        initialData: _homeBloc.defaultItem,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: snapshot.data.index == 1
                ? AppBar(
                    title: Text("Listings"),
                    bottom: TabBar(
                      tabs: [
                        new Tab(
                          text: 'lending',
                        ),
                        new Tab(
                          text: 'borrowing',
                        )
                      ],
                      controller: _tabController,
                    ),
                  )
                : AppBar(
                    title: _nameChooser(snapshot.data),
                  ),
            body: snapshot.data.index == 1
                ? TabBarView(
                    children: [sLend(context, _listingsBloc), sBorrow(context, _listingsBloc)],
                    controller: _tabController,
                  )
                : _navChooser(context, snapshot.data, _listingsBloc, _exploreBloc, _chatBloc),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.explore), title: Text('Explore')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), title: Text('Listings')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat), title: Text('Chats')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Profile'))
              ],
              currentIndex: snapshot.data.index,
              onTap: _homeBloc.onItemTapped,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
            floatingActionButton: StreamBuilder(
              stream: _listingsBloc.fabStream,
              builder: (context, snapshot){
                if (snapshot.hasData && snapshot.data) {
                  return FloatingActionButton.extended(
                      onPressed: () => Navigator.of(context).pushNamed('/lend'),
                      icon: Icon(Icons.add),
                      label: Text("Add item")
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        });
  }

  Widget _nameChooser(data) {
    switch (data) {
      case NavBarItem.EXPLORE:
        return Text('Explore');
//    case NavBarItem.LISTINGS:
//      return listings();
      case NavBarItem.CHAT:
        return Text('Chat');
      case NavBarItem.PROFILE:
        return Text('Profile');
//                hopefully we never get down to default
      default:
        return Text('ERROR');
    }
  }

}


Widget listings() {
  return Text("DDD");

}

_navChooser(context, data,ListingsBloc listingsbloc, explorebloc, chatbloc) {
  // remove FAB on bottom
  listingsbloc.changefabStream(false);
  switch (data) {
    case NavBarItem.EXPLORE:
      return sExplore(context, explorebloc);
//    case NavBarItem.LISTINGS:
//      return listings();
    case NavBarItem.CHAT:
      return sChat(context, chatbloc);
    case NavBarItem.PROFILE:
      return wProfile();
//                hopefully we never get down to default
    default:
      return Center(child: Text('ERROR'));
  }

}

Widget wProfile() {
  return Container(
   child: RaisedButton(
       onPressed: () async {
         final FirebaseAuth _auth = FirebaseAuth.instance;
         await _auth.signOut();
       }
   ),
  );
}


