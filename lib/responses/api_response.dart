class ApiResponse<T> {
  T? data;
  String? message;
  int? status;

  ApiResponse({this.message, this.status});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'message': String message,
        'status': int status,
      } =>
        ApiResponse(
          message: message,
          status: status,
        ),
      _ => throw const FormatException('Failed to load Data.'),
    };
  }
}
