module ApplicationHelper
  def page_header_label
    content_for?(:page_header) ? content_for(:page_header) : t("default_page_header")
  end
end
