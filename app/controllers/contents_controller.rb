class ContentsController < ApplicationController
    #新規作成
    def create
        @content = Content.new(content_params)
        if @content.save
            # flash[:success] = "オマエ トモダチ"
            # ツイート
            # ツイッターにとばす
        else
            flash[:danger] = "ゲンシジン　シッパイ"
            render 'home'
        end
    end

    #ツイート
    def tweet
    end

    private
        def content_params
            params.require(:content).permit(:original_text)
        end
end
