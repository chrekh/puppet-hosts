Puppet::Functions.create_function(:'hosts::tabs') do
  dispatch :tabsgen do
    param 'String', :str
  end

  def tabsgen(str)
    count = (31 - str.length) / 8
    return ' ' if count < 1
    "\t" * count
  end
end
