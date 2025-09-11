import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final void Function(int) onToggle;
  final void Function(int)? onDelete;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.completed ? TextDecoration.lineThrough : null,
                color: todo.completed ? Colors.grey : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created: ${_formatDate(todo.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (todo.updatedAt != todo.createdAt)
                  Text(
                    'Updated: ${_formatDate(todo.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            leading: Checkbox(
              value: todo.completed,
              onChanged: (_) => onToggle(index),
            ),
            trailing: onDelete != null
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, index),
                  )
                : null,
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: Text(
            'Are you sure you want to delete "${todos[index].title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete!(index);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
