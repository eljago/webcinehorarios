class Admin::CommentsController < ApplicationController
  
  def index
    @comments = Comment.where(show_id: params[:show_id])
  end
  
  private
  
  def comment_params
    params.require(:comment).permit :author, :content, :member_id, :show
  end
end