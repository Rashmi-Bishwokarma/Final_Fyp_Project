import 'package:fyp_rememory/app/components/footer.dart';
import 'package:fyp_rememory/app/models/journal.dart';
import 'package:fyp_rememory/app/modules/editJournal/views/edit_journal_view.dart';

import 'package:fyp_rememory/app/modules/showjournal/controllers/showjournal_controller.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShowJournalView extends StatelessWidget {
  final ShowJournalController controller = Get.put(ShowJournalController());
  final TextEditingController searchController = TextEditingController();

  ShowJournalView({Key? key}) : super(key: key);

  // Function to build text with hashtags styled differently

  List<TextSpan> buildTextSpanWithHashtags(String text) {
    // Use a regular expression to match words and hashtags
    RegExp regex = RegExp(r"(\#\w+|\w+|'|\s|\,|\.|\?)");
    Iterable<RegExpMatch> matches = regex.allMatches(text);

    return matches.map((match) {
      String word = match.group(0)!;
      bool isHashtag = word.startsWith('#') && word.length > 1;

      return TextSpan(
        text: word,
        style: isHashtag
            ? const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold) // Hashtag style
            : const TextStyle(color: Colors.black), // Normal text style
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal Entries',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                // Adds a black border with a specified width around the container
                border: Border.all(color: Colors.black, width: 1.0),
                // To make the container a rectangle with sharp corners
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title or tag...',
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder
                        .none, // Remove the underline of the input field
                    contentPadding: const EdgeInsets.symmetric(
                        vertical:
                            10.0), // Vertical padding inside the TextField
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: controller.onSearchTextChanged,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.journalEntries.isEmpty) {
                return const Center(child: Text('No journal entries found'));
              } else {
                return ListView.builder(
                  itemCount: controller.journalEntries.length,
                  itemBuilder: (context, index) {
                    final Journal entry = controller.journalEntries[index];
                    String fullImageUrl = getImageUrl(entry.featuredImage ??
                        ''); // Using getImageUrl from constants.dart

                    return Slidable(
                      key: ValueKey(entry.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              // Pass the journalId to the EditJournalView
                              Get.to(() => const EditJournalView(),
                                  arguments: {'journalId': entry.id});
                            },
                            foregroundColor: const Color(0xFF463A79),
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              if (entry.id != null) {
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
                                          onPressed: () =>
                                              Navigator.of(dialogContext)
                                                  .pop(), // Close the dialog
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Delete',
                                          ),
                                          onPressed: () {
                                            // Now call the delete method from the controller
                                            controller
                                                .deleteJournalEntry(
                                                    entry.id!.toString())
                                                .then((_) => Navigator.of(
                                                        dialogContext)
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
                              } else {
                                // If the entry's ID is null, show a snackbar with an error message
                                Get.snackbar('Error',
                                    'This entry cannot be deleted because it does not have a valid ID.');
                              }
                            },
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Use your desired radius here
                        ),
                        color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.title ?? 'Untitled',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '  at  ${DateFormat.yMMMd().format(entry.createdAt ?? DateTime.now())},',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  if (entry.mood != null &&
                                      entry.mood!.isNotEmpty)
                                    Text(
                                      'Feeling ${entry.mood} in ${entry.location}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black, // Default color
                                        ),
                                        children: buildTextSpanWithHashtags(
                                            entry.entry ?? ''),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  if (entry.featuredImage != null &&
                                      entry.featuredImage!.isNotEmpty)
                                    SizedBox(
                                      width: 379,
                                      height: 200,
                                      child: Image.network(
                                        fullImageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
