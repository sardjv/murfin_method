class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.page(params[:page])
  end

  def new
    @tag_type = TagType.find(params[:tag_type_id])
    @tag = Tag.new
  end

  def create
    @tag_type = TagType.find(params[:tag_type_id])
    @tag = @tag_type.tags.new(tag_params)
    if @tag.save
      redirect_to admin_tag_types_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :new
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      redirect_to admin_tag_types_path, notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tag_types_path, notice: notice('successfully.destroyed')
  end

  private

  def notice(action)
    t("notice.#{action}", model_name: Tag.model_name.human)
  end

  def tag_params
    params.require(:tag).permit(
      :name,
      :tag_type_id
    )
  end
end
