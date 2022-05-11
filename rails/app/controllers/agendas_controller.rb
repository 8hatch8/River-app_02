class AgendasController < ApplicationController
  def index
    agendas = Agenda.where(room_id: params[:room_id])

    agendas_json =
      agendas.map do |agenda|
        {
          id: agenda.id,
          name: agenda.name,
          content: agenda.content,
          items_order: agenda.items_order,
          room_id: agenda.room_id,
        }
      end
    render json: agendas_json, status: 200
  end

  def create
    agenda = Agenda.new(agenda_params)

    if agenda.save
      render json: { message: '新規作成しました' }, status: 200
    else
      render json: { message: '作成できませんでした', erros: agenda.errors.messages }, status: 400
    end
  end

  def update
    agenda = Agenda.find(params[:id])

    if agenda.update(agenda_params)
      render json: { message: '更新しました' }, status: 200
    else
      render json: { message: '更新できませんでした', erros: agenda.errors.messages }, status: 400
    end
  end

  def destroy
    agenda = Agenda.find(params[:id])
    agenda.destroy
    render json: { message: '削除しました' }, status: 200
  end

  private

  def agenda_params
    params.require(:agenda).permit(:name, :content, :items_order, :room_id)
  end
end
