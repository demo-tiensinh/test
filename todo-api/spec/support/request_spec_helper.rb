module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  # Generate auth token for test user
  def auth_token(user = create(:user))
    Base64.strict_encode64({ user_id: user.id, exp: 1.day.from_now.to_i }.to_json)
  end

  # Set auth headers for request
  def auth_headers(user = create(:user))
    {
      'Authorization' => "Bearer #{auth_token(user)}",
      'Content-Type' => 'application/json'
    }
  end
end

