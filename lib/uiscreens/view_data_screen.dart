import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart'; // Import the clipboard package

class ViewDataScreen extends StatelessWidget {
  final String networkName;
  final String usernameOrEmail;
  final String password;
  final String description;

  ViewDataScreen({
    required this.networkName,
    required this.usernameOrEmail,
    required this.password,
    required this.description,
  });
  void _copyToClipboard(BuildContext context, String text) {
    // Use the clipboard package to copy text to the clipboard
    FlutterClipboard.copy(text).then((value) {
      // Show a snackbar to indicate the text was copied
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Copied to clipboard: $text'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Entry Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldRow(
              label: 'Network Name:',
              value: networkName,
              icon: Icons.copy,
              onTap: () =>
                  _copyToClipboard(context, networkName), // Pass context
            ),
            SizedBox(height: 16),
            _buildFieldRow(
              label: 'Username/Email:',
              value: usernameOrEmail,
              icon: Icons.copy,
              onTap: () => _copyToClipboard(context, usernameOrEmail),
            ),
            SizedBox(height: 16),
            _buildFieldRow(
              label: 'Password:',
              value: password,
              icon: Icons.copy,
              onTap: () => _copyToClipboard(context, password),
            ),
            SizedBox(height: 16),
            _buildFieldRow(
              label: 'Description:',
              value: description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow({
    required String label,
    required String value,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
        if (icon != null)
          InkWell(
            onTap: onTap,
            child: Icon(
              icon,
              size: 24,
            ),
          ),
      ],
    );
  }
}
