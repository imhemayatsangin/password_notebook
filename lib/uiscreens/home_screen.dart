import 'package:flutter/material.dart';
import 'package:password_notebook/database/passworddb_helper.dart';
import 'package:password_notebook/uiscreens/delete_confirmation_dialog.dart';
import 'package:password_notebook/uiscreens/view_data_screen.dart';
import 'package:password_notebook/uiscreens/entry_form_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _entries = [];
  bool _isLoading = true;

  final TextEditingController _networkNameController = TextEditingController();
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void _loadList() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _entries = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _loadList();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final filteredEntries = _entries
        .where((entry) =>
            entry['networkName'].toLowerCase().contains(query.toLowerCase()) ||
            entry['usernameOrEmail']
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    setState(() {
      _entries = filteredEntries;
      _isLoading = false;
    });
  }

  Future<void> _addEntry(BuildContext context) async {
    await SQLHelper.createEntry(
      _networkNameController.text,
      _usernameOrEmailController.text,
      _passwordController.text,
      _descriptionController.text,
    );
    Navigator.of(context).pop(true); // Close the bottom sheet
    _loadList();
  }

  Future<void> _updateEntry(int id, BuildContext context) async {
    await SQLHelper.updateEntry(
      id,
      _networkNameController.text,
      _usernameOrEmailController.text,
      _passwordController.text,
      _descriptionController.text,
    );
    Navigator.of(context).pop(true); // Close the bottom sheet
    _loadList();
  }

  void _deleteEntry(int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        onDeleteConfirmed: () async {
          await SQLHelper.deleteEntry(id);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Entry deleted successfully'),
          ));
          _loadList();
        },
      ),
    );

    if (shouldDelete == true) {}
  }

  void _showForm(int? id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryFormScreen(entryId: id),
      ),
    ).then((result) {
      if (result == true) {
        _loadList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _performSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search by Network Name or Username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadList();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) => Card(
                      color: const Color.fromARGB(255, 44, 127, 165),
                      margin: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewDataScreen(
                                networkName: _entries[index]['networkName'],
                                usernameOrEmail: _entries[index]
                                    ['usernameOrEmail'],
                                password: _entries[index]['password'],
                                description: _entries[index]['description'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(_entries[index]['networkName']),
                          subtitle: Text(_entries[index]['usernameOrEmail']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showForm(_entries[index]['id']),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteEntry(_entries[index]['id']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
