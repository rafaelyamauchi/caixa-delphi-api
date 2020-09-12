unit middleware.authorization;

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
    Rest.Json,
    System.SysUtils,
    model.entities.sessao;

  procedure authorization(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure authorization(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Token: string;
  LKey: TJWK;
  LToken: TJWT;
  LSession: TSessao;
begin
  Token := Req.Headers['x-auth-token'];

  if Token.Trim.IsEmpty then
  begin
    Res.Status(THTTPStatus.Unauthorized)
      .Send(TJSONObject.Create(TJSONPair.Create('message',
        'Acesso negado token não informado')));
    raise EHorseCallbackInterrupted.Create;
  end;

  LKey := TJWK.Create('jwtPrivateKey');
  LToken := TJOSE.Verify(LKey, token);
  if Assigned(LToken) then
  begin
    try
      if LToken.Verified then
      begin
        try
          LSession := TSessao.Create;
          TJson.JsonToObject(LSession, LToken.Claims.JSON);
          THorseHackRequest(Req).SetSession(LSession);
        except
          on E: exception do
          begin
            if E.InheritsFrom(EHorseCallbackInterrupted) then
            raise EHorseCallbackInterrupted(E);
            Res.Status(THTTPStatus.Unauthorized)
              .Send(TJSONObject.Create(TJSONPair.Create('message',
                'Acesso negado')));
            raise EHorseCallbackInterrupted.Create;
          end;
        end;
      end else
      begin
        Res.Status(THTTPStatus.BadRequest)
          .Send(TJSONObject.Create(TJSONPair.Create('message',
          'Token inválido')));
        raise EHorseCallbackInterrupted.Create;
      end;

      try
        Next();
      finally
        if Assigned(LSession) then
          LSession.Free;
      end;

    finally
      LToken.Free;
    end;
  end;

end;

end.
