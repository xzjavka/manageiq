class MiqExpression::Target
  ParseError = Class.new(StandardError)

  def self.parse!(field)
    parse(field) || raise(ParseError, field)
  end

  def self.parse(field)
    match = self::REGEX.match(field) || return
    model = match[:model_name].classify.safe_constantize || return
    args = [model, match[:associations].to_s.split("."), match[:column]]
    args.push(match[:namespace] == self::MANAGED_NAMESPACE) if match.names.include?('namespace')
    new(*args)
  end

  attr_reader :model, :associations, :column

  def initialize(model, associations, column)
    @model = model
    @associations = associations
    @column = column
  end
end