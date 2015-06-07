class BaseForm
  extend FastAttributes
  include ActiveModel::Model

  def self.model_class_name
    name.gsub(/Form$/, '')
  end

  def model_name
    @_model_name ||=
      ActiveModel::Name.new(self, nil, self.class.model_class_name)
  end
end