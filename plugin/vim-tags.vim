function! LoadRubyTags()
  let s:load_ruby_tags_gp = finddir('.git/..', expand('%:p:h').';')

  if !empty(s:load_ruby_tags_gp)
    let s:load_ruby_tags_fp = s:load_ruby_tags_gp  . '/.bundle/.tag_files'

    if !filereadable(s:load_ruby_tags_fp)
      let s:install_response = system('bundler plugin install vim-tags')
      let s:command_response = system('bundler vim-tags')
    endif

    let g:gem_files = json_decode(readfile(s:load_ruby_tags_fp))
    let l:comma_tags = join(values(g:gem_files), "/tags,") . '/tags'

    setlocal includeexpr=get(g:gem_files,v:fname,v:fname)
    setlocal suffixesadd=/
    cnoremap <buffer><expr> <Plug><cfile> get(g:gem_files,expand("<cfile>"),"\022\006")

    let &l:tags = &tags . ',' . l:comma_tags
  endif
endfunction

autocmd FileType ruby :call LoadRubyTags()
