class Admin::LivesubmitCheckbox::Component < ApplicationComponent
  def initialize(url, field_name, field_current_value)
    @url = url
    @field_name = field_name
    @field_current_value = field_current_value
  end

  def options
    {
      data: { disable_with: text },
      "aria-pressed": (@field_current_value.presence || false).to_s
    }
  end

  private

  def text
    if enabled?
      enabled_text
    else
      disabled_text
    end
  end

  def enabled_text
    t("shared.yes")
  end

  def disabled_text
    t("shared.no")
  end

  def enabled?
    @field_current_value
  end
end
