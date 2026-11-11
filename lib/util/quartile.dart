// original source: https://stackoverflow.com/a/55297611 (JavaScript)

double quantile(List<double> arr, double q) {
  if (arr.isEmpty) return 0;
  final sorted = [...arr]..sort();
  final double pos = (sorted.length - 1) * q;
  final base = pos.floor();
  final rest = pos - base;
  if (sorted.length > base + 1) {
    return sorted[base] + rest * (sorted[base + 1] - sorted[base]);
  } else {
    return sorted[base];
  }
}

double q33(List<double> arr) => quantile(arr, .33);

double q66(List<double> arr) => quantile(arr, .66);
