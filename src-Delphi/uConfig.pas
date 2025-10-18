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
  Signature : 8b4a28427841153d8fb676b879befbed66397256
  ***************************************************************************
*)

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
