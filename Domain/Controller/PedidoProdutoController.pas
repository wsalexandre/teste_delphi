unit PedidoProdutoController;

interface

uses
  PedidoProduto,
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  DataModule,
  FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  Datasnap.DBClient, Datasnap.Provider;

type
  TPedidoProdutoController = class(TObject)
  private
    procedure AplicarParametro(APedidoProduto: TPedidoProduto);
  public
    constructor Create;
    class function ListarPedidoProdutos(ANumeroPedido: Integer): TList<TPedidoProduto>;
    procedure SalvarPedidoProduto(APedidoProduto: TPedidoProduto);
    class procedure ExcluirPedidoProduto(AId: Integer);
    procedure CarregarPedidoProdutos(ANumeroPedido: Integer);
    procedure SalvarPedidoProdutos;
  end;

implementation

constructor TPedidoProdutoController.Create;
begin
  inherited Create;
end;

class function TPedidoProdutoController.ListarPedidoProdutos(ANumeroPedido: Integer): TList<TPedidoProduto>;
var
  PedidoProduto: TPedidoProduto;
begin
  Result := TList<TPedidoProduto>.Create;

  Dm.qryPedidoProdutos.Transaction := Dm.FDTransaction1;
  Dm.qryPedidoProdutos.SQL.Clear;
  Dm.qryPedidoProdutos.SQL.Add('SELECT pp.Id, pp.CodigoProduto, p.Descricao, pp.NumeroPedido, pp.Quantidade, pp.ValorTotal, pp.ValorUnitario ');
  Dm.qryPedidoProdutos.SQL.Add('FROM pedidos_produtos AS pp');
  Dm.qryPedidoProdutos.SQL.Add('LEFT JOIN produtos AS p ON p.Codigo=pp.CodigoProduto');
  Dm.qryPedidoProdutos.SQL.Add('WHERE NumeroPedido = :NumeroPedido');
  Dm.qryPedidoProdutos.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;

  Dm.qryPedidoProdutos.Open;
  try
    while not Dm.qryPedidoProdutos.Eof do
    begin
      PedidoProduto := TPedidoProduto.Create;
      try
        PedidoProduto.Id := Dm.qryPedidoProdutos.FieldByName('Id').AsInteger;
        PedidoProduto.NumeroPedido := Dm.qryPedidoProdutos.FieldByName('NumeroPedido').AsInteger;
        PedidoProduto.CodigoProduto := Dm.qryPedidoProdutos.FieldByName('CodigoProduto').AsInteger;
        PedidoProduto.Descricao := Dm.qryPedidoProdutos.FieldByName('Descricao').AsString;
        PedidoProduto.Quantidade := Dm.qryPedidoProdutos.FieldByName('Quantidade').AsInteger;
        PedidoProduto.ValorUnitario := Dm.qryPedidoProdutos.FieldByName('ValorUnitario').AsCurrency;
        PedidoProduto.ValorTotal := Dm.qryPedidoProdutos.FieldByName('ValorTotal').AsCurrency;
        Result.Add(PedidoProduto);
      except
        on E: Exception do
        begin
          PedidoProduto.Free;
          raise;
        end;
      end;
      Dm.qryPedidoProdutos.Next;
    end;
  finally
    Dm.qryPedidoProdutos.Close;
  end;
end;

procedure TPedidoProdutoController.SalvarPedidoProduto(APedidoProduto: TPedidoProduto);
begin
  Dm.qryPedidoProdutos.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryPedidoProdutos.Close;
  Dm.qryPedidoProdutos.SQL.Clear;
  if APedidoProduto.Id = 0 then
  begin
    Dm.qryPedidoProdutos.SQL.Text := 'INSERT INTO pedidos_produtos (NumeroPedido, CodigoProduto, ' +
                                    'Quantidade, ValorUnitario, ValorTotal) ' +
                                    'VALUES (:NumeroPedido, :CodigoProduto, :Quantidade, ' +
                                    ':ValorUnitario, :ValorTotal)';
  end
  else
  begin
    Dm.qryPedidoProdutos.SQL.Text := 'UPDATE pedidos_produtos SET NumeroPedido = :NumeroPedido, ' +
                                    'CodigoProduto = :CodigoProduto, Quantidade = :Quantidade, ' +
                                    'ValorUnitario = :ValorUnitario, ValorTotal = :ValorTotal ' +
                                    'WHERE Id = :Id';
  end;
  AplicarParametro(APedidoProduto);
  Dm.qryPedidoProdutos.ExecSQL;

  if not Dm.FDTransaction1.Active then
  begin
    Dm.FDTransaction1.StartTransaction;
    Dm.FDTransaction1.Commit;
  end;
end;

procedure TPedidoProdutoController.AplicarParametro(APedidoProduto: TPedidoProduto);
begin
  if APedidoProduto.Id <> 0 then
    Dm.qryPedidoProdutos.ParamByName('Id').AsInteger := APedidoProduto.Id;
  Dm.qryPedidoProdutos.ParamByName('NumeroPedido').AsInteger := APedidoProduto.NumeroPedido;
  Dm.qryPedidoProdutos.ParamByName('CodigoProduto').AsInteger := APedidoProduto.CodigoProduto;
  Dm.qryPedidoProdutos.ParamByName('Quantidade').AsInteger := APedidoProduto.Quantidade;
  Dm.qryPedidoProdutos.ParamByName('ValorUnitario').AsCurrency := APedidoProduto.ValorUnitario;
  Dm.qryPedidoProdutos.ParamByName('ValorTotal').AsCurrency := APedidoProduto.ValorTotal;
end;

class procedure TPedidoProdutoController.ExcluirPedidoProduto(AId: Integer);
begin
  Dm.qryPedidoProdutos.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryPedidoProdutos.Close;
  Dm.qryPedidoProdutos.SQL.Text := 'DELETE FROM pedidos_produtos WHERE Id = :Id';
  Dm.qryPedidoProdutos.ParamByName('Id').AsInteger := AId;
  Dm.qryPedidoProdutos.ExecSQL;
end;

procedure TPedidoProdutoController.CarregarPedidoProdutos(ANumeroPedido: Integer);
begin
  Dm.qryPedidoProdutos.SQL.Text := 'SELECT * FROM pedidos_produtos WHERE NumeroPedido = :NumeroPedido';
  Dm.qryPedidoProdutos.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
  Dm.qryPedidoProdutos.Open;
end;

procedure TPedidoProdutoController.SalvarPedidoProdutos;
begin
  Dm.qryPedidoProdutos.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryPedidoProdutos.ApplyUpdates;
end;

end.
