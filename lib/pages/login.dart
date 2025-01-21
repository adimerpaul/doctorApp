import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../utils/color.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  _handleGoogleSignIn() async {
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: ColorUtils.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Login'),
        // ),
        body: Container(
          color: ColorUtils.primaryColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 250,left: 40,right: 40),
                child: Image.asset(
                  'assets/images/doctor.png',
                  // height: 350,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: ColorUtils.white,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Citas Medicas, Diagnosticos y Recetas en linea con los mejores doctores',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorUtils.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Encuentra los mejores doctores en linea y agenda tu cita medica, recibe diagnosticos y recetas en linea',
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorUtils.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _handleGoogleSignIn,
                        icon: Image.asset(
                          'assets/images/google_icon.png',
                          height: 30,
                        ),
                        label: Text('Iniciar Sesion'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: ColorUtils.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: ColorUtils.primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
