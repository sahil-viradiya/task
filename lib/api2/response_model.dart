// Response Model
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final int? totalRecord;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.totalRecord,
  });

  factory ApiResponse.success(T data, {String message = 'Success', int? statusCode, int? totalRecord}) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
      totalRecord: totalRecord,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, int? totalRecord}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      totalRecord: totalRecord,
    );
  }
}