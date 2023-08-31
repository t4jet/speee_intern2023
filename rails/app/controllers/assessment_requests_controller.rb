# frozen_string_literal: true

class AssessmentRequestsController < ApplicationController
  def index
    @assessment_request = AssessmentRequest.new
  end

  def create
    @assessment_request = AssessmentRequest.new(assessment_params)

    if @assessment_request.save
      ieul_api_client = Assessment::Request::IeulApiClient.new
      ieul_api_client.post(@assessment_request.attributes)
      
      redirect_to thanks_path
    else
      render 'index', status: :unprocessable_entity
    end

  end

  private

  def assessment_params
    params.require(:assessment_request).permit(
      :branch_id,
      :property_city,
      :property_address,
      :user_lastname,
      :user_firstname,
      :user_lastname_kana,
      :user_firstname_kana,
      :user_tel,
      :user_email,
      :property_constructed_year,
      :property_room_plan,
      :property_building_area,
      :property_land_area,
      :property_exclusive_area,
      :property_type
    )
  end
end
