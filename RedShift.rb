require 'aws-sdk'
require 'yaml'
require 'pry'
require_relative 'SdkCredentials'


module RedShift
  @@creds = SdkCredentials.new
  @@redshift_client = Aws::Redshift::Client.new(@@creds.getCreds)


  def self.createRedshiftCluster(project,environment,file)
    @esearch_config = YAML.load_file("#{file}")

    resp = @@redshift_client.create_cluster({
      db_name: "#{@esearch_config['db_name']}",
      cluster_identifier: "#{@esearch_config['cluster_identifier']}", # required
      cluster_type: "#{@esearch_config['cluster_type']}",
      node_type: "#{@esearch_config['node_type']}", # required
      master_username: "#{@esearch_config['master_username']}", # required
      master_user_password: "#{@esearch_config['master_user_password']}", # required
      vpc_security_group_ids: ["#{@esearch_config['vpc_security_group_ids']}"],
      cluster_subnet_group_name: "#{@esearch_config['cluster_subnet_group_name']}",
      publicly_accessible: @esearch_config['publicly_accessible'],
      tags: [
        {
          key: "Project",
          value: "#{project}",
        },
        {
          key: "Environment",
          value: "#{environment}",
        },
      ],
    })
    puts resp.cluster.cluster_identifier
    puts "Creating Redshift cluster #{@esearch_config['db_name']} . This can take a long time ..."
    while @@redshift_client.describe_clusters({cluster_identifier: "#{@esearch_config['cluster_identifier']}"}).clusters[0].cluster_status != "available" do
        puts "Building Redshift Cluster...."
        sleep 5
    end
    endpoint = @@redshift_client.describe_clusters({cluster_identifier: "#{@esearch_config['cluster_identifier']}"}).clusters[0].endpoint.address
    puts "Redshift cluster creation done => #{endpoint}"
    return endpoint
  end


  def self.updateRedshiftCluster(project,environment,file)
    @esearch_config = YAML.load_file("#{file}")

    resp = @@redshift_client.modify_cluster({
      cluster_identifier: "#{@esearch_config['cluster_identifier']}", # required
      cluster_type: "#{@esearch_config['cluster_type']}",
      node_type: "#{@esearch_config['node_type']}", # required
      number_of_nodes: "#{@esearch_config['number_of_nodes']}", # required
    })
    puts resp.cluster.cluster_identifier
    puts "Updating Redshift cluster #{@esearch_config['db_name']} . This can take a long time ..."
    return resp
  end

  def self.deleteRedshiftCluster(project,environment,cluster_name)
    resp = @@redshift_client.delete_cluster({
      cluster_identifier: "#{cluster_name}", # required
      skip_final_cluster_snapshot: true,
    })
    puts "Deleting Redshift cluster #{cluster_name} . ..."
    while @@redshift_client.describe_clusters({cluster_identifier: "#{cluster_name}"}).clusters[0].cluster_status != "deleting" do
        puts "Deleting Redshift cluster ...."
        sleep 5
    end
    puts "Redshift cluster deletion will be done !"
    return resp
  end

  def self.createRedshiftSubnetGroup(project,environment,file)
    @esearch_config = YAML.load_file("#{file}")
    resp = @@redshift_client.create_cluster_subnet_group({
      cluster_subnet_group_name: "#{@esearch_config['cluster_subnet_group_name']}", # required
      description: "#{@esearch_config['description']}", # required
      subnet_ids: ["#{@esearch_config['subnet_ids']}"], # required
    })
    puts "Creating RedShift Subnet Group #{@esearch_config['cluster_subnet_group_name']} . ..."
    while @@redshift_client.describe_cluster_subnet_groups({cluster_subnet_group_name: "#{@esearch_config['cluster_subnet_group_name']}"}).cluster_subnet_groups[0].subnet_group_status != "Complete" do
        puts "Creating RedShift Subnet Group...."
        sleep 5
    end
    puts "RedShift Subnet Group creation done !"
    return resp
  end

  def self.buildRedshiftCluster(project,environment,file)
    resp = self.createRedshiftCluster(project,environment,file)
    puts resp
  end

end
