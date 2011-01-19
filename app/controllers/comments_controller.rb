class CommentsController < ApplicationController
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment][:comment])
    if @comment.valid?
      @comment.save
      @commentable.save
      remember_comment
      redirect_to @commentable
    else
      flash[:error] = t(:comment_could_not_be_saved, 
        :errors => @comment.errors.full_messages.join("<br/>")).html_safe
      redirect_to redirect_path
    end
  end
  
  def edit
    @commentable = params[:type].classify.constantize.find(params[:commentable_id])
    @comment = @commentable.comments.find(params[:comment_id])
  end
  
  def update
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
    @comment.comment = params[:comment][:comment]
    @comment.save
    @commentable.save    
    @new_comment = (RedCloth.new(@comment.comment).to_html.html_safe)
  end
  
  def destroy
    @commentable = params[:type].classify.constantize.find(params[:commentable_id])
    @comment = @commentable.comments.find(params[:comment_id])
    @comment.destroy
    @commentable.save
  end
  
  
  private
  
  def redirect_path
    eval("#{@commentable.class.to_s.underscore}_path(@commentable, "+
         ":comment => params[:comment][:comment])")
  end
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def remember_comment
    session[:comments] ||= []
    session[:comments] << @comment._id
  end
end