object ViewMainPedido_Form: TViewMainPedido_Form
  Left = 0
  Top = 0
  Caption = 'WK-PDV'
  ClientHeight = 674
  ClientWidth = 1012
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object pnlItensPedido: TPanel
    Left = 0
    Top = 0
    Width = 853
    Height = 528
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 849
    ExplicitHeight = 527
    object GridVendas: TStringGrid
      Left = 1
      Top = 1
      Width = 851
      Height = 526
      Align = alClient
      TabOrder = 0
      OnKeyDown = GridVendasKeyDown
      ExplicitWidth = 847
      ExplicitHeight = 525
    end
  end
  object pnlOpcoes: TPanel
    Left = 853
    Top = 0
    Width = 159
    Height = 528
    Align = alRight
    TabOrder = 1
    ExplicitLeft = 849
    ExplicitHeight = 527
    object lblNumeroPedido: TLabel
      Left = 1
      Top = 468
      Width = 157
      Height = 21
      Align = alBottom
      Alignment = taCenter
      Caption = 'N'#250'mero Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 121
    end
    object btnNovo: TButton
      Left = 8
      Top = 16
      Width = 145
      Height = 25
      Caption = 'Novo Pedido'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnGravar: TButton
      Left = 6
      Top = 47
      Width = 145
      Height = 25
      Caption = 'Gravar'
      TabOrder = 1
      OnClick = btnGravarClick
    end
    object txtNumeroPedido: TMaskEdit
      Left = 1
      Top = 489
      Width = 157
      Height = 38
      Align = alBottom
      Alignment = taCenter
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '0'
      ExplicitTop = 488
    end
    object btnAbrir: TButton
      Left = 6
      Top = 129
      Width = 145
      Height = 25
      Caption = 'Abrir Pedido'
      TabOrder = 3
      OnClick = btnAbrirClick
    end
  end
  object pnlDigitacao: TPanel
    Left = 0
    Top = 609
    Width = 1012
    Height = 65
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 608
    ExplicitWidth = 1008
    object lblTotal: TLabel
      Left = 948
      Top = 1
      Width = 63
      Height = 63
      Align = alRight
      Alignment = taRightJustify
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 45
    end
    object Label2: TLabel
      Left = 865
      Top = 1
      Width = 83
      Height = 63
      Align = alRight
      Caption = 'Total:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 45
    end
    object Label3: TLabel
      Left = 12
      Top = 8
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object lblNomeCliente: TLabel
      Left = 68
      Top = 29
      Width = 28
      Height = 21
      Caption = '____'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCodigoCliente: TLabel
      Left = 12
      Top = 29
      Width = 9
      Height = 21
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 528
    Width = 1012
    Height = 81
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 527
    ExplicitWidth = 1008
    object Label1: TLabel
      Left = 12
      Top = 6
      Width = 85
      Height = 15
      Caption = 'C'#243'digo Produto'
    end
    object Label4: TLabel
      Left = 193
      Top = 7
      Width = 62
      Height = 15
      Caption = 'Quantidade'
    end
    object Label5: TLabel
      Left = 345
      Top = 7
      Width = 71
      Height = 15
      Caption = 'Valor Unit'#225'rio'
    end
    object SpeedButton1: TSpeedButton
      Left = 136
      Top = 29
      Width = 23
      Height = 22
      Caption = '...'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object lblDescricao: TLabel
      Left = 12
      Top = 57
      Width = 12
      Height = 21
      Caption = '...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtCodigoProduto: TMaskEdit
      Left = 12
      Top = 27
      Width = 118
      Height = 23
      TabOrder = 0
      Text = ''
      OnKeyDown = txtCodigoProdutoKeyDown
    end
    object txtQuantidade: TMaskEdit
      Left = 193
      Top = 28
      Width = 120
      Height = 23
      TabOrder = 1
      Text = ''
    end
    object txtValorUnitario: TMaskEdit
      Left = 345
      Top = 28
      Width = 116
      Height = 23
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object btnAdicionarItem: TButton
      Left = 481
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Adicionar'
      Enabled = False
      TabOrder = 3
      OnClick = btnAdicionarItemClick
    end
    object btnCancelarAlteracao: TButton
      Left = 579
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 4
      Visible = False
      OnClick = btnCancelarAlteracaoClick
    end
  end
end
