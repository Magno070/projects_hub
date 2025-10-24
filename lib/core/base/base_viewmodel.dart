import 'package:flutter/foundation.dart';

/// Classe base para todos os ViewModels
/// Fornece funcionalidades comuns como loading, error handling e dispose
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  /// Indica se o ViewModel está carregando
  bool get isLoading => _isLoading;

  /// Mensagem de erro atual
  String? get errorMessage => _errorMessage;

  /// Indica se o ViewModel foi descartado
  bool get isDisposed => _disposed;

  /// Define o estado de loading
  void setLoading(bool loading) {
    if (_isLoading != loading && !_disposed) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Define a mensagem de erro
  void setError(String? error) {
    if (_errorMessage != error && !_disposed) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  /// Limpa o erro atual
  void clearError() {
    setError(null);
  }

  /// Executa uma operação assíncrona com tratamento de erro e loading
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    bool clearErrorOnStart = true,
  }) async {
    if (clearErrorOnStart) clearError();

    setLoading(true);

    try {
      final result = await operation();
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Método para ser sobrescrito nas classes filhas para cleanup específico
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
