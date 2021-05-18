import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/ui/homeview.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(25),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Spacer(),
              TextField(
                controller: _emailField,
                decoration: InputDecoration(
                  hintText: 'name@mail.com',
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _passwordField,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '********',
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    bool shouldNavigate =
                        await signIn(_emailField.text, _passwordField.text);
                    if (shouldNavigate) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                child: OutlinedButton(
                  onPressed: () async {
                    bool shouldNavigate =
                        await register(_emailField.text, _passwordField.text);
                    if (shouldNavigate) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(),
                        ),
                      );
                    }
                  },
                  child: Text('Register'),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
