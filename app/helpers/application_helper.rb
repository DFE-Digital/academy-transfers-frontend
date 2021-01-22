module ApplicationHelper
  def page_header_label
    content_for?(:page_header) ? content_for(:page_header) : t("default_page_header")
  end

  def tab_link(name, selected: false)
    classes = %w[govuk-tabs__list-item]
    classes << "govuk-tabs__list-item--selected" if selected

    link = link_to t(".tab_headers.#{name}"), "##{name}", class: "govuk-tabs__tab", id: "tab_#{name}"

    tag.li(link, class: classes)
  end

  def render_as_tab(name, *args)
    tag.div(render(name.to_s(*args)), id: name, class: "govuk-tabs__panel")
  end

  def summary_row(model, attribute, change_url: nil)
    title = tag.dt(t(".#{attribute}"), class: "govuk-summary-list__key")
    value = tag.dd(model.send(attribute), class: "govuk-summary-list__value")

    change_link = change_url ? link_to_change(model.class.name, change_url) : ""
    change = tag.dd(change_link, class: "govuk-summary-list__actions")

    tag.div(class: "govuk-summary-list__row") do
      [title, value, change].each { |e| safe_concat(e) }
    end
  end

  def link_to_change(label, url)
    hidden_span = tag.span(label, class: "govuk-visually-hidden")
    link_to("#{t('generic.change')} #{hidden_span}".html_safe, url, class: "govuk-link")
  end
end
