unit services.lojasIntf;

interface

  uses
    System.Json,
    model.entities.lojas,
    model.entities.caixas,
    model.entities.categorias,
    model.entities.movimentos;

  type
    ILojaService = interface
      ['{115C5C4A-1665-42C6-8B2D-E419B089BBAE}']
      function consultarLoja(const Email: string; const Senha: string): Boolean;
      function consultarIDLoja(const Email: string): integer;
      function consultarIDCaixa(const id: integer): integer;
      function consultarIDCategoria(const id: integer): integer;

      function criarLoja(const Nome: string; const Email: string; const Senha: string): TRetornoLoja;
      function criarCaixa(const saldoTotal: double; const idLoja: integer): TRetornoCaixa;
      function criarCategoria(const Nome: string; const idLoja: integer): TRetornoCategoria;
      function criarMovimentos(const idCategoria: integer; const valor: double;
        const tipo: string; const descricao: string; const data: TDate;
        const idCaixa: integer): TRetornoMovimento;

      function resumoCaixa(const idCaixa: integer): TJSONObject;
    end;

implementation

end.
