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
  FMX.Memo;

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
    procedure btnAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbLettersCountTracking(Sender: TObject);
  private
    { Déclarations privées }
    procedure RestartGame;
    procedure StartGame;
    procedure GenerateWords;
    procedure EdtLetterChanged(Sender: TObject);
    procedure EdtListLettersChange(Sender: TObject);
  public
    { Déclarations publiques }
    LettersCount: byte;
    Letters: TDictionary<byte, char>;
    GeneratedWordsCount: cardinal;
    edtAvailableLetters: tedit;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.Generics.Defaults,
  u_urlOpen;

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

  x := 5;
  LettersCount := trunc(tbLettersCount.Value);
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
  edtAvailableLetters.MaxLength := LettersCount;
  edtAvailableLetters.Width := edtAvailableLetters.MaxLength * 10;
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

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
