
String? validatePostcode(String? value) {
  if (value == null || value.isEmpty) return 'Required';
  // Regex: Exactly 5 digits
  final regex = RegExp(r'^\d{5}$'); 
  if (!regex.hasMatch(value)) return 'Enter valid 5-digit postcode';
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) return 'Required';
  // Regex: Starts with 01, followed by 8-9 digits (Example for MY)
  final regex = RegExp(r'^01\d{8,9}$');
  if (!regex.hasMatch(value)) return 'Enter valid mobile number';
  return null;
}