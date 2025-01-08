mixin InputValidatorMixin {
  String? validateText(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName tidak boleh kosong";
    }
    return null;
  }

  String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName tidak boleh kosong";
    }
    if (double.tryParse(value) == null) {
      return "$fieldName harus berupa angka";
    }
    return null;
  }

  String? validateConfirmPassword({
    required String? confirmPassword,
    required String newPassword,
    String fieldName = "Konfirmasi Password",
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "$fieldName tidak boleh kosong";
    }
    if (confirmPassword != newPassword) {
      return "$fieldName tidak sesuai dengan password baru";
    }
    return null;
  }
}
