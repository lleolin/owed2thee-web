class ApplicationQuery
  attr_reader :relation

  def initialize(relation)
    @relation = relation.extending(self.class.const_get(:Scopes))
  end

  module Scopes
  end
end
