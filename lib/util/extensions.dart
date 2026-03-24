extension StringExtension on String? {
  String orEmpty() => this ?? "";
}

extension IntExtension on int? {
  int orZero() => this ?? 0;
}

extension DoubleExtension on double? {
  double orZero() => this ?? 0.0;
}