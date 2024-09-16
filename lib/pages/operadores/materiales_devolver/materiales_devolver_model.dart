import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'materiales_devolver_widget.dart' show MaterialesDevolverWidget;
import 'package:flutter/material.dart';

class MaterialesDevolverModel
    extends FlutterFlowModel<MaterialesDevolverWidget> {
  ///  Local state fields for this page.

  bool baja = false;

  bool normal = false;

  bool alta = false;

  bool crititca = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController = FlutterFlowDataTableController<int>();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
