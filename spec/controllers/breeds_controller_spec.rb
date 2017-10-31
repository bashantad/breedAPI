require 'rails_helper'

RSpec.describe BreedsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:breed) }
  let(:breed) { FactoryGirl.create(:breed, name: 'Norwegian Forest Cat') }
  let(:invalid_attributes) { { name: '' }}
  let(:valid_session) { {} }

  describe 'GET #index' do

    subject { get :index, params: {}, session: valid_session }

    before do
      FactoryGirl.create_list(:breed, 2)
      subject
    end

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'returns list of breeds' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(2)
    end

  end

  describe 'GET #show' do
    subject { get :show, params: {id: breed.to_param}, session: valid_session }

    before do
      breed.create_tags(['low shedding'])
    end

    it 'returns a success response' do
      subject
      expect(response).to be_success
    end

    it 'returns json response for breed and tags' do
      subject
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eq('Norwegian Forest Cat')
      expect(parsed_response['tags']).to be_kind_of(Array)
    end

  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { valid_attributes.merge({ tags: ['Knows Kung Fu', 'Climbs Trees']}) }

      it 'creates a new Breed' do
        expect {
          post :create, params: {breed: valid_params}, session: valid_session
        }.to change(Breed, :count).by(1)
         .and change(Taggable, :count).by(2)
         .and change(Tag, :count).by(2)
      end

      it 'renders a JSON response with the new breed' do

        post :create, params: {breed: valid_params}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(breed_url(Breed.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new breed' do

        post :create, params: {breed: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {name: 'American Bobtail', tags: ['pet friendly']}
      }

      it 'updates the requested breed' do
        breed.create_tags(['low shedding'])
        put :update, params: {id: breed.to_param, breed: new_attributes}, session: valid_session
        breed.reload
        expect(breed.name).to eq(new_attributes[:name])
        expect(breed.tags.count).to eq(1)
        expect(breed.tags.first.title).to eq('pet friendly')
      end

      it 'renders a JSON response with the breed' do
        put :update, params: {id: breed.to_param, breed: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the breed' do
        put :update, params: {id: breed.to_param, breed: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested breed & removes associated tags' do
      breed.create_tags(['pet friendly'])
      expect {
        delete :destroy, params: {id: breed.to_param}, session: valid_session
      }.to change(Breed, :count).by(-1)
       .and change(Tag, :count).by(-1)
    end
  end

  describe 'GET #tags' do
    let(:tags) { ['low shedding', 'knows kung fu', 'pet friendly'] }
    subject {
      get :tags, params: {breed_id: breed.to_param}, session: valid_session
    }

    before do
      breed.create_tags(tags)
    end

    it 'returns a success response' do
      subject
      expect(response).to be_success
    end

    it 'returns json response for tags array' do
      subject
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.collect{|resp| resp['title']}).to match_array(tags)
    end

  end

  describe 'POST #tags' do
    let(:tags) { ['low shedding', 'knows kung fu'] }

    it 'returns a success response' do
      breed.create_tags(tags)
      post :tags, params: {breed_id: breed.to_param, tags: ['pet friendly']}, session: valid_session
      breed.reload
      expect(Tag.count).to eq(1)
      expect(breed.tags.first.title).to eq('pet friendly')
    end

  end

  describe 'GET #stats' do
    let(:tag_set1) { ['low shedding', 'knows kung fu'] }
    let(:tag_set2) { ['pet friendly', 'climbs trees'] }
    let(:breed1) {FactoryGirl.create(:breed, name: 'American Bobtail') }

    before do
      breed.create_tags(tag_set1)
      breed1.create_tags(tag_set2)
    end

    it 'returns json response with bread stats' do
      get :stats, session: valid_session
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to include(a_hash_including({ 'name' => 'Norwegian Forest Cat', 'tag_count' => 2 }))
      expect(parsed_response).to include(a_hash_including({ 'name' => 'American Bobtail', 'tag_count' => 2 }))
    end
  end

end
