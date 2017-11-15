# gem:Qq默认读取的是当前工作目录下的'qq_secrets.yml'，将其更改为'config'下的对应文件
Dir.chdir(Rails.root+'config')
require 'qq'
class QqController < ApplicationController
    skip_before_action :require_login, only: [:authorize, :callback]
    load_and_authorize_resource :user

    def authorize
        callback_url = request.url.chomp("authorize").concat("callback")
        begin
            session['csrf'] = Digest::MD5.hexdigest(rand.to_s)
            redirect_to "#{QQ::AUTH_URL}&state=#{session['csrf']}"
        rescue
        end
    end

    def callback
        raise 'CSRF!' if session['csrf'] != params['state']
        u = Qq.new(params['code'])
        access_token_qq = AccessToken.find_by(name: 'qq', access_token: u.openid)
        if !access_token_qq.nil?
            user = User.find(access_token_qq.user_id)
            log_in user
            return redirect_to user_notes_path(user)
        end
        current_user.access_tokens.create(user_id: current_user.id, name: 'qq', access_token: u.openid, expires: nil, revoked:true )
        render :json => {
                    status:true,
                    message: 'QQ授权成功'
        }
    end
end