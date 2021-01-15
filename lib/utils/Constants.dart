class APIConstants {
  static const String octetStream = "application/octet-stream";
  static const String baseUrl = "http://sing.appsmata.com/";
  //static const String baseUrl = "http://192.168.43.18/projects/vsongweb/";
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

class SharedPreferenceKeys {
  static const String isUserLoggedin = "songbook_user_signedin";
  static const String userCountryName = "songbook_country_name";
  static const String userCountryIcode = "songbook_country_icode";
  static const String userCountryCcode = "songbook_country_ccode";
  static const String appBooksLoaded = "songbook_books_loaded";
  static const String appSongsLoaded = "songbook_songs_loaded";
  static const String userMobile = "songbook_user_mobile";
  static const String selectedBooks = "songbook_selected_books";
  static const String user = "songbook_user";
  static const String darkMode = "songbook_dark_mode";
  static const String screenAwake = "songbook_screen_awake";
}

class LangStrings {
  static const String appName = "vSongBook";
  static const String appVersion = " v1.8.2";
  static const String appSlogan = "Freedom to sing anywhere";

  static const String appTheme = "Display Theme";
  static const String darkMode = "Dark Mode";
  static const String lightMode = "Light Mode";
  static const String screenAwake = "Screen Awake";
  static const String screenAwakeOn = "Screen will be ON indefinately when viewing a song";
  static const String screenAwakeOff = "Screen will go OFF if inactive when viewing a song";
  static const String isEnabled = " enabled";
  static const String isDisabled = " disabled";

  static const String quickSettings = "Quick Settings";

  static const String justAMinute = "Just a minute!";
  static const String inProgress = "In progress ...";
  static const String userSignin = "Signing you in ...";
  static const String userChangePassword = "Changing ...";
  static const String userSignup = "Signing you up ...";
  static const String fetchingData = "Fetching Data ...";
  static const String gettingReady = "Getting ready ...";
  static const String somePatience = "Eish! ... Some patience ...";
  static const String noFavs = "Oops! You are all caught up. Mmmmh... Why not start favouriting songs right away!";
  static const String noDrafts = "Oops! You are all caught up. Mmmmh... Why not start drafting something right away!";
  static const String noSongs = "Oops! You are all caught up. Mmmmh... Head to manage your songbooks afresh!";

  static const String copySong = "Copy Song to Clipboard";
  static const String shareSong = "Share this Song";
  static const String editSong = "Edit this Song";
  static const String copyVerse = "Copy Verse to Clipboard";
  static const String shareVerse = "Share this Verse";
  static const String imageVerse = "Share an Image of this Verse";
  static const String takeTimeSelecting = "Take time to select a songbook at a time so as to setup your vSongBook Collection.\n\n" +
          "Once done that, proceed to press the 'TICK' button at the top right or bottom right for next stage\n\n" +
          "We can always bring you back here to add or remove songbooks";

  static const String noInternetConnection = "No internet connection";
  static const String signinSuccessful = "Sign in was successful";
  static const String signinUnsuccessful = "Oops! Your sign in was unsuccessful";
  static const String changePasswordSuccessful = "Changing your password was successful";
  static const String shangePasswordUnsuccessful = "Change password was unsuccessful";
  static const String signupSuccessful = "Registration was successful";
  static const String signupUnsuccessful = "Registration was unsuccessful";
  static const String userAlreadyRegistered = "User already registered";
  static const String userNotFound = "User not found, Let's know you more";
  static const String signupSuspended = "Registration temporarily suspended. Try again soon";
  static const String signupUnpermited = "You have no permission to proceed";
  static const String enterPass = "Please enter your password";
  static const String enterNewPass = "Please enter your password";
  static const String enterOldPass = "Please enter your old password";
  static const String enterEmail = "Please enter your email id";
  static const String enterPhone = "Please enter your Mobile Number";
  static const String enterValidMail = "Please enter valid email id";
  static const String enterName = "Please enter your name";
  static const String invalidOldPassword = "Invalid old password";
  static const String invalidEntry = "Invalid entry!";

  static const String requestSuccessful = "Request was successful";
  static const String requestUnsuccessful = "Request was unsuccessful";
  static const String requestNotFound = "Request was not found";
  static const String requestSuspended = "Request was suspended";
  static const String requestUnpermited = "Request not permitted at the moment";
  static const String requestInvalid = "Request is invalid";
  static const String songCopied = "Song copied to clipboard!";
  static const String verseCopied = "Verse copied to clipboard!";
  static const String songLiked = " liked!";
  static const String songDisliked = " disliked!";

  static const String addASong = "Add a Song";
  static const String draftASong = "Draft a Song";
  static const String searchNow = "Search a song";
  static const String searchHint = "Search by title, number or words";
  static const String searchResult = "Search by title, number or words";
  static const String signupNow = "Not registered? Register now !";
  static const String signinNow = "Already registered? Login now !";
  static const String login = "Login";
  static const String reload = "RELOAD";
  static const String proceed = "PROCEED";
  static const String register = "Register";
  static const String password = "Password";
  static const String oldPassword = "Old Password";
  static const String newPassword = "Password";
  static const String changePassword = "Change Password";
  static const String logout = "Logout";
  static const String email = "Email Address";
  static const String mobile = "Mobile";
  static const String country = "Country";
  static const String code = "Code";
  static const String hasChorus = "Has Chorus";
  static const String noChorus = "No Chorus";
  static const String verses = " verse";
  static const String name = "Name";
  static const String defaultCCode = "254";
  static const String defaultCName = "Kenya";
  static const String defaultCI = "KE";

  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String yourGender = "You are a";
  static const String yourCity = "Your City";
  static const String yourChurch = "Your Church";

  static const String setUpTheApp = "Set up your ";
  static const String createCollection = "Create your Collection";
  static const String songTitle = "Song Title";
  static const String songContent = "Song Content";
  static const String songKey = "Song Key";
  static const String songNotes = "Song Notes";
  static const String learnMore = "Learn More";

  static const String manageSongbooks = "Manage Books";
  static const String supportUs = "Support us";
  static const String helpFeedback = "Help & Feedback";
  static const String aboutTheApp = "About ";
  static const String manageApp = "App Settings";
  static const String appSettings = " Settings";

  static const String donateActionButton = "OKAY GOT IT";
  static const String laterActionButton = "REMIND ME LATER";
  
  static String donateDialogTitle = "DONATE NOW";
  static const String donateDialogMessage = "vSongBook is a free app to give users like you freedom to sing anywhere anytime. We are non-profit " +
  "and we rely on people like you to help us keep it from commercials to millions of people around the world.";

  static const String retry = "RETRY";
  static const String songsInside = " songs inside;\n";
  static const String songsPrefix = " songs).\n";
  static const String displaySettings = "Display Preferences";
  static const String okayDone = "OKAY, DONE";
  static const String okayGotIt = "OKAY, GOT IT";
  static const String goBack = "GO BACK";
  static const String doneSelecting = "Done with selecting?";
  static const String areYouConnected = "Wait, are you connected?";
  static const String noSelection = "Oops! This is so heart breaking. You haven't selected a book, you expect things to be okay. You got to " +
          "select at least one book.\n\n By the way we can always bring you back here to select afresh. But for " +
          "now select at least one.";
  static const String noNewSelection = "Oops! You haven't selected anymore book to your original collection, maybe you just want to keep your original " +
          "collection.\n\n By the way we can always bring you back here to select afresh. Well lets hope that is okay with you for now.";
  static const String noConnection = "Oops! This is so heart breaking. You don't seem to have a working internet connection.\n\n" +
          "Kindly connect to a reliable internet either via Wi-Fi or Mobile Data then Retry again.";

  static const String appAbout = "<h3>What is vSongBook?</h3><p>... vSongBook (Virtual Songbook) is an application that gives users access to songs sung in church services among other places where praise and worship is carried out. Major songbooks include Songs of Worship, Nyimbo za Injili, Believers Songs, Redemption Songs and Tenzi za Rohoni. Other songbooks in various local dialects have been added over time and more are under way to be added.</p>" +
          "<hr><h3>What it is not ...</h3><p>... this is not a media player or tutor utility if you don't know how to sing a particular song. Be sure you know to sing most or all of the songs in it, otherwise feel free to customize the songs you want it have for you.</p>";
  static const String appHistory = "<p>vSongBook was first developed in September 2014 by Jack Siro while a student at KTTC. By then he was just trying his hands on Android and he just wanted make a little app to have the Songs of worship and Nyimbo za injili on his phone just like the Bible was an app on his phone.</p><p>Later while at home in December his father who came to his room to check on him and ask <i>some little computer questions</i> noticed an unfamiliar app on his phone. On learning and interacting with it though by then it had only 100 songs in English and Swahili books, he asked to have it on his phone. The happy father went to share it with his elder songs. It was at the End of Year Meetings at Mbale, Kenya that Brother Siro endosed the app there during one of his sermons.</p>" +
          "<p>With the help of Brother Gitau while a student at JKUAT Taita Taveta and other youth believers the rest of the songs were able to available in soft copy. The app which resided on his personal website got shared and many started asking to have more songs and features on it.</p><p>The need to have it hosted on Play Store was becoming unavoidable but since the app was not being monetized it was hard to do so till Brother Ngalonde of ZimApps in Zimbabwe came through to allow him to host the app on his Play Store account in the midst of 2015. Towards the midst of 2016 he was already monetizing the app he was able to purchase his own Google Play Store account where to date he still hosts the app from.</p>" +
          "<p>With the help the likes Pastor Waheire, Brother Simon Muthama and Brother Kijusa the Nyimbo cia Kuinira Ngai (Kikuyu), Mbathi sya Kumutaiaa Ngai (Kikamba) and Tsinyimboa Tsya Nyasaye (Luhya) were made available in softcopy. Bro Simutami of Malawi was very supportive in having the Bemba Hymnal just like Sister Alunga was with the Third Exodus songs.</p>" +
          "<p>It was in the year 2016 that the need to have the app available on Windows Phone was realized but it was not until the midst of 2017 that this was made possible on the Windows App Store. A year later the app became available in Windows PCs which didn't have a specific place to download it from until in 2019 when it beaceme available on the website www.appsmata.com launched by Jack Siro to cater for the projects that would fall under the umbrella of Appsmata Solutions the brand he was now promoting.</p>" +
          "<p>vSongBook for iOS the latest product for the app became a reality in the midst of 2020 after a whole 3 years of trying to save and getting the requirements that were needed. However as the iOS platform is very expensive to develop for this goal took time to come to reality thanks Brother Danvick who was generaous with his MacBook and iPhone that this became possible.</p>" +
          "<p>This is not the end of the story because this project is still in progress and many fatures are underway to make it the best singing app for anyone wishing to sing from the comfort of their phone. Keep supporting it with your prayers, finance and whatever you got to keep it alive! Be blessed!</p>";
  static const String appThanks = "<h3>Special Thanks be to the following people/Organizations:</h3>" +
          "<p>Pastor Siro, Sister Siro and the entire Kisii Church, " +
          "Brother George Gitau and  JKUAT Taita Taveta Youths, " +
          "Pastor Wakhanu, Pastor Mutonyi, Brother Timothy Mutonyi, " +
          "Brother Davis Wasonga, " +
          "Pastor Waheire & Banana Church, " +
          "Pastor Mwaura & Nakuru Church, " +
          "Brother Simon Muthama, " +
          "Brother Paul Kijusa and Sister Lydia Kijusa, " +
          "Sister Barnabas Alunga, " +
          "Brother Kevin Ngalonde (ZimApps, Zimbabwe), " +
          "Brother John Nyaga (Embu Univerity), " +
          "Brother Danvick Muller, " +
          "KTTC (No one in particular), " +
          "Android 254 (No one in particular), " +
          "</p>";

  static const String donateTabPage = "Support Us, Donate";

  static const String donateTab1Title = "M-Pesa";
  static const String donateTab1Content = "PAYBILL: 891300\n\nACCOUNT: 33112";

  static const String donateTab2Title = "Equitel";
  static const String donateTab2Content = "BUSINESS NUMBER:\n\t891300\n\nACCOUNT: 33112";

  static const String donateTab3Title = "Airtel";
  static const String donateTab3Content = "BUSINESS NAME:\n\tMCHANGA\n\nACCOUNT: 33112";

  static const String donateTab4Title = "PayPal";
  static const String donateTab4Content = "EMAIL:\n\tappsmatake [at] gmail.com";

  static const String helpTabPage = "Help and Feedback";

  static const String helpTab1Title = "Contact us";
  static const String helpTab1Content = "<p>PHONE: +2547 - </p><hr><p>EMAIL: <a href=\"mailto:appsmatake@gmail.com\">appsmatake@gmail.com</a> </p><hr> <p>WEBSITE: " +
      "<a href=\"https://appsmata.com/vSongBook\">appsmata.com/vSongBook</a></p>";

  static const String helpTab2Title = "App Reviews";
  static const String helpTab2Content = "Whether you are happy with our app or not please let us know by leaving a rating as well as review on the " +
      "<a href=\"https://play.google.com/store/apps/details?id=com.jackson_siro.visongbook\">Google Play Store</a> or " +
      "<a href=\"https://apps.apple.com/app/vsongbook/id1327276691\">Apple Store</a>.";

  static const String helpTab3Title = "Open Source";
  static const String helpTab3Content = "If you are a software developer, the source code for this app is freely available on the GitHub:</br></br> " +
      "<a href=\"https://github.com/Appsmata/vSongBook-Mobile\">https://github.com/Appsmata/vSongBook-Mobile</a>";
}

class Tables {
  static const String books = 'as_books';
  static const String songs = 'as_songs';
  static const String sermons = 'as_sermons';
  static const String tithing = 'as_tithing';
}

class Columns {
  static const int ownsongs = 50;
  static const String bookid = 'bookid';
  static const String categoryid = 'categoryid';
  static const String enabled = 'enabled';
  static const String title = 'title';
  static const String tags = 'tags';
  static const String qcount = 'qcount';
  static const String position = 'position';
  static const String content = 'content';
  static const String backpath = 'backpath';
  static const String created = 'created';
  static const String updated = 'updated';

  static const String songid = 'songid';
  static const String postid = 'postid';
  static const String number = 'number';
  static const String basetype = 'basetype';
  static const String alias = 'alias';
  static const String views = 'views';
  static const String key = 'key';
  static const String isfav = 'isfav';
  static const String author = 'author';
  static const String notes = 'notes';
  static const String metawhat = 'metawhat';
  static const String metawhen = 'metawhen';
  static const String metawhere = 'metawhere';
  static const String metawho = 'metawho';
  static const String netthumbs = 'netthumbs';
  static const String acount = 'acount';
  static const String userid = 'userid';

  static const String sermonid = 'sermonid';
  static const String subtitle = 'subtitle';
  static const String preacher = 'preacher';
  static const String place = 'place';
  static const String extra = 'extra';
  static const String state = 'state';

  static const String titheid = 'titheid';
  static const String source = 'source';
  static const String mode = 'mode';
  static const String amount = 'amount';
}

class Queries {
  static const String createBooksTable = 'CREATE TABLE ' +
      Tables.books + '(' +
      Columns.bookid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.categoryid + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.enabled + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.title + ' VARCHAR(100) UNIQUE, ' +
      Columns.tags + ' VARCHAR(250) UNIQUE, ' +
      Columns.qcount + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.position + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.content + ' VARCHAR(1000), ' +
      Columns.backpath + ' VARCHAR(250) UNIQUE, ' +
      Columns.created + ' VARCHAR(20), ' +
      Columns.updated + ' VARCHAR(20)' +
      ");";
  static const String createSongsTable = 'CREATE TABLE ' +
      Tables.songs + '(' +
      Columns.songid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.postid + ' INTEGER UNIQUE, ' +
      Columns.bookid + ' INTEGER, ' +
      Columns.categoryid + ' INTEGER, ' +
      Columns.basetype + ' VARCHAR(20), ' +
      Columns.number + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.alias + ' VARCHAR(250), ' +
      Columns.title + ' VARCHAR(100), ' +
      Columns.tags + ' VARCHAR(100), ' +
      Columns.content + ' VARCHAR(50000), ' +
      Columns.key + ' VARCHAR(10), ' +
      Columns.author + ' VARCHAR(100), ' +
      Columns.notes + ' VARCHAR(250), ' +
      Columns.created + ' VARCHAR(20), ' +
      Columns.updated + ' VARCHAR(20), ' +
      Columns.metawhat + ' VARCHAR(20), ' +
      Columns.metawhen + ' VARCHAR(20), ' +
      Columns.metawhere + ' VARCHAR(20), ' +
      Columns.metawho + ' VARCHAR(20), ' +
      Columns.netthumbs + ' INTEGER, ' +
      Columns.views + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.isfav + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.acount + ' INTEGER, ' +
      Columns.userid + ' INTEGER' +
      ");";

  static const String createSermonsTable = 'CREATE TABLE ' +
      Tables.sermons + '(' +
      Columns.sermonid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.categoryid + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.title + ' VARCHAR(100), ' +
      Columns.subtitle + ' VARCHAR(100), ' +
      Columns.preacher + ' VARCHAR(100), ' +
      Columns.place + ' VARCHAR(100), ' +
      Columns.extra + ' VARCHAR(200), ' +
      Columns.tags + ' VARCHAR(100), ' +
      Columns.content + ' VARCHAR(50000), ' +
      Columns.created + ' VARCHAR(20), ' +
      Columns.updated + ' VARCHAR(20), ' +
      Columns.state + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.isfav + ' INTEGER NOT NULL DEFAULT 0' +
      ");";

  static const String createTithingTable = 'CREATE TABLE ' +
      Tables.tithing + '(' +
      Columns.titheid + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Columns.source + ' VARCHAR(50), ' +
      Columns.mode + ' VARCHAR(20), ' +
      Columns.amount + ' INTEGER NOT NULL DEFAULT 0, ' +
      Columns.extra + ' VARCHAR(100), ' +
      Columns.created + ' INTEGER NOT NULL DEFAULT 0' +
      ");";

  static String searchQuery(String searchStr) {
    return ' WHERE ' + Tables.songs + '.' + Columns.title + " LIKE '%$searchStr%' $bookQuery OR " + 
      Tables.songs + '.' + Columns.alias + " LIKE '%$searchStr%' $bookQuery OR " + 
      Tables.songs + '.' + Columns.content + " LIKE '%$searchStr%' $bookQuery" + songsOrderby;
  }
  
  static const String selectSongsColumns = 
      'SELECT ' + 
        Columns.songid + ', ' +  Columns.postid + ', ' + Tables.songs + '.' + Columns.bookid + ', ' + 
        Tables.songs + '.' + Columns.categoryid +  ', ' + Columns.number + ', ' + Columns.alias + ', ' + 
        Tables.songs + '.' + Columns.title + ', ' + Tables.songs + '.' + Columns.content + ', ' + 
        Columns.key + ', ' + Tables.songs + '.' + Columns.created + ', ' + 
        Tables.songs + '.' + Columns.isfav + ', ' +  Tables.books + "." + Columns.title + ' AS songbook' +
      ' FROM ' + Tables.songs + 
      ' LEFT JOIN ' + Tables.books + ' ON ' + Tables.books + '.' + Columns.categoryid + '=' + Tables.songs + '.' + Columns.bookid;

  static const String songsOrderby = ' ORDER BY ' +  Columns.songid + ' ASC';

  static String whereSongsBookid(String book)
  {
    return ' WHERE ' + Tables.songs + '.' + Columns.bookid + '=' + book + songsOrderby;
  }

  static String whereSongsNumber(int songno)
  {
    return ' WHERE ' + Tables.songs + '.' + Columns.bookid + '=' + songno.toString() + songsOrderby;
  }

  static String bookQuery = 'AND ' + Tables.songs + '.' + Columns.bookid + '!=' + Columns.ownsongs.toString();
  
  static String whereSongMatch(String searchStr)
  {
    return ' WHERE ' + Tables.songs + '.' + Columns.title + " LIKE '%$searchStr%' $bookQuery OR " + 
     Tables.songs + '.' +  Columns.alias + " LIKE '%$searchStr%' $bookQuery OR " + 
      Tables.songs + '.' + Columns.content + " LIKE '%$searchStr%' $bookQuery" + songsOrderby;
  }

}
