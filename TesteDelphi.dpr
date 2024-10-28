program TesteDelphi;

uses
  Vcl.Forms,
  Cliente in 'Domain\Model\Cliente.pas',
  Produto in 'Domain\Model\Produto.pas',
  Pedido in 'Domain\Model\Pedido.pas',
  PedidoProduto in 'Domain\Model\PedidoProduto.pas',
  ViewMainPedido in 'Domain\View\ViewMainPedido.pas' {ViewMainPedido_Form},
  Common in 'Domain\Common\Common.pas',
  ClienteController in 'Domain\Controller\ClienteController.pas',
  PedidoController in 'Domain\Controller\PedidoController.pas',
  PedidoProdutoController in 'Domain\Controller\PedidoProdutoController.pas',
  ProdutoController in 'Domain\Controller\ProdutoController.pas',
  ViewGenericGrid in 'Domain\View\ViewGenericGrid.pas' {ViewGenericSearch_Form},
  DataModule in 'Domain\Controller\DataModule.pas' {Dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TViewMainPedido_Form, ViewMainPedido_Form);
  Application.Run;
end.
