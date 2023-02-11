import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newjourney/client.dart';
import 'package:newjourney/homescreen.dart';
import 'package:newjourney/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Account account = Account(MyClient().myCleint);
  bool trying = false;
  String showmsg = '';
  late String email, password;
  createAcc() async {
    try {
      final user = await account
          .createEmailSession(email: email, password: password)
          .then((value) {
        setState(() {
          trying = false;
        });
        EasyLoading.showSuccess('Logged In Successfully',
            duration: const Duration(seconds: 1));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      email: email,
                    )));
      });
    } on AppwriteException catch (e) {
      setState(() {
        trying = false;
      });
      showmsg = e.message.toString();
      EasyLoading.showError('$showmsg \n Please Try Again',
          duration: const Duration(seconds: 2));
    }
  }

  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                    child: Text(
                  'Login to Test First Appwrite Cloud Performance',
                  style: TextStyle(fontSize: 20),
                )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Email';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    email = val;
                  },
                  cursorColor: const Color.fromARGB(255, 239, 148, 148),
                  decoration: InputDecoration(
                    hintText: "Email",
                    fillColor: const Color.fromARGB(255, 116, 244, 120),
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Password?';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    password = val;
                  },
                  cursorColor: const Color.fromARGB(255, 239, 148, 148),
                  decoration: InputDecoration(
                    hintText: "Password",
                    fillColor: const Color.fromARGB(255, 116, 244, 120),
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            trying = true;
                          });
                          createAcc();
                        },
                        child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 253, 107, 97)),
                            child: Center(
                                child: trying
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text(
                                        'Log In',
                                        style: TextStyle(letterSpacing: 5),
                                      ))))),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t Have Account'),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
