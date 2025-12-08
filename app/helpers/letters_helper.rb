module LettersHelper
  def extract_template_layout(template)
    layout = template.layout || {}

    canvas       = layout["canvas"] || {}
    background   = layout["background"] || {}
    placeholders = layout["placeholders"] || []

    width  = canvas["width"]  || 960
    height = canvas["height"] || 1350

    {
      layout: layout,
      canvas: canvas,
      background: background,
      placeholders: placeholders,
      width: width,
      height: height,
      aspect_ratio: "#{width} / #{height}",
    }
  end

  def scaled_layout(template, display_width: 560)
    data = extract_template_layout(template)

    original_width  = data[:width].to_f
    original_height = data[:height].to_f

    scale = display_width / original_width

    # placeholders を縮小した座標で返す
    scaled_placeholders = data[:placeholders].map do |ph|
      ph.merge(
        "x_scaled"      => ph["x"] * scale,
        "y_scaled"      => ph["y"] * scale,
        "width_scaled"  => ph["width"] * scale,
        "height_scaled" => ph["height"] * scale
      )
    end

    data.merge(
      display_width: display_width,
      display_height: original_height * scale,
      scale: scale,
      placeholders_scaled: scaled_placeholders
    )
  end
end
