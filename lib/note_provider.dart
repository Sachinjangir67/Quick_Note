import 'package:flutter/material.dart';
import 'models/note.dart';
import 'services/note_service.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  final NoteService _noteService = NoteService();

  List<Note> get notes => _notes;

  Note get note => Note(id: '', title: '', content: '', timestamp: DateTime.now());

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _notes = await _noteService.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _noteService.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> updateNote(Note updatedNote) async {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      await _noteService.saveNotes(_notes);
    }
     notifyListeners();
  }
  Future<void> deleteNote(String noteId) async {
    await _noteService.deleteNote(noteId);
    _notes.removeWhere((n) => n.id == noteId);
     notifyListeners();
  }

}