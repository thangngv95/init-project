class CommentsController < ApplicationController
  
  	before_action :set_post, only: :create

	def create  
	  @comment = current_user.comments.build(comment_params)
	  @comment.user_id = current_user.id

	  if @comment.save
	    redirect_back(fallback_location: root_path)
	  else
	    redirect_to root_path
	  end
	end

	def destroy  
	  @comment = current_user.comments.find(params[:id])
	  @micropost = @comment.micropost
	  @comment.destroy
	  redirect_to root_path
	end  

	private

	def comment_params  
	  params.require(:comment).permit(:content, :micropost_id, :user_id)
	end

	def set_post  
	  @micropost = Micropost.find(params[:comment][:micropost_id])
	end 
end
