" ==============================================================================
" ~/.vim/colors/matushell.vim - Dynamic Material You Theme for Vim
" Ported directly from matugen / Neovim matushell.lua
" ==============================================================================

highlight clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "matushell"
set background=dark

" 1. Read dynamic colors from matugen (fallback to current active palette)
function! s:get_palette() abort
    let l:p = {
        \ 'background': '#0B0F11',
        \ 'on_background': '#DEE7ED',
        \ 'surface': '#0B0F11',
        \ 'surface_container': '#141A1E',
        \ 'surface_container_low': '#0F1417',
        \ 'surface_container_high': '#1A2124',
        \ 'surface_container_highest': '#1F272B',
        \ 'on_surface': '#DEE7ED',
        \ 'on_surface_variant': '#A4ACB2',
        \ 'outline': '#6E777C',
        \ 'outline_variant': '#41494E',
        \ 'primary': '#A3CCE3',
        \ 'on_primary': '#184557',
        \ 'primary_container': '#2E576B',
        \ 'on_primary_container': '#C1E9FF',
        \ 'secondary': '#B4CAD6',
        \ 'secondary_container': '#2A3E48',
        \ 'on_secondary_container': '#ADC2CF',
        \ 'tertiary': '#B8C5F2',
        \ 'on_tertiary': '#3E4C71',
        \ 'tertiary_container': '#38466B',
        \ 'on_tertiary_container': '#DAE2FF',
        \ 'error': '#FA746F'
        \ }

    let l:path = expand('~/.cache/matugen/nvim.json')
    if !filereadable(l:path)
        let l:path = expand('~/.local/state/caelestia/scheme.json')
    endif

    if filereadable(l:path)
        try
            let l:raw = join(readfile(l:path), '')
            let l:data = json_decode(l:raw)
            if has_key(l:data, 'colors') && has_key(l:data.colors, 'dark')
                let l:dark = l:data.colors.dark
                for [k, v] in items(l:dark)
                    if type(v) == v:t_string && v =~ '^#[0-9a-fA-F]\{6\}$'
                        let l:p[k] = v
                    endif
                endfor
            elseif has_key(l:data, 'colours')
                for [k, v] in items(l:data.colours)
                    if type(v) == v:t_string && v =~ '^[0-9a-fA-F]\{6\}$'
                        let l:p[k] = '#' . v
                    endif
                endfor
            endif
        catch
        endtry
    endif
    return l:p
endfunction

let s:p = s:get_palette()

" Transparency setting (default: 1 to match Neovim transparency.lua)
let s:transparent = get(g:, 'matushell_transparent', 1)
let s:bg = s:transparent ? 'NONE' : s:p.surface
let s:container_bg = s:transparent ? 'NONE' : s:p.surface_container

" Helper function to set highlights cleanly
function! s:hi(group, guifg, guibg, gui) abort
    let l:cmd = 'highlight ' . a:group
    if !empty(a:guifg)
        let l:cmd .= ' guifg=' . a:guifg
    endif
    if !empty(a:guibg)
        let l:cmd .= ' guibg=' . a:guibg
    endif
    if !empty(a:gui)
        let l:cmd .= ' gui=' . a:gui . ' cterm=' . a:gui
    else
        let l:cmd .= ' gui=NONE cterm=NONE'
    endif
    execute l:cmd
endfunction

" -----------------------------------------------------------------------------
" 2. Syntax Highlighting (Eliminates ugly default yellow!)
" -----------------------------------------------------------------------------
" Comments & Doc
call s:hi('Comment', s:p.on_surface_variant, 'NONE', 'italic')
call s:hi('SpecialComment', s:p.on_surface_variant, 'NONE', 'italic')

" Constants, Numbers & Types (Soft Lavender / Tertiary)
call s:hi('Constant', s:p.tertiary, 'NONE', '')
call s:hi('Number', s:p.tertiary, 'NONE', '')
call s:hi('Boolean', s:p.tertiary, 'NONE', 'bold')
call s:hi('Float', s:p.tertiary, 'NONE', '')
call s:hi('Type', s:p.tertiary, 'NONE', 'italic')
call s:hi('StorageClass', s:p.tertiary, 'NONE', 'italic')
call s:hi('Structure', s:p.tertiary, 'NONE', 'italic')
call s:hi('Typedef', s:p.tertiary, 'NONE', 'italic')

" Strings (Soft Sky Blue / Primary - NOT yellow!)
call s:hi('String', s:p.primary, 'NONE', '')
call s:hi('Character', s:p.primary, 'NONE', '')

" Functions & Identifiers (Soft Secondary Accent)
call s:hi('Function', s:p.secondary, 'NONE', '')
call s:hi('Identifier', s:p.on_surface, 'NONE', '')

" Statements, Keywords, Loops (Soft Primary Accent - NOT yellow!)
call s:hi('Statement', s:p.primary, 'NONE', 'bold')
call s:hi('Conditional', s:p.primary, 'NONE', 'bold')
call s:hi('Repeat', s:p.primary, 'NONE', 'bold')
call s:hi('Label', s:p.primary, 'NONE', 'bold')
call s:hi('Keyword', s:p.primary, 'NONE', 'bold')
call s:hi('Exception', s:p.primary, 'NONE', 'bold')

" Operators & Delimiters
call s:hi('Operator', s:p.secondary, 'NONE', '')
call s:hi('Delimiter', s:p.on_surface_variant, 'NONE', '')
call s:hi('Special', s:p.secondary, 'NONE', '')
call s:hi('SpecialChar', s:p.secondary, 'NONE', '')
call s:hi('Tag', s:p.secondary, 'NONE', '')

" Preprocessor & Errors (Coral Red / Error Accent)
call s:hi('PreProc', s:p.error, 'NONE', '')
call s:hi('Include', s:p.error, 'NONE', '')
call s:hi('Define', s:p.error, 'NONE', '')
call s:hi('Macro', s:p.error, 'NONE', '')
call s:hi('PreCondit', s:p.error, 'NONE', '')
call s:hi('Debug', s:p.error, 'NONE', '')
call s:hi('Error', s:p.error, 'NONE', 'bold')
call s:hi('Todo', s:p.on_tertiary, s:p.tertiary, 'bold')
call s:hi('Title', s:p.primary, 'NONE', 'bold')

" -----------------------------------------------------------------------------
" 3. Editor UI Elements
" -----------------------------------------------------------------------------
call s:hi('Normal', s:p.on_surface, s:bg, '')
call s:hi('NormalNC', s:p.on_surface, s:bg, '')
call s:hi('CursorLine', '', s:p.surface_container_high, '')
call s:hi('CursorColumn', '', s:p.surface_container_high, '')
call s:hi('LineNr', s:p.outline, 'NONE', '')
call s:hi('CursorLineNr', s:p.primary, 'NONE', 'bold')
call s:hi('SignColumn', '', s:bg, '')
call s:hi('VertSplit', s:p.outline_variant, 'NONE', '')
call s:hi('WinSeparator', s:p.outline_variant, 'NONE', '')
call s:hi('Folded', s:p.on_surface_variant, s:p.surface_container, '')
call s:hi('FoldColumn', s:p.outline, 'NONE', '')
call s:hi('ColorColumn', '', s:p.surface_container, '')
call s:hi('NonText', s:p.outline_variant, 'NONE', '')
call s:hi('EndOfBuffer', s:p.outline_variant, 'NONE', '')
call s:hi('Whitespace', s:p.outline_variant, 'NONE', '')
call s:hi('MatchParen', s:p.primary, 'NONE', 'bold,underline')

" Selections & Search
call s:hi('Visual', s:p.on_primary_container, s:p.primary_container, '')
call s:hi('VisualNOS', s:p.on_primary_container, s:p.primary_container, '')
call s:hi('Search', s:p.on_tertiary_container, s:p.tertiary_container, '')
call s:hi('IncSearch', s:p.on_primary, s:p.primary, 'bold')
call s:hi('CurSearch', s:p.on_primary, s:p.primary, 'bold')

" Popup Menu / WildMenu
call s:hi('Pmenu', s:p.on_surface, s:p.surface_container, '')
call s:hi('PmenuSel', s:p.on_primary_container, s:p.primary_container, 'bold')
call s:hi('PmenuSbar', '', s:p.surface_container, '')
call s:hi('PmenuThumb', '', s:p.outline, '')
call s:hi('WildMenu', s:p.on_primary_container, s:p.primary_container, 'bold')

" StatusLine & Tabs
call s:hi('StatusLine', s:p.on_surface, s:p.surface_container, 'bold')
call s:hi('StatusLineNC', s:p.on_surface_variant, s:p.surface_container_low, '')
call s:hi('StatusModeNormal', s:p.surface, s:p.primary, 'bold')
call s:hi('StatusModeInsert', s:p.surface, s:p.tertiary, 'bold')
call s:hi('StatusModeVisual', s:p.surface, s:p.secondary, 'bold')
call s:hi('StatusModeReplace', s:p.surface, s:p.error, 'bold')
call s:hi('StatusLineInfo', s:p.on_surface_variant, s:p.surface_container, '')
call s:hi('TabLine', s:p.on_surface_variant, s:p.surface_container, '')
call s:hi('TabLineSel', s:p.primary, s:bg, 'bold')
call s:hi('TabLineFill', '', s:p.surface_container_low, '')

" Netrw / Directories
call s:hi('Directory', s:p.secondary, 'NONE', 'bold')
call s:hi('netrwDir', s:p.secondary, 'NONE', 'bold')
call s:hi('netrwClassify', s:p.outline, 'NONE', '')
call s:hi('netrwLink', s:p.tertiary, 'NONE', '')
call s:hi('netrwSymLink', s:p.tertiary, 'NONE', '')
call s:hi('netrwTreeBar', s:p.outline_variant, 'NONE', '')

" Diff
call s:hi('DiffAdd', s:p.primary, '#203833', '')
call s:hi('DiffChange', '', '#27344a', '')
call s:hi('DiffDelete', s:p.error, '#3e1b1c', '')
call s:hi('DiffText', s:p.on_surface, '#38466b', 'bold')
