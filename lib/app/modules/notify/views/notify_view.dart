import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notify_controller.dart';

class NotifyView extends GetView<NotifyController> {
  const NotifyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotifyView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotifyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
