class CustomException {
  final Exception? lastException;

  CustomException(this.lastException);
}

class CustomResponseException implements Exception {
  final String message;

  CustomResponseException(this.message);

  @override
  String toString() {
    return message;
  }
}
