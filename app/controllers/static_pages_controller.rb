class StaticPagesController < ApplicationController
  def home
    @content = Content.new
  end

  def new
    @content = Content.new
  end
  
  def index
    @contents = Content.all
  end

  def success
  end
end
