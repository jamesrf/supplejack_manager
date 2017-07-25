# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

module ApplicationHelper
  include EnvironmentHelpers

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def link_to_tab(name, path, html_options={})
    li_options = {}
    li_options.reverse_merge!({class: "active"}) if request.path == path
    content_tag(:li, link_to(name, path, html_options), li_options)
  end

  def pretty_format(parser_id, raw_data)
    parser = Parser.find(parser_id) rescue nil
    if parser.present?
      format = parser.xml? ? :xml : :json
      raw_data = JSON.pretty_generate(JSON.parse(raw_data.to_json)) if format == :json
      CodeRay.scan(raw_data, format).html(line_numbers: :table).html_safe
    else
      raw_data
    end
  end

  def format_backtrace(backtrace)
    content_tag 'div' do
      backtrace.each_with_index do |span_content, index|
        concat content_tag("small", span_content)
      end
    end
  end

  def safe_users_path(params={})
    current_user.admin? ? users_path(params) : root_path
  end

  def can_show_button(action, object)
    can?(action, object) ? '' : 'disabled'
  end

  def parser_type_enabled
    ENV["PARSER_TYPE_ENABLED"] == "true"
  end
end
