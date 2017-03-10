if exists("g:loaded_cuaccp")
  finish
endif
let g:loaded_cuaccp = 1

" This block follows three principles:
"   (1) Any text editor that breaks CUA bindings for copy/cut/paste is broken.
"   (2) Any text editor that introduces security problems from pasting text
"       that was copied from a web browser is broken.
"   (3) Any text editor that, when the cursor is between two quote marks,
"       pastes text *outside* of those quote marks, is broken.
" Note that Vim breaks all three principles by default, whereas gedit breaks
" none.
if has('clipboard')
  " Destructively remove blank lines from both ends of a register and set it
  " to be characterwise. This is intended especially for pasting from the
  " quoteplus register; in almost all cases, pasting from the clipboard means
  " pasting from a different application that doesn't have any conception of
  " linewise or blockwise registers, so unconditional characterwise pasting is
  " more intuitive.
  function! s:MakeCharacterwise(reg)
    " In older versions of Vim, the call to setreg() at the end on the list
    " reg_cont crashes Vim with 'Caught deadly signal ABRT'. Git bisect
    " reveals that this is fixed with Vim 7.4 patch 513, 'Crash because
    " reference count is wrong for list returned by getreg().' Searching the
    " Git log reveals that there have been several bugs related to
    " setreg()/getreg(). The following conditional *should* fix things, but if
    " you are really worried, it's best to upgrade Vim or use the mapping from
    " $VIMRUNTIME/mswin.vim and $VIMRUNTIME/autoload/paste.vim.
    if has('nvim') || v:version > 704 || (v:version == 704 && has("patch513"))
      let reg_cont = getreg(a:reg, 1, 1)

      " Remove empty lines at the beginning and end of the register
      while (!empty(reg_cont)) && (reg_cont[-1] ==# '')
        call remove(reg_cont, -1)
      endwhile
      while (!empty(reg_cont)) && (reg_cont[0] ==# '')
        call remove(reg_cont, 0)
      endwhile
    else
      let reg_cont = getreg(a:reg)

      " Same idea as above; remove empty lines from the beginning and end.
      " Note that because the result of calling getreg() is not a list in this
      " case, any NULLs will be converted to newlines.
      while char2nr(strpart(reg_cont, len(reg_cont)-1)) == 10
        let reg_cont = strpart(reg_cont, 0, len(reg_cont)-1)
      endwhile
      while char2nr(strpart(reg_cont, 0, 1)) == 10
        let reg_cont = strpart(reg_cont, 1)
      endwhile
    endif

    call setreg(a:reg, reg_cont, 'c')
  endfunction

  vnoremap <silent> <C-X> "+x:<C-U>call <SID>MakeCharacterwise('+')<CR>
  vnoremap <silent> <C-C> "+y:<C-U>call <SID>MakeCharacterwise('+')<CR>

  nnoremap <silent> <C-V> :<C-U>call <SID>MakeCharacterwise('+')<CR>"+gP
  cnoremap <C-V> <C-R><C-R>+
  inoremap <silent> <C-V> <C-G>u<C-\><C-O>:<C-U>call <SID>MakeCharacterwise('+')<CR><C-R><C-O>+
  vnoremap <silent> <C-V> "-y:<C-U>call <SID>MakeCharacterwise('+')<CR>gv"+gp
  inoremap <silent> <C-G><C-V> <C-G>u<C-\><C-O>:<C-U>call <SID>MakeCharacterwise('+')<CR><C-R><C-R>+
endif