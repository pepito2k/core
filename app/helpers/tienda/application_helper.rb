module Tienda
  module ApplicationHelper

    def body_class
      "#{params[:controller].gsub('/', '_')}_#{params[:action]}"
    end

    def navigation_manager_link(item)
      link_to item.url(self), item.link_options.merge(class: item.active?(self) ? 'active-menu' : 'inactive') do
        "<i class='fa #{item.icon}'></i>#{item.description}".html_safe
      end
    end

    def status_tag(status)
      content_tag :span, t("tienda.orders.statuses.#{status}"), :class => "status-tag #{status}"
    end

    def attachment_preview(attachment, options = {})
      if attachment
        String.new.tap do |s|
          if attachment.mounted_as == :image
            style = "style='background-image:url(#{attachment.url})'"
          else
            style = ''
          end
          s << "<div class='attachmentPreview #{attachment.mounted_as == :image ? 'image' : 'doc'}'>"
          s << "<div class='imgContainer'><div class='img' #{style}></div></div>"
          s << "<div class='desc'>"
          s << "<span class='filename'>#{link_to File.basename(attachment.path), attachment.url}</span>"
          # s << "<span class='filename'><a href='#{attachment_path(attachment)}'>#{attachment.file_name}</a></span>"
          s << "<span class='delete'>"
          s << link_to(t('helpers.attachment_preview.delete', :default => 'Delete this file?'), attachment_path(attachment), :method => :delete, :data => {:confirm => t('helpers.attachment_preview.delete_confirm', :default => "Are you sure you wish to remove this attachment?")})
          s << "</span>"
          s << "</div>"
          s << "</div>"
        end.html_safe
      elsif !options[:hide_if_blank]
        "<div class='attachmentPreview'><div class='imgContainer'><div class='img none'></div></div><div class='desc none'>#{t('helpers.attachment_preview.no_attachment')}</div></div>".html_safe
      end
    end

    def settings_label(field, html_class)
      "<label for='settings_#{field}' class='#{html_class}'>#{t("tienda.settings.labels.#{field}")}</label>".html_safe
    end

    def settings_field(field, options = {})
      default = I18n.t("tienda.settings.defaults")[field.to_sym]
      value = (params[:settings] && params[:settings][field]) || Tienda.settings[field.to_s]
      type = I18n.t("tienda.settings.types")[field.to_sym] || 'string'
      case type
      when 'boolean'
        String.new.tap do |s|
          value = default if value.blank?
          s << "<div class='radios'>"
          s << radio_button_tag("settings[#{field}]", 'true', value == true, :id => "settings_#{field}_true")
          s << label_tag("settings_#{field}_true", t("tienda.settings.options.#{field}.affirmative", :default => 'Yes'))
          s << radio_button_tag("settings[#{field}]", 'false', value == false, :id => "settings_#{field}_false")
          s << label_tag("settings_#{field}_false", t("tienda.settings.options.#{field}.negative", :default => 'No'))
          s << "</div>"
        end.html_safe
      else
        text_field_tag "settings[#{field}]", value, options.merge(:placeholder => default, :class => options[:class])
      end
    end

  end
end
