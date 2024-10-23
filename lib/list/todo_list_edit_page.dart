import 'package:flutter/material.dart';
import 'package:flutter_application_2/provider/todo_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyEditPage extends ConsumerStatefulWidget {
  final Todo todo;

  const MyEditPage({Key? key, required this.todo}) : super(key: key);

  @override
  _MyEditPageState createState() => _MyEditPageState();
}

class _MyEditPageState extends ConsumerState<MyEditPage> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  String selectedStatus = "Not yet";

  @override
  void initState() {
    super.initState();
    taskController.text = widget.todo.task;
    detailController.text = widget.todo.detail;
    selectedStatus = widget.todo.isCompleted ? "Completion" : "Not yet";
  }

  void _onSave() {
    final todoListNotifier = ref.read(todoListProvider.notifier);
    final updatedTodo = widget.todo.copyWith(
      task: taskController.text,
      detail: detailController.text,
      isCompleted: selectedStatus == "Completion",
    );

    todoListNotifier.editTodoLocal(updatedTodo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("タスク編集"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "タスク名",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
            child: TextField(
              controller: taskController,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: const InputDecoration(hintText: "タスク名を入力"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "詳細",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
            child: TextField(
              controller: detailController,
              maxLines: 10,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: const InputDecoration(hintText: "詳細を入力"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ステータス",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
            child: DropdownButton<String>(
              underline: Container(height: 2, color: Colors.black),
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: "Not yet", child: Text("未着手")),
                DropdownMenuItem(value: "Completion", child: Text("完了")),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text("保存"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
