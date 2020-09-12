unit model.entities.caixas;

interface
  uses
    Rest.Json;

  type
    TCaixa = class
    private
      FSaldoTotal: Double;
    public
      property saldoTotal: Double read FSaldoTotal write FSaldoTotal;

      constructor Create(const saldoTotal: Double);
      destructor Destroy; override;

      function ToJsonString: string;
      class function FromJsonString(const AValue: string): TCaixa;
    end;

    TRetornoCaixa = class
      private
        FSaldoTotal: double;
      public
        property SaldoTotal: double read FSaldoTotal write FSaldoTotal;

        constructor Create(const saldoTotal: double);
    end;


implementation

{ TCaixa }

constructor TCaixa.Create(const saldoTotal: Double);
begin
  FSaldoTotal := saldoTotal;
end;

destructor TCaixa.Destroy;
begin

  inherited;
end;

class function TCaixa.FromJsonString(const AValue: string): TCaixa;
begin
  result := TJson.JsonToObject<TCaixa>(AValue);
end;

function TCaixa.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

{ TRetornoCaixa }

constructor TRetornoCaixa.Create(const saldoTotal: double);
begin
  FSaldoTotal := saldoTotal;
end;

end.
