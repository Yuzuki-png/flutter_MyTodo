import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_2/todo_list_page.dart';

class MyEditPage extends ConsumerWidget {
  MyEditPage({super.key, required this.id});

  final int id;
  final todoContentTaskController = TextEditingController();
  final todoContentDetailController = TextEditingController();
  String selectedStatus = "Not yet"; // ステータスの初期値

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todoList = ref.watch(todoListProvider);
    final todoListNotifier = ref.read(todoListProvider.notifier);

    Todo? todo = todoList.firstWhere((element) => element.id == id);

    //初期値として前のデータを入れる
    todoContentTaskController.text = todo.task;
    todoContentDetailController.text = todo.detail;
    selectedStatus = todo.isCompleted ? "Completion" : "Not yet";

    onPressedSaveButton() {
      String task = todoContentTaskController.text;
      String detail = todoContentDetailController.text;
      todoContentDetailController.clear();
      todoContentTaskController.clear();
      bool isCompleted = selectedStatus == "Completion";

      Todo todo =
          Todo(id: id, task: task, detail: detail, isCompleted: isCompleted);
      todoListNotifier.editTodo(todo);
      Navigator.pop(
        context,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("タスク編集"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "タスク名",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              controller: todoContentTaskController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: const InputDecoration(hintText: "タスク名を入力"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "詳細",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              controller: todoContentDetailController,
              maxLines: 10,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: const InputDecoration(hintText: "詳細を入力"),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ステータス",
                style: TextStyle(fontSize: 20),
              ),
            ),
            DropdownButton<String>(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: "Not yet", child: Text("未着手")),
                DropdownMenuItem(value: "Completion", child: Text("完了")),
              ],
              onChanged: (String? newValue) {
                selectedStatus = newValue!;
              },
            ),
            ElevatedButton(
              onPressed: () {
                onPressedSaveButton();
              },
              child: const Text("保存"),
            ),
          ],
        ),
      ),
    );
  }
}
