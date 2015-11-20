class CreatePasswordReset < CreateTemporarySignin
  attr_reader :email_address

  delegate :user, to: :email_address

  def initialize(email_address)
    @email_address = email_address
    super
  end

  def create_temporary_signin
    @temporary_signin = PasswordReset.create!(email_address: email_address,
                                              user: user)
  end
end
