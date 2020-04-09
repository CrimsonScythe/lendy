import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/HomeBloc.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';
import '../blocs/PostsBloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

//  HomeScreen({Key key, @required this.uID}) : super(key: key);

}

class HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;

  ItemBloc bloc = new ItemBloc();

//  TabController _tabController;

  @override
  void initState() {
    super.initState();
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
            appBar: new AppBar(
              title: Text("Home"),
            ),
            body: _navChooser(snapshot.data),
              bottomNavigationBar:
                  stream: _homeBloc.itemStream,
                  initialData: _homeBloc.defaultItem,
                  builder: (context, snapshot) {
                    return BottomNavigationBar(
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
                    );
                  }
          );
        }
    );
    return Scaffold(
        appBar: new AppBar(
          title: Text("Home"),
        ),
        body: StreamBuilder(
          stream: _homeBloc.itemStream,
          initialData: _homeBloc.defaultItem,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case NavBarItem.EXPLORE:
                return Text('EXPLORE');
              case NavBarItem.LISTINGS:
                return listings();
              case NavBarItem.CHAT:
                return Text('CHAT');
              case NavBarItem.PROFILE:
                return Text('PROFILE');
//                hopefully we never get down to default
              default:
                return Center(child: Text('ERROR'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/lend');
          },
          label: Text('Lend'),
          icon: Icon(Icons.add),
        ),
        bottomNavigationBar: StreamBuilder(
            stream: _homeBloc.itemStream,
            initialData: _homeBloc.defaultItem,
            builder: (context, snapshot) {
              return BottomNavigationBar(
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
              );
            })
    );
  }

  Widget listings() {

//    return DefaultTabController(
//      length: 2,
//      child: Scaffold(
//        appBar: new AppBar(
//          title: Text('Listings'),
//          bottom: TabBar(
//            tabs: [
//              new Tab(
//                text: 'lend',
//              ),
//              new Tab(
//                text: 'borrow',
//              )
//            ],
//          ),
//        ),
//        body: TabBarView(
//          children: [new Text('lend'), new Text('borrow')],
//        ),
//      ),
//    );
  }

  _navChooser(data) {
    switch (data) {
      case NavBarItem.EXPLORE:
        return Text('EXPLORE');
      case NavBarItem.LISTINGS:
        return listings();
      case NavBarItem.CHAT:
        return Text('CHAT');
      case NavBarItem.PROFILE:
        return Text('PROFILE');
//                hopefully we never get down to default
      default:
        return Center(child: Text('ERROR'));
    }
  }
}
