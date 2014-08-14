class Admin::CommentsController < ApplicationController
  
  def index
    @comments = Comment.where(show_id: params[:show_id])
  end
  
end