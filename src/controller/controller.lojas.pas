unit controller.lojas;

interface

  uses
    Horse,
    Horse.Commons,
    JOSE.Core.JWT,
    JOSE.Core.JWK,
    JOSE.Core.Builder,
    System.Classes,
    System.JSON,
    Web.HTTPApp,
    System.SysUtils,
    services.lojasIntf,
    services.lojasImpl,
    model.entities.lojas;

    procedure criarLoja(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure criarLoja(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Loja: TLoja;
  RetornoLoja: TRetornoLoja;
  Resposta: TJSONObject;
begin
  Loja  := TLoja.FromJsonString(Req.Body);
  if (Loja.Nome = EmptyStr) or (Loja.email = EmptyStr) or (Loja.senha = EmptyStr) then
  begin
    Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'Nome, Email e Senha são campos obrigatórios')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  with TServiceLoja.Create do
  begin
    if (consultarIDLoja(Loja.email) = 0) then
    begin
      try
        try
          RetornoLoja := criarLoja(Loja.Nome, Loja.Email, Loja.Senha);
          Resposta := TJSONObject.Create;
          Resposta.AddPair('nome', RetornoLoja.Nome);
          Resposta.AddPair('email', RetornoLoja.Email);
          Res.Status(THTTPStatus.Created).Send(Resposta);
        finally
          RetornoLoja.Free;
        end;
      finally
        Loja.Free;
      end;

      try
        Next;
      except
        raise;
      end;
    end else
    begin
      Res.Send(TJSONObject.Create(
        TJSONPair.Create('mensagem', 'Loja já cadastrada')))
          .Status(THTTPStatus.BadRequest);
      raise EHorseCallbackInterrupted.Create;
    end;
  end;
end;

end.
