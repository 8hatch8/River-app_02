class Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def redirect_callbacks
    super
  end

  def omniauth_success
    super
    update_auth_header
  end

  def omniauth_failure
    super
  end

  private

  def update_auth_header
    super
  end

  def get_resource_from_auth_hash
    # superでは@recource（Userのインスタンス）にauth_hashの値を代入
    super

    # デフォルトがnameであるnicknameには、superで値が代入されないため、追加で設定
    @resource.nickname = auth_hash.info.name
    clean_resource
    # その後、デフォルトで@resourceの更新または新規作成処理が走る
  end

  def render_data_or_redirect(message, data, user_data = {})
    if %w[inAppBrowser newWindow].include?(omniauth_window_type)
      render_data(message, user_data.merge(data))
    elsif auth_origin_url
      # URLクエリパラメータにnicknameを追加し、アプリケーションサーバへリダイレクト
      redirect_to DeviseTokenAuth::Url.generate(
                    auth_origin_url,
                    data.merge(blank: true, nickname: user_data['nickname']),
                  )
    else
      fallback_render data[:error] || 'エラーが発生しました'
    end
  end

  def clean_resource
    @resource.nickname = strip_emoji(@resource.nickname)
  end

  def strip_emoji(str)
    # Twitterなどは絵文字が含まれる可能性があり、取り除く
    str.encode('SJIS', 'UTF-8', invalid: :replace, undef: :replace, replace: '').encode('UTF-8')
  end
end
