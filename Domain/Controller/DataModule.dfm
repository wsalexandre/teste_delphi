object Dm: TDm
  OnCreate = DataModuleCreate
  Height = 516
  Width = 841
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Password=p@ssw0rd'
      'User_Name=root'
      'Database=teste_delphi'
      'Server=localhost'
      'Pooled=teste_delphi'
      'DriverID=MySQL')
    TxOptions.Isolation = xiRepeatableRead
    TxOptions.AutoStart = False
    TxOptions.AutoStop = False
    LoginPrompt = False
    Transaction = FDTransaction1
    AfterCommit = FDConnection1AfterCommit
    Left = 184
    Top = 40
  end
  object qryClientes: TFDQuery
    Connection = FDConnection1
    Transaction = FDTransaction1
    SQL.Strings = (
      'SELECT * FROM clientes')
    Left = 80
    Top = 192
  end
  object MySQLDriverLink1: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorHome = 'D:\teste-delphi'
    VendorLib = 'libmySQL.dll'
    Left = 80
    Top = 40
  end
  object qryProdutos: TFDQuery
    Connection = FDConnection1
    Transaction = FDTransaction1
    SQL.Strings = (
      'SELECT * FROM produtos')
    Left = 80
    Top = 264
  end
  object qryPedidos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM pedidos')
    Left = 80
    Top = 344
  end
  object qryPedidoProdutos: TFDQuery
    Connection = FDConnection1
    Transaction = FDTransaction1
    SQL.Strings = (
      'SELECT * FROM pedidos_produtos')
    Left = 80
    Top = 424
  end
  object FDTransaction1: TFDTransaction
    Options.Isolation = xiRepeatableRead
    Options.AutoStart = False
    Options.AutoStop = False
    Connection = FDConnection1
    AfterCommit = FDTransaction1AfterCommit
    Left = 280
    Top = 40
  end
  object dspPedidos: TDataSetProvider
    DataSet = qryPedidos
    Left = 200
    Top = 344
  end
  object cdsPedidos: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspPedidos'
    Left = 328
    Top = 344
    object cdsPedidosNumeroPedido: TAutoIncField
      FieldName = 'NumeroPedido'
      ReadOnly = True
    end
    object cdsPedidosDataEmissao: TDateTimeField
      FieldName = 'DataEmissao'
    end
    object cdsPedidosCodigoCliente: TIntegerField
      FieldName = 'CodigoCliente'
    end
    object cdsPedidosValorTotal: TBCDField
      FieldName = 'ValorTotal'
      currency = True
      Precision = 10
      Size = 2
    end
  end
  object dsPedidos: TDataSource
    DataSet = cdsPedidos
    Left = 456
    Top = 344
  end
  object dspPedidoProdutos: TDataSetProvider
    DataSet = qryPedidoProdutos
    Left = 200
    Top = 424
  end
  object cdsPedidoProdutos: TClientDataSet
    Aggregates = <>
    MasterSource = dsPedidos
    PacketRecords = 0
    Params = <>
    ProviderName = 'dspPedidoProdutos'
    Left = 328
    Top = 424
    object cdsPedidoProdutosId: TAutoIncField
      FieldName = 'Id'
      ReadOnly = True
    end
    object cdsPedidoProdutosNumeroPedido: TIntegerField
      FieldName = 'NumeroPedido'
    end
    object cdsPedidoProdutosCodigoProduto: TIntegerField
      FieldName = 'CodigoProduto'
    end
    object cdsPedidoProdutosQuantidade: TIntegerField
      FieldName = 'Quantidade'
    end
    object cdsPedidoProdutosValorUnitario: TBCDField
      FieldName = 'ValorUnitario'
      currency = True
      Precision = 10
      Size = 2
    end
    object cdsPedidoProdutosValorTotal: TBCDField
      FieldName = 'ValorTotal'
      currency = True
      Precision = 10
      Size = 2
    end
  end
  object dsPedidoProdutos: TDataSource
    DataSet = cdsPedidoProdutos
    Left = 456
    Top = 424
  end
end
