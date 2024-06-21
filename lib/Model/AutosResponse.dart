class AutosResponse{
  final int id;
  final String matricula;
  final String color;
  final String modelo;
  final String marca;

  AutosResponse(this.id,
      this.matricula,
      this.color,
      this.modelo,
      this.marca);
  AutosResponse.fromJson(Map<String,dynamic>json)
      : id =json['id'],
        matricula=json['matricula'],
        color=json['color'],
        modelo=json['modelo'],
        marca=json['marca'];
}