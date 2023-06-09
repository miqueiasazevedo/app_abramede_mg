class Programacao {
  late String id;
  late String idPalestrante;
  late String data;
  late String horaInicial;
  late String horaTermino;
  late String periodo;
  late String titulo;
  late String local;
  late String area;
  late String atividade;
  late String outrasInformacoes;

  Programacao(
      this.id,
      this.idPalestrante,
      this.data,
      this.horaInicial,
      this.horaTermino,
      this.periodo,
      this.titulo,
      this.local,
      this.area,
      this.atividade,
      this.outrasInformacoes);

  Programacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idPalestrante = json['id_palestrante'];
    data = json['data'];
    horaInicial = json['hora_inicial'];
    horaTermino = json['hora_termino'];
    periodo = json['periodo'];
    titulo = json['titulo'];
    local = json['local'];
    area = json['area'];
    atividade = json['atividade'];
    outrasInformacoes = json['outras_informacoes'];
  }
}
