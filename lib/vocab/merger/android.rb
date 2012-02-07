module Vocab
  module Merger
    class Android < Base

      def initialize( locales_dir = nil, updates_dir = nil )
        @locales_dir = locales_dir || 'res'
        @updates_dir = updates_dir || 'tmp/translations'
      end

      def merge_file( path )
        keys = english_keys
        current = current_for_locale( path )
        updates = updates_for_locale( path )

        translation = {}
        keys.each do |key|
          value = updates[ key ] || current[ key ]
          if value
            translation[ key ] = value
          else
            Vocab.ui.warn( "No translation found for key #{key} while merging #{path}" )
          end
        end

        Vocab::Translator::Android.write( translation, path )
      end

      def english_keys
        return Vocab::Translator::Android.english_keys( @locales_dir )
      end

      def current_for_locale( path )
        Vocab::Translator::Android.hash_from_xml( path )
      end

      def updates_for_locale( path )
        name = path.gsub( "#{@locales_dir}/", '' )
        update = "#{updates_dir}/#{name}"
        Vocab::Translator::Android.hash_from_xml( update )
      end

      def translation_locales
        return Vocab::Translator::Android.locales( @updates_dir )
      end

      def files_to_merge
        return translation_locales.collect do |locale|
          "#{@locales_dir}/values-#{locale}/strings.xml"
        end
      end

    end
  end
end