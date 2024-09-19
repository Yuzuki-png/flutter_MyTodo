import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_page.g.dart';

class Todo {
  final int id;
  final String task;
  final String detail;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.task,
    required this.detail,
    required this.isCompleted,
  });
}

@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(int id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void toggleCompleted(int id) {
    state = state
        .map((todo) => todo.id == id
            ? Todo(
                id: todo.id,
                task: todo.task,
                detail: todo.detail,
                isCompleted: !todo.isCompleted)
            : todo)
        .toList();
  }

  void editTodo(Todo todo) {
    state = [todo];
  }
}

class NextAddPage extends ConsumerStatefulWidget {
  const NextAddPage({super.key});

  @override
  _NextAddPageState createState() => _NextAddPageState();
}

class _NextAddPageState extends ConsumerState<NextAddPage> {
  final todoContentTaskController = TextEditingController();
  final todoContentDetailController = TextEditingController();
  String selectedStatus = "Not yet"; // ステータスの初期値

  void onPressedAddButton() {
    List<Todo> todoList = ref.read(todoListProvider);
    final todoListNotifier = ref.read(todoListProvider.notifier);

    String task = todoContentTaskController.text;
    String detail = todoContentDetailController.text;
    todoContentDetailController.clear();
    todoContentTaskController.clear();

    bool isCompleted = selectedStatus == "Completion";

    int id = (todoList.isEmpty) ? 1 : todoList.last.id + 1;

    Todo todo =
        Todo(id: id, task: task, detail: detail, isCompleted: isCompleted);
    todoListNotifier.addTodo(todo);
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyHomePage();
        },
      ),
    );
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
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "タスク名",
                style: TextStyle(fontSize: 20),
              )),
          TextField(
            controller: todoContentTaskController,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            decoration: const InputDecoration(hintText: "買い物リスト"),
          ),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "詳細",
                style: TextStyle(fontSize: 20),
              )),
          TextField(
            controller: todoContentDetailController,
            maxLines: 10,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            decoration: const InputDecoration(hintText: "スーパーで買い物をする"),
          ),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ステータス",
                style: TextStyle(fontSize: 20),
              )),
          DropdownButton<String>(
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
          ElevatedButton(
              onPressed: () {
                onPressedAddButton();
              },
              child: const Text("追加"))
        ],
      ),
    );
  }
}
