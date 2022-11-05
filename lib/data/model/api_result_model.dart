class APIResultModel {
  final bool success;
  final String message;
  final dynamic data;

  APIResultModel({
    required this.success,
    required this.message,
    this.data,
  });

}