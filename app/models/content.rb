class Content < ApplicationRecord
    validates :original_text, presence:true
    validates :converted_text, presence:true
    before_save :convert_as_genshi

    #private
        def convert_as_genshi
            # アクセストークンの取得（postリクエストを投げる）
            # 構文解析APIにpostリクエストを送信
            # レスポンスを取得
            # 文字列を操作していい感じにする
            access_token = get_cotoha_access_token
            #original = "腹が減っては戦はできぬ"
            parsed_text = exec_cotoha_parse(access_token)
            puts parsed_text

        end

    private

        def get_cotoha_access_token
            #header = "Content-Type:application/json;charset=UTF-8"
            publish_url = ENV["ACCESS_TOKEN_PUBLISH_URL"]
            data = {
                "grantType": "client_credentials",
                "clientId": ENV["CLIENT_ID"],
                "clientSecret": ENV["CLIENT_SECRET"]
            }.to_json

            uri = URI.parse(publish_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            req = Net::HTTP::Post.new(uri.request_uri)
            req["Content-Type"] = "application/json"
            req.body = data
            res = http.request(req)
            res_body_json = JSON.parse(res.body)
            res_body_json["access_token"]
        end

        def exec_cotoha_parse(access_token)
            base_url = "#{ENV["API_BASE_URL"]}v1/parse"
            data = {
                "sentence": "腹が減っては戦はできぬ"
            }.to_json

            uri = URI.parse(base_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            req = Net::HTTP::Post.new(uri.request_uri,
                "Content-Type" => "application/json;charset=UTF-8",
                "Authorization" => "Bearer #{access_token}")
            req.body = data
            res = http.request(req)
            res_body = JSON.parse(res.body)
            into_genshi(res_body)
        end

        def into_genshi(json_output)
            result = json_output['result']
            converted_list = []
            result.each do |chank|
                chank['tokens'].each do |token|
                    converted_list << token['kana'] unless token['pos'].include?('助詞')
                end
            end
            converted_list.join(' ')
        end
end
