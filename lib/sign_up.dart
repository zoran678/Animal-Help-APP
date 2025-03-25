import 'package:flutter/material.dart';
import 'package:animal_app/class.dart';
import 'package:animal_app/ind_screen.dart';
import 'package:animal_app/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

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
                    StyleText('Create Account'),
                  ],
                ),
                const Row(
                  children: [
                    StyleText2('Connect with the NGOs for help'),
                  ],
                ),
                const SizedBox(height: 50),
                const Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Your name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your Name',
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
                            text: 'Email Address',
                            style: TextStyle(fontStyle: FontStyle.italic),
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
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Your password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Radio(
                        value: 'Indivisual', groupValue: null, onChanged: null),
                    StyleText2('Indivisual'),
                    SizedBox(
                      width: 50,
                    ),
                    Radio(
                        value: 'Organisation',
                        groupValue: null,
                        onChanged: null),
                    StyleText2('Organisation'),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await AuthService().signup(
                            emailAddress: emailcontroller.text.trim(),
                            password: passwordcontroller.text.trim());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IndivisiualScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 190, vertical: 8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Color.fromARGB(255, 116, 188, 234),
                        ),
                        child: const Text(
                          'Submit',
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
                              text: 'Already have an account?',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2)),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 65, 140),
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
