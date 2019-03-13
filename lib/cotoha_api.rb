class CotohaApi    
    def initialize
        @client_id = ENV["CLIENT_ID"]
        @client_secret = ENV["CLIENT_SECRET"]
        @publish_url = ENV["ACCESS_TOKEN_PUBLISH_URL"]
        @base_url = ENV["API_BASE_URL"]
        @access_token = get_access_token
    end

    def convert_into_genshi(text)
        parsed_text = exec_parse(text)
        genshi_conversion(parsed_text)
    end

    private
        def get_response_body(url, head, body)
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            req = Net::HTTP::Post.new(uri.request_uri)
            head.each do |key, val|
                req[key] = val
            end
            req.body = body.to_json
            response = http.request(req)
            JSON.parse(response.body)
        end

        def get_access_token
            head = {"Content-Type" => "application/json"}
            body = {
                grantType: "client_credentials",
                clientId: @client_id,
                clientSecret: @client_secret
            }
            response_body = get_response_body(@publish_url, head, body)
            response_body["access_token"]
        end

        def exec_parse(utsusemi)
            url = "#{@base_url}v1/parse"
            head = {
                "Content-Type" => "application/json;charset=UTF-8",
                "Authorization" => "Bearer #{@access_token}"
            }
            body = {sentence: utsusemi}
            response_body = get_response_body(url, head, body)
            response_body['result']
        end

        def genshi_conversion(parsed_hash)
            genshi_words = []
            parsed_hash.each do |chank|
                chank['tokens'].each do |token|
                    genshi_words << token['kana'] unless token['pos'].include?('助詞')
                end
            end
            genshi_words.join(' ')
        end
end