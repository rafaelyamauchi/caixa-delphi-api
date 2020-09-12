unit model.entities.movimentos;

interface

  uses
    Rest.Json,
    System.SysUtils;

  type
    TMovimento = class
    private
      FIdCategoria: integer;
      FValor: Double;
      FTipo: string;
      FDescricao: string;
      FData: TDate;
    public
      property IdCategoria: integer read FIdCategoria write FIdCategoria;
      property Valor: double read FValor write FValor;
      property Tipo: string read FTipo write FTipo;
      property Descricao: string read FDescricao write FDescricao;
      property Data: TDate read FData write FData;


      constructor Create(const idCategoria: integer; const valor: double;
        const tipo: string; descricao: string; const data: TDate);
      destructor Destroy; override;

      function ToJsonString: string;
      class function FromJsonString(const AValue: string): TMovimento;
    end;

    TRetornoMovimento = class
      private
        FIdCategoria: integer;
        FValor: Double;
        FTipo: string;
        FDescricao: string;
        FData: TDate;
      public
        property IdCategoria: integer read FIdCategoria write FIdCategoria;
        property Valor: double read FValor write FValor;
        property Tipo: string read FTipo write FTipo;
        property Descricao: string read FDescricao write FDescricao;
        property Data: TDate read FData write FData;


        constructor Create(const idCategoria: integer; const valor: double;
          const tipo: string; descricao: string; const data: TDate);
    end;

implementation

{ TMovimento }

constructor TMovimento.Create(const idCategoria: integer; const valor: double;
  const tipo: string; descricao: string; const data: TDate);
begin
  FIdCategoria := idCategoria;
  FValor := valor;
  FTipo := tipo;
  FDescricao := descricao;
  FData := data;
end;

destructor TMovimento.Destroy;
begin

  inherited;
end;

class function TMovimento.FromJsonString(const AValue: string): TMovimento;
begin
  result := TJson.JsonToObject<TMovimento>(AValue);
end;

function TMovimento.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

{ TRetornoMovimento }

constructor TRetornoMovimento.Create(const idCategoria: integer;
  const valor: double; const tipo: string; descricao: string; const data: TDate);
begin
  FIdCategoria := idCategoria;
  FValor := valor;
  FTipo := tipo;
  FDescricao := descricao;
  FData := data;
end;

end.
