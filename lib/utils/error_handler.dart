// Error handling utilities for database operations
//
// This file provides utilities for safely handling errors from database
// operations and displaying appropriate feedback to users.
import 'package:material_ui/material_ui.dart';

import '../util/tailwind_colors.dart';

/// Result wrapper for database operations
///
/// This class represents the result of a database operation that may succeed or fail.
/// It provides type-safe handling of both success and error cases.
sealed class DbResult<T> {
  const DbResult();

  /// Execute different code based on success or failure
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) error,
  }) =>
      switch (this) {
        Success(data: final data) => success(data),
        Failure(message: final message) => error(message),
      };
}

/// Successful database operation result
class const Success<T>(final T data) extends DbResult<T>;

/// Failed database operation result
class const Failure<T>(
  final String message, {
  final Exception? exception,
}) extends DbResult<T>;

/// Helper function to safely execute database operations
Future<DbResult<T>> safeDbOperation<T>(
  Future<T> Function() operation, {
  String? errorMessage,
}) async {
  try {
    final result = await operation();
    return Success(result);
  } on Exception catch (e) {
    return Failure(
      errorMessage ?? 'An error occurred: $e',
      exception: e,
    );
  } catch (_) {
    return Failure(
      errorMessage ?? 'An unexpected error occurred',
    );
  }
}

/// Show error snackbar to user
void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: TailwindColor.red.palette.s600,
      duration: const Duration(seconds: 4),
    ),
  );
}
