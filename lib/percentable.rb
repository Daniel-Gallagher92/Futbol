module Percentable
  def percentage(selected, total)
    (selected / total.to_f).round(2)
  end
end