class ApplicationController < ActionController::Base
    before_action :ser_current_user
    
    def ser_current_user
        if session[:user_id]
            Current.user = User.find_by(id: session[:user_id])
        end
    end

    def require_user_logged_in!
        redirect_to sign_in_path, alert: "User Must be Signed In" if Current.user.nil?
    end

end
