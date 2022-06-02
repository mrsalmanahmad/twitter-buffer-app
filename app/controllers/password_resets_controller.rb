class PasswordResetsController < ApplicationController
    def edit
    end

    def create
        @user = User.find_by(email: params[:email])
        if @user.present?
            #Send Email
            PasswordMailer.with(user: @user).reset.deliver_now
        end
        redirect_to root_path, notice: "If user Exist we have sent you an email please check !"
    end

    def edit
        @user = User.find_signed(params[:token], purpose: "password_reset")
     rescue ActiveSupport::MessageVerifier::InvalidSignature
        redirect_to sign_in_path, alert: "Your token has expired please try again"
    end

    def update
        @user = User.find_signed(params[:token], purpose: "password_reset")
        if @user.update(password_params)
            redirect_to sign_in_path, notice: "Your Password is Changed Successfully"
        else
            render :edit
        end
    end

    private
    def password_params
        params.require(:user).permit(:password,:password_confirmation)
    end

end 
 