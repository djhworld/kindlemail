require './lib/constants.rb'
class WhisperFileDatastore
  
  def load_store
    if(File.exist?(FILE_STORE))
      data = IO.read(FILE_STORE)
      @db = Marshal.load(data)
    else
      @db = {}
    end
  end

  def file_exists?(kindle_addr, filename)
    load_store
    if(@db.key?kindle_addr == false)
      return false
    elsif(@db[kindle_addr].nil?)
      return false
    elsif(@db[kindle_addr].key?filename)
      puts "This file was sent to #{kindle_addr} on #{@db[kindle_addr][filename]}"
      return true
    end
    return false
  end
  
  def add_entry(kindle_addr,filename)
    load_store
    @db[kindle_addr] = {} if(@db[kindle_addr].nil?)
    @db[kindle_addr][filename] = Time.now
    data = Marshal.dump(@db)
    file = File.new(FILE_STORE, "w")
    file.write data
    file.close
  end
end
