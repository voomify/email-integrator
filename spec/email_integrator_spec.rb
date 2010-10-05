require File.dirname(__FILE__) + '/spec_helper.rb'


# Time to add your specs!
# http://rspec.info/
describe EmailIntegrator do

  before(:all) do
    class HoptoadNotifier
          def self.notify(args)
            raise "Unexpected error"
          end
    end
  end
  
  it "throws exception if server is not passed" do
    should_throw_exception(ArgumentError) do
      EmailIntegrator::POP3.new(:username=>"username",
                          :password=>"password")
    end
  end

  it "throws exception if username is not passed" do
    should_throw_exception(ArgumentError) do
      EmailIntegrator::POP3.new(:server=>"server",
                          :password=>"password")
    end
  end

  it "throws exception if password is not passed" do
    should_throw_exception(ArgumentError) do
      EmailIntegrator::POP3.new(:server=>"server",
                          :username=>"username")
    end
  end


  it "throws exception if bad server is passed" do
      should_throw_exception(SocketError) do
        EmailIntegrator::POP3.new(:server=>"garbage",
                            :username=>"username",
                            :password=>"password").process(/.*/) { |msg| }
      end
    end

  it "process email" do

    mock_message = mock('message')
    mock_message.should_receive(:pop).at_least(1).and_return("look at me")

    mock_connection = mock('connection')
    mock_connection.should_receive(:mails).and_return([mock_message])
    mock_connection.should_receive(:start).and_yield(mock_connection)

    Net::POP3.should_receive(:new).and_return(mock_connection)


    EmailIntegrator::POP3.new(:server=>"garbage",
                             :username=>"username",
                             :password=>"password").process(/.*/) do |xml|
      xml.should == "look at me"
    end

  end

  it "process email but don't find a message" do

    mock_message = mock('message')
    mock_message.should_receive(:pop).at_least(1).and_return("look at me")

    mock_connection = mock('connection')
    mock_connection.should_receive(:mails).and_return([mock_message])
    mock_connection.should_receive(:start).and_yield(mock_connection)

    #Net::POP3.should_receive(:new).and_return(MockConnection.new)
    Net::POP3.should_receive(:new).and_return(mock_connection)

    EmailIntegrator::POP3.new(:server=>"garbage",
                             :username=>"username",
                             :password=>"password").process(/anything/) do |xml|
      raise 'This should not be called!'
    end

  end

end
