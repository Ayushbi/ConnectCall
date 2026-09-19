
import 'package:connectcall/Screens/Home/Homcontent.dart';
import 'package:connectcall/Screens/Riverpod/ScreenTheme.dart';
import 'package:connectcall/Screens/Splash/SplashScreen.dart';
import 'package:connectcall/Screens/auth/Registration.dart';
import 'package:connectcall/Screens/calling/audio.dart';
import 'package:connectcall/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp( ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isdark = ref.watch(Themeprovider);



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect Call',
      themeMode: isdark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(),
      home:Audio_calling()
    );
  }
}
