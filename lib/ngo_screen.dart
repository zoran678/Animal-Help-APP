import 'package:animal_app/class.dart';
import 'package:flutter/material.dart';
import 'package:animal_app/detail_animal.dart';

class NgoScreen extends StatelessWidget {
  const NgoScreen({Key? key}) : super(key: key);

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
                  Row(
                    children: [
                      const StyleText2('Oraganisation'),
                      const SizedBox(width: 200),
                      Image.asset(
                        'Assets/images/Upload.jpg',
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailAnimal(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0))),
                      child: Row(children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'Assets/images/Upload.jpg',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 50),
                        const Column(
                          children: [
                            Row(
                              children: [StyleText2('Text')],
                            ),
                            Row(
                              children: [
                                StyleText2('Date'),
                                SizedBox(height: 25),
                                SizedBox(width: 50),
                                StyleText2('Loaction')
                              ],
                            )
                          ],
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
