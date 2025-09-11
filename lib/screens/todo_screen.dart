import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../services/todo_service.dart';
import '../widgets/todo_input.dart';
import '../widgets/todo_list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TodoService todoService = TodoService();

  bool? completedFilter;
  String searchQuery = '';

  // Pagination info
  int currentPage = 1;
  int totalPages = 1;
  int totalTodos = 0;
  bool hasNextPage = false;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos({bool resetPage = true}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      if (resetPage) currentPage = 1;
    });

    try {
      final todoResponse = await todoService.fetchTodos(
        page: currentPage,
        completed: completedFilter,
        search: searchQuery.isNotEmpty ? searchQuery : null,
      );
      setState(() {
        todos = todoResponse.data;
        totalPages = todoResponse.totalPages;
        totalTodos = todoResponse.total;
        hasNextPage = todoResponse.next != null;
      });
    } catch (e) {
      print('Error fetching todos: $e');
      setState(() {
        errorMessage = 'Failed to load todos: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addTodo(String title) async {
    try {
      final newTodo = await todoService.addTodo(title);
      setState(() {
        todos.insert(0, newTodo);
        controller.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add todo: $e')));
      }
    }
  }

  Future<void> toggleTodo(int index) async {
    final todo = todos[index];
    try {
      final updatedTodo = await todoService.updateTodo(
        todo.id,
        completed: !todo.completed,
      );
      setState(() {
        todos[index] = updatedTodo;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update todo: $e')));
      }
    }
  }

  Future<void> deleteTodo(int index) async {
    final todo = todos[index];
    try {
      await todoService.deleteTodo(todo.id);
      setState(() {
        todos.removeAt(index);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo deleted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete todo: $e')));
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Todos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All'),
              leading: Radio<bool?>(
                value: null,
                groupValue: completedFilter,
                onChanged: (value) {
                  setState(() => completedFilter = value);
                  Navigator.pop(context);
                  fetchTodos();
                },
              ),
            ),
            ListTile(
              title: const Text('Completed'),
              leading: Radio<bool?>(
                value: true,
                groupValue: completedFilter,
                onChanged: (value) {
                  setState(() => completedFilter = value);
                  Navigator.pop(context);
                  fetchTodos();
                },
              ),
            ),
            ListTile(
              title: const Text('Pending'),
              leading: Radio<bool?>(
                value: false,
                groupValue: completedFilter,
                onChanged: (value) {
                  setState(() => completedFilter = value);
                  Navigator.pop(context);
                  fetchTodos();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadNextPage() {
    if (hasNextPage && currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
      fetchTodos(resetPage: false);
    }
  }

  void _loadPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchTodos(resetPage: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchTodos),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchQuery = '';
                          fetchTodos();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                searchQuery = value;
                fetchTodos();
              },
            ),
          ),

          // Add Todo Input
          TodoInput(
            controller: controller,
            onAdd: () {
              if (controller.text.trim().isNotEmpty) {
                addTodo(controller.text.trim());
              }
            },
          ),

          // Filter Chips
          if (completedFilter != null || searchQuery.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (completedFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(completedFilter! ? 'Completed' : 'Pending'),
                        onDeleted: () {
                          setState(() => completedFilter = null);
                          fetchTodos();
                        },
                      ),
                    ),
                  if (searchQuery.isNotEmpty)
                    Chip(
                      label: Text('Search: $searchQuery'),
                      onDeleted: () {
                        searchController.clear();
                        searchQuery = '';
                        fetchTodos();
                      },
                    ),
                ],
              ),
            ),

          // Todo List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchTodos,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos found.\nAdd your first todo above!',
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: [
                      // Pagination info
                      if (totalTodos > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: $totalTodos todos',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                'Page $currentPage of $totalPages',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      // Todo list
                      Expanded(
                        child: TodoList(
                          todos: todos,
                          onToggle: toggleTodo,
                          onDelete: deleteTodo,
                        ),
                      ),
                      // Pagination controls
                      if (totalPages > 1)
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: currentPage > 1
                                    ? _loadPreviousPage
                                    : null,
                                child: const Text('Previous'),
                              ),
                              Text('$currentPage / $totalPages'),
                              ElevatedButton(
                                onPressed: hasNextPage ? _loadNextPage : null,
                                child: const Text('Next'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
