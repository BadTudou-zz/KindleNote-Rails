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
        access_token_qq = AccessToken.find_by(name: 'qq', openid: u.openid)
        if logged_in?
                # 更新绑定的QQ
            if !access_token_qq.nil?
                flash[:success] = "已重新绑定QQ"
                access_token_qq.update(user_id: current_user.id, name: 'qq', openid: u.openid, expires: nil, revoked:true )
            else
                # 新绑定QQ
                flash[:success] = "绑定QQ成功"
                user_info = u.get_user_info
                current_user.access_tokens.create(user_id: current_user.id, name: 'qq', openid: u.openid, expires: nil, revoked:true )
            end
            return redirect_to user_notes_path(current_user)
        else
                # 旧用户登录
             if !access_token_qq.nil?
                flash[:success] = "使用QQ登录成功"
                user = User.find(access_token_qq.user_id)
                log_in user
                return redirect_to user_notes_path(user)
            else
                # 新用户注册
                flash[:success] = "注册成功，请及时设置您的邮箱和密码"
                user_info = u.get_user_info
                new_user = User.create(name: user_info['nickname'], password_digest: 'kindlenote')
                new_user.access_tokens.create(user_id: new_user.id, name: 'qq', openid: u.openid, expires: nil, revoked:true )
                log_in new_user
                return redirect_to user_notes_path(new_user)
            end
        end
    end
end