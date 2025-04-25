import 'dart:async';

import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:myapp/models/note.dart';
import '../services/note_service.dart';
import '../note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  Timer? _debounce;
  bool _isNewNote = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isNewNote = widget.note == null;
    _startAutoSave();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _startAutoSave() {
    _debounce?.cancel();
    _debounce = Timer.periodic(const Duration(seconds: 3), (timer) {
      _saveNote();
    });
  }

  void _saveNote() {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final timestamp = DateTime.now();
    final noteService = NoteService();
    final newNote = Note(
      title: _titleController.text,
      id: widget.note!.id,
      timestamp: DateTime.now(),
      content: _contentController.text,
    );
    if (_isNewNote) {
      noteService.addNote(newNote);
      _isNewNote = false;
    } else {
      noteService.updateNote(newNote);
    }
  }

  void _deleteNote() {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final noteService = NoteService();
    noteService.deleteNote(widget.note!.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Editor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveNote();
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!_isNewNote)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteNote();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              onChanged: (_) => _startAutoSave(),
            ),
            const SizedBox(height: kDefaultPadding),
             Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                onChanged: (_) => _startAutoSave(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}