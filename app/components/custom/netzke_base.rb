module Custom
  module NetzkeBase

    def self.included(klass)
      klass.class_eval {include ActionView::Helpers::JavaScriptHelper}
      klass.class_eval {include ActionView::Helpers::TagHelper}
      klass.class_eval {include ActionView::Helpers::UrlHelper}
    end

  end
end
