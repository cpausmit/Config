%%
%% This is file `foils.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% foiltex.dtx  (with options: `package')
%% ********************************************************************
%% Copyright (C) 1995,1997 IBM Corporation
%% This file is part of the FoilTeX package.   Use of this is governed
%% by explicit restrictions.  These can be found in the header of the
%% foiltex.ins file.
%% 
%% Questions, comments or suggestions concerning this program can be
%% sent to
%%     James (Jim) Hafner
%%     IBM Research Division
%%     Almaden Research Center, K53-B2
%%     650 Harry Road
%%     San Jose, CA 95120-6099
%%     email: hafner@almaden.ibm.com
%% ********************************************************************
%%
%% These files are updated versions of the FoilTeX package for use with
%% the new LaTeX2e.  There are many enhancements and a few bugs
%% have been fixed.  Undoubtedly there are many more.  Contact
%% the author if you find any bugs or have suggestions for improvement
%% of this suite of files.
%% ********************************************************************
\def\filedate{1998/12/06}
\def\foiltexversion{3.0}
\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\ProvidesClass{cpfoils}
       [\filedate\space v\foiltexversion\space
        FoilTeX Class File, Copyright IBM 1995,1997]
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
%%
\newcommand{\meeting}[1]{\renewcommand{\meeting}{#1}}
\newcommand{\institute}[1]{\renewcommand{\institute}{#1}}
\newcommand{\speaker}[1]{\renewcommand{\speaker}{#1}}
\newif\if@openbib \@openbibfalse
\newif\if@landscape \@landscapefalse
\newif\if@dvips \@dvipsfalse
\newif\if@header@rule \@header@rulefalse
\newif\if@footer@rule \@footer@rulefalse
\newif\if@magscaleECfonts \@magscaleECfontsfalse
\newif\if@useDCfonts \@useDCfontsfalse
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{35mmSlide}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {7.33in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}%
    \@landscapetrue}
\newcommand\@ptsize{}
\DeclareOption{17pt}{\renewcommand\@ptsize{17}}
\DeclareOption{20pt}{\renewcommand\@ptsize{20}}
\DeclareOption{25pt}{\renewcommand\@ptsize{25}}
\DeclareOption{30pt}{\renewcommand\@ptsize{30}}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{openbib}{\@openbibtrue}
\DeclareOption{headrule}{\@header@rulefalse}
%\DeclareOption{headrule}{\@header@ruletrue}
\DeclareOption{footrule}{\@footer@ruletrue}
\DeclareOption{dvips}{\@dvipstrue}
\DeclareOption{magscalefonts}{\@magscaleECfontstrue}
\DeclareOption{useDCfonts}{\@useDCfontstrue}
\DeclareOption{a5paper}{%
    \ClassWarning{FoilTeX}{No 'a5paper' option for foils.}}
\DeclareOption{b5paper}{%
    \ClassWarning{FoilTeX}{No 'b5paper' option for foils.}}
\DeclareOption{legalpaper}{%
    \ClassWarning{FoilTeX}{No 'legalpaper' option for foils.}}
\DeclareOption{executivepaper}{%
    \ClassWarning{FoilTeX}{No 'executivepaper' option for foils.}}
\DeclareOption{10pt}{%
    \ClassWarning{FoilTeX}{No '10pt' foils option, try 17pt, 20pt, 25pt
     or 30pt (defaulting to 20pt).}}
\DeclareOption{11pt}{%
    \ClassWarning{FoilTeX}{No '11pt' foils option, try 17pt, 20pt, 25pt
    or 30pt (defaulting to 20pt).}}
\DeclareOption{12pt}{%
    \ClassWarning{FoilTeX}{No '11pt' foils option, try 17pt, 20pt, 25pt
    or 30pt (defaulting to 20pt).}}
\DeclareOption{oneside}{}
\DeclareOption{twoside}{%
    \ClassWarning{FoilTeX}{No 'twoside' option for foils.}}
\DeclareOption{openright}{%
    \ClassWarning{FoilTeX}{No 'openright' option for foils.}}
\DeclareOption{openany}{%
    \ClassWarning{FoilTeX}{No 'openany' option for foils.}}
\DeclareOption{titlepage}{}
\DeclareOption{notitlepage}{%
    \ClassWarning{FoilTeX}{No 'notitlepage' option for foils.}}
\DeclareOption{onecolumn}{}
\DeclareOption{twocolumn}{%
    \ClassWarning{FoilTeX}{No 'twocolumn' layout for foils.}}
\ExecuteOptions{letterpaper,20pt,final}
\InputIfFileExists{foiltex.cfg}{}{}
\ProcessOptions
\if@landscape
  \if@dvips{\special{landscape}}\fi
\fi
\input{fltfonts.def}
\input{foil\@ptsize.clo}
\DeclareRobustCommand\FoilTeX{{\normalfont%
   {\sffamily Foil}\kern-.03em{\rmfamily\TeX}}}
\renewcommand\_{\leavevmode\kern.06em\vbox{\hrule width.4em height.12ex}}
\renewcommand\footnoterule{\kern-3\p@\hrule width.4\textwidth\kern2.6\p@}
\newcommand\@makefntext[1]{\parindent 1em\noindent
 \hbox to 1.8em{\hss\@makefnmark}#1}
\def\@makefnmark{\hbox{$^{\mathsf{\@thefnmark}}\m@th$}}
\let\@oldmarginpar\marginpar
\def\@marginragged{\if@reversemargin\raggedleft\else\raggedright\fi}
\def\@foilmarginpar{\@ifnextchar[{\@foilmarginparRL}{\@foilmarginparR}}
\def\@foilmarginparRL[#1]#2{%
  \@oldmarginpar[{\@marginragged #1\par}]{{\@marginragged #2\par}}}
\def\@foilmarginparR#1{\@oldmarginpar{\@marginragged #1\par}}
\let\marginpar\@foilmarginpar
\def\Black#1{#1}
\def\globalColor#1{#1}
\newcommand\today{\ifcase\month\or
 January\or February\or March\or April\or May\or June\or
 July\or August\or September\or October\or November\or December\fi
 \space\number\day, \number\year}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{1}
\setlength\parskip{0\p@ \@plus 4\p@ \@minus 4\p@}
\if@compatibility
 \setlength\parindent{0\p@}
 \setlength\jot{3\p@}
\else
 \setlength\parindent{0\p@}
 \setlength\jot{10\p@}
\fi
\righthyphenmin=100
\lefthyphenmin=100
\def\@eqnnum{\hbox{\reset@font\sffamily (\theequation)}}
\renewcommand\theequation{\arabic{equation}}
\if@compatibility
  \newenvironment{titlepage}{%
    \@restonecolfalse \newpage \thispagestyle{empty}
      \setcounter{page}{0}}{\newpage}
 \newcommand\@pnumwidth{1.55em}
 \newcommand\@tocrmarg {2.55em}
 \newcommand\@dotsep{4.5}
\fi
\def\sloppyfoils{\tolerance 9000 \hfuzz 2\p@ \vfuzz 2\p@ \hbadness 2000}
\sloppyfoils
\setlength\leftmargini{25\p@}
\setlength\leftmarginii{22\p@}
\setlength\leftmarginiii{18.7\p@}
\setlength\leftmarginiv{17\p@}
\setlength\leftmarginv{10\p@}
\setlength\leftmarginvi{10\p@}
\setlength\leftmargin\leftmargini
\if@compatibility
  \setlength\labelwidth\leftmargini\advance\labelwidth-\labelsep
  \setlength\labelsep{.5em}
\else
  \setlength\labelsep{10\p@}
  \setlength\labelwidth\leftmargini\advance\labelwidth-\labelsep
\fi
\setlength\partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}
\newcommand\@listIa{\leftmargin\leftmargini
\topsep 14\p@ \@plus 2\p@ \@minus 4\p@
\parsep 14\p@ \@plus 4\p@ \@minus 4\p@
\itemsep 14\p@ \@plus 4\p@ \@minus 2\p@}
\newcommand\@listIb{\leftmargin\leftmargini
\topsep 8\p@ \@plus 2\p@ \@minus 2\p@
\parsep 2\p@ \@plus 1\p@ \@minus 1\p@
\itemsep \parsep}
\newcommand\@listIc{\leftmargin\leftmargini
\topsep 6\p@ \@plus 1\p@ \@minus 1\p@
\parsep 2\p@ \@plus 1\p@ \@minus 1\p@
\itemsep \parsep}
\newcommand\@listId{\leftmargin\leftmargini
\topsep 4\p@ \@plus 1\p@ \@minus 1\p@
\parsep 2\p@ \@plus 1\p@ \@minus 1\p@
\itemsep \parsep}
\newcommand\@listii{\leftmargin\leftmarginii
 \labelwidth\leftmarginii\advance\labelwidth-\labelsep
 \topsep \z@
 \parsep \z@
 \itemsep \parsep}
\newcommand\@listiii{\leftmargin\leftmarginiii
 \labelwidth\leftmarginiii\advance\labelwidth-\labelsep
 \partopsep 1\p@ \@plus 0\p@ \@minus 1\p@
 \topsep \z@
 \parsep \z@
 \itemsep \topsep}
\newcommand\@listiv{\leftmargin\leftmarginiv
 \labelwidth\leftmarginiv\advance\labelwidth-\labelsep}
\newcommand\@listv{\leftmargin\leftmarginv
 \labelwidth\leftmarginv\advance\labelwidth-\labelsep}
\newcommand\@listvi{\leftmargin\leftmarginvi
 \labelwidth\leftmarginvi\advance\labelwidth-\labelsep}
\if@compatibility
 \let\zerolistvertdimens\relax
\else
 \def\zerolistvertdimens{\parskip0pt\topsep0pt\partopsep0pt%
    \parsep0pt\itemsep0pt}
\fi
\if@compatibility
 \def\@item[#1]{%
   \if@noparitem
     \@donoparitem
   \else
     \if@inlabel \indent \par \fi
     \ifhmode \unskip\unskip \par \fi
     \if@newlist
       \if@nobreak
         \@nbitem
       \else
         \addpenalty\@beginparpenalty
         \addvspace\@topsep \addvspace{-\parskip}
       \fi
     \else
       \addpenalty\@itempenalty \addvspace\itemsep
     \fi
     \global\@inlabeltrue
   \fi
 \everypar{\global\@minipagefalse\global\@newlistfalse
   \if@inlabel
     \global\@inlabelfalse \hskip -\parindent \box\@labels \penalty\z@
   \fi
   \everypar{}}
 \global\@nobreakfalse
 \if@noitemarg \@noitemargfalse
   \if@nmbrlist \refstepcounter{\@listctr}\fi
 \fi
 \sbox\@tempboxa{\globalColor{\makelabel{#1}}} \global\setbox\@labels
 \hbox{\unhbox\@labels \hskip \itemindent
   \hskip -\labelwidth \hskip -\labelsep
   \ifdim
     \wd\@tempboxa >\labelwidth \box\@tempboxa
   \else
     \hbox to\labelwidth {\unhbox\@tempboxa}
   \fi
   \hskip \labelsep}
 \ignorespaces
 }
\fi
\renewcommand\theenumi{\arabic{enumi}}
\renewcommand\theenumii{\alph{enumii}}
\renewcommand\theenumiii{\roman{enumiii}}
\renewcommand\theenumiv{\Alph{enumiv}}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\newcommand\labelitemi{$\m@th\bullet$}
\newcommand\labelitemii{{\normalfont\bfseries --}}
\newcommand\labelitemiii{$\m@th\ast$}
\newcommand\labelitemiv{$\m@th\cdot$}
\newcommand\descriptionlabel[1]{\hspace\labelsep \normalfont\bfseries #1}
\newenvironment{description}{\list{}{\labelwidth\z@
  \itemindent-\leftmargin \let\makelabel\descriptionlabel}}{\endlist}
\newenvironment{verse}{\let\\=\@centercr
 \list{}{\itemsep\z@ \itemindent -1.5em\listparindent \itemindent
 \rightmargin\leftmargin\advance\leftmargin 1.5em}\item[]}{\endlist}
\newenvironment{quotation}{\list{}{\listparindent 1.5em
 \itemindent\listparindent
 \rightmargin\leftmargin \parsep 0\p@ \@plus 1\p@}\item[]}{\endlist}
\newenvironment{quote}{\list{}{\rightmargin\leftmargin}\item[]}{\endlist}
\setlength\oddsidemargin{-38\p@}
\setlength\evensidemargin{-38\p@}
\setlength\topmargin{0\p@}
\setlength\headsep{40\p@} % was \setlength\headsep{60\p@}
\setlength\headheight{10\p@}

\if@compatibility
 \setlength\footheight{25\p@}
 \setlength\footskip{25\p@}
 \setlength\@maxsep{20\p@}
 \setlength\@dblmaxsep{20\p@}
\else
 \newdimen\head@footskip
 \setlength\head@footskip{0.9in}
 \setlength\footskip{\head@footskip}
 \addtolength\footskip{-\headsep}
 \addtolength\footskip{-\headheight}
\fi

\setlength\footnotesep{5\p@}
\setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
\skip\@mpfootins = \skip\footins
\setlength\marginparwidth{54\p@}
\setlength\marginparsep{10\p@}
\setlength\marginparpush{5\p@}

\if@compatibility
 \message{ Style provides compatibility. }
 \setlength\textheight{7.6in}
 \setlength\textwidth{6.5in}
 \let\@rotdimens\relax
 \let\@defaultdimens\relax
\else
 \message{ Style provides non-compatibility. }
 \newdimen\@foilheight
 \newdimen\@foilwidth
 \setlength\voffset{-0.3in}
 \setlength\textheight{\paperheight}
 \addtolength\textheight{-1.0in}
 \addtolength\textheight{-\head@footskip}
 % CP tune
 \addtolength\textheight{+0.2in}
 % CP tune ends
 \setlength\textwidth{\paperwidth}
 \addtolength\textwidth{-1.0in}
 % CP tune
 \addtolength\textwidth{+0.4in}
 % CP tune ends
 \def\setp@gelayoutdimens{%
  \setlength\head@footskip{\footskip}
  \addtolength\head@footskip{\headsep}
  \addtolength\head@footskip{\headheight}
  \setlength\@foilheight{\textheight}
  \addtolength\@foilheight{\head@footskip}
  \setlength\@foilwidth{\textwidth}
%%CP here is the place!!
 \def\@rotdimens{\setlength\hoffset{0.42in}\setlength\topmargin{-0.35in}
        \setlength\footskip{0.3in}% end of my changes
% Good stuff
% \def\@rotdimens{\setlength\hoffset{0.3in}\setlength\topmargin{-0.35in}
%        \setlength\footskip{0.3in}% end of my changes
%%        \setlength\footskip{0.0in}% end of my changes
        \textheight\@foilwidth \textwidth\@foilheight
        \addtolength\textheight{-\head@footskip}
        \vsize\textheight \hsize\textwidth \linewidth\textwidth
        \columnwidth\textwidth \@colroom\textheight \@colht\textheight}
  \def\@defaultdimens{\setlength\hoffset{0in}\setlength\topmargin{0.4in}
        \addtolength\footskip{0.0in}% end of my changes
        \textheight\@foilheight \textwidth\@foilwidth
        \addtolength\textheight{-\head@footskip}
        \vsize\textheight \hsize\textwidth \linewidth\textwidth
        \columnwidth\textwidth \@colroom\textheight \@colht\textheight}
   \@defaultdimens}   % end of \def\setp@gelayoutdimens
\fi

\AtBeginDocument{\if@compatibility\else\setp@gelayoutdimens\fi}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\@beginparpenalty -\@lowpenalty
\@endparpenalty -\@lowpenalty
\@itempenalty -\@lowpenalty
\setlength\arraycolsep{10\p@}
\setlength\tabcolsep{12\p@}
\setlength\arrayrulewidth{1\p@}
\setlength\doublerulesep{3\p@}
\setlength\tabbingsep\labelsep
\if@compatibility
 \setlength\fboxsep{6\p@}
\else
 \setlength\fboxsep{10\p@}
\fi
\setlength\fboxrule{1\p@}
\newlength\abovetitleskip
\newlength\titleauthorskip
\newlength\authorauthorskip
\newlength\authordateskip
\newlength\dateabstractskip
\setlength\abovetitleskip{2em}
\setlength\titleauthorskip{1.5em}
\setlength\authorauthorskip{.5em}
\setlength\authordateskip{1em}
\setlength\dateabstractskip{1em}
\def\maketitle{\par
  \begingroup
    \setcounter{page}{0}
    \def\thefootnote{\fnsymbol{footnote}} \newpage
    \@maketitle
    \thispagestyle{foilheadings}
    \@thanks
  \endgroup
  \setcounter{footnote}{0}
  \let\maketitle\relax \let\@maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax%
}
\def\@maketitle{\newpage
  \zerolistvertdimens
  \if@compatibility\else
    \advance\abovetitleskip -\baselineskip % \null adds this space
  \fi
  \null\vskip\abovetitleskip
  \begin{center}
     {\Huge\it\black\@title\par}
     \vskip\titleauthorskip
     {\lineskip\authorauthorskip\black
       %\begin{tabular}[t]{c}{\@author}\end{tabular}
       \begin{center}{\@author\\{\it \institute}}\end{center}
       \par}
%     \vskip\authordateskip{{\black\@date}}
     \vfill{\black\large\meeting\par\@date}
  \end{center}
%  \par\vfil
}
\newcommand\abstractname{Abstract}
\newenvironment{abstract}{%
  \if@compatibility
    \dateabstractskip\parskip
    \advance\dateabstractskip\topsep
    \advance\dateabstractskip\baselineskip
  \fi
  \vskip\dateabstractskip
  \centerline{\reset@font\bfseries\abstractname}
  \if@compatibility\vspace{-.5em}\vspace{0\p@}\fi
  \list{}{\listparindent 1.5em
          \itemindent\listparindent \rightmargin\leftmargin
          \zerolistvertdimens
         }\item[]%
  }{\endlist\vfill}
\newcommand\leftheader[1]{\gdef\@leftheader{#1}}
\newcommand\rightheader[1]{\gdef\@rightheader{#1}}
\newcommand\rightfooter[1]{\gdef\@rightfooter{#1}}
\leftheader{}
\rightheader{}
\rightfooter{\quad\textsf{\thepage}}
\newif\ifLogo \Logotrue
\newcommand\LogoOff{\Logofalse}
\newcommand\LogoOn{\Logotrue}
\newcommand\Restriction[1]{\gdef\@Restriction{#1}}
\Restriction{}
\newcommand\MyLogo[1]{\gdef\@MyLogo{\ifLogo{#1}\else\fi}}
\MyLogo{-- Typeset by CP \FoilTeX\ --}
\newsavebox\@tempfootbox
\newdimen\@tempfootht

\newcommand\ps@foilheadings{\let\@mkboth\@gobbletwo
  \def\@oddhead{%
    \ifnum \c@page>0
      {\Black{%
      \if@header@rule\hbox to\z@{\blue \rule[-30\p@]{\textwidth}{8\p@}\hss}\fi
      \reset@font\tiny
      \@leftheader\hfil\@rightheader}}%
    \else
      \hfill
    \fi}%
  \def\@oddfoot{%
    \ifnum \c@page>0
      {\Black{%
      \sbox\@tempfootbox{\tiny\@MyLogo\ \@Restriction\hfil\@rightfooter}%
      \@tempfootht\ht\@tempfootbox
      \advance\@tempfootht 5.66666\p@
      \if@footer@rule%
      \hbox to\z@{\rule[\@tempfootht]{\textwidth}{1\p@}\hss}%
      \fi%
      \reset@font\tiny
     \@MyLogo\ \@Restriction\hfil\@rightfooter}}%
    \else
      {\Black{\hfil\reset@font\footnotesize%
       \@MyLogo\ \@Restriction\hfil}}%
    \fi}%
  \let\@evenhead\@oddhead%
  \let\@evenfoot\@oddfoot%
}

\ps@foilheadings
\pagenumbering{arabic}
\onecolumn
\mark{{}{}}

\newcommand\ps@cpfoilheadings{\let\@mkboth\@gobbletwo
  \def\@oddhead{%
    \ifnum \c@page>0
      {\black{%
      \if@header@rule\hbox to\z@{\blue \rule[-30\p@]{\textwidth}{4\p@}\hss}\fi
      \reset@font\tiny
      \@leftheader\hfil\@rightheader}}%
    \else
      \hfill
    \fi}%
  \def\@oddfoot{%
    \ifnum \c@page>0
      {\Black{%
      \sbox\@tempfootbox{\tiny\@MyLogo\ \@Restriction\hfil\@rightfooter}%
      \@tempfootht\ht\@tempfootbox
      \advance\@tempfootht 5.66666\p@
      \if@footer@rule%
      \hbox to\z@{\rule[\@tempfootht]{\textwidth}{1\p@}\hss}%
      \fi%
      \reset@font\tiny
     \@MyLogo\ \@Restriction\hfil\@rightfooter}}%
    \else
      {\Black{\hfil\reset@font\footnotesize%
       \@MyLogo\ \@Restriction\hfil}}%
    \fi}%
  \let\@evenhead\@oddhead%
  \let\@evenfoot\@oddfoot%
}

\ps@cpfoilheadings
\pagenumbering{arabic}
\onecolumn
\mark{{}{}}

\newcommand\refname{References}
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newcommand\newblock{}
\newenvironment{thebibliography}[1]{
 \vskip 3.5ex \@plus -1ex \@minus -.2ex
 \noindent{\large\bfseries\refname}
 \vskip 2.3ex \@plus .2ex
 \list{\@biblabel{\arabic{enumiv}}}%
 {\settowidth\labelwidth{\@biblabel{#1}}%
 \leftmargin\labelwidth
 \advance\leftmargin\labelsep
 \if@openbib
   \advance\leftmargin\bibindent
   \itemindent -\bibindent
   \listparindent \itemindent
   \parsep \z@
 \fi
 \usecounter{enumiv}%
 \let\p@enumiv\@empty
 \renewcommand\theenumiv{\arabic{enumiv}}}
 \if@openbib
   \renewcommand\newblock{\par}
 \else
   \renewcommand\newblock{\hskip .11em \@plus .33em \@minus -.07em}
 \fi
 \sloppy\clubpenalty4000\widowpenalty4000%
 \sfcode`\.=\@m\relax}%
 {\def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
 \endlist}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\newlength\captionwidth
\newlength\abovefloatskip
\setlength\abovecaptionskip{15\p@ \@plus 5\p@ \@minus 5\p@}
\setlength\belowcaptionskip{0\p@}
\setlength\captionwidth\hsize
\setlength\abovefloatskip{20\p@ \@plus 5\p@ \@minus 10\p@}

\newcommand\@makecaption[2]{%
 \vskip \abovecaptionskip
 \sbox\@tempboxa{#1: #2}%
 \ifdim \wd\@tempboxa >\captionwidth
   \centering\parbox[t]{\captionwidth}{\unhbox\@tempboxa\par}
 \else
   \hbox to\hsize{\hfil\box\@tempboxa\hfil}
 \fi
 \vskip\belowcaptionskip}
\long\def\@caption#1[#2]#3{\par \begingroup \@parboxrestore \normalsize
 \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
 \endgroup}
\def\@xfloat#1[#2]{%
   \def \@captype {#1}%
   \ifhmode \@bsphack \fi \vskip\abovefloatskip
   \vbox\bgroup \color@begingroup \normalcolor
   \hsize\columnwidth \@parboxrestore
   \if@nobreak
     \def\outer@nobreak{\global\@nobreaktrue}\global\@nobreakfalse
   \fi}
\def\end@nonfloat{\par\vskip\z@skip
   \color@endgroup
   \outer@nobreak
   \egroup}
\newcommand\newnonfloat[2]{%
  \expandafter\newcommand\csname#1name\endcsname{#2}%
  \expandafter\newcounter{#1}%
  \expandafter\renewcommand\csname the#1\endcsname
        {\@arabic\csname c@#1\endcsname}%
  \expandafter\newcommand\csname fnum@#1\endcsname
    {\csname#1name\endcsname~\csname the#1\endcsname}%
  \expandafter\newenvironment{#1}{\@float{#1}}{\end@nonfloat}%
  \expandafter\newenvironment{#1*}{\@float{#1}}{\end@nonfloat}}
\newnonfloat{table}{Table}
\newnonfloat{figure}{Figure}
\newlength\foilheadskip
\if@compatibility
  \setlength\foilheadskip{.25in}
\else
  \setlength\foilheadskip{4\p@ \@plus 0\p@ \@minus 18\p@}
\fi
\def\foil@rot@start{\special{ps:
  0 \strip@pt\@foilheight\space 72.27 div Resolution mul translate
  90 neg rotate}%
}
\newif\ifcur@rot@state
\newif\ifnew@rot@state

\newcommand\foilhead{\new@rot@statefalse%        set state for the page
   \@ifnextchar[{\@foilhead}{\@foilhead[0\p@]}}
\if@compatibility
\else
  \newcommand\rotatefoilhead{%
    \if@dvips
      \new@rot@statetrue
    \else
      \@warning{Without the 'dvips' option, rotation is not supported}
      \new@rot@statefalse
    \fi
    \@ifnextchar[{\@foilhead}{\@foilhead[0\p@]}}
\fi
\def\@foilhead[#1]#2{\vfill\eject
  \ifnew@rot@state
    \cur@rot@statetrue\@rotdimens
  \else
    \cur@rot@statefalse\@defaultdimens
  \fi
% CP >> header manipulations
%  {\rightheader{\hfill{\LARGE\it\boldmath%
%                \hskip-0.005\textwidth%
%                \psframebox[linecolor=yellow,linewidth=4pt,fillstyle=solid,fillcolor=yellow]{\parbox[]{0.99\textwidth}{\centerline{#2}}}%
%                       \unboldmath}\hfill}}}
  {\rightheader{\hfill{\LARGE\it#2}\hfill}}}
\CheckCommand*\@begindvi{%
  \unvbox \@begindvibox
 \global\let \@begindvi \@empty}
\def \@begindvi{%
  \ifcur@rot@state\foil@rot@start\fi
  \unvbox \@begindvibox
  \gdef\@begindvi{\ifcur@rot@state\foil@rot@start\fi\@empty}
}
\def\newtheorem#1{\@ifnextchar[{\@Othm{#1}}{\@Nthm{#1}}}
\def\@Othm#1[#2]#3{\@Sthm{#1}{#3}\@othm{#1}[#2]{#3}}
\def\@Nthm#1#2{\@Sthm{#1}{#2}\@nthm{#1}{#2}}
\def\@Sthm#1#2{{{\global\@namedef{#1*}{\@starthm{#2}}
   \global\@namedef{end#1*}{\@endtheorem}}}}
\def\@starthm#1{\@ifnextchar[{\@ystarthm{#1}}{\@xstarthm{#1}}}
\def\@xstarthm#1{\@beginstartheorem{#1} \ignorespaces}
\def\@ystarthm#1[#2]{\@opargbeginstartheorem{#1}{#2}\ignorespaces}
\def\@begintheorem#1#2{\trivlist
      \item[\hskip\labelsep{\bfseries #1\ #2. }]\slshape}
\def\@opargbegintheorem#1#2#3{\trivlist
      \item[\hskip\labelsep{\bfseries #1\ #2.\ [#3] }]\slshape}
\def\@beginstartheorem#1{\trivlist
      \item[\hskip\labelsep{\bfseries #1. }]\slshape}
\def\@opargbeginstartheorem#1#2{\trivlist
      \item[\hskip\labelsep{\bfseries #1.\ [#2] }]\slshape}
\newtheorem{Theorem}{Theorem}
\newtheorem{Lemma}{Lemma}
\newtheorem{Corollary}{Corollary}
\newtheorem{Proposition}{Proposition}
\newtheorem{Definition}{Definition}
\newenvironment{Proof}{\begin{trivlist}\item[] {\bfseries Proof.}}{%
  \ifhmode\nolinebreak[4]~$\ProofBox$\else$\ProofBox$\fi \end{trivlist}}
\DeclareMathSymbol\ProofBox{0}{flasy}{"32}
\def\bm#1{\mathpalette\bmstyle{#1}}
\def\bmstyle#1#2{\mbox{\boldmath$#1#2$}}
\@namedef{boldequation*}{\boldmath$$}
\@namedef{endboldequation*}{$$\global\@ignoretrue\unboldmath}
\def\boldequation{\boldmath$$\refstepcounter{equation}}
\def\endboldequation{\eqno\@eqnnum%
    $$\global\@ignoretrue\unboldmath}
\endinput
%%
%% End of file `cpfoils.cls'.
