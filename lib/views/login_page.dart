import 'package:flutter/material.dart';
import 'package:projet_final/models/user_model.dart';
import 'package:projet_final/services/database_manager.dart';
import 'package:projet_final/views/note_list_page.dart';
import 'package:projet_final/views/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Méthode de connexion asynchrone reliée à SQLite
  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // 1. Fetching / Vérification en base de données SQLite
      User? user = await DatabaseHelper.instance.loginUser(username, password);

      if (!mounted) return;

      if (user != null) {
        // Connexion réussie -> Affichage du message et redirection avec l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie !'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoteListPage(currentUser: user),
          ),
        );
      } else {
        // Erreur : Utilisateur non trouvé ou mot de passe incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nom d\'utilisateur ou mot de passe incorrect !'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'LogIn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CHAMP NOM D'UTILISATEUR
                  const Text(
                    "Nom d'utilisateur",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Entrez votre nom d'utilisateur",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Veuillez entrer votre nom d'utilisateur";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // CHAMP MOT DE PASSE
                  const Text(
                    'Mot de passe',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Entrez votre mot de passe",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre mot de passe";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // BOUTON SE CONNECTER
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Se Connecter', style: TextStyle(fontSize: 16)),
                  ),

                  const SizedBox(height: 16),

                  // BOUTON CRÉER UN COMPTE
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}