# frozen_string_literal: true

class Api::HealthChecksController < ApplicationController
  def index
    head :ok
  end
end
