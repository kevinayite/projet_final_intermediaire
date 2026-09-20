// import 'package:flutter/material.dart';
// import 'package:projet_final/models/note_model.dart';
// import 'package:projet_final/services/database_manager.dart';


// class EditNotePage extends StatefulWidget {
//   final Note note;

//   const EditNotePage({super.key, required this.note});

//   @override
//   State<EditNotePage> createState() => _EditNotePageState();
// }

// class _EditNotePageState extends State<EditNotePage> {
//   late TextEditingController _titleController;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.note.title);
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     super.dispose();
//   }

//   void _saveNote() async {
//     final updatedText = _titleController.text.trim();
//     if (updatedText.isNotEmpty) {
//       final updatedNote = Note(
//         id: widget.note.id,
//         title: updatedText,
//       );
//       await DatabaseHelper.instance.updateNote(updatedNote);
//       if (mounted) Navigator.pop(context, true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Modifier la note', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Note',
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Annuler'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _saveNote,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:projet_final/models/note_model.dart';
import 'package:projet_final/services/database_manager.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  const EditNotePage({super.key, required this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final updatedText = _titleController.text.trim();
    if (updatedText.isNotEmpty) {
      final updatedNote = Note(
        id: widget.note.id,
        userId: widget.note.userId, // Conservation du userId d'origine
        title: updatedText,
      );
      await DatabaseHelper.instance.updateNote(updatedNote);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la note', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Note',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveNote,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}