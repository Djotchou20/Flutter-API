import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart';
// import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController secretController = TextEditingController();
  final String apiUrl =
      'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/auth/getkeys';
  // final String apiKey = 'k840o8ccsw8cswkos084g44w4cgco0ccgkcc08w0';

  @override
  void initState() {
    super.initState();
    checkSavedCredentials();
  }

  void checkSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedUsername = prefs.getString('username') ?? '';
    String savedSecret = prefs.getString('secret') ?? '';

    if (savedUsername.isNotEmpty && savedSecret.isNotEmpty) {
      authenticateUser(savedUsername, savedSecret);
    }
  }

  Future<void> authenticateUser(String username, String secret) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'secret': secret,
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String _apikey = responseData['api_key'];

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 && _apikey.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('api_key', _apikey);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Authentication Failed'),
            content: Text('Invalid credentials. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Incorrect Username or Password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: secretController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  authenticateUser(
                    usernameController.text,
                    secretController.text,
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
