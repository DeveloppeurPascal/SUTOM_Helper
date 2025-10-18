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
  Signature : 5c686480fcddb96a3eb7f6062f28d5f25e0ae592
  ***************************************************************************
*)

program SutomHelper;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  u_urlOpen in 'lib-externes\librairies\u_urlOpen.pas',
  Olf.FMX.AboutDialog in 'lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in 'lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  uDMLogo in 'uDMLogo.pas' {dmLogo: TDataModule},
  uAboutBoxDescriptionTextConst in 'uAboutBoxDescriptionTextConst.pas',
  uAboutBoxLicenseTextConst in 'uAboutBoxLicenseTextConst.pas',
  Olf.RTL.Language in 'lib-externes\librairies\Olf.RTL.Language.pas',
  Olf.RTL.Params in 'lib-externes\librairies\Olf.RTL.Params.pas',
  uConfig in 'uConfig.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmLogo, dmLogo);
  Application.Run;
end.
