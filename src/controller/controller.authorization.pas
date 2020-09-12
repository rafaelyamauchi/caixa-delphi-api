unit controller.authorization;

interface

  uses
    Horse,
    Horse.Commons,
    JOSE.Core.JWT,
    JOSE.Core.JWK,
    JOSE.Core.Builder,
    System.Classes,
    System.SysUtils,
    System.JSON,
    Web.HTTPApp,
    services.lojasIntf,
    services.lojasImpl,
    model.entities.lojas;

procedure auth(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure auth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LToken: TJWT;
  Loja: TLoja;
begin
  Loja  := TLoja.FromJsonString(Req.Body);
  try
    if (Loja.email = EmptyStr) or (Loja.senha = EmptyStr) then
    begin
      Res.Send(TJSONObject.Create(
        TJSONPair.Create('message', 'Email e Senha são campos obrigatórios')))
          .Status(THTTPStatus.BadRequest);
      raise EHorseCallbackInterrupted.Create;
    end;

    with TServiceLoja.Create do
    begin
      if consultarLoja(Loja.email, Loja.senha) then
      begin
        LToken := TJWT.Create;
        try
          try
            LToken.Claims.Issuer := 'Horse';
            LToken.Claims.Subject := Loja.email;
            Res.Send(TJSONObject.Create(TJSONPair.Create('token',
            TJOSE.SHA256CompactToken('jwtPrivateKey', LToken))));
          except
            on E: exception do
            begin
              if E.InheritsFrom(EHorseCallbackInterrupted) then
              raise EHorseCallbackInterrupted(E);
              Res.Send('Server error').Status(THTTPStatus.InternalServerError);
            raise EHorseCallbackInterrupted.Create;
            end;
          end;

          try
            Next;
          except
            raise;
          end;

        finally
          LToken.Free;
        end;
      end else
      begin
        Res.Send(TJSONObject.Create(
          TJSONPair.Create('message', 'Email ou Senha inválidos')))
            .Status(THTTPStatus.Unauthorized);
        raise EHorseCallbackInterrupted.Create;
      end;
    end;
  finally
    Loja.Free;
  end;
end;

end.
