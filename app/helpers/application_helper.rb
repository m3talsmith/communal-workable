module ApplicationHelper
  def slide &block
    raw "<div class='slide'>#{capture(&block)}</div>"
  end
end
