import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:fyp_rememory/app/modules/explore/controllers/explore_controller.dart';
import 'package:fyp_rememory/app/models/explore_post.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../components/footer.dart';
import '../../../utils/constants.dart';

class ExploreView extends GetView<ExploreController> {
  final TextEditingController searchController = TextEditingController();

  ExploreView({Key? key}) : super(key: key);
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
    Get.lazyPut(() => ExploreController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Explore Journal',
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
                    hintText: 'Search by user, title or tag...',
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
              } else {
                return ListView.builder(
                  itemCount: controller.journalEntries.length,
                  itemBuilder: (context, index) {
                    final Journal journal = controller.journalEntries[index];
                    String fullImageUrl =
                        getImageUrl(journal.featuredImage ?? '');
                    String profileImageUrl =
                        getImageUrl(journal.profileImage ?? '');
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Use your desired radius here
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
                                backgroundImage: journal.profileImage != null
                                    ? NetworkImage(
                                        profileImageUrl,
                                      )
                                    : const AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider, // AssetImage is used as a fallback
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    journal.fullName,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (journal.mood.isNotEmpty)
                                    Text(
                                      '  feels ${journal.mood} ',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(
                                'Posted on ${DateFormat.yMMMd().format(journal.createdAt as DateTime)}',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 17),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Colors.black, // Default color
                                            ),
                                            children: buildTextSpanWithHashtags(
                                                journal.entry),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      if (journal.featuredImage != null &&
                                          journal.featuredImage!.isNotEmpty)
                                        Expanded(
                                          // This makes the child fill the available space.
                                          child: Image.network(
                                            fullImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          // Implement your like function in the controller
                                          controller
                                              .toggleLike(journal.journalId);
                                        },
                                        icon: Icon(
                                          journal.isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: journal.isLiked
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        label: Text(
                                          '${journal.likeCount} Likes',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
      // Assuming you have a bottom navigation bar component
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
