object StartupDialogForm: TStartupDialogForm
  Left = 337
  Top = 343
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Startup Dialog'
  ClientHeight = 369
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LogoImage: TImage
    Left = 33
    Top = 12
    Width = 461
    Height = 60
    Cursor = crHandPoint
    Stretch = True
    OnClick = LogoImageClick
    OnDblClick = LogoImageDblClick
  end
  object Bevel: TBevel
    Left = 10
    Top = 315
    Width = 509
    Height = 9
    Shape = bsBottomLine
  end
  object MoreButton: TButton
    Left = 259
    Top = 330
    Width = 75
    Height = 25
    Caption = '&More...'
    TabOrder = 0
    OnClick = MoreButtonClick
  end
  object RunButton: TButton
    Left = 339
    Top = 330
    Width = 75
    Height = 25
    Caption = '&Run'
    TabOrder = 1
    OnClick = RunButtonClick
  end
  object QuitButton: TButton
    Left = 419
    Top = 330
    Width = 75
    Height = 25
    Caption = '&Quit'
    TabOrder = 2
    OnClick = QuitButtonClick
  end
  object RelTypePanel: TPanel
    Left = 8
    Top = 331
    Width = 217
    Height = 25
    BevelOuter = bvLowered
    Caption = 'Full Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object PageControl: TPageControl
    Left = 8
    Top = 84
    Width = 511
    Height = 225
    ActivePage = tbConfig
    TabOrder = 4
    object tbReadme: TTabSheet
      Caption = 'Readme'
      ImageIndex = 1
      object ReadmeMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 503
        Height = 197
        Align = alClient
        Color = 12189695
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Lucida Console'
        Font.Style = []
        HideScrollBars = False
        Lines.Strings = (
          'README.TXT was found or could not be read!')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
      end
    end
    object tbLicense: TTabSheet
      Caption = 'License'
      object LicenseMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 503
        Height = 197
        Align = alClient
        Color = 12189695
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Lucida Console'
        Font.Style = []
        HideScrollBars = False
        Lines.Strings = (
          'LICENSE.TXT was found or could not be read!')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
      end
    end
    object tbConfig: TTabSheet
      Caption = 'Configuration'
      ImageIndex = 2
      object StringGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 503
        Height = 197
        Align = alClient
        Color = 12189695
        ColCount = 2
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goFixedRowDefAlign]
        ParentDoubleBuffered = False
        TabOrder = 0
        ColWidths = (
          64
          430)
      end
    end
  end
end
