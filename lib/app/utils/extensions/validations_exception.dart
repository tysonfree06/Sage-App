extension EmailValidatorExtension on String {
  bool emailValidator() {
    final emailValid = RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(this);
    return emailValid;
  }
}

extension UrlValidatorExtension on String {
  bool urlValidator() {
    final urlValid = RegExp(
      r'^(http://www\.|https://www\.|http://|https://)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
    return urlValid;
  }
}

// extension PasswordValidatorExtension on String {
//   bool passwordValidator() {
//     final passwordValid = RegExp(
//       r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
//     ).hasMatch(this);
//     // Minimum 8 characters, 1 uppercase, 1 number, 1 special character
//     return passwordValid;
//   }

//   // bool lessSecurePasswordValidator() {
//   //   return length >= 8; // Checks if the password length is >= 8
//   // }
// }

extension PasswordValidatorExtension on String {
  bool passwordValidator() {
    final passwordValid = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    ).hasMatch(this);
    // Explanation:
    // (?=.*[a-z])        → At least one lowercase
    // (?=.*[A-Z])        → At least one uppercase
    // (?=.*\d)           → At least one digit
    // (?=.*[^A-Za-z0-9]) → At least one special character (anything that's not a letter/number)
    // .{8,}              → At least 8 characters total
    return passwordValid;
  }
}

extension NameValidatorExtension on String {
  bool nameValidator() {
    final nameValid = RegExp(
      r'^[a-zA-Z\s]+$', // Only letters and spaces
    ).hasMatch(this);
    return nameValid;
  }
}

extension ExperienceValidatorExtension on String {
  bool experienceValidator() {
    final experienceValid = RegExp(
      r'^[0-9]+$', // Only digits
    ).hasMatch(this);
    return experienceValid;
  }
}

extension UsernameValidatorExtension on String {
  bool usernameValidator() {
    final usernameValid = RegExp(
      r'^[a-zA-Z0-9_-]{3,15}$',
      // Alphanumeric, with underscores or hyphens, between 3 to 15 characters
    ).hasMatch(this);
    return usernameValid;
  }
}

extension AddressValidatorExtension on String {
  bool addressValidator() {
    final addressValid = RegExp(
      r'^[a-zA-Z0-9\s,.-]+$', // Letters, numbers, spaces, commas, periods, and hyphens
    ).hasMatch(this);
    return addressValid;
  }
}

extension CostValidatorExtension on String {
  bool costValidator() {
    final costValid = RegExp(
      r'^[0-9]+$', //Only numbers
    ).hasMatch(this);
    return costValid;
  }
}

extension LinkValidatorExtension on String {
  bool linkValidator() {
    const urlPattern = r'^(https?:\/\/)?' // protocol (optional)
        r'(([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})' // domain
        r'(\/[^\s]*)?$'; // path (optional)

    final linkValid = RegExp(urlPattern).hasMatch(this);
    return linkValid;
  }
}
