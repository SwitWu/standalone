%
% \subsection{The Class File}
%    \begin{macrocode}
%<!COPYRIGHT>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{standalone}[%
%<!DATE>
%<!VERSION>
%<*DRIVER>
    2099/01/01 develop
%</DRIVER>
    Class to compile TeX sub-files standalone]
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{If-Switches}
%
% \begin{macro}{\ifstandalone}
% This if-switch is defined by both the class and package. This class sets
% it to true while the package (loaded by the main document) sets it to false.
%    \begin{macrocode}
\newif\ifstandalone
\standalonetrue
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\ifstandalonebeamer}
% This if-switch is defined by both the class and package. This class sets
% it to true only if the |beamer| option was given. The package (loaded by the main document) sets it always to false.
%    \begin{macrocode}
\newif\ifstandalonebeamer
\standalonebeamerfalse
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\onlyifstandalone}
% Macro version of |\ifstandalone|. The |{ }| around the argument protects the content from the package etc. scanners.
%    \begin{macrocode}
\let\onlyifstandalone\@firstofone
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\IfStandalone}[2]{true clause}{false clause}
% Macro version of |\ifstandalone .. \else .. \fi|. The |{ }| around the argument protects the content from the package etc. scanners.
%    \begin{macrocode}
\let\IfStandalone\@firstoftwo
%    \end{macrocode}
% \end{macro}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Code for border values}
% The following macros are used to parse the \opt{border} option.
%
% \begin{macro}{\sa@border@left}
% \begin{macro}{\sa@border@right}
% \begin{macro}{\sa@border@top}
% \begin{macro}{\sa@border@margin}
%    \begin{macrocode}
\def\sa@border@left{0.50001bp}
\let\sa@border@right\sa@border@left
\let\sa@border@top\sa@border@left
\let\sa@border@bottom\sa@border@left
%    \end{macrocode}
% \end{macro}
% \end{macro}
% \end{macro}
% \end{macro}
%
%
% \begin{macro}{\rem@bp}
%    \begin{macrocode}
\def\rem@bp#1bp\relax#2\@nnil{#1}%
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\default@bp}
%    \begin{macrocode}
\def\default@bp#1#2{%
    \begingroup
    \afterassignment\remove@to@nnil
    \dimen@ #2bp\relax\@nnil
    \expandafter
    \endgroup
    \expandafter
    \def\expandafter#1\expandafter{\the\dimen@}%
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@readborder}
%    \begin{macrocode}
\def\sa@readborder#1 #2 #3 #4 #5\@nnil{%
    \ifx\\#2#3#4\\%
        \default@bp\sa@border@left{#1}%
        \let\sa@border@right\sa@border@left
        \let\sa@border@top\sa@border@left
        \let\sa@border@bottom\sa@border@left
    \else
    \ifx\\#4\\%
        \default@bp\sa@border@left{#1}%
        \let\sa@border@right\sa@border@left
        \default@bp\sa@border@top{#2}%
        \let\sa@border@bottom\sa@border@top
    \else
        \default@bp\sa@border@left{#1}%
        \default@bp\sa@border@bottom{#2}%
        \default@bp\sa@border@right{#3}%
        \default@bp\sa@border@top{#4}%
    \fi\fi
}%
%    \end{macrocode}
% \end{macro}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Options}
%
%    \begin{macrocode}
\let\sa@classoptionslist\@classoptionslist
\RequirePackage{xkeyval}
\newif\ifsa@preview
\newif\ifsa@crop
\newif\ifsa@multi
\newif\ifsa@varwidth
\newif\ifsa@ignorerest
\newif\ifsa@tikz
\newif\ifsa@convert
%    \end{macrocode}
%
% The \cs{ifstandalonebeamer} switch is in the user-level.
% Wire the setter macros to the internal naming scheme, so that \Macro\sa@boolean can be used with it.
%    \begin{macrocode}
\let\sa@beamertrue\standalonebeamertrue
\let\sa@beamerfalse\standalonebeamerfalse
%    \end{macrocode}
%
% \begin{macro}{\sa@option}
% Wrapper macro to define options.
%    \begin{macrocode}
\def\sa@option{%
    \define@key{standalone.cls}%
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@keyalias}
%    \begin{macrocode}
\def\sa@keyalias#1#2#3#4{%
    \expandafter\let\csname KV@#1@#2\expandafter\endcsname\csname KV@#3@#4\endcsname
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{key}{standalone.cls}{border}
% Sets the border around the content.
%    \begin{macrocode}
\sa@option{border}{%
    \sa@readborder#1 {} {} {} {} \@nnil
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{macro}{\sa@boolean}[2]{name of if-switch}{`true' or `false'}
% Sets if-switches.
%    \begin{macrocode}
\def\sa@boolean#1#2{%
    \begingroup
    \edef\@tempa{#2}%
    \def\@tempb{true}%
    \ifx\@tempa\@tempb
        \endgroup
        \csname sa@#1true\endcsname
    \else
        \endgroup
        \csname sa@#1false\endcsname
    \fi
}
%    \end{macrocode}
% \end{macro}
%
%
%
%
% \begin{key}{standalone.cls}{preview}
% Boolean to control if \pkg{preview} package should be used.
%    \begin{macrocode}
\sa@option{preview}[true]{%
    \sa@boolean{preview}{#1}%
    \ifsa@preview
        \sa@cropfalse
    \fi
}
\sa@previewtrue
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{crop}
% Boolean to control if own code should be used.
% That code boxes the content and resizes the page to match the box dimensions.
%    \begin{macrocode}
\sa@option{crop}[true]{%
    \sa@boolean{crop}{#1}%
    \ifsa@crop
        \sa@previewfalse
    \fi
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{ignorerest}
% Boolean to control if all other code outside of specified environments should be explicit ignored.
% That code boxes the outside content and then than discards it.
%    \begin{macrocode}
\sa@option{ignorerest}[true]{%
    \sa@boolean{ignorerest}{#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{multi}
% Boolean to control if multiple pages are used.
%    \begin{macrocode}
\sa@option{multi}[true]{%
    \sa@boolean{multi}{#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{varwidth}
% Boolean to control if \pkg{varwidth} package should be used.
% If so the content will be placed in a \env{varwidth} environment to avoid extending it to the full line width if a
% paragraph break is inserted.
%
% The option is by default set to true if the \pkg{varwidth} package is available.
%    \begin{macrocode}
\sa@option{varwidth}[true]{%
    \sa@boolean{varwidth}{#1}%
    \ifsa@varwidth
        \def\sa@varwidth{\varwidth{\linewidth}}%
        \def\sa@endvarwidth{\endvarwidth}%
    \else
        \let\sa@varwidth\@empty
        \let\sa@endvarwidth\@empty
    \fi
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{tikz}
%    \begin{macrocode}
\sa@option{tikz}[true]{%
    \sa@boolean{tikz}{#1}%
    \setkeys{standalone.cls}{multi}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{beamer}
% Boolean to control if the \cls{beamer} class is used.
%
% If true sets the class to \cls{beamer} and switches \opt{preview} off.
% If false the default class is restored if the current class was \cls{beamer}.
%    \begin{macrocode}
\sa@option{beamer}[true]{%
    \sa@boolean{beamer}{#1}%
    \ifstandalonebeamer
        \def\sa@class{beamer}%
        \sa@previewfalse
    \else
        \begingroup
        \def\@tempa{beamer}%
        \ifx\@tempa\sa@class
            \endgroup
            \def\sa@class{article}%
        \else
            \endgroup
        \fi
    \fi
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls}{class}
%    \begin{macrocode}
\sa@option{class}{%
    \def\sa@class{#1}%
}
\def\sa@class{article}
%    \end{macrocode}
% \end{key}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% \begin{key}{standalone.cls}{convert}
%    \begin{macrocode}
\sa@option{convert}[true]{%
    \setkeys{standalone.cls/convert}{#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{macro}{\sa@convertoption}
% Wrapper to define \opt{convert} options.
%    \begin{macrocode}
\def\sa@convertoption{%
    \define@key{standalone.cls/convert}%
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\sa@convertvar}[2]{name}{initial value}
% Wrapper to define \opt{convert} variables.
%    \begin{macrocode}
\def\sa@convertvar#1#2{%
    \define@key{standalone.cls/convert}{#1}{%
        \@namedef{sa@convert@#1}{##1}%
    }%
    \@namedef{sa@convert@#1}{#2}%
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{key}{standalone.cls/convert}{true}
%    \begin{macrocode}
\sa@convertoption{true}[]{%
    \sa@converttrue
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls/convert}{false}
%    \begin{macrocode}
\sa@convertoption{false}[]{%
    \sa@convertfalse
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls/convert}{png}
%    \begin{macrocode}
\sa@convertoption{png}[]{%
    \setkeys{standalone.cls/convert}{true,outext={.png}}%
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls}{png}
%    \begin{macrocode}
\sa@option{png}{%
    \setkeys{standalone.cls/convert}{png,#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls/convert}{jpg}
%    \begin{macrocode}
\sa@convertoption{jpg}[]{%
    \setkeys{standalone.cls/convert}{true,outext={.jpg}}%
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls}{jpg}
%    \begin{macrocode}
\sa@option{jpg}{%
    \setkeys{standalone.cls/convert}{jpg,#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls/convert}{gif}
%    \begin{macrocode}
\sa@convertoption{gif}[]{%
    \setkeys{standalone.cls/convert}{true,outext={.gif}}%
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls}{gif}
%    \begin{macrocode}
\sa@option{gif}{%
    \setkeys{standalone.cls/convert}{gif,#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls/convert}{onfailure}
%    \begin{macrocode}
\sa@convertoption{onfailure}{%
    \begingroup
    \edef\@tempa{#1}%
    \def\@tempb{error}%
    \ifx\@tempa\@tempb
        \endgroup
        \let\sa@convert@failuremsg\ClassError
    \else
    \def\@tempb{warning}%
    \ifx\@tempa\@tempb
        \endgroup
        \let\sa@convert@failuremsg\ClassWarning
    \else
    \def\@tempb{info}%
    \ifx\@tempa\@tempb
        \endgroup
        \let\sa@convert@failuremsg\ClassInfo
    \else
    \def\@tempb{ignore}%
    \ifx\@tempa\@tempb
        \endgroup
        \def\sa@convert@failuremsg##1##2##3{}%
        \let\sa@convert@notfoundmsg\@gobbletwo
    \else
        \let\on@line\@empty
        \ClassError{standalone}{Invalid value '\@tempa' for the 'onfailure' option.\MessageBreak
                                Valid values: 'error', 'warning', 'info', 'ignore'}{}%
        \endgroup
    \fi\fi\fi\fi
}
\let\sa@convert@failuremsg\ClassWarning
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls/convert}{newer}
%    \begin{macrocode}
\sa@convertoption{newer}[]{%
  \def\sa@convert@newer{\filemodCmp{\outfile}{\jobname}}%
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls/convert}{force}
%    \begin{macrocode}
\sa@convertoption{force}[]{%
  \let\sa@convert@newer\@secondoftwo
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls/convert}{gsdevice}
%    \begin{macrocode}
\sa@convertoption{defgsdevice}{%
    \sa@defgsdevice#1\relax\relax
}
\def\sa@defgsdevice#1#2{%
    \@namedef{sa@gsdevice@#1}{#2}%
}
\@namedef{sa@gsdevice@.jpg}{jpg}%
\@namedef{sa@gsdevice@.png}{png16m}%
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls/convert}{imagemagick}
%    \begin{macrocode}
\sa@convertoption{imagemagick}[]{%
    \def\sa@convert@command{\convertexe\space -density \density\space \infile\space \ifx\size\empty\else -resize \size\fi\space -quality 90 \outfile}%
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls/convert}{ghostscript}
%    \begin{macrocode}
\sa@convertoption{ghostscript}[]{%
    \def\sa@convert@command{gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=\gsdevice\space -r\density\space -sOutputFile=\outfile\space \infile}%
}
\sa@keyalias{standalone.cfg/convert}{gs}{standalone.cfg/convert}{ghostscript}
%    \end{macrocode}
% \end{key}
%
%    \begin{macrocode}
\sa@convertvar{size}{}
\sa@convertvar{inext}{\ifpdf.pdf\else.ps\fi}
\sa@convertvar{precommand}{\ifpdf\else dvips \jobname \fi}
\sa@convertvar{inname}{\jobname}
\sa@convertvar{infile}{\inname\inext}
\sa@convertvar{outext}{.png}
\sa@convertvar{outname}{\inname}
\sa@convertvar{outfile}{\outname\outext}
\sa@convertvar{convertexe}{imgconvert}
\sa@convertvar{density}{300}
\sa@convertvar{gsdevice}{%
    \expandafter\ifx\csname sa@gsdevice@\outext\endcsname\relax
        \expandafter\@gobble\outext
    \else
        \csname sa@gsdevice@\outext\endcsname
    \fi
}
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{General macros}
%
% \begin{macro}{\standaloneenv}[1]{comma separated list if environment names}
% Loops over all environment names and calls \Macro\@standaloneenv on them.
%    \begin{macrocode}
\newcommand*\standaloneenv[1]{%
    \begingroup
    \edef\@tempa{\endgroup\noexpand\@for\noexpand\@tempa:=\zap@space#1 \@empty}%
    \@tempa\do{\expandafter\@standaloneenv\expandafter{\@tempa}}%
    \setkeys{standalone.cls}{multi}%
}
\@onlypreamble\standaloneenv
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\standaloneconfig}
% User level configuration macro.
%    \begin{macrocode}
\newcommand*{\standaloneconfig}{\setkeys{standalone.cls}}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\@standaloneenv}
% Default no-op version.
%    \begin{macrocode}
\let\@standaloneenv\@gobble
%    \end{macrocode}
% \end{macro}
%
% Counter to indicate if currently inside a standaloneenv.
%    \begin{macrocode}
\newcount\sa@internal
%    \end{macrocode}
%
%
% \begin{environment}{standalone}
% The \env{standalone} environment is defined by default to be without effect.
% The \cs{endstandalone} macro is set to |\relax|, so a redefinition with
% \cs{renewenvironment} in the configuration file is possible and also can later be detected.
%    \begin{macrocode}
\let\standalone\empty
\let\endstandalone\relax
%    \end{macrocode}
% \end{environment}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Load config file, process options and load class}
%
% Load configuration file.
%    \begin{macrocode}
\InputIfFileExists{standalone.cfg}{}{}
%    \end{macrocode}
%
% Process options as normal keys. Only unknown keys are set as global options.
%    \begin{macrocode}
\begingroup
\def\@tempa{\endgroup\setkeys*{standalone.cls}}
\expandafter\@tempa\expandafter{\sa@classoptionslist}
\let\@classoptionslist\XKV@rm
%    \end{macrocode}
%
% Disable keys which are only allowed as class options.
% The \opt{multi} option is still allowed inside the preamble.
%    \begin{macrocode}
\disable@keys{standalone.cls}{crop,preview,class,beamer,ignorerest}
\AtBeginDocument{%
    \disable@keys{standalone.cls}{multi}%
}
%    \end{macrocode}
%
% Loads the class given by the |class| option with the rest of the options.
%    \begin{macrocode}
\expandafter\expandafter\expandafter\LoadClass
\expandafter\expandafter\expandafter[%
\expandafter\@classoptionslist
\expandafter]\expandafter{\sa@class}
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Varwidth Option}
%
%    \begin{macrocode}
\ifsa@varwidth
    \RequirePackage{varwidth}
\fi
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{TikZ Option}
%
% Loads \pkg{tikz} and makes the \env{tikzpicture} environment and standalone environment.
%    \begin{macrocode}
\ifsa@tikz
    \RequirePackage{tikz}
    \AtEndOfPackage{\standaloneenv{tikzpicture}}
\fi
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Preview Option}
%
% The \env{standalone} environment is redefined to use the |preview| environment as
% long it was not redefined in the configuration file.
%    \begin{macrocode}
\ifsa@preview
%    \end{macrocode}
%
% Note: The used options are in the config file.
%    \begin{macrocode}
\RequirePackage{preview}
\ifsa@tikz\else
    \@ifundefined{endstandalone}{%
        \renewenvironment{standalone}
            {\preview\sa@varwidth}
            {\sa@endvarwidth\endpreview}
    }{}% TODO: Add info message?
\fi
%    \end{macrocode}
%
% Set Border
%    \begin{macrocode}
\def\PreviewBbAdjust{-\sa@border@left\space -\sa@border@bottom\space \sa@border@right\space \sa@border@top}%
%    \end{macrocode}
%
% \begin{macro}{\@standaloneenv}
% Preview version. Wrappes a \env{preview} environment around the original environment.
% Also adds the \env{varwidth} macros, which can be empty.
% These \env{varwidth} macros are the reason why \Macro\PreviewEnvironment is not used directly.
%    \begin{macrocode}
\def\@standaloneenv#1{%
    \expandafter\let\csname sa@orig@#1\expandafter\endcsname\csname #1\endcsname
    \expandafter\let\csname sa@orig@end#1\expandafter\endcsname\csname end#1\endcsname
    \expandafter\def\csname #1\endcsname{%
        \ifnum\sa@internal=0
            \preview
            \sa@varwidth
        \fi
        \advance\sa@internal\@ne
        \csname sa@orig@#1\endcsname
    }%
    \expandafter\def\csname end#1\endcsname{%
        \csname sa@orig@end#1\endcsname
        \advance\sa@internal\m@ne
        \ifnum\sa@internal=0
            \sa@endvarwidth
            \endpreview
        \fi
    }%
}%
%    \end{macrocode}
% \end{macro}
%
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Crop Option}
%
%    \begin{macrocode}
\RequirePackage{ifpdf}
\RequirePackage{ifxetex}
\ifsa@crop
%    \end{macrocode}
%
% Box register to save the content.
% \begin{macro}{\sa@box}
%    \begin{macrocode}
\newbox\sa@box
%    \end{macrocode}
% \end{macro}
%
% Set all normal page margins etc. to zero.
%    \begin{macrocode}
\pagestyle{empty}
\hoffset=-72.27pt
\voffset=-72.27pt
\topmargin=0pt
\headheight=0pt
\headsep=0pt
\marginparsep=0pt
\marginparwidth=0pt
\footskip=0pt
\marginparpush=0pt
\oddsidemargin=0pt
\evensidemargin=0pt
\topskip=0pt
\textheight=\maxdimen
%    \end{macrocode}
%
% \begin{macro}{\sa@boxit}
%    \begin{macrocode}
\def\sa@boxit{%
    \setbox\sa@box\hbox\bgroup\color@setgroup\sa@varwidth
}%
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\endsa@boxit}
%    \begin{macrocode}
\def\endsa@boxit{%
    \sa@endvarwidth\color@endgroup\egroup
}%
%    \end{macrocode}
% \end{macro}
%
%
% \begin{environment}{standalone}
% Redefine the \env{standalone} environment to box the content if \opt{multi} is off,
% in order to use the whole content as single page. If \opt{multi} and \opt{ignorerest} are on
% the content is also boxed, but later discarded. If only \opt{multi} is on the environment
% doesn't have to do anything.
%    \begin{macrocode}
\renewenvironment{standalone}{%
    \ifsa@multi
        \ifsa@ignorerest
            \sa@boxit
        \fi
    \else
        \sa@boxit
    \fi
}{%
    \ifsa@multi
        \ifsa@ignorerest
            \endsa@boxit
        \fi
    \else
        \endsa@boxit
        \sa@handlebox
    \fi
}
%    \end{macrocode}
% \end{environment}
%
%
% \begin{macro}{\@standaloneenv}
% If the \opt{ignorerest} option is used all content outside of \Macro\standaloneenv\relax-ironments is
% boxed and discarded. This requires such environments to close the box first and reopen it afterwards.
%    \begin{macrocode}
\ifsa@multi\else
    \sa@ignorerestfalse
\fi
\ifsa@ignorerest
    \def\@standaloneenv#1{%
        \expandafter\let\csname sa@orig@#1\expandafter\endcsname\csname #1\endcsname
        \expandafter\let\csname sa@orig@end#1\expandafter\endcsname\csname end#1\endcsname
        \expandafter\def\csname #1\endcsname{%
            \ifnum\sa@internal=0
                \edef\@tempa{\endgroup
                    \noexpand\endsa@boxit
                    \begingroup
                    \def\noexpand\@currenvir{\@currenvir}%
                    \def\noexpand\@currenvline{\@currenvline}%
                }%
                \@tempa
                \sa@boxit
            \fi
            \advance\sa@internal\@ne
            \csname sa@orig@#1\endcsname
        }%
        \expandafter\def\csname end#1\endcsname{%
            \csname sa@orig@end#1\endcsname
            \advance\sa@internal\m@ne
            \ifnum\sa@internal=0
                \endsa@boxit
                \sa@handlebox
                \aftergroup\sa@boxit
            \fi
        }%
    }%
\else
    \def\@standaloneenv#1{%
        \expandafter\let\csname sa@orig@#1\expandafter\endcsname\csname #1\endcsname
        \expandafter\let\csname sa@orig@end#1\expandafter\endcsname\csname end#1\endcsname
        \expandafter\def\csname #1\endcsname{%
            \ifnum\sa@internal=0
                \sa@boxit
            \fi
            \advance\sa@internal\@ne
            \csname sa@orig@#1\endcsname
        }%
        \expandafter\def\csname end#1\endcsname{%
            \csname sa@orig@end#1\endcsname
            \advance\sa@internal\m@ne
            \ifnum\sa@internal=0
                \endsa@boxit
                \sa@handlebox
            \fi
        }%
    }%
\fi
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@handlebox}
% Adds the border as part of the box dimensions and places the result
% using the output format dependent \Macro\sa@placebox macro.
%    \begin{macrocode}
\def\sa@handlebox{%
    \sbox\sa@box{%
%    \end{macrocode}
% add left border
%    \begin{macrocode}
        \hskip\sa@border@left
%    \end{macrocode}
% add top border
%    \begin{macrocode}
        \@tempdima=\ht\sa@box
        \advance\@tempdima\sa@border@top\relax
        \ht\sa@box=\@tempdima
%    \end{macrocode}
% add bottom border
%    \begin{macrocode}
        \@tempdima=\dp\sa@box
        \advance\@tempdima\sa@border@bottom\relax
        \dp\sa@box=\@tempdima
%    \end{macrocode}
% Remove all depth, so that height=totalheight
%    \begin{macrocode}
        \raise\dp\sa@box
            \box\sa@box
%    \end{macrocode}
% add right border
%    \begin{macrocode}
        \hskip\sa@border@right
    }%
    \sa@placebox
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@placebox}
% Define output dependent macro to place the content box together
% with the required resizing of the page.
%    \begin{macrocode}
\ifpdf
    \def\sa@placebox{%
        \newpage
        \global\pdfpagewidth=\wd\sa@box
        \global\pdfpageheight=\ht\sa@box
        \global\paperwidth=\wd\sa@box
        \global\paperheight=\ht\sa@box
        \global\hsize=\wd\sa@box
        \global\vsize=\ht\sa@box
        \global\@colht=\ht\sa@box
        \global\@colroom=\ht\sa@box
        \noindent\usebox\sa@box
        \newpage
    }
\else
\ifxetex
    \def\sa@placebox{%
        \newpage
        \global\pdfpagewidth=\wd\sa@box
        \global\pdfpageheight=\ht\sa@box
        \global\paperwidth=\wd\sa@box
        \global\paperheight=\ht\sa@box
        \global\hsize=\wd\sa@box
        \global\vsize=\ht\sa@box
        \global\@colht=\ht\sa@box
        \global\@colroom=\ht\sa@box
        \noindent\usebox\sa@box
        \newpage
    }
\else
    \def\sa@placebox{%
        \global\paperwidth=\wd\sa@box
        \global\paperheight=\ht\sa@box
        \global\@colht=\maxdimen
        \global\@colroom=\maxdimen
        \global\hsize=\maxdimen
        \global\vsize=\maxdimen
        \sa@papersize
        \begingroup
        \@tempdima0.99626\paperwidth
        \@tempdimb0.99626\paperheight
        \edef\@tempc{\strip@pt\@tempdima}%
        \edef\@tempd{\strip@pt\@tempdimb}%
        \advance\@tempdima by .998pt
        \advance\@tempdimb by .998pt
        \def\strip@float##1.##2\relax{##1}%
        \edef\@tempa{\expandafter\strip@float\the\@tempdima\relax}%
        \edef\@tempb{\expandafter\strip@float\the\@tempdimb\relax}%
        \special{ps::%
            \@percentchar\@percentchar PageBoundingBox: 0 0 \@tempa\space\@tempb^^J%
            \@percentchar\@percentchar HiResPageBoundingBox: 0 0 \@tempc\space\@tempd^^J%
            \@percentchar\@percentchar BeginPageSetup^^J%
            << /PageSize [\@tempc\space\@tempd]
            >> setpagedevice^^J%<<
            0 0 bop^^J%
            \@percentchar\@percentchar EndPageSetup}%
        \endgroup
        \topskip=0pt
        \noindent\sa@ps@content
        \newpage
    }
%    \end{macrocode}
% \end{macro}
%
% Other macros required for PostScript output.
% They will redefine themselves to act differently for the very first page than for the remaining ones.
% \begin{macro}{\sa@ps@content}
%
% Simply place the box of the first page. Further pages need to be vertically adjusted because the
% reference point is still for the size of the first page.
%    \begin{macrocode}
\def\sa@ps@content{%
    \noindent\usebox\sa@box
    \global\def\sa@ps@content{%
        \@tempdima\sa@yoffset
        \advance\@tempdima-\topskip
        \dp\sa@box\z@
        \ht\sa@box\z@
        \noindent\lower\@tempdima\copy\sa@box
    }%
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@papersize}
% Declare official papersize as the size of the first page.
% Store offset and disable this macro for all further pages.
%    \begin{macrocode}
\def\sa@papersize{%
    \global\let\sa@papersize\relax
    \special{papersize=\the\paperwidth,\the\paperheight}%
    \global\sa@yoffset=\paperheight
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\sa@yoffset}
% Offset required to vertical adjust all further pages according to the first page.
%    \begin{macrocode}
\newlength\sa@yoffset
%    \end{macrocode}
% \end{macro}
%
% End of |\ifpdf .. \else\ifxetex .. \else| statement.
%    \begin{macrocode}
\fi\fi
%    \end{macrocode}
%
% End of \opt{crop} option code.
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Beamer code}
%
%    \begin{macrocode}
\ifstandalonebeamer
%    \end{macrocode}
% \begin{environment}{standaloneframe}
% Front-end for the beamer |frame| environment. Parses all arguments
% the same way and calls it with an added option.
%    \begin{macrocode}
\newenvironment{standaloneframe}{%
  \@ifnextchar<%
    {\@standaloneframe}%
    {\@@standaloneframe{}}%
}{\end{frame}}%
\def\@standaloneframe<#1>{%
    \@@standaloneframe{<#1>}%
}
\def\@@standaloneframe#1{%
  \@ifnextchar[%]
    {\@@@standaloneframe{#1}}%
    {\@@@standaloneframe{#1}[]}%
}%
\def\@@@standaloneframe#1[{%
  \@ifnextchar<%
    {\@@@@standaloneframe{#1}[}%
    {\@@@@@@standaloneframe{#1}[}%
}%
\def\@@@@standaloneframe#1[#2]{%
  \@ifnextchar[%]
    {\@@@@@standaloneframe{#1}{#2}}%
    {\begin{frame}#1[#2][environment=standaloneframe]}%
}%
\def\@@@@@standaloneframe#1#2[#3]{%
    \begin{frame}#1[#2][environment=standaloneframe,#3]%
}%
\def\@@@@@@standaloneframe#1[#2]{%
    \begin{frame}#1[environment=standaloneframe,#2]%
}%
%    \end{macrocode}
% \end{environment}
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Conversion code}
%    \begin{macrocode}
\ifsa@convert
%    \end{macrocode}
%
%    \begin{macrocode}
\RequirePackage{filemod-expmin}
\begingroup
\let\on@line\@gobble
%    \end{macrocode}
%
% \begin{macro}{\sa@convert}[1]{error message on failure}
% Conversion macro.
%    \begin{macrocode}
\def\sa@convert#1{%
    \edef\filemodbefore{\csname pdffilemoddate\endcsname{\outfile}}%
    \immediate\write18{\sa@convert@command}%
    \IfFileExists{\outfile}{%
        \edef\filemodafter{\csname pdffilemoddate\endcsname{\outfile}}%
        \ifx\filemodbefore\filemodafter
            \expandafter\ifx\csname pdffilemoddate\endcsname\relax\else
                \sa@convert@failuremsg{standalone}{#1}{}%
            \fi
        \else
            \ClassInfo{standalone}{Conversion successfull.}%
        \fi
    }{%
        \sa@convert@failuremsg{standalone}{#1}{}%
    }%
}
%    \end{macrocode}
% \end{macro}
%
% Provide the internal macros to the user level.
%    \begin{macrocode}
\let\infile\sa@convert@infile
\let\inext\sa@convert@inext
\let\inname\sa@convert@inname
\let\gsdevice\sa@convert@gsdevice
\let\convertexe\sa@convert@convertexe
\let\density\sa@convert@density
\let\size\sa@convert@size
\let\outext\sa@convert@outext
\let\outname\sa@convert@outname
\let\outfile\sa@convert@outfile
%    \end{macrocode}
%
% Execute preconvert command if it is set.
%    \begin{macrocode}
\edef\sa@convert@precommand{\sa@convert@precommand}%
\ifx\sa@convert@precommand\@empty\else
    \immediate\write18{\sa@convert@precommand}%
\fi
%    \end{macrocode}
%
%    \begin{macrocode}
\IfFileExists{\infile}{%
    \sa@convert@newer{%
        \ClassInfo{standalone}{Skipped conversion: outfile newer than main file.}%
    }{%
        \ifcase0%
            \expandafter\ifx\csname pdfshellescape\endcsname\relax
            \ifeof18 \else 3\fi
            \else\the\pdfshellescape\fi
        \relax% 0
            \sa@convert@failuremsg
                {standalone}{Shell escape disabled! Cannot convert file '\infile'.}{}%
        \or% 1
            \sa@convert{Conversion unsuccessful!\MessageBreak 
                        There might be something wrong with your\MessageBreak
                        conversation software or the file permissions!}%
        \else% 2 or 3
            \sa@convert{Conversion failed! Please ensure that shell escape\MessageBreak is enabled (e.g. use '-shell-escape').}%
        \fi
    }%
}{%
    \sa@convert@notfoundmsg{standalone}{Cannot convert missing input file '\infile'.}{}%
}%
\endgroup
%    \end{macrocode}
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Document Environment in Sub-Files}
% This is done at the very end so that all used packages are already loaded.
% Just in case these try also to redefine the \env{document} environment.
%
% \begin{environment}{document}
% Adds own `after begin document' and `before end document` hooks.
%    \begin{macrocode}
\begingroup
\toks@\expandafter{%
    \document
    \sa@cls@afterbegindocument
}
\xdef\document{\the\toks@}%
\toks@\expandafter{%
    \expandafter
    \sa@cls@beforeenddocument
    \enddocument
}
\xdef\enddocument{\the\toks@}%
\endgroup
%    \end{macrocode}
% \end{environment}
%
%
% \begin{macro}{\sa@cls@afterbegindocument}
% \begin{macro}{\sa@cls@beforeenddocument}
% Hooks which add the \env{standalone} environment. Surrounding spaces
% are removed. This hooks are used (instead of calling the content directly in the above macros)
% to add the possibility to fine tune this later, e.g.\ in the configuration file.
%    \begin{macrocode}
\def\sa@cls@afterbegindocument{\standalone\ignorespaces}
\def\sa@cls@beforeenddocument{\ifhmode\unskip\fi\endstandalone}
%    \end{macrocode}
% \end{macro}
% \end{macro}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%