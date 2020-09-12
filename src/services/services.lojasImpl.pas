unit services.lojasImpl;

interface

   uses
    Data.DB,
    FireDAC.Comp.Client,
    BCrypt,
    BCrypt.Types,
    model.entities.lojas,
    model.entities.caixas,
    model.entities.categorias,
    model.entities.movimentos,
    repository.lojasIntf,
    repository.lojasImpl,
    services.lojasIntf,
    System.SysUtils,
    System.Json;


  type
    TServiceLoja = class(TInterfacedObject, ILojaService)

  private
    FLojaRepository: ILojaRepository;

  public
    function consultarLoja(const Email: string; const Senha: string): Boolean;
    function consultarIDLoja(const Email: string): integer;
    function consultarIDCaixa(const id: integer): integer;
    function consultarIDCategoria(const id: integer): integer;

    function criarLoja(const Nome: string; const Email: string; const Senha: string): TRetornoLoja;
    function criarCaixa(const saldoTotal: double; const idLoja: integer): TRetornoCaixa;
    function criarCategoria(const Nome: string; const idLoja: integer): TRetornoCategoria;
    function criarMovimentos(const idCategoria: integer; const valor: double;
      const tipo: string; const descricao: string; const data: TDate; const idCaixa: integer): TRetornoMovimento;

    function resumoCaixa(const idCaixa: integer): TJSONObject;

    function gerarHashSenha(const senha: string): string;
    function compararSenha(const senha: string; const hashed: string): Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TServiceLoja }

function TServiceLoja.consultarIDCategoria(const id: integer): integer;
var
  idCategoria: integer;
begin
  idCategoria := FLojaRepository.consultarIDCategoria(id);
  Result := idCategoria;
end;

function TServiceLoja.consultarIDLoja(const Email: string): integer;
var
  idLoja: integer;
begin
  idLoja := FLojaRepository.consultarIDLoja(Email);
  Result := idLoja;
end;

function TServiceLoja.compararSenha(const senha, hashed: string): Boolean;
begin
  Result := TBCrypt.CompareHash(senha, hashed);
end;

function TServiceLoja.consultarIDCaixa(const id: integer): integer;
var
  idCaixa: integer;
begin
  idCaixa := FLojaRepository.consultarIDCaixa(id);
  Result := idCaixa;
end;

function TServiceLoja.consultarLoja(const Email, Senha: string): Boolean;
var
  hashedSenha: string;
  LVerify: Boolean;
begin
  hashedSenha := FLojaRepository.consultarLoja(Email, Senha);
  LVerify     := compararSenha(Senha, hashedSenha);
  Result      := LVerify;
end;

constructor TServiceLoja.Create;
begin
  FLojaRepository := TLojaRepository.Create;
end;

function TServiceLoja.criarCaixa(const saldoTotal: double; const idLoja: integer): TRetornoCaixa;
begin
  FLojaRepository.criarCaixa(saldoTotal, idLoja);
  Result := TRetornoCaixa.Create(saldoTotal);
end;

function TServiceLoja.criarCategoria(const Nome: string; const idLoja: integer): TRetornoCategoria;
begin
  FLojaRepository.criarCategoria(Nome, idLoja);
  Result := TRetornoCategoria.Create(Nome);
end;

function TServiceLoja.criarLoja(const Nome: string; const Email: string; const Senha: string): TRetornoLoja;
var
  encryptarSenha: string;
begin
  encryptarSenha := gerarHashSenha(Senha);
  FLojaRepository.criarLoja(Nome, Email, encryptarSenha);
  Result := TRetornoLoja.Create(Nome, Email);
end;

function TServiceLoja.criarMovimentos(const idCategoria: integer; const valor: double;
const tipo: string; const descricao: string; const data: TDate; const idCaixa: integer): TRetornoMovimento;
begin
  FLojaRepository.criarMovimento(idCategoria, valor, tipo, descricao, now, idCaixa);
  Result := TRetornoMovimento.Create(idCategoria, valor, tipo, descricao, now);
end;

destructor TServiceLoja.Destroy;
begin

  inherited;
end;

function TServiceLoja.gerarHashSenha(const senha: string): string;
begin
  Result := TBCrypt.GenerateHash(senha);
end;

function TServiceLoja.resumoCaixa(const idCaixa: integer): TJSONObject;
var
  resumo: TJSONObject;
  movimento: TJSONObject;
  categoria: TJSONObject;
  movimentacoes: TJSONArray;
  ResumoQuery: TFDQuery;
begin
  ResumoQuery := TFDQuery.Create(nil);
  FLojaRepository.resumoCaixa(idCaixa, ResumoQuery);
  if (ResumoQuery.IsEmpty) then
    Result := nil
  else
  begin
    resumo := TJSONObject.Create;
    ResumoQuery.First;
    resumo.AddPair('saldoTotal',FloatToStr(
      ResumoQuery.FieldByName('SALDOTOTAL').AsFloat));
    movimentacoes := TJSONArray.Create;
    while not (ResumoQuery.Eof) do
    begin
      movimento := TJSONObject.Create;
      movimento.AddPair('data', DateToStr(ResumoQuery.FieldByName('data').AsDateTime));

      categoria := TJSONObject.Create;
      categoria.AddPair('id', IntToStr(ResumoQuery.FieldByName('categoriaid').AsInteger));
      categoria.AddPair('nome', ResumoQuery.FieldByName('nome').AsString);

      movimento.AddPair('categoria', categoria);
      movimento.AddPair('id', IntToStr(ResumoQuery.FieldByName('movimentoid').AsInteger));
      movimento.AddPair('tipo', ResumoQuery.FieldByName('tipo').AsString);
      movimento.AddPair('valor', FloatToStr(ResumoQuery.FieldByName('valor').AsFloat));
      movimento.AddPair('tipo', ResumoQuery.FieldByName('descricao').AsString);
      movimentacoes.Add(movimento);
      ResumoQuery.Next;
    end;
    resumo.AddPair('movimentacoes', movimentacoes);
    Result := resumo;
  end;
end;

end.
