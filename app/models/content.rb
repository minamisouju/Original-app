class Content < ApplicationRecord
    validates :original_text, presence:true, length:{maximum: 140}
    validates :converted_text, presence:true, length:{maximum: 140}
    before_save :generate_genshi
    #after_save :tweet_genshi

    #private

        def generate_genshi
            cotoha_init
            parsed_text = exec_cotoha_parse(self.original_text)
            #puts parsed_text
            self.converted_text = parsed_text
            #tweet_genshi
        end

        def tweet_genshi
            genshi = self.last.converted_text
            twitter_init
            @twitter.update!(genshi)
            #render plain: "Twitter.update"
        end

    private
        def cotoha_init
            @client_id = ENV["CLIENT_ID"]
            @client_secret = ENV["CLIENT_SECRET"]
            @publish_url = ENV["ACCESS_TOKEN_PUBLISH_URL"]
            @base_url = ENV["API_BASE_URL"]
            @access_token = get_cotoha_access_token
        end

        def get_api_response(url, head, body)
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            req = Net::HTTP::Post.new(uri.request_uri)
            head.each do |key, val|
                req[key] = val
            end
            req.body = body.to_json
            http.request(req)
        end

        def get_cotoha_access_token
            head = {"Content-Type" => "application/json"}
            body = {
                grantType: "client_credentials",
                clientId: @client_id,
                clientSecret: @client_secret
            }
            response = get_api_response(@publish_url, head, body)
            res_body = JSON.parse(response.body)
            res_body["access_token"]
        end

        def exec_cotoha_parse(utsusemi)
            url = "#{@base_url}v1/parse"
            head = {
                "Content-Type" => "application/json;charset=UTF-8",
                "Authorization" => "Bearer #{@access_token}"
            }
            body = {sentence: utsusemi}
            response = get_api_response(url, head, body)
            res_body = JSON.parse(response.body)
            into_genshi(res_body['result'])
        end

        def into_genshi(parse_result)
            genshi_words = []
            parse_result.each do |chank|
                chank['tokens'].each do |token|
                    genshi_words << token['kana'] unless token['pos'].include?('助詞')
                end
            end
            genshi_words.join(' ')
        end

        def twitter_init
            @twitter = Twitter::REST::Client.new do |config|
                config.consumer_key        = ENV["CONSUMER_KEY"]
                config.consumer_secret     = ENV["CONSUMER_SECRET"]
                config.access_token        = ENV["ACCESS_TOKEN"]
                config.access_token_secret = ENV["ACCESS_SECRET"]
            end
        end
end
