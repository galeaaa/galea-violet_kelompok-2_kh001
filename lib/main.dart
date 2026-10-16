// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       //home
//       home : const HomePage()
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage ({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;
//
//   final List<Widget> pages = const [
//     HomeContent(),
//     // Content2(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar : AppBar(
//         title : const Text("GaleaApp"),
//       ),
//       body: pages[currentIndex],
//
//       bottomNavigationBar : BottomNavigationBar(
//         currentIndex: currentIndex,
//
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label : 'settings'
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class HomeContent extends StatelessWidget {
//   const HomeContent({super.key});
//
//   @override
//   Widget build(BuildContext context){
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//           "Selamat Datang",
//         style: TextStyle(
//
//           color: Colors.green,
//         ),
//       ),
//       const Padding(padding: EdgeInsets.only(bottom:20)),
//           Container(
//             width : 200,
//             height: 30,
//             color: Colors.grey,
//           ),
//           const Padding(padding: EdgeInsets.only(bottom:20)),
//           Container(
//             width: 400,
//             height: 20,
//             color: Colors.grey,
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                     height: 50,
//                     color: Colors.red,
//                   ),
//               ),
//               const SizedBox(width : 12),
//               Expanded(
//                   child: Container(
//                     height: 50,
//                     color: Colors.red,
//                   ),
//               ),
//               Expanded(
//               child: Container(
//               height: 50,
//               color: Colors.red,
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'widgets/buttons.dart';
import 'theme/app_theme.dart';
import 'contants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, //pakai warna dari colors.dart
      appBar: AppBar(
        title: const Text('Design System Demo'),
        backgroundColor: AppColors.primary,
      ),

      body: Container(
        color: AppColors.background, // background biru dari colors.dart
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Universitas Esa Unggul',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary, // pakai warna pink dari colors.dart
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tekan tombol di bawah untuk melihat profil GitHub.',
            ),

            const SizedBox(height: 24),

            AppButton(
              label: 'Buka Github',
              icon: Icons.location_on,
              url:
              'https://github.com/galeaaa',
            ),

            const SizedBox(height: 16),

            AppButton(
              label: 'Klik untuk melihat profil GitHub',
              icon: Icons.touch_app,
              onPressed: () {
                debugPrint('Tombol berhasil ditekan!');
              }, url: 'https://github.com/galeaaa',
            ),
          ],
        ),
      ),
    );
  }
}