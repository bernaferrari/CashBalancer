// Error handling utilities for database operations
//
// This file provides utilities for safely handling errors from database
// operations and displaying appropriate feedback to users.
import 'package:flutter/material.dart';

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
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(message: final message) => error(message),
    };
  }

  /// Check if the operation was successful
  bool get isSuccess => this is Success;

  /// Check if the operation failed
  bool get isFailure => this is Failure;

  /// Get the data if successful, null otherwise
  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  /// Get the error message if failed, null otherwise
  String? get errorOrNull => switch (this) {
    Success() => null,
    Failure(message: final message) => message,
  };
}

/// Successful database operation result
class Success<T> extends DbResult<T> {
  final T data;

  const Success(this.data);
}

/// Failed database operation result
class Failure<T> extends DbResult<T> {
  final String message;
  final Exception? exception;

  const Failure(this.message, {this.exception});
}

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
      errorMessage ?? 'An error occurred: ${e.toString()}',
      exception: e,
    );
  } catch (e) {
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
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
    ),
  );
}

/// Show success snackbar to user
void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}
