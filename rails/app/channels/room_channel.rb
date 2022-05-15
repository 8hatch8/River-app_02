class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_channel_#{params[:room]}'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def post(data)
    if item =
         Item.create(
           format: 'text',
           text: data['text'],
           agenda_id: data['agenda_id'],
           user_id: data['user_id'],
         )
      ActionCable.server.broadcast(
        # 配信先
        "room_channel_#{data['room_id']}",
        # 配信内容
        {
          type: 'text',
          payload: {
            id: item.id,
            text: item.text,
            user_id: item.user_id,
            agenda_id: item.agenda_id,
          },
        },
      )
    end
  end
end
