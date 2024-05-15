import 'package:ats_recruitment_system/NavBar.dart';
import 'package:ats_recruitment_system/widgets/homescreen.dart';
import 'package:ats_recruitment_system/widgets/inputjobtitle.dart';
import 'package:ats_recruitment_system/widgets/loginscreen.dart';
import 'package:ats_recruitment_system/widgets/signupscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ATS System',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  KeyboardVisibilityProvider(child: HomeScreen()),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUp(),
        '/home': (context) => MyHomePage(),
        '/inputjobtitle': (context) => InputJobTitle(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});




  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('ast'),
      ),
      body: const Center(),
      );
  }
}

class BaseInc extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const Text('Base Inc');
  }

}

class authCheckState extends StatefulWidget {
  const authCheckState({super.key});

  @override
  State<authCheckState> createState() => _authCheckStateState();
}

class _authCheckStateState extends State<authCheckState> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getCurrentUser() async{
    sharedPreferences = await SharedPreferences.getInstance();

    try{
      if (sharedPreferences.getString('employeeId') != null){
        setState(() {
          userAvailable = true;
        });
      }
      else{
        setState(() {
          userAvailable = false;
        });
      }
    }catch(e){
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const MyHomePage() : const LoginScreen();
  }
}

