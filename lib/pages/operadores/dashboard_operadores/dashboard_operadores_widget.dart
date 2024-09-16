import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'dashboard_operadores_model.dart';
export 'dashboard_operadores_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardOperadoresWidget extends StatefulWidget {
  const DashboardOperadoresWidget({super.key});

  @override
  _DashboardOperadoresWidgetState createState() =>
      _DashboardOperadoresWidgetState();
}

class _DashboardOperadoresWidgetState extends State<DashboardOperadoresWidget> {
  late DashboardOperadoresModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardOperadoresModel());
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
        key: scaffoldKey,
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
                _buildSidebarItem('Materiales', Icons.inventory, () {
                  context.pushNamed('Materiales');
                }),
                _buildSidebarItem('Producción', Icons.bar_chart, () {
                  context.pushNamed('Produccion');
                }),
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
              'Dashboard Operador',
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
                _mostrarAsignacionesEnProceso(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(40.0, 40.0, 40.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildStatCard('Producción total', '1,200', 'Unidades disponibles'),
          const SizedBox(width: 30),
          _buildStatCard('Tasa de defectos', '2.3%', 'Operadores asignados'),
          const SizedBox(width: 30),
          _buildStatCard('Eficiencia', '95%', 'Promedio'),
        ],
      ),
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

  void _mostrarAsignacionesEnProceso(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Asignaciones Pendientes'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: obtenerAsignacionesEnProcesoStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No hay asignaciones pendientes');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var asignacion = snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title:
                            Text(asignacion['operadorNombre'] ?? 'Sin nombre'),
                        subtitle:
                            Text('Estado: ${asignacion['estado'] ?? 'N/A'}'),
                        trailing: Text(asignacion['fechaAsignacion'] != null
                            ? DateFormat('dd/MM/yyyy HH:mm')
                                .format(asignacion['fechaAsignacion'].toDate())
                            : 'Sin fecha'),
                        onTap: () =>
                            _mostrarDetallesAsignacion(context, asignacion),
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

  void _mostrarDetallesAsignacion(
      BuildContext context, DocumentSnapshot asignacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(asignacion['operadorNombre'] ?? 'Detalles de la Asignación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Estado: ${asignacion['estado']}'),
                Text(
                    'Fecha de Asignación: ${DateFormat('dd/MM/yyyy HH:mm').format(asignacion['fechaAsignacion'].toDate())}'),
                const Text('Materiales:'),
                ...((asignacion['materiales'] as List<dynamic>?) ?? [])
                    .map((material) => Text(
                        '- ${material['materialNombre']}: ${material['cantidad']} ${material['unidad']}'))
                    .toList(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Marcar como Recibido'),
              onPressed: () => _marcarComoRecibido(context, asignacion.id),
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

  void _marcarComoRecibido(BuildContext context, String asignacionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('asignaciones')
          .doc(asignacionId)
          .update({
        'estado': 'entregado',
      });
      Navigator.of(context).pop(); // Cierra el diálogo de detalles
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asignación marcada como recibida')),
      );
    } catch (e) {
      print('Error al marcar como recibido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al marcar como recibido')),
      );
    }
  }
}

Stream<QuerySnapshot> obtenerAsignacionesEnProcesoStream() {
  return FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .snapshots()
      .asyncMap((userDoc) async {
    if (!userDoc.exists) {
      return FirebaseFirestore.instance
          .collection('asignaciones')
          .limit(0)
          .get();
    }

    final uid = userDoc.data()?['uid'] as String?;
    if (uid == null) {
      return FirebaseFirestore.instance
          .collection('asignaciones')
          .limit(0)
          .get();
    }

    return FirebaseFirestore.instance
        .collection('asignaciones')
        .where('operadorId', isEqualTo: uid)
        .where('estado', isEqualTo: 'pendiente') // Agregamos esta línea
        .get();
  });
}
