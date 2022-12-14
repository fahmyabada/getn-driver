import 'package:dio/dio.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

const placeHolderImage =
    "https://www.escapeauthority.com/wp-content/uploads/2116/11/No-image-found.jpg";

const apiKeyAndroid = "AIzaSyBw4jfzf6T0r8C8BZK6f7PG_3JJXoDOe70";
const apiKeyIos = "AIzaSyBD1KUeURXjZajvtxdqFnjrqaNvPJPnEzs";

String serverFailureMessage = 'Server Failure';
String cashFailureMessage = 'Cache Failure';
// String LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString() = 'network not available';

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
        errorDescription = dioError.response?.data["message"] is Map
            ? getMapValues(dioError.response?.data["message"])
            : dioError.response?.data["message"];
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
  } else {
    errorDescription = "Unexpected error occurred : $error";
  }
  print(
      "handleError:: errorDescription >> ${errorDescription.replaceAll('(', '').replaceAll(')', '')}");
  return errorDescription;
}

getMapValues(map) {
  String values = "";
  map.forEach((key, value) {
    values += "$value\n";
  });
  return values;
}

String handleErrorFirebase(String type, dynamic error) {
  switch (error) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
    case "[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.":
      return LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('SmsVerificationExpired')
          .toString();
    case "[firebase_auth/invalid-verification-code] The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.":
      return LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('SmsVerificationInvalid')
          .toString();
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
    default:
      if (type == "login") {
        return "Login failed. Please try again.";
      } else {
        return "register failed. Please try again.";
      }
  }
}
