# frozen_string_literal: true

require "bundler"
require "json"

class VimTagsCommand < Bundler::Plugin::API
  command "vim-tags"

  def exec(*)
    write_gem_file
    write_ruby_file
    write_gem_paths_file
  end

  private

  def write_gem_file
    write_to_file(
      File.join(Bundler.app_config_path, ".gem_tag_files"),
      "\nWriting gem file tag cache",
      { tags: gem_tags, paths: gem_paths }
    )
  end

  def write_gem_paths_file
    write_to_file(
      File.join(Bundler.app_config_path, ".gem_paths"),
      "\nWriting gem paths cache",
      gem_specs.map { |spec| [spec.name, spec.full_gem_path] }.to_h.to_json
    )
  end

  def write_ruby_file
    write_to_file(
      File.join(Bundler.app_config_path, ".ruby_tag_files"),
      "Writing ruby tag cache to",
      { tags: ruby_tags, paths: $:.join(",") }
    )
  end

  def ruby_tags
    $:.select { |path| File.exist?(File.join(path, "tags")) }.join(",")
  end

  def gem_tags
    gem_specs.filter_map do |spec|
      tag_path = File.join(spec.full_gem_path, "tags")

      next unless File.exist?(tag_path)

      tag_path
    end.sort.join(",")
  end

  def gem_paths
    gem_specs.map { |spec| File.join(spec.full_gem_path, "lib") }.sort.join(",")
  end

  def gem_specs
    @gem_specs ||= Bundler.load.specs
  end

  def write_to_file(file_path, description, payload)
    puts "#{description} to #{file_path}"

    dirname = File.dirname(file_path)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    File.open(file_path, "w") do |f|
      f.truncate(0)

      f.write payload.to_json
    end
  end
end

Bundler::Plugin.add_hook("after-install-all") do |_dependencies|
  VimTagsCommand.new.exec
end
