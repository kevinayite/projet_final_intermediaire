// import 'package:flutter/material.dart';
// import 'package:projet_final/models/note_model.dart';
// import 'package:projet_final/services/database_manager.dart';
// import 'package:projet_final/views/widgets/edit_note_page.dart';



// class NoteListPage extends StatefulWidget {
//   const NoteListPage({super.key});

//   @override
//   State<NoteListPage> createState() => _NoteListPageState();
// }

// class _NoteListPageState extends State<NoteListPage> {
//   final TextEditingController _noteController = TextEditingController();
//   List<Note> _notes = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _refreshNotes();
//   }

//   // Recharge les notes depuis SQLite
//   Future<void> _refreshNotes() async {
//     setState(() => _isLoading = true);
//     _notes = await DatabaseHelper.instance.getAllNotes();
//     setState(() => _isLoading = false);
//   }

//   // Ajouter une note
//   void _addNote() async {
//     final text = _noteController.text.trim();
//     if (text.isNotEmpty) {
//       await DatabaseHelper.instance.insertNote(Note(title: text));
//       _noteController.clear();
//       _refreshNotes();
//     }
//   }

//   // Supprimer une note
//   void _deleteNote(int id) async {
//     await DatabaseHelper.instance.deleteNote(id);
//     _refreshNotes();
//   }

//   // Redirection vers l'écran d'édition
//   void _navigateToEdit(Note note) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditNotePage(note: note),
//       ),
//     );

//     if (result == true) {
//       _refreshNotes();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('To do list', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Champ d'ajout
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _noteController,
//                     decoration: const InputDecoration(
//                       hintText: 'Ajouter une note',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add_box, size: 32),
//                   onPressed: _addNote,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Liste des notes depuis la base de données SQLite
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _notes.isEmpty
//                       ? const Center(child: Text('Aucune note pour le moment'))
//                       : ListView.builder(
//                           itemCount: _notes.length,
//                           itemBuilder: (context, index) {
//                             final note = _notes[index];
//                             return Column(
//                               children: [
//                                 ListTile(
//                                   title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         icon: const Icon(Icons.edit_note),
//                                         onPressed: () => _navigateToEdit(note),
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(Icons.delete_outline),
//                                         onPressed: () => _deleteNote(note.id!),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Divider(color: Colors.black, thickness: 1),
//                               ],
//                             );
//                           },
//                         ),
//             ),
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