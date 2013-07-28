class ColorStrategy::LightBlueDarkBlue
  def start
    @start ||= Color::RGB.from_html("#a5cbef")
  end

  def target
    @target ||= Color::RGB::DarkBlue
  end
end
