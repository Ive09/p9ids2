class Usuariosresponse{
  final String name;
  final String email;
  final String password;

  Usuariosresponse(this.name,
      this.email,
      this.password);
  Usuariosresponse.fromJson(Map<String,dynamic>json)
      : name =json['name'],
        email=json['email'],
        password=json['password'];
}