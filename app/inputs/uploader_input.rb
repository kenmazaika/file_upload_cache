# Snagged from: https://gist.github.com/2026284, then changed quite a bit

# A formtastic input which incorporates a cache_id that can be fetched from server
#
# Example: `form.input :file, as: "uploader"`
# 
# Copyright (c) Samuel Cochran 2012, under the [MIT license](http://www.opensource.org/licenses/mit-license).
if defined?(Formtastic)
  class UploaderInput < Formtastic::Inputs::FileInput

    def method_present?
      object.send(method).present?
    end

    def wrapper_html_options
      super.tap do |options|
        options[:class] << " present" if method_present?
      end
    end

    def cache_html
      builder.hidden_field("#{method}_cache_id", :value => object.send("cached_#{method}").try(:id), :id => "#{method}_cache")
    end

    def file_html
      builder.file_field(method, input_html_options.merge(:class => 'cached_file', :id => method))
    end

    def existing_html
      if method_present?
        existing = template.content_tag(:span, object.send("cached_#{method}").try(:original_filename))
        template.content_tag(:div, :id => "#{method}_existing") do
          template.link_to(existing, Rails.application.routes.url_helpers.cached_file_path(object.send("cached_#{method}").try(:id))) <<
          template.content_tag(:span, " replace", :id => "#{method}_replace")
        end
      end or "".html_safe
    end

    def replace_html
      file_html
    end

    def to_html
      input_wrapping do
        label_html <<
        cache_html <<
        existing_html <<
        file_html
      end
    end

  end

end
