import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:surgatani/screens/home_screen.dart';
import 'package:surgatani/utils/app_theme.dart';

// Import semua model data
import 'package:surgatani/models/pencatatan_tanaman_pangan_model.dart';
import 'package:surgatani/models/pencatatan_hortikultura_model.dart';
import 'package:surgatani/models/pencatatan_peternakan_model.dart';
import 'package:surgatani/models/pencatatan_perkebunan_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  await Hive.initFlutter();

  // Daftarkan SEMUA adapter
  Hive.registerAdapter(PencatatanTanamanPanganAdapter());
  Hive.registerAdapter(KomoditiAdapter());
  Hive.registerAdapter(PencatatanHortikulturaAdapter());
  Hive.registerAdapter(KomoditiSederhanaAdapter());
  Hive.registerAdapter(PencatatanPeternakanAdapter());
  Hive.registerAdapter(ItemPeternakanAdapter());
  Hive.registerAdapter(SubItemPeternakanAdapter());
  Hive.registerAdapter(PencatatanPerkebunanAdapter());

  // PERBAIKAN: Buka sebagai generic Box, bukan typed Box
  await Hive.openBox('tanaman_pangan_box');
  await Hive.openBox('hortikultura_box');
  await Hive.openBox('peternakan_box');
  await Hive.openBox('perkebunan_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SURGA TANI',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
