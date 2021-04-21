import 'package:chat21_flutter/view/loginpageView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat21_flutter/view/homeView.dart';
import 'package:chat21_flutter/routes.dart';
import 'package:provider/provider.dart';
import 'package:chat21_flutter/controller/firebaseController.dart';
// import 'package:crm_flutter/screens/home_screen.dart';

// void main() {
// runApp(MultiProvider(
//   providers: [
//     // ChangeNotifierProvider(builder: (BuildContext context) => FirebaseAccount()),
//     ChangeNotifierProvider<FirebaseAccount>(
//           create: (context) => FirebaseAccount(),
//         ),
//   ],
//   child: MyApp(),
// ));
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<FirebaseController>(
        create: (context) => FirebaseController(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueGrey,
          textTheme: ButtonTextTheme.primary,
        ),
        // primaryColor: Colors.lightBlue,
        // accentColor: Color(0xFFFEF9EB),
      ),
      // home: HomeScreen(),
      // home: MyHomePage(title: 'Denovortho'),
      routes: {
        Routes.login: (context) => LoginpageView(),
        Routes.home: (context) => HomeView(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.root:
            return MaterialPageRoute(builder: (context) => LoginpageView());
          default:
            return MaterialPageRoute(builder: (context) => LoginpageView());
        }
      },
    );
  }
}
