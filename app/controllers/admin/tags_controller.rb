class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.order(updated_at: :desc).page(params[:page])
  end

  def new
    @tag = Tag.new
    render action: :edit
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: t('tag.notice.successfully.created')
    else
      flash.now.alert = t('tag.notice.could_not_be.created')
      render :edit
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: t('tag.notice.successfully.updated')
    else
      flash.now.alert = t('tag.notice.could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tags_path, notice: t('tag.notice.successfully.destroyed')
  end

  private

  def tag_params
    params.require(:tag).permit(
      :content
    )
  end
end
