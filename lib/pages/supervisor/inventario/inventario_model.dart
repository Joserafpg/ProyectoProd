import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'inventario_widget.dart' show InventarioWidget;
import 'package:flutter/material.dart';

class InventarioModel extends FlutterFlowModel<InventarioWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  late FlutterFlowDataTableController<Map<String, dynamic>>
      paginatedDataTableController;

  @override
  void initState(BuildContext context) {
    paginatedDataTableController =
        FlutterFlowDataTableController<Map<String, dynamic>>(
            // Configura el controlador según tus necesidades
            );
  }

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
