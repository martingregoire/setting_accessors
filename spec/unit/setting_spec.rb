describe Setting, type: :model do

  #----------------------------------------------------------------
  #                        #create_or_update
  #----------------------------------------------------------------

  describe '#create_or_update' do
    let(:ash) { User.create(:name => 'Ash Ketchum') }

    context 'when being called without an assignable' do
      context 'and the setting does not exist yet' do
        before do
          expect(Setting.count).to be_zero
          Setting.create_or_update(:total_pokemon, 151)
        end

        it 'creates a new setting' do
          expect(Setting.count).to eql 1
        end

        it 'assigns the given value to the new setting' do
          expect(Setting.total_pokemon).to eql 151
        end
      end

      context 'and the setting already exists' do
        before do
          Setting.create_or_update(:total_pokemon, 151)
        end

        it 'updates the existing setting' do
          Setting.create_or_update(:total_pokemon, 10000)
          expect(Setting.total_pokemon).to eql 10000
          expect(Setting.count).to eql 1
        end
      end
    end

    context 'when being called with an assignable' do
      context 'and the setting does not exist yet' do
        before do
          expect(Setting.count).to be_zero
          Setting.create_or_update(:total_pokemon, 151, ash)
        end

        it 'creates a new setting' do
          expect(Setting.count).to eql 1
        end

        it 'assigns the given value to the new setting' do
          expect(Setting.total_pokemon(ash)).to eql 151
        end

        it 'does not create a global setting' do
          expect(Setting.total_pokemon).to be_nil
        end
      end

      context 'and the setting already exists' do
        before do
          Setting.create_or_update(:total_pokemon, 151, ash)
        end

        it 'updates the existing setting' do
          Setting.create_or_update(:total_pokemon, 10000, ash)
          expect(Setting.total_pokemon(ash)).to eql 10000
          expect(Setting.count).to eql 1
        end
      end
    end
  end

  #----------------------------------------------------------------
  #                        #method_missing
  #----------------------------------------------------------------

  describe '#method_missing' do
    context 'when being called for a global getter method' do
      context 'and the requested setting does not exist' do
        it 'returns nil' do
          expect(Setting.gotta_catch_em_all).to be_nil
        end
      end

      context 'and a setting with the given name exists' do
        before do
          Setting.gotta_catch_em_all = 'Pokemon!'
        end

        it "returns the setting's value" do
          expect(Setting.gotta_catch_em_all).to eql 'Pokemon!'
        end
      end
    end

    context 'when being called for a class setting getter' do
      let(:ash) { User.create(:name => 'Ash Ketchum') }
      let(:gary) { User.create(:name => 'Gary Oak') }
      let(:team_rocket) { User.create(:name => 'Jessie and James') }

      before do
        # Create settings assigned to two users
        Setting.create_or_update(:pokedex_count, 151, ash)
        Setting.create_or_update(:pokedex_count, 1, gary)
      end

      context 'and there is a setting for the given assignable' do
        it 'returns the correct values' do
          expect(Setting.pokedex_count(ash)).to eql 151
          expect(Setting.pokedex_count(gary)).to eql 1
        end
      end

      context 'and there is no setting for the given assignable' do
        it 'returns nil' do
          expect(Setting.pokedex_count(team_rocket)).to be_nil
        end
      end
    end

    context 'when being called for a global setter method' do
      context 'and the setting does not exist yet' do
        it 'creates a new setting' do
          expect(Setting.count).to be_zero
          Setting.gotta_catch_em_all = 'Pokemon!'
          expect(Setting.count).to eql 1
        end
      end

      context 'and the setting already exists' do
        before do
          Setting.gotta_catch_em_all = 'Pokemon!'
        end

        it 'updates the existing setting' do
          Setting.gotta_catch_em_all = 'Digimon?'
          expect(Setting.gotta_catch_em_all).to eql 'Digimon?'
          expect(Setting.count).to eql 1
        end
      end
    end
  end
end
