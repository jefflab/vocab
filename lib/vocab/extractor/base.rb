module Vocab
  module Extractor
    class Base
      class << self
        def extract( diff_path = nil, full_path = nil )
          current = extract_current
          previous = extract_previous
          diff = diff( previous, current )
          write_diff( diff, diff_path )
          write_full( current, full_path )
          print_instructions
        end

        # make a hash of all the translations that are new or changed in the current yml
        def diff( previous, current )
          diff = {}
          current.each do |key, value|
            previous_value = previous[ key ]
            if( previous_value.nil? || previous_value != value )
              diff[ key ] = value
            end
          end
          return diff
        end

        def extract_previous
          raise "extract_previous not implemented"
        end

        def extract_current
          raise "extract_current not implemented"
        end

        def write_diff( diff, path )
          raise "write_diff not implemented"
        end

        def write_full( diff, path )
          raise "write_full not implemented"
        end

        def previous_file( path, sha )
          path = git_path( path )
          return `cd #{Vocab.root} && git show #{sha}:#{path}`
        end

        def git_root
          return `git rev-parse --show-toplevel`.strip
        end

        def git_path( path )
          return File.expand_path( path ).gsub( "#{git_root}/", '' )
        end

        def print_instructions( values = {} )
instructions = <<-EOS

Instructions for integrating new translations:

For existing languages, send #{values[:diff]} to get translations for new keys
For new languages, send #{values[:full]} to get translations for all keys

To integrate new translations, files must be in tmp/translations.  For example:

#{values[:tree]}

After translations are in place, you can merge them into the project with:

vocab merge rails

EOS
          Vocab.ui.say( instructions )
        end

      end
    end
  end
end