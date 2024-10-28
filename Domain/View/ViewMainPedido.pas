unit ViewMainPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.Mask, DataModule, Vcl.Buttons,
  Cliente, Produto, Pedido, PedidoProduto,
  PedidoController, PedidoProdutoController,
  ClienteController, ProdutoController,
  ViewGenericGrid, Common, System.StrUtils, System.Generics.Collections;

type
  TViewMainPedido_Form = class(TForm)
    pnlItensPedido: TPanel;
    pnlOpcoes: TPanel;
    pnlDigitacao: TPanel;
    btnNovo: TButton;
    btnGravar: TButton;
    lblTotal: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    txtCodigoProduto: TMaskEdit;
    txtQuantidade: TMaskEdit;
    txtValorUnitario: TMaskEdit;
    Label1: TLabel;
    Label3: TLabel;
    lblNomeCliente: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnAdicionarItem: TButton;
    SpeedButton1: TSpeedButton;
    lblNumeroPedido: TLabel;
    lblCodigoCliente: TLabel;
    txtNumeroPedido: TMaskEdit;
    lblDescricao: TLabel;
    GridVendas: TStringGrid;
    btnCancelarAlteracao: TButton;
    btnAbrir: TButton;
    procedure btnNovoClick(Sender: TObject);
    procedure txtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure txtQuantidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridVendasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelarAlteracaoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FPedido : TPedido;
    FPedidoProdutoController : TPedidoProdutoController;
    FCliente : TCliente;
    FProduto : TProduto;
    FAcaoItem : (ttInclusao, ttAlteracao);
    FItemAlteracao : Integer;
    procedure ProcuraProduto(ACodigoProduto: integer);
    function ValidaProduto : Boolean;
    procedure IncluirAlterarProduto;
    procedure AtualizarGridVendas(ANumeroPedido: Integer);
    procedure LimparDigitacao;
  public
    { Public declarations }
  end;

var
  ViewMainPedido_Form: TViewMainPedido_Form;

implementation

{$R *.dfm}

procedure TViewMainPedido_Form.AtualizarGridVendas(ANumeroPedido: Integer);
var
  lstPedidoProdutos: TList<TPedidoProduto>;
  I: Integer;
begin
  GridVendas.ColCount := 5;
  GridVendas.Cells[0, 0] := 'ID';
  GridVendas.Cells[1, 0] := 'Código';
  GridVendas.Cells[2, 0] := 'Descrição';
  GridVendas.Cells[3, 0] := 'Quantidade';
  GridVendas.Cells[4, 0] := 'Valor Unitário';
  GridVendas.Cells[5, 0] := 'Valor Total';

  GridVendas.RowCount := 1;

  lstPedidoProdutos := TPedidoProdutoController.ListarPedidoProdutos(ANumeroPedido);
  try
    GridVendas.RowCount := lstPedidoProdutos.Count + 1;
    for I := 0 to lstPedidoProdutos.Count - 1 do
    begin
      GridVendas.Cells[0, I + 1] := lstPedidoProdutos[I].Id.ToString;
      GridVendas.Cells[1, I + 1] := lstPedidoProdutos[I].CodigoProduto.ToString;
      GridVendas.Cells[2, I + 1] := lstPedidoProdutos[I].Descricao;
      GridVendas.Cells[3, I + 1] := lstPedidoProdutos[I].Quantidade.ToString;
      GridVendas.Cells[4, I + 1] := FloatToStr2(lstPedidoProdutos[I].ValorUnitario);
      GridVendas.Cells[5, I + 1] := FloatToStr2(lstPedidoProdutos[I].ValorTotal);
      GridVendas.RowHeights[I + 1] := 20;
    end;
  finally
    lstPedidoProdutos.Free;
  end;
end;

procedure TViewMainPedido_Form.btnNovoClick(Sender: TObject);
var
  ClienteControler: TClienteController;
  ViewClientes: TViewGenericSearch_Form;
begin
  if Application.MessageBox('Criar Novo Pedido?', 'Pergunta', MB_ICONQUESTION + MB_YESNO) = mrYes then
  begin
    ClienteControler := TClienteController.Create;
    try
      ViewClientes := TViewGenericSearch_Form.Create(ClienteControler);
      try
        if ViewClientes.ShowModal = mrOk then
        begin
          if ViewClientes.ObterObjetoSelecionado is TCliente then
          begin
            FCliente := TCliente(ViewClientes.ObterObjetoSelecionado);
            lblCodigoCliente.Caption := FCliente.Codigo.ToString;
            lblNomeCliente.Caption := FCliente.Nome;

            FPedido := TPedidoController.CriarNovoPedido(FCliente.Codigo);
            txtNumeroPedido.Text := FPedido.NumeroPedido.ToString;
            lblTotal.Caption := '0.00';
            AtualizarGridVendas(FPedido.NumeroPedido);
            FAcaoItem := ttInclusao;
            FItemAlteracao := 0;

            if not Assigned(FPedidoProdutoController) then
            begin
              FPedidoProdutoController := TPedidoProdutoController.Create;
              btnAdicionarItem.Enabled := True;
              txtCodigoProduto.Text := '0';
            end;
          end;
        end;
      finally
        ViewClientes.Free;
      end;
    finally
      ClienteControler.Free;
    end;
  end;
end;

procedure TViewMainPedido_Form.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  if Assigned(FPedido) then
    FPedido.Free;

  if Assigned(FPedidoProdutoController) then
    FPedidoProdutoController.Free;

  if Assigned(FCliente) then
    FCliente.Free;

  if Assigned(FProduto) then

  if Assigned(FPedido) then
    FProduto.Free;

  Application.Terminate;
end;

procedure TViewMainPedido_Form.GridVendasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    FProduto := TProdutoController.ObterProdutoPorCodigo(StrToInt(GridVendas.Cells[1, GridVendas.Row]));
    FItemAlteracao := StrToInt(GridVendas.Cells[0, GridVendas.Row]);

    txtCodigoProduto.text := IntToStr(FProduto.Codigo);
    lblDescricao.Caption := FProduto.Descricao;
    txtQuantidade.Text  := GridVendas.Cells[3, GridVendas.Row];
    txtValorUnitario.Text  := GridVendas.Cells[4, GridVendas.Row];
    txtCodigoProduto.Enabled := False;

    FAcaoItem := ttAlteracao;
    btnCancelarAlteracao.Visible := True;
    txtQuantidade.SetFocus;
  end;

  if (Key = VK_DELETE) then
  begin
    if Application.MessageBox('Confirma a exclusão?', 'Pergunta', MB_ICONQUESTION + MB_YESNO) = mrYes then
    begin
      TPedidoProdutoController.ExcluirPedidoProduto(StrToInt(GridVendas.Cells[0, GridVendas.Row]));
      TPedidoController.TotalPedido(FPedido.NumeroPedido);
      AtualizarGridVendas(FPedido.NumeroPedido);
    end;
  end;

end;

procedure TViewMainPedido_Form.btnAbrirClick(Sender: TObject);
var
  PedidoControler: TPedidoController;
  ViewPedidos: TViewGenericSearch_Form;
begin
  PedidoControler := TPedidoController.Create;
  try
    ViewPedidos := TViewGenericSearch_Form.Create(PedidoControler);
    try
      if ViewPedidos.ShowModal = mrOk then
      begin
        if ViewPedidos.ObterObjetoSelecionado is TPedido then
        begin
          FPedido := TPedido(ViewPedidos.ObterObjetoSelecionado);
          lblCodigoCliente.Caption := FPedido.CodigoCliente.ToString;

          FCliente := TClienteController.ObterClientePorCodigo(FPedido.CodigoCliente);
          lblNomeCliente.Caption := FCliente.Nome;

          txtNumeroPedido.Text := FPedido.NumeroPedido.ToString;
          FAcaoItem := ttInclusao;
          FItemAlteracao := 0;

          if not Assigned(FPedidoProdutoController) then
          begin
            FPedidoProdutoController := TPedidoProdutoController.Create;
            btnAdicionarItem.Enabled := True;
            txtCodigoProduto.Text := '0';
          end;

          lblTotal.Caption := FloatToStr2(TPedidoController.TotalPedido(strtoint(txtNumeroPedido.Text)));
          AtualizarGridVendas(strtoint(txtNumeroPedido.Text));
        end;
      end;
    finally
      ViewPedidos.Free;
    end;
  finally
    PedidoControler.Free;
  end;


  TPedidoController.ObterPedidoPorNumero(0);
end;

procedure TViewMainPedido_Form.btnAdicionarItemClick(Sender: TObject);
begin
  IncluirAlterarProduto;
end;

procedure TViewMainPedido_Form.btnCancelarAlteracaoClick(Sender: TObject);
begin
  LimparDigitacao;
end;

procedure TViewMainPedido_Form.btnGravarClick(Sender: TObject);
begin
  if Application.MessageBox('Gravar Pedido?', 'Pergunta', MB_ICONQUESTION + MB_YESNO) = mrYes then
  begin
    if not Dm.FDTransaction1.Active then
    begin
      Dm.FDTransaction1.StartTransaction;
      Dm.FDTransaction1.Commit;
    end;
  end;
end;

procedure TViewMainPedido_Form.IncluirAlterarProduto;
var
  ProdutoControler: TPedidoProdutoController;
  PedidoProduto: TPedidoProduto;
begin
  if ValidaProduto then
  begin
    PedidoProduto := TPedidoProduto.Create;
    try
      PedidoProduto.NumeroPedido  := FPedido.NumeroPedido;
      PedidoProduto.Quantidade    := StrToInt(txtQuantidade.Text);
      PedidoProduto.ValorUnitario := StrToFloat2(txtValorUnitario);
      PedidoProduto.CodigoProduto := FProduto.Codigo;
      PedidoProduto.ValorTotal    := PedidoProduto.ValorUnitario * PedidoProduto.Quantidade;

      ProdutoControler := TPedidoProdutoController.Create;
      try
        case FAcaoItem of
          ttInclusao:
            begin
              PedidoProduto.Id := 0;
              ProdutoControler.SalvarPedidoProduto(PedidoProduto);
            end;

          ttAlteracao:
            begin
              PedidoProduto.Id := FItemAlteracao;
              ProdutoControler.SalvarPedidoProduto(PedidoProduto);
            end;
        end;
      finally
        ProdutoControler.Free;
      end;
    finally
      PedidoProduto.Free;
    end;

    lblTotal.Caption := FormatFloat('###,###.00', TPedidoController.TotalPedido(FPedido.NumeroPedido));
    AtualizarGridVendas(FPedido.NumeroPedido);
    LimparDigitacao;
  end;
end;

procedure TViewMainPedido_Form.LimparDigitacao;
begin
  txtCodigoProduto.Text := '0';
  txtQuantidade.Text := '1';
  txtValorUnitario.Text := '0';
  lblDescricao.Caption := '';

  FProduto.Codigo:=0;
  FProduto.Descricao := '';
  FProduto.PrecoVenda := 0.00;

  FItemAlteracao := 0;
  FAcaoItem := ttInclusao;

  txtCodigoProduto.Enabled := True;
  btnCancelarAlteracao.Visible := False;
end;

procedure TViewMainPedido_Form.ProcuraProduto(ACodigoProduto: integer);
var
  ProdutoControler: TProdutoController;
  ViewProdutos: TViewGenericSearch_Form;
begin
  ProdutoControler := TProdutoController.Create;
  try
    if ACodigoProduto = 0 then
    begin
      ViewProdutos := TViewGenericSearch_Form.Create(ProdutoControler);
      try
        if ViewProdutos.ShowModal = mrOk then
        begin
          if ViewProdutos.ObterObjetoSelecionado is TProduto then
          begin
            FProduto := TProduto(ViewProdutos.ObterObjetoSelecionado);
            txtCodigoProduto.Text := FProduto.Codigo.ToString;
            txtQuantidade.Text := '1';
            txtValorUnitario.Text := FloatToStr2(FProduto.PrecoVenda);
            lblDescricao.Caption  := FProduto.Descricao;
          end;
        end;
      finally
        ViewProdutos.Free;
      end;
    end
    else
    begin
      FProduto := ProdutoControler.ObterProdutoPorCodigo(ACodigoProduto);
      txtCodigoProduto.Text := FProduto.Codigo.ToString;
      txtQuantidade.Text := '1';
      txtValorUnitario.Text := FloatToStr2(FProduto.PrecoVenda);
      lblDescricao.Caption  := FProduto.Descricao;
    end;
  finally
    ProdutoControler.Free;
  end;
end;

procedure TViewMainPedido_Form.SpeedButton1Click(Sender: TObject);
begin
  if not Assigned(FPedido) then
  begin
    Application.MessageBox('Primeiro crie um novo pedido', 'Atenção');
    exit;
  end;

  if txtCodigoProduto.Text = EmptyStr then
    txtCodigoProduto.Text := '0';

    ProcuraProduto(StrToInt(txtCodigoProduto.text));
end;


procedure TViewMainPedido_Form.txtCodigoProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not Assigned(FPedido) then
  begin
    Application.MessageBox('Primeiro crie um novo pedido', 'Atenção');
    exit;
  end;

  if txtCodigoProduto.Text = EmptyStr then
    txtCodigoProduto.Text := '0';

  if (Key = VK_RETURN) and ((Sender as TMaskEdit).Name = 'txtCodigoProduto') then
    ProcuraProduto(StrToInt(txtCodigoProduto.text));
end;

procedure TViewMainPedido_Form.txtQuantidadeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ValidarInteiro(Sender as TMaskEdit);
end;

function TViewMainPedido_Form.ValidaProduto: Boolean;
begin
  Result := True;

  if (txtCodigoProduto.Text = '0') or (txtCodigoProduto.Text = '') then
  begin
    Application.MessageBox('Código Inválido', 'Atenção');
    Result := False;
    Exit;
  end;

  if (txtQuantidade.Text = '0') or (txtQuantidade.Text = '') then
  begin
    Application.MessageBox('Quantidade Inválida', 'Atenção');
    Result := False;
    Exit;
  end;

  if (txtValorUnitario.Text = '0') or (txtValorUnitario.Text = '') then
  begin
    Application.MessageBox('Valor Inválido', 'Atenção');
    Result := False;
    Exit;
  end;

end;

end.
