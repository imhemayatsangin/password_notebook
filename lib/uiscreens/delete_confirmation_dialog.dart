import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onDeleteConfirmed;

  DeleteConfirmationDialog({required this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this entry?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
            onDeleteConfirmed();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
