class PasswordEntry {
  final int id;
  final String networkName;
  final String usernameOrEmail;
  final String password;
  final String description;
  final DateTime createdAt;

  PasswordEntry({
    required this.id,
    required this.networkName,
    required this.usernameOrEmail,
    required this.password,
    required this.description,
    required this.createdAt,
  });
}
