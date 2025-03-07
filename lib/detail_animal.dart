import 'package:animal_app/class.dart';
import 'package:flutter/material.dart';

class DetailAnimal extends StatelessWidget {
  const DetailAnimal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(70.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                const StyleText('Animal Detail'),
                Row(
                  children: [
                    Image.asset(
                      'Assets/images/Upload.jpg',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      'Assets/images/Upload.jpg',
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'Assets/images/Upload.jpg',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      'Assets/images/Upload.jpg',
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'Assets/images/Upload.jpg',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      'Assets/images/Upload.jpg',
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(children: [
                  const StyleText('Discription'),
                  TextFormField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Add a discription',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 50,
                ),
                Column(children: [
                  const StyleText('Other Details'),
                  TextFormField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Add a discription',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
