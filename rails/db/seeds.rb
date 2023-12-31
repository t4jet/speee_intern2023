# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# rubocop:disable Rails/SkipsModelValidations

require 'csv'

CSV.foreach('db/csv/companies_master.csv', encoding: 'UTF-8').each_slice(500) do |rows|
  company_attrs = []
  rows.each do |row|
    company_attrs << { ieul_id: row[2], name: row[0] }
  end
  Company.insert_all(company_attrs)
end

prefecture_attrs = []
CSV.foreach('db/csv/prefectures_master.csv', encoding: 'UTF-8') do |row|
  prefecture_attrs << { name: row[1] }
end
Prefecture.insert_all(prefecture_attrs)

CSV.foreach('db/csv/cities_master.csv', encoding: 'UTF-8').each_slice(1000) do |rows|
  city_attrs = []
  rows.each do |row|
    city_attrs << { prefecture_id: row[1], name: row[2] }
  end
  City.insert_all(city_attrs)
end

CSV.foreach('db/csv/companies_master.csv', encoding: 'UTF-8').each_slice(500) do |rows|
  office_attrs = []
  rows.each do |row|
    city = City.find_by(name: row[7])
    company = Company.find_by(id: row[2])
    office_attrs << { company_id: company.id, ieul_id: row[2], ieul_office_id: row[3],
                      name: row[1], post_number: row[5],
                      prefecture_id: city.prefecture_id, city_id: city.id, address: row[8], logo_url: row[4],
                      phone_number: row[9], fax_number: row[10], business_time: row[11], regular_holiday: row[12],
                      catch_copy: row[13], introducion: row[14], available_area: row[15] }
  end
  Office.insert_all(office_attrs)
end

assessable_area_attrs = []
CSV.foreach('db/csv/companies_master.csv', encoding: 'UTF-8').each_slice(1000) do |rows|
  rows.each do |row|
    City.find_by(name: row[7])
    Company.find_by(id: row[2])
    available_area_ids = row[15].split(',')
    office = Office.find_by(ieul_id: row[2], ieul_office_id: row[3])
    available_area_ids.each do |available_area_id|
      assessable_area_attrs << { city_id: available_area_id, office_id: office.id }
    end
  end
  AssessableArea.upsert_all(assessable_area_attrs)
end

userid = 1
CSV.foreach('db/csv/reviews_master.csv', encoding: 'UTF-8').each_slice(1000) do |rows|
  review_attrs = []
  rows.each do |row|
    city = City.find_by(name: row[6])
    office = Office.find_by(id: row[1])
    bool = row[18] == 1
    review_attrs << { user_id: userid, office_id: office.id, ieul_id: row[0], ieul_office_id: row[1], user_name: row[2],
                      user_sex: row[3], user_age: row[4], prefecture_id: city.prefecture_id, city_id: city.id,
                      address: row[7], property_type: row[8], number_of_sales: row[9], sale_consideration_date: row[10],
                      assessment_request_date: row[11], selling_date: row[12], sale_date: row[13],
                      release_date: row[14], sales_speed_satisfaction: row[15], assessment_price: row[16],
                      selling_price: row[17], is_discounted: bool, months_to_discount: row[19],
                      discount_price: row[20], contract_price: row[21],
                      contract_price_satisfaction: row[22], intermediary_agreement_type: row[23], headline: row[24],
                      reason_for_sale: row[25], concern_for_sale: row[26], reason_for_choosing_office: row[27],
                      support_satisfaction: row[28], reason_for_support_satiosfaction: row[29], advise: row[30],
                      improvement_point: row[31] }
    userid += 1
  end
  Review.insert_all(review_attrs)
end
# rubocop:enable  Rails/SkipsModelValidations
