object TreeMenuForm: TTreeMenuForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tree Menu'
  ClientHeight = 269
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView: TTreeView
    Left = 8
    Top = 8
    Width = 241
    Height = 187
    Indent = 19
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    OnChange = TreeViewChange
    OnChanging = TreeViewChanging
    OnClick = TreeViewClick
    OnDblClick = TreeViewDblClick
  end
  object OkButton: TButton
    Left = 51
    Top = 210
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = OkButtonClick
  end
  object QuitButton: TButton
    Left = 132
    Top = 210
    Width = 75
    Height = 25
    Caption = 'Quit'
    TabOrder = 2
    OnClick = QuitButtonClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 250
    Width = 259
    Height = 19
    Panels = <>
  end
end
