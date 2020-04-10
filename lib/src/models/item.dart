class Item {
//  without photo
  final String _category;
  final String _title;
  final String _des;
  final int _daily;
  final int _monthly;
  final int _weekly;
  final int depo;

  Item(this._category,
      this._title,
      this._des, this._daily, this._monthly, this._weekly, this.depo);

  String get title => _title;
  int get daily => _daily;

}