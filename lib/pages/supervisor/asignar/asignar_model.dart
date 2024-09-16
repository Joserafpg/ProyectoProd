import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'asignar_widget.dart' show AsignarWidget;
import 'package:flutter/material.dart';
import 'operador.dart';

class AsignarModel extends FlutterFlowModel<AsignarWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  DateTime? datePicked;
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for PaginatedDataTable widget.
  late FlutterFlowDataTableController<Map<String, dynamic>>
      paginatedDataTableController;

  // Si no necesitas esta lista, también puedes eliminarla
  // List<Operador> operadores = [];

  List<Operador?> operadores = [];

  @override
  void initState(BuildContext context) {
    paginatedDataTableController =
        FlutterFlowDataTableController<Map<String, dynamic>>();
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();

    paginatedDataTableController.dispose();
  }
}
