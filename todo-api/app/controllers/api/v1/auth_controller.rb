module Api
  module V1
    class AuthController < ApplicationController
      # POST /api/v1/auth/login
      def login
        @user = User.find_by(username: login_params[:username])
        
        if @user&.authenticate(login_params[:password])
          token = generate_token(@user)
          render json: { 
            access_token: token,
            refresh_token: generate_refresh_token(@user)
          }, status: :ok
        else
          render json: { code: 401, message: 'Invalid username or password' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.require(:login).permit(:username, :password)
      end

      def generate_token(user)
        # In a real application, you would use a JWT gem to generate a proper token
        # This is a simplified version for demonstration purposes
        payload = {
          user_id: user.id,
          username: user.username,
          exp: 24.hours.from_now.to_i
        }
        
        # In a real application, you would sign this payload with a secret key
        Base64.strict_encode64(payload.to_json)
      end

      def generate_refresh_token(user)
        # In a real application, you would use a JWT gem to generate a proper token
        # This is a simplified version for demonstration purposes
        payload = {
          user_id: user.id,
          exp: 7.days.from_now.to_i
        }
        
        # In a real application, you would sign this payload with a secret key
        Base64.strict_encode64(payload.to_json)
      end
    end
  end
end

