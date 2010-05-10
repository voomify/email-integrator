require 'spec/test/unit'
require 'pp'

def should_throw_exception(expected_exception_class, &block)

  begin
    block.call
  rescue expected_exception_class
    threw_error = true 
  rescue Exception => err    
  end
  assert threw_error, message(expected_exception_class, err)
end

def message(expected_exception_class, err)
   error = "The test did NOT throw the expected exception: #{expected_exception_class}"
   if err
    error << " threw #{err.class} instead"
   else
    error <<  " no exceptions were thrown"
   end
end