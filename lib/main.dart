import 'package:flutter/material.dart';
import 'package:flutter_application_2/list/todo_list_edit_page.dart';
import 'package:flutter_application_2/list/todo_list_page.dart';
import 'package:flutter_application_2/provider/todo_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'MyHomePage',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: MyHomePage(),
        );
      },
    ),
    GoRoute(
      path: '/MyEditPage',
      name: 'MyEditPage',
      pageBuilder: (context, state) {
        final todo = state.extra as Todo; // state.extra から todo を取得
        return MaterialPage(
          child: MyEditPage(todo: todo), // 必須パラメータ`todo`を渡す
        );
      },
    ),
    GoRoute(
      path: '/NextAddPage',
      name: 'NextAddPage',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: NextAddPage(),
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.push('/NextAddPage');
        break;
      case 2:
        break;
    }
  }

  void _pushEditPage(int index) {
    final todoList = ref.read(todoListProvider);
    context.push(
      '/MyEditPage',
      extra: todoList.asData!.value[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoListProvider);
    final todoListNotifier = ref.read(todoListProvider.notifier);

    // if (todoList.isLoading || todoList.hasError) {
    //   return Container(
    //     child: Text("ロード中またはエラー発生"),
    //   );
    // }

    void onPressedDeleteButton(int index) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("確認"),
            content: const Text("このタスクを削除してもよろしいですか？"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => context.pop(),
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  todoListNotifier
                      .removeTodoFromApi(todoList.asData!.value[index].id);
                  context.pop();
                },
              ),
            ],
          );
        },
      );
    }

    void onPressedToggleButton(int index) {
      final todoId = todoList.asData!.value[index].id;
      todoListNotifier.isToggleLocal(todoId);
    }

    void _pushPage(BuildContext context) {
      context.push("/NextAddPage");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("タスク管理アプリ"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _pushPage(context);
                },
                child: const Text("➕追加"),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.asData!.value.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todoList.asData!.value[index].task),
                      Text(todoList.asData!.value[index].detail),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          todoList.asData!.value[index].isCompleted
                              ? "完了"
                              : "未完了",
                          style: TextStyle(
                            color: todoList.asData!.value[index].isCompleted
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    onPressedDeleteButton(index);
                                  },
                                  child: const Text('削除'),
                                ),
                                const SizedBox(width: 70),
                                ElevatedButton(
                                  onPressed: () {
                                    onPressedToggleButton(index);
                                  },
                                  child: const Text('切り替え'),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pushEditPage(index);
                              },
                              child: const Text('編集'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
