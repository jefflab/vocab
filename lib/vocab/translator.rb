# Warning: this object has some sharp edges because it is an unusual use of the i18n gem
# For example:
#   - we are calling private methods
#   - instances share the I18n.load_path, which could lead to unexpected behavior

module Vocab
  class Translator

    def load_dir( dir )
      I18n.load_path = Dir.glob( "#{dir}/**/*.{yml,rb}" )
      load_translations
    end

    def load_file( file )
      I18n.load_path = [ file ]
      load_translations
    end

    def translations
      return @backend.send( :translations )
    end

    def flattened_translations
      return @backend.flatten_translations( :en, translations, true, false )
    end

  private

    def load_translations
      @backend = I18n::Backend::Simple.new
      @backend.reload!
      @backend.send( :init_translations )
    end

  end
end