# frozen_string_literal: true

class CompanysController < ApplicationController
  def index;
    return unless params[:ieul_office_id]

    @office = Office.find(params[:ieul_office_id])
    @ieul_id = Office.find(params[:ieul_office_id]).ieul_id
    @company_name =  Company.find(@ieul_id).name
    @reviews = @office.reviews.order(release_date: :desc).limit(5)
  end
end
