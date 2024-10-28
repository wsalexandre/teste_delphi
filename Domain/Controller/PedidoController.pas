unit PedidoController;

interface

uses
  Pedido,
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  DataModule;

type
  TPedidoController = class(TObject)
  private
    procedure AplicarParametro(APedido: TPedido);
  public
    constructor Create;
    class function CriarNovoPedido(ACodigoCliente:Integer): TPedido;
    function ListarPedidos: TList<TPedido>;
    class function ObterPedidoPorNumero(ANumeroPedido:Integer) : TPedido;
    procedure SalvarPedido(APedido: TPedido);
    procedure ExcluirPedido(ANumeroPedido: Integer);
    procedure CarregarPedidos;
    function CarregarPedidoNumero(ANumeroPedido: Integer) : TPedido;
    procedure SalvarPedidos;
    class function TotalPedido(ANumeroPedido: Integer): Currency;
  end;

implementation

constructor TPedidoController.Create;
begin
  inherited Create;
end;

class function TPedidoController.CriarNovoPedido(ACodigoCliente: Integer): TPedido;
var
  Pedido: TPedido;
begin
  Pedido := TPedido.Create;
  try
    Pedido.DataEmissao := Date;
    Pedido.CodigoCliente := ACodigoCliente;
    Pedido.ValorTotal := 0;

    if not Dm.FDTransaction1.Active then
      Dm.FDTransaction1.StartTransaction; // Start the transaction only if it’s inactive

    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.SQL.Text := 'INSERT INTO pedidos (DataEmissao, CodigoCliente, ValorTotal) ' +
                                'VALUES (:DataEmissao, :CodigoCliente, :ValorTotal)';
      Dm.qryPedidos.ParamByName('DataEmissao').AsDateTime := Pedido.DataEmissao;
      Dm.qryPedidos.ParamByName('CodigoCliente').AsInteger := Pedido.CodigoCliente;
      Dm.qryPedidos.ParamByName('ValorTotal').AsCurrency := Pedido.ValorTotal;
      Dm.qryPedidos.ExecSQL;

      Dm.qryPedidos.SQL.Text := 'SELECT NumeroPedido FROM pedidos ORDER BY NumeroPedido DESC LIMIT 1';
      Dm.qryPedidos.Open;
      if not Dm.qryPedidos.Eof then
      begin
        Pedido.NumeroPedido := Dm.qryPedidos.FieldByName('NumeroPedido').AsInteger;
      end;

      Result := Pedido;
    except
      on E: Exception do
      begin
        if Dm.FDTransaction1.Active then
          Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  except
    Pedido.Free;
    raise;
  end;
end;

function TPedidoController.ListarPedidos: TList<TPedido>;
var
  Pedido: TPedido;
begin
  Result := TList<TPedido>.Create;
  try
    Dm.FDTransaction1.StartTransaction; // Inicia a transação
    try
      Dm.qryPedidos.close;
      Dm.qryPedidos.SQL.clear;
      Dm.qryPedidos.SQL.Text := 'SELECT * FROM pedidos ORDER BY NumeroPedido';
      Dm.qryPedidos.Open;
      while not Dm.qryPedidos.Eof do
      begin
        Pedido := TPedido.Create;
        Pedido.NumeroPedido := Dm.qryPedidos.FieldByName('NumeroPedido').AsInteger;
        Pedido.DataEmissao := Dm.qryPedidos.FieldByName('DataEmissao').AsDateTime;
        Pedido.CodigoCliente := Dm.qryPedidos.FieldByName('CodigoCliente').AsInteger;
        Pedido.ValorTotal := Dm.qryPedidos.FieldByName('ValorTotal').AsCurrency;
        Result.Add(Pedido);
        Dm.qryPedidos.Next;
      end;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback; // Desfaz a transação em caso de erro
        raise; // Re-lança a exceção
      end;
    end;
  finally
    Dm.qryPedidos.Close;
  end;
end;

class function TPedidoController.ObterPedidoPorNumero(
  ANumeroPedido: Integer): TPedido;
begin
  Result := TPedido.Create;
  try
    Dm.FDTransaction1.StartTransaction;
    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.Close;
      Dm.qryPedidos.SQL.Clear;
      Dm.qryPedidos.SQL.Add('SELECT p.*, c.Nome FROM pedidos AS p LEFT JOIN clientes AS c ON p.CodigoCliente=c.Codigo');
      Dm.qryPedidos.SQL.Add('where p.NumeroPedido = :NumeroPedido');
      Dm.qryPedidos.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Dm.qryPedidos.Open;

      if not Dm.qryPedidos.Eof then
      begin
        Result.NumeroPedido := Dm.qryPedidos.FieldByName('NumeroPedido').AsInteger;
        Result.DataEmissao := Dm.qryPedidos.FieldByName('DataEmissao').AsDateTime;
        Result.CodigoCliente := Dm.qryPedidos.FieldByName('CodigoCliente').AsInteger;
        Result.NomeCliente := Dm.qryPedidos.FieldByName('Nome').AsString;
        Result.ValorTotal := Dm.qryPedidos.FieldByName('ValorTotal').AsCurrency;
      end;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
    Dm.qryPedidos.Close;
  end;
end;

procedure TPedidoController.SalvarPedido(APedido: TPedido);
begin
  try
    Dm.FDTransaction1.StartTransaction;
    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.Close;
      Dm.qryPedidos.SQL.Clear;
      if APedido.NumeroPedido = 0 then
      begin
        Dm.qryPedidos.SQL.Text := 'INSERT INTO pedidos (DataEmissao, CodigoCliente, ValorTotal) ' +
                                  'VALUES (:DataEmissao, :CodigoCliente, :ValorTotal)';
      end
      else
      begin
        Dm.qryPedidos.SQL.Text := 'UPDATE pedidos SET DataEmissao = :DataEmissao, ' +
                                  'CodigoCliente = :CodigoCliente, ValorTotal = :ValorTotal ' +
                                  'WHERE NumeroPedido = :NumeroPedido';
      end;
      AplicarParametro(APedido);
      Dm.qryPedidos.ExecSQL;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
  end;
end;

procedure TPedidoController.AplicarParametro(APedido: TPedido);
begin
  if APedido.NumeroPedido <> 0 then
    Dm.qryPedidos.ParamByName('NumeroPedido').AsInteger := APedido.NumeroPedido;
  Dm.qryPedidos.ParamByName('DataEmissao').AsDateTime := APedido.DataEmissao;
  Dm.qryPedidos.ParamByName('CodigoCliente').AsInteger := APedido.CodigoCliente;
  Dm.qryPedidos.ParamByName('ValorTotal').AsCurrency := APedido.ValorTotal;
end;

procedure TPedidoController.ExcluirPedido(ANumeroPedido: Integer);
begin
  try
    Dm.FDTransaction1.StartTransaction;
    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.Close;
      Dm.qryPedidos.SQL.Text := 'DELETE FROM pedidos WHERE NumeroPedido = :NumeroPedido';
      Dm.qryPedidos.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Dm.qryPedidos.ExecSQL;
      Dm.FDTransaction1.Commit;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
  end;
end;

function TPedidoController.CarregarPedidoNumero(
  ANumeroPedido: Integer): TPedido;
var
  Pedido : TPedido;
begin
  try
    Dm.FDTransaction1.StartTransaction;
    try
      Dm.qryPedidos.close;
      Dm.qryPedidos.SQL.Clear;
      Dm.qryPedidos.SQL.Text := 'SELECT * FROM pedidos where NumeroPedido = :NumeroPedido';
      Dm.qryPedidos.Open;

      if not Dm.qryPedidos.Eof then
      begin
        Pedido := TPedido.Create;
        Pedido.NumeroPedido := Dm.qryPedidos.FieldByName('NumeroPedido').AsInteger;
        Pedido.DataEmissao := Dm.qryPedidos.FieldByName('DataEmissao').AsDateTime;
        Pedido.CodigoCliente := Dm.qryPedidos.FieldByName('CodigoCliente').AsInteger;
        Pedido.ValorTotal :=  TotalPedido(ANumeroPedido);
        Result := Pedido;
      end;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
  end;
end;

procedure TPedidoController.CarregarPedidos;
begin
  try
    Dm.FDTransaction1.StartTransaction;
    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.SQL.Text := 'SELECT * FROM pedidos';
      Dm.qryPedidos.Open;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
  end;
end;

procedure TPedidoController.SalvarPedidos;
begin
  try
    Dm.FDTransaction1.StartTransaction;
    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.ApplyUpdates;
      Dm.FDTransaction1.Commit;
    except
      on E: Exception do
      begin
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
  end;
end;

class function TPedidoController.TotalPedido(ANumeroPedido: Integer) : Currency;
var
  TotalPedido : Currency;
begin
  try
    try
      Dm.qryPedidos.Transaction := Dm.FDTransaction1;
      Dm.qryPedidos.Close;
      Dm.qryPedidos.SQL.Clear;
      Dm.qryPedidos.SQL.Text := 'SELECT sum(valortotal) as total FROM pedidos_produtos where NumeroPedido = :NumeroPedido';
      Dm.qryPedidos.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Dm.qryPedidos.Open;

      TotalPedido := Dm.qryPedidos.FieldByName('total').AsCurrency;

      Dm.FDTransaction1.StartTransaction;
      Dm.qryPedidos.Close;
      Dm.qryPedidos.SQL.Clear;
      Dm.qryPedidos.SQL.Text := 'update pedidos set ValorTotal = :ValorTotal where NumeroPedido = :NumeroPedido';
      Dm.qryPedidos.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Dm.qryPedidos.ParamByName('ValorTotal').AsCurrency := TotalPedido;
      Dm.qryPedidos.ExecSQL;

      Result := TotalPedido;
    except
      on E: Exception do
      begin
        Result := 0;
        Dm.FDTransaction1.Rollback;
        raise;
      end;
    end;
  finally
    // ...
  end;
end;

end.
