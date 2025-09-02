class RideType {
  final String type;
  final double basePrice;
  final double perKmPrice;
  final String icon;

  RideType({
    required this.type,
    required this.basePrice,
    required this.perKmPrice,
    required this.icon,
  });

  factory RideType.fromJson(Map<String, dynamic> json) {
    return RideType(
      type: json['type'],
      basePrice: json['basePrice'].toDouble(),
      perKmPrice: json['perKmPrice'].toDouble(),
      icon: json['icon'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "basePrice": basePrice,
      "perKmPrice": perKmPrice,
      "icon": icon,
    };
  }
}
