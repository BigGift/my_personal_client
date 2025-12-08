import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test0001/screens/pages/MusicDebugPage.dart';
import 'package:test0001/screens/pages/music_page.dart';
import 'package:test0001/screens/pages/my_home_page.dart';
import 'package:test0001/screens/pages/photos_page.dart';
import 'package:test0001/screens/tabs/diary_tab.dart';
import 'dart:io';

import 'package:test0001/screens/tabs/music_tab.dart';
import 'package:test0001/screens/tabs/photo_tab.dart';




void main() {
  runApp(
    // Riverpod 全局作用域
    const ProviderScope(
      child: MyApp(),
    ),
  );
  //httpRequest();
  //dioGetHttp();
}



// void dioGetHttp() async {
//   //final response = await dio.get('https://dart.dev');
//   final response = await dio.get('http://192.168.50.227:8080/user/2');
//   print("archer；  == $response");
// }


// Future<void> httpRequest() async {
//   //request http
//   String url = 'http://www.baidu.com';
//   //String url = 'http://192.168.50.227:8080/user/2';
//   HttpClient client = HttpClient();
//   HttpClientRequest request = await client.getUrl(Uri.parse(url));
//   HttpClientResponse response = await request.close();
//   print(response.statusCode);
//   var result = await response.transform(utf8.decoder).join();
//   print(result);
//   client.close();
// }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大米的主页',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.green),
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.orange
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}