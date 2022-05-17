class ItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.new(item_params)

    if item.save
      render json: { message: '投稿しました' }, status: 200
    else
      render json: { message: '投稿できませんでした', erros: item.errors.messages }, status: 400
    end
  end

  def update
    item = Item.find(params[:id])

    if item.update(item_params)
      render json: { message: '編集しました' }, status: 200
    else
      render json: { message: '編集できませんでした', erros: item.errors.messages }, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: { message: '削除しました' }, status: 200
  end

  def move
    item = Item.find(params[:id])

    render json: { message: '移動しました' }, status: 200 if item.insert_at(item_params[:position])
  end

  private

  def item_params
    params
      .require(:item)
      .permit(:text, :format, :position, :agenda_id)
      .merge(user_id: current_user.id)
  end
end
