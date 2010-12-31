require 'yaml'
module UtilityMethods
  def loadConfig(file)
    config = YAML.load_file(file)
    config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
end

