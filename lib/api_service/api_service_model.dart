
class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final String? message;
  final bool success;

  ApiResponse({
    this.data,
    this.statusCode,
    this.message,
    this.success = false,
  });

  factory ApiResponse.success(T data, int code) => ApiResponse(
    data: data,
    statusCode: code,
    success: true,
  );

  factory ApiResponse.error(String message, [int? code]) => ApiResponse(
    message: message,
    statusCode: code,
    success: false,
  );
}
