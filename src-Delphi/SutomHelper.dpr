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
