module ActiveSupport
  # Wrapping an array in an +ArrayInquirer+ gives a friendlier way to check
  # its string-like contents:
  #
  #   variants = ActiveSupport::ArrayInquirer.new([:phone, :tablet])
  #
  #   variants.phone?    # => true
  #   variants.tablet?   # => true
  #   variants.desktop?  # => false
  class ArrayInquirer < Array
    # Passes each element of +candidates+ collection to ArrayInquirer collection.
    # The method returns true if at least one element is the same. If +candidates+
    # collection is not given, method returns true.
    #
    #   variants = ActiveSupport::ArrayInquirer.new([:phone, :tablet])
    #
    #   variants.any?                      # => true
    #   variants.any?(:phone, :tablet)     # => true
    #   variants.any?('phone', 'desktop')  # => true
    #   variants.any?(:desktop, :watch)    # => false
    def any?(*candidates, &block)
      if candidates.none?
        super
      else
        candidates.any? do |candidate|
          include?(candidate) || include?(candidate.to_sym)
        end
      end
    end

    private
      def respond_to_missing?(name, include_private = false)
        name[-1] == '?'
      end

      def method_missing(name, *args)
        if name[-1] == '?'
          any?(name[0..-2])
        else
          super
        end
      end
  end
end
