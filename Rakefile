require 'rake'
require_relative 'SdkCredentials'
require_relative 'RedShift'

desc 'buildRedshiftCluster'
task :buildRedshiftCluster, [:project, :environment, :file] do | t, args |
  RedShift.buildRedshiftCluster(args[:project], args[:environment], args[:file])
end


desc 'updateRedshiftCluster'
task :updateRedshiftCluster, [:project, :environment, :file] do | t, args |
  RedShift.updateRedshiftCluster(args[:project], args[:environment], args[:file])
end

desc 'deleteRedshiftCluster'
task :deleteRedshiftCluster, [:project, :environment, :cluster_name] do | t, args |
  RedShift.deleteRedshiftCluster(args[:project], args[:environment], args[:cluster_name])
end

desc 'createRedshiftSubnetGroup'
task :createRedshiftSubnetGroup, [:project, :environment, :file] do | t, args |
  RedShift.createRedshiftSubnetGroup(args[:project], args[:environment], args[:file])
end
