module Vocab
  module Merger
    class Base

      attr_accessor :locales_dir, :updates_dir

      def update_settings
        sha = Vocab.settings.update_translation
        Vocab.ui.say( "Updated current translation to #{sha}" )
      end

      def merge
        files_to_merge.each do |file|
          Vocab.ui.say( "Merging file: #{file}" )
          merge_file( file )
        end
        update_settings
      end
    end
  end
end