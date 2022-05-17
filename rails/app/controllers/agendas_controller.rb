class AgendasController < ApplicationController
  before_action :authenticate_user!

  def show
    agenda = Agenda.includes(:items).find(params[:id])

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

    if agenda.save
      agenda_json = {
        id: agenda.id,
        name: agenda.name,
        content: agenda.content,
        position: count_all_agendas + 1,
        room_id: agenda.room_id,
      }
      render json: { message: '新規作成しました', agenda: agenda_json }, status: 200
    else
      render json: { message: '作成できませんでした', erros: agenda.errors.messages }, status: 400
    end
  end

  def update
    agenda = Agenda.find(params[:id])

    if agenda.update(agenda_params)
      agenda_json = {
        id: agenda.id,
        name: agenda.name,
        content: agenda.content,
        position: agenda.position,
        room_id: agenda.room_id,
      }
      render json: { message: '更新しました', agenda: agenda_json }, status: 200
    else
      render json: { message: '更新できませんでした', erros: agenda.errors.messages }, status: 400
    end
  end

  def destroy
    agenda = Agenda.find(params[:id])
    agenda.destroy
    render json: { message: '削除しました' }, status: 200
  end

  def move
    agenda = Agenda.find(params[:id])

    if agenda.insert_at(agenda_params[:position])
      render json: { message: '移動しました' }, status: 200
    end
  end

  private

  def agenda_params
    params.require(:agenda).permit(:name, :content, :position, :room_id)
  end
end
