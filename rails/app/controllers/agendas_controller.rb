class AgendasController < ApplicationController
  before_action :authenticate_user!

  def show
    agenda = Agenda.includes(items: :user).find(params[:id])

    # agendaがもつitemsを取得
    items_json =
      agenda
        .items
        .order(:position)
        .map do |item|
          {
            id: item.id,
            text: item.text,
            format: item.format,
            position: item.position,
            user_id: item.user_id,
            user_name: item.user.nickname,
          }
        end

    # itemsを含めてagendaを返す
    agenda_json = {
      id: agenda.id,
      name: agenda.name,
      content: agenda.content,
      position: agenda.position,
      room_id: agenda.room_id,
      items: items_json,
    }
    render json: agenda_json, status: 200
  end

  def create
    agenda = Agenda.new(agenda_params)
    count_all_agendas = Agenda.where(room_id: agenda.room_id).length
    agenda.position = agenda.position || count_all_agendas + 1

    if agenda.save
      render json: { message: '新規作成しました' }, status: 200
      type = 'add_agenda'
      broadcast_agenda(agenda, type)
    else
      render json: { message: '作成できませんでした', errors: agenda.errors.messages }, status: 400
    end
  end

  def update
    agenda = Agenda.find(params[:id])

    if agenda.update(agenda_params)
      render json: { message: '更新しました' }, status: 200
      type = 'update_agenda'
      broadcast_agenda(agenda, type)
    else
      render json: { message: '更新できませんでした', errors: agenda.errors.messages }, status: 400
    end
  end

  def destroy
    agenda = Agenda.find(params[:id])
    agenda.destroy
    render json: { message: '削除しました' }, status: 200
    type = 'delete_agenda'
    broadcast_agenda(agenda, type)
  end

  def move
    agenda = Agenda.find(params[:id])

    if agenda.insert_at(agenda_params[:position])
      render json: { message: '移動しました' }, status: 200
      type = 'move_agenda'
      broadcast_agenda(agenda, type)
    else
      render json: { message: '移動できませんでした', errors: agenda.errors.messages }, status: 400
    end
  end

  private

  def agenda_params
    params.require(:agenda).permit(:name, :content, :position, :room_id)
  end

  def broadcast_agenda(agenda, type)
    room_id = agenda.room_id
    ActionCable.server.broadcast(
      # 配信先
      "room_channel_#{room_id}",
      # 配信内容
      {
        type: type,
        agenda: {
          id: agenda.id,
          name: agenda.name,
          content: agenda.content,
          position: agenda.position,
          room_id: agenda.room_id,
        },
      },
    )
  end
end
