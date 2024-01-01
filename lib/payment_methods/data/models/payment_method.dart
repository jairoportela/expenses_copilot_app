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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name};
    if (icon != null) {
      data['icon'] = icon!;
    }
    return data;
  }
}
