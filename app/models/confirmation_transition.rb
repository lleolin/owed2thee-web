class ConfirmationTransition < Transition
  belongs_to :confirmable,  foreign_key:  'transitional_id',
                            foreign_type: 'transitional_type',
                            polymorphic:  true
end
