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

  describe "Helper Methods" do

    describe "#team_name_from_id" do
      it "returns a team name when given a team_id" do
        expect(@stat_tracker.team_name_from_id("1")).to eq("Atlanta United")
        expect(@stat_tracker.team_name_from_id("4")).to eq("Chicago Fire")
        expect(@stat_tracker.team_name_from_id("0")).to eq(nil)
      end
    end

  end

  # Game Statistics Tests

  describe "Game Statistics" do
    context "#highest_total_score" do
      it "returns the highest total score" do
        highest_total_score = @stat_tracker.highest_total_score

        expect(highest_total_score).to be_a(Integer)
        expect(highest_total_score).to eq(11)
      end
    end

    context "#lowest_total_score" do
      it "returns the lowest total score" do
        lowest_total_score = @stat_tracker.lowest_total_score

        expect(lowest_total_score).to be_a(Integer)
        expect(lowest_total_score).to eq(0)
      end
    end


    describe "#all_games_count" do 
      it "can count all of the games" do
        all_games_count = @stat_tracker.all_games_count

        expect(all_games_count).to be_a(Integer)
        expect(all_games_count).to eq(7441)
      end
    end

    describe "#percentage_home_wins" do 
      it "can calculate percentage of home wins" do 
        expect(@stat_tracker.percentage_home_wins).to be_a(Float)
        expect(@stat_tracker.percentage_home_wins).to eq(0.44)
      end
    end

    describe "#percentage_visitor_wins" do 
      it "can calculate percentage of home wins" do 
        expect(@stat_tracker.percentage_visitor_wins).to be_a(Float)
        expect(@stat_tracker.percentage_visitor_wins).to eq(0.36)
      end
    end

    describe "#percentage_ties" do 
      it "can calculate percentage of ties" do 
        expect(@stat_tracker.percentage_ties).to be_a(Float)
        expect(@stat_tracker.percentage_ties).to eq(0.41)
      end
    end

    context "#count_of_games_by_season" do
      it "returns the number of games in a season" do
        expect(@stat_tracker.count_of_games_by_season).to be_a(Hash)
        expect(@stat_tracker.count_of_games_by_season).to eq({
          "20122013"=>806,
          "20132014"=>1323,
          "20142015"=>1319,
          "20152016"=>1321,
          "20162017"=>1317,
          "20172018"=>1355
        })
      end
    end

    context "#average goals game/season" do 
      it "returns the average goals per game" do
        expect(@stat_tracker.average_goals_per_game).to be_a(Float)
        expect(@stat_tracker.average_goals_per_game).to eq(4.22)
      end

      it "returns average goals in a game for a season" do
        expect(@stat_tracker.average_goals_per_season).to be_a(Hash)
        expect(@stat_tracker.average_goals_per_season).to eq({
          "20122013" => 4.12,
          "20132014" => 4.19,
          "20142015" => 4.14,
          "20152016" => 4.16,
          "20162017" => 4.23,
          "20172018" => 4.44,
        })
      end
    end
  
  end

  # League Statistics Tests

  describe "League Statistics" do
    describe "#count_of_teams" do
      it "returns the number of teams in the league" do
        expect(@stat_tracker.count_of_teams).to be_a(Integer)
        expect(@stat_tracker.count_of_teams).to eq(32)
      end
    end
    
    describe "#best_offense" do   
      it "returns the name of the team w/the highest average number of goals" do
        best_offense = @stat_tracker.best_offense
        expect(best_offense).to be_a(String)
        expect(best_offense).to eq("Reign FC")
      end
    end

    describe "highest_scoring_visitor" do
      it "returns the highest scoring visitor" do
        highest_scoring_visitor = @stat_tracker.highest_scoring_visitor
        expect(highest_scoring_visitor).to be_a(String)
        expect(highest_scoring_visitor).to eq("FC Dallas")
      end  
    end

    describe "lowest_scoring_visitor" do
      it "returns the lowest scoring visitor" do
        lowest_scoring_visitor = @stat_tracker.lowest_scoring_visitor
        expect(lowest_scoring_visitor).to be_a(String)
        expect(lowest_scoring_visitor).to eq("San Jose Earthquakes")
      end
    end    

    describe "highest_scoring_home_team" do
      it "returns the highest scoring home team" do
        highest_scoring_home_team = @stat_tracker.highest_scoring_home_team
        expect(highest_scoring_home_team).to be_a(String)
        expect(highest_scoring_home_team).to eq("Reign FC")
      end
    end  

    describe "lowest_scoring_home_team" do
      it "returns the lowest scoring home team" do
        lowest_scoring_home_team = @stat_tracker.lowest_scoring_home_team
        expect(lowest_scoring_home_team).to be_a(String)
        expect(lowest_scoring_home_team).to eq("Utah Royals FC")
      end
    end    

    describe "#worst_offense" do   
      it "returns the name of the team w/the lowest average number of goals" do
        worst_offense = @stat_tracker.worst_offense
        expect(worst_offense).to be_a(String)
        expect(worst_offense).to eq("Utah Royals FC")
      end
    end

    
  end

  # Season Statistics Tests

  describe "Season Statistics" do

    describe "#most_accurate_team" do
      it "returns the team with the best ratio of shots/goals for the season" do
        most_accurate_team_20132014 = @stat_tracker.most_accurate_team("20132014")
        most_accurate_team_20142015 = @stat_tracker.most_accurate_team("20142015")
        
        expect(most_accurate_team_20132014).to be_a(String)
        expect(most_accurate_team_20132014).to eq("Real Salt Lake")
        expect(most_accurate_team_20142015).to eq("Toronto FC")
      end
    end

    describe "#least_accurate_team" do
      it "returns the team with the worst ratio of shots/goals for the season" do
        least_accurate_team_20132014 = @stat_tracker.least_accurate_team("20132014")
        least_accurate_team_20142015 = @stat_tracker.least_accurate_team("20142015")

        expect(least_accurate_team_20132014).to be_a(String)
        expect(least_accurate_team_20132014).to eq("New York City FC")
        expect(least_accurate_team_20142015).to eq("Columbus Crew SC")
      end
    end

    describe "#tackles" do
      it 'returns the team with the most tackles in the given season' do
        most_tackles = @stat_tracker.most_tackles("20122013")

        expect(most_tackles).to be_a(String)
        expect(most_tackles).to eq("FC Cincinnati")
      end

      it 'returns the team with the fewest tackles in the given season' do
        fewest_tackles = @stat_tracker.fewest_tackles("20142015")

        expect(fewest_tackles).to be_a(String)
        expect(fewest_tackles).to eq("Orlando City SC")
      end
    end

    describe "#winningest_coach" do 
      it "returns the name of the coach with most wins in season" do 

        expect(@stat_tracker.winningest_coach("20122013")).to eq("Claude Julien")
        expect(@stat_tracker.winningest_coach("20122013")).to be_a(String)
      end
    end

    describe "#worst_coach" do 
      it "returns the name of the coach with least wins in season" do 

        expect(@stat_tracker.worst_coach("20122013")).to be_a(String)
        expect(@stat_tracker.worst_coach("20122013")).to eq("Martin Raymond")
      end
    end

    describe "#worst_coach_by_opinion" do 
      it "returns the name of Daniel's least favorite NHL coach" do 
    
        expect(@stat_tracker.worst_coach_by_opinion).to be_a(String)
        expect(@stat_tracker.worst_coach_by_opinion).to eq("John Tortorella")
      end
    end
    
    describe "#best_coach_by_opinion" do 
      it "returns the name of Daniel's favorite NHL coach" do 
    
        expect(@stat_tracker.best_coach_by_opinion).to be_a(String)
        expect(@stat_tracker.best_coach_by_opinion).to eq("Jon Cooper")
      end
    end
  end

end