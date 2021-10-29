function! LoadRubyTags()
  if exists("g:vim_tags_loaded")
    return
  endif

  let s:load_ruby_tags_fp = finddir('.git/..', expand('%:p:h').';') . '/.bundle/.tag_files'

  if !filereadable(s:load_ruby_tags_fp)
    let s:install_response = system('bundler plugin install vim-tags')
    let s:command_response = system('bundler vim-tags')
  endif

  let s:comma_tags = system("cat " . s:load_ruby_tags_fp . " | paste -sd ',' -")
  let g:vim_tags_loaded = 1

  let &l:tags = &tags . ',' . s:comma_tags
endfunction

autocmd FileType ruby :call LoadRubyTags()
