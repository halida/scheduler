module ApplicationHelper

  class BootTabBuilder < TabsOnRails::Tabs::TabsBuilder
    
    def tab_for(tab, name, hash_or_url, item_options = {})
      item_options[:class] = item_options[:class].to_s.split(" ").push("active").join(" ") if current_tab?(tab)
      
      content = @context.link_to(name, hash_or_url, item_options.delete(:link_html))
      @context.content_tag(:li, content, item_options)
    end
    
    def open_tabs(options = {})
      @context.tag("ul", options, open = true)
    end

    def close_tabs(options = {})
      "</ul>".html_safe
    end        
  end
  
  def boot_tabs_tag(options = {}, &block)
    options.reverse_merge!(builder: BootTabBuilder)
    tabs_tag(options, &block)
  end
end
