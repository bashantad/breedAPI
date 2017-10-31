require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:tag) }
  let(:invalid_attributes) { { title: '' } }
  let(:tag) { FactoryGirl.create(:tag) }

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      tag
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: {id: tag.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { title: 'Climbs Trees'}
      }

      it 'updates the requested tag' do
        put :update, params: {id: tag.to_param, tag: new_attributes}, session: valid_session
        tag.reload
        expect(tag.title).to eq('Climbs Trees')
      end

      it 'renders a JSON response with the tag' do
        put :update, params: {id: tag.to_param, tag: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the tag' do
        put :update, params: {id: tag.to_param, tag: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested tag' do
      tag
      expect {
        delete :destroy, params: {id: tag.to_param}, session: valid_session
      }.to change(Tag, :count).by(-1)
    end
  end

  describe 'GET #stats' do
    let(:tag_set1) { ['low shedding', 'knows kung fu'] }
    let(:tag_set2) { ['low shedding'] }
    let(:breed1) { FactoryGirl.create(:breed, name: 'American Bobtail') }
    let(:breed2) { FactoryGirl.create(:breed, name: 'Norwegian Forest Cat') }

    before do
      breed1.create_tags(tag_set1)
      breed2.create_tags(tag_set2)
    end

    it 'returns json response with bread stats' do
      get :stats, session: valid_session
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to include(a_hash_including({ 'name' => 'low shedding', 'breed_count' => 2 }))
      expect(parsed_response).to include(a_hash_including({ 'name' => 'knows kung fu', 'breed_count' => 1 }))
    end
  end

end
