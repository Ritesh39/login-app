import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LoginDashboardApp());
}

class LoginDashboardApp extends StatelessWidget {
  const LoginDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SessionManager(),
    );
  }
}

class SessionManager extends StatefulWidget {
  const SessionManager({super.key});

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  bool isLoggedIn = false;
  String? username;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? storedUsername = prefs.getString('username');

    setState(() {
      isLoggedIn = loggedIn;
      username = storedUsername;
    });
  }

  Future<void> login(String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('username', newUsername);

    setState(() {
      isLoggedIn = true;
      username = newUsername;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('username');

    setState(() {
      isLoggedIn = false;
      username = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? Dashboard(username, logout) : Login(login);
  }
}

class Login extends StatefulWidget {
  final Function loginCallback;

  const Login(this.loginCallback, {super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/login1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        appBar: AppBar(
          title: const Text('Login',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
          backgroundColor: Colors.transparent,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('WELCOME', 
              style: TextStyle(color: Colors.black , fontSize: 40),),
            const SizedBox(height: 60),
            TextField(
              controller: usernameController, // get the entered username
              decoration: const InputDecoration(hintText: 'Username',fillColor: Colors.white, border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String enteredUsername = usernameController.text;
                widget.loginCallback(enteredUsername); // Pass the entered username
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}


class Dashboard extends StatelessWidget {
  final String? username;
  final Function logoutCallback;

  const Dashboard(this.username,this.logoutCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/login1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        appBar: AppBar(
          title: const Text('Dashboard',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.transparent,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hi $username',style: const TextStyle(color: Colors.black , fontSize: 30),),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logoutCallback();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
