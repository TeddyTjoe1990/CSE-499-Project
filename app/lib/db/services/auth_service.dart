import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';

class AuthService {
  // Simulación de una función para cerrar sesión
  Future<void> logout(BuildContext context) async {
    // Aquí iría la lógica real, como eliminar el token
    // de SharedPreferences o llamar a una API.
    print('Cerrando sesión...');

    // Navega a la pantalla de login y elimina todas las rutas anteriores.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}