module SoftDeletable
  extend ActiveSupport::Concern

  def soft_delete!
    self.touch(:deleted_at)
  end
end
