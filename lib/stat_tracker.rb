require "csv"
require_relative "percentable"

class StatTracker
  include Percentable

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = create_games(locations[:games])
    @teams = create_teams(locations[:teams])
    @game_teams = create_game_teams(locations[:game_teams])
  end

  # Helper methods for initialization
  def read_csv(file_path)
    CSV.parse(File.read(file_path), headers: true, header_converters: :symbol)
  end

  def create_games(file_path) 
    data = read_csv(file_path)
    games = []
    data.each do |row|
      games << Game.new(
        row[:game_id],
        row[:season], 
        row[:type], 
        row[:date_time], 
        row[:away_team_id], 
        row[:home_team_id],
        row[:away_goals],
        row[:home_goals],
        row[:venue],
        row[:venue_link]
      )
    end
    games
  end

  def create_teams(file_path) 
    data = read_csv(file_path)
    teams = []
    data.each do |row|
      teams << Team.new(
        row[:team_id], 
        row[:franchiseid], 
        row[:teamname], 
        row[:abbreviation], 
        row[:stadium], 
        row[:link]
      )
    end
    teams
  end

  def create_game_teams(file_path)
    data = read_csv(file_path)
    game_teams = []
    data.each do |row|
      game_teams << GameTeam.new(
        row[:game_id], 
        row[:team_id], 
        row[:hoa], 
        row[:result], 
        row[:settled_in], 
        row[:head_coach], 
        row[:goals], 
        row[:shots], 
        row[:tackles], 
        row[:pim], 
        row[:powerplayopportunities], 
        row[:powerplaygoals], 
        row[:faceoffwinpercentage], 
        row[:giveaways], 
        row[:takeaways]
      )
    end
    game_teams
  end

  # Game Statistics

  def highest_total_score
    games.map do |game|
      game.away_goals + game.home_goals
    end.max
  end

  def lowest_total_score
    games.map do |game|
      game.away_goals + game.home_goals
    end.min
  end
  
  def all_games_count #Necessary for percentage methods
    games.count
  end

  def percentage_home_wins
    hometeam_wins = game_teams.find_all do |game|
      game.hoa == "home" && game.result == "WIN"
    end.count 
    
    percentage(hometeam_wins, all_games_count)
  end

  def percentage_visitor_wins
    visitor_wins = game_teams.find_all do |game|
      game.hoa == "away" && game.result == "WIN"
    end.count 
    percentage(visitor_wins, all_games_count)
  end

  def percentage_ties
    ties = game_teams.find_all do |game|
      game.result == "TIE"
    end.count 
  
    percentage(ties, all_games_count)
  end
  
  # League Statistics

  def count_of_teams
    teams.count
  end

  def best_offense
    # Groups teams by team_id into a Hash
    team_hash = game_teams.group_by do |game_team|
      game_team.team_id
    end

    # Changes Hash values into the team's average score
    team_hash.transform_values! do |game_teams|
      total_team_goals = game_teams.sum{ |game_team| game_team.goals }
      total_games = game_teams.count
      
      avg_goals_per_game = percentage(total_team_goals, total_games)
      avg_goals_per_game
    end

    # Returns the K/V pair of the team with the highest avg goals per game
    best_offense_team = team_hash.max_by do |team_id, avg_goals_per_game|
      avg_goals_per_game
    end

    best_offense_team_id = best_offense_team[0]

    # Finds the matching team from @teams by the team ID
    # Maybe turn this into a helper method?
    best_offense_team = @teams.find do |team| 
      team.team_id == best_offense_team_id
    end
    
    best_offense_team.team_name
  end

  def worst_offense
    # Groups teams by team_id into a Hash
    team_hash = game_teams.group_by do |game_team|
      game_team.team_id
    end

    # Changes Hash values into the team's average score
    team_hash.transform_values! do |game_teams|
      total_team_goals = game_teams.sum{ |game_team| game_team.goals }
      total_games = game_teams.count
      
      avg_goals_per_game = percentage(total_team_goals, total_games)
      avg_goals_per_game
    end

    # Returns the K/V pair of the team with the highest avg goals per game
    worst_offense_team = team_hash.min_by do |team_id, avg_goals_per_game|
      avg_goals_per_game
    end

    worst_offense_team_id = worst_offense_team[0]

    # Finds the matching team from @teams by the team ID
    # Maybe turn this into a helper method?
    worst_offense_team = @teams.find do |team| 
      team.team_id == worst_offense_team_id
    end
    
    worst_offense_team.team_name
  end

  # Season Statistics
  
  def most_tackles(season)
    team_tackles = Hash.new { |hash, team_id| hash[team_id] = 0 }
  
    games_for_season = games.select { |game| game.season == season }
    games_for_season.each do |game|
      game_teams_for_season = game_teams.select { |game_team| game_team.game_id == game.game_id }
      game_teams_for_season.each do |game_team|
        team_id = game_team.team_id
        tackles = game_team.tackles.to_i
        team_tackles[team_id] += tackles
      end
    end
  
    most_tackles_team_id = team_tackles.max_by { |_team_id, tackles| tackles }&.first
    most_tackles_team = teams.find { |team| team.team_id == most_tackles_team_id }
  
    most_tackles_team&.team_name
  end
  
  def fewest_tackles(season)
    team_tackles = Hash.new { |hash, team_id| hash[team_id] = 0 }
  
    games_for_season = games.select { |game| game.season == season }
    games_for_season.each do |game|
      game_teams_for_season = game_teams.select { |game_team| game_team.game_id == game.game_id }
      game_teams_for_season.each do |game_team|
        team_id = game_team.team_id
        tackles = game_team.tackles.to_i
        team_tackles[team_id] += tackles
      end
    end
  
    fewest_tackles_team_id = team_tackles.min_by { |_team_id, tackles| tackles }&.first
    fewest_tackles_team = teams.find { |team| team.team_id == fewest_tackles_team_id }
  
    fewest_tackles_team&.team_name
  end

  def season_game_teams(season) 
    # Returns an array of game_teams for a given season
    games_for_season = @games.find_all do |game| 
      game.season == season
    end

    game_ids = games_for_season.map do |game| 
      game.game_id
    end

    @game_teams.find_all do |game_team|
      game_ids.include?(game_team.game_id)
    end
  end

  def season_wins(season) 
    # Returns a hash of head coaches and their win count for a given season
    season_game_teams = season_game_teams(season)
    head_coaches = season_game_teams.group_by do |game_team| 
      game_team.head_coach
    end

    head_coaches.each do |coach, game_teams|
      head_coaches[coach] = game_teams.find_all do |game_teams| 
        game_team.result == "WIN"
      end.count
    end
  end

  def winningest_coach(season) 
    #There is a tie between Claude Julien and Joel Quenneville
    head_coaches = season_wins(season)
    head_coaches.max_by do |coach, wins|
      wins
    end.first
  end

  def worst_coach(season) 
    head_coaches = season_wins(season)
    head_coaches.min_by do |coach, wins|
      wins
    end.first
  end

  def worst_coach_by_opinion
    #Although he is not the worst coach, he is the worst person
    "John Tortorella"
  end
  
  def best_coach_by_opinion
    #Not up for debate
    "Jon Cooper"
  end  
end