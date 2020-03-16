import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'activity/user/home.dart';
import 'activity/user/konsultasi.dart';
import 'activity/user/info_gejala.dart';
import 'activity/user/info_penyakit.dart';
import 'activity/user/pencegahan.dart';
import 'activity/user/solusi.dart';
import 'splashscreen.dart';
import 'activity/user/register.dart';
import 'activity/user/login_user.dart';
import 'activity/user/pilih_akun.dart';
import 'activity/user/profil.dart';
import 'activity/user/edit_profil.dart';
import 'activity/user/tentang.dart';
import 'activity/user/history_konsultasi.dart';
import 'activity/user/lihat_proses.dart';
import 'activity/user/download_pdf.dart';



import 'activity/admin/login_admin.dart';
import 'activity/admin/home_admin.dart';
import 'activity/user/hasil_konsultasi.dart';
import 'activity/admin/gejala/kelola_gejala.dart';
import 'activity/admin/laporan_konsultasi.dart';
import 'activity/admin/pembentukan_rule.dart';
import 'activity/admin/pelatihan_perceptron.dart';
import 'activity/admin/hasil_pelatihan.dart';
import 'activity/admin/pengujian_perceptron.dart';
import 'activity/admin/gejala/tambah_gejala.dart';
import 'activity/admin/tes.dart';
import 'activity/admin/hasil_pengujian.dart';
import 'activity/admin/informasi/kelola_informasi.dart';
import 'activity/admin/informasi/informasi_pencegahan.dart';
import 'activity/admin/informasi/informasi_solusi.dart';
import 'activity/admin/informasi/detail_pencegahan.dart';
import 'activity/admin/informasi/detail_solusi.dart';
import 'activity/admin/user/kelola_user.dart';
import 'activity/admin/user/tambah_user.dart';
import 'activity/admin/informasi/tambah_pencegahan.dart';
import 'activity/admin/informasi/tambah_solusi.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Diagnosa Gingivitis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/konsultasi': (BuildContext context) => new Konsultasi(),
        '/infopenyakit': (BuildContext context) => new InfoPenyakit(),
        '/infogejala': (BuildContext context) => new InfoGejala(),
        '/pencegahan': (BuildContext context) => new Pencegahan(),
        '/solusi': (BuildContext context) => new Solusi(),
        '/home': (BuildContext context) => new HomePage(),
        '/splashscreen': (BuildContext context) => new Splashscreen(),
        '/hasilkonsultasi': (BuildContext context) => new HasilKonsultasi(),
        '/register': (BuildContext context) => new Register(),
        '/loginuser': (BuildContext context) => new LoginUser(username: "",),
        '/pilihakun': (BuildContext context) => new PilihAkun(),
        '/profil': (BuildContext context) => new ProfilUser(),
        '/editprofil': (BuildContext context) => new EditProfil(),
        '/tentang': (BuildContext context) => new Tentang(),
        '/history': (BuildContext context) => new HistoryKonsultasi(),
        '/lihatproses': (BuildContext context) => new LihatProses(),
//        '/downloadpdf': (BuildContext context) => new WebViewTest(),



        '/loginadmin': (BuildContext context) => new LoginAdmin(),
        '/homeadmin': (BuildContext context) => new HomeAdmin(),
        '/kelolagejala': (BuildContext context) => new KelolaGejala(),
        '/tambahgejala': (BuildContext context) => new TambahGejala(),

        '/laporankonsultasi': (BuildContext context) => new LaporanKonsultasi(),
        '/pembentukkanrule': (BuildContext context) => new PembentukanRule(),
        '/pelatihan': (BuildContext context) => new PelatihanPerceptron(),
        '/hasilpelatihan': (BuildContext context) => new HasilPelatihan(),
        '/pengujian': (BuildContext context) => new PengujianPerceptron(),
        '/hasilpengujian': (BuildContext context) => new HasilPengujian(),
        '/kelolainformasi': (BuildContext context) => new KelolaInformasi(),
        '/kelolapencegahan': (BuildContext context) => new KelolaPencegahan(),
        '/kelolasolusi': (BuildContext context) => new KelolaSolusi(),

        '/kelolauser': (BuildContext context) => new KelolaUser(),
        '/tambahuser': (BuildContext context) => new TambahUser(),

        '/tambahpencegahan': (BuildContext context) => new TambahPencegahan(),
        '/tambahsolusi': (BuildContext context) => new TambahSolusi(),

      },
      home: Splashscreen(),
    );
  }
}
