import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';
import '../models/todo_response.dart';

class TodoService {
  final String baseUrl =
      'https://todo-test-app-bvamb3h2hrgsarer.eastus2-01.azurewebsites.net/api';

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_userId != null) 'user-id': _userId!,
  };

  // Get all todos with optional pagination, filtering, and sorting
  Future<TodoResponse> fetchTodos({
    int page = 1,
    int limit = 10,
    bool? completed,
    String? search,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };

    if (completed != null) queryParams['completed'] = completed.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse(
      '$baseUrl/todos',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return TodoResponse.fromJson(responseData);
    } else {
      print('Failed to load todos: ${response.statusCode}');
      throw Exception('Failed to load todos: ${response.statusCode}');
    }
  }

  // Get a specific todo by ID
  Future<Todo> getTodo(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/todos/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load todo: ${response.statusCode}');
    }
  }

  // Create a new todo
  Future<Todo> addTodo(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: _headers,
      body: json.encode({'title': title, 'completed': false}),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add todo: ${response.statusCode}');
    }
  }

  // Update a todo
  Future<Todo> updateTodo(int id, {String? title, bool? completed}) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (completed != null) body['completed'] = completed;

    final response = await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: _headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update todo: ${response.statusCode}');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo: ${response.statusCode}');
    }
  }
}
