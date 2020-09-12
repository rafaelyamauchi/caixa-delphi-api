unit model.connectionIntf;

interface
  uses
    Data.SQLExpr,
    FireDAC.Comp.Client;

  type
    IDBConnection = interface
      ['{6FC40B2E-4185-409E-9EC1-FE4F86E8C5D0}']
      function getDefaultConnection: TFDConnection;
    end;

implementation

end.
