require "snippet"

class Previewer

  attr_reader :parser, :loader, :syntax_error, :index, :fetch_error, :fetch_error_backtrace, :document_error

  def initialize(parser, content, index=0)
    @parser = parser
    @parser.content = content if content.present?
    @loader = ParserLoader.new(parser)
    @index = index.to_i
    @syntax_error = nil
    @fetch_error = nil
    @fetch_error_backtrace = nil
  end

  def load_record
    begin
      klass = loader.parser_class
      klass.environment = "staging"
      klass.records(limit: index+1).each_with_index do |record, i|
        return record if index == i
      end
      nil
    rescue StandardError => e
      @fetch_error = e.message
      @fetch_error_backtrace = e.backtrace
      return nil
    end
  end

  def record
    return nil if @record_not_found == true

    @record ||= begin
      if loader.loaded?
        record = load_record
        if record
          record.attributes
          record.valid?
        else
          @record_not_found = true
        end
        record
      else
        @syntax_error = loader.syntax_error
        @record_not_found = true
      end
    end
  end

  def record?
    record
    !@record_not_found
  end

  def document?
    begin
      !!record.document
    rescue StandardError => e
      @document_error = e.message
      false
    end
  end

  def attributes_json
    JSON.pretty_generate(record.attributes)
  end

  def attributes_output
    CodeRay.scan(attributes_json, :json).html(:line_numbers => :table).html_safe
  end

  def pretty_xml_output
    record.raw_data
  end

  def pretty_json_output
    JSON.pretty_generate(record.raw_data)
  end

  def raw_output
    format = parser.xml? ? :xml : :json
    CodeRay.scan(self.send("pretty_#{format}_output"), format).html(line_numbers: :table).html_safe
  end

  def field_errors?
    record.field_errors.any?
  end

  def field_errors_json
    return nil unless field_errors?
    JSON.pretty_generate(record.field_errors)
  end

  def field_errors_output
    CodeRay.scan(field_errors_json, :json).html(:line_numbers => :table).html_safe if field_errors?
  end

  def validation_errors?
    !record.errors.empty?
  end

end