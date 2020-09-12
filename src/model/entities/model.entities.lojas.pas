unit model.entities.lojas;

interface
  uses
    JOSE.Core.JWT,
    JOSE.Core.JWK,
    JOSE.Core.Builder,
    Generics.Collections,
    Rest.Json,
    System.SysUtils;


  type
    TLoja = class
    private
      FNome: string;
      FEmail: string;
      FSenha: string;
    public
      property Nome: string read FNome write FNome;
      property Email: string read FEmail write FEmail;
      property Senha: string read FSenha write FSenha;


      function ToJsonString: string;
      class function FromJsonString(const AValue: string): TLoja;

      constructor Create(const Nome: string; const Email: string; const Senha: string);
      destructor Destroy; override;
    end;

      TRetornoLoja = class
    private
      FNome: string;
      FEmail: string;
    public
      property Nome: string read FNome write FNome;
      property Email: string read FEmail write FEmail;

      constructor Create(const Nome: string; const Email: string);
      destructor Destroy; override;
    end;

implementation


{ TLoja }

constructor TLoja.Create(const Nome: string; const Email: string; const Senha: string);
begin
  FNome := Nome;
  FEmail:= Email;
  FSenha:= Senha;
end;

destructor TLoja.Destroy;
begin
  inherited;
end;

class function TLoja.FromJsonString(const AValue: string): TLoja;
begin
  Result := TJson.JsonToObject<TLoja>(AValue);
end;

function TLoja.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

{ RetornoLoja }

constructor TRetornoLoja.Create(const Nome: string; const Email: string);
begin
  FNome := Nome;
  FEmail := Email;
end;

destructor TRetornoLoja.Destroy;
begin

  inherited;
end;

end.
