unit controller.movimentos;

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
    model.entities.movimentos,
    model.entities.sessao;

    procedure criarMovimento(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure criarMovimento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Movimento: TMovimento;
  RetornoMovimento: TRetornoMovimento;
  Resposta: TJSONObject;
  email: string;
  idLoja: integer;
  idCaixa: integer;
  idCategoria: integer;
begin
  email := Req.Session<TSessao>.sub;
  Movimento := TMovimento.FromJsonString(Req.Body);
  if (Movimento.IdCategoria = 0) then
  begin
    Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'Id da categoria é um campo obrigatório')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  if (Movimento.Valor = 0) then
  begin
    Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'Valor é um campo obrigatório')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  if ((UpperCase(Movimento.Tipo) <> 'ENTRADA') and (UpperCase(Movimento.Tipo) <> 'SAIDA'))
  or (UpperCase(Movimento.Tipo) = EmptyStr) then
  begin
    Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'Tipo informado inválido')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  if (Movimento.Descricao = EmptyStr) then
  begin
    Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'descrição é um campo obrigatório')))
          .Status(THTTPStatus.BadRequest);
    raise EHorseCallbackInterrupted.Create;
  end;

  with TServiceLoja.Create do
  begin
    idLoja := consultarIDLoja(email);
    if (idLoja > 0) then
    begin
      idCaixa := consultarIDCaixa(idLoja);
      if (idCaixa > 0) then
      begin
        idCategoria := consultarIDCategoria(Movimento.IdCategoria);
        if (idCategoria > 0) then
        begin
          try
            try
              RetornoMovimento := criarMovimentos(Movimento.IdCategoria,
                Movimento.Valor, Movimento.Tipo, Movimento.Descricao,
                Movimento.Data, idCaixa);
              Resposta := TJSONObject.Create;
              Resposta.AddPair('idCategoria',
                IntToStr(RetornoMovimento.IdCategoria));
              Resposta.AddPair('valor',
                FloatToStr(RetornoMovimento.Valor));
              Resposta.AddPair('tipo', RetornoMovimento.Tipo);
              Resposta.AddPair('descricao', RetornoMovimento.Descricao);
              Resposta.AddPair('data', DateToStr(RetornoMovimento.Data));
              Res.Status(THTTPStatus.Created).Send(Resposta);
            finally
              RetornoMovimento.Free;
            end;

            try
              Next;
            except
              raise;
            end;

          finally
            Movimento.Free;
          end;
        end else
        begin
          Res.Send(TJSONObject.Create(
            TJSONPair.Create('mensagem', 'Categoria não cadastrada')))
              .Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;
      end else
      begin
        Res.Send(TJSONObject.Create(
        TJSONPair.Create('mensagem', 'Caixa não cadastrado')))
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
