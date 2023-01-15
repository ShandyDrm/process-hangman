require 'sinatra'
require 'sinatra/json'
require 'time'

require_relative 'requests/business_logic_game'
require_relative 'requests/business_leaderboard'

post '/new-game' do
  json_new_game = JSON.parse(request.body.read)

  response_body, response_code = BusinessLogicGame.new_game(json_new_game)
  halt response_code, json(response_body)
end

put '/guess' do
  json_guess = JSON.parse(request.body.read)

  response_body, response_code = BusinessLogicGame.guess(json_guess)
  halt response_code, json(response_body)
end

post '/new-leaderboard' do
  json_new_leaderboard = JSON.parse(request.body.read)
  game_session_id = json_new_leaderboard['game_session_id']

  game_status_payload, game_status_code = BusinessLogicGame.game_status(game_session_id)
  halt 404, json(message: 'game not found') if game_status_code == 404
  halt 500, json(message: 'internal server error') unless game_status_code == 200

  game_status = game_status_payload['game_status']
  game_status_code = {
    game_is_ongoing: 100,
    game_is_won: 101,
    game_is_lost: 102,
  }

  halt 403, json(message: 'invalid game for leaderboard') unless game_status == game_status_code[:game_is_won]

  username = json_new_leaderboard['username']
  
  game_session = game_status_payload['game_session']
  game_start = Time.parse(game_session['created_at'])
  game_end = Time.parse(game_session['updated_at'])
  duration = (game_end - game_start).to_s

  level = game_session['answer'].length

  create_leaderboard_payload = {
    username: username,
    game_session_id: game_session_id,
    duration: duration,
    level: level
  }
  
  leaderboard_body, leaderboard_status = BusinessLeaderboard.create_leaderboard(create_leaderboard_payload)
  halt leaderboard_status, json(leaderboard_body)
end

get '/leaderboards' do
  response_body, response_code = DataLeaderboard.get_leaderboards(params)
  halt response_code, json(response_body)
end
