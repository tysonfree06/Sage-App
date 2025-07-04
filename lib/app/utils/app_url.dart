class AppUrl {
  static String baseUrl = 'http://sprint.ml-bench.com';
  
  static String login = '$baseUrl/api/auth/login';
  static String signup = '$baseUrl/api/auth/signup';
  static String sendOtp = '$baseUrl/api/auth/send-otp';
  static String verifyOtp = '$baseUrl/api/auth/verify-otp';
  static String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static String resetPassword = '$baseUrl/api/auth/reset-password';
  static String profileUpdate = '$baseUrl/api/user/profile-update';
  static String updatePassword = '$baseUrl/api/user/update-password';
  static String uploadImage = '$baseUrl/api/upload/image';  
}
