class EtapasResponse{
  final int id;
  final String nombre;
  final String duracion;
  final int id_servicio;

  EtapasResponse(this.id,
      this.nombre,
      this.duracion,
      this.id_servicio);
  EtapasResponse.fromJson(Map<String,dynamic>json)
      : id =json['id'],
        nombre=json['nombre'],
        duracion=json['duracion'],
        id_servicio=json['id_servicio'];
}