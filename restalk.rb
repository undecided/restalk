require 'beanstalk-client'
require 'resque'

class Restalk
  VERSION = '0.0.0.5'
  def self.init(adapter)
    extend BeanstalkAdapter if adapter == :beanstalk
    extend ResqueAdapter if adapter == :resque
    super()
  end
  
  module BeanstalkAdapter
    def init
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
    QUEUE = 'jarvis_pdf'
    def init
      Resque.redis = ENV['REDIS'] || 'localhost:6379'
    end

    def push(data)
      Resque.enqueue_to(QUEUE, RestalkResqueJob, data)
    end

    def pop
      data = Resque.pop QUEUE
      RestalkResqueJob.new data['args'].first
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