import 'package:animal_app/ngo_screen.dart';
import 'package:animal_app/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:animal_app/class.dart';
import 'package:animal_app/ind_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? option;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  const Row(
                    children: [
                      StyleText('Hi, Welcome Back !'),
                    ],
                  ),
                  const Row(
                    children: [
                      StyleText2('To the Animal Help App'),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Email Address',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your email ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Password',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                            () {
                              isObscure = !isObscure;
                            },
                          );
                        },
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Enter Your password',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 300),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2)),
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 14, 14),
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Indivisual',
                        groupValue: option,
                        onChanged: (value) {
                          setState(
                            () {
                              option = value;
                            },
                          );
                        },
                      ),
                      const StyleText2('Indivisual'),
                      const SizedBox(
                        width: 50,
                      ),
                      Radio(
                        value: 'Organisation',
                        groupValue: option,
                        onChanged: (value) {
                          setState(
                            () {
                              option = value;
                            },
                          );
                        },
                      ),
                      const StyleText2('Organisation'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NgoScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 200, vertical: 8),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Color.fromARGB(255, 116, 188, 234),
                            ),
                            child: const Text(
                              'Login',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Row(
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Dont have an account ?',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2)),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 65, 140),
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
