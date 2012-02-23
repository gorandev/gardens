desc 'jammit'
  task :jam => :environment do
  require 'jammit'
  Jammit.package!
end
