import 'package:prod_audit/auth/firebase_auth/auth_util.dart';

import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'asignar_model.dart';
export 'asignar_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AsignarWidget extends StatefulWidget {
  const AsignarWidget({super.key});

  @override
  State<AsignarWidget> createState() => _AsignarWidgetState();
}

class _AsignarWidgetState extends State<AsignarWidget> {
  late AsignarModel _model;
  int cantidad = 0;
  final ValueNotifier<List<Map<String, dynamic>>> materialesNotifier =
      ValueNotifier([]);
  Map<String, String>? operadorSeleccionado;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> materiales = [];
  List<Map<String, String>> operadores = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AsignarModel());
    _model.textController ??= TextEditingController();
    cargarOperadores();
    cargarMateriales();
  }

  Future<void> cargarOperadores() async {
    try {
      // Obtener el ID del documento del usuario actual
      String currentUserDocId = currentUserUid;

      // Obtener el documento del usuario actual
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserDocId)
          .get();

      // Obtener el UID real del usuario
      String supervisorUid = userDoc['uid'] as String;

      // Consultar los operadores asignados a este supervisor
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Empleados')
          .where('puesto', isEqualTo: 'Operador')
          .where('supervisor', isEqualTo: supervisorUid)
          .get();

      setState(() {
        operadores = querySnapshot.docs.map((doc) {
          return {
            'uid': doc.id,
            'nombre': doc['nombre'] as String,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar operadores: $e');
    }
  }

  Future<void> cargarMateriales() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Inventario').get();

      setState(() {
        materiales = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'nombre': doc['nombre'] as String? ?? 'Sin nombre',
            'cantidadDisponible': doc['cantidadDisponible'] as int? ?? 0,
            'unidad': doc['unidad'] as String? ?? 'N/A',
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar materiales: $e');
      // Muestra un mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Error al cargar materiales. Por favor, intenta de nuevo.')),
      );
    }
  }

  Future<void> actualizarInventario(
      String materialNombre, int cantidadAsignada) async {
    try {
      // Buscar el documento del material por nombre
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Inventario')
          .where('nombre', isEqualTo: materialNombre)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("Material no encontrado en el inventario");
      }

      DocumentReference docRef = querySnapshot.docs.first.reference;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception("El material no existe en el inventario");
        }

        int cantidadActual = snapshot['cantidadDisponible'] as int? ?? 0;
        int nuevaCantidad = cantidadActual - cantidadAsignada;
        if (nuevaCantidad < 0) {
          throw Exception("No hay suficiente cantidad disponible");
        }

        transaction.update(docRef, {'cantidadDisponible': nuevaCantidad});
      });

      // Actualizar la lista local de materiales
      setState(() {
        int index = materiales.indexWhere((m) => m['nombre'] == materialNombre);
        if (index != -1) {
          materiales[index]['cantidadDisponible'] -= cantidadAsignada;
        }
      });

      print('Inventario actualizado para $materialNombre: -$cantidadAsignada');
    } catch (e) {
      print('Error al actualizar inventario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al actualizar inventario: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void actualizarEstadoSinAnimacion(VoidCallback actualizacion) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(actualizacion);
      }
    });
  }

  Future<void> guardarAsignacion() async {
    if (operadorSeleccionado == null || materialesNotifier.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Por favor, selecciona un operador y asigna materiales.')),
      );
      return;
    }

    try {
      // Iniciar una transacción de Firestore
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Crear una nueva asignación
        DocumentReference asignacionRef =
            FirebaseFirestore.instance.collection('asignaciones').doc();

        Map<String, dynamic> asignacionData = {
          'operadorId': operadorSeleccionado!['uid'] ?? '',
          'operadorNombre': operadorSeleccionado!['nombre'] ?? '',
          'fechaAsignacion': FieldValue.serverTimestamp(),
          'materiales': materialesNotifier.value
              .map((material) => {
                    'materialNombre': material['material'] ?? '',
                    'cantidad': material['cantidad'] as int? ?? 0,
                    'unidad': material['unidad'] ?? '',
                  })
              .toList(),
          'estado': 'pendiente'
        };

        transaction.set(asignacionRef, asignacionData);

        // Crear un nuevo documento en la colección 'movimientos'
        DocumentReference movimientoRef =
            FirebaseFirestore.instance.collection('movimientos').doc();

        Map<String, dynamic> movimientoData = {
          'tipoMovimiento': 'Asignación',
          'fechaMovimiento': FieldValue.serverTimestamp(),
          'operadorId': operadorSeleccionado!['uid'] ?? '',
          'operadorNombre': operadorSeleccionado!['nombre'] ?? '',
          'materiales': materialesNotifier.value
              .map((material) => {
                    'materialNombre': material['material'] ?? '',
                    'cantidad': material['cantidad'] as int? ?? 0,
                    'unidad': material['unidad'] ?? '',
                  })
              .toList(),
          'asignacionId': asignacionRef.id,
          'estado': 'pendiente'
        };

        transaction.set(movimientoRef, movimientoData);

        // Actualizar el inventario
        for (var material in materialesNotifier.value) {
          String materialNombre = material['material'] as String? ?? '';
          int cantidad = material['cantidad'] as int? ?? 0;
          if (materialNombre.isNotEmpty && cantidad > 0) {
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('Inventario')
                .where('nombre', isEqualTo: materialNombre)
                .limit(1)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              DocumentReference docRef = querySnapshot.docs.first.reference;
              try {
                DocumentSnapshot snapshot = await transaction.get(docRef);
                if (!snapshot.exists) {
                  throw Exception(
                      "El documento del inventario no existe para $materialNombre");
                }
                int cantidadActual =
                    snapshot['cantidadDisponible'] as int? ?? 0;
                int nuevaCantidad = cantidadActual - cantidad;
                if (nuevaCantidad < 0) {
                  throw Exception(
                      "No hay suficiente cantidad disponible para $materialNombre");
                }
                transaction
                    .update(docRef, {'cantidadDisponible': nuevaCantidad});
              } catch (e) {
                print('Error al procesar el material $materialNombre: $e');
                throw e; // Re-lanzar la excepción para que la transacción falle
              }
            } else {
              throw Exception(
                  "Material $materialNombre no encontrado en el inventario");
            }
          }
        }
      },
          timeout: const Duration(
              seconds: 30)); // Aumentar el tiempo de espera de la transacción

      setState(() {
        operadorSeleccionado = null;
        materialesNotifier.value = [];
        _model.dropDownValue = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Asignación guardada y movimiento registrado con éxito')),
      );
    } catch (e) {
      print('Error al guardar la asignación y registrar el movimiento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al guardar la asignación y registrar el movimiento: ${e.toString()}')),
      );
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed('Dashboard');
                          },
                          text: '',
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          options: FFButtonOptions(
                            width: 40.0,
                            height: 40.0,
                            padding: EdgeInsets.zero,
                            color: const Color(0xFF2563EB),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Text(
                          'Asignar materiales',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Contenido principal
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Formulario (lado izquierdo)
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(14.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Operador
                              const Text('Operador',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController ??=
                                    FormFieldController<String>(null),
                                options: operadores
                                    .map((op) => op['nombre']!)
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    if (operadorSeleccionado == null) {
                                      operadorSeleccionado =
                                          operadores.firstWhere(
                                        (op) => op['nombre'] == val,
                                        orElse: () => {'uid': '', 'nombre': ''},
                                      );
                                      _model.dropDownValue = val;
                                    } else {
                                      // Mostrar diálogo de confirmación
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                '¿Quieres empezar de nuevo?'),
                                            content: const Text(
                                                'Si cambias el operador, se borrarán todas las asignaciones actuales.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancelar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Aceptar'),
                                                onPressed: () {
                                                  setState(() {
                                                    operadorSeleccionado =
                                                        operadores.firstWhere(
                                                      (op) =>
                                                          op['nombre'] == val,
                                                      orElse: () => {
                                                        'uid': '',
                                                        'nombre': ''
                                                      },
                                                    );
                                                    _model.dropDownValue = val;
                                                    materialesNotifier.value
                                                        .clear();
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                                width: 200.0,
                                height: 50.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                                hintText: 'Seleccionar operador...',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor: Colors.transparent,
                                borderWidth: 0.0,
                                borderRadius: 8.0,
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                hidesUnderline: true,
                                isOverButton: false,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                              const SizedBox(height: 20.0),

                              // Fecha de asignación
                              const Text('Fecha de asignación',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      final datePickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: getCurrentTimestamp,
                                        firstDate: DateTime(1900),
                                        lastDate: getCurrentTimestamp,
                                        builder: (context, child) {
                                          return wrapInMaterialDatePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: 'Inter Tight',
                                                      fontSize: 32.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24.0,
                                          );
                                        },
                                      );

                                      TimeOfDay? datePickedTime;
                                      if (datePickedDate != null) {
                                        datePickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              getCurrentTimestamp),
                                          builder: (context, child) {
                                            return wrapInMaterialTimePickerTheme(
                                              context,
                                              child!,
                                              headerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              headerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              headerTextStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .override(
                                                        fontFamily:
                                                            'Inter Tight',
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                              pickerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              pickerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              selectedDateTimeBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              selectedDateTimeForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              actionButtonForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              iconSize: 24.0,
                                            );
                                          },
                                        );
                                      }

                                      if (datePickedDate != null &&
                                          datePickedTime != null) {
                                        safeSetState(() {
                                          _model.datePicked = DateTime(
                                            datePickedDate.year,
                                            datePickedDate.month,
                                            datePickedDate.day,
                                            datePickedTime!.hour,
                                            datePickedTime.minute,
                                          );
                                        });
                                      }
                                    },
                                    text: '',
                                    icon: const Icon(
                                      Icons.edit_calendar,
                                      size: 20.0,
                                    ),
                                    options: FFButtonOptions(
                                      width: 50.0,
                                      height: 50.0,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 10.0, 0.0, 10.0),
                                      color: const Color(0xFF2563EB),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Inter Tight',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(14.0),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    dateTimeFormat(
                                        "M/d H:mm", _model.datePicked),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),

                              // Buscar Materiales
                              const Text('Buscar Materiales',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Autocomplete<Map<String, dynamic>>(
                                      initialValue: const TextEditingValue(),
                                      optionsBuilder: (textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<
                                              Map<String, dynamic>>.empty();
                                        }
                                        return materiales.where((option) {
                                          final lowercaseNombre =
                                              option['nombre'].toLowerCase();
                                          return lowercaseNombre.contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      displayStringForOption: (option) =>
                                          option['nombre'],
                                      onSelected:
                                          (Map<String, dynamic> selection) {
                                        setState(() {
                                          _model.textFieldSelectedOption =
                                              selection['nombre'];
                                          // Aquí podrías actualizar otros campos si es necesario
                                        });
                                      },
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        return AutocompleteOptionsList(
                                          textFieldKey: _model.textFieldKey,
                                          textController:
                                              _model.textController!,
                                          options: options
                                              .map((option) =>
                                                  option['nombre'] as String)
                                              .toList(),
                                          onSelected: (option) => onSelected(
                                              options.firstWhere((o) =>
                                                  o['nombre'] == option)),
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                          textHighlightStyle: const TextStyle(),
                                          elevation: 4.0,
                                          optionBackgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                          optionHighlightColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          maxHeight: 200.0,
                                        );
                                      },
                                      fieldViewBuilder: (
                                        context,
                                        textEditingController,
                                        focusNode,
                                        onEditingComplete,
                                      ) {
                                        _model.textFieldFocusNode = focusNode;
                                        _model.textController =
                                            textEditingController;
                                        return TextFormField(
                                          key: _model.textFieldKey,
                                          controller: textEditingController,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintText: 'Materiales',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .textControllerValidator
                                              .asValidator(context),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),

                              // Cantidad para devolver
                              const Text('Cantidad para devolver',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor: const Color(0xFF2563EB),
                                    icon: FaIcon(
                                      FontAwesomeIcons.minus,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (cantidad > 0) cantidad--;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$cantidad',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor: const Color(0xFF2563EB),
                                    icon: Icon(
                                      Icons.add,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        cantidad++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),

                              // Contenedor para alinear el botón a la derecha
                              Container(
                                alignment: Alignment.centerRight,
                                child: FFButtonWidget(
                                  onPressed: () {
                                    print("Botón presionado");
                                    if (_model.dropDownValue != null &&
                                        _model.textFieldSelectedOption !=
                                            null &&
                                        cantidad > 0) {
                                      print("Condiciones iniciales cumplidas");
                                      try {
                                        // Obtener la unidad de medida del mapa
                                        print("Buscando unidad de medida");
                                        String unidad = 'N/A';
                                        for (var material in materiales) {
                                          if (material['nombre'] ==
                                              _model.textFieldSelectedOption) {
                                            unidad =
                                                material['unidad'] as String? ??
                                                    'N/A';
                                            break;
                                          }
                                        }
                                        print("Unidad encontrada: $unidad");

                                        // Crear una copia de la lista actual
                                        print("Creando copia de la lista");
                                        List<Map<String, dynamic>> nuevaLista =
                                            List.from(materialesNotifier.value);
                                        print("Copia creada");

                                        print("Buscando índice existente");
                                        int existingIndex =
                                            nuevaLista.indexWhere((item) =>
                                                item['operador'] ==
                                                    _model.dropDownValue &&
                                                item['material'] ==
                                                    _model
                                                        .textFieldSelectedOption);
                                        print(
                                            "Índice encontrado: $existingIndex");

                                        if (existingIndex != -1) {
                                          print(
                                              "Actualizando cantidad existente");
                                          nuevaLista[existingIndex]
                                              ['cantidad'] += cantidad;
                                        } else {
                                          print("Agregando nueva asignación");
                                          nuevaLista.add({
                                            'operador': _model.dropDownValue!,
                                            'material':
                                                _model.textFieldSelectedOption!,
                                            'cantidad': cantidad,
                                            'unidad': unidad,
                                          });
                                        }

                                        print("Actualizando ValueNotifier");
                                        materialesNotifier.value = nuevaLista;

                                        print(
                                            "Actualizando operador seleccionado");
                                        operadorSeleccionado =
                                            operadores.firstWhere(
                                          (op) =>
                                              op['nombre'] ==
                                              _model.dropDownValue,
                                          orElse: () =>
                                              {'uid': '', 'nombre': ''},
                                        );

                                        print("Limpiando campos");
                                        _model.textController?.clear();
                                        setState(() {
                                          cantidad = 0;
                                        });

                                        print("Asignación completada");
                                      } catch (e) {
                                        print(
                                            "Error durante la asignación: $e");
                                      }
                                    } else {
                                      print(
                                          "No se cumplieron las condiciones iniciales");
                                    }
                                  },
                                  text: 'Guardar',
                                  icon: const Icon(
                                    Icons.save,
                                    size: 15.0,
                                  ),
                                  options: FFButtonOptions(
                                    width: 120.0,
                                    height: 40.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: const Color(0xFF2563EB),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 2.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      // Materiales Asignados (lado derecho)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Materiales Asignados',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 10.0),
                            ValueListenableBuilder<List<Map<String, dynamic>>>(
                              valueListenable: materialesNotifier,
                              builder: (context, materiales, child) {
                                return Container(
                                  height: 400.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(14.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: FlutterFlowDataTable<
                                      Map<String, dynamic>>(
                                    controller:
                                        _model.paginatedDataTableController,
                                    data: materiales,
                                    columnsBuilder: (onSortChanged) => [
                                      DataColumn2(
                                        label: DefaultTextStyle.merge(
                                          softWrap: true,
                                          child: Text(
                                            'Operador',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                      DataColumn2(
                                        label: DefaultTextStyle.merge(
                                          softWrap: true,
                                          child: Text(
                                            'Material',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                      DataColumn2(
                                        label: DefaultTextStyle.merge(
                                          softWrap: true,
                                          child: Text(
                                            'Cantidad',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
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
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    dataRowBuilder: (item, index, selected,
                                            onSelectChanged) =>
                                        DataRow(
                                      color: WidgetStateProperty.all(
                                        index % 2 == 0
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                      ),
                                      cells: [
                                        DataCell(Text(item['operador'])),
                                        DataCell(Text(item['material'])),
                                        DataCell(
                                            Text(item['cantidad'].toString())),
                                        DataCell(Text(item['unidad'])),
                                      ],
                                    ),
                                    paginated: true,
                                    numRows: 10,
                                    selectable: false,
                                    headingRowHeight: 56.0,
                                    dataRowHeight: 48.0,
                                    columnSpacing: 20.0,
                                    headingRowColor: const Color(0xFF2563EB),
                                    borderRadius: BorderRadius.circular(14.0),
                                    addHorizontalDivider: true,
                                    addTopAndBottomDivider: false,
                                    hideDefaultHorizontalDivider: true,
                                    horizontalDividerColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    horizontalDividerThickness: 1.0,
                                    addVerticalDivider: false,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            // Botón de enviar
                            Align(
                              alignment: Alignment.centerRight,
                              child: FFButtonWidget(
                                onPressed: guardarAsignacion,
                                text: 'Enviar asignación',
                                icon:
                                    const Icon(Icons.send_rounded, size: 15.0),
                                options: FFButtonOptions(
                                  width: 200.0,
                                  height: 50.0,
                                  color: const Color(0xFF2563EB),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
