module ApplicationHelper
  def page_header_label
    content_for?(:page_header) ? content_for(:page_header) : t("default_page_header")
  end

  def tab_link(name, selected: false)
    classes = ["govuk-tabs__list-item"]
    classes << "govuk-tabs__list-item--selected" if selected

    link = link_to(t(".tab_headers.#{name}"), "##{name}", class: "govuk-tabs__tab", id: "tab_#{name}"
    )

    content_tag(:li, link, class: classes)
  end

  def render_as_tab(name, *args)
    content_tag :div, render(name.to_s *args), id: name, class: "govuk-tabs__panel"
  end
end
