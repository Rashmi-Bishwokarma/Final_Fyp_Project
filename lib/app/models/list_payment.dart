class Subscription {
  final String subscriptionId;
  final String userId;
  final String startDate;
  final String endDate;
  final String status;
  final String fullName;
  final String email;
  final String planName;
  final String price;
  final String duration;
  final String features;

  Subscription({
    required this.subscriptionId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.fullName,
    required this.email,
    required this.planName,
    required this.price,
    required this.duration,
    required this.features,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptionId: json['subscription_id'],
      userId: json['user_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      fullName: json['full_name'],
      email: json['email'],
      planName: json['plan_name'],
      price: json['price'],
      duration: json['duration'],
      features: json['features'],
    );
  }
}
