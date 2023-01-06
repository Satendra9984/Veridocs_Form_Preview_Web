import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veridocs_web_form_preview/form_preview.dart';
import 'package:veridocs_web_form_preview/form_screens/form_result_home_page.dart';
import 'package:veridocs_web_form_preview/form_screens/home_page.dart';

import 'app_provider/form_provider.dart';
import 'home_page.dart';
// List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   // cameras = await availableCameras();
  // } on CameraException catch (e) {
  //   print('Error in fetching the cameras: $e');
  // }
  const firebaseConfig = {
    'apiKey': "AIzaSyA0KGfaOxma0G8tbmB_PEydfbvC7g5eOr0",
    'authDomain': "veridox-68b89.firebaseapp.com",
    'databaseURL':
        "https://veridox-68b89-default-rtdb.asia-southeast1.firebasedatabase.app",
    'projectId': "veridox-68b89",
    'storageBucket': "veridox-68b89.appspot.com",
    'messagingSenderId': "217484249170",
    'appId': "1:217484249170:web:e6e00a838b72fcd236778b",
    'measurementId': "G-BKG5HBEPY9"
  };
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      databaseURL: firebaseConfig['databaseURL']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      appId: firebaseConfig['appId']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      measurementId: firebaseConfig['measurementId']!,
    ),
  );
  runApp(const VeridocsPreview());
}

class VeridocsPreview extends StatefulWidget {
  const VeridocsPreview({super.key});

  @override
  State<StatefulWidget> createState() => _VeridocsPreviewState();
}

class _VeridocsPreviewState extends State<VeridocsPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => FormProvider())],
      child: MaterialApp(
        title: 'Books App',
        // home: const HomePage(),
        routes: {
          '/': (context) => FormResultHomePage(caseId: '20230515180'),
        },
        onGenerateRoute: (settings) {
          // Handle '/'
          debugPrint('onGenerateRoute\n');
          // if (settings.name == '/') {
          //   return MaterialPageRoute(builder: (context) => HomePage());
          // }

          // Handle '/details/:id'
          var uri = Uri.parse(settings.name!);
          if (uri.pathSegments.length == 2 &&
              uri.pathSegments.first == 'preview') {
            var id = uri.pathSegments[1];
            debugPrint('id parsed -> $id');
            return MaterialPageRoute(
                builder: (context) => FormPreviewHomePage(agencyId: id));
          }
          if (uri.pathSegments.length == 2 &&
              uri.pathSegments.first == 'result') {
            var id = uri.pathSegments[1];
            debugPrint('id parsed -> $id');
            return MaterialPageRoute(
                builder: (context) => FormResultHomePage(caseId: id));
          }

          // return MaterialPageRoute(builder: (context) => HomePage());
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
// https://github.com/Satendra9984/Veridocs_Form_Preview_Web.git
