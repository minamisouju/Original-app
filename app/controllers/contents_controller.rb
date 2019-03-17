class ContentsController < ApplicationController
    #新規作成
    def create
        @content = Content.new(content_params)
        if @content.save
            flash[:success] = "オマエ トモダチ"
            redirect_to success_path
        else
            flash[:danger] = "ゲンシジン　シッパイ"
            redirect_to new_content_path
        end
    end

    #ツイート
    def tweet
        random_id = Content.all.map(&:id).sample
        twitter = TwitterApi.new
        twitter.tweet(random_id)
        redirect_to success_path
    end

    def new
      @content = Content.new
    end
    
    def index
      @contents = Content.all
    end

    def destroy
    end

    def home
      @content = Content.new
    end

    def success
        @content = Content.new
    end

    private
        def content_params
            params.require(:content).permit(:original_text)
        end
end
