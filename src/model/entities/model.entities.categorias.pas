unit model.entities.categorias;

interface

  uses
    Rest.Json;

  type
    TCategoria = class
    private
      FNome: String;
    public
      property Nome: string read FNome write FNome;

      constructor Create(const Nome: string);
      destructor Destroy; override;

      function ToJsonString: string;
      class function FromJsonString(const AValue: string): TCategoria;
    end;

    TRetornoCategoria = class
      private
        FNome: string;
      public
        property Nome: string read FNome write FNome;

        constructor Create(const Nome: string);
    end;

implementation

{ TCategoria }

constructor TCategoria.Create(const Nome: string);
begin
  FNome := Nome;
end;

destructor TCategoria.Destroy;
begin

  inherited;
end;

class function TCategoria.FromJsonString(const AValue: string): TCategoria;
begin
  result := TJson.JsonToObject<TCategoria>(AValue);
end;

function TCategoria.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

{ TRetornoCategoria }

constructor TRetornoCategoria.Create(const Nome: string);
begin
  FNome := Nome;
end;

end.
