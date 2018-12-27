# frozen_string_literal: true

class Track < ActiveRecord::Base
  validates_enum :mood, allow_nil: true, message: "Invalid enum value"
end
