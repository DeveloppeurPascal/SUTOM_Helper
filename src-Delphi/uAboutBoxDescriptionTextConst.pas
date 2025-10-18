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
  Signature : 80bfb4204d4e33567dbcdbd04ce31a8ae5acbab6
  ***************************************************************************
*)

unit uAboutBoxDescriptionTextConst;

interface

const
  CAboutBoxDescriptionFR =
    'SUTOM Helper est vous aide à résoudre les challenges de mots '
    + 'à trouver comme SUTOM (https://sutom.nocle.fr), WORDLE (https://wordle.louan.me), '
    + 'TUSMO (https://www.tusmo.xyz/), des mots croisés ou fléchés et les autres '
    + 'quelle que soit la langue utilisée.' + slinebreak + '' + slinebreak +
    'Choisissez le nombre de lettres, indiquez pour chaque position la lettre à '
    + 'utiliser puis la liste des lettres possibles afin d''obtenir la liste des '
    + 'combinaisons possibles. A vous de faire le choix parmi elles en cultivant '
    + 'votre vocabulaire.' + slinebreak + '' + slinebreak +
    'Et profitez en pour ouvrir un dictionnaire et apprendre les mots que vous '
    + 'ne connaissiez pas.';

  CAboutBoxDescriptionEN =
    'SUTOM Helper help you to solve word-finding challenges such as SUTOM '
    + '(https://sutom.nocle.fr), WORDLE (https://wordle.louan.me), TUSMO ' +
    '(https://www.tusmo.xyz/), crosswords or arrow puzzles and others in any language.'
    + slinebreak + '' + slinebreak +
    'Choose the number of letters, indicate for each position the letter to be '
    + 'used and then the list of possible letters to obtain the list of possible '
    + 'combinations. It''s up to you to choose from among them as you build up '
    + 'your vocabulary.' + slinebreak + '' + slinebreak +
    'And take the opportunity to open a dictionary and learn the words you didn''t know.';

  CAboutBoxDescriptionDE = CAboutBoxDescriptionEN;
  // TODO : traduire en allemand
  CAboutBoxDescriptionIT = CAboutBoxDescriptionEN; // TODO : traduire en italien
  CAboutBoxDescriptionPT = CAboutBoxDescriptionEN;
  // TODO : traduire en portugais
  CAboutBoxDescriptionSP = CAboutBoxDescriptionEN;
  // TODO : traduire en espagnol

implementation

end.
