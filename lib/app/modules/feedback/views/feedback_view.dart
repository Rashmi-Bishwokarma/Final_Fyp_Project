import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FeedbackController());
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 239, 243, 244),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 239, 243, 244),
          title: const Text('FeedbackView'),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 252, 254, 255),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 252, 254,
                  255), // Applies a 5 pixels radius uniformly to all corners
            ),
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              }
              // Create a table with a row for each feedback item
              return SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(400), // Message column width
                    1: FlexColumnWidth(300),
                    2: FlexColumnWidth(300),
                    3: FlexColumnWidth(400),
                    4: FlexColumnWidth(400),
                  },
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('User'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Message'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Date'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Rating'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Email'),
                        ),
                      ],
                    ),
                    ...controller.feedbackList.map((feedback) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(feedback.username),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(feedback.message),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(feedback.createdAt.toIso8601String()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: feedback.rating != null
                                ? RatingBar.builder(
                                    initialRating: feedback.rating!.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  )
                                : Text('N/A'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(feedback.email),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}
