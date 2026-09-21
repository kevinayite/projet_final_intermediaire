import 'package:flutter/material.dart';
import 'package:projet_final/models/user_model.dart';
import 'package:projet_final/services/database_manager.dart';
import 'package:projet_final/views/login_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Méthode d'inscription asynchrone reliée à SQLite
  void _register() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // 1. Vérifier dans la BDD SQLite si le nom d'utilisateur existe déjà
      bool exists = await DatabaseHelper.instance.checkUsernameExists(username);
      if (exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ce nom d\'utilisateur existe déjà !'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 2. Insérer le nouvel utilisateur dans la BDD SQLite
      int userId = await DatabaseHelper.instance.registerUser(
        User(username: username, password: password),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compte créé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      final user = User(id: userId, username: username, password: password);

      // 3. Redirection vers la liste des notes en injectant l'utilisateur connecté
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) => LoginPage(currentUser: user),
          builder: (context) => LoginPage(),
        ),
      );
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
                  const SizedBox(height: 40),
                  const Text(
                    'Création de Compte',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 30),

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
                        return "Veuillez entrer un nom d'utilisateur";
                      }
                      if (value.trim().length < 3) {
                        return "Le nom d'utilisateur doit contenir au moins 3 caractères";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

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
                        return "Veuillez entrer un mot de passe";
                      }
                      if (value.length < 6) {
                        return "Le mot de passe doit contenir au moins 6 caractères";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // CHAMP CONFIRMATION MOT DE PASSE
                  const Text(
                    'Retapez votre mot de passe',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Confirmez votre mot de passe",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez confirmer votre mot de passe";
                      }
                      if (value != _passwordController.text) {
                        return "Les deux mots de passe ne correspondent pas";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  // BOUTON CRÉER LE COMPTE
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Créer votre compte',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BOUTON SE CONNECTER (Retour)
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}