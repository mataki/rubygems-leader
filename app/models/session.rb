class Session < ActiveRecord::Base
  # todo hookup resque or some other kind of job to actually kick this.
  def self.expire_sessions
    delete_all "created_at < '#{1.day.ago.to_s(:db)}'"
  end
end

