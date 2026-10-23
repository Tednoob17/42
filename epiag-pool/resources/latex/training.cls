\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{training}[2024/01/01 v1.0 LaTeX class for training documents]
\newcommand{\schoollogo}[1]{\def\@schoollogo{#1}}
\schoollogo{}

\newcommand{\lang}{english}
\newcommand{\setlang}[1]{\renewcommand{\lang}{#1}}
\newcommand{\summarytitle}{Summary}%
\newcommand{\versiontitle}{Version}%

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{report}
}

\ProcessOptions\relax
\LoadClass[a4paper,12pt,onecolumn]{report}

\usepackage[top=1in,bottom=1in,left=1in,right=1in]{geometry}
\usepackage[pdftex]{graphicx}
\usepackage[hyphens]{url}
\usepackage{ragged2e}
\Urlmuskip=0mu plus 3mu\relax
\def\UrlBreaks{\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;%
  \do\>\do\]\do\)\do\'\do\+\do\=\do\#\do\%\do\;\do\?\do\&%
  \do\:\do\~\do\,\do\-\do\*}
\emergencystretch=4em
\setlength{\hfuzz}{2pt}
\AtBeginDocument{\ttfamily\hyphenchar\font=45\relax\normalfont}
\setlength{\rightskip}{0pt plus 1cm}
\usepackage{fancyhdr}
\setlength{\headheight}{30pt}
\usepackage{array}
\usepackage[table]{xcolor}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{listings}
\usepackage{tabularx}
\usepackage{textcomp}
\usepackage{color}
\usepackage[pdftex]{hyperref}
\usepackage{fancybox}
\usepackage{float}
\usepackage{atbeginend}
\usepackage{tocloft}
\usepackage{multirow}
\usepackage{booktabs}
\usepackage[\lang]{babel}
\usepackage{minted}
\usepackage{pifont,mdframed}
\usepackage{etoolbox}

%% Helper for dynamic table column widths
\newcommand{\fullwidthcol}{\dimexpr\textwidth-2\tabcolsep-2\arrayrulewidth\relax}
\newcommand{\halfwidthcol}{\dimexpr(\textwidth-2\tabcolsep-2\arrayrulewidth)/2\relax}

%% III - Lengths and color redefinitions

\AfterBegin{enumerate}{
  \itemsep10pt%
}
\AfterBegin{itemize}{
  \itemsep5pt%
  \renewcommand{\labelitemi}{$\bullet$}%
  \renewcommand{\labelitemii}{$\circ$}%
}

\BeforeBegin{enumerate}{\vspace{15pt}}
\AfterEnd{enumerate}{\vspace{15pt}}

\BeforeBegin{itemize}{\vspace{15pt}}
\AfterEnd{itemize}{\vspace{15pt}}

\BeforeBegin{lstlisting}{\vspace{15pt}}
\AfterEnd{lstlisting}{\vspace{15pt}}

\BeforeBegin{tabularx}{\vspace{15pt}}
\AfterEnd{tabularx}{\vspace{15pt}}

\definecolor{nicergreen}{rgb}{0,0.502,0}
\definecolor{nicerblue}{rgb}{0,0.302,1}
\definecolor{nicerorange}{rgb}{1,0.502,0}
\definecolor{nicergrey}{rgb}{0.502,0.502,0.502}
\definecolor{nicerred}{rgb}{0.626,0,0}
\definecolor{hintbg}{rgb}{0.85,1.0,0.85}
\definecolor{warnbg}{rgb}{1.0,0.75,0.75}
\definecolor{infobg}{rgb}{0.75,0.75,1.0}
\definecolor{bibliotechbg}{RGB}{239,253,255}
\definecolor{lightgrey}{rgb}{0.95,0.95,0.95}
\definecolor{darkgrey}{rgb}{0.1,0.1,0.1}
\definecolor{assholeblack}{rgb}{0,0,0}
\definecolor{defframe}{rgb}{0.70,0.60,0.90}
\definecolor{defbg}{rgb}{0.97,0.95,0.99}
\definecolor{exoframe}{rgb}{0.80,0.85,0.95}
\definecolor{exobg}{rgb}{0.95,0.97,1.00}

\hypersetup
{
  colorlinks,
  linkcolor=black,
  urlcolor=blue
}

\lstset
{
  backgroundcolor=\color{gray!15},
  basicstyle=\small\ttfamily,
  breaklines=true,
  postbreak={},
  columns=fullflexible,
  frame=lines,
  tabsize=4,
  numbers=none,
  numberstyle=\scriptsize\ttfamily,
  numbersep=5pt,
  showspaces=false,
  showstringspaces=false,
  showtabs=false,
  upquote=true,
  float
}

\makeatletter
\pagestyle{fancy}
\lhead{\parbox[b]{\dimexpr0.5\textwidth-10pt\relax}{\RaggedRight\small\@title}}
\rhead{\parbox[b]{\dimexpr0.5\textwidth-10pt\relax}{\RaggedLeft\small\@subtitle}}
\cfoot{\thepage}
\makeatother

\renewcommand{\thechapter}{\Roman{chapter}}

\setlength{\cftchapnumwidth}{2.5cm}
\setlength{\cftsecnumwidth}{2.5cm}
\setlength{\cftsubsecnumwidth}{2.5cm}
\setlength{\cftsubsubsecnumwidth}{2.5cm}
\setlength{\cftaftertoctitleskip}{0.5cm}
\renewcommand{\cftsecafterpnum}{\vskip 2pt}
\renewcommand{\cftsubsecafterpnum}{\vskip 2pt}

\makeatletter
\newcommand{\website}[1]{\def \@website {#1}}
\website{}

\newcommand{\subtitle}[1]{\def \@subtitle {#1}}
\subtitle{}

\newcommand{\summary}[1]{\def \@summary {#1}}
\summary{}

\newcommand{\version}[1]{\def \@version {#1}}
\version{}

\edef\@authors{}
\newcommand{\member}[2]{%
  \protected@edef\@authors{\@authors #1 \protect\url{#2}\\}
  \author{\@authors}
}
\author{}

\newcommand*{\@insertlogo}{%
  \ifx\@schoollogo\@empty
    \vskip 2mm
  \else
    \vskip 2mm \includegraphics[height=1cm]{\@schoollogo}
  \fi
}

\def \maketitle {
  \begin{titlepage}
    \begin{center}
      \includegraphics[height=8cm]{\@schoollogo}
      \vskip 5em
      {\huge \@title}
      \vskip 2em
      {\LARGE \@subtitle}
      \vskip 4em
    \end{center}
    \begin{center}
      \@author
    \end{center}
    \vskip 5em
    \begin{center}
      \emph{\summarytitle : \@summary}
    \end{center}
    \ifx\@prerequisite\@empty\else
    \begin{center}
      \emph{Prerequisites : \@prerequisite}
    \end{center}
    \fi
    \begin{center}
      \emph{\versiontitle : \@version}
    \end{center}
  \end{titlepage}
}
\makeatother

\makeatletter
\setminted{bgcolor=white,fontsize=\small,breaklines=true,breakanywhere=true,breaksymbol={},breaksymbolright={},breaksymbolleft={},style=vs}
\makeatother

\newcounter{exerciceCounter}
\newcommand*{\exercicenumber}{
  \ifnum\value{exerciceCounter}<10 0\fi
  \arabic{exerciceCounter}
}

\newcommand*{\startexercices}{
  \setcounter{exerciceCounter}{0}
}

\newcommand*{\nextexercice}{
  \stepcounter{exerciceCounter}
}

\newcounter{itemizeCounter}
\setcounter{itemizeCounter}{0}
\BeforeBegin{itemize}{
  \addtocounter{itemizeCounter}{1}
}

\AfterEnd{itemize}{
  \addtocounter{itemizeCounter}{-1}
  \ifnum\value{itemizeCounter} = 0
    \stepcounter{exerciceCounter}
  \fi
}

\newcommand{\kbox}[3]
{
  \needspace{3cm}
  \vskip 15pt
  \nopagebreak[4]
  \noindent
  \colorbox{#1}
  {
    \begin{tabular*}{0.97\textwidth}{
        >{\RaggedRight\arraybackslash}m{4em}
        >{\RaggedRight\arraybackslash}m{\dimexpr0.97\textwidth-4em-4\tabcolsep-2\arrayrulewidth\relax}
      }
          \includegraphics[width=4em]{#2}
        & {\footnotesize\sloppy #3}\\
    \end{tabular*}
  }
  \nopagebreak[4]
  \vskip 15pt
}

\newcommand{\hint}[1]{\kbox{hintbg}{helphint.pdf}{#1}}
\newcommand{\warn}[1]{\kbox{warnbg}{warn.pdf}{#1}}
\newcommand{\info}[1]{\kbox{infobg}{info.pdf}{#1}}

\makeatletter
\newcommand{\mso}[1]{
  \ttfamily #1 \normalfont
}

\makeatletter
\newcommand{\turnindir}[1]{\def \@turnindir {#1}}
\newcommand{\daypiscine}[1]{\def \@daypiscine {#1}}
\newcommand{\extitle}[1]{\def \@extitle {#1}}
\newcommand{\exnumber}[1]{\def \@exnumber {#1}}
\newcommand{\exscore}[1]{\def \@exscore {#1}}
\newcommand{\exflags}[1][-W -Wall -Werror]{\def \@exflags {#1}}
\newcommand{\excompil}[1][gcc]{\def \@excompil {#1}}
\newcommand{\exrules}[1][n/a]{\def \@exrules {#1}}
\newcommand{\exfiles}[1]{\def \@exfiles {#1}}
\newcommand{\exnotes}[1][n/a]{\def \@exnotes {#1}}
\newcommand{\exauthorize}[1]{\def \@exauthorize {#1}}
\newcommand{\exforbidden}[1]{\def \@exforbidden {#1}}
\newcommand{\exmake}[1][No]{\def \@exmake {#1}}

\newcommand{\exbonus}{\edef\@exnumber{\@exnumber\ (Bonus)}}

\turnindir{}
\daypiscine{}
\extitle{}
\exnumber{}
\exscore{}
\exflags{}
\excompil{}
\exrules{}
\exfiles{}
\exnotes{}
\exauthorize{None}
\exforbidden{None}
\exmake{}

\newcommand{\makeheaderbasic}
{
  \noindent
  \begin{tabularx}{\textwidth}{|X X  X X|}
    \hline
  \multicolumn{1}{|>{\raggedright}m{1cm}|}
  {\@insertlogo} &
  \multicolumn{2}{>{\centering\arraybackslash}X}{\small Exercise : \@exnumber } &
  \multicolumn{1}{ >{\raggedleft}p{1.5cm}|}
              {} \\ \hline

  \multicolumn{4}{|>{\RaggedRight\arraybackslash}X|}
              {\small \@extitle} \\ \hline

\end{tabularx}
\exrules
\exmake
\exforbidden{None}
\extitle{}
\exnumber{}
}

\newcommand{\makeheaderfiles}
{
  \noindent
  \begin{tabularx}{\textwidth}{|X X  X X|}
    \hline
  \multicolumn{1}{|>{\raggedright}m{1cm}|}
  {\@insertlogo} &
  \multicolumn{2}{>{\centering\arraybackslash}X}{\small Exercise \@exnumber } &
  \multicolumn{1}{ >{\raggedleft}p{1.5cm}|}
              {} \\ \hline

  \multicolumn{4}{|>{\RaggedRight\arraybackslash}X|}
              {\small \@extitle} \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Turn-in directory : \ttfamily
                ex\@exnumber/ }
              \\ \hline
  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Files to turn in : \ttfamily \@exfiles }
              \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Allowed functions : \ttfamily \@exauthorize }
              \\ \hline

\end{tabularx}
\exrules
\exmake
\exauthorize{None}
\exforbidden{None}
\extitle{}
\exnumber{}
}

\newcommand{\makeheaderfilesnodirectory}
{
  \noindent
  \begin{tabularx}{\textwidth}{|X X  X X|}
    \hline
  \multicolumn{1}{|>{\raggedright}m{1cm}|}
  {\@insertlogo} &
  \multicolumn{2}{>{\centering\arraybackslash}X}{\small Exercice : \@exnumber } &
  \multicolumn{1}{ >{\raggedleft}p{1.5cm}|}
              {} \\ \hline

  \multicolumn{4}{|>{\RaggedRight\arraybackslash}X|}
              {\small \@extitle} \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Files to turn in : \ttfamily \@exauthorize }
              \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Authorised functions : \ttfamily \@exnotes }
              \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Notes : \ttfamily \@exnotes }
              \\ \hline
\end{tabularx}
\exnotes
\exrules
\exmake
\exauthorize{None}
\exforbidden{None}
\extitle{}
\exnumber{}
}

\newcommand{\makeheaderfilesforbidden}
{
  \noindent
  \begin{tabularx}{\textwidth}{|X X  X X|}
    \hline
  \multicolumn{1}{|>{\raggedright}m{1cm}|}
  {\@insertlogo} &
  \multicolumn{2}{>{\centering\arraybackslash}X}{\small Exercise : \@exnumber } &
  \multicolumn{1}{ >{\raggedleft}p{1.5cm}|}
              {} \\ \hline

  \multicolumn{4}{|>{\RaggedRight\arraybackslash}X|}
              {\small \@extitle} \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Turn-in directory : \ttfamily
                ex\@exnumber/ }
              \\ \hline
  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Files to turn in : \ttfamily \@exfiles }
              \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Forbidden functions : \ttfamily \@exforbidden }
              \\ \hline

\end{tabularx}
\exnotes
\exrules
\exmake
\exauthorize{None}
\exforbidden{None}
\extitle{}
\exnumber{}
}

\newcommand{\makeheadercode}
{
  \noindent
  \begin{tabularx}{\textwidth}{|X X  X X|}
    \hline
  \multicolumn{1}{|>{\raggedright}m{1cm}|}
  {\@insertlogo} &
  \multicolumn{2}{>{\centering\arraybackslash}X}{\small Exercise \@exnumber } &
  \multicolumn{1}{ >{\raggedleft}p{1.5cm}|}
              {} \\ \hline

  \multicolumn{4}{|>{\RaggedRight\arraybackslash}X|}
              {\small \@extitle} \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Turn-in directory: \ttfamily
                ex\@exnumber/ }
              \\ \hline

  \multicolumn{2}{|>{\raggedright\arraybackslash}X}
              {\small Compiler: \ttfamily \@excompil } &
  \multicolumn{2}{|>{\raggedright\arraybackslash}X|}
              {\small Compilation flags:
                \ttfamily \@exflags }
              \\ \hline

  \multicolumn{2}{|>{\raggedright\arraybackslash}X}
              {\small Makefile: \ttfamily{\@exmake}} &
  \multicolumn{2}{|>{\raggedright\arraybackslash}X|}
              {Makefile rules: \ttfamily \@exrules } \\ \hline

  \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
              {\small Files to turn in: \ttfamily \@exfiles }
              \\ \hline

   \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
               {\small Notes : \ttfamily \@exnotes }
               \\ \hline

   \multicolumn{4}{|>{\raggedright\arraybackslash}X|}
               {\small Forbidden fonctions: \ttfamily \@exforbidden }
               \\ \hline
\end{tabularx}
\exnotes
\exrules
\exmake
\exforbidden{None}
\extitle{}
\exnumber{}
}

\newcommand{\ftname}[1]{\def \@ftname {#1}}
\newcommand{\ftprototype}[1]{\def \@ftprototype {#1}}
\newcommand{\ftdesc}[1]{\def \@ftdesc {#1}}
\newcommand{\ftparams}[1]{\def \@ftparams {#1}}
\newcommand{\ftret}[1]{\def \@ftret {#1}}
\newcommand{\ftfuncts}[1]{\def \@ftfuncts {#1}}
\newcommand{\ftturnin}[1]{\def \@ftturnin {#1}}
\newcommand{\ftmakefile}[1]{\def \@ftmakefile {#1}}
\newcommand{\ftlibft}[1]{\def \@ftlibft {#1}}
\newcommand{\ftcompil}[1]{\def \@ftcompil {#1}}

\ftname{}
\ftprototype{}
\ftdesc{}
\ftparams{}
\ftret{}
\ftfuncts{}
\ftturnin{}
\ftmakefile{}
\ftlibft{}
\ftcompil{}

\newcolumntype{s}{>{\hsize=.5\hsize}X}
\newcolumntype{b}{>{\hsize=1.5\hsize}X}
\newcommand{\makeheaderfct}
{
  \noindent
  \begin{tabularx}{\textwidth}{| s | b |} \hline
    \textbf{Function name} & \texttt{\@ftname} \\ \hline
    \textbf{Prototype} & \texttt{\@ftprototype} \\ \hline
    \textbf{Turn in files} & \texttt{\@ftturnin} \\ \hline
    \textbf{Parameters} & \texttt{\@ftparams} \\ \hline
    \textbf{Return value} & \texttt{\@ftret} \\ \hline
    \textbf{External functs.} & \texttt{\@ftfuncts} \\ \hline
    \textbf{Description} & \texttt{\@ftdesc} \\ \hline
\end{tabularx}
}

\newcommand{\makeheaderlib}
{
  \noindent
  \begin{tabularx}{\textwidth}{| s | b |} \hline
    \textbf{Program name} & \texttt{\@ftname} \\ \hline
    \textbf{Turn in files} & \texttt{\@ftturnin} \\ \hline
    \textbf{Makefile} & \texttt{\@ftmakefile} \\ \hline
    \textbf{External functs.} & \texttt{\@ftfuncts} \\ \hline
    \textbf{Libft authorized} & \texttt{\@ftlibft} \\ \hline
    \textbf{Description} & \texttt{\@ftdesc} \\ \hline
\end{tabularx}
}

\newcommand{\makeheaderprg}
{
  \noindent
  \begin{tabularx}{\textwidth}{| s | b |} \hline
    \textbf{Program name} & \texttt{\@ftname} \\ \hline
    \textbf{Turn in files} & \texttt{\@ftturnin} \\ \hline
    \textbf{Makefile} & \texttt{\@ftmakefile} \\ \hline
    \textbf{Arguments} & \texttt{\@ftparams} \\ \hline
    \textbf{External functs.} & \texttt{\@ftfuncts} \\ \hline
    \textbf{Libft authorized} & \texttt{\@ftlibft} \\ \hline
    \textbf{Description} & \texttt{\@ftdesc} \\ \hline
\end{tabularx}
}

\newcommand{\exmandatory}{Mandatory exercise}
\newcommand{\exretrovalid}{Retrovalidated exercise}
\newcommand{\exoptional}{Optional exercise}
\newcommand{\exercice}{Exercise}

\newcommand{\reproductionfromman}[1]{Reproduce the behavior of the function \texttt{#1} (man #1).}

\makeatletter
\newenvironment{code}{%
  \VerbatimEnvironment
  \fvset{fontsize=\scriptsize,breaklines=true}
  \par\vspace{10pt}
  \noindent
  \begin{minipage}{\linewidth}
      \begin{VerbatimOut}{\jobname.pyg}}
{%[
      \end{VerbatimOut}
      \minted@pygmentize{c}
      \DeleteFile{\jobname.pyg}
    \end{minipage}
\par\vspace{10pt}}
\makeatother

\makeatletter
\newenvironment{jscode}{%
  \VerbatimEnvironment
  \fvset{fontsize=\scriptsize,breaklines=true}
  \par\vspace{10pt}
  \noindent
  \begin{minipage}{\linewidth}
      \begin{VerbatimOut}{\jobname.pyg}}
{%[
      \end{VerbatimOut}
      \minted@pygmentize{js}
      \DeleteFile{\jobname.pyg}
    \end{minipage}
\par\vspace{10pt}}
\makeatother

\newminted{rust}{fontsize=\scriptsize,breaklines=true,breaksymbol={}}
\newminted{python}{fontsize=\scriptsize,breaklines=true,breaksymbol={}}

\lstnewenvironment{console} {
    \lstset {
        extendedchars=true,
        literate={✓}{{\checkmark}}1 {\_}{\textunderscore}1,
        basicstyle=\color{white}\scriptsize\ttfamily,
        backgroundcolor=\color{assholeblack},
        breaklines=true,
        numberstyle=\scriptsize,
        columns=flexible,
        keepspaces=true,
    }
}{}

\newenvironment{warning}
  {\vspace*{1\baselineskip}
  \par\begin{mdframed}[linewidth=2pt,linecolor=red]%
  \begin{list}{}{\leftmargin=1cm
    \labelwidth=\leftmargin}\item[\Large\ding{172}]}
   {\end{list}\end{mdframed}\par \vspace*{1\baselineskip}}

\newcommand{\fileheader}[5]{%
  \par\vspace{8pt}%
  \noindent\begin{mdframed}[linewidth=1pt,linecolor=gray!40,backgroundcolor=gray!5]%
  \begin{minipage}{\linewidth}%
  \scriptsize\ttfamily%
  /**\par
  ~~* Module: #1\par
  ~~* Exercise: #2\par
  ~~* File: #3\par
  ~~* Author: \textless votre login\textgreater\par
  ~~*\par
  ~~* Description: #4\par
  ~~*\par
  ~~* Return: #5\par
  */\par
  \end{minipage}%
  \end{mdframed}%
  \par\vspace{8pt}}

\makeatletter
\newcommand{\prerequisite}[1]{\def\@prerequisite{#1}}
\providecommand{\@prerequisite}{}
\makeatother
