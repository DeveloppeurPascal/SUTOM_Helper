unit uConfig;

interface

type
  TConfig = class
  private
    class procedure SetLanguage(const Value: string); static;
    class function GetLanguage: string; static;
  protected
  public
    class property Language: string read GetLanguage write SetLanguage;
    class procedure Save;
  end;

implementation

uses
  System.IOUtils,
  Olf.RTL.Params,
  Olf.RTL.Language;

Const
  CParamLanguage = 'lng';

  { TConfig }

class function TConfig.GetLanguage: string;
begin
  result := tparams.getValue(CParamLanguage, GetCurrentLanguageISOCode);
end;

class procedure TConfig.Save;
begin
  tparams.Save;
end;

class procedure TConfig.SetLanguage(const Value: string);
begin
  tparams.setValue(CParamLanguage, Value);
end;

procedure InitParams;
var
  Folder: string;
begin
{$IFDEF DEBUG}
  Folder := tpath.combine(tpath.combine(tpath.GetDocumentsPath,
    'OlfSoftware-debug'), 'SUTOMHelper-debug');
{$ELSE}
  Folder := tpath.combine(tpath.combine(tpath.GetHomePath, 'OlfSoftware'),
    'SUTOMHelper');
{$ENDIF}
  tparams.setFolderName(Folder);
end;

initialization

InitParams;

end.
