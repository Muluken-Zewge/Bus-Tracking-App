//import 'package:final_project_demo/pages/login.dart';
import 'package:final_project_demo/pages/passangerhomepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Bus Management System'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(5, 32, 5, 32),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bus.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Bus Management App',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 120),
              const Text(
                'Choose your role',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                elevation: 5.0,
                height: 40,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => PassangerHomePage())));
                },
                color: Colors.amber,
                child: const Text(
                  'Passanger',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 30.0),
              // MaterialButton(
              //     shape: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
              //     ),
              //     elevation: 5.0,
              //     height: 40,
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: ((context) => const LoginPage())));
              //     },
              //     color: Colors.amber,
              //     child: const Text(
              //       'Driver',
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
