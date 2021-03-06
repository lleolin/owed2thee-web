module I18n
  module Backend
    class SelfAware < Simple
      def resolve_hash(locale, object, subject, options)
        keys = subject.except(:string).keys
        interpolations = keys.each_with_object({}) do |key, memo|
          memo[key] = resolve(locale, :"#{object}.#{key}", subject[key],
                              options)
        end
        I18n.translate(:"#{object}.string", interpolations.merge(options))
      end

      def resolve_symbol(locale, subject, options)
        I18n.translate(subject, options.merge(locale: locale, throw: true))
      end

      def resolve_proc(locale, object, subject)
        date_or_time = options.delete(:object) || object
        resolve(locale, object, subject.call(date_or_time, options))
      end

      def resolve(locale, object, subject, options = {})
        return subject if options[:resolve] == false

        result = catch(:exception) do
          case subject
          when Hash then resolve_hash(locale, object, subject, options)
          when Symbol then resolve_symbol(locale, subject, options)
          when Proc then resolve_proc(locale, object, subject)
          else subject
          end
        end

        result unless result.is_a?(MissingTranslation)
      end
    end
  end
end

I18n.backend = I18n::Backend::SelfAware.new
