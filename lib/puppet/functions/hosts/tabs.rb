# Helper function for creating right amount of tabs for alignment.
# @api private
Puppet::Functions.create_function(:'hosts::tabs') do
  # @param str
  #  String to calculate nr of tabs for
  # @return
  #  A string with tabs
  dispatch :tabsgen do
    param 'String', :str
  end

  def tabsgen(str)
    count = (31 - str.length) / 8
    return ' ' if count < 1
    "\t" * count
  end
end
