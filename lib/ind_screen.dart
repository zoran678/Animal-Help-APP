import 'package:flutter/material.dart';

class IndivisiualScreen extends StatelessWidget {
  const IndivisiualScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'Assets/images/Upload.jpg',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: 'Add a discription',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 116, 234, 210),
                    ),
                    child: const Text(
                      'Locate',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {},
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
                      'Continue',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
