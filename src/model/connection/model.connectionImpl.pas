unit model.connectionImpl;

interface

  uses
    System.SysUtils,
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option,
    FireDAC.Stan.Error,
    FireDAC.UI.Intf,
    FireDAC.Phys.Intf,
    FireDAC.Stan.Def,
    FireDAC.Stan.Pool,
    FireDAC.Stan.Async,
    FireDAC.Phys,
    FireDAC.VCLUI.Wait,
    FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteDef,
    FireDAC.Phys.SQLite,
    FireDAC.Comp.UI,
    FireDAC.Comp.Client,
    FireDAC.Comp.ScriptCommands,
    Data.DB,
    model.connectionIntf;

  type
    TDBConnection = class(TInterfacedObject, IDBConnection)
  private
    FDConnection: TFDConnection;
  public
    function getDefaultConnection: TFDConnection;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

{ TDBConnection }

constructor TDBConnection.Create;
var
  databaseFile: string;
begin
  databaseFile := GetCurrentDir + PathDelim + '..'
    + PathDelim + '..' + PathDelim + 'db' + PathDelim + 'caixa.s3db';
  FDConnection := TFDConnection.Create(nil);
  FDConnection.LoginPrompt := False;
  FDConnection.DriverName := 'SQLITE';
  FDConnection.Params.Values['DriverID'] := 'SQLite';
  FDConnection.Params.Values['Database'] := ExpandFileName(databaseFile);
  FDConnection.Params.Values['OpenMode'] := 'CreateUTF8';
  FDConnection.Params.Values['LockingMode'] := 'Normal';
  FDConnection.Params.Values['Synchronous'] := 'Full';
  FDConnection.Connected := True;
  FDConnection.Open();
end;

destructor TDBConnection.Destroy;
begin
  FDConnection.Close;
  FDConnection.Free;
  inherited;
end;

function TDBConnection.getDefaultConnection: TFDConnection;
begin
  result := FDConnection;
end;

end.
