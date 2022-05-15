class RoomsController < ApplicationController
  before_action ::authenticate_user!

  def index
    user = User.includes(:rooms).find(current_user.id)
    rooms = user.rooms

    rooms_json =
      rooms.map do |room|
        {
          id: room.id,
          name: room.name,
          password_digest: room.password_digest,
          agendas_order: room.agendas_order,
          user_id: room.user_id,
        }
      end
    render json: rooms_json, status: 200
  end

  def show
    room = Room.includes(:agendas).find(params[:id])

    # roomがもつagendasを取得
    agendas_json = room.agendas.map { |agenda| { id: agenda.id, name: agenda.name } }

    # agendasを含めてroomを返す
    room_json = {
      id: room.id,
      name: room.name,
      password_digest: room.password_digest,
      agendas_order: room.agendas_order,
      user_id: room.user_id,
      agendas: agendas_json,
    }
    render json: room_json, status: 200
  end

  def create
    room = Room.new(room_params)

    if room.save
      render json: { message: '新規作成しました' }, status: 200
    else
      render json: { message: '作成できませんでした', erros: room.errors.messages }, status: 400
    end
  end

  def update
    room = Room.find(params[:id])

    if room.update(room_params)
      render json: { message: '更新しました' }, status: 200
    else
      render json: { message: '更新できませんでした', erros: room.errors.messages }, status: 400
    end
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    render json: { message: '削除しました' }, status: 200
  end

  private

  def room_params
    params
      .require(:rooms)
      .permit(:name, :password_digest, :agendas_order)
      .merge(user_id: current_user.id)
  end
end
