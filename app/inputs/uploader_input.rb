# A formtastic input which incorporates a cache_id that can be fetched from server
#
# Example: `form.input :file, as: "uploader"`
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
      builder.hidden_field("#{method}_cache_id", :value => object.send("cached_#{method}").try(:id), :id => "#{base_id}_cache")
    end

    def file_html
      builder.file_field(method, input_html_options.merge(:class => 'cached_file', :id => base_id))
    end

    def existing_html
      if method_present?
        existing = template.content_tag(:span, object.send("cached_#{method}").try(:original_filename))
        template.content_tag(:div, :id => "#{base_id}_existing") do
          template.link_to(existing, Rails.application.routes.url_helpers.file_upload_cache_cached_file_path(object.send("cached_#{method}").try(:id))) <<
          template.content_tag(:span, " replace", :id => "#{base_id}_replace")
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

    def base_id
      input_html_options[:id] || method
    end

  end

end
