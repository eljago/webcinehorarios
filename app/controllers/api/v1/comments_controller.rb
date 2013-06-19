module Api
  module V1
    class CommentsController < Api::V1::ApiController
  
      def create
        show = Show.find(params[:show_id])
        comment = show.comments.new
        comment.user = User.find(params[:user_id])
        comment.content = params[:content]
        if comment.save
          @comments = show.comments
          render action: 'comment_created'
        else
          render action: 'fail_create'
        end
      end
      
      def fail_create
        
      end
    end
  end
end