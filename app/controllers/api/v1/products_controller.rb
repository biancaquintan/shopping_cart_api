# frozen_string_literal: true

# app/controllers/api/v1/products_controller.rb
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show update destroy]

      # GET api/v1/products
      def index
        @products = Product.all

        render json: @products
      end

      # GET api/v1/products/1
      def show
        render json: @product
      end

      # POST api/v1/products
      def create
        @product = Product.new(product_params)

        if @product.save
          render json: @product, status: :created, location: api_v1_product_url(@product)
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT api/v1/products/1
      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # DELETE api/v1/products/1
      def destroy
        @product.destroy!
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :price)
      end
    end
  end
end
