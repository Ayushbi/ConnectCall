
 String NormalizePhone(String phone) {
phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

if (phone.startsWith("91") && phone.length == 12) {
  phone = phone.substring(2);
}
return phone;
}