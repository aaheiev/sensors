class Measurement < ApplicationRecord
  belongs_to :channel
  validates :metric,:created_at, presence: true
  validates :metric, uniqueness: { scope: [ :channel_id, :created_at ] }
  self.primary_key = :channel_id,:metric,:created_at
end
