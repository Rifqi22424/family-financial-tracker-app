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
}
