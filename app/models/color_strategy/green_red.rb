class ColorStrategy::GreenRed
  def start
    @start ||= Color::RGB.from_html("#3B848C")
  end

  def target
    @target ||= Color::RGB.from_html("#BF2431")
  end
end
