module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_websocket_user
 
    def connect
      self.current_websocket_user = find_verified_user
    end
 
    private
      def find_verified_user
        if verified_user = User.find_by(id: cookies.encrypted[:user_id])

          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
