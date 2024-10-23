import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_provider.g.dart';
part 'todo_list_provider.freezed.dart';

@freezed
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String task,
    required String detail,
    required bool isCompleted,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson({
        'id': json['id'] as String,
        'task': json['task'] as String,
        'detail': json['detail'] as String,
        'isCompleted': json['isToggle'] ?? false,
      });
}

@riverpod
class TodoList extends _$TodoList {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3012/todo'));

  @override
  Future<List<Todo>> build() async {
    return await fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _dio.get('/getList');
      final todos = (response.data as List<dynamic>)
          .map((todo) => Todo.fromJson(todo as Map<String, dynamic>))
          .toList();
      return todos;
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  // Future<void> addTodoToApi(Todo todo) async {
  //   try {
  //     await _dio.post('/registration', data: {
  //       'task': todo.task,
  //       'detail': todo.detail,
  //       'isCompleted': todo.isCompleted,
  //     });
  //     state = await AsyncValue.guard(() => fetchTodos());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> editTodoFromApi(Todo updatedTodo) async {
  //   try {
  //     await _dio.post('/edit/${updatedTodo.id}', data: updatedTodo.toJson());
  //     state = await AsyncValue.guard(() => fetchTodos());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> removeTodoFromApi(String id) async {
    try {
      await _dio.delete('/delete/$id');
      state = await AsyncValue.guard(() => fetchTodos());
    } catch (e) {
      print(e);
    }
  }

  // Future<void> isToggleApi(Todo todo) async {
  //   try {
  //     final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
  //     await _dio.post('/edit/${updatedTodo.id}', data: updatedTodo.toJson());
  //     state = await AsyncValue.guard(() => fetchTodos());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void addTodoLocal(Todo todo) {
    final currentState = state.value ?? <Todo>[];
    final newState = [...currentState, todo];
    state = AsyncValue.data(newState);
  }

  void removeTodoLocal(String id) {
    final currentState = state.value ?? <Todo>[];
    state =
        AsyncValue.data(currentState.where((todo) => todo.id != id).toList());
  }

  void editTodoLocal(Todo updatedTodo) {
    final currentState = state.value ?? <Todo>[];
    state = AsyncValue.data(currentState
        .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
        .toList());
  }

  void isToggleLocal(String id) {
    final currentState = state.value ?? <Todo>[];

    final updatedState = currentState.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    state = AsyncValue.data(updatedState);
  }
}
