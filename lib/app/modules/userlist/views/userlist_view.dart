import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../controllers/userlist_controller.dart'; // Make sure this is the correct path to your UserController

class UserListView extends StatelessWidget {
  UserListView({Key? key}) : super(key: key);

  // If UserController is initialized in the main.dart or any parent widget, you don't need to put it here again.
  // Otherwise, uncomment the following line to initialize UserController.
  // final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    // Using GetX<YourControllerType> to automatically manage state and lifecycle of the controller.
    return GetX<UserListController>(
      init:
          UserListController(), // Initialize your UserController if not already initialized
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('User List'),
          ),
          body: controller.isLoading.isTrue
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.userList.length,
                  itemBuilder: (context, index) {
                    final user = controller.userList[index];
                    String profileImageUrl =
                        getImageUrl(user.profileImage ?? '');
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: user.profileImage != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(profileImageUrl),
                              )
                            : CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                        // Implement onTap to navigate to user details or perform other actions
                        onTap: () {
                          // Navigation or action
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
