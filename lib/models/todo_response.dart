import 'todo_model.dart';

class TodoResponse {
  final List<Todo> data;
  final int total;
  final int totalPages;
  final int currentPage;
  final PaginationInfo? next;
  final PaginationInfo? previous;

  TodoResponse({
    required this.data,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    this.next,
    this.previous,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) {
    return TodoResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      next: json['next'] != null
          ? PaginationInfo.fromJson(json['next'] as Map<String, dynamic>)
          : null,
      previous: json['previous'] != null
          ? PaginationInfo.fromJson(json['previous'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PaginationInfo {
  final int page;
  final int limit;

  PaginationInfo({required this.page, required this.limit});

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(page: json['page'] ?? 1, limit: json['limit'] ?? 10);
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit};
  }
}
