int _charsum(String str) {
  var sum = 0;
  for (var i = 0; i < str.length; i++) {
    sum += str.codeUnitAt(i) * (i + 1);
  }
  return sum;
}

String hashArrayOfStrings(List<String> arrayOfStrings) {
  var sum = 0.0;
  var product = 1;
  for (var i = 0; i < arrayOfStrings.length; i++) {
    final cs = _charsum(arrayOfStrings[i]);
    if (product % cs > 0) {
      product *= cs;
      sum += 65027 / cs;
    }
  }

  return (sum.toString()).substring(0, 16).replaceAll('.', '');
}
