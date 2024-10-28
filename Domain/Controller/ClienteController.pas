unit ClienteController;

interface

uses
  Cliente,
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  DataModule;

type
  TClienteController = class(TObject)
  private
    procedure AplicarParametro(ACliente: TCliente);
  public
    constructor Create;
    function ListarClientes: TList<TCliente>;
    class function ObterClientePorCodigo(ACodigo: Integer): TCliente;
    procedure SalvarCliente(ACliente: TCliente);
    procedure ExcluirCliente(ACodigo: Integer);
    procedure CarregarClientes;
    procedure SalvarClientes;
  end;

implementation

constructor TClienteController.Create;
begin
  inherited Create;
end;

function TClienteController.ListarClientes: TList<TCliente>;
var
  Cliente: TCliente;
begin
  Result := TList<TCliente>.Create;

  Dm.qryClientes.Close;
  Dm.qryClientes.SQL.Clear;
  Dm.qryClientes.SQL.Text := 'SELECT * FROM clientes order by Nome';
  Dm.qryClientes.Open;

  try
    while not Dm.qryClientes.Eof do
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := Dm.qryClientes.FieldByName('Codigo').AsInteger;
      Cliente.Nome := Dm.qryClientes.FieldByName('Nome').AsString;
      Cliente.Cidade := Dm.qryClientes.FieldByName('Cidade').AsString;
      Cliente.UF := Dm.qryClientes.FieldByName('UF').AsString;
      Result.Add(Cliente);
      Dm.qryClientes.Next;
    end;
  finally
    Dm.qryClientes.Close;
  end;
end;

class function TClienteController.ObterClientePorCodigo(ACodigo: Integer): TCliente;
var
  Cliente: TCliente;
begin
  Result := nil;
  try
    try
      Dm.qryClientes.SQL.Text := 'SELECT * FROM clientes WHERE Codigo = :Codigo';
      Dm.qryClientes.ParamByName('Codigo').AsInteger := ACodigo;
      Dm.qryClientes.Open;
      if not Dm.qryClientes.Eof then
      begin
        Cliente := TCliente.Create;
        Cliente.Codigo := Dm.qryClientes.FieldByName('Codigo').AsInteger;
        Cliente.Nome := Dm.qryClientes.FieldByName('Nome').AsString;
        Cliente.Cidade := Dm.qryClientes.FieldByName('Cidade').AsString;
        Cliente.UF := Dm.qryClientes.FieldByName('UF').AsString;
        Result := Cliente;
      end;
    except
      on E: Exception do
      begin
        // Trate o erro aqui...
        raise;
      end;
    end;
  finally
    Dm.qryClientes.Close;
  end;
end;

procedure TClienteController.SalvarCliente(ACliente: TCliente);
begin
  Dm.qryClientes.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryClientes.Close;
  Dm.qryClientes.SQL.Clear;
  if ACliente.Codigo = 0 then
  begin
    Dm.qryClientes.SQL.Text := 'INSERT INTO clientes (Nome, Cidade, UF) ' +
                              'VALUES (:Nome, :Cidade, :UF)';
  end
  else
  begin
    Dm.qryClientes.SQL.Text := 'UPDATE clientes SET Nome = :Nome, ' +
                              'Cidade = :Cidade, UF = :UF ' +
                              'WHERE Codigo = :Codigo';
  end;
  AplicarParametro(ACliente);
  Dm.qryClientes.ExecSQL;
end;

procedure TClienteController.AplicarParametro(ACliente: TCliente);
begin
  if ACliente.Codigo <> 0 then
    Dm.qryClientes.ParamByName('Codigo').AsInteger := ACliente.Codigo;
  Dm.qryClientes.ParamByName('Nome').AsString := ACliente.Nome;
  Dm.qryClientes.ParamByName('Cidade').AsString := ACliente.Cidade;
  Dm.qryClientes.ParamByName('UF').AsString := ACliente.UF;
end;

procedure TClienteController.ExcluirCliente(ACodigo: Integer);
begin
  Dm.qryClientes.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryClientes.Close;
  Dm.qryClientes.SQL.Text := 'DELETE FROM clientes WHERE Codigo = :Codigo';
  Dm.qryClientes.ParamByName('Codigo').AsInteger := ACodigo;
  Dm.qryClientes.ExecSQL;
end;

procedure TClienteController.CarregarClientes;
begin
  Dm.qryClientes.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryClientes.SQL.Text := 'SELECT * FROM clientes';
  Dm.qryClientes.Open;
end;

procedure TClienteController.SalvarClientes;
begin
  Dm.qryClientes.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryClientes.ApplyUpdates;
end;

end.
