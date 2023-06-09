class Palestrante {
  late String id;
  late String nome;
  late String localidade;
  late String internacional;
  late String miniCurriculo;
  late String urlImagemPerfil;

  Palestrante(this.id, this.nome, this.localidade, this.miniCurriculo,
      this.internacional, this.urlImagemPerfil);

  Palestrante.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    localidade = json['localidade'];
    internacional = json['internacional'];
    miniCurriculo = json['mini_curriculo'];
    urlImagemPerfil = json['url_imagem_perfil'];
  }
}
