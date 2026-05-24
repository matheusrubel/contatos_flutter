import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/models/nota.dart';
import 'package:image_picker/image_picker.dart';

class NotaFormScreen extends StatefulWidget {
  final Nota? nota;

  const NotaFormScreen({super.key, this.nota});

  @override
  State<NotaFormScreen> createState() => _NotaFormScreenState();
}

class _NotaFormScreenState extends State<NotaFormScreen> {
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  String? _imagemPath;
  final _dbHelper = DatabaseHelper();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.nota != null) {
      _tituloController.text = widget.nota!.titulo;
      _conteudoController.text = widget.nota!.conteudo;
      _imagemPath = widget.nota!.imagemPath;
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagemPath = picked.path);
    }
  }

  Future<void> _save() async {
    final hoje = DateTime.now();
    final data =
        '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}';

    final nota = Nota(
      id: widget.nota?.id,
      titulo: _tituloController.text,
      conteudo: _conteudoController.text,
      imagemPath: _imagemPath,
      data: data,
    );

    if (widget.nota == null) {
      await _dbHelper.insertNota(nota);
    } else {
      await _dbHelper.updateNota(nota);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nota == null ? 'Nova Nota' : 'Editar Nota'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _conteudoController,
              decoration: const InputDecoration(labelText: 'Conteúdo'),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            if (_imagemPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_imagemPath!),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: Text(_imagemPath == null
                  ? 'Selecionar imagem'
                  : 'Trocar imagem'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
