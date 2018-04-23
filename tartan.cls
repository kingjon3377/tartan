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
\LoadClass[twoside]{article}
\RequirePackage{ucs}
\RequirePackage[utf8x]{inputenc}
\RequirePackage{xstring}
\RequirePackage{etoolbox}
\RequirePackage{makecell}
\RequirePackage{relsize}
\RequirePackage{tocloft}
\RequirePackage{environ}
\RequirePackage{parskip}
\RequirePackage{needspace}

\RequirePackage{ltablex}
\RequirePackage[landscape,paperheight=5.5in,paperwidth=4.5in,top=.3in,bottom=.25in,left=.2in,right=.25in]{geometry}
\RequirePackage{etoolbox}
\RequirePackage{suffix}

\RequirePackage{verse}

\RequirePackage{graphicx}
\RequirePackage{nicefrac}
\raggedbottom

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
% 2. The source of the dance. TODO: We want a brief form for the ToC and a fuller form for the briefing
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
\NewEnviron{scdance}[5]{\pagebreak[2]\Needspace{4\baselineskip}\par\noindent\refstepcounter{dances}%
	\textbf{\textsf{\large \uppercase{#1}%
		\addcontentsline{dances}{dances}{%
			\protect\numberline{\thedances}\textbf{#1}\protect\hfill#3\ifstrempty{#2}{\relax}{, #2}%
		}%
		\nopagebreak[4]%
		\hfill(\StrLeft{#3}{1}#4) #5\nopagebreak[4]%
	}}%
	\nopagebreak[4]%
	\ifstrempty{#2}{\relax}{\nopagebreak[4]\\*\nopagebreak[4]{\small \textit{#2}}\nopagebreak[4]}%
	\nopagebreak[4]\begin{tabularx}{\linewidth}{llX} \nopagebreak[4]\BODY \end{tabularx}\pagebreak[2]}

\newcounter{NamedFigureDepth}

% Typeset a series of (dance) figures indented from the main directions, as in
% the case of a complicated named figure (e.g. the Targe) or a meanwhile
% figure. Should only be used inside an scdance environment; unfortunately, due
% to the best implementation I could find or come up with that worked at all
% and allowed page breaks to fall in the middle of a named figure, nesting it
% inside itself has no effect.
\newcommand{\namedfigure}[1]{\addtocounter{NamedFigureDepth}{1} #1 \addtocounter{NamedFigureDepth}{-1}}
%\newenvironment{namedfigure}{\addtocounter{NamedFigureDepth}{1}}{\addtocounter{NamedFigureDepth}{-1}}

% Add a (dance) figure to the current dance. It takes the bar(s) this line of
% the directions describes as an optional parameter, and the movement as the
% required parameter. Should only be used inside an scdance environment (though
% it can be used inside a namedfigure environment).
\newcommand{\scfigure}[2][\relax]{%
	\ifthenelse{\value{NamedFigureDepth}>0}{%
		& #1 & #2\tabularnewline\nopagebreak[3]%
	}{%
		#1 & \multicolumn{2}{p{.9\linewidth}}{#2}\tabularnewline\pagebreak[1]%
	}}

% Add a break or intermission to the list of dances. It will *not* be printed
% between the dances' directions, but only in the table of contents. It takes
% what to call the intermission as its sole argument (in *square* brackets);
% this can be omitted, in which case it defaults to "Intermission".
\newcommand{\intermission}[1][Intermission]{%
	\addtocontents{dances}{\protect\contentsline{dances}{\hfill \textbf{#1}}{}}\relax}

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
\nopagebreak{\raggedleft\small Robert Burns\hspace*{5em}\par}
}

% Inserts an image. This image is always centered and is resized to mostly fill
% the page horizontally and vertically (or as close as possible without
% exceeding those dimensions or breaking its aspect ratio). The sole argument
% is the filename of the image to insert, including its path relative to the
% document (or any of the standard LaTeX paths), but *not* including its
% extension. Only PNG, JPEG, and PDF format images are supported. (See standard
% LaTeX documentation of the \includegraphics command for more details.)
\newcommand\tartanimage[1]{%
	\begin{center}%
		\includegraphics[width=.9\textwidth,height=.9\textheight,keepaspectratio]{#1}%
	\end{center}}

\newcommand\@covergroupname{}
\newcommand\@titlegroupname{}
\newcommand\@covereventname{}
\newcommand\@titleeventname{}
\newcommand\@coverdate{}
\newcommand\@titledate{}
\newcommand\@coverhall{}
\newcommand\@titlehall{}
\newcommand\@halladdress{}
\newcommand\@balltimes{}
\newcommand\@musicians{}

% The \tartangroupname command (re)defines the name of the group for the cover and
% title page; the starred variant (re)defines it for only the title page.
\newcommand\tartangroupname[1]{\renewcommand{\@covergroupname}{#1}\renewcommand{\@titlegroupname}{#1}}
\WithSuffix\newcommand\tartangroupname*[1]{\renewcommand{\@titlegroupname}{#1}}

% The \tartanballname command (re)defines the name of the event for the cover
% and title page; the starred variant (re)defines it for only the title page.
\newcommand\tartanballname[1]{\renewcommand{\@covereventname}{#1}\renewcommand{\@titleeventname}{#1}}
\WithSuffix\newcommand\tartanballname*[1]{\renewcommand{\@titleeventname}{#1}}

% The \tartanballdate command (re)defines the date of the event for the cover
% and title page; the starred variant (re)defines it for only the title page.
\newcommand\tartanballdate[1]{\renewcommand{\@coverdate}{#1}\renewcommand{\@titledate}{#1}}
\WithSuffix\newcommand\tartanballdate*[1]{\renewcommand{\@titledate}{#1}}

% The \tartanhall command (re)defines the location of the event for the cover
% and title page; the starred variant (re)defines it for only the title page.
\newcommand\tartanhall[1]{\renewcommand{\@coverhall}{#1}\renewcommand{\@titlehall}{#1}}
\WithSuffix\newcommand\tartanhall*[1]{\renewcommand{\@titlehall}{#1}}

% The \tartanhalladdress command (re)defines the address of the location of the
% event for the title page.
\newcommand\tartanhalladdress[1]{\renewcommand{\@halladdress}{#1}}

% The \tartantimes command (re)defines the time(s) associated with the event for the title page.
\newcommand\tartantimes[1]{\renewcommand{\@balltimes}{#1}}

% The \tartanmusicians command (re)defines the names of the musicians for the title page.
\newcommand\tartanmusicians[1]{\renewcommand{\@musicians}{#1}}

% The \tartancover command lays out the cover, without an image, with the group
% and event name centered in large type at the top and the date and location of
% the event in smaller type at the bottom of the page. Because this is expected
% to be the first page of the document, we don't bother clearing the page (i.e.
% starting a new page if the current one has any text on it) within it, and we
% also leave starting a new page after it to the caller.
\newcommand\tartancover{%
	\begin{center}%
		\LARGE\ifdefempty{\@covergroupname}{\relax}{\@covergroupname\\*}%
		\ifdefempty{\@covereventname}{\relax}{\@covereventname\\*}%
		\vspace*{\fill}\Large%
		\ifdefempty{\@coverdate}{\relax}{\@coverdate\ifdefempty{\@coverhall}{\relax}{\\*}}%
		\ifdefempty{\@coverhall}{\relax}{\@coverhall}%
	\normalsize\end{center}}

% The \tartanimagecover takes the filename of an image (with path but without
% extension, as in \tartanimage) and produces a cover with the name of the
% group and event above the image and the date and location of the event below
% it. It is essentially the same as \tartancover except taking the name of an
% image to add in the middle. To keep the image from pushing the items below it
% off the page, using a wide-but-narrow image is recommended.
\newcommand\tartanimagecover[1]{%
	\enlargethispage{3\baselineskip}%
	\begin{center}%
		\LARGE\ifdefempty{\@covergroupname}{\relax}{\@covergroupname\\*}%
		\ifdefempty{\@covereventname}{\relax}{\@covereventname\\*}%
		\vfill\includegraphics[keepaspectratio,height=.75\textheight,width=.9\textwidth]{#1}\vfill%
		\Large\ifdefempty{\@coverdate}{\relax}{\@coverdate\ifdefempty{\@coverhall}{\relax}{\\*}}%
		\ifdefempty{\@coverhall}{\relax}{\@coverhall}%
	\normalsize\end{center}}

% The \maketartantitle command lays out the title page, including the name of
% the group, the name of the event, the location, the address (in parentheses
% and smaller type if specified), the specified times, and the names of the
% musicians. As with \tartancover, it does not force a page break either before
% or after the "title page."
\newcommand\maketartantitle{%
	\begin{center}%
		{%
			{%
				\sffamily\Large%
				\ifdefempty{\@titlegroupname}{\relax}{%
					\textbf{\@titlegroupname}\\*}%
				\ifdefempty{\@titleeventname}{\relax}{%
					\textbf{\@titleeventname}\\*}%
				\ifdefempty{\@titlegroupname}{\ifdefempty{\@titleeventname}{\relax}{\vskip \parskip}}{\vfill}%
				\ifdefempty{\@titlehall}{\relax}{\@titlehall\ifdefempty{\@halladdress}{\vfill}{\\*}}%
				\ifdefempty{\@halladdress}{\relax}%
					{{\large(\@halladdress)}\vfill}%
				\ifdefempty{\@titledate}{\relax}{\@titledate\\*\vspace*{\fill}}%
				\large\ifdefempty{\@balltimes}{\relax}{%
					\@balltimes\\*\vspace*{\fill}}%
				\ifdefempty{\@musicians}{\relax}{{Music by\\*\textbf{\@musicians}}}%
			}%
		}%
	\end{center}}

% The \cleartoverso command starts a new page, inserting an additional blank
% page before it if necessary to put subsequent content on a left-hand (or top,
% in the way programs are printed in our group) page.
\newcommand{\cleartoverso}{\clearpage\ifodd\c@page\hbox{}\newpage\fi}
