class TotalRevenue {
  final double totalRevenue;

  TotalRevenue({required this.totalRevenue});

  factory TotalRevenue.fromJson(Map<String, dynamic> json) {
    // Use null-aware operator to provide a default value if the key doesn't exist or is null.
    double revenue = double.tryParse(json['total_revenue'].toString()) ?? 0.0;
    return TotalRevenue(
      totalRevenue: revenue,
    );
  }
}
