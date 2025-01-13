module ApplicationHelper

  class BootTabBuilder < TabsOnRails::Tabs::TabsBuilder

    def tab_for(tab, name, hash_or_url, item_options = {})
      html = item_options.delete(:link_html) || {}

      html[:class] ||= ""
      case @options[:kind]
      when :nav
        html[:class] += " dropdown-item"
        html[:class] += " active" if current_tab?(tab)
      when :tab
        item_options[:class] ||= ""
        item_options[:class] += " nav-item"
        html[:class] ||= ""
        html[:class] += " nav-link"
        html[:class] += " active" if current_tab?(tab)
      end

      content = @context.link_to(name, hash_or_url, html)
      @context.content_tag(:li, content, item_options)
    end

    def open_tabs(options = {})
      options[:class] ||= ""

      case @options[:kind]
      when :nav
        options[:class] += " dropdown-menu"
      when :tab
        options[:class] += " nav nav-tabs"
      end

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
    content_tag(:span, class: "float-end") do
      will_paginate(items, renderer: WillPaginate::ActionView::BootstrapLinkRenderer)
    end
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

  def form_errors(f)
    list = [f.error_notification]
    if f.object.errors[:base].present?
      list << \
      f.error_notification(message: f.object.errors[:base].to_sentence)
    end
    list.join("<br/>").html_safe
  end

  def hash_as_table(data)
    return unless data.present?
    render "shared/hash_as_table", data: data
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
      options = breadcrumb[:options]
      options[:class] ||= ""
      options[:class] += " text-muted"
      list << link_to(breadcrumb[:name], breadcrumb[:url], options)
    end
    content_tag(:div, list.join(sep).html_safe, class: 'breadcrumbs mb-1')
  end

  def render_enabled(enabled)
    if enabled
      content_tag(:span, "Enabled", class: "badge text-bg-success")
    else
      content_tag(:span, "Disabled", class: "badge text-bg-secondary")
    end
  end

  def format_time(t, user=nil)
    return unless t
    user ||= current_user
    t.in_time_zone(user.timezone)
  end

end
