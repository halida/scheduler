module ApplicationHelper

  class BootTabBuilder < TabsOnRails::Tabs::TabsBuilder

    def tab_for(tab, name, hash_or_url, item_options = {})
      html = item_options.delete(:link_html) || {}
      html[:class] ||= ""
      html[:class] += " dropdown-item"
      html[:class] += " active" if current_tab?(tab)
      content = @context.link_to(name, hash_or_url, html)
      @context.content_tag(:li, content, item_options)
    end

    def open_tabs(options = {})
      @context.tag("ul", options, open = true)
    end

    def close_tabs(options = {})
      "</ul>".html_safe
    end
  end

  def bootstrap_tabs_tag(options = {}, &block)
    options.reverse_merge!(builder: BootTabBuilder)
    tabs_tag(options, &block)
  end

  def bootstrap_will_paginate(items)
    will_paginate(items, renderer: BootstrapPagination::Rails)
  end

  def execution_status(e)
    content_tag(:span, e.status, class: "execution-status status-#{e.status}", title: e.status)
  end

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :error   if type == :alert
      next unless [:error, :info, :success, :warning].include?(type)

      Array(message).each do |msg|
        inner = [
          '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>'.html_safe,
          msg.html_safe,
        ].join("").html_safe
        text = content_tag(:div, inner, class: "alert alert-dismissible fade show alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def hash_as_table(data)
    return unless data.present?
    render partial: "shared/hash_as_table", locals: {data: data}
  end

  def inline_hash(hash)
    hash.map do |k, v|
      [content_tag(:mark, k),
       content_tag(:span, v),
      ]
    end.flatten.join(" ").html_safe
  end

  def render_breadcrumbs
    return if @breadcrumbs.blank?
    sep = "<span class='sep'> / </span>"
    list = [nil]
    @breadcrumbs.each do |breadcrumb|
      list << link_to(breadcrumb[:name], breadcrumb[:url], breadcrumb[:options])
    end
    content_tag(:div, list.join(sep).html_safe, class: 'breadcrumbs mb-1')
  end

  def render_enabled(enabled)
    if enabled
      content_tag(:span, "Enabled", class: "label label-success")
    else
      content_tag(:span, "Disabled", class: "label label-disabled")
    end
  end

  def format_time(t, user=nil)
    return unless t
    user ||= current_user
    t.in_time_zone(user.timezone)
  end

end
