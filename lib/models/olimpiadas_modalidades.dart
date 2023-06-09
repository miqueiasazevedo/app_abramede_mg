class OlimpiadasModalidades {
  late String id;
  late String sigla;

  OlimpiadasModalidades(this.id, this.sigla);

  OlimpiadasModalidades.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sigla = json['sigla'];
  }
}
