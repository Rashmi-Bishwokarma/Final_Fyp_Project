import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/to_do_list_controller.dart'; // Ensure this path is correct
import 'package:fyp_rememory/app/models/to_do_list.dart';
import 'package:fyp_rememory/app/components/footer.dart'; // Ensure this path is correct

class ToDoListView extends GetView<ToDoListController> {
  @override
  final ToDoListController controller = Get.put(ToDoListController());

  ToDoListView({Key? key}) : super(key: key);

  bool _hasTasksForDay(DateTime day) {
    // Assuming your tasks are stored in a list in the controller
    var tasks = controller.todoList.value?.tasks ?? [];
    return tasks.any((task) => isSameDay(task.startDate, day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo List',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: controller.focusedDay.value,
                      calendarFormat: controller.calendarFormat.value,
                      onDaySelected: (selectedDay, focusedDay) {
                        controller.onDaySelected(selectedDay, focusedDay);
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(controller.selectedDay.value, day);
                      },
                      onFormatChanged: (format) {
                        // Update the calendarFormat in your controller or state
                        controller.calendarFormat.value = format;
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, date, focusedDay) {
                          if (_hasTasksForDay(date)) {
                            // Return a Container with green background if the day has tasks
                            return Center(
                              child: Text(
                                '${date.day}', // Display the day of the month
                                style: const TextStyle(
                                    color: Colors
                                        .red), // Text color that contrasts with the background
                              ),
                            );
                          }
                          // Return null to use the default builder for dates without tasks
                          return null;
                        },
                        // Keep other builder properties if needed
                      ),

                      // Add other configurations as needed
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Tasks',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    var filteredTasks =
                        controller.todoList.value?.tasks?.where((task) {
                              // Check if task.startDate is not null before comparing
                              if (task.startDate != null) {
                                return isSameDay(task.startDate!,
                                    controller.selectedDay.value);
                              }
                              return false; // If task.startDate is null, filter it out
                            }).toList() ??
                            [];

                    return filteredTasks.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              return Slidable(
                                key: ValueKey(task.id),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        _showEditTaskDialog(context, task);
                                      },
                                      foregroundColor: const Color(0xFF463A79),
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Delete Task'),
                                              content: Text(
                                                'Are you sure you want to delete this task?',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Delete',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    controller.deleteTask(
                                                        task.id.toString());
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
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      color: const Color.fromRGBO(
                                          244, 245, 246, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            task.title ?? 'Untitled',
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '  at  ${DateFormat.yMMMd().format(task.createdAt ?? DateTime.now())},',
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.description ??
                                                "No Description",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                task.startTime != null
                                                    ? DateFormat('H:mm').format(
                                                        DateFormat('HH:mm:ss')
                                                            .parse(task
                                                                .startTime!))
                                                    : "Not set",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                ' - ',
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                task.endTime != null
                                                    ? DateFormat('H:mm').format(
                                                        DateFormat('HH:mm:ss')
                                                            .parse(
                                                                task.endTime!))
                                                    : "Not set",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 6.0),
                                            decoration: BoxDecoration(
                                              color: task.priority == 'High'
                                                  ? Colors.red
                                                  : task.priority == 'Low'
                                                      ? Colors.orange
                                                      : Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Text(
                                              task.priority ?? "Normal",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                            'No tasks found for this date',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add, color: Color(0xFF473A79)),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
          currentIndex: 3), // Ensure this component exists or adjust as needed
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    TextEditingController startDateController = TextEditingController();
    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();
    String priority = 'Normal'; // Default priority

    // Function to open date picker for due date
    Future<void> selectDate(
        BuildContext context, TextEditingController startDateController) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (pickedDate != null) {
        // Correctly formats the pickedDate to a string in 'yyyy-MM-dd' format
        startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      }
    }

    Future<void> selectTime(
        BuildContext context, TextEditingController controller) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        // ignore: use_build_context_synchronously
        controller.text = pickedTime.format(context);
      }
    }

    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('Add New Task'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => selectDate(context, startDateController),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: startDateController,
                            decoration: InputDecoration(
                              hintText: "Start Date",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 16,
                              ),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => selectTime(context, startTimeController),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: startTimeController,
                            decoration: InputDecoration(
                              hintText: "Start Time",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 16,
                              ),
                              icon: const Icon(Icons.access_time),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => selectTime(context, endTimeController),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: endTimeController,
                            decoration: InputDecoration(
                              hintText: "End Time",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 16,
                              ),
                              icon: const Icon(Icons.access_time),
                            ),
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: priority,
                        onChanged: (String? newValue) {
                          setState(() {
                            priority = newValue!;
                          });
                        },
                        items: <String>['Low', 'Normal', 'High']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Cancel ',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(
                      'Add',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty) {
                        // Example function call to add task; adapt based on your actual data handling
                        controller.addTask(
                          title: titleController.text,
                          description: descriptionController.text,
                          startDate: startDateController.text,
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                          priority: priority,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}

void _showEditTaskDialog(BuildContext context, Task task) {
  // Initialize text controllers with the task's current data
  TextEditingController titleController =
      TextEditingController(text: task.title);
  TextEditingController descriptionController =
      TextEditingController(text: task.description);
  TextEditingController startDateController = TextEditingController(
      text: task.startDate != null
          ? DateFormat('yyyy-MM-dd').format(task.startDate!)
          : '');
  TextEditingController startTimeController =
      TextEditingController(text: task.startTime ?? '');
  TextEditingController endTimeController =
      TextEditingController(text: task.endTime ?? '');
  String priority = task.priority ?? 'Normal'; // Default priority
  Future<void> selectDate(
      BuildContext context, TextEditingController startDateController) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      // Correctly formats the pickedDate to a string in 'yyyy-MM-dd' format
      startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      // ignore: use_build_context_synchronously
      controller.text = pickedTime.format(context);
    }
  }

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
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectDate(context, startDateController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          hintText: "Start Date",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectTime(context, startTimeController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          hintText: "Start Time",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectTime(context, endTimeController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                          hintText: "End Time",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: priority,
                    onChanged: (String? newValue) {
                      setState(() {
                        priority = newValue!;
                      });
                    },
                    items: <String>['Low', 'Normal', 'High']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                  // Update task with new details
                  final ToDoListController controller =
                      Get.find<ToDoListController>();
                  controller.editTask(
                    taskId: task.id.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    startDate: startDateController.text,
                    startTime: startTimeController.text,
                    endTime: endTimeController.text,
                    priority: priority,
                  );
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    },
  );
}
