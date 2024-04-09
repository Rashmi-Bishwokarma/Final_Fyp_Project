import 'package:flutter/material.dart';

// Add a callback function to the constructor
class EmojiDropdown extends StatefulWidget {
  final Function(String)? onMoodChanged;

  const EmojiDropdown({key, this.onMoodChanged});

  @override
  EmojiDropdownState createState() => EmojiDropdownState();
}

class EmojiDropdownState extends State<EmojiDropdown> {
  String? selectedMood;

  final Map<String, String> moods = {
    '😊': 'happiness',
    '😂': 'joy',
    '🥳': 'proud',
    '😞': 'sadness',
    '😨': 'fear',
    '😳': 'embarrassment',
    '😟': 'worry',
    '😠': 'anger',
    '😡': 'upset',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        hintText: 'How are you feeling today?',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
      ),
      value: selectedMood,
      items: moods.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value,
          child: Row(
            children: [
              Text(entry.key),
              const SizedBox(width: 8),
              Text(entry.value),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedMood = newValue;
        });
        // Call the callback function when the mood changes
        if (widget.onMoodChanged != null) {
          widget.onMoodChanged!(newValue!);
        }
      },
    );
  }
}
