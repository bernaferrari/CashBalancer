// original source: https://stackoverflow.com/a/55297611 (JavaScript)

import 'dart:math' as math;

// sort array ascending
List<double> asc(List<double> arr) {
  return [...arr]..sort((a, b) => a.compareTo(b));
}

double sum(List<num> arr) {
  return arr.fold(0, (a, b) => a + b);
}

double mean(List<num> arr) {
  return sum(arr) / arr.length;
}

// sample standard deviation
double std(List<num> arr) {
  final mu = mean(arr);
  final diffArr = arr.map((a) => math.pow(a - mu, 2)).toList();
  return math.sqrt(sum(diffArr) / (arr.length - 1));
}

double quantile(List<double> arr, double q) {
  final sorted = asc(arr);
  final double pos = (sorted.length - 1) * q;
  final base = pos.floor();
  final rest = pos - base;
  if (sorted[base + 1] != null) {
    return sorted[base] + rest * (sorted[base + 1] - sorted[base]);
  } else {
    return sorted[base];
  }
}

double q25(List<double> arr) => quantile(arr, .25);

double q50(List<double> arr) => quantile(arr, .50);

double q75(List<double> arr) => quantile(arr, .75);

double median(List<double> arr) => quantile(arr, .50);
