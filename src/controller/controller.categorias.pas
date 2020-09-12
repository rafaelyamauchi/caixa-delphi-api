unit controller.categorias;

interface
  uses
    Horse,
    Horse.Commons,

    JOSE.Core.JWT,
    JOSE.Core.JWK,
    JOSE.Core.Builder,

    System.SysUtils,
    System.Classes,
    System.JSON,

    Web.HTTPApp,

    services.lojasIntf,
    services.lojasImpl,
    model.entities.lojas,
    model.entities.caixas,
    model.entities.categorias,
    model.entities.sessao;

    procedure criarCategoria(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure criarCategoria(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Categoria: TCategoria;
  RetornoCategoria: TRetornoCategoria;
  Resposta: TJSONObject;
  email: string;
  idLoja: integer;
begin
  email := Req.Session<TSessao>.sub;
  Categoria := TCategoria.FromJsonString(Req.Body);
  if (Categoria.Nome = EmptyStr) then
  begin
    Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'Nome da Categoria é um campo obrigatório')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  with TServiceLoja.Create do
  begin
    idLoja := consultarIDLoja(email);
    if (idLoja > 0) then
    begin
      try
        try
          RetornoCategoria := criarCategoria(Categoria.Nome, idLoja);
          Resposta := TJSONObject.Create;
          Resposta.AddPair('nome', RetornoCategoria.Nome);
          Res.Status(THTTPStatus.Created).Send(Resposta);
        finally
          RetornoCategoria.Free;
        end;

        try
          Next;
        except
          raise;
        end;

      finally
        Categoria.Free;
      end;
    end else
    begin
      Res.Send(TJSONObject.Create(
        TJSONPair.Create('mensagem', 'Loja não cadastrada cadastrada')))
          .Status(THTTPStatus.BadRequest);
      raise EHorseCallbackInterrupted.Create;
    end;
  end;
end;

end.
