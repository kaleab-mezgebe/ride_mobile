class Validators {
  static bool isValidPhone(String phone) {
    return phone.isNotEmpty && phone.length >= 7;
  }

  static bool isValidOtp(String otp) {
    return otp.length == 6;
  }
}
