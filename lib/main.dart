import 'package:chickenaccount/firebase_options.dart';
import 'package:chickenaccount/screens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chickenaccount/screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyCE_Lgbsd_qzmIAX5R9Bm0gBlUXUDU6sUs',
            appId: "1:167830565516:web:b5e50f7f97e6c0c1eb01a9",
            messagingSenderId: "167830565516",
            projectId: "al-jilani-chicken-account",
            storageBucket: "al-jilani-chicken-account.appspot.com"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  /*const keyApplicationId = 'U3REz6bKFFysqQyzUsHdm9kwoaIkCno2PNoyoFG0';
  const keyClientKey = 'H8wAcvr5D3vw3NihlmBDXtFhAj0Yuu1hvI4mNzGc';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);*/
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /* ParseUser? currentUser;

  Future<bool> hasUserLogged() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }*/

  Future<bool> hasUserLogged() async {
    return false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicken Account',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
          future: hasUserLogged(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Scaffold(
                  body: Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  ),
                );
              default:
                if (snapshot.hasData && snapshot.data!) {
                  return const Home();
                  // return UserPage();
                } else {
                  return const LoginScreen();
                }
            }
          }),
    );
  }

  /*userpagelogin() {
    Future currentUser = ParseUser.currentUser();
    if (currentUser != null) {
      //runApp(const LoginScreen());
    } else {
      // runApp(const Home());
    }
  }*/
}
