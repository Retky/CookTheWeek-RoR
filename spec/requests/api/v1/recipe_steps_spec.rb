require 'rails_helper'

RSpec.describe 'Api::V1::RecipeSteps', type: :request do
  before do
    # User registration
    post '/users/tokens/sign_up',
         params: { email: 'test@test.com', password: 'password', password_confirmation: 'password' }
    @user_id = response.parsed_body['resource_owner']['id']
    @token = response.parsed_body['token']
    @recipe = {
      recipe: {
        name: 'Recipe',
        description: '',
        portions: 3,
        difficulty: 2,
        preparation_time: 0.75,
        cooking_time: 1,
        public: false,
        tips: '',
        image_url: '',
        recipe_steps_attributes: [
          { id: nil, step_number: 1, instructions: 'Check Steps' },
          { id: nil, step_number: 2, instructions: 'Done' }
        ],
        recipe_ingredients_attributes: [
          { id: nil, name: 'Milk', quantity: 1.8, unit: 'liters' },
          { id: nil, name: 'Egg', quantity: 3, unit: 'piece' },
          { id: nil, name: 'Flour', quantity: 200, unit: 'grams' }
        ]
      }
    }
    post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
    @recipe_step_id = response.parsed_body['recipe_steps'][0]['id']
  end

  describe 'DELETE /destroy' do
    it 'should returns http unauthorized when no token is provided' do
      delete "/api/v1/users/#{@user_id}/recipe_steps/#{@recipe_step_id}"
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should returns http success' do
      delete "/api/v1/users/#{@user_id}/recipe_steps/#{@recipe_step_id}", headers: { 'Authorization' => @token }
      expect(response).to have_http_status(:success)
    end
    it 'should returns http unprocessable_entity when trying to delete a recipe step from another user' do
      post '/users/tokens/sign_up',
           params: { email: 'other@test.com', password: 'password', password_confirmation: 'password' }
      other_token = response.parsed_body['token']
      delete "/api/v1/users/#{@user_id}/recipe_steps/#{@recipe_step_id}", headers: { 'Authorization' => other_token }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
