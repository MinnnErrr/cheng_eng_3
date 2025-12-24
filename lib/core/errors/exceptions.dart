class PaymentDesyncException implements Exception {
  final String message;
  PaymentDesyncException(this.message);
  @override
  String toString() => message;
}