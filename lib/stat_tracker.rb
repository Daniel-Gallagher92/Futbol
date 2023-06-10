require "csv"
require "./percentable.rb"

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

  # League Statistics

  def count_of_teams
    @teams.count
  end

end