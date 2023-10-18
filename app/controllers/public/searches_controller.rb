class Public::SearchesController < ApplicationController

  def search
    @posts = Post.search(params[:word])
    render "/public/searches/search_result"
  end

end
