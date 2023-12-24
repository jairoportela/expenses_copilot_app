class PaymentMethod {
  const PaymentMethod({required this.id, required this.name});
  final String id;
  final String name;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(id: json['id'], name: json['name']);
  }
}
