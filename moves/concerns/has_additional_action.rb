require_relative "../move"

module HasAdditionalAction
  
  def has_additional_action?
    true
  end

  private

  def additional_action; end
end