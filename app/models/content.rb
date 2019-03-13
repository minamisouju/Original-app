class Content < ApplicationRecord
    validates :original_text, presence:true, length:{maximum: 140}
    validates :converted_text, presence:true, length:{maximum: 140}, allow_nil: true
    before_validation :set_genshi
    after_save :post_twitter

    private
        def set_genshi
            cotoha = CotohaApi.new
            genshi_text = cotoha.convert_into_genshi(self.original_text)
            self.converted_text = genshi_text
        end

        def post_twitter
            twitter = TwitterApi.new
            twitter.tweet(self.id)
        end
end