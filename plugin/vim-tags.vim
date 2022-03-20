function! LoadRubyTags()
  let l:project_directory = finddir('.git/..', expand('%:p:h').';')

  if !empty(l:project_directory)
    let l:gem_tag_files_path = l:project_directory . '/.bundle/.gem_tag_files'

    if !filereadable(l:gem_tag_files_path) && !get(g:, 'vim_tags_skip_bundle', 0)
      let l:install_response = system('bundler plugin install vim-tags')
      let l:command_response = system('bundler vim-tags')
    endif

    if filereadable(l:gem_tag_files_path)
      let l:gems = json_decode(readfile(l:gem_tag_files_path))
      let l:ruby = json_decode(readfile(l:project_directory . '/.bundle/.ruby_tag_files'))

      let &l:tags = &tags . ',' . l:gems['tags'] . ',' . l:ruby['tags']
      let &l:path = &path . ',' . l:gems['paths'] . ',' . l:ruby['paths']
    endif
  endif
endfunction

augroup rubypath
  autocmd!
  autocmd FileType ruby setlocal suffixesadd+=.rb

  autocmd FileType ruby :call LoadRubyTags()
augroup END
