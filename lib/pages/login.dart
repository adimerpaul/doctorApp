import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/color.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  @override
  void initState() {
    super.initState();
    // _checkCurrentUser();
  }

  /// Verificar si hay un usuario actualmente autenticado
  // void _checkCurrentUser() {
  //   globals.isLoggedIn = true;
  //   globals.auth.authStateChanges().listen((User? user) {
  //     if (user != null) {
  //       print('Usuario autenticado: ${user.email}');
  //     } else {
  //       print('No hay usuario autenticado');
  //     }
  //   });
  // }

  /// Iniciar sesión con Google
  Future<void> signInWithGoogle() async {
    try {
      // Inicia sesión con Google
      final GoogleSignInAccount? googleUser = await globals.googleSignIn.signIn();
      if (googleUser == null) {
        print('Inicio de sesión cancelado por el usuario.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Crear credenciales para Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase con las credenciales
      final UserCredential userCredential =
      await globals.auth.signInWithCredential(credential);
      final String? photoUrl = userCredential.user?.photoURL;
      print('Foto de perfil: $photoUrl');
      if (photoUrl != null) {
        final localPath = await downloadAndSavePhotoPublicForApp(photoUrl);
        print('Foto guardada en: $localPath');
      }

      print("Usuario autenticado: ${userCredential.user?.email}");
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
    }
  }
  Future<String> downloadAndSavePhotoPublic(String photoUrl) async {
    try {
      // Descargar la imagen desde la URL
      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        // Obtener el directorio público para guardar la imagen
        final directory = Directory('/storage/emulated/0/Download'); // Carpeta "Descargas"

        // Verificar si el directorio existe o crearlo
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        // Definir la ruta completa del archivo (nombre de archivo)
        final filePath = '${directory.path}/avatar.png';

        // Guardar la imagen como archivo en el almacenamiento público
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Foto guardada públicamente en: $filePath');
        return filePath;
      } else {
        throw Exception('Error al descargar la foto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al guardar la foto: $e');
      throw e;
    }
  }
  Future<String> downloadAndSavePhotoPublicForApp(String photoUrl) async {
    try {
      // Descargar la imagen desde la URL
      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        // Obtener el directorio externo privado de la aplicación
        final directory = await getExternalStorageDirectory();

        // Crear una subcarpeta específica para tu aplicación, accesible públicamente
        final appDirectory = Directory('${directory!.path}/DoctorApp');
        if (!appDirectory.existsSync()) {
          appDirectory.createSync(recursive: true);
        }

        // Definir la ruta completa del archivo
        final filePath = '${appDirectory.path}/avatar.png';

        // Guardar la imagen como archivo
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Foto guardada en: $filePath');
        return filePath;
      } else {
        throw Exception('Error al descargar la foto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al guardar la foto: $e');
      throw e;
    }
  }

  Future<String> downloadAndSavePhoto(String photoUrl) async {
    try {
      // Descargar la imagen desde la URL
      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        // Obtener el directorio de almacenamiento local
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/avatar.png';

        // Guardar la imagen como archivo
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Foto guardada localmente en: $filePath');
        return filePath;
      } else {
        throw Exception('Error al descargar la foto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al guardar la foto: $e');
      throw e;
    }
  }
  /// Cerrar sesión
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Firebase
      await globals.auth.signOut();
      // Cerrar sesión en GoogleSignIn
      await globals.googleSignIn.signOut();

      print('Cierre de sesión exitoso.');
    } catch (e) {
      print('Error durante el cierre de sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Hace la barra de estado transparente
        statusBarIconBrightness: Brightness.light, // Iconos claros (para fondos oscuros)
        statusBarBrightness: Brightness.dark, // Brillo del contenido (para iOS)
      ),
      child: Scaffold(
        body: Container(
          color: ColorUtils.primaryColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 150, left: 40, right: 40),
                child: Image.asset(
                  'assets/images/doctor.png',
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
                        'Citas Médicas, Diagnósticos y Recetas en línea con los mejores doctores',
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
                        onPressed: signInWithGoogle,
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
        ),
      ),
    );
  }
}
