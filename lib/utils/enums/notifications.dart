enum NotificationType {
  //emitted when new user is created
  NEW_REGISTRATION,
  //emitted when admins confirms an account
  ACCOUNT_CONFIRMED,
  ACCOUNT_CONFIRMED_REFRESH,
  //emitted when teacher adds new course
  COURSE_ADDED,
  COURSE_ADDED_REFRESH
}

NotificationType getNotificationTypeFromString(final String status) {
  for (final NotificationType element in NotificationType.values) {
    if (element.toString() == status) {
      return element;
    }
  }
  return null;
}
