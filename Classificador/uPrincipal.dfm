object FrmClassifica: TFrmClassifica
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'FrmClassifica'
  ClientHeight = 567
  ClientWidth = 1041
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 548
    Width = 1041
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 209
    Height = 507
    Align = alLeft
    BevelOuter = bvNone
    Color = 12615680
    ParentBackground = False
    TabOrder = 1
    object gpbDados: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 203
      Height = 182
      Align = alTop
      Caption = 'Dados da Rede'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object SpeedButton1: TSpeedButton
        AlignWithMargins = True
        Left = 5
        Top = 155
        Width = 193
        Height = 22
        Align = alBottom
        Caption = 'Importar Rede'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton1Click
        ExplicitLeft = 64
        ExplicitTop = 120
        ExplicitWidth = 23
      end
      object GroupBox1: TGroupBox
        Left = 17
        Top = 24
        Width = 167
        Height = 62
        Caption = 'N'#186' de Camadas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'SegoeUi'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object lblNumCamadas: TLabel
          Left = 2
          Top = 16
          Width = 163
          Height = 44
          Align = alClient
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 4
          ExplicitHeight = 21
        end
      end
      object GroupBox2: TGroupBox
        Left = 17
        Top = 87
        Width = 167
        Height = 62
        Caption = 'Neur'#244'nios por Camada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'SegoeUi'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object LblNeucamadas: TLabel
          Left = 2
          Top = 16
          Width = 163
          Height = 44
          Align = alClient
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 4
          ExplicitHeight = 21
        end
      end
    end
    object BitBtn2: TBitBtn
      Left = 70
      Top = 408
      Width = 75
      Height = 25
      Caption = 'BitBtn2'
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object Edit1: TEdit
      Left = 22
      Top = 470
      Width = 186
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object ComboBox1: TComboBox
      Left = 24
      Top = 200
      Width = 145
      Height = 21
      ItemIndex = 0
      TabOrder = 3
      Text = 'COM0'
      Items.Strings = (
        'COM0'
        'COM1'
        'COM2'
        'COM3'
        'COM4'
        'COM5'
        'COM6'
        'COM7'
        'COM8'
        'COM9')
    end
    object BitBtn1: TBitBtn
      Left = 24
      Top = 227
      Width = 75
      Height = 25
      Caption = 'Conectar'
      TabOrder = 4
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1041
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    Color = 12615680
    ParentBackground = False
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 209
    Top = 41
    Width = 832
    Height = 507
    Align = alClient
    TabOrder = 3
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 830
      Height = 328
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Image1: TImage
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 824
        Height = 281
        Align = alClient
        Center = True
        ExplicitLeft = -3
        ExplicitTop = 41
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 830
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Classe identificada'
        Color = 12615680
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 329
      Width = 830
      Height = 177
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 352
        Top = 112
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 830
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Classe identificada'
        Color = 12615680
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 336
    Top = 184
  end
  object ApdComPort1: TApdComPort
    Baud = 9600
    TraceName = 'APRO.TRC'
    LogName = 'APRO.LOG'
    Left = 56
    Top = 297
  end
  object ApdDataPacket1: TApdDataPacket
    Enabled = True
    EndCond = [ecString]
    StartString = '['
    EndString = ']'
    ComPort = ApdComPort1
    PacketSize = 0
    OnStringPacket = ApdDataPacket1StringPacket
    Left = 56
    Top = 360
  end
end
