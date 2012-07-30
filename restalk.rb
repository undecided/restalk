class Restalk
  VERSION = '0.0.0.1'
  def self.init(adapter)
    extend BeanstalkAdapter if adapter == :beanstalk
    extend ResqueAdapter if adapter == :resque
    super()
  end
  
  module BeanstalkAdapter
    def init(adapter)
      @@beanstalk = Beanstalk::Pool.new(['127.0.0.1:11300'])
    end

    def push(data)
      @@beanstalk.put(data)
    end

    def pop
      @@beanstalk.reserve
    end

    def stats
      @@beanstalk.stats
    end
  end

  module ResqueAdapter
    def init(adapter)

    end
  end
end