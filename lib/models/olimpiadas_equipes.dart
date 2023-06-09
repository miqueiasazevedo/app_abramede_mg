class OlimpiadasEquipes {
  late String id;
  late String nomeEquipe;
  late String lider;
  late String membros;
  late String nomeProfessorResponsavel;

  OlimpiadasEquipes(this.id, this.nomeEquipe, this.lider, this.membros,
      this.nomeProfessorResponsavel);

  OlimpiadasEquipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomeEquipe = json['nome_equipe'];
    lider = json['lider'];
    membros = json['membros'];
    nomeProfessorResponsavel = json['nome_professor_responsavel'];
  }
}
