class APIConstants {
  static const String octetStream = "application/octet-stream";
  static const String baseUrl = "http://sing.appsmata.com/";
  //static const String baseUrl = "http://192.168.43.18/projects/vsongweb/";
}

class ApiStrings {
  static const String areYouConnected = "Je, umeunganishwa?";
  static const String noConnection = "Hauna Mwungano wa Mtandao";
  static const String noInternetConnection =
      "Masalale! Hili linavunja moyo sana. Huonekani kuwa na mwungano imara wa mtandao.\n\n" +
          "Tafadhali jiunge na mtandao imara kupitia kwa Wi-Fi or Data ya Simu halafu jaribu tena.";
}

class APIOperations {
  static const String success = "success";
  static const String failure = "failure";
  static const String suspended = "suspended";
  static const String unpermited = "unpermited";
  static const String missing = "missing";
  static const String invalid = "invalid";
  static const String already = "already";

  static const String login = "login";
  static const String register = "register";
  static const String changePassword = "chgpass";

  static const String postsLists = "as-client/posts-lists.php";
  static const String postsSelect = "as-client/posts-select.php";
  static const String postsSingle = "as-client/posts-single.php";
  static const String postsAnswers = "as-client/posts-answers.php";
  static const String postsSearch = "as-client/posts-search.php";
  static const String postsSlider = "as-client/posts-slider.php";
  static const String postsByCategory = "as-client/posts-by-category.php";
  static const String categoriesAll = "as-client/categories.php";
  static const String booksSelect = "as-client/book-select.php";
  static const String feedback = "as-client/feedback.php";
  static const String showComment = "as-client/comment-by-id.php";
  static const String sountComment = "as-client/comment-submit.php";
  static const String backgroundDrawer = "as-client/bg-drawer.php";
  static const String userSignin = "as-client/user-signin.php";
  static const String userSignup = "as-client/user-signup.php";
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
