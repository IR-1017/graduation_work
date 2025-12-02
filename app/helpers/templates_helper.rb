module TemplatesHelper
  def template_aspect_class(template)
    case template.kind
    when "stationery"    then "aspect-[3/4]" # 縦
    when "message_card"  then "aspect-[4/3]" # 横
    else "aspect-[3/4]"
    end
  end
end