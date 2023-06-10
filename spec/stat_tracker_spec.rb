require 'spec_helper'

RSpec.describe StatTracker do 
  before(:each) do 
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'
    
    locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    
    @stat_tracker = StatTracker.from_csv(locations)
  end

  describe "#Initialize" do 
    it "exists w/ attribute" do 
      expect(@stat_tracker).to be_a(StatTracker)
      expect(@stat_tracker.games).to be_a(Array)
      expect(@stat_tracker.teams).to be_a(Array)
      expect(@stat_tracker.game_teams).to be_a(Array)
    end
  end

  describe "#Create_games" do 

    it "can create games" do 
      expected_game_data = {
        away_goals: 2,
        away_team_id: "3",
        date_time: "5/16/13",
        game_id: "2012030221",
        home_goals: 3,
        home_team_id: "6",
        season: "20122013",
        type: "Postseason",
        venue: "Toyota Stadium",
        venue_link: "/api/v1/venues/null"
      }
      
      test_game = @stat_tracker.games.first

      expect(test_game).to be_a(Game)
      expect(test_game.away_goals).to eq(expected_game_data[:away_goals])
      expect(test_game.away_team_id).to eq(expected_game_data[:away_team_id])
      expect(test_game.date_time).to eq(expected_game_data[:date_time])
      expect(test_game.game_id).to eq(expected_game_data[:game_id])
      expect(test_game.home_goals).to eq(expected_game_data[:home_goals])
      expect(test_game.home_team_id).to eq(expected_game_data[:home_team_id])
      expect(test_game.season).to eq(expected_game_data[:season])
      expect(test_game.type).to eq(expected_game_data[:type])
      expect(test_game.venue).to eq(expected_game_data[:venue])
      expect(test_game.venue_link).to eq(expected_game_data[:venue_link])
    end
  end
  
  describe "#Create_teams" do
    it "can create a team" do 
      expected_team_data = {
        abbreviation: "ATL",
        franchise_id: "23",
        link: "/api/v1/teams/1",
        stadium: "Mercedes-Benz Stadium",
        team_id: "1",
        team_name: "Atlanta United"
      }

      test_team = @stat_tracker.teams.first

      expect(test_team).to be_a(Team)
      expect(test_team.abbreviation).to eq(expected_team_data[:abbreviation])
      expect(test_team.franchise_id).to eq(expected_team_data[:franchise_id])
      expect(test_team.link).to eq(expected_team_data[:link])
      expect(test_team.stadium).to eq(expected_team_data[:stadium])
      expect(test_team.team_id).to eq(expected_team_data[:team_id])
      expect(test_team.team_name).to eq(expected_team_data[:team_name])

    end
  end

  describe "#Create_game_teams" do
    it "can create a game_team" do 
      expected_game_team_data = {
        face_off_win_percentage: 44.8,
        game_id: "2012030221",
        giveaways: 17,
        goals: 2,
        head_coach: "John Tortorella",
        hoa: "away",
        pim: 8,
        power_play_goals: 0,
        power_play_opportunities: 3,
        result: "LOSS",
        settled_in: "OT",
        shots: 8,
        tackles: 44,
        takeaways: 7,
        team_id: "3"
      }

      test_game_team = @stat_tracker.game_teams.first

      expect(test_game_team).to be_a(GameTeam)
      expect(test_game_team.face_off_win_percentage).to eq(expected_game_team_data[:face_off_win_percentage])
      expect(test_game_team.game_id).to eq(expected_game_team_data[:game_id])
      expect(test_game_team.giveaways).to eq(expected_game_team_data[:giveaways])
      expect(test_game_team.goals).to eq(expected_game_team_data[:goals])
      expect(test_game_team.head_coach).to eq(expected_game_team_data[:head_coach])
      expect(test_game_team.hoa).to eq(expected_game_team_data[:hoa])
      expect(test_game_team.pim).to eq(expected_game_team_data[:pim])
      expect(test_game_team.power_play_goals).to eq(expected_game_team_data[:power_play_goals])
      expect(test_game_team.power_play_opportunities).to eq(expected_game_team_data[:power_play_opportunities])
      expect(test_game_team.result).to eq(expected_game_team_data[:result])
      expect(test_game_team.settled_in).to eq(expected_game_team_data[:settled_in])
      expect(test_game_team.shots).to eq(expected_game_team_data[:shots])
      expect(test_game_team.tackles).to eq(expected_game_team_data[:tackles])
      expect(test_game_team.takeaways).to eq(expected_game_team_data[:takeaways])
      expect(test_game_team.team_id).to eq(expected_game_team_data[:team_id])
    end
  end

  describe "#count_of_teams" do
    it "returns the number of teams in the league" do
      expect(@stat_tracker.count_of_teams).to be_a(Integer)
      expect(@stat_tracker.count_of_teams).to eq(32)
    end
  end

  describe "#highest_total_score" do
    it "returns the highest total score" do
      expect(@stat_tracker.highest_total_score).to be_a(Integer)
      expect(@stat_tracker.highest_total_score).to eq(11)
    end
  end
end