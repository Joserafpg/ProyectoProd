import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class InventarioRecord extends FirestoreRecord {
  InventarioRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "producto" field.
  String? _producto;
  String get producto => _producto ?? '';
  bool hasProducto() => _producto != null;

  // "cantidad" field.
  int? _cantidad;
  int get cantidad => _cantidad ?? 0;
  bool hasCantidad() => _cantidad != null;

  // "unidad_medida" field.
  String? _unidadMedida;
  String get unidadMedida => _unidadMedida ?? '';
  bool hasUnidadMedida() => _unidadMedida != null;

  // "ubicacion" field.
  String? _ubicacion;
  String get ubicacion => _ubicacion ?? '';
  bool hasUbicacion() => _ubicacion != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _producto = snapshotData['producto'] as String?;
    _cantidad = castToType<int>(snapshotData['cantidad']);
    _unidadMedida = snapshotData['unidad_medida'] as String?;
    _ubicacion = snapshotData['ubicacion'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Inventario');

  static Stream<InventarioRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InventarioRecord.fromSnapshot(s));

  static Future<InventarioRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InventarioRecord.fromSnapshot(s));

  static InventarioRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InventarioRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InventarioRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InventarioRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InventarioRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InventarioRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInventarioRecordData({
  String? uid,
  String? producto,
  int? cantidad,
  String? unidadMedida,
  String? ubicacion,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'producto': producto,
      'cantidad': cantidad,
      'unidad_medida': unidadMedida,
      'ubicacion': ubicacion,
    }.withoutNulls,
  );

  return firestoreData;
}

class InventarioRecordDocumentEquality implements Equality<InventarioRecord> {
  const InventarioRecordDocumentEquality();

  @override
  bool equals(InventarioRecord? e1, InventarioRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.producto == e2?.producto &&
        e1?.cantidad == e2?.cantidad &&
        e1?.unidadMedida == e2?.unidadMedida &&
        e1?.ubicacion == e2?.ubicacion;
  }

  @override
  int hash(InventarioRecord? e) => const ListEquality()
      .hash([e?.uid, e?.producto, e?.cantidad, e?.unidadMedida, e?.ubicacion]);

  @override
  bool isValidKey(Object? o) => o is InventarioRecord;
}
