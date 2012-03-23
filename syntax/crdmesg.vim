" Language: c/r dmesg output
" Maintainer: Jeremy C. Andrus <jeremya@cs.columbia.edu>
" Last Change: 2012-03-23
" URL:

" Setup
if version >= 600
	if exists("b:current_syntax")
		finish
	endif
else
	syntax clear
endif

syn case match

" Parse the line
syn match crDmesgFuncName "\]\s*[a-zA-Z_]\+:\s\s"ms=s+1,me=e-2 contained
syn match crDmesgAssign "[^\]]\s*\w\+[:=][^\s]"ms=s+1,me=e-2 contained
syn match crDmesgSpecialChar "\\\d\d\d\|\\." contained
syn region crDmesgString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=crDmesgSpecialChar oneline contained
syn match crDmesgNumber "\W[+-]\=\(\d\+\)\=\.\=\d\+\([eE][+-]\=\d\+\)\="lc=1 contained
syn match crDmesgNumber "\W0x\x\+" contained
syn match crDmesgNumber "\W0x\s*(null)" contained
syn match crDmesgNumberRHS "\W\(0x\x\+\|-\=\d\+\)"lc=1 contained
"syn match crDmesgOtherRHS "?" contained
syn match crDmesgConstant "[A-Z_]\{2,}" contained
syn match crDmesgOperator "[-+=*/!%&|:,]" contained

syn match crDmesgSpecialFmtO "\[obj [^\]]\+\]" contained
syn match crDmesgSpecialFmtP "\[ptr [^\]]\+\]" contained
syn match crDmesgSpecialFmtV "\[sym [^\]]\+\]" contained
syn match crDmesgSpecialFmtS "\[str [^\]]\+\]" contained
syn match crDmesgSpecialFmtT "\[pid \-*\d\+ tsk [^\]]\+\]" contained
syn region crDmesgVerbosed start="(" end=")" matchgroup=Normal contained oneline

syn region crDmesgCRFunc start="\]\s*[a-zA-Z_]\+:\s\s" end="$" contains=crDmesgOperator,crDmesgNumberRHS,crDmesgSpecialChar,crDmesgConstant,crDmesgAssign,crDmesgFuncName,crDmesgVerbosed,crDmesgSpecialFmtO,crDmesgSpecialFmtP,crDmesgSpecialFmtV,crDmesgSpecialFmtS,crDmesgSpecialFmtT oneline transparent

syn match crDmesgPID "\[\s*\d\+:"ms=s+1,me=e-1 contained
syn match crDmesgPIDns ":\s*\d\+:"ms=s+1,me=e-1 contained
syn match crDmesgDbgLine ":c/r:\s*\d\+\]"ms=s+1,me=e-1 contained
syn region crDmesgInfo start="\]\s\+\["ms=s+1 end="\]"me=e-1 contains=crDmesgPID,crDmesgPIDns,crDmesgDbgLine,crDmesgErrMsg oneline transparent

syn match crDmesgTS "\[\s*\d\+\.\d\+\s*\]"ms=s+1,me=e-1 contained
syn region crDmesgLvlDebug start="^<7>" end="\]"me=e-1 contains=crDmesgTS oneline
syn region crDmesgLvlInfo start="^<6>" end="\]"me=e-1 contains=crDmesgTS oneline
syn region crDmesgLvlInfo start="^<5>" end="\]"me=e-1 contains=crDmesgTS oneline
syn region crDmesgLvlWarn start="^<4>" end="\]"me=e-1 contains=crDmesgTS oneline
syn region crDmesgLvlErr start="^<3>" end="\]"me=e-1 contains=crDmesgTS oneline

syn match crDmesgErrMsg "\[err \-\d\+\]\[pos \d\+\]\[\s*E\s*@\s*\d\+\]"ms=s+1,me=e-1
syn match crDmesgMsg " c/r:\s*[^\s0-9:][^:]\+:"me=e-1

"syn match crDmesgNIsys "!! IOS[_]ni[_]syscall:"
"syn region crDmesgComment start="/\*" end="\*/" oneline

" Define the default highlighting
if version >= 508 || !exists("did_crDmesg_syntax_inits")
	if version < 508
		let did_crDmesg_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	let s:my_syncolor=0
	if !exists(':SynColor') 
		command -nargs=+ SynColor hi def <args>
		let s:my_syncolor=1
	endif

	"Identifier
	HiLink crDmesgComment Comment
	HiLink crDmesgVerbosed Comment
	HiLink crDmesgNumber Number
	HiLink crDmesgNumberRHS Number
	HiLink crDmesgString String
	HiLink crDmesgConstant Function
	HiLink crDmesgAssign Macro
	HiLink crDmesgFuncName Statement
	HiLink crDmesgOperator Operator
	HiLink crDmesgSpecialFmtO Include
	HiLink crDmesgSpecialFmtP Include
	HiLink crDmesgSpecialFmtV Include
	HiLink crDmesgSpecialFmtS Include
	HiLink crDmesgSpecialFmtT Include
	HiLink crDmesgSpecialChar Special
	HiLink crDmesgPID PreProc
	HiLink crDmesgPIDns PreProc
	HiLink crDmesgDbgLine Structure
	HiLink crDmesgTS Comment
	HiLink crDmesgLvlDebug Comment
	HiLink crDmesgLvlInfo Macro
	HiLink crDmesgLvlWarn Todo
	HiLink crDmesgLvlErr Error
	HiLink crDmesgXNUFunc Normal
	SynColor crDmesgErrMsg guibg=firebrick3 guifg=Black gui=bold,italic
	SynColor crDmesgMsg guibg=#000044 guifg=#5555ff gui=bold

	delcommand HiLink
	delcommand SynColor
endif

let b:current_syntax = "dmesg"
