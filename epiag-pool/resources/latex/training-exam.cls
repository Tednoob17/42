\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{training-exam}[2024/01/01 v1.0 LaTeX class for exams]

\newcommand{\examduration}[1]{\def\@examduration{#1}}
\examduration{2 hours}

\newcommand{\examscore}[1]{\def\@examscore{#1}}
\examscore{100}

\newcommand{\examlevelname}[1]{\def\@examlevelname{#1}}
\examlevelname{}

\newcounter{examLevel}
\setcounter{examLevel}{0}

\newcommand{\examlevel}[1]{%
  \stepcounter{examLevel}%
  \examlevelname{#1}%
  \chapter{Level \arabic{examLevel}: #1}%
}

\newcommand{\examlevels}{%
  \ifnum\value{examLevel}=1 1 level\else
  \arabic{examLevel} levels\fi
}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{training}
}

\ProcessOptions\relax
\LoadClass{training}

\renewcommand{\summarytitle}{Duration}
\renewcommand{\versiontitle}{Score}

\renewcommand{\maketitle}{%
  \begin{titlepage}%
    \begin{center}%
      \includegraphics[height=8cm]{\@schoollogo}%
      \vskip 5em%
      {\huge EXAM --- \@title}%
      \vskip 2em%
      {\LARGE \@subtitle}%
      \vskip 4em%
    \end{center}%
    \begin{center}%
      \@author%
    \end{center}%
    \vskip 3em%
    \begin{center}%
      \fbox{\begin{minipage}{0.7\textwidth}%
        \centering%
        \textbf{Duration:} \@examduration \\[0.5em]%
        \textbf{Total score:} \@examscore \\[0.5em]%
        \textbf{Rules:} No internet, no notes, no AI tools.%
      \end{minipage}}%
    \end{center}%
    \vskip 2em%
    \begin{center}%
      \emph{\@summary}%
    \end{center}%
  \end{titlepage}%
}

\newcommand{\startexam}{%
  \setcounter{exerciceCounter}{0}%
  \setcounter{examLevel}{0}%
}

\newcommand{\exampoints}[1]{%
  \hfill{\small\itshape [#1 points]}%
}
