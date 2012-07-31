require 'bundler/setup'

class Restalk
  VERSION = '0.0.0.6'
  def self.init(adapter)
    extend BeanstalkAdapter if adapter == :beanstalk
    extend ResqueAdapter if [:resque, :redis].include? adapter
    super()
  end
  
  module BeanstalkAdapter
    def init
      @@beanstalk = Beanstalk::Pool.new([ENV['BEANSTALK'] || '127.0.0.1:11300'])
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
    QUEUE = 'jarvis_pdf'
    def init
      Resque.redis = ENV['REDIS'] || 'localhost:6379'
    end

    def push(data)
      Resque.enqueue_to(QUEUE, RestalkResqueJob, data)
    end

    def pop
      data = Resque.pop QUEUE
      return RestalkResqueJob.new data['args'].first if data
    end

    def stats
      Resque.info
    end

    class RestalkResqueJob
      attr_accessor :body
      def initialize(data)
        @body = data
      end

      def perform(data)
        @body = data
        self
      end

      def delete
        true
      end
    end
  end
end