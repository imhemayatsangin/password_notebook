import 'package:flutter/material.dart';
import 'package:password_notebook/database/passworddb_helper.dart';

class EntryFormScreen extends StatefulWidget {
  final int? entryId; // Pass the entry ID if updating, null if adding

  EntryFormScreen({this.entryId});

  @override
  _EntryFormScreenState createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final networkNameController = TextEditingController();
  final usernameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If entryId is not null, fetch and populate the form with existing data
    if (widget.entryId != null) {
      _fetchEntryData();
    }
  }

  void _fetchEntryData() async {
    final entryData = await SQLHelper.getItem(widget.entryId!);
    setState(() {
      networkNameController.text = entryData[0]['networkName'];
      usernameOrEmailController.text = entryData[0]['usernameOrEmail'];
      passwordController.text = entryData[0]['password'];
      descriptionController.text = entryData[0]['description'];
    });
  }

  void _saveOrUpdateEntry() async {
    final networkName = networkNameController.text;
    final usernameOrEmail = usernameOrEmailController.text;
    final password = passwordController.text;
    final description = descriptionController.text;

    if (widget.entryId == null) {
      // Add new entry
      await SQLHelper.createEntry(
          networkName, usernameOrEmail, password, description);
    } else {
      // Update existing entry
      await SQLHelper.updateEntry(
          widget.entryId!, networkName, usernameOrEmail, password, description);
    }

    Navigator.of(context).pop(true); // Close the form screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryId == null ? 'Add Entry' : 'Edit Entry'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: networkNameController,
              decoration: InputDecoration(
                hintText: 'Network or Website name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: usernameOrEmailController,
              decoration: InputDecoration(
                hintText: 'Username or Email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrUpdateEntry,
              child: Text(widget.entryId == null ? 'Save' : 'Update'),
            )
          ],
        ),
      ),
    );
  }
}
