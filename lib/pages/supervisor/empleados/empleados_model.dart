import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'empleados_widget.dart' show EmpleadosWidget;
import 'package:flutter/material.dart';

class EmpleadosModel extends FlutterFlowModel<EmpleadosWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  late FlutterFlowDataTableController<Map<String, dynamic>>
      paginatedDataTableController;

  @override
  void initState(BuildContext context) {
    paginatedDataTableController =
        FlutterFlowDataTableController<Map<String, dynamic>>(
            // ... configuración del controlador ...
            );
  }

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
