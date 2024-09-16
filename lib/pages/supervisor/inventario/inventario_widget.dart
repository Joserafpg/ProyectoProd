import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'inventario_model.dart';
export 'inventario_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InventarioWidget extends StatefulWidget {
  const InventarioWidget({super.key});

  @override
  State<InventarioWidget> createState() => _InventarioWidgetState();
}

class _InventarioWidgetState extends State<InventarioWidget> {
  late InventarioModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> inventarioData = [];

  // Controladores para los campos de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadAgregarController =
      TextEditingController();
  final TextEditingController _cantidadMinimaController =
      TextEditingController();
  final TextEditingController _unidadController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();

  // Variable para almacenar el material seleccionado
  Map<String, dynamic>? _materialSeleccionado;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InventarioModel());
    _obtenerDatosInventario();
  }

  Future<void> _obtenerDatosInventario() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Inventario').get();
      print('Número de documentos obtenidos: ${querySnapshot.docs.length}');
      setState(() {
        inventarioData = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          print('Documento: $data');
          return data;
        }).toList();
      });
      print('Datos del inventario: $inventarioData');
    } catch (e) {
      print('Error al obtener datos del inventario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.0, -1.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 118.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      alignment: const AlignmentDirectional(-1.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  40.0, 0.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed('Dashboard');
                                },
                                text: '',
                                icon: const Icon(
                                  Icons.chevron_left,
                                  size: 25.0,
                                ),
                                options: FFButtonOptions(
                                  width: 40.0,
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5.0, 10.0, 10.0, 10.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          2.0, 2.0, 2.0, 2.0),
                                  color: const Color(0xFF2563EB),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                25.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Inventario',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 29.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(40.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 70.0,
                        height: 94.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(1.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            _mostrarMenuAgregar(context);
                          },
                          text: 'Agregar',
                          options: FFButtonOptions(
                            width: 150.0,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: const Color(0xFF2563EB),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'Modificar',
                            options: FFButtonOptions(
                              width: 150.0,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: const Color(0xFF2563EB),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'Eliminar',
                            options: FFButtonOptions(
                              width: 150.0,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: const Color(0xFF2563EB),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 70.0,
                        height: 87.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      40.0, 40.0, 40.0, 40.0),
                  child: inventarioData.isEmpty
                      ? Center(
                          child: inventarioData.isEmpty
                              ? const Text('No hay datos disponibles')
                              : const CircularProgressIndicator(),
                        )
                      : FlutterFlowDataTable<Map<String, dynamic>>(
                          controller: _model.paginatedDataTableController,
                          data: inventarioData,
                          columnsBuilder: (onSortChanged) {
                            print(
                                'Construyendo columnas. Datos: $inventarioData');
                            return [
                              DataColumn2(
                                label: DefaultTextStyle.merge(
                                  softWrap: true,
                                  child: Text(
                                    'Nombre',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                onSort: onSortChanged,
                              ),
                              DataColumn2(
                                label: DefaultTextStyle.merge(
                                  softWrap: true,
                                  child: Text(
                                    'Cantidad Disponible',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                onSort: onSortChanged,
                              ),
                              DataColumn2(
                                label: DefaultTextStyle.merge(
                                  softWrap: true,
                                  child: Text(
                                    'Cantidad Mínima',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                onSort: onSortChanged,
                              ),
                              DataColumn2(
                                label: DefaultTextStyle.merge(
                                  softWrap: true,
                                  child: Text(
                                    'Unidad',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                onSort: onSortChanged,
                              ),
                              DataColumn2(
                                label: DefaultTextStyle.merge(
                                  softWrap: true,
                                  child: Text(
                                    'Ubicación',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                onSort: onSortChanged,
                              ),
                              DataColumn2(
                                label: DefaultTextStyle.merge(
                                  softWrap: true,
                                  child: Text(
                                    'Última Actualización',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                onSort: onSortChanged,
                              ),
                            ];
                          },
                          dataRowBuilder:
                              (item, index, selected, onSelectChanged) {
                            print('Construyendo fila para item: $item');
                            return DataRow(
                              selected: selected,
                              onSelectChanged: onSelectChanged,
                              color: WidgetStateProperty.all(
                                index % 2 == 0
                                    ? FlutterFlowTheme.of(context)
                                        .secondaryBackground
                                    : FlutterFlowTheme.of(context)
                                        .primaryBackground,
                              ),
                              cells: [
                                DataCell(Text(item['nombre'] ?? '')),
                                DataCell(Text(
                                    item['cantidadDisponible']?.toString() ??
                                        '')),
                                DataCell(Text(
                                    item['cantidadMinima']?.toString() ?? '')),
                                DataCell(Text(item['unidad'] ?? '')),
                                DataCell(Text(item['ubicacion'] ?? '')),
                                DataCell(Text(item['ultimaActualizacion'] !=
                                        null
                                    ? (item['ultimaActualizacion'] as Timestamp)
                                        .toDate()
                                        .toString()
                                    : '')),
                              ],
                            );
                          },
                          paginated: true,
                          selectable: true,
                          hidePaginator: false,
                          showFirstLastButtons: false,
                          headingRowHeight: 56.0,
                          dataRowHeight: 48.0,
                          columnSpacing: 20.0,
                          headingRowColor: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(24.0),
                          addHorizontalDivider: true,
                          addTopAndBottomDivider: false,
                          hideDefaultHorizontalDivider: true,
                          horizontalDividerColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          horizontalDividerThickness: 1.0,
                          addVerticalDivider: false,
                          checkboxUnselectedFillColor: Colors.transparent,
                          checkboxSelectedFillColor: Colors.transparent,
                          checkboxCheckColor: const Color(0x8A000000),
                          checkboxUnselectedBorderColor:
                              const Color(0x8A000000),
                          checkboxSelectedBorderColor: const Color(0x8A000000),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarMenuAgregar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Agregar material al inventario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del material',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return inventarioData.where((material) => material['nombre']
                        .toLowerCase()
                        .contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['nombre']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _materialSeleccionado = suggestion;
                      _nombreController.text = suggestion['nombre'];
                      _cantidadMinimaController.text =
                          suggestion['cantidadMinima'].toString();
                      _unidadController.text = suggestion['unidad'];
                      _ubicacionController.text = suggestion['ubicacion'];
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cantidadAgregarController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad a agregar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cantidadMinimaController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad Mínima',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _unidadController,
                  decoration: InputDecoration(
                    labelText: 'Unidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _ubicacionController,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: const Size(120, 50),
              ),
              onPressed: () {
                _guardarMaterial();
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Guardar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _guardarMaterial() async {
    try {
      if (_materialSeleccionado != null) {
        // Actualizar material existente
        await FirebaseFirestore.instance
            .collection('Inventario')
            .doc(_materialSeleccionado!['id'])
            .update({
          'cantidadDisponible':
              FieldValue.increment(int.parse(_cantidadAgregarController.text)),
          'cantidadMinima': int.parse(_cantidadMinimaController.text),
          'unidad': _unidadController.text,
          'ubicacion': _ubicacionController.text,
          'ultimaActualizacion': FieldValue.serverTimestamp(),
        });
      } else {
        // Agregar nuevo material
        await FirebaseFirestore.instance.collection('Inventario').add({
          'nombre': _nombreController.text,
          'cantidadDisponible': int.parse(_cantidadAgregarController.text),
          'cantidadMinima': int.parse(_cantidadMinimaController.text),
          'unidad': _unidadController.text,
          'ubicacion': _ubicacionController.text,
          'ultimaActualizacion': FieldValue.serverTimestamp(),
        });
      }
      // Limpiar los controladores después de guardar
      _nombreController.clear();
      _cantidadAgregarController.clear();
      _cantidadMinimaController.clear();
      _unidadController.clear();
      _ubicacionController.clear();
      _materialSeleccionado = null;
      // Actualizar la lista de inventario
      _obtenerDatosInventario();
    } catch (e) {
      print('Error al guardar material: $e');
      // Aquí podrías mostrar un mensaje de error al usuario
    }
  }
}
