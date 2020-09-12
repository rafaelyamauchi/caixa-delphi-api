program Server;

{$APPTYPE CONSOLE}

{$R *.res}



{$R *.dres}

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.Logger,
  JOSE.Core.JWT,
  JOSE.Core.JWK,
  JOSE.Core.Builder,
  System.Classes,
  System.Types,
  System.SysUtils,
  System.Json,
  Rest.Json,
  model.connectionIntf in 'src\model\connection\model.connectionIntf.pas',
  model.connectionImpl in 'src\model\connection\model.connectionImpl.pas',
  model.entities.lojas in 'src\model\entities\model.entities.lojas.pas',
  model.entities.caixas in 'src\model\entities\model.entities.caixas.pas',
  model.entities.categorias in 'src\model\entities\model.entities.categorias.pas',
  model.entities.movimentos in 'src\model\entities\model.entities.movimentos.pas',
  model.entities.sessao in 'src\model\entities\model.entities.sessao.pas',
  repository.lojasImpl in 'src\repository\repository.lojasImpl.pas',
  repository.lojasIntf in 'src\repository\repository.lojasIntf.pas',
  services.lojasIntf in 'src\services\services.lojasIntf.pas',
  services.lojasImpl in 'src\services\services.lojasImpl.pas',
  middleware.authorization in 'src\middleware\middleware.authorization.pas',
  controller.authorization in 'src\controller\controller.authorization.pas',
  controller.lojas in 'src\controller\controller.lojas.pas',
  controller.caixas in 'src\controller\controller.caixas.pas',
  controller.categorias in 'src\controller\controller.categorias.pas',
  controller.movimentos in 'src\controller\controller.movimentos.pas',
  controller.resumo in 'src\controller\controller.resumo.pas';

procedure createFolder();
var
  destname: string;
begin
  destname := GetCurrentDir + PathDelim + '..' + PathDelim + '..' + PathDelim + 'db';
  if (not DirectoryExists(ExpandFileName(destname))) then
    CreateDir(ExpandFileName(destname));

  if (not FileExists(ExpandFileName(destname) + PathDelim + 'caixa.s3db')) then
    FileCreate(ExpandFileName(destname) + PathDelim + 'caixa.s3db');
end;

procedure initDB();
var
  oSQL: TStringList;
  oSQLResource: TResourceStream;
begin
  createFolder();
  oSQLResource := TResourceStream.Create(HInstance, 'DB', RT_RCDATA);
  try
    try
      with TDBConnection.Create do
      try
        oSQL := TStringList.Create;
        try
          oSQL.LoadFromStream(oSQLResource);
          getDefaultConnection.ExecSQL(oSQL.Text);
        finally
          oSQL.Free;
        end;
      finally
        Free;
      end;
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    oSQLResource.Free;
  end;
end;

begin
  initDB();
  try
    ReportMemoryLeaksOnShutdown := true;
    THorse
      .Use(Jhonson)
      .Use(HandleException)
      .Use(THorseLogger.New());

    THorse.Post('/api/authorization', auth);
    THorse.Post('/api/lojas', criarLoja);
    THorse.Post('/api/caixas', authorization, criarCaixa);
    THorse.Post('/api/categorias', authorization, criarCategoria);
    THorse.Post('/api/caixa/movimentos', authorization, criarMovimento);
    THorse.Get('/api/caixas', authorization, consultarResumo);

    THorse.Listen(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
