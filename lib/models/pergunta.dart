class Pergunta {
  late String id;
  late String pergunta;
  late String opcaoEscolhida;

  Pergunta(this.id, this.pergunta, this.opcaoEscolhida);

  Pergunta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pergunta = json['pergunta'];
    opcaoEscolhida = json['opcao_escolhida'];

    //print("Pergunta ID: " + id + " pergunta: " + pergunta);
  }
}
