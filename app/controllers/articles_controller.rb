class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  # def index
  #   

  #   if :pageviews_remaining >=1
  #     articles = Article.all.includes(:user).order(created_at: :desc)
  #     render json: articles, each_serializer: ArticleListSerializer
  #   end
    
  # end

  def show
    session[:pageviews_remaining]||= 3
    session[:pageviews_remaining] -= 1

    if session[:pageviews_remaining] == 0
      render json: { error: "Maximum pageview limit reached"},status: :unauthorized
    else
      article = Article.find(params[:id])
      render json: article
    end
    
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
