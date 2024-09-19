import 'package:flutter/material.dart';
import 'package:flutter_application_2/todo_list_edit_page.dart';
import 'package:flutter_application_2/todo_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aaa Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});
  void _pushPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const NextAddPage();
        },
      ),
    );
  }

  Future<void> pushEditPage(BuildContext context, id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyEditPage(
            id: id,
          );
        },
      ),
    );
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todoList = ref.watch(todoListProvider);
    final todoListNotifier = ref.read(todoListProvider.notifier);
    void onPressedDeleteButton(int index) {
      todoListNotifier.removeTodo(todoList[index].id);
    }

    void onPressedToggleButton(int index) {
      todoListNotifier.toggleCompleted(todoList[index].id);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("タスク管理アプリ"),
        ),
        body: Column(
          children: [
            SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                hintText: "検索",
                icon: Icon(Icons.search),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _pushPage(context);
              },
              child: const Text("追加"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Text(todoList[index].id.toString()),
                      const SizedBox(width: 20),
                      Text(todoList[index].task),
                      const SizedBox(width: 20),
                      Text(todoList[index].detail),
                      const SizedBox(width: 20),
                      Text(todoList[index].isCompleted ? "完了" : "未完了"),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          onPressedDeleteButton(index);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 50),
                        ),
                        child: const Text('削除'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onPressedToggleButton(index);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 50),
                        ),
                        child: const Text('切り替え'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pushEditPage(context, todoList[index].id);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 50),
                        ),
                        child: const Text('編集'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'todo作成'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
