// import 'package:flutter/material.dart';
// import 'package:projet_final/views/note_list_page.dart';

// class RegisterPage extends StatelessWidget {
//   const RegisterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 'Création de Compte',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),

//               const SizedBox(height: 30),

//               const Text(
//                 "Nom d'utilisateur",
//                 style: TextStyle(fontWeight: FontWeight.w500),
//               ),

//               const SizedBox(height: 8),

//               TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               const Text(
//                 'Mot de passe',
//                 style: TextStyle(fontWeight: FontWeight.w500),
//               ),

//               const SizedBox(height: 8),

//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               const Text(
//                 'Retapez votre mot de passe',
//                 style: TextStyle(fontWeight: FontWeight.w500),
//               ),

//               const SizedBox(height: 8),

//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 28),

//               // ElevatedButton(
//               //   onPressed: () {},
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: Colors.blue,
//               //     foregroundColor: Colors.white,
//               //     padding: const EdgeInsets.symmetric(vertical: 14),
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(12),
//               //     ),
//               //   ),
//               //   child: const Text(
//               //     'Créer votre compte',
//               //     style: TextStyle(fontSize: 16),
//               //   ),
//               // ),


//               // Pour le bouton "Créer votre compte" -> vers la liste des notes
// ElevatedButton(
//   onPressed: () {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const NoteListPage()),
//     );
//   },
//   child: const Text('Créer votre compte', style: TextStyle(fontSize: 16)),
// ),

// // Pour le bouton "Se connecter" -> retour à la page Login
// OutlinedButton(
//   onPressed: () {
//     Navigator.pop(context);
//   },
//   child: const Text('Se connecter', style: TextStyle(color: Colors.black)),
// ),

//               const SizedBox(height: 12),

//               OutlinedButton(
//                 onPressed: () {},
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Se connecter',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:projet_final/views/login_page.dart';
import 'package:projet_final/views/note_list_page.dart';

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

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Si toutes les validations passent :
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compte créé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      // Redirection vers la liste des notes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
                    child: const Text('Créer votre compte', style: TextStyle(fontSize: 16)),
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