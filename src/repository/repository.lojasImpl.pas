unit repository.lojasImpl;

interface

  uses
    FireDAC.Comp.Client,
    FireDAC.Stan.Param,

    repository.lojasIntf,
    model.connectionImpl,
    model.connectionIntf,

    System.SysUtils;


  type
    TLojaRepository = class(TInterfacedObject, ILojaRepository)
  private
    FDBConnection: IDBConnection;
    FFDQuery: TFDQuery;
    FFDQueryUPDATE: TFDQuery;
  public
    function consultarLoja(const Email: string; const Senha: string): string;
    function consultarIDLoja(const Email: string): integer;
    function consultarIDCaixa(const id: integer): integer;
    function consultarIDCategoria(const id: integer): integer;

    procedure criarLoja(const Nome: string; Email: string;
  const Senha: string);
    procedure criarCaixa(const saldoTotal: Double; const idLoja: integer);
    procedure criarCategoria(const nome: string; const idLoja: integer);
    procedure criarMovimento(const idCategoria: integer; const valor: double;
      const tipo: string; const descricao: string; const data: TDate;
      const idCaixa: integer);

    procedure resumoCaixa(const idCaixa: integer; out AFDQuery: TFDQuery);

    constructor Create;
    destructor Destroy; override;

  end;

implementation

  const
    SELECT_ID:
      string = 'SELECT LOJA.ID '+
               'FROM LOJA '+
               'WHERE LOJA.EMAIL = :EMAIL';

  const
    SELECT_ID_CAIXA:
      string = 'SELECT CAIXA.ID '+
               'FROM CAIXA '+
               'WHERE CAIXA.IDLOJA = :IDLOJA';

  const
    SELECT_LOJA:
      string = 'SELECT LOJA.SENHA '+
               'FROM LOJA '+
               'WHERE LOJA.EMAIL = :EMAIL';

  const
    SELECT_ID_CATEGORIA:
      string = 'SELECT CATEGORIA.ID '+
               'FROM CATEGORIA '+
               'WHERE CATEGORIA.ID = :IDCATEGORIA';

  const
    INSERT_LOJA:
      string = 'INSERT INTO LOJA '+
               '(NOME, EMAIL, SENHA) '+
               'VALUES '+
               '(:NOME, :EMAIL, :SENHA)';
  const
    INSERT_CAIXA:
      string = 'INSERT INTO CAIXA '+
               '(SALDOTOTAL, IDLOJA) '+
               'VALUES '+
               '(:SALDOTOTAL, :IDLOJA)';
  const
    INSERT_CATEGORIA:
      string = 'INSERT INTO CATEGORIA '+
               '(NOME, IDLOJA) '+
               'VALUES '+
               '(:NOME, :IDLOJA)';

  const
    INSERT_MOVIMENTO:
      string = 'INSERT INTO MOVIMENTO '+
               '(IDCATEGORIA, VALOR, TIPO, DESCRICAO, DATA, IDCAIXA) '+
               'VALUES '+
               '(:IDCATEGORIA, :VALOR, :TIPO, :DESCRICAO, :DATA, :IDCAIXA)';

  const
    UPDATE_SALDO:
      string = 'UPDATE CAIXA '+
               'SET SALDOTOTAL = SALDOTOTAL + :NOVOSALDO '+
               'WHERE ID = :IDCAIXA';

  const
    RESUMO_CAIXA:
      string = 'SELECT '+
               'CAIXA.SALDOTOTAL, '+
               'MOVIMENTO.ID AS MOVIMENTOID, '+
               'MOVIMENTO.DATA, '+
               'MOVIMENTO.TIPO, '+
               'MOVIMENTO.VALOR, '+
               'MOVIMENTO.DESCRICAO, '+
               'CATEGORIA.Id AS CATEGORIAID, '+
               'CATEGORIA.NOME '+
               'FROM CAIXA '+
               'INNER JOIN MOVIMENTO ON CAIXA.ID = MOVIMENTO.IdCaixa '+
               'INNER JOIN CATEGORIA ON CATEGORIA.ID = MOVIMENTO.IDCATEGORIA '+
               'WHERE CAIXA.ID = :IDCAIXA';

{ TLojaRepository }

function TLojaRepository.consultarIDCategoria(const id: integer): integer;
begin
  FFDQuery.SQL.Text := SELECT_ID_CATEGORIA;
  FFDQuery.ParamByName('IDCATEGORIA').AsInteger  := id;

  FFDQuery.Prepare;
  FFDQuery.Open;
  Result := FFDQuery.FieldByName('ID').asInteger;
end;

function TLojaRepository.consultarIDLoja(const Email: string): integer;
begin
  FFDQuery.SQL.Text := SELECT_ID;
  FFDQuery.ParamByName('EMAIL').AsString  := Email;

  FFDQuery.Prepare;
  FFDQuery.Open;
  Result := FFDQuery.FieldByName('ID').asInteger;
end;

function TLojaRepository.consultarIDCaixa(const id: integer): integer;
begin
  FFDQuery.SQL.Text := SELECT_ID_CAIXA;
  FFDQuery.ParamByName('IDLOJA').AsInteger  := ID;

  FFDQuery.Prepare;
  FFDQuery.Open;
  Result := FFDQuery.FieldByName('ID').asInteger;
end;

function TLojaRepository.consultarLoja(const Email, Senha: string): string;
begin
  FFDQuery.SQL.Text := SELECT_LOJA;
  FFDQuery.ParamByName('EMAIL').AsString  := Email;

  FFDQuery.Prepare;
  FFDQuery.Open;
  Result := FFDQuery.FieldByName('SENHA').AsString;
end;

constructor TLojaRepository.Create;
begin
  FDBConnection := TDBConnection.Create;
  FFDQuery := TFDQuery.Create(nil);
  FFDQueryUPDATE := TFDQuery.Create(nil);
  FFDQuery.Connection := FDBConnection.getDefaultConnection;
  FFDQueryUPDATE.Connection := FDBConnection.getDefaultConnection;
end;

procedure TLojaRepository.criarCaixa(const saldoTotal: Double;
  const idLoja: integer);
begin
  FFDQuery.SQL.Text := INSERT_CAIXA;
  FFDQuery.ParamByName('SALDOTOTAL').asFloat := saldoTotal;
  FFDQuery.ParamByName('IDLOJA').AsInteger   := idLoja;

  FFDQuery.Prepare;
  FFDQuery.ExecSQL();
end;

procedure TLojaRepository.criarCategoria(const nome: string; const idLoja: integer);
begin
  FFDQuery.SQL.Text := INSERT_CATEGORIA;
  FFDQuery.ParamByName('NOME').asString := nome;
  FFDQuery.ParamByName('IDLOJA').AsInteger   := idLoja;

  FFDQuery.Prepare;
  FFDQuery.ExecSQL();
end;

procedure TLojaRepository.criarLoja(const Nome: string; Email: string;
  const Senha: string);
begin
  FFDQuery.SQL.Text := INSERT_LOJA;
  FFDQuery.ParamByName('NOME').AsString   := Nome;
  FFDQuery.ParamByName('EMAIL').AsString  := Email;
  FFDQuery.ParamByName('SENHA').AsString  := Senha;

  FFDQuery.Prepare;
  FFDQuery.ExecSQL();
end;

procedure TLojaRepository.criarMovimento(const idCategoria: integer; const valor: double;
  const tipo, descricao: string; const data: TDate; const idCaixa: integer);
var
  saldo: double;
begin
  if  UpperCase(tipo) = 'SAIDA'  then
    saldo := (valor*-1)
  else
    saldo := (valor);

  FFDQuery.SQL.Text := INSERT_MOVIMENTO;
  FFDQuery.ParamByName('IDCATEGORIA').AsInteger := idCategoria;
  FFDQuery.ParamByName('VALOR').AsFloat       := saldo;
  FFDQuery.ParamByName('TIPO').AsString       := tipo;
  FFDQuery.ParamByName('DATA').AsDate         := data;
  FFDQuery.ParamByName('DESCRICAO').AsString  := descricao;
  FFDQuery.ParamByName('IDCAIXA').AsInteger   := idCaixa;

  FFDQuery.Prepare;
  FFDQuery.ExecSQL();

  FFDQueryUPDATE.SQL.Text := UPDATE_SALDO;
  FFDQueryUPDATE.ParamByName('NOVOSALDO').AsFloat := saldo;
  FFDQueryUPDATE.ParamByName('IDCAIXA').AsInteger := idCaixa;

  FFDQueryUPDATE.Prepare;
  FFDQueryUPDATE.ExecSQL();
end;

destructor TLojaRepository.Destroy;
begin
  FFDQuery.Free;
  FFDQueryUPDATE.Free;
  inherited;
end;

procedure TLojaRepository.resumoCaixa(const idCaixa: integer;
  out AFDQuery: TFDQuery);
begin
  AFDQuery.Connection := FDBConnection.getDefaultConnection;
  AFDQuery.SQL.Text   := RESUMO_CAIXA;

  AFDQuery.ParamByName('IDCAIXA').AsInteger := idCaixa;
  AFDQuery.Prepare;
  AFDQuery.Open;
end;

end.
