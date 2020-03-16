import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModelminLogin {
  int grupjk;
  TextEditingController edc_username = new TextEditingController();
  TextEditingController edc_password = new TextEditingController();

  FocusNode foc_username = new FocusNode();
  FocusNode foc_password= new FocusNode();
  bool hidePass=true;
}

class ModelminHome {
  ScrollController scrollController = new ScrollController();
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  String nama="";

  List dataAdmin;
}

class ModelminKelolaGejala{
  ScrollController scrollController = new ScrollController();
  List dataGejala;
  int reloadData = 0;
}

class ModelminTambahGejala{
  TextEditingController edc_gejala = new TextEditingController();

  FocusNode foc_gejala = new FocusNode();
}


class ModelminDetailGejala{
  List dataGejala;
  List dataHimpunan;
  String nama_gejala ="";
  String kode_gejala ="";
}

class ModelminPembentukanRule{
  List dataRule;
  bool isSearch = false;
  TextEditingController edc_search = new TextEditingController();
  FocusNode foc_search = new FocusNode();
  String wordSearch = "";
  bool isLoading = false;

}

class ModelminDetailRule{
  List dataRule;
  List dataGejala;
  int totalGejala = 0;
  List<String> rule;
}

class ModelminPelatihan{
  List data;
  bool isEmpty = true;
  bool isSearch = false;
  int jumlahData = 0;
  TextEditingController edc_search = new TextEditingController();
  FocusNode foc_search = new FocusNode();
  String wordSearch = "";
  int reloadData = 0;
  bool loading = false;
}

class ModelminPengujian{
  List data;
  bool isEmpty = true;
  bool isSearch = false;
  int jumlahData = 0;
  TextEditingController edc_search = new TextEditingController();
  FocusNode foc_search = new FocusNode();
  String wordSearch = "";
  int reloadData = 0;
  bool loading = false;
}

class ModelminHasilPelatihan{
  List data;
  int epoch = 0;
  double jumlahData  = 0;
  String bestBobot  = "";
  double bestBias   = 0;
  bool showProses = false;
  String title = "Hasil Pelatihan";
}

class ModelminHasilPengujian{
  List data;
  int epoch = 0;
  double jumlahData  = 0;
  double jumlahakurat = 0;
  double presentasiAkurat = 0;
  bool showProses = false;
  String title = "Hasil Pengujian";
}

class ModelminPencegahan{
  int reloadData = 0;
  String nama = "";
  String ket = "";
  List data ;
}

class ModelminSolusi{
  int reloadData = 0;
  String nama = "";
  String ket = "";
  List data ;
}

class ModelminKelolaUser{
  List data ;
  int reloadData = 0;
  DateTime dateNow = DateTime.now();
}

class ModelminDetailUser{
  List data;
  String nama = "";
  String username = "";
  String password = "";
  String jk = "";
  String tmp_lahir = "";
  String tgl_lahir = "";
  String alamat = "";
  String nohp = "";
  String tgl_daftar = "";
  String id_user = "";
  double fullWidth = 0;
  double fullHeight = 0;
  ScrollController scrollController = new ScrollController();
}

class ModelminEditUser{
  ScrollController scrollController = new ScrollController();
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  String nama="";
  int id = 0;
  int jk = null;
  List dataUser;
  String tmp_lahir = "";
  String tgl_lahir = "";
  String nohp = "";
  String alamat = "";
  String jekel = "";
  String tgl_daftar = "";
  int grupjk;
  InputType inputType = InputType.date;
  final formats = {
    InputType.date: DateFormat('yyyy-MM-dd'),
  };
  bool editable = true;
  DateTime date;

  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_tmplahir = new TextEditingController();
  TextEditingController edc_tgllahir = new TextEditingController();
  TextEditingController edc_alamat = new TextEditingController();
  TextEditingController edc_nohp = new TextEditingController();


  FocusNode foc_nama = new FocusNode();
  FocusNode foc_tmplahir = new FocusNode();
  FocusNode foc_tgllahir = new FocusNode();
  FocusNode foc_alamat = new FocusNode();
  FocusNode foc_nohp = new FocusNode();
}

class ModelminTambahUser{
  ScrollController scrollController = new ScrollController();
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  String nama="";
  int id = 0;
  int jk = null;
  List dataUser;
  String tmp_lahir = "";
  String tgl_lahir = "";
  String nohp = "";
  String alamat = "";
  String jekel = "";
  String tgl_daftar = "";
  int grupjk;
  InputType inputType = InputType.date;
  final formats = {
    InputType.date: DateFormat('yyyy-MM-dd'),
  };
  bool editable = true;
  DateTime date;
  TextEditingController edc_username = new TextEditingController();
  TextEditingController edc_password = new TextEditingController();
  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_tmplahir = new TextEditingController();
  TextEditingController edc_tgllahir = new TextEditingController();
  TextEditingController edc_alamat = new TextEditingController();
  TextEditingController edc_nohp = new TextEditingController();

  FocusNode foc_username = new FocusNode();
  FocusNode foc_password = new FocusNode();
  FocusNode foc_nama = new FocusNode();
  FocusNode foc_tmplahir = new FocusNode();
  FocusNode foc_tgllahir = new FocusNode();
  FocusNode foc_alamat = new FocusNode();
  FocusNode foc_nohp = new FocusNode();

  bool hidePass = true;
}

class ModelminMetode {
  ScrollController scrollController = new ScrollController();
  TabController tabController;
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  int id = 0;

  List variabel;
  List dataKonsul;
  List dataRuleFuzzy;
  bool showJawaban = false;
  var data;
  var bobot;
  double bias;
  bool showVariabel =false;
  bool showPerhitungan =false;
  bool showFuzzifikasi = false;
  bool showMesin = false;
  bool showDefuzzifikasi = false;

  String lihatHitungan;

}

class ModelminUbahPassword{
  FocusNode foc_password = new FocusNode();
  TextEditingController edc_password = new TextEditingController();
  bool hidePass=true;
}

class ModelminTambahPencegahan{
  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_ket = new TextEditingController();

  FocusNode foc_nama = new FocusNode();
  FocusNode foc_ket = new FocusNode();

}
class ModelminEditPencegahan{
  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_ket = new TextEditingController();

  FocusNode foc_nama = new FocusNode();
  FocusNode foc_ket = new FocusNode();
  List data;

//  String nama="";
//  String ket="";

}

class ModelminTambahSolusi{
  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_ket = new TextEditingController();

  FocusNode foc_nama = new FocusNode();
  FocusNode foc_ket = new FocusNode();

}
class ModelminEditSolusi{
  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_ket = new TextEditingController();

  FocusNode foc_nama = new FocusNode();
  FocusNode foc_ket = new FocusNode();
  List data;

//  String nama="";
//  String ket="";

}

class ModelminKelolaLaporan{
  ScrollController scrollController = new ScrollController();
  List dataGejala;
  int reloadData = 0;
}
