import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({Key? key}) : super(key: key) {
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut(() => DashboardController());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the device width for responsive layout
    double deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 254, 255),
          borderRadius: BorderRadius.circular(
              8), // Applies a 5 pixels radius uniformly to all corners
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 252, 254, 255),
          appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 252, 254, 255),
              title: const Text('Dashboard')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10, // space between cards
                      children: <Widget>[
                        buildAverageRatingCard(controller),
                        statCard(
                            'Total User',
                            controller.tableCounts.value.users,
                            Icons.person,
                            Colors.blue),
                        statCard(
                            'Total App Plans',
                            controller.tableCounts.value.plans,
                            Icons.subscriptions,
                            Colors.green),
                        statCard(
                            'Total Tags',
                            controller.tableCounts.value.tags,
                            Icons.tag_sharp,
                            Colors.blue),
                        statCard(
                            'Total Feedbacks',
                            controller.tableCounts.value.feedback,
                            Icons.feedback_sharp,
                            Colors.amber),

                        // Add more stat cards as needed
                      ],
                    ),

                    // Line Chart Card for Visitor Statistics
                    Row(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: 400,
                              width: deviceWidth * 0.53, // 90% of device width
                              child: Column(
                                children: [
                                  const Text(
                                    'User Activity on writting Journal', // Title of the chart
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Expanded(
                                      child:
                                          LineChart(lineChartData(controller))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Tasks Circular Chart
                        buildSalesGoalCard(controller, context),
                      ],
                    ),
                    // Other sections go here
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  // A method to create each statistics card
  Widget statCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 160, // fixed width for each card
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.grey)),
            Text('$count',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

Widget buildAverageRatingCard(DashboardController controller) {
  return Obx(() => Card(
        elevation: 2,
        child: Container(
          width: 160, // Adjust the size as needed
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.star, size: 40, color: Colors.amber),
              SizedBox(height: 10),
              Text('Average Rating', style: TextStyle(color: Colors.grey)),
              Text(
                  '${controller.averageRating.value.averageRating.toStringAsFixed(1)} / 5', // Assuming rating out of 5
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
        ),
      ));
}

LineChartData lineChartData(DashboardController controller) {
  return LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: controller.journalCounts
            .map((e) => FlSpot(
                  DateTime.parse(e.date).millisecondsSinceEpoch /
                      (1000 * 60 * 60 * 24 * 7).toDouble(),
                  e.count.toDouble(),
                ))
            .toList(),
        isCurved: true,
        color: Colors.green,
        belowBarData: BarAreaData(show: false),
      ),
    ],
    gridData: FlGridData(show: true),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            var date = DateTime.fromMillisecondsSinceEpoch(
                (value * (1000 * 60 * 60 * 24 * 7)).toInt());
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                DateFormat('MM/dd').format(date),
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            );
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
              style: TextStyle(color: Colors.black, fontSize: 10)),
          reservedSize: 40,
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(show: false),
  );
}

Widget buildSalesGoalCard(
    DashboardController controller, BuildContext context) {
  // Calculate the percentage of the goal achieved
  double achievedPercentage =
      controller.totalRevenue.value.totalRevenue / controller.salesGoal * 100;

  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 400,
        // Adjust width as needed or keep it responsive
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                percent: achievedPercentage / 100,
                center: new Text(
                  "${achievedPercentage.toStringAsFixed(1)}%",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      Text(
                        "ACHIEVED",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      Text(
                        'Rs ${controller.totalRevenue.value.totalRevenue.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      Text(
                        "GOAL",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      Text(
                        'Rs ${controller.salesGoal.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
