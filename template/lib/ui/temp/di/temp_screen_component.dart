import 'package:flutter/material.dart';
import 'package:flutter_template/ui/app/di/app.dart';
import 'package:flutter_template/ui/base/default_dialog_controller.dart';
import 'package:flutter_template/ui/base/error/standard_error_handler.dart';
import 'package:flutter_template/ui/base/material_message_controller.dart';
import 'package:flutter_template/ui/temp/temp_wm.dart';
import 'package:mwwm/mwwm.dart';

/// Шаблон для [Component] экрана
class TempScreenComponent implements BaseWidgetModelComponent<TempWidgetModel> {
  @override
  TempWidgetModel wm;

  TempScreenComponent(
    AppComponent parentComponent,
    Key scaffoldKey,
    NavigatorState navigator,
  ) {
    final wmDependencies = WidgetModelDependencies(
      errorHandler: StandardErrorHandler(
        MaterialMessageController(scaffoldKey),
        DefaultDialogController(scaffoldKey),
      ),
      navigator: navigator,
    );

    wm = TempWidgetModel(
      wmDependencies,
      navigator,
    );
  }
}
