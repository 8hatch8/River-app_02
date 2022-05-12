class ItemsController < ApplicationController
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

  private

  def item_params
    params.require(:item).permit(:text, :type, :agenda_id).merge(user_id: current_user.id)
  end
end
