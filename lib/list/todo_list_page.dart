import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/provider/todo_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NextAddPage extends ConsumerStatefulWidget {
  const NextAddPage({super.key});
  @override
  _NextAddPageState createState() => _NextAddPageState();
}

class _NextAddPageState extends ConsumerState<NextAddPage> {
  final todoContentTaskController = TextEditingController();
  final todoContentDetailController = TextEditingController();
  String selectedStatus = "Not yet"; // ステータスの初期値を未着手に設定

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void onPressedAddButton() {
    if (todoContentTaskController.text.isEmpty) {
      showErrorDialog("エラー", "タスク名が入力されていません");
      return;
    }
    if (todoContentDetailController.text.isEmpty) {
      showErrorDialog("エラー", "詳細が入力されていません");
      return;
    }

    String task = todoContentTaskController.text;
    String detail = todoContentDetailController.text;
    bool isCompleted = selectedStatus == "Completion";

    Todo todo = Todo(
      id: DateTime.now().toString(),
      task: task,
      detail: detail,
      isCompleted: isCompleted,
    );

    final todoListNotifier = ref.read(todoListProvider.notifier);
    todoListNotifier.addTodoLocal(todo);

    todoContentTaskController.clear();
    todoContentDetailController.clear();

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("タスク管理アプリ追加"),
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
              controller: todoContentTaskController,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: const InputDecoration(hintText: "買い物リスト"),
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
              controller: todoContentDetailController,
              maxLines: 10,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: const InputDecoration(hintText: "スーパーで買い物をする"),
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
            child: DropdownButton(
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
                onPressed: onPressedAddButton,
                child: const Text("保存"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
