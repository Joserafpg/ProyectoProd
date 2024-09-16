import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'materiales_solicitar_widget.dart' show MaterialesSolicitarWidget;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialesSolicitarModel
    extends FlutterFlowModel<MaterialesSolicitarWidget> {
  ///  Local state fields for this page.

  bool prioridadBaja = false;
  bool prioridadNormal = false;
  bool prioridadAlta = false;
  bool prioridadCritica = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController1 = FlutterFlowDataTableController<int>();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for PaginatedDataTable widget.
  late FlutterFlowDataTableController<Map<String, dynamic>>
      paginatedDataTableController2;

  String? selectedMaterial;
  int cantidad = 0;
  List<Map<String, dynamic>> materialesSolicitados = [];
  List<String> materiales = [];
  List<String> materialesInventario = [];

  Future<void> cargarMaterialesInventario() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('inventario').get();
      materialesInventario =
          querySnapshot.docs.map((doc) => doc['nombre'] as String).toList();
    } catch (e) {
      print('Error al cargar materiales del inventario: $e');
    }
  }

  TextEditingController? textController1;

  @override
  void initState(BuildContext context) {
    paginatedDataTableController2 =
        FlutterFlowDataTableController<Map<String, dynamic>>();
    textController1 = TextEditingController();
  }

  @override
  void dispose() {
    paginatedDataTableController1.dispose();
    paginatedDataTableController2.dispose();
    textController1?.dispose();
  }
}
