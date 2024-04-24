// Define a class for a single plan
class Plan {
  final String planId;
  late final String name;
  late final String price;
  final String duration;
  late final String features;
  final String isActive;

  Plan({
    required this.planId,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    required this.isActive,
  });

  // A method to deserialize a plan from a JSON object
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json['plan_id'].toString(),
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
      features: json['features'],
      isActive: json['is_active'],
    );
  }
}

// Define a class for the whole response that includes a list of plans
class PlansResponse {
  final bool success;
  final List<Plan> plans;

  PlansResponse({
    required this.success,
    required this.plans,
  });

  // A method to deserialize the entire response, including a list of plans
  factory PlansResponse.fromJson(Map<String, dynamic> json) {
    var list = json['plans'] as List;
    List<Plan> plansList = list.map((i) => Plan.fromJson(i)).toList();
    return PlansResponse(
      success: json['success'],
      plans: plansList,
    );
  }
}
