class ItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.new(item_params)
    item.position = Item.where(agenda_id: item.agenda_id).length + 1 if item.position.blank?

    if item.save
      render json: { message: '投稿しました' }, status: 200
      type = 'post_item'
      broadcast_item(item, type)
    else
      render json: { message: '投稿できませんでした', errors: item.errors.messages }, status: 400
    end
  end

  def update
    item = Item.find(params[:id])

    if item.update(item_params)
      render json: { message: '編集しました' }, status: 200
      type = 'update_item'
      broadcast_item(item, type)
    else
      render json: { message: '編集できませんでした', errors: item.errors.messages }, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: { message: '削除しました' }, status: 200
    type = 'delete_item'
    broadcast_item(item, type)
  end

  def move
    item = Item.find(params[:id])

    if item.insert_at(item_params[:position])
      render json: { message: '移動しました' }, status: 200
      type = 'move_item'
      broadcast_item(item, type)
    else
      render json: { message: '移動できませんでした', errors: agenda.errors.messages }, status: 400
    end
  end

  private

  def item_params
    params
      .require(:item)
      .permit(:text, :format, :position, :agenda_id)
      .merge(user_id: current_user.id)
  end

  def broadcast_item(item, type)
    room_id = item.agenda.room.id
    ActionCable.server.broadcast(
      # 配信先
      "room_channel_#{room_id}",
      # 配信内容
      {
        type: type,
        item: {
          id: item.id,
          format: item.format,
          text: item.text,
          position: item.position,
          user_id: item.user_id,
          agenda_id: item.agenda_id,
        },
      },
    )
  end
end
