class Item {
//  without photo
  final String _category;
  final String _title;
  final String _des;
  final int _daily;
  final int _monthly;
  final int _weekly;
  final int depo;
  final List _urls;
  final String _docID;
  final List _imgNames;
  final String _userName;
  final String _userProfileUrl;
  final String _uID;

  Item(this._category,
      this._title,
      this._des,
      this._daily,
      this._monthly,
      this._weekly,
      this.depo,
      this._urls,
      this._docID,
      this._imgNames,
      this._userName,
      this._userProfileUrl,
      this._uID
      );

  String get docID => _docID;

  String get userName => _userName;
  String get userProfileUrl => _userProfileUrl;

  String get title => _title;
  int get daily => _daily;
  List get urls => _urls;

  int get weekly => _weekly;


  int get monthly => _monthly;


  String get des => _des;

  List get imgNames => _imgNames;


  String get category => _category;

  List get prices {
    var list = new List<int>();
    list.add(_daily);
    list.add(_weekly);
    list.add(_monthly);
    return list;
  }


}