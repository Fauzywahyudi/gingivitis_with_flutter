import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;


class DBHelper{

  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper()=> _instance;

  static Database _db;

  // db info
  static final nm_db= "tes1";
  static final versi_db= 1;


  // tabel
  static final tb_user="user";
  static final tb_jawaban="jawaban";

  // column
  static final _id  ="id";
  static final _nama="nama";
  static final _jk  ="jk";
  static final _umur="umur";
  static final _nohp="nohp";
  static final _tgl_buat="tgl_buat";
  static final _status="status";
  static final _kode_gejala = "kode_gejala";
  static final _jawaban = "jawaban";
  static final _username = "username";
  static final _password = "password";
  static final _simpan = "simpan";



  Future<Database> get db async{
    if(_db!=null)return _db;
    _db=await setDB();
    return _db;
  }

  setDB()async{
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,nm_db);
    var dB = await openDatabase(path,version: versi_db,onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db,int version) async{
    await db.execute("CREATE TABLE $tb_user ($_id INTEGER PRIMARY KEY, "
        "$_nama TEXT, "
        "$_username TEXT, "
        "$_password TEXT NULL, "
        "$_simpan TEXT, "
        "$_status TEXT)");

    await db.execute("CREATE TABLE $tb_jawaban ($_id INTEGER PRIMARY KEY, "
        "$_kode_gejala TEXT, "
        "$_jawaban TEXT)");

    print("DB $nm_db Created");
  }

//  Future<int> loginAdmin(String username, String password)async {
//    var dbClient = await  db;
//    int res = await dbClient.rawUpdate("");
//    if(res==1){
//      print("sukses");
//    }else{
//      print("gagal");
//    }
//    return res;
//  }



  Future<int> addData(String username,String password,String nama,int id, String status)async {
    var dbClient = await  db;
    String stat;
    if(status.isEmpty){
      stat="off";
    }else{
      stat="aktif";
    }
    int res = await dbClient.rawUpdate("INSERT INTO $tb_user($_id,$_nama,$_username,$_password,$_simpan,$_status) VALUES('$id','$nama','$username','$password','1','$stat')");
    if(res==1){
      print("sukses");
    }
    return res;
  }

  Future<List> getAkun ()async{
    var dbClient = await  db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM $tb_user");
    return list;
  }

  Future<int> delAkun (int id) async{
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("DELETE FROM $tb_user WHERE $_id='$id'");
    return res;
  }

  Future<int> editAkun (int id, String nama) async{
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("UPDATE $tb_user SET nama='$nama' WHERE $_id='$id'");
    return res;
  }

  Future<int> delPass (int id) async{
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("UPDATE $tb_user SET $_password='' WHERE $_id='$id'");
    return res;
  }

  Future<int> login (int id) async{
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("UPDATE $tb_user SET $_status='aktif' WHERE $_id='$id'");
    return res;
  }

  Future<int> updatePassword (int id,String password) async{
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("UPDATE $tb_user SET $_password='$password' WHERE $_id='$id'");
    return res;
  }

  Future<List> ceklogin (int id) async{
    var dbClient = await  db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM $tb_user WHERE $_id='$id'");
    return list;
  }

  Future<int> logout (int id) async{
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("UPDATE $tb_user SET $_status='off' WHERE $_id='$id'");
    return res;
  }

  Future<int> jawaban(String kode_gejala, int jawaban)async {
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("INSERT INTO $tb_jawaban($_id,$_kode_gejala,$_jawaban) VALUES(null,'$kode_gejala',$jawaban)");
    return res;
  }

  Future<int> resetJawaban()async {
    var dbClient = await  db;
    int res = await dbClient.rawUpdate("DELETE FROM $tb_jawaban");
    if(res==1){
      print("sukses reset");
    }
    return res;
  }

  Future<List> getJawaban()async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM $tb_jawaban");
    return list;
  }

  Future<List> getData()async {
    var dbClient = await db;
    String status="aktif";
    List<Map> list = await dbClient.rawQuery("SELECT * FROM $tb_user WHERE $_status='$status'");
    return list;
  }

  Future<int> cekAkun(int id,String username)async {
    var dbClient = await db;
    int res = Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tb_user WHERE $_username='$username' AND $_id='$id'"));
    return res;
  }

  Future<int> cekUser(String type) async{
    var dbclient = await db;

    if(type=="aktif"){
      int res = Sqflite
          .firstIntValue(await dbclient.rawQuery("SELECT COUNT(*) FROM $tb_user WHERE $_status='aktif' "));
      return res;
    }else{
      int res = Sqflite
          .firstIntValue(await dbclient.rawQuery('SELECT COUNT(*) FROM $tb_user '));
      return res;
    }

  }

}