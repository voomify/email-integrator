
# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]

namespace :gem do
  begin
    require 'jeweler'
    gem_name = 'voomify_email_integrator'

    Jeweler::Tasks.new do |gem|
      gem.name = gem_name
      gem.summary = 'Voomify email integrator. Reads POP3 emails.'
      gem.files = Dir['{lib}/**/*', '{tasks}/**/*']
      gem.author = 'Russell Edens'
      gem.email =  'russell@voomify.com'
      gem.description = 'This gem contains the logic for reading email from a pop3 mailbox'
      gem.homepage = 'http://www.github.com/voomify/email_integrator'
      # other fields that would normally go in your gemspec also be included here
    end
  rescue
    puts 'Jeweler or one of its dependencies is not installed.'
  end

   task :uninstall do
    sh "gem uninstall #{gem_name}"
   end

  task :reinstall =>[:uninstall,:install]

end
