unit controller.caixas;

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
    model.entities.sessao;

    procedure criarCaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure criarCaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Caixa: TCaixa;
  RetornoCaixa: TRetornoCaixa;
  Resposta: TJSONObject;
  email: string;
  idLoja: integer;
  idCaixa: integer;
begin
  email := Req.Session<TSessao>.sub;
  Caixa := TCaixa.FromJsonString(Req.Body);
  if (Caixa.saldoTotal <= 0) then
  begin
    Res.Send(
      TJSONObject.Create(
        TJSONPair.Create('message', 'saldoTotal é um campo obrigatório')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  with TServiceLoja.Create do
  begin
    idLoja := consultarIDLoja(email);
    if (idLoja > 0) then
    begin
      idCaixa := consultarIDCaixa(idLoja);
      if (idCaixa = 0) then
      begin
        try
          try
            RetornoCaixa := criarCaixa(Caixa.saldoTotal, idLoja);
            Resposta := TJSONObject.Create;
            Resposta.AddPair('saldoTotal',
              FloattoStr(RetornoCaixa.saldoTotal));
            Res.Status(THTTPStatus.Created).Send(Resposta);
          finally
            RetornoCaixa.Free;
          end;

          try
            Next;
          except
            raise;
          end;

        finally
          Caixa.Free;
        end;
      end else
      begin
        Res.Send(TJSONObject.Create(
        TJSONPair.Create('mensagem', 'Caixa já cadastrado')))
          .Status(THTTPStatus.BadRequest);
        raise EHorseCallbackInterrupted.Create;
      end;
    end else
    begin
      Res.Send(TJSONObject.Create(
        TJSONPair.Create('mensagem', 'Loja não cadatrada')))
          .Status(THTTPStatus.BadRequest);
      raise EHorseCallbackInterrupted.Create;
    end;
  end;
end;

end.
