function! LoadRubyTags()
  let l:load_ruby_tags_dir = finddir('.git/..', expand('%:p:h').';')

  if !empty(l:load_ruby_tags_dir)
    let l:load_ruby_tags_gem_tags_path = l:load_ruby_tags_dir . '/.bundle/.gem_tag_files'

    if !filereadable(l:load_ruby_tags_gem_tags_path)
      let l:install_response = system('bundler plugin install vim-tags')
      let l:command_response = system('bundler vim-tags')
    endif

    let g:gem_files = json_decode(readfile(l:load_ruby_tags_gem_tags_path))
    let l:gem_comma_tags = join(values(g:gem_files), "/tags,") . '/tags'
    let l:ruby_comma_tags = join(readfile(l:load_ruby_tags_dir . '/.bundle/.ruby_tag_files'), "/tags,") . '/tags'

    setlocal includeexpr=get(g:gem_files,v:fname,v:fname)
    setlocal suffixesadd=/
    cnoremap <buffer><expr> <Plug><cfile> get(g:gem_files,expand("<cfile>"),"\022\006")

    let &l:tags = &tags . ',' . l:gem_comma_tags . ',' . l:ruby_comma_tags
  endif
endfunction

autocmd FileType ruby :call LoadRubyTags()
