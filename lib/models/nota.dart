class Nota {
  int? id;
  String titulo;
  String conteudo;
  String? imagemPath;
  String data;

  Nota({
    this.id,
    required this.titulo,
    required this.conteudo,
    this.imagemPath,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
      'imagem_path': imagemPath,
      'data': data,
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'],
      titulo: map['titulo'],
      conteudo: map['conteudo'],
      imagemPath: map['imagem_path'],
      data: map['data'],
    );
  }
}
