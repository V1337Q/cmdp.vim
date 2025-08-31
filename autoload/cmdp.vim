let s:command_popup = -1
let s:current_input = ""

function! cmdp#OpenCommandPopup()
    if s:command_popup != -1
        call popup_close(s:command_popup)
    endif
    
    let s:current_input = ""
    let width = 50
    let height = 3
    let line = (&lines - height) / 2
    let col = (&columns - width) / 2
    
    let s:command_popup = popup_create('', {
        \ 'line': line,
        \ 'col': col,
        \ 'pos': 'topleft',
        \ 'minwidth': width,
        \ 'maxwidth': width,
        \ 'minheight': height,
        \ 'maxheight': height,
        \ 'padding': [0,1,0,1],
        \ 'border': [1,1,1,1],
        \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
        \ 'mapping': 0,
        \ 'filter': 'cmdp#SimplePopupFilter',
        \ 'callback': 'cmdp#CommandPopupCallback'
    \ })
    
    call cmdp#UpdatePopupDisplay()
endfunction

function! cmdp#UpdatePopupDisplay()
    let display_text = ['> Command:', s:current_input]
    call popup_settext(s:command_popup, display_text)
endfunction

function! cmdp#SimplePopupFilter(id, key)
    if a:key == "\<CR>" 
        if s:current_input != ''
            let command = s:current_input
            call popup_close(a:id)
            let s:command_popup = -1
            execute command
        endif
        return 1
        
    elseif a:key == "\<Esc>" || a:key == "\<C-c>"
        call popup_close(a:id)
        let s:command_popup = -1
        return 1
        
    elseif a:key == "\<BS>" 
        if len(s:current_input) > 0
            let s:current_input = s:current_input[:-2]
            call cmdp#UpdatePopupDisplay()
        endif
        return 1
        
    elseif a:key =~ '^[ -~]$' 
        let s:current_input .= a:key
        call cmdp#UpdatePopupDisplay()
        return 1
        
    elseif a:key == "\<C-u>" 
        let s:current_input = ""
        call cmdp#UpdatePopupDisplay()
        return 1
    endif
    
    return 0
endfunction

function! cmdp#CommandPopupCallback(id, result)
    let s:command_popup = -1
endfunction

