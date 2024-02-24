class CheckUrl {
  static bool isURLValid(String url) {
    final RegExp regex =
    RegExp(r'^(?:http|https)://\w+\.\w+(?:\.\w+)*(?:/[^ ]+)*$');
    return regex.hasMatch(url);
  }
}
