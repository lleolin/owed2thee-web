class PaymentPolicy < ApplicationPolicy
  attr_reader :loan
  def initialize(user, payment, loan = nil)
    super(user, payment)
    @loan = loan
  end

  def apply?
    payment_balance_is_nonzero? && LoanPolicy.new(user, loan).pay?
  end

  def confirm?
    payment_is_confirmable? && user_is_participant? && !user_is_creator?
  end

  alias payment record

  def publish?
    user_is_creator? && payment_is_publishable?
  end

  def show?
    user_is_creator? || user_is_participant?
  end

  private

  def payment_balance_is_nonzero?
    payment.balance_cents > 0
  end

  def payment_is_confirmable?
    payment_is_published? && payment.can_transition_to?(:confirmed)
  end

  def payment_is_publishable?
    payment.can_transition_to?(:published)
  end

  def payment_is_published?
    payment.published?
  end

  def user_is_creator?
    payment.creator == user
  end

  def user_is_participant?
    user_is_payee? || user_is_payer?
  end

  def user_is_payee?
    payment.payee == user
  end

  def user_is_payer?
    payment.payer == user
  end
end
