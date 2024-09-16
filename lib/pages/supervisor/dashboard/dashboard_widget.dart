import 'package:cloud_firestore/cloud_firestore.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';
import 'package:intl/intl.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());
    verificarConexion();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Row(
          children: [
            if (responsiveVisibility(context: context, phone: false))
              _buildSidebar(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatCards(),
                          _buildCharts(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 118.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 50.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dashboard',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                  ),
            ),
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 60.0,
              fillColor: const Color(0xFF2563EB),
              icon: Icon(
                Icons.notifications_none,
                color: FlutterFlowTheme.of(context).info,
                size: 30.0,
              ),
              onPressed: () {
                _mostrarMenuSolicitudes(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isExpanded ? 200.0 : 70.0,
      color: const Color(0xFF2563EB),
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(_isExpanded ? Icons.menu_open : Icons.menu,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSidebarItem('Dashboard', Icons.dashboard, () {}),
                _buildSidebarItem('Inventario', Icons.inventory, () {
                  context.pushNamed('Inventario');
                }),
                _buildSidebarItem('Asignar', Icons.assignment, () {
                  context.pushNamed('Asignar');
                }),
                _buildSidebarItem('Empleados', Icons.people, () {
                  context.pushNamed('Empleados');
                }),
                _buildSidebarItem('Estadísticas', Icons.bar_chart, () {}),
              ],
            ),
          ),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: AnimatedOpacity(
        opacity: _isExpanded ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: _isExpanded
            ? Text(title, style: const TextStyle(color: Colors.white))
            : const SizedBox.shrink(),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.white),
      title: _isExpanded
          ? const Text('Cerrar sesión', style: TextStyle(color: Colors.white))
          : null,
      onTap: () async {
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();
        if (context.mounted) {
          context.goNamedAuth('Login', context.mounted);
        }
      },
    );
  }

  Widget _buildStatCards() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(40.0, 40.0, 40.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildInventoryStatCard(),
          const SizedBox(width: 30),
          _buildAsignacionesHoyCard(),
          const SizedBox(width: 30),
          _buildSolicitudesPendientesCard(),
        ],
      ),
    );
  }

  Widget _buildSolicitudesPendientesCard() {
    return StreamBuilder<int>(
      stream: obtenerSolicitudesPendientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatCard('Solicitudes Pendientes', '...', 'Cargando...');
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return _buildStatCard(
              'Solicitudes Pendientes', 'Error', 'No se pudo cargar');
        } else {
          final totalSolicitudes = snapshot.data ?? 0;
          return _buildStatCard('Solicitudes Pendientes', '$totalSolicitudes',
              'Solicitudes activas');
        }
      },
    );
  }

  Widget _buildAsignacionesHoyCard() {
    return StreamBuilder<int>(
      stream: obtenerAsignacionesHoy(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatCard('Asignaciones hoy', '...', 'Cargando...');
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return _buildStatCard(
              'Asignaciones hoy', 'Error', 'No se pudo cargar');
        } else {
          final totalAsignaciones = snapshot.data ?? 0;
          return _buildStatCard(
              'Asignaciones hoy', '$totalAsignaciones', 'Operadores asignados');
        }
      },
    );
  }

  Widget _buildInventoryStatCard() {
    return StreamBuilder<int>(
      stream: obtenerTotalInventario(),
      builder: (context, snapshot) {
        print('Estado de la conexión: ${snapshot.connectionState}');
        print('Datos: ${snapshot.data}');
        print('Error: ${snapshot.error}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatCard('Inventario', '...', 'Cargando...');
        } else if (snapshot.hasError) {
          return _buildStatCard('Inventario', 'Error', 'No se pudo cargar');
        } else if (!snapshot.hasData) {
          return _buildStatCard('Inventario', '0', 'Sin datos');
        } else {
          final totalInventario = snapshot.data ?? 0;
          return _buildStatCard(
              'Inventario', '$totalInventario', 'Unidades disponibles');
        }
      },
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        height: 250.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Text(
                  value,
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Text(
                  subtitle,
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(40.0, 40.0, 40.0, 40.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              height: 400.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    20.0, 20.0, 20.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uso de Materiales',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    // Aquí iría el gráfico de uso de materiales
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Container(
              height: 400.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    20.0, 20.0, 20.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próximas asignaciones',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    // Aquí iría la lista de próximas asignaciones
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarMenuSolicitudes(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Solicitudes Pendientes'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: obtenerSolicitudesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No hay solicitudes pendientes');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var solicitud = snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title:
                            Text(solicitud['empleado_nombre'] ?? 'Sin nombre'),
                        subtitle: Text(
                            'Prioridad: ${solicitud['prioridad'] ?? 'N/A'}'),
                        trailing: Text(solicitud['hora'] != null
                            ? DateFormat('HH:mm')
                                .format(solicitud['hora'].toDate())
                            : 'Sin hora'),
                        onTap: () =>
                            _mostrarDetallesSolicitud(context, solicitud),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetallesSolicitud(
      BuildContext context, DocumentSnapshot solicitud) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(solicitud['empleado_nombre'] ?? 'Detalles de la Solicitud'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Empleado: ${solicitud['empleado_nombre']}'),
                Text('Prioridad: ${solicitud['prioridad']}'),
                Text(
                    'Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(solicitud['hora'].toDate())}'),
                Text('Estado: ${solicitud['estado']}'),
                const Text('Materiales:'),
                ...(solicitud['materiales'] as List<dynamic>)
                    .map((material) => Text(
                        '- ${material['material']}: ${material['cantidad']} ${material['unidad'] ?? ''}'))
                    .toList(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Marcar como Entregado'),
              onPressed: () => _marcarComoEntregado(context, solicitud),
            ),
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _marcarComoEntregado(
      BuildContext context, DocumentSnapshot solicitud) async {
    try {
      // Obtener los documentos del inventario fuera de la transacción
      List<QueryDocumentSnapshot> inventarioDocs = await Future.wait(
          (solicitud['materiales'] as List<dynamic>).map((material) async {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Inventario')
            .where('nombre', isEqualTo: material['material'])
            .limit(1)
            .get();
        if (querySnapshot.docs.isEmpty) {
          throw Exception(
              "Material ${material['material']} no encontrado en el inventario");
        }
        return querySnapshot.docs.first;
      }));

      // Iniciar una transacción de Firestore
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Actualizar el estado de la solicitud a 'entregado'
        DocumentReference solicitudRef = FirebaseFirestore.instance
            .collection('solicitudes')
            .doc(solicitud.id);
        transaction.update(solicitudRef, {'estado': 'entregado'});

        // Crear una nueva asignación basada en la solicitud
        DocumentReference asignacionRef =
            FirebaseFirestore.instance.collection('asignaciones').doc();

        Map<String, dynamic> asignacionData = {
          'estado': 'entregado',
          'fechaAsignacion': FieldValue.serverTimestamp(),
          'materiales': (solicitud['materiales'] as List<dynamic>)
              .map((material) => {
                    'cantidad': material['cantidad'],
                    'materialNombre': material['material'],
                    'unidad': material['unidad'] ?? '',
                  })
              .toList(),
          'operadorId': solicitud['empleado_uid'],
          'operadorNombre': solicitud['empleado_nombre'],
        };

        transaction.set(asignacionRef, asignacionData);

        // Actualizar el inventario para cada material
        for (int i = 0; i < inventarioDocs.length; i++) {
          var docRef = inventarioDocs[i].reference;
          var material = (solicitud['materiales'] as List<dynamic>)[i];

          int cantidadActual =
              inventarioDocs[i]['cantidadDisponible'] as int? ?? 0;
          int cantidad = material['cantidad'];
          int nuevaCantidad = cantidadActual - cantidad;

          if (nuevaCantidad < 0) {
            throw Exception(
                "No hay suficiente cantidad disponible para ${material['material']}");
          }

          transaction.update(docRef, {'cantidadDisponible': nuevaCantidad});
        }
      });

      Navigator.of(context).pop(); // Cierra el diálogo de detalles
      Navigator.of(context)
          .pop(); // Cierra el diálogo de solicitudes pendientes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Solicitud marcada como entregada, guardada en asignaciones e inventario actualizado')),
      );
    } catch (e) {
      print('Error al marcar como entregado y actualizar inventario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al marcar como entregado y actualizar inventario: ${e.toString()}')),
      );
    }
  }

  Stream<QuerySnapshot> obtenerSolicitudesStream() {
    final currentUserUid2 = currentUserUid;

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid2)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists) {
        return FirebaseFirestore.instance
            .collection('solicitudes')
            .limit(0)
            .get();
      }

      final uid = userDoc.data()?['uid'] as String?;
      if (uid == null) {
        return FirebaseFirestore.instance
            .collection('solicitudes')
            .limit(0)
            .get();
      }

      return FirebaseFirestore.instance
          .collection('solicitudes')
          .where('supervisor_uid', isEqualTo: uid)
          .where('estado', isEqualTo: 'Pendiente')
          .get();
    });
  }
}

Stream<int> obtenerTotalInventario() {
  print('Iniciando obtención de inventario...');
  return FirebaseFirestore.instance
      .collection('Inventario')
      .snapshots()
      .map((snapshot) {
    print('Número de documentos: ${snapshot.docs.length}');
    int total = snapshot.docs.fold(0, (total, doc) {
      print('Documento completo: ${doc.data()}');
      int cantidad = doc['cantidadDisponible'] as int? ?? 0;
      print('Documento: ${doc.id}, Cantidad Disponible: $cantidad');
      return total + cantidad;
    });
    print('Total calculado: $total');
    return total;
  });
}

Stream<int> obtenerAsignacionesHoy() {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return FirebaseFirestore.instance
      .collection('asignaciones')
      .where('fechaAsignacion', isGreaterThanOrEqualTo: startOfDay)
      .where('fechaAsignacion', isLessThan: endOfDay)
      .snapshots()
      .map((snapshot) {
    print('Asignaciones hoy: ${snapshot.docs.length}');
    return snapshot.docs.length;
  });
}

Stream<int> obtenerSolicitudesPendientes() async* {
  final currentUserUid2 = currentUserUid;

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid2)
        .get();

    if (!userDoc.exists) {
      yield 0;
      return;
    }

    final uid = userDoc.data()?['uid'] as String?;
    if (uid == null) {
      yield 0;
      return;
    }

    yield* FirebaseFirestore.instance
        .collection('solicitudes')
        .where('supervisor_uid', isEqualTo: uid)
        .where('estado', isEqualTo: 'Pendiente')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  } catch (e) {
    print('Error al obtener solicitudes pendientes: $e');
    yield 0;
  }
}

void verificarConexion() async {
  try {
    var snapshot =
        await FirebaseFirestore.instance.collection('Inventario').get();
    print('Documentos en inventario: ${snapshot.docs.length}');
    for (var doc in snapshot.docs) {
      print('Documento: ${doc.id}, Datos: ${doc.data()}');
    }
  } catch (e) {
    print('Error al conectar con Firestore: $e');
  }
}
