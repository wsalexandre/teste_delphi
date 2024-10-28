unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient, Datasnap.Provider, IniFiles,
  System.IOUtils, Vcl.Forms;

type
  TDm = class(TDataModule)
    FDConnection1: TFDConnection;
    qryClientes: TFDQuery;
    MySQLDriverLink1: TFDPhysMySQLDriverLink;
    qryProdutos: TFDQuery;
    qryPedidos: TFDQuery;
    qryPedidoProdutos: TFDQuery;
    FDTransaction1: TFDTransaction;
    dspPedidos: TDataSetProvider;
    cdsPedidos: TClientDataSet;
    dsPedidos: TDataSource;
    dspPedidoProdutos: TDataSetProvider;
    cdsPedidoProdutos: TClientDataSet;
    dsPedidoProdutos: TDataSource;
    cdsPedidoProdutosId: TAutoIncField;
    cdsPedidoProdutosNumeroPedido: TIntegerField;
    cdsPedidoProdutosCodigoProduto: TIntegerField;
    cdsPedidoProdutosQuantidade: TIntegerField;
    cdsPedidoProdutosValorUnitario: TBCDField;
    cdsPedidoProdutosValorTotal: TBCDField;
    cdsPedidosNumeroPedido: TAutoIncField;
    cdsPedidosDataEmissao: TDateTimeField;
    cdsPedidosCodigoCliente: TIntegerField;
    cdsPedidosValorTotal: TBCDField;
    procedure FDConnection1AfterCommit(Sender: TObject);
    procedure FDTransaction1AfterCommit(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure CarregarConfiguracoesConexao(FDConnection1: TFDConnection; FDTransaction1: TFDTransaction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDm.CarregarConfiguracoesConexao(FDConnection1: TFDConnection;
  FDTransaction1: TFDTransaction);
var
  IniFile: TIniFile;
begin

  IniFile := TIniFile.Create( (ExtractFilePath(Application.ExeName) + 'conexao.ini') );
  try
    FDConnection1.Params.Clear;

    FDConnection1.Params.Add('DriverID=' + IniFile.ReadString('Conexao', 'DriverID', 'MySQL'));
    FDConnection1.Params.Add('Server=' + IniFile.ReadString('Conexao', 'Server', 'localhost'));
    FDConnection1.Params.Add('Port=' + IniFile.ReadString('Conexao', 'Port', '3306'));
    FDConnection1.Params.Add('Database=' + IniFile.ReadString('Conexao', 'Database', 'teste_delphi'));
    FDConnection1.Params.Add('User_Name=' + IniFile.ReadString('Conexao', 'User_Name', 'root'));
    FDConnection1.Params.Add('Password=' + IniFile.ReadString('Conexao', 'Password', 'p@ssw0rd'));
    FDConnection1.Params.Add('CharacterSet=' + IniFile.ReadString('Conexao', 'CharacterSet', 'utf8'));
    FDConnection1.TxOptions.AutoCommit := IniFile.ReadBool('Conexao', 'AutoCommit', False);
    FDConnection1.Transaction := FDTransaction1;
    FDConnection1.Connected := True;
  finally
    IniFile.Free;
  end;
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  CarregarConfiguracoesConexao(FDConnection1, FDTransaction1);
end;

procedure TDm.FDConnection1AfterCommit(Sender: TObject);
begin
    if FDTransaction1.Active then try
      FDTransaction1.Commit;
    except
    end;
end;

procedure TDm.FDTransaction1AfterCommit(Sender: TObject);
begin
  try
    if (FDConnection1.intransaction) then
      FDConnection1.Commit;
    except
  end;

  if FDTransaction1.Active then try
    FDTransaction1.Commit;
  except
  end;
end;

end.
