import 'package:bd_alunos/database/database_helper.dart';
import 'package:bd_alunos/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final dbhelper = DatabaseHelper();

  Future<void> saveContact() async {
    final contact = Contact(
      name: nameController.text,
      phone: phoneController.text,
    );

    await dbhelper.insertContact(contact);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo contato"),),
      body: Padding(padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller:  nameController,
            decoration: InputDecoration(labelText: "Nome: "),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Telefone: "),
          ),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: saveContact, child: Text("Salvar"))
        ],
      ),),
    );
  }
}
