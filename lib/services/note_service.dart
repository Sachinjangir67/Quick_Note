import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import 'package:flutter/material.dart';

class NoteService {
  static const String _notesKey = 'notes';

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey);
    if (notesJson == null) {
      return [];
    }
    return notesJson
        .map((noteJson) => Note.fromJson(jsonDecode(noteJson)))
        .toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }
  Future<void> addNote(Note newNote) async {
    // Retrieve existing notes
    List<Note> existingNotes = await getNotes();
    
    // Add the new note
    existingNotes.add(newNote);

    // Save the updated list
    await saveNotes(existingNotes);
  }

  Future<void> updateNote(Note updatedNote) async {
    // Retrieve existing notes
    List<Note> existingNotes = await getNotes();

    // Find the index of the note to be updated
    int index = existingNotes.indexWhere((note) => note.id == updatedNote.id);

    if (index != -1) {
      // Replace the old note with the updated note
      existingNotes[index] = updatedNote;

      // Save the updated list
      await saveNotes(existingNotes);
    } else {
      // Handle the case where the note is not found
      debugPrint('Note with ID ${updatedNote.id} not found.');
    }
  }


  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();

    // find the index of the note to be deleted.
    int index = notes.indexWhere((element) => element.id == id);

    if (index >= 0) {
      notes.removeAt(index);
      await saveNotes(notes);
    } else {
      // Handle the case where the note is not found
      print("Note with ID $id not found.");
    }
  }
}