import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'materiales_widget.dart' show MaterialesWidget;
import 'package:flutter/material.dart';

class MaterialesModel extends FlutterFlowModel<MaterialesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  late FlutterFlowDataTableController<Map<String, dynamic>>
      paginatedDataTableController;

  @override
  void initState(BuildContext context) {
    paginatedDataTableController =
        FlutterFlowDataTableController<Map<String, dynamic>>(
            // ... configuración existente ...
            );
  }

  @override
  void dispose() {
    paginatedDataTableController.dispose();
  }
}
