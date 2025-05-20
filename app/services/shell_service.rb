# frozen_string_literal: true

class ShellService
  private

  def open3
    ApplicationContainer[:open3]
  end
end
