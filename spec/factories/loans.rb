FactoryGirl.define do
  factory :loan, traits: %i(loan) do
    transient do
      involving nil
    end

    association :creator, factory: :confirmed_user
    amount { Faker::Commerce.price }

    factory :confirmed_debt, traits: %i(debt published confirmed)
    factory :confirmed_loan, traits: %i(published confirmed)
    factory :debt, traits: %i(debt)
    factory :published_debt, traits: %i(debt published)
    factory :published_loan, traits: %i(published) do
      factory :unconfirmed_loan
    end
    factory :unpublished_loan

    trait :confirmed do
      after(:create) do |loan, _|
        ConfirmLoan.with(loan, loan.borrower)
      end
    end

    trait :debt do
      association :lender, factory: :unconfirmed_user
      borrower { creator }
    end

    trait :loan do
      association :borrower, factory: :unconfirmed_user
      lender { creator }
    end

    trait :published do
      after(:create) do |loan, _|
        PublishLoan.with(loan, loan.creator)
      end
    end

    after :build do |loan, evaluator|
      loan.contact_name ||= loan.obligor.primary_email_address.address
      if evaluator.involving.present?
        participant = %i(borrower creator lender).sample
        loan.send(participant, evaluator.involving)
      end
    end

    after :create do |loan, _|
      CreateUserContactsForTransferParticipant.with(loan, loan.creator)
    end
  end
end
