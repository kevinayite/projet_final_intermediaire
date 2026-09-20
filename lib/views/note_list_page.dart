import 'package:flutter/material.dart';
import 'package:projet_final/services/database_manager.dart';
import 'package:projet_final/views/widgets/edit_note_page.dart';
import '../models/note_model.dart';


class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final TextEditingController _noteController = TextEditingController();
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  // Recharge les notes depuis SQLite
  Future<void> _refreshNotes() async {
    setState(() => _isLoading = true);
    _notes = await DatabaseHelper.instance.getAllNotes();
    setState(() => _isLoading = false);
  }

  // Ajouter une note
  void _addNote() async {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      await DatabaseHelper.instance.insertNote(Note(title: text));
      _noteController.clear();
      _refreshNotes();
    }
  }

  // Supprimer une note
  void _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _refreshNotes();
  }

  // Redirection vers l'écran d'édition
  void _navigateToEdit(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(note: note),
      ),
    );

    if (result == true) {
      _refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do list', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ d'ajout
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Ajouter une note',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_box, size: 32),
                  onPressed: _addNote,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Liste des notes depuis la base de données SQLite
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notes.isEmpty
                      ? const Center(child: Text('Aucune note pour le moment'))
                      : ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_note),
                                        onPressed: () => _navigateToEdit(note),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _deleteNote(note.id!),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.black, thickness: 1),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}