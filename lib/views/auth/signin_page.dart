import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/loading_widget.dart';
import '../../providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "", _password = "";
  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Future<void> onSingInButtonPress() async {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          setState(() {
            loading = true;
          });
          await authProvider.signInEmailPassword(_email, _password).then((isSuccess) {
            if (isSuccess) {
              print("@onSingInButtonPress success" );
              Navigator.pop(context);
            }
          });
        } on AuthExceptionCode catch (e) {
          switch (e) {
            case AuthExceptionCode.wrongPassword:
              error = "Wrong Password";
              break;
            case AuthExceptionCode.userNotFound:
              error = "User not Found";
              break;
            case AuthExceptionCode.invalidEmail:
              error = "Invalid Email";
              break;
            case AuthExceptionCode.emailVerifiedNull:
              error = "Invalid Email";
              break;
            case AuthExceptionCode.userNeedConfirmation:
              error =
                  "Email not Verified.";
              break;

            default:
              error = e.toString();
          }
          setState(() {});
        } catch (e) {
          debugPrint(e.toString());
        }
        setState(() {
          loading = false;
        });
      }
    }

    final Widget mainContent;

    if (loading) {
      mainContent = const LoadingWidget();
    } else {
      mainContent =Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  error.isNotEmpty
                      ? Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 15),
                  )
                      : const Text(""),
                  Padding(
                    //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return "Provide an Email";
                        }
                        return null;
                      },
                      initialValue: _email,
                      onSaved: (input) => _email = input!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      validator: (input) {
                        if (input == null) {
                          return "Provide a password.";
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input!,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: onSingInButtonPress,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Sign In",
                              style: const TextStyle(color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),

                      TextButton(
                          onPressed: onSingInButtonPress,
                          child: Text("Sign up")),
                    ],
                  ),

                ],
              ),
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration:  const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/city_of_aveiro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
          ),
          child: Center(
            child: mainContent,
          ),
        ),
      ),
    );
  }
}
