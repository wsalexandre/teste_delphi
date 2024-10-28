unit Pedido;

interface

uses
  Classes, SysUtils;

type
  // Classe para representar a tabela "pedidos"
  TPedido = class(TObject)
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FValorTotal: Double;
    FNomeCliente : string;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property NomeCliente: string read FNomeCliente write FNomeCliente;
  end;

implementation

end.
