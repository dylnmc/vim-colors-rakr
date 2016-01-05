" Name:    rakr vim colorscheme
" Author:  Ramzi Akremi
" License: MIT

" Global setup {{{

hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'rakr'
"}}}
if has('gui_running') || &t_Co == 88 || &t_Co == 256
  " functions {{{
  " returns an approximate grey index for the given grey level

  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " returns the palette index for the given grey index
  fun <SID>grey_color(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  " returns an approximate color index for the given color level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual color level for the given color index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " returns the palette index for the given R/G/B color indices
  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " returns the palette index to approximate the given R/G/B color levels
  fun <SID>color(r, g, b)
    " get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " get the closest color
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " there are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " use the grey
        return <SID>grey_color(l:gx)
      else
        " use the color
        return <SID>rgb_color(l:x, l:y, l:z)
      endif
    else
      " only one possibility
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  endfun

  " returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
    let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
    let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
  endfun

  " sets the highlighting for the given group
  fun <SID>X(group, fg, bg, attr)
    if a:fg != ""
      exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif
    if a:bg != ""
      exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif
    if a:attr != ""
      exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
  endfun
  " }}}
  " solarized colors {{{
  let s:base03   = '002b36'
  let s:base02   = '073642'
  let s:base01   = '586e75'
  let s:base00   = '657b83'
  let s:base0    = '839496'
  let s:base1    = '93a1a1'
  let s:base2    = 'eee8d5'
  let s:base3    = 'fdf6e3'
  let s:yellow   = 'b58900'
  let s:orange   = 'cb4b16'
  let s:red      = 'dc322f'
  let s:magenta  = 'd33682'
  let s:violet   = '6c71c4'
  let s:blue     = '268bd2'
  let s:cyan     = '2aa198'
  let s:green    = '859900'
  let s:yellow1  = 'b58900'
  let s:orange1  = 'cb4b16'
  let s:red1     = 'dc322f'
  let s:magenta1 = 'd33682'
  let s:violet1  = '6c71c4'
  let s:blue1    = '268bd2'
  let s:cyan1    = '2aa198'
  let s:green1   = '859900'
  "}}}
  " Flat colors {{{
  let s:base03   = '212f3e'
  let s:base02   = '34495e'
  let s:base01   = '7f8c8d'
  let s:base00   = '95a5a6'
  let s:base0    = 'bdc3c7'
  let s:base1    = 'E8ECED'
  let s:base2    = 'ecf0f1'
  let s:base3    = 'f3f7f8'
  let s:cyan     = '16a085'
  let s:cyan1    = '07c5ac'
  let s:green    = '2ecc71'
  let s:green1   = '27ae60'
  let s:blue     = '3498db'
  let s:blue1    = '2980b9'
  let s:violet   = '8e44ad'
  let s:violet1  = '9b59b6'
  let s:yellow   = 'fec50a'
  let s:yellow1  = 'FD9809'
  let s:orange   = 'f39c12'
  let s:orange1  = 'd35400'
  let s:magenta  = '7A2B9D'
  let s:magenta1 = 'c8438c'
  let s:red      = 'e74c3c'
  let s:red1     = 'c0392b'
  "}}}
  " Invert colors if background is white {{{
  let s:is_light=(&background == 'light')

  if s:is_light
    let s:temp03  = s:base03
    let s:temp02  = s:base02
    let s:temp01  = s:base01
    let s:temp00  = s:base00
    let s:base03  = s:base3
    let s:base02  = s:base2
    let s:base01  = s:base1
    let s:base00  = s:base0
    let s:base0   = s:temp00
    let s:base1   = s:temp01
    let s:base2   = s:temp02
    let s:base3   = s:temp03

    let s:temp    = s:cyan
    let s:cyan    = s:cyan1
    let s:cyan1   = s:temp
    let s:temp    = s:green
    let s:green   = s:green1
    let s:green1  = s:temp
    let s:temp    = s:blue
    let s:blue    = s:blue1
    let s:blue1   = s:temp
    let s:temp    = s:violet
    let s:violet  = s:violet1
    let s:violet1 = s:temp
    let s:temp    = s:yellow
    let s:yellow  = s:yellow1
    let s:yellow1 = s:temp
    let s:temp    = s:orange
    let s:orange  = s:orange1
    let s:orange1 = s:temp
    let s:temp    = s:red
    let s:red     = s:red1
    let s:red1    = s:temp
  endif
  "}}}
  " Default Colors {{{
  call <SID>X('Normal',                     s:base3,    s:base03, 'none')
  call <SID>X('Comment',                    s:base00,   'none',   'italic')
  call <SID>X('Constant',                   s:green,    'none',   'none')
  call <SID>X('Identifier',                 s:blue,     'none',   'none')
  call <SID>X('Function',                   s:blue,     'none',   'none')
  call <SID>X('Statement',                  s:green,    'none',   'none')
  call <SID>X('PreProc',                    s:orange,   'none',   'none')
  call <SID>X('Type',                       s:yellow1,  'none',   'none')
  call <SID>X('Special',                    s:red,      'none',   'none')
  call <SID>X('Underlined',                 s:violet,   'none',   'underline')
  call <SID>X('Ignore',                     'none',     'none',   'none')
  call <SID>X('Error',                      s:red,      'none',   'bold')
  call <SID>X('Todo',                       s:magenta,  'none',   'bold')

  call <SID>X('SpecialKey',                 s:base00,   'none',   'reverse')
  call <SID>X('NonText',                    s:base01,   s:base03, 'none')

  " StatusLine
  " StatusLineNC

  call <SID>X('Visual',                     s:blue,     s:base03, 'reverse')
  call <SID>X('Directory',                  s:base1,     'none',   'bold')
  call <SID>X('ErrorMsg',                   s:red,      'none',   'reverse')
  call <SID>X('IncSearch',                  s:orange,   'none',   'reverse')
  call <SID>X('Search',                     s:yellow,   'none',   'reverse')
  call <SID>X('ModeMsg',                    s:blue,     'none',   'none')
  call <SID>X('MoreMsg',                    s:blue,     'none',   'none')
  call <SID>X('LineNr',                     s:base00,   s:base02, 'none')
  call <SID>X('Question',                   s:cyan,     'none',   'bold')

  call <SID>X('Delimiter',                  s:red1,     'none',   'none')

  call <SID>X('Title',                      s:red,      'none',   'bold')
  call <SID>X('VertSplit',                  s:base00,   s:base00, 'none')
  call <SID>X('WarningMsg',                 s:red,      'none',   'bold')
  call <SID>X('WildMenu',                   s:base2,    s:base02, 'reverse,bold')
  call <SID>X('Folded',                     s:base0,    s:base02, 'bold')
  call <SID>X('FoldColumn',                 s:base0,    s:base02, 'none')

  call <SID>X('DiffAdd',                    s:green,    s:base02, 'bold')
  call <SID>X('DiffChange',                 s:yellow,   s:base02, 'bold')
  call <SID>X('DiffDelete',                 s:red,      s:base02, 'bold')
  call <SID>X('DiffText',                   s:blue,     s:base02, 'bold')

  call <SID>X('SignColumn',                 s:base0,    'none',   'none')
  call <SID>X('Conceal',                    s:blue,     'none',   'none')
  call <SID>X('SpellBad',                   s:red,      'none',   'underline')
  call <SID>X('SpellCap',                   s:violet,   'none',   'underline')
  call <SID>X('SpellRare',                  s:cyan,     'none',   'underline')
  call <SID>X('SpellLocal',                 s:yellow,   'none',   'underline')
  call <SID>X('PMenu',                      s:base0,    s:base02, 'none')
  call <SID>X('PMenuSel',                   s:base01,   s:base2,  'none')
  call <SID>X('PMenuSbar',                  s:base2,    s:base0,  'none')
  call <SID>X('PMenuThumb',                 s:base0,    s:base02, 'none')
  call <SID>X('TabLine',                    s:base0,    s:base01, 'underline')
  call <SID>X('TabLineFill',                s:base0,    s:base01, 'underline')
  call <SID>X('TabLineSel',                 s:base01,   s:base2,  'underline')
  call <SID>X('CursorLine',                 'none',     s:base02, 'none')
  call <SID>X('CursorColumn',               'none',     s:base02, 'none')
  call <SID>X('Cursor',                     'none',     s:base03, 'none')
  hi link lCursor Cursor
  call <SID>X('CursorLineNr',               s:base3,    'none',   'bold')
  call <SID>X('MatchParen',                 s:yellow,   s:red,    'bold')
  
  " }}}
  " CSS/SCSS {{{
  call <SID>X('cssTagName',                 s:red,      'none',   'none')
  call <SID>X('cssAttrComma',               s:base1,    'none',   'none')
  call <SID>X('cssBraces',                  s:base1,    'none',   'none')
  call <SID>X('cssDimensionProp',           s:blue,     'none',   'none')
  hi link cssPositioningProp cssDimensionProp
  hi link cssFontProp cssDimensionProp
  hi link cssBackgroundProp cssDimensionProp
  hi link cssBoxProp cssDimensionProp
  call <SID>X('cssPositioningAttr',         s:green,    'none',   'none')
  call <SID>X('cssCommonAttr',              s:green,    'none',   'none')

  call <SID>X('cssBorderAttr',              s:green,    'none',   'none')
  call <SID>X('cssURL',                     s:magenta,  'none',   'underline')
  call <SID>X('cssColor',                   s:magenta,  'none',   'none')
  call <SID>X('cssValueNumber',             s:magenta,  'none',   'none')
  call <SID>X('cssBackgroundAttr',          s:magenta,  'none',   'none')
  call <SID>X('cssTextAttr',                s:magenta,  'none',   'none')
  call <SID>X('cssValueLength',             s:magenta,  'none',   'none')
  call <SID>X('cssUnitDecorators',          s:magenta,  'none',   'none')
  call <SID>X('cssPseudoClassId',           s:magenta,  'none',   'none')
  call <SID>X('cssFunctionName',            s:green,    'none',   'none')
  call <SID>X('cssProp',                    s:orange,   'none',   'none')

  call <SID>X('scssAmpersand',              s:green,    'none',   'bold')
  call <SID>X('scssAttribute',              s:base2,    'none',   'none')
  call <SID>X('scssDefinition',             s:base2,    'none',   'none')
  call <SID>X('scssFunctionName',           s:magenta,  'none',   'none')
  call <SID>X('scssInclude',                s:green,    'none',   'bold')
  call <SID>X('scssMixinName',              s:green,    'none',   'none')
  call <SID>X('scssMixinParams',            s:base2,    'none',   'none')
  call <SID>X('scssSelectorName',           s:magenta,  'none',   'none')
  call <SID>X('scssVariable',               s:blue,     'none',   'none')
  "}}}
  " HTML/XML {{{
  call <SID>X('HTMLEndTag',                 s:blue1, 'none',   'bold')
  call <SID>X('HTMLTag',                    s:blue1, 'none',   'bold')
  call <SID>X('HTMLTagN',                   s:blue,     'none',   'bold')
  call <SID>X('HTMLTagName',                s:blue,  'none',   'none')
  hi link xmlTagName HTMLTagName
  call <SID>X('HTMLArg',                    s:base01,    'none',   'none')
  call <SID>X('HTMLLink',                   s:red,      'none',   'underline')
  "}}}
  " NERDTree {{{
  call <SID>X('NERDTreeCWD',                s:blue,     'none',   'bold')
  call <SID>X('NERDTreeFile',               s:base2,    'none',   'none')
  call <SID>X('NERDTreeDirSlash',           s:orange,   'none',   'none')
  call <SID>X('NERDTreeGitFlags',           s:base2,    'none',   'none')
  call <SID>X('NERDTreeGitStatusDirDirty',  s:magenta,  'none',   'bold')
  call <SID>X('NERDTreeGitStatusModified',  s:orange,   'none',   'bold')
  call <SID>X('NERDTreeGitStatusUntracked', s:base2,    'none',   'bold')
  call <SID>X('NERDTreeOpenable',           s:blue,     'none',   'none')
  call <SID>X('NERDTreeClosable',           s:blue,     'none',   'none')

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg=#'. a:guibg .' guifg=#'. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade',      'green',  'none', s:green,  'none')
call NERDTreeHighlightFile('md',        'blue',   'none', s:blue,   'none')
call NERDTreeHighlightFile('markdown',  'blue',   'none', s:blue,   'none')
call NERDTreeHighlightFile('config',    'yellow', 'none', s:yellow, 'none')
call NERDTreeHighlightFile('conf',      'yellow', 'none', s:yellow, 'none')
call NERDTreeHighlightFile('json',      'green',  'none', s:magenta,  'none')
call NERDTreeHighlightFile('yml',      'green',  'none', s:magenta,  'none')
call NERDTreeHighlightFile('xml',      'green',  'none', s:magenta,  'none')
call NERDTreeHighlightFile('html',      'green',  'none', s:green,  'none')
call NERDTreeHighlightFile('css',       'cyan',   'none', s:cyan1,   'none')
call NERDTreeHighlightFile('sass',      'cyan',   'none', s:cyan,   'none')
call NERDTreeHighlightFile('scss',      'cyan',   'none', s:cyan,   'none')
call NERDTreeHighlightFile('coffee',    'Red',    'none', s:orange1,    'none')
call NERDTreeHighlightFile('js',        'Red',    'none', s:orange,    'none')
call NERDTreeHighlightFile('rb',        'Red',    'none', s:red,    'none')
call NERDTreeHighlightFile('ru',        'Red',    'none', s:red1,    'none')
call NERDTreeHighlightFile('ts',        'Blue',   'none', s:blue,   'none')
call NERDTreeHighlightFile('ds_store',  'Gray',   'none', s:base1,  'none')
call NERDTreeHighlightFile('gitconfig', 'black',  'none', s:base1,  'none')
call NERDTreeHighlightFile('gitignore', 'Gray',   'none', s:base1,  'none')



  "}}}
  " Ruby highlighting {{{

  call <SID>X('rubyArrayDelimiter',           s:base00,     'none',   'none')
  call <SID>X('rubySymbol',           s:red,     'none',   'none')

  " }}}
  " vim syntax highlightling {{{
  call <SID>X('vimBracket',                 s:red1,     'none',   'none')
  call <SID>X('vimIsCommand',               s:blue,     'none',   'none')
  call <SID>X('vimCommand',                 s:yellow,   'none',   'none')
  call <SID>X('vimCommandSep',              s:blue,     'none',   'none')
  call <SID>X('vimCommentString',           s:base01,   'none',   'underline,italic')
  call <SID>X('vimGroup',                   s:blue,     'none',   'none')
  call <SID>X('vimHiLink',                  s:blue,     'none',   'none')
  call <SID>X('vimHiGroup',                 s:blue,     'none',   'none')
  call <SID>X('vimHiLink',                  s:blue,     'none',   'none')
  call <SID>X('vimOper',                    s:green1,   'none',   'none')
  hi! link vimOperParen vimOper
  call <SID>X('vimSyncMtchOpt',             s:yellow,   'none',   'none')
  hi! link vimVar Identifier
  hi! link vimFunc Function
  hi! link vimUserFunc Function
  hi! link helpSpecial Special
  hi! link vimSet Normal
  hi! link vimSetEqual Normal
  "}}}
endif
" delete functions {{{
delf <SID>X
delf <SID>rgb
delf <SID>color
delf <SID>rgb_color
delf <SID>rgb_level
delf <SID>rgb_number
delf <SID>grey_color
delf <SID>grey_level
delf <SID>grey_number
" }}}
" vim: set fdl=0 fdm=marker:
