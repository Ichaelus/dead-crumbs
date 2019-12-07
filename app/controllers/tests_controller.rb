class TestsController < ApplicationController

  def test_flash
    redirect_to root_path, flash: { success: 'This is a test flash' }
  end

end
