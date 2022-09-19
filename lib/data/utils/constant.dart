
import 'package:dio/dio.dart';

const placeHolderImage =
    "https://www.escapeauthority.com/wp-content/uploads/2116/11/No-image-found.jpg";

const apiKey = "AIzaSyCVy_LzCTaZn-MCwJF6qElGO3gc5K0JwI8";


String serverFailureMessage = 'Server Failure';
String cashFailureMessage = 'Cache Failure';
String networkFailureMessage = 'network not available';

String handleError(dynamic error) {
  String errorDescription = "";

  print("handleError:: error >> $error");

  if (error is DioError) {
    print("************************ DioError ************************");

    DioError dioError = error;
    print("dioError:: $dioError");
    if (dioError.response != null) {
      print("dioError:: response >> ${dioError.response}");
    }

    switch (dioError.type) {
      case DioErrorType.other:
        errorDescription =
        "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        errorDescription = "Error: ${dioError.response?.data["message"]}";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
  } else {
    errorDescription = "Unexpected error occured";
  }
  print("handleError:: errorDescription >> $errorDescription");
  return errorDescription;
}
