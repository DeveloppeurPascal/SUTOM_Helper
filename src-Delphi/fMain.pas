(* C2PP
  ***************************************************************************

  SUTOM Helper

  Copyright 2023-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://sutomhelper.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/SUTOM_Helper

  ***************************************************************************
  File last update : 2025-10-16T10:43:04.820+02:00
  Signature : 60f37a7b93b4a7168379d6b14091377c12e206e0
  ***************************************************************************
*)

unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  Olf.FMX.AboutDialog,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  uDMLogo,
  FMX.Layouts,
  FMX.TabControl,
  System.Generics.Collections,
  FMX.Memo.Types,
  FMX.Edit,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Menus;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    btnClose: TButton;
    btnAbout: TButton;
    btnRestart: TButton;
    OlfAboutDialog1: TOlfAboutDialog;
    tcGame: TTabControl;
    tiLettersNumber: TTabItem;
    tiWord: TTabItem;
    tbLettersCount: TTrackBar;
    lblHowManyLetters: TLabel;
    Layout1: TLayout;
    btnStart: TButton;
    mmoWordsList: TMemo;
    lLetters: TLayout;
    lblNbLetters: TLabel;
    MainMenu1: TMainMenu;
    mnuFichier: TMenuItem;
    mnuQuitter: TMenuItem;
    mnuMot: TMenuItem;
    mnuRestart: TMenuItem;
    mnuOutils: TMenuItem;
    mnuLangues: TMenuItem;
    mnuAide: TMenuItem;
    mnuAPropos: TMenuItem;
    mnuMacOS: TMenuItem;
    mnuLangueFrancais: TMenuItem;
    mnuLangueAnglais: TMenuItem;
    procedure btnAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbLettersCountTracking(Sender: TObject);
    procedure mnuLangueAnglaisClick(Sender: TObject);
    procedure mnuLangueFrancaisClick(Sender: TObject);
  private
    FCurrentLanguage: string;
    { Déclarations privées }
    procedure RestartGame;
    procedure StartGame;
    procedure GenerateWords;
    procedure EdtLetterChanged(Sender: TObject);
    procedure EdtListLettersChange(Sender: TObject);
    procedure SetCurrentLanguage(const Value: string);
  protected
    procedure TraduireTextes;
  public
    { Déclarations publiques }
    LettersCount: byte;
    Letters: TDictionary<byte, char>;
    GeneratedWordsCount: cardinal;
    edtAvailableLetters: tedit;
    property CurrentLanguage: string read FCurrentLanguage
      write SetCurrentLanguage;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.Generics.Defaults,
  u_urlOpen,
  uAboutBoxDescriptionTextConst,
  uAboutBoxLicenseTextConst,
  Olf.FMX.AboutDialogForm,
  uConfig;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnRestartClick(Sender: TObject);
begin
  RestartGame;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  StartGame;
end;

procedure TfrmMain.EdtLetterChanged(Sender: TObject);
var
  edt: tedit;
begin
  if Sender is tedit then
  begin
    edt := Sender as tedit;
    if edt.Text.trim.isEmpty then
      Letters.AddOrSetValue(edt.Tag, '?')
    else
      Letters.AddOrSetValue(edt.Tag, edt.Text.chars[0]);
    GenerateWords;
  end;
end;

procedure TfrmMain.EdtListLettersChange(Sender: TObject);
begin
  GenerateWords;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FCurrentLanguage := '';
  CurrentLanguage := tconfig.Language;

{$IFDEF DEBUG}
  caption := '[DEBUG] ' + OlfAboutDialog1.Titre + ' v' +
    OlfAboutDialog1.VersionNumero;
{$ELSE}
  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;
{$ENDIF}
{$IF defined(MACOS) and not defined(IOS)}
  mnuQuitter.Visible := false;
  mnuFichier.Visible := false;
  mnuAPropos.Parent := mnuMacOS;
  mnuAide.Visible := false;
{$ELSE}
  mnuMacOS.Visible := false;
{$ENDIF}
  Letters := TDictionary<byte, char>.Create;
  GeneratedWordsCount := 0;
  RestartGame;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Letters.Free;
end;

procedure TfrmMain.GenerateWords;
begin
  GeneratedWordsCount := GeneratedWordsCount + 1;

  tthread.CreateAnonymousThread(
    procedure
    var
      LGeneratedWordsCount: cardinal;
      Word: string;
      C: char;
      I, J, K, L: integer;
      WordsList: tlist<string>;
      AvailableLetters: string;
      LettersList: TDictionary<char, byte>;
    begin
      LGeneratedWordsCount := GeneratedWordsCount;

      WordsList := tlist<string>.Create;
      try
        WordsList.Add('');
        for I := 0 to Letters.count - 1 do
          for J := WordsList.count - 1 downto 0 do
            if (Letters[I] <> '?') then
              WordsList[J] := WordsList[J] + Letters[I]
            else
            begin
              Word := WordsList[J];

              LettersList := TDictionary<char, byte>.Create;
              try
                for K := 0 to Letters.count - 1 do
                begin
                  if (K < Word.Length) then
                    C := Word.chars[K]
                  else
                    C := Letters[K];
                  if LettersList.ContainsKey(C) then
                    LettersList[C] := LettersList[C] + 1
                  else
                    LettersList.Add(C, 1);

                  if LGeneratedWordsCount <> GeneratedWordsCount then
                    abort;
                end;

                AvailableLetters := edtAvailableLetters.Text;
                K := 0;
                while K < AvailableLetters.Length do
                begin
                  C := AvailableLetters.chars[K];
                  if LettersList.ContainsKey(C) and (LettersList[C] > 0) then
                  begin
                    LettersList[C] := LettersList[C] - 1;
                    AvailableLetters := AvailableLetters.Remove(K, 1);
                  end
                  else
                    inc(K);

                  if LGeneratedWordsCount <> GeneratedWordsCount then
                    abort;
                end;
              finally
                LettersList.Free;
              end;
              AvailableLetters := AvailableLetters + '?';

              for K := 0 to AvailableLetters.Length - 1 do
              begin
                if K = 0 then
                  WordsList[J] := Word + AvailableLetters.chars[K]
                else
                  WordsList.Add(Word + AvailableLetters.chars[K]);

                if LGeneratedWordsCount <> GeneratedWordsCount then
                  abort;
              end;
            end;
      except
        WordsList.Free;
        raise;
      end;

      WordsList.Sort(TComparer<string>.Construct(
        function(const a, b: string): integer
        begin
          if a = b then
            result := 0
          else if a > b then
            result := 1
          else
            result := -1;
        end));

      tthread.Queue(nil,
        procedure
        var
          I: integer;
        begin
          mmoWordsList.BeginUpdate;
          try
            mmoWordsList.Lines.Clear;
            for I := 0 to WordsList.count - 1 do
            begin
              mmoWordsList.Lines.Add(WordsList[I]);
              if LGeneratedWordsCount <> GeneratedWordsCount then
                abort;
            end;
          finally
            WordsList.Free;
            mmoWordsList.EndUpdate;
          end;
        end);
    end).Start;
end;

procedure TfrmMain.mnuLangueAnglaisClick(Sender: TObject);
begin
  CurrentLanguage := 'en';
end;

procedure TfrmMain.mnuLangueFrancaisClick(Sender: TObject);
begin
  CurrentLanguage := 'fr';
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.RestartGame;
begin
  tbLettersCount.Value := 5;
  lblNbLetters.Text := '5';
  tcGame.ActiveTab := tiLettersNumber;
  tbLettersCount.SetFocus;
end;

procedure TfrmMain.SetCurrentLanguage(const Value: string);
// var
// I: integer;
begin
  FCurrentLanguage := Value.tolower;
  TraduireTextes;

  // for I := 0 to mnuLangues.ChildrenCount - 1 do
  // if mnuLangues.Children[I] is TMenuItem then
  // (mnuLangues.Children[I] as TMenuItem).IsChecked := false;

  mnuLangueFrancais.IsChecked := (FCurrentLanguage = 'fr');
  mnuLangueAnglais.IsChecked := (FCurrentLanguage = 'en');
  // TODO : ajouter l'option pour l'allemand
  // TODO : ajouter l'option pour l'italien
  // TODO : ajouter l'option pour l'espagnol
  // TODO : ajouter l'option pour le portugais

  tconfig.Language := FCurrentLanguage;
  tconfig.Save;
end;

procedure TfrmMain.StartGame;
var
  I: integer;
  x: single;
  edt, FirstLetter: tedit;
begin
  Letters.Clear;

  FirstLetter := nil;
  while lLetters.ChildrenCount > 0 do
    lLetters.Children[0].Free;

  LettersCount := trunc(tbLettersCount.Value);
  if LettersCount < 1 then
    raise exception.Create('At least one letter is expected !');

  x := 5;
  edt := nil;
  for I := 1 to LettersCount do
  begin
    edt := tedit.Create(self);
    edt.Parent := lLetters;
    edt.Position.x := x;
    edt.Position.y := 5;
    edt.MaxLength := 1;
    edt.Width := 20;
    edt.CharCase := TEditCharCase.ecUpperCase;
    edt.OnChange := EdtLetterChanged;
    edt.Tag := I - 1;
    Letters.AddOrSetValue(edt.Tag, '?');
    x := x + edt.Width + 5;
    if not Assigned(FirstLetter) then
      FirstLetter := edt;
  end;

  edtAvailableLetters := tedit.Create(self);
  edtAvailableLetters.Parent := lLetters;
  edtAvailableLetters.Position.x := 5;
  edtAvailableLetters.Position.y := FirstLetter.Position.y +
    FirstLetter.Height + 5;
  if not Assigned(edt) then
    raise exception.Create('Oups');
  edtAvailableLetters.Width := edt.Position.x + edt.Width;
  // jusqu'à la dernière case des lettres présentes au dessus
  edtAvailableLetters.CharCase := TEditCharCase.ecUpperCase;
  edtAvailableLetters.OnChange := EdtListLettersChange;

  GenerateWords;

  tcGame.ActiveTab := tiWord;
  FirstLetter.SetFocus;
end;

procedure TfrmMain.tbLettersCountTracking(Sender: TObject);
begin
  lblNbLetters.Text := trunc(tbLettersCount.Value).ToString;
end;

procedure TfrmMain.TraduireTextes;
begin
  OlfAboutDialog1.Description.Clear;
  OlfAboutDialog1.Licence.Clear;
  if FCurrentLanguage = 'fr' then
  begin
    OlfAboutDialog1.Langue := tolfaboutdialoglang.fr;
    OlfAboutDialog1.Description.Add(CAboutBoxDescriptionFR);
    OlfAboutDialog1.Licence.Add(CAboutBoxLicenseFR);
    lblHowManyLetters.Text := 'Combien de &lettres ?';
    btnAbout.Text := '&A propos';
    btnClose.Text := '&Quitter';
    btnRestart.Text := '&Relancer';
    btnStart.Text := '&Go';
    mnuFichier.Text := '&Fichier';
    mnuQuitter.Text := btnClose.Text;
    mnuMot.Text := '&Mot';
    mnuRestart.Text := btnRestart.Text;
    mnuOutils.Text := 'O&utils';
    mnuLangues.Text := '&Langue';
    mnuAide.Text := '&Aide';
    mnuAPropos.Text := 'A p&ropos de ' + OlfAboutDialog1.Titre;
  end
  // TODO : ajouter traduction en allemand
  // TODO : ajouter traduction en italien
  // TODO : ajouter traduction en portugais
  // TODO : ajouter traduction en espagnol
  else
  begin
    OlfAboutDialog1.Langue := tolfaboutdialoglang.en;
    OlfAboutDialog1.Description.Add(CAboutBoxDescriptionen);
    OlfAboutDialog1.Licence.Add(CAboutBoxLicenseen);
    lblHowManyLetters.Text := 'How many &letters ?';
    btnAbout.Text := '&About';
    btnClose.Text := '&Quit';
    btnRestart.Text := '&Restart';
    btnStart.Text := '&Go';
    mnuFichier.Text := '&File';
    mnuQuitter.Text := btnClose.Text;
    mnuMot.Text := '&Word';
    mnuRestart.Text := btnRestart.Text;
    mnuOutils.Text := 'T&ools';
    mnuLangues.Text := '&Language';
    mnuAide.Text := '&Help';
    mnuAPropos.Text := 'Ab&out ' + OlfAboutDialog1.Titre;
  end;
  mnuLangueFrancais.Text := 'Français';
  mnuLangueAnglais.Text := 'English';
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
globalusemetal := true;

end.
