class Alternativa {
  late String id;
  late String idPergunta;
  late String alternativa;

  Alternativa(this.id, this.idPergunta, this.alternativa);

  Alternativa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idPergunta = json['id_pergunta'];
    alternativa = json['alternativa'];

    /*print("Alternativa ID: " +
        id +
        " id_pergunta: " +
        id_pergunta +
        " alternativa: " +
        alternativa);

     */
  }
}
