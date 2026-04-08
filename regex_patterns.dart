class RegexPatterns {
  static final RegExp email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp password = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
  static final RegExp username = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  static final RegExp phoneNumber = RegExp(r'^\+?[0-9]{10,15}$');
  static final RegExp name = RegExp(r'^[a-zA-Z\s\-]+$');
  static final RegExp url = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
}
