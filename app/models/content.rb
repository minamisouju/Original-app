class Content < ApplicationRecord
    validates :original_text, presence:true
    validates :converted_text, presence:true
end
