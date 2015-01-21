# Dimiter Todorov - 2014
module Rbtwist

class Fault < StandardError
  attr_reader :fault

  def initialize msg, fault
    super "#{fault.class.wsdl_name}: #{msg}"
    @fault = fault
  end

  def method_missing *a
    @fault.send(*a)
  end
end

end
