unit repository.lojasIntf;

interface
  uses
    FireDAC.Comp.Client;


  type
    ILojaRepository = interface
      ['{9760C0FB-75E7-4CC2-849F-10F749AFD036}']
    function consultarLoja(const Email: string; const Senha: string): string;
    function consultarIDLoja(const Email: string): integer;
    function consultarIDCaixa(const id: integer): integer;
    function consultarIDCategoria(const id: integer): integer;

    procedure criarLoja(const Nome: string; Email: string; const Senha: string);
    procedure criarCaixa(const saldoTotal: Double; const idLoja: integer);
    procedure criarCategoria(const nome: string; const idLoja: integer);
    procedure criarMovimento(const idCategoria: integer; const valor: double;
      const tipo: string; const descricao: string; const data: TDate;
      const idCaixa: integer);

    procedure resumoCaixa(const idCaixa: integer; out AFDQuery: TFDQuery);
    end;

implementation

end.
