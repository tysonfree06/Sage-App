extension EmailValidatorExtension on String {
  bool emailValidator() {
    final emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(this);
    return emailValid;
  }
}

extension PasswordValidatorExtension on String {
  bool isValidPassword() {
    // At least 8 characters, one uppercase, one lowercase, one number
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(this);
  }
}

extension NameValidatorExtension on String {
  bool isValidName() {
    return RegExp(r'^[A-Za-z\s]{2,}$').hasMatch(this);
  }
}

extension PhoneValidatorExtension on String {
  bool isValidPhoneNumber() {
    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(this);
  }
}

extension EmptyFieldValidatorExtension on String {
  bool isNotEmptyField() {
    return trim().isNotEmpty;
  }
}

extension InvitationCodeValidatorExtension on String {
  bool isValidInvitationCode() {
    // Assuming alphanumeric with optional dashes/underscores, length 4-10
    return RegExp(r'^[A-Za-z0-9_-]{4,10}$').hasMatch(this);
  }
}

