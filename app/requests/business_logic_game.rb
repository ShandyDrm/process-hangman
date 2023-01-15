require 'faraday'

class BusinessLogicGame
  def self.conn
    @@conn ||= Faraday.new(url: ENV['BUSINESS_LOGIC_GAME_URL'], headers: {'Content-Type' => 'application/json'}) do |config|
      config.request :json
      config.response :json
      config.adapter Faraday.default_adapter
    end
  end

  def self.new_game(new_game_payload)
    response = conn.post('new-game', new_game_payload)
    [response.body, response.status]
  end

  def self.guess(guess_payload)
    response = conn.put('guess', guess_payload)
    [response.body, response.status]
  end

  def self.game_status(game_session_id)
    response = conn.get('game-status') do |req|
      req.body = {game_session_id: game_session_id}.to_json
    end
    [response.body, response.status]
  end
end
