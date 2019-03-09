class TwitterApi
    def initialize
        @twitter = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV["CONSUMER_KEY"]
            config.consumer_secret     = ENV["CONSUMER_SECRET"]
            config.access_token        = ENV["ACCESS_TOKEN"]
            config.access_token_secret = ENV["ACCESS_SECRET"]
        end
    end

    def tweet(content_id)
        genshi = Content.find(content_id)[:converted_text]
        @twitter.update!(genshi)
    end
end