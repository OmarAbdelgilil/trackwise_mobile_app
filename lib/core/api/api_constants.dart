class ApiConstants {
  //static const String baseUrl = 'http://192.168.1.56:3000/api';
  // static const String baseUrl = 'http://192.168.1.81:5000/api';
  static const String baseUrl =
      'https://trackwise-backend-3m8o.onrender.com/api';
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String addUsage = '/addUsage';
  static const String addSteps = '/addSteps';
  static const String searchByEmail = '/findUserByEmail';
  static const String scores = "/scoresWithDate";
  static const String sendFriendRequest = '/sendRequest';
  static const String getFriendRequests = "/getAllRequests";
  static const String acceptFreindRequest = '/acceptRequest';
  static const String rejectRequest = '/rejectRequest';
  static const String getRecommendation = "/rec/appRec";
  static const String unFriend = "/unfriend";
  static const String userTags = "/getUserTag";
  static const String verifyEmail = '/send-otp';
  static const String verifyOtp = '/verify-otp';
  static const String resetPass = "/reset-password";
}
