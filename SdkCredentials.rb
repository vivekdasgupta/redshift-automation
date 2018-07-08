require 'yaml'
class SdkCredentials
  @@creds = YAML.load(File.read('your_credentials.yml'))
  @@sdkcreds = {
    region: @@creds['region'],
    access_key_id: @@creds['access_key_id'],
    secret_access_key: @@creds['secret_access_key'],
    session_token: @@creds['session_token'],
  }
  def getCreds
    return @@sdkcreds
  end

  def getRegion
    return "#{@@creds['region']}"
  end

  def getAccId
    return "#{@@creds['account_id']}"
  end

end
