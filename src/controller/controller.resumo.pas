unit controller.resumo;

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

    procedure consultarResumo(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure consultarResumo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Resumo: TJSONObject;
  email: string;
  idLoja: integer;
  idCaixa: integer;
begin
  email := Req.Session<TSessao>.sub;
  with TServiceLoja.Create do
  begin
    idLoja := consultarIDLoja(email);
    if (idLoja > 0) then
    begin
      idCaixa := consultarIDCaixa(idLoja);
      if (idCaixa > 0) then
      begin
        Resumo := resumoCaixa(idCaixa);
        if Assigned(Resumo) then
        begin
          Res.Status(THTTPStatus.OK).Send(resumo);
        end else
        begin
          Res.Send(TJSONObject.Create(
          TJSONPair.Create('mensagem', 'Nenhum movimento encontrado')))
            .Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;
      end else
      begin
        begin
          Res.Send(TJSONObject.Create(
          TJSONPair.Create('mensagem', 'Caixa não cadastrado')))
            .Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;
      end;
    end else
    begin
      Res.Send(TJSONObject.Create(
        TJSONPair.Create('mensagem', 'Loja não cadatrada')))
          .Status(THTTPStatus.BadRequest);
      raise EHorseCallbackInterrupted.Create;
    end;
  end
end;

end.
