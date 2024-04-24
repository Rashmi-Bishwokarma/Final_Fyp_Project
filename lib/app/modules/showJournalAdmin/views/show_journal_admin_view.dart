import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import the Slidable widget
import 'package:fyp_rememory/app/modules/showJournalAdmin/controllers/show_journal_admin_controller.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:fyp_rememory/app/models/explore_post.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShowJournalAdminView extends GetView<ShowJournalAdminController> {
  final TextEditingController searchController = TextEditingController();

  ShowJournalAdminView({Key? key}) : super(key: key);

  List<TextSpan> buildTextSpanWithHashtags(String text) {
    RegExp regex = RegExp(r"(\#\w+|\w+|'|\s|\,|\.|\?)");
    Iterable<RegExpMatch> matches = regex.allMatches(text);

    return matches.map((match) {
      String word = match.group(0)!;
      bool isHashtag = word.startsWith('#') && word.length > 1;

      return TextSpan(
        text: word,
        style: isHashtag
            ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
            : const TextStyle(color: Colors.black),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ShowJournalAdminController());

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 243, 244),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 239, 243, 244),
        title: const Text('Public Journal View'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by user, title or tag...',
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: controller.onSearchTextChanged,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: controller.journalEntries.length,
                    itemBuilder: (context, index) {
                      final Journal journal = controller.journalEntries[index];
                      String fullImageUrl =
                          getImageUrl(journal.featuredImage ?? '');
                      String profileImageUrl =
                          getImageUrl(journal.profileImage ?? '');

                      // Wrap each Card with a Slidable widget
                      return Slidable(
                        key: ValueKey(journal.journalId),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Add your edit action here
                              },
                              backgroundColor: Colors.blue,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Add your delete action here
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: journal.profileImage !=
                                            null
                                        ? NetworkImage(
                                            profileImageUrl,
                                          )
                                        : const AssetImage(
                                                'assets/images/default_avatar.png')
                                            as ImageProvider, // AssetImage is used as a fallback
                                  ),
                                  title: Text(journal.fullName,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  subtitle: Text(
                                    'Posted on ${DateFormat.yMMMd().format(journal.createdAt)}',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          children: buildTextSpanWithHashtags(
                                              journal.entry),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (journal.featuredImage != null &&
                                          journal.featuredImage!.isNotEmpty)
                                        Image.network(fullImageUrl,
                                            fit: BoxFit.cover),
                                      const SizedBox(height: 5),
                                      const Divider(),
                                      Text(
                                        'Total: ${journal.likeCount} Likes',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}
