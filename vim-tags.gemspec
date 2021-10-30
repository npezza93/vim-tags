# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name    = "vim-tags"
  spec.version = "0.4.1"
  spec.authors = ["Nick Pezza"]
  spec.email   = ["pezza@hey.com"]

  spec.summary =
    "Generate cache file of all paths to tags files of dependencies"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|bin|lib)/|\.(?:git))}) ||
        f.end_with?("md") || f.end_with?("txt")
    end
  end

  spec.add_development_dependency "debug"
end
