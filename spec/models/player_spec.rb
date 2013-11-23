require 'spec_helper'


describe Player do

  subject { FactoryGirl.build(:player) }

  context "attribute access check" do
    it {should respond_to(:name) }
    it {should respond_to(:turn) }
  end

  context "associations check" do
    it {should respond_to(:game) }

    it "can be linked to a game" do
      expect { subject.create_game(FactoryGirl.attributes_for(:game)) }.to_not raise_error
      subject.game.should_not be_nil
    end

  end

  context "attribute validations" do

    it "validates empty name" do
      subject.name = ""
      subject.should_not be_valid
      subject.should have(1).error_on(:name)
    end

    it "has a unique name" do
      subject.name = "grace"
      subject.save
      player2 = FactoryGirl.build(:player)
      player2.name = "grace"
      player2.save.should be_false
      player2.should have(1).error_on(:name)
    end
  end

  context "Player's grids" do
    before do
      @grid = FactoryGirl.build(:grid)
    end

    context '#get_battlefield_grid' do
      before do
        @grid.grid_type = 'battlefield'
        Grid.stub(:create_grid_for_player).with('battlefield', subject).and_return(@grid)
      end

      it "returns a grid with grid_type 'battlefield'" do
        subject.get_battlefield_grid.grid_type.should == 'battlefield'
      end
    end

    context '#get_my_ships_grid' do
      before do
        @grid.grid_type = 'my_ships'
        Grid.stub(:create_grid_for_player).with('my_ships', subject).and_return(@grid)
      end

      it "returns a grid with grid_type 'my_ships'" do
        subject.get_my_ships_grid.grid_type.should == 'my_ships'
      end
    end
  end

end
