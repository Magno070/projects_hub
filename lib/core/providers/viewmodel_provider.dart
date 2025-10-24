import 'package:flutter/material.dart';

/// Provider personalizado para ViewModels que integra com o sistema de DI
/// Facilita o uso de ViewModels em widgets Flutter
class ViewModelProvider<T extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final T Function()? create;
  final T? value;

  const ViewModelProvider({
    super.key,
    required this.child,
    this.create,
    this.value,
  }) : assert(
         create != null || value != null,
         'Either create or value must be provided',
       );

  @override
  State<ViewModelProvider<T>> createState() => _ViewModelProviderState<T>();

  /// Método estático para obter o ViewModel do contexto
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_InheritedViewModelProvider<T>>();
    if (provider == null) {
      throw FlutterError(
        'ViewModelProvider.of<$T> called with a context that does not contain a ViewModelProvider<$T>',
      );
    }
    return provider.viewModel;
  }

  /// Método estático para obter o ViewModel do contexto (pode retornar null)
  static T? ofNullable<T extends ChangeNotifier>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_InheritedViewModelProvider<T>>();
    return provider?.viewModel;
  }
}

class _ViewModelProviderState<T extends ChangeNotifier>
    extends State<ViewModelProvider<T>> {
  late T _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.value ?? widget.create!();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedViewModelProvider<T>(
      viewModel: _viewModel,
      child: widget.child,
    );
  }
}

class _InheritedViewModelProvider<T extends ChangeNotifier>
    extends InheritedWidget {
  final T viewModel;

  const _InheritedViewModelProvider({
    required this.viewModel,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedViewModelProvider<T> oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}

/// Widget que facilita o uso de ViewModels com Consumer
class ViewModelConsumer<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;
  final Widget? child;

  const ViewModelConsumer({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, viewModel, child) =>
          builder(context, viewModel, child),
      child: this.child,
    );
  }
}

/// Consumer que funciona com ViewModelProvider
class Consumer<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;
  final Widget? child;

  const Consumer({super.key, required this.builder, this.child});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModelProvider.of<T>(context);
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) => builder(context, viewModel, child),
      child: this.child,
    );
  }
}
