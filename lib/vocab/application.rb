require 'optparse'
require 'ostruct'

module Vocab
  class Application

    class << self
      def run
        handle_command
      end

      ##############################
      # CLI
      ##############################

      def handle_command
        options = OpenStruct.new
        parser = OptionParser.new

        parser.banner = 'Usage: vocab [-h] command [platform] [file]'
        parser.on( '-h', '--help', 'Show this usage message' ) { options.help = true }
        parser.separator ""
        parser.separator "    vocab init"
        parser.separator "    vocab extract rails"
        parser.separator "    vocab extract android"
        parser.separator "    vocab merge rails"
        parser.separator "    vocab merge android"
        parser.separator "    vocab validate android"
        parser.separator "    vocab validate rails"
        parser.separator ""

        commands = parser.parse( ARGV )
        options.command = commands[0]
        options.platform = commands[1]
        options.path = commands[2]

        if( options.command == 'init' )
          Vocab::Settings.create
        elsif( options.command == 'extract' && options.platform == 'rails' )
          Extractor::Rails.extract
        elsif( options.command == 'extract' && options.platform == 'android' )
          Extractor::Android.extract
        elsif( options.command == 'merge' && options.platform == 'rails' )
          Merger::Rails.new.merge
        elsif( options.command == 'merge' && options.platform == 'android' )
          Merger::Android.new.merge
        elsif( options.command == 'validate' && options.platform == 'android' )
          Validator::Android.new.validate
        elsif( options.command == 'validate' && options.platform == 'rails' )
          Validator::Rails.new.validate
        else
          puts parser.help
        end
      end

    end
  end
end