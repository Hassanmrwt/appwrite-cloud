import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newjourney/client.dart';
import 'package:newjourney/id.dart';
import 'package:newjourney/login.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Account account = Account(MyClient().myCleint);
  late String email, name, password;
  String showmsg = '';
  bool trying = false;
  createAcc() async {
    String user = '';
    try {
      account
          .create(
              userId: ID.unique(), email: email, password: password, name: name)
          .then((value) {
        setState(() {
          trying = false;
        });
        saveAccountData();
        EasyLoading.showSuccess('Congratulations! Regisetered Successfully',
            duration: const Duration(seconds: 1));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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

  saveAccountData() async {
    String docId = const Uuid().v4();
    Databases databases = Databases(MyClient().myCleint);
    Future res = databases.createDocument(
        databaseId: '63e66d9679c6efa71597',
        collectionId: "63e67ccc28b8cb918799",
        documentId: docId,
        data: {
          'email': email,
          'name': name,
          'docId': docId,
          "colId": "63e67ccc28b8cb918799",
          'avatorId': ""
        });
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
                  'Sign Up to Test First Appwrite Cloud Performance',
                  style: TextStyle(fontSize: 20),
                )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  cursorColor: const Color.fromARGB(255, 239, 148, 148),
                  onChanged: (val) {
                    name = val;
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Name Required';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
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
                                    'Register',
                                    style: TextStyle(letterSpacing: 5),
                                  )),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Have Account'),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
