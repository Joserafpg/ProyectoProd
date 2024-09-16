class Operador {
  final String id;
  final String nombre;
  final String apellido;
  // Agrega más campos según sea necesario

  Operador({
    required this.id,
    required this.nombre,
    required this.apellido,
    // Inicializa otros campos aquí
  });

  // Opcionalmente, puedes agregar métodos como:

  // Método para crear un Operador desde un Map (útil para JSON)
  factory Operador.fromMap(Map<String, dynamic> map) {
    return Operador(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      // Asigna otros campos
    );
  }

  // Método para convertir el Operador a un Map (útil para JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      // Incluye otros campos
    };
  }

  // Puedes agregar más métodos según tus necesidades
}
