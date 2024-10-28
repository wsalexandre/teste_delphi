unit ViewGenericGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Cliente, Produto, ClienteController, ProdutoController,
  PedidoController, Pedido,
  System.Generics.Collections,
  Common;

type
  TViewGenericSearch_Form = class(TForm)
    StringGrid1: TStringGrid;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancelar: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FController: TObject;
    FTipo: (ttCliente, ttProduto, ttPedido);
    procedure CarregarClientes;
    procedure CarregarProdutos;
    procedure CarregaPedidos;
    function ObterCodigoSelecionado: Integer;
  public
    constructor Create(AClienteController: TClienteController); overload;
    constructor Create(AProdutoController: TProdutoController); overload;
    constructor Create(APedidoController: TPedidoController); overload;
    function ObterObjetoSelecionado: TObject;
    property CodigoSelecionado: Integer read ObterCodigoSelecionado;
  end;

var
  ViewGenericSearch_Form: TViewGenericSearch_Form;

implementation

{$R *.dfm}

uses
  System.Types; // Para usar o tipo TPointF

{ TForm2 }

constructor TViewGenericSearch_Form.Create(AClienteController: TClienteController);
begin
  inherited Create(nil);
  FController := AClienteController;
  FTipo := ttCliente;
  Caption := 'Clientes';
  StringGrid1.ColCount := 4;
  StringGrid1.ColWidths[0] := 50;
  StringGrid1.ColWidths[1] := 200;
  StringGrid1.Cells[0, 0] := 'Código';
  StringGrid1.Cells[1, 0] := 'Nome';
  StringGrid1.Cells[2, 0] := 'Cidade';
  StringGrid1.Cells[3, 0] := 'Estado';
  CarregarClientes;
end;

constructor TViewGenericSearch_Form.Create(AProdutoController: TProdutoController);
begin
  inherited Create(nil);
  FController := AProdutoController;
  FTipo := ttProduto;
  Caption := 'Produtos';
  StringGrid1.ColCount := 3;
  StringGrid1.ColWidths[0] := 50;
  StringGrid1.ColWidths[1] := 200;
  StringGrid1.ColWidths[2] := 100;
  StringGrid1.Cells[0, 0] := 'Código';
  StringGrid1.Cells[1, 0] := 'Descrição';
  StringGrid1.Cells[2, 0] := 'Preço';
  CarregarProdutos;
end;

procedure TViewGenericSearch_Form.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TViewGenericSearch_Form.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TViewGenericSearch_Form.CarregaPedidos;
var
  Pedidos: TList<TPedido>;
  I: Integer;
begin
  StringGrid1.RowCount := 1;
  Pedidos := TPedidoController(FController).ListarPedidos;
  try
    StringGrid1.RowCount := Pedidos.Count + 1;
    for I := 0 to Pedidos.Count - 1 do
    begin
      StringGrid1.Cells[0, I + 1] := Pedidos[I].NumeroPedido.ToString;
      StringGrid1.Cells[1, I + 1] := FormatDateTime('dd/mm/yyyy', Pedidos[I].DataEmissao);
      StringGrid1.Cells[2, I + 1] := Pedidos[I].CodigoCliente.ToString;
      StringGrid1.Cells[3, I + 1] := FloatToStr2(Pedidos[I].ValorTotal);
      StringGrid1.RowHeights[I + 1] := 20;
    end;
  finally
    Pedidos.Free;
  end;

end;

procedure TViewGenericSearch_Form.CarregarClientes;
var
  Clientes: TList<TCliente>;
  I: Integer;
begin
  StringGrid1.RowCount := 1;
  Clientes := TClienteController(FController).ListarClientes;
  try
    StringGrid1.RowCount := Clientes.Count + 1;
    for I := 0 to Clientes.Count - 1 do
    begin
      StringGrid1.Cells[0, I + 1] := IntToStr(Clientes[I].Codigo);
      StringGrid1.Cells[1, I + 1] := Clientes[I].Nome;
      StringGrid1.Cells[2, I + 1] := Clientes[I].Cidade;
      StringGrid1.Cells[3, I + 1] := Clientes[I].UF;
      StringGrid1.RowHeights[I + 1] := 20;
    end;
  finally
    Clientes.Free;
  end;
end;

procedure TViewGenericSearch_Form.CarregarProdutos;
var
  Produtos: TList<TProduto>;
  I: Integer;
begin
  StringGrid1.RowCount := 1;
  Produtos := TProdutoController(FController).ListarProdutos;
  try
    StringGrid1.RowCount := Produtos.Count + 1;
    for I := 0 to Produtos.Count - 1 do
    begin
      StringGrid1.Cells[0, I + 1] := IntToStr(Produtos[I].Codigo);
      StringGrid1.Cells[1, I + 1] := Produtos[I].Descricao;
      StringGrid1.Cells[2, I + 1] := FloatToStr2(Produtos[I].PrecoVenda);
      StringGrid1.RowHeights[I + 1] := 20;
    end;
  finally
    Produtos.Free;
  end;
end;

function TViewGenericSearch_Form.ObterObjetoSelecionado: TObject;
var
  Codigo: Integer;
begin
  Result := nil;
  if StringGrid1.Row > 0 then
  begin
    Codigo := StrToInt(StringGrid1.Cells[0, StringGrid1.Row]);
    case FTipo of
      ttCliente:
        Result := TClienteController(FController).ObterClientePorCodigo(Codigo);
      ttProduto:
        Result := TProdutoController(FController).ObterProdutoPorCodigo(Codigo);
      ttPedido:
        Result := TPedidoController(FController).ObterPedidoPorNumero(Codigo);
    end;
  end;
end;

function TViewGenericSearch_Form.ObterCodigoSelecionado: Integer;
begin
  Result := 0;
  if StringGrid1.Row > 0 then
  begin
    Result := StrToInt(StringGrid1.Cells[0, StringGrid1.Row]);
  end;
end;

constructor TViewGenericSearch_Form.Create(APedidoController: TPedidoController);
begin
  inherited Create(nil);
  FController := APedidoController;
  FTipo := ttPedido;
  Caption := 'Pedidos';
  StringGrid1.ColCount := 4;
  StringGrid1.ColWidths[0] := 50;
  StringGrid1.ColWidths[1] := 100;
  StringGrid1.ColWidths[2] := 100;
  StringGrid1.ColWidths[2] := 100;
  StringGrid1.Cells[0, 0] := 'Numero';
  StringGrid1.Cells[1, 0] := 'Data';
  StringGrid1.Cells[2, 0] := 'Cliente';
  StringGrid1.Cells[3, 0] := 'ValorTotal';
  CarregaPedidos;
end;

end.
