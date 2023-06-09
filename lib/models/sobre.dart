class Sobre {
  late String informacao;

  Sobre(this.informacao);

  Sobre.fromJson(Map<String, dynamic> json) {
    informacao = json['informacao'];
  }
}
