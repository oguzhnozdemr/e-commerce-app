import 'package:e_commerce_project/data/cubits/detail_cubit.dart';
import 'package:e_commerce_project/data/cubits/favorites_cubit.dart';
import 'package:e_commerce_project/data/repository/urunler_repository.dart';
import 'package:e_commerce_project/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/cubits/urunler_cubit.dart';
import 'data/cubits/sepet_cubit.dart';
import 'data/service/sepet_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UrunCubit(UrunlerRepository())..urunleriYukle(),
        ),
        BlocProvider(
          create: (context) => SepetCubit(SepetService(), "kullanici1"),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(),
        ),
        BlocProvider(
          create: (context) => DetailCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
