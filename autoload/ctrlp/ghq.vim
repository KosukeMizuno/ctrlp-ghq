if exists('g:loaded_ctrlp_ghq') && g:loaded_ctrlp_ghq
  finish
endif
let g:loaded_ctrlp_ghq = 1

let s:ghq_var = {
\  'init':   'ctrlp#ghq#init()',
\  'exit':   'ctrlp#ghq#exit()',
\  'accept': 'ctrlp#ghq#accept',
\  'lname':  'ghq',
\  'sname':  'ghq',
\  'type':   'path',
\  'sort':   0,
\  'nolim':  1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:ghq_var)
else
  let g:ctrlp_ext_vars = [s:ghq_var]
endif

let s:root = join(split(system('git config --path --get-all ghq.root'), "\n"), ',')
let s:ghq_command = get(g:, 'ctrlp_ghq_command', 'ghq')

if empty(s:root)
	let s:root = expand('~/.ghq')
endif

function! ctrlp#ghq#init()
  return split(system(printf('%s list', s:ghq_command)), '\n')
endfunc

function! ctrlp#ghq#accept(mode, str)
  call ctrlp#exit()
  exe 'lcd' get(map(filter(split(globpath(s:root, a:str), '\n'), 'isdirectory(v:val)'), 'fnamemodify(v:val, "p")'), 0, '')
endfunction

function! ctrlp#ghq#exit()
  if exists('s:list')
    unlet! s:list
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#ghq#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
