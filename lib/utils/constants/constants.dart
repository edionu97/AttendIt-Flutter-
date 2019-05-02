class Constants{

  // ignore: non_constant_identifier_names
  static double PROFILE_PICTURE_WIDTH = 150;

  // ignore: non_constant_identifier_names
  static double PROFILE_PICTURE_HEIGHT = 150;

  // ignore: non_constant_identifier_names
  static String SERVER_ADDRESS="http://192.168.43.155:8080";

  // ignore: non_constant_identifier_names
  static String WEB_SOCKET = SERVER_ADDRESS.replaceAll("http", "ws") + "/topic";

  // ignore: non_constant_identifier_names
  static String LOGIN_API="/auth/login";

  // ignore: non_constant_identifier_names
  static String REGISTER_API="/auth/register";

  // ignore: non_constant_identifier_names
  static String CHANGE_PASSWORD = "/auth/change-password";

  // ignore: non_constant_identifier_names
  static String GET_PROFILE_API="/profile/info";

  // ignore: non_constant_identifier_names
  static String CREATE_UPDATE_PROFILE_API = "/profile/create-update";

  // ignore: non_constant_identifier_names
  static String UPLOAD_PICTURE_API = "/profile/upload-picture";

  // ignore: non_constant_identifier_names
  static String UPLOAD_LEFT_RIGHT_API ="/stream/update-left-right";

  // ignore: non_constant_identifier_names
  static String CHECK_FACE = "/attendance/check";

  // ignore: non_constant_identifier_names
  static String GET_ALL_AVAILABLE_COURSES = "/attendance/courses";

  // ignore: non_constant_identifier_names
  static String TILT_HEAD_LEFT_RIGHT ="You should move your head from left to right and back slowly";

  // ignore: non_constant_identifier_names
  static String TILT_HEAD_UP_DOWN= "You should move your head from up to down and back slowly";

  // ignore: non_constant_identifier_names
  static String TMP_LEFT_RIGHT = "/tmp.mp4";

  // ignore: non_constant_identifier_names
  static String TMP_UP_DOWN =  "/up.mp4";
}