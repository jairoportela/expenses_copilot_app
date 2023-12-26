class PaymentMethod {
  const PaymentMethod(
      {required this.id, required this.name, required this.icon});
  final String id;
  final String name;
  final String? icon;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
