unit ProdutoController;

interface

uses
  Produto,
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  DataModule;

type
  TProdutoController = class(TObject)
  private
    procedure AplicarParametro(AProduto: TProduto);
  public
    constructor Create;
    function ListarProdutos: TList<TProduto>;
    class function ObterProdutoPorCodigo(ACodigo: Integer): TProduto;
    procedure SalvarProduto(AProduto: TProduto);
    procedure ExcluirProduto(ACodigo: Integer);
    procedure CarregarProdutos;
    procedure SalvarProdutos;
  end;

implementation

constructor TProdutoController.Create;
begin
  inherited Create;
end;

function TProdutoController.ListarProdutos: TList<TProduto>;
var
  Produto: TProduto;
begin
  Result := TList<TProduto>.Create;
  Dm.qryProdutos.Close;
  Dm.qryProdutos.SQL.Clear;
  Dm.qryProdutos.SQL.Text := 'SELECT * FROM produtos order by codigo';
  Dm.qryProdutos.Open;
  try
    while not Dm.qryProdutos.Eof do
    begin
      Produto := TProduto.Create;
      Produto.Codigo := Dm.qryProdutos.FieldByName('Codigo').AsInteger;
      Produto.Descricao := Dm.qryProdutos.FieldByName('Descricao').AsString;
      Produto.PrecoVenda := Dm.qryProdutos.FieldByName('PrecoVenda').AsCurrency;
      Result.Add(Produto);
      Dm.qryProdutos.Next;
    end;
  finally
    Dm.qryProdutos.Close;
  end;
end;

class function TProdutoController.ObterProdutoPorCodigo(ACodigo: Integer): TProduto;
var
  Produto: TProduto;
begin
  Result := nil;
  try
    try
      Dm.qryProdutos.SQL.Clear;
      Dm.qryProdutos.SQL.Text := 'SELECT * FROM produtos WHERE Codigo = :Codigo';
      Dm.qryProdutos.ParamByName('Codigo').AsInteger := ACodigo;
      Dm.qryProdutos.Open;
      if not Dm.qryProdutos.Eof then
      begin
        Produto := TProduto.Create;
        Produto.Codigo := Dm.qryProdutos.FieldByName('Codigo').AsInteger;
        Produto.Descricao := Dm.qryProdutos.FieldByName('Descricao').AsString;
        Produto.PrecoVenda := Dm.qryProdutos.FieldByName('PrecoVenda').AsCurrency;
        Result := Produto;
      end;
    except
      on E: Exception do
      begin
        //
        raise;
      end;
    end;
  finally
    Dm.qryProdutos.Close;
  end;
end;

procedure TProdutoController.SalvarProduto(AProduto: TProduto);
begin
  Dm.qryProdutos.Transaction := Dm.FDTransaction1;
  Dm.qryProdutos.Close;
  Dm.qryProdutos.SQL.Clear;
  if AProduto.Codigo = 0 then
  begin
    Dm.qryProdutos.SQL.Text := 'INSERT INTO produtos (Descricao, PrecoVenda) ' +
                              'VALUES (:Descricao, :PrecoVenda)';
  end
  else
  begin
    Dm.qryProdutos.SQL.Text := 'UPDATE produtos SET Descricao = :Descricao, ' +
                              'PrecoVenda = :PrecoVenda ' +
                              'WHERE Codigo = :Codigo';
  end;
  AplicarParametro(AProduto);
  Dm.qryProdutos.ExecSQL;
end;

procedure TProdutoController.AplicarParametro(AProduto: TProduto);
begin
  if AProduto.Codigo <> 0 then
    Dm.qryProdutos.ParamByName('Codigo').AsInteger := AProduto.Codigo;
  Dm.qryProdutos.ParamByName('Descricao').AsString := AProduto.Descricao;
  Dm.qryProdutos.ParamByName('PrecoVenda').AsCurrency := AProduto.PrecoVenda;
end;

procedure TProdutoController.ExcluirProduto(ACodigo: Integer);
begin
  Dm.qryProdutos.Transaction := Dm.FDTransaction1; // Define a transação
  Dm.qryProdutos.Close;
  Dm.qryProdutos.SQL.Text := 'DELETE FROM produtos WHERE Codigo = :Codigo';
  Dm.qryProdutos.ParamByName('Codigo').AsInteger := ACodigo;
  Dm.qryProdutos.ExecSQL;
end;

procedure TProdutoController.CarregarProdutos;
begin
  Dm.qryProdutos.SQL.Text := 'SELECT * FROM produtos';
  Dm.qryProdutos.Open;
end;

procedure TProdutoController.SalvarProdutos;
begin
  //Dm.qryProdutos.ApplyUpdates;
end;

end.
