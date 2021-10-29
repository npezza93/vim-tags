# frozen_string_literal: true

require "bundler"

class VimTagsCommand < Bundler::Plugin::API
  command "vim-tags"

  def exec(*)
    cache_file = File.join(Bundler.app_config_path, ".tag_files")

    puts "\nWriting tag cache to #{cache_file}"

    File.open(cache_file, "w") do |f|
      f.truncate(0)

      f.write (gem_paths + ruby_paths).uniq.join("\n")
    end
  end

  def gem_paths
    Bundler.load.specs.filter_map do |spec|
      path = File.join(spec.full_gem_path, "tags")

      next if spec.name == "bundler" || !File.exist?(path)

      path
    end
  end

  def ruby_paths
    $:.map { |path| File.join(path, "tags") }.
      select { |path| File.exist?(path) }
  end
end

Bundler::Plugin.add_hook("after-install-all") do |_dependencies|
  VimTagsCommand.new.exec
end
