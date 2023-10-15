import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class Task {
  final String title;
  final String details;

  Task({required this.title, required this.details});
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> taskList = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int editingIndex = -1; // Track the index being edited

  void deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
    });
  }

  void editTask(int index, String newTitle, String newDetails) {
    setState(() {
      taskList[index] = Task(title: newTitle, details: newDetails);
      editingIndex = -1; // Reset editingIndex after updating
    });
  }

  void addTask() {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      if (editingIndex != -1) {
        editTask(editingIndex, title, description);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task updated!')),
        );
      } else {
        Task task = Task(title: title, details: description);
        setState(() {
          taskList.add(task);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added!')),
        );
      }
      titleController.clear();
      descriptionController.clear();
    }
  }

  Future<void> _showEditBottomSheet(int index) async {
    titleController.text = taskList[index].title;
    descriptionController.text = taskList[index].details;

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Edit Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Edit Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    editTask(index, titleController.text, descriptionController.text);
                    Navigator.pop(context); // Close the bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task updated!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Title and description cannot be empty!')),
                    );
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAlertDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Choose an action'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _showEditBottomSheet(index);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                deleteTask(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task deleted!')),
                );
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.greenAccent,
        title: Text(
          'CRUD',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.black),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Add Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Add Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          addTask();
                        },
                        child: Text('Add'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      _showAlertDialog(index);
                    },
                    subtitle: Text(taskList[index].details),
                    title: Text(taskList[index].title),
                    leading: CircleAvatar(
                      child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.black,
                    height: 30,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
