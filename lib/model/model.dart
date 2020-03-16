import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class ModelSplashscreen {
  bool isNew = false;
  int aktif;
  int jumlah;

}

class ModelKonsultasi {
  String ketGejala;
  String gejala;
  int mulaiGejala = 0;
  int maksGejala;
  double fullWidth;
  double fullHeight;

  bool select_tidak = false;
  bool select_mungkin = false;
  bool select_iya =false;
  int jawaban = 0;
  List dataGejala = null;

  int id ;
  String nama = "";
  String jk = "";
  int umur = 0;
  String nohp = "";
  String pola_jawaban;
  bool loading = false;
  List dataUser;

}

class ModelHasilKonsultasi{
  int fy = 0;
  List data;
  String nama ="";
  bool loading = false;
}


class ModelHome {
  ScrollController scrollController = new ScrollController();
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  String nama="";
  int id = 0;
  int jk = null;
  List dataUser;

}

class ModelLihatProses {
  ScrollController scrollController = new ScrollController();
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  int id = 0;

  List variabel;
  List dataKonsul;
  List ruleFuzzy;
  bool showJawaban = false;
  var data;
  var bobot;
  double bias;
  bool showVariabel =false;
  bool showPerhitungan =false;

  String lihatHitungan;

}

class ModelDownloadPDF {
  ScrollController scrollController = new ScrollController();
  bool lastStatus = true;
  double fullWidth = 0;
  double fullHeight = 0;
  int id = 0;

  List variabel;
  List dataKonsul;
  bool showJawaban = false;
  var data;
  var bobot;
  double bias;
  bool showVariabel =false;
  bool showPerhitungan =false;

  String lihatHitungan;
  String id_konsul;

}

class ModelProfilUser {
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
}

class ModelTentang {
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
}

class ModelEditProfil {
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

class ModelPenyakit {
  String nama = "";
  String ket = "";
  List data;
}

class ModelDataDiri {
  int grupjk;

  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_umur = new TextEditingController();
  TextEditingController edc_nohp = new TextEditingController();


  FocusNode foc_nama = new FocusNode();
  FocusNode foc_umur = new FocusNode();
  FocusNode foc_nohp = new FocusNode();

}

class ModelRegister {
  int grupjk;
  TextEditingController edc_username = new TextEditingController();
  TextEditingController edc_password = new TextEditingController();
  TextEditingController edc_nama = new TextEditingController();
  TextEditingController edc_umur = new TextEditingController();
  TextEditingController edc_nohp = new TextEditingController();

  FocusNode foc_username = new FocusNode();
  FocusNode foc_password = new FocusNode();
  FocusNode foc_nama = new FocusNode();
  FocusNode foc_umur = new FocusNode();
  FocusNode foc_nohp = new FocusNode();

  bool hidePass =true;

}

class ModelLogin {
  TextEditingController edc_username = new TextEditingController();
  TextEditingController edc_password = new TextEditingController();

  FocusNode foc_username = new FocusNode();
  FocusNode foc_password = new FocusNode();
  bool loading = false;

  List dataLogin;
  int jum=0;
  bool hidePass = true;
}

class ModelPilihAkun {
  int reloadData = 0;
}

class ModelHistory {
  String id;
  bool loading = false;
}
