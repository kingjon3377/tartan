% tartan: A package to typeset Scottish Country Dance ball programs
%
% Copyright 2017 Jonathan Lovelace
% 
% This file may be distributed and/or modified under the conditions of the
% LaTeX Project Public License, either version 1.3c of this license or (at your
% option) any later version. The latest version of this license is in:
%
% http://www.latex-project.org/lppl.txt
%
% and version 1.3c or later is part of all ditributions of LaTeX version
% 2008/05/04 or later.
%
% Maintainer: Jonathan Lovelace
% Website:    https://shinecycle.wordpress.com
% Contact:    kingjon3377@gmail.com
%
% This work consists of this file, tartan.cls, and the sample document, example.tex.

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tartan}[2017/07/04 v0.9]
\LoadClass{article}
\RequirePackage{xstring}
\RequirePackage{etoolbox}
\RequirePackage{makecell}
\RequirePackage{relsize}
\RequirePackage{tocloft}
\RequirePackage{environ}
\RequirePackage{parskip}

\RequirePackage{ltablex}
\RequirePackage[paperwidth=5.5in,paperheight=4.5in]{geometry}
\RequirePackage{etoolbox}

% By default LaTeX prints a page number on every page; we hereby turn that feature off.
\pagestyle{empty}
\addtocontents{dances}{\protect\thispagestyle{empty}}

% This is the boilerplate to set up the list of dances/table of contents.
% It causes a \listofdances command to be created, which will typeset the table
% of contents.
% You'll want to put \clearpage (or \cleardoublepage) before and after \listofdances.
% TODO: Fix the unwanted hard space at the right of each contents line
\newlistof{dances}{dances}{\relax}
\cftpagenumbersoff{dances}

% Add a dance to the program. The parameters to \begin{scdance} are as follows:
% 1. The title or name of the dance.
% 2. The source of the dance.
% 3. The tempo of the dance: Jig, Reel, Strathspey, or Medley.
% 4. The length of the dance: RxB, where R is the number of times through the
%    dance and B is the length of each round in bars of music.
% 5. The formation in which the dance is danced: "2C (4C set)", "Sq. Set", "3C set", etc.
% TODO: Allow user to control whether source is printed with the dance directions.
% TODO: Provide an easier way to read dance directions from file
% Instead of using a nested table for named figures, we test (using the
% approach suggested by https://tex.stackexchange.com/a/55866 ) whether we're
% in a named-figure environment, and if so indent those rows of the table by a
% column, and if not make the row use up the remaining columns.
\NewEnviron{scdance}[5]{\par \noindent \refstepcounter{dances}\textbf{\large \uppercase{#1}\addcontentsline{dances}{dances}{\protect\numberline{\thedances}\textbf{#1}\protect\hfill#3\ifstrempty{#2}{\relax}{, #2}}\hfill(\StrLeft{#3}{1}#4) #5}\ifstrempty{#2}{\relax}{\\*\textit{#2}}\begin{tabularx}{\linewidth} { llX } \BODY \end{tabularx}}

\newbool{InNamedFigure}

% Typeset a series of (dance) figures indented from the main directions, as in
% the case of a complicated named figure (e.g. the Targe) or a meanwhile
% figure. Should only be used inside an scdance environment; unfortunately, due
% to the best implementation I could find or come up with that worked at all
% and allowed page breaks to fall in the middle of a named figure, nesting it
% inside itself has no effect.
\newcommand{\namedfigure}[1]{\global\booltrue{InNamedFigure} #1 \global\boolfalse{InNamedFigure}}
%\newenvironment{namedfigure}{\booltrue{InNamedFigure}}{\boolfalse{InNamedFigure}}

% Add a (dance) figure to the current dance. It takes the bar(s) this line of
% the directions describes as an optional parameter, and the movement as the
% required parameter. Should only be used inside an scdance environment (though
% it can be used inside a namedfigure environment).
\newcommand{\scfigure}[2][\relax]{\ifbool{InNamedFigure}{& #1 & #2}{#1 & \multicolumn2{l}{#2}} \tabularnewline}

% Add a break or intermission to the list of dances. It will *not* be printed
% between the dances' directions, but only in the table of contents. It takes
% what to call the intermission as its sole argument (in *square* brackets);
% this can be omitted, in which case it defaults to "Intermission".
\newcommand{\intermission}[1][Intermission]{\addtocontents{dances}{\protect\contentsline{dances}{\hfill \textbf{#1}}{}}\relax}

% Since Auld Lang Syne is always sung at the end of our Balls, and usually
% printed in the program if space permits, we provide a command to print that
% text, to simplify the LaTeX of the individual program. Note that this will go
% on its own page, adding page breaks before and (if there is another page)
% after it. (However, I believe that specifying a page break before calling
% this, using \clearpage, won't cause a double page break.)
\newcommand{\auldlangsyne}{%
\clearpage%
\vspace*{\fill}%
\settowidth{\versewidth}{And we'll tak' a right gude-willie waught,}
\begin{verse}[\versewidth]
\begin{altverse}
Should auld acquaintance be forgot,\\
And never brought to mind?\\
Should auld acquaintance be forgot,\\
And auld lang syne?\\
\textit{For auld lang syne, my Jo,\\
For auld lang syne,\\
We'll tak' a cup o' kindness yet,\\
For auld lang syne.}
\end{altverse}

\begin{altverse}
And there's a hand, my trusty fiere!\\
and gie's a hand o' thine!\\
And we'll tak' a right gude-willie waught,\\
for auld lang syne.\\
\textit{For auld lang syne, etc.}
\end{altverse}
\vfill
\end{verse}%
}
