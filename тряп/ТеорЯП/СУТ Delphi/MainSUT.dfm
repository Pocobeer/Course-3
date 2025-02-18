object frmMainSUT: TfrmMainSUT
  Left = 283
  Top = 256
  Width = 1254
  Height = 666
  Caption = #1057#1080#1085#1090#1072#1082#1089#1080#1095#1077#1089#1082#1080' '#1091#1087#1088#1072#1074#1083#1103#1077#1084#1072#1103' '#1090#1088#1072#1085#1089#1083#1103#1094#1080#1103
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 520
    Width = 118
    Height = 13
    Caption = #1054#1073#1085#1072#1088#1091#1078#1077#1085#1085#1099#1077' '#1086#1096#1080#1073#1082#1080
  end
  object lblZagRez: TLabel
    Left = 608
    Top = 88
    Width = 131
    Height = 13
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1090#1086#1082#1077#1085#1099
  end
  object Label1: TLabel
    Left = 928
    Top = 88
    Width = 159
    Height = 13
    Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1072#1084#1103#1090#1080' '#1076#1072#1085#1085#1099#1093
  end
  object GrBoxProg: TGroupBox
    Left = 8
    Top = 8
    Width = 585
    Height = 505
    Caption = ' '#1058#1077#1082#1089#1090' '#1090#1077#1089#1090#1086#1074#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '
    TabOrder = 0
    object StBarProg: TStatusBar
      Left = 2
      Top = 484
      Width = 581
      Height = 19
      Panels = <
        item
          Text = ' '#1057#1090#1088#1086#1082#1072': '#1061#1061
          Width = 80
        end
        item
          Text = ' '#1055#1086#1079#1080#1094#1080#1103' '#1074' '#1089#1090#1088#1086#1082#1077': '#1061#1061
          Width = 130
        end
        item
          Text = ' '#1048#1079#1084#1077#1085#1077#1085#1080#1103': '#1045#1089#1090#1100
          Width = 50
        end>
    end
    object btnLoad: TButton
      Left = 496
      Top = 24
      Width = 75
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 1
      OnClick = btnLoadClick
    end
    object btnSave: TButton
      Left = 496
      Top = 56
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 2
      OnClick = btnSaveClick
    end
    object REdProg: TRichEdit
      Left = 8
      Top = 16
      Width = 473
      Height = 465
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 3
      OnChange = REdProgChange
      OnKeyUp = REdProgKeyUp
      OnMouseDown = REdProgMouseDown
    end
  end
  object memError: TMemo
    Left = 8
    Top = 536
    Width = 585
    Height = 73
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object memToken: TMemo
    Left = 608
    Top = 104
    Width = 297
    Height = 513
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnScan: TButton
    Left = 624
    Top = 32
    Width = 75
    Height = 25
    Caption = #1057#1082#1072#1085#1077#1088
    TabOrder = 3
    OnClick = btnScanClick
  end
  object memData: TMemo
    Left = 928
    Top = 104
    Width = 297
    Height = 513
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object GrBoxLR: TGroupBox
    Left = 736
    Top = 8
    Width = 209
    Height = 65
    Caption = #1042#1086#1089#1093#1086#1076#1103#1097#1103#1103' '#1057#1059#1058' '
    TabOrder = 5
    object btnSut: TButton
      Left = 110
      Top = 24
      Width = 83
      Height = 25
      Caption = #1057#1059#1058
      TabOrder = 0
      OnClick = btnSutClick
    end
    object btnLoadXml: TButton
      Left = 16
      Top = 24
      Width = 81
      Height = 25
      Caption = 'LR-'#1090#1072#1073#1083#1080#1094#1072
      TabOrder = 1
      OnClick = btnLoadXmlClick
    end
  end
  object GrBoxLL: TGroupBox
    Left = 968
    Top = 8
    Width = 209
    Height = 65
    Caption = #1053#1080#1089#1093#1086#1076#1103#1097#1103#1103' '#1057#1059#1058' '
    TabOrder = 6
    object btnSutLL: TButton
      Left = 110
      Top = 24
      Width = 83
      Height = 25
      Caption = #1057#1059#1058
      TabOrder = 0
      OnClick = btnSutLLClick
    end
    object btnLoadLL: TButton
      Left = 16
      Top = 24
      Width = 81
      Height = 25
      Caption = 'LL-'#1090#1072#1073#1083#1080#1094#1072
      TabOrder = 1
      OnClick = btnLoadLLClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofShowHelp, ofEnableSizing]
    Title = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1090#1077#1089#1090#1086#1074#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Left = 544
    Top = 176
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = #1047#1072#1075#1088#1091#1079#1082#1072' '#1090#1077#1089#1090#1086#1074#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Left = 544
    Top = 224
  end
  object XMLDoc: TXMLDocument
    FileName = 'E:\LEONID\'#1044#1080#1089#1094#1080#1087#1083#1080#1085#1099'\'#1058#1077#1086#1088#1071#1055'\'#1057#1059#1058' Delphi\TESTS\SLR_Table_'#1057#1093#1077#1084#1072'.xml'
    Options = [doAttrNull]
    Left = 544
    Top = 264
    DOMVendorDesc = 'MSXML'
  end
end
