class Constants{

  // ignore: non_constant_identifier_names
  static double PROFILE_PICTURE_WIDTH = 150;

  // ignore: non_constant_identifier_names
  static double PROFILE_PICTURE_HEIGHT = 150;

  // ignore: non_constant_identifier_names
  static String SERVER_ADDRESS="http://172.16.10.104:8080";

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
  static String CHECK_STUDENT_ENROLLMENT = "/enrollment/check-enrollment";

  // ignore: non_constant_identifier_names
  static String ADD_STUDENT_ENROLLMENT = "/enrollment/add";

  // ignore: non_constant_identifier_names
  static String REMOVE_STUDENT_ENROLLMENT = "/enrollment/delete";

  // ignore: non_constant_identifier_names
  static String GET_ENROLLMENTS_FOR ="/enrollment/for";

  // ignore: non_constant_identifier_names
  static String GET_ENROLLMENT_TYPE_AT ="/enrollment/at-types";

  // ignore: non_constant_identifier_names
  static String GET_ATTENDANCES_FOR_AT ="/attendance/for-at";

  // ignore: non_constant_identifier_names
  static String GET_USER_INFO = "/auth/info";

  // ignore: non_constant_identifier_names
  static String GET_ALL_USERS ="/auth/users";

  // ignore: non_constant_identifier_names
  static String SET_ROLE = "/auth/user/set-role";

  // ignore: non_constant_identifier_names
  static String GET_MY_COURSES = "/courses/posted-by";

  // ignore: non_constant_identifier_names
  static String FIND_BY = "/courses/find-by";

  // ignore: non_constant_identifier_names
  static String ADD_COURSE = "/courses/add";

  // ignore: non_constant_identifier_names
  static String GET_COURSE_ENROLLMENTS = "/enrollment/at";

  // ignore: non_constant_identifier_names
  static String GET_GROUPS_ENROLLED = "/enrollment/get-grups";

  // ignore: non_constant_identifier_names
  static String GET_ENROLLED_AT_COURSE_GROUP = "/enrollment/no-course-grup";

  // ignore: non_constant_identifier_names
  static String UPLOAD_ATTENDANCE_VIDEO = "/stream/attendance-video";

  // ignore: non_constant_identifier_names
  static String ATTENDANCE_HISTORY = "/history/for";

  // ignore: non_constant_identifier_names
  static String ATTENDANCE_HISTORY_AT = "/history/presents-at";

  // ignore: non_constant_identifier_names
  static String ATTENDANCE_HISTORY_ABSENTS = "/history/absents-at";

  // ignore: non_constant_identifier_names
  static String ATTENDANCE_MODIFY = "/attendance/modify";

  // ignore: non_constant_identifier_names
  static String TILT_HEAD_LEFT_RIGHT ="You should move your head from left to right and back slowly";

  // ignore: non_constant_identifier_names
  static String TILT_HEAD_UP_DOWN= "You should move your head from up to down and back slowly";

  // ignore: non_constant_identifier_names
  static String TMP_LEFT_RIGHT = "/tmp.mp4";

  // ignore: non_constant_identifier_names
  static String TMP_UP_DOWN =  "/up.mp4";

  // ignore: non_constant_identifier_names
  static String TMP_ATTENDANCE = "/attendance.mp4";

  // ignore: non_constant_identifier_names
  static String ADMIN = "admin";
}