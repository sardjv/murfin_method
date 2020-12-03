class Admin::TagTypesController < ApplicationController
  def index
    @tag_types = TagType.page(params[:page])
  end

  def new
    @tag_type = TagType.new
    render action: :edit
  end

  def create
    @tag_type = TagType.new(tag_type_params)

    if @tag_type.save
      redirect_to admin_tag_types_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :edit
    end
  end

  def edit
    @tag_type = TagType.find(params[:id])
  end

  def update
    @tag_type = TagType.find(params[:id])

    if @tag_type.update(tag_type_params)
      redirect_to admin_tag_types_path, notice: notice('.successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @tag_type = TagType.find(params[:id])
    if @tag_type.destroy
      redirect_to admin_tag_types_path, notice: notice('successfully.destroyed')
    else
      redirect_to admin_tag_types_path, alert: notice('could_not_be.destroyed')
    end
  end

  private

  def notice(action)
    t("notice.#{action}", model_name: TagType.model_name.human)
  end

  def tag_type_params
    params.require(:tag_type).permit(
      :parent_id, :name, :active
    )
  end
end
