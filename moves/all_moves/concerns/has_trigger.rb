require_relative "../move"

module HasTrigger
  def has_trigger?
    true
  end

  def trigger_perform_fail_msg; end

  private

  def trigger(pokemon)
    false
  end
end