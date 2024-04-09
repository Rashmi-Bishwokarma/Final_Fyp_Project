import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_rememory/app/models/note.dart';
import 'package:fyp_rememory/app/modules/showNote/controllers/show_note_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/footer.dart';
// Adjust the import path as needed
// Adjust the import path as needed

class ShowNoteView extends GetView<ShowNoteController> {
  const ShowNoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ShowNoteController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Notes',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.notes.isEmpty) {
          return Center(child: Text('No notes found'));
        } else {
          return ListView.builder(
            itemCount: controller.notes.length,
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return Slidable(
                key: ValueKey(note.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        _showEditNoteDialog(context, note, controller);
                      },
                      foregroundColor: const Color(0xFF463A79),
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        // Show a confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Delete Journal Entry'),
                              content: const Text(
                                'Are you sure you want to delete this journal entry? This action cannot be undone.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(dialogContext)
                                      .pop(), // Close the dialog
                                ),
                                TextButton(
                                  child: const Text(
                                    'Delete',
                                  ),
                                  onPressed: () {
                                    // Now call the delete method from the controller
                                    controller
                                        .deleteNote(note.id)
                                        .then((_) => Navigator.of(dialogContext)
                                            .pop()) // Close the dialog after deletion
                                        .catchError((error) {
                                      // Handle the error if deletion fails
                                      Navigator.of(dialogContext)
                                          .pop(); // Close the dialog
                                      Get.snackbar('Error',
                                          'Failed to delete the entry: $error');
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      'Last updated: ${note.updatedAt}',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Default color
                      ),
                    ),
                    subtitle: Text(
                      note.content,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Default color
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}

void _showEditNoteDialog(
    BuildContext context, Note note, ShowNoteController controller) {
  // Initialize text controllers with the task's current data
  TextEditingController contentController =
      TextEditingController(text: note.content);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Edit Task',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: "Notes",
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                child: Text(
                  'Save',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  // Call editNote method from controller to save the changes
                  controller
                      .editNote(note.id, contentController.text)
                      .then((success) {
                    if (success) {
                      Navigator.of(context)
                          .pop(); // Close the dialog on success
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    },
  );
}
