class CasoClinico {
  late String id;
  late String nomeCasoClinico;
  late String descritivo;

  CasoClinico(this.id, this.nomeCasoClinico, this.descritivo);

  CasoClinico.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomeCasoClinico = json['nome_caso_clinico'];
    descritivo = json['descritivo'];
  }
}
