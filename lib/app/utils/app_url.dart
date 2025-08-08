class AppUrl {
  // static String baseUrl = 'https://aletheia.ai.ml-bench.com';

  static String baseUrl =
      'https://sage-backend-760q.onrender.com'; //this new url didn't work

  // static String baseUrl = "https://xrrpjm5s-8081.inc1.devtunnels.ms";

  static String login = '$baseUrl/api/auth/login';
  static String getMeUser = '$baseUrl/api/auth/me';
  static String getPartner = '$baseUrl/api/user/partner';
  static String signup = '$baseUrl/api/auth/signup';
  static String sendOtp = '$baseUrl/api/auth/send-otp';
  static String verifyOtp = '$baseUrl/api/auth/verify-email-otp';
  static String verifyResetOtp = '$baseUrl/api/auth/verify-reset-otp';
  static String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static String resetPassword = '$baseUrl/api/auth/reset-password';
  static String profileUpdate = '$baseUrl/api/user/profile-update';
  static String updatePassword = '$baseUrl/api/user/update-password';
  static String uploadImage = '$baseUrl/api/upload/image';
  static String deleteAccount = '$baseUrl/api/user/delete-account';
  static String removePartner = '$baseUrl/api/user/remove-partner';
  static String getPoints = '$baseUrl/api/raffle/points';
  static String getReferrals = '$baseUrl/api/raffle/referrals';
  static String contactUs = '$baseUrl/api/user/contact';
  //ideas
  static String getIdeasFeed = '$baseUrl/api/ideas/feed';
  static String ideas =
      '$baseUrl/api/ideas'; //Fir: Save Idea, Unsave Idea, Dislike Idea, Add Idea, Get Added Ideas, Delete Added Idea
  static String getSavedIdeas = '$baseUrl/api/ideas/saved-ideas';

  //subscription
  static String createPaymentIntent =
      '$baseUrl/api/subscription/create-payment-intent';
  static String createSubscription =
      '$baseUrl/api/subscription/create-subscription';
  static String getSubscriptionDetails =
      '$baseUrl/api/subscription/subscription';
  static String cancelSubcription =
      '$baseUrl/api/subscription/Cancel-subscription';

  //home
  static String relationshipSuggestion = '$baseUrl/api/user/daily-tip';

  //notifications
  static String notifications = '$baseUrl/api/notifications';
}
