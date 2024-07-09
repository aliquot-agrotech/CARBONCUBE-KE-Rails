# spec/requests/vendor_spec.rb
require 'rails_helper'

RSpec.describe 'Vendor Management', type: :request do
  let(:vendor_params) {
    {
      vendor: {
        full_name: "John Doe",
        phone_number: "1234567890",
        email: "john.doe@example.com",
        enterprise_name: "John's Enterprise",
        location: "123 Main St, City, Country",
        password: "securepassword",
        business_registration_number: "123456789",
        categories: [1, 2]
      }
    }
  }
  let(:product_params) {
    {
      product: {
        title: "New Product",
        description: "This is a new product",
        media: ["image1_url", "image2_url"],
        category_id: 1,
        price: 99.99,
        quantity: 100,
        brand: "Brand Name",
        manufacturer: "Manufacturer Name",
        package_length: 10.09,
        package_width: 10.09,
        package_height: 10.09,
        package_weight: 2.09
      }
    }
  }

  describe 'Vendor Signup and Login' do
    it 'signs up a vendor' do
      post '/vendor/signup', params: vendor_params
      expect(response).to have_http_status(:created)
    end

    it 'logs in a vendor' do
      post '/vendor/signup', params: vendor_params
      post '/vendor/login', params: { email: vendor_params[:vendor][:email], password: vendor_params[:vendor][:password] }
      expect(response).to have_http_status(:ok)
      @jwt_token = JSON.parse(response.body)['token']
    end
  end

  describe 'Product Management' do
    before do
      post '/vendor/signup', params: vendor_params
      post '/vendor/login', params: { email: vendor_params[:vendor][:email], password: vendor_params[:vendor][:password] }
      @jwt_token = JSON.parse(response.body)['token']
    end

    it 'creates a product' do
      post '/vendor/products', headers: { Authorization: "Bearer #{@jwt_token}" }, params: product_params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('New Product')
    end

    it 'updates a product' do
      post '/vendor/products', headers: { Authorization: "Bearer #{@jwt_token}" }, params: product_params
      product_id = JSON.parse(response.body)['id']
      put "/vendor/products/#{product_id}", headers: { Authorization: "Bearer #{@jwt_token}" }, params: {
        product: {
          title: "Updated Product",
          description: "This is an updated product"
        }
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq('Updated Product')
    end

    it 'deletes a product' do
      post '/vendor/products', headers: { Authorization: "Bearer #{@jwt_token}" }, params: product_params
      product_id = JSON.parse(response.body)['id']
      delete "/vendor/products/#{product_id}", headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'Order Status and Analytics' do
    before do
      post '/vendor/signup', params: vendor_params
      post '/vendor/login', params: { email: vendor_params[:vendor][:email], password: vendor_params[:vendor][:password] }
      @jwt_token = JSON.parse(response.body)['token']
    end

    it 'updates order status' do
      patch '/vendor/orders/22', headers: { Authorization: "Bearer #{@jwt_token}" }, params: { status: "transiting" }
      expect(response).to have_http_status(:ok)
    end

    it 'views reviews and analytics' do
      get '/vendor/analytics', headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
