class APIConstants {
  static const String octetStream = "application/octet-stream";
  static const String baseUrl = "https://sing.appsmata.com/";
  //static const String baseUrl = "http://192.168.43.18/projects/vsongweb/";
}

class ApiStrings {
  static const String areYouConnected = "Are you connected?";
  static const String noConnection = "No Internet Connection";
  static const String noInternetConnection =
      "Oops! This is heart breaking. Its seems like you don't have a relaible internet connection.\n\n" +
          "Please enable your mobile data or Wi-Fi before trying again.";
}

class APIOperations {
  static const String success = "success";
  static const String failure = "failure";
  static const String suspended = "suspended";
  static const String unpermited = "unpermited";
  static const String missing = "missing";
  static const String invalid = "invalid";
  static const String already = "already";

  static const String postsSelect = "as-client/posts-select.php";
  static const String booksSelect = "as-client/book-select.php";
  static const String userLastseen = "as-client/user-lastseen.php";
}

class EventConstants {
  static const int noInternetConnection = 0;

  static const int requestSuccessful = 300;
  static const int requestUnsuccessful = 301;
  static const int requestNotFound = 302;
  static const int requestSuspended = 303;
  static const int requestUnpermited = 304;
  static const int requestInvalid = 305;

  static const int userSigninSuccessful = 500;
  static const int userSigninUnsuccessful = 501;
  static const int userNotFound = 502;
  static const int userSignupSuccessful = 503;
  static const int userSignupUnsuccessful = 504;
  static const int userAlreadyRegistered = 505;
  static const int signupSuspended = 506;
  static const int signupUnpermited = 507;
  static const int changePasswordSuccessful = 508;
  static const int changePasswordUnsuccessful = 509;
  static const int invalidOldPassword = 510;
}

class APIResponseCode {
  static const int scOK = 200;
}
