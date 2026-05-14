import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/models/contact_model.dart';
import 'package:flutter_application_1/pages/add_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();
  List<Contact> contacts = [];

  Future<void> _loadContacts() async {
    final data = await dbHelper.getContacts();
    setState((){
      contacts = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatinhos do CR7"),
      ),
      body: contacts.isEmpty ? Center(child: Text("Nenhum contato encontrado")) : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: IconButton(onPressed: () async {
              await dbHelper.deleteContact(contact.id!);
              _loadContacts();
            }, icon: Icon(Icons.delete)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactPage()),
          );
            _loadContacts();
        },
        child: Icon(Icons.add),
      ),
    );
  }
























































































}