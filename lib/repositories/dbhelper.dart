final String tableNMame = 'parks';

class DBHelper{
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper(){
    return _instance;
  }

  DBHelper._internal();
}