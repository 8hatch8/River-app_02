class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:roomId]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def post(data)
    position = Agenda.find(data['agenda_id']).items.length + 1
    if item =
         Item.create(
           format: 'text',
           text: data['text'],
           position: position,
           agenda_id: data['agenda_id'],
           user_id: data['user_id'],
         )
      ActionCable.server.broadcast(
        # 配信先
        "room_channel_#{params[:roomId]}",
        # 配信内容
        {
          type: 'post',
          payload: {
            id: item.id,
            format: 'text',
            text: item.text,
            position: item.position,
            user_id: item.user_id,
            agenda_id: item.agenda_id,
          },
        },
      )
    end
  end
end
