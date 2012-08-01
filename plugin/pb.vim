" pb.vim plugin for interacting with Mac OS X pastebuffer
" Maintainer: Dmitry "troydm" Geurkov <d.geurkov@gmail.com>
" Version: 0.1
" Description: pb.vim plugin simplifies interaction with Mac OS X pastebuffer
" using pbcopy and pbpaste utilities by providing convienient commands for
" yanking into mac os x pastebuffer and pasting from it
" Last Change: 1 August, 2012
" License: Vim License (see :help license)
" Website: https://github.com/troydm/pb.vim
"
" See pb.vim for help.  This can be accessed by doing:

if v:version < 700
  echoerr "pb.vim: this plugin requires vim >= 7!"
  finish
endif

" Options
if !exists("g:pb_command_prefix")
  let g:pb_command_prefix = ''  
endif

" Utility function to get current buffer line ending symbols
function! s:GetCurrentLineEnding()
  if &ff == 'unix'
    return "\n"
  endif
  if &ff == 'mac'
    return "\r"
  endif
  return "\r\n"
endfunction

command! -register -range Pbyank :call <SID>PbyankText(<line1>,<line2>,"<reg>")
function! s:PbyankText(l1,l2,r)
  if a:r == ''
    let text = join(getline(a:l1,a:l2),s:GetCurrentLineEnding())
  else
    let text = getreg(a:r)
  endif
  call system(g:pb_command_prefix . 'pbcopy', text)
endfunction

command! -register -range Pbpaste :call <SID>PbpasteText(<line1>,<line2>,"<reg>")
function! s:PbpasteText(l1,l2,r)
  let text = system(g:pb_command_prefix . 'pbpaste')
  if a:r == ''
    let save_cursor = getpos(".")
    let cursor = getpos(".")
    let cursor[1] = a:l1
    if a:l1 != a:l2
      execute ''.a:l1.','.a:l2.'delete'
      call append(a:l1-1,'')
    endif
    call setpos('.', cursor)
    let prevreg = getreg(v:register)
    call setreg(v:register,text)
    normal p
    call setreg(v:register,prevreg)
    call setpos('.', save_cursor)
  else
    call setreg(a:r,text)
  endif
endfunction

" vim: set sw=2 sts=2 et fdm=marker:
