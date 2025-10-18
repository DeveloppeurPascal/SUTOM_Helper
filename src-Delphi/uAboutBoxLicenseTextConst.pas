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
  Signature : bd52509fdc2a3cf90406e7a78b3bf9b299e7008d
  ***************************************************************************
*)

unit uAboutBoxLicenseTextConst;

interface

const
  CAboutBoxLicenseFR =
    'Ce programme est distribué en shareware. Si vous l''utilisez (surtout ' +
    'dans le cadre d''une activité commerciale ou rémunératrice), merci de ne '
    + 'pas oublier l''auteur et de contribuer à son développement par l''achat '
    + 'd''une licence.' + slinebreak + slinebreak +
    'Ce logiciel est fourni tel quel, avec peut-être des bogues ou sans. Aucune '
    + 'garantie sur son fonctionnement ni sur les données traitées n''est proposée. '
    + 'Faites des backups !';

  CAboutBoxLicenseEN =
    'This program is distributed as shareware. If you use it (especially for ' +
    'commercial or income-generating purposes), please remember the author and '
    + 'contribute to its development by purchasing a license.' + slinebreak +
    slinebreak +
    'This software is supplied as is, with or without bugs. No warranty is offered '
    + 'as to its operation or the data processed. Make backups!';

  CAboutBoxLicenseDE = CAboutBoxLicenseEN; // TODO : traduire en allemand
  CAboutBoxLicenseIT = CAboutBoxLicenseEN; // TODO : traduire en italien
  CAboutBoxLicensePT = CAboutBoxLicenseEN; // TODO : traduire en portugais
  CAboutBoxLicenseSP = CAboutBoxLicenseEN; // TODO : traduire en espagnol

implementation

end.
