require 'faraday'

class BusinessLeaderboard
  def self.conn
    @@conn ||= Faraday.new(url: ENV['BUSINESS_LEADERBOARD_URL'], headers: {'Content-Type' => 'application/json'}) do |config|
      config.request :json
      config.response :json
      config.adapter Faraday.default_adapter
    end
  end

  def self.get_leaderboards(params)
    resp = conn.get('leaderboards', params)
    [resp.body, resp.status]
  end

  def self.get_leaderboard(leaderboard_id)
    resp = conn.get("leaderboards/#{leaderboard_id}")
    [resp.body, resp.status]
  end

  def self.create_leaderboard(payload)
    resp = conn.post('leaderboards', payload)
    [resp.body, resp.status]
  end

  def self.update_leaderboard(leaderboard_id, payload)
    resp = conn.patch("leaderboards/#{leaderboard_id}", payload)
    [resp.body, resp.status]
  end

  def self.delete_leaderboard(leaderboard_id)
    resp = conn.delete("leaderboards/#{leaderboard_id}")
    [resp.body, resp.status]
  end
end
