import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInSlider extends StatelessWidget {
  final String title;
  const SignInSlider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3.5 - 10,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/hi.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (Platform.isIOS)
            Positioned(
              top: 30,
              left: 10,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/svg/arrow-back-circle.svg',
                  height: 40,
                  color: Colors.black, // optional, change color if needed
                ),
              ),
            ),
        ],
      ),
    );
  }
}



