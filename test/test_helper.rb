ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    include Devise::Test::IntegrationHelpers

    parallelize(workers: 1)

    fixtures :users,
             :clinics,
             :patients,
             :doctors,
             :doctor_availabilities,
             :appointments,
             :consultations,
             :prescriptions,
             :prescription_items,
             :reviews
  end
end