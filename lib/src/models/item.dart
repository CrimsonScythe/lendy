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

  Item(this._category,
      this._title,
      this._des, this._daily, this._monthly, this._weekly, this.depo, this._urls);

  String get title => _title;
  int get daily => _daily;
  List get urls => _urls;

  int get weekly => _weekly;


  int get monthly => _monthly;


  String get des => _des;


  String get category => _category;

  List get prices {
    var list = new List<int>();
    list.add(_daily);
    list.add(_weekly);
    list.add(_monthly);
    return list;
  }


}