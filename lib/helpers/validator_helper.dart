class Valid {

  static bool email(String email) {
    if(email.length > 10)
      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    return false;
  }

  static bool isNumber(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }
  
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }
}