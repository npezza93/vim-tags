# frozen_string_literal: true

require "bundler"
require "json"

class VimTagsCommand < Bundler::Plugin::API
  command "vim-tags"

  def exec(*)
    cache_file = File.join(Bundler.app_config_path, ".gem_tag_files")

    puts "\nWriting gem file tag cache to #{cache_file}"

    File.open(cache_file, "w") do |f|
      f.truncate(0)

      f.write gem_paths.to_json
    end

    cache_file = File.join(Bundler.app_config_path, ".ruby_tag_files")

    puts "Writing ruby tag cache to #{cache_file}\n"

    File.open(cache_file, "w") do |f|
      f.truncate(0)

      f.write ruby_paths
    end
  end

  def gem_paths
    Bundler.load.specs.
      select { |spec| File.exist?(File.join(spec.full_gem_path, "tags")) }.
      to_h { |spec| [spec.name, spec.full_gem_path] }
  end

  def ruby_paths
    $:.select { |path| File.exist?(File.join(path, "tags")) }
  end
end

Bundler::Plugin.add_hook("after-install-all") do |_dependencies|
  VimTagsCommand.new.exec
end
