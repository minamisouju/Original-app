FactoryBot.define do
    factory :content do
        sequence(:original_text){|i| "TEST_ORG_#{i}"}
        sequence(:converted_text){|i| "TEST_CONV_#{i}"}
    end
end