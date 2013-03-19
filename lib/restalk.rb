
class Restalk
  VERSION = '0.1.0'
  def initialize(adapter, queue=nil)
    extend BeanstalkAdapter if adapter == :beanstalk
    extend ResqueAdapter if [:resque, :redis].include? adapter
    init queue
  end

  def connected?
    self.respond_to? :push
  end

  def self.init(*args)
    @current_adapter = self.new *args
  end

  def self.method_missing(sym, *args, &block)
    @current_adapter.send sym, *args, &block
  end

  module BeanstalkAdapter
    def init
      require 'beanstalk-client'
      @beanstalk = Beanstalk::Pool.new([ENV['BEANSTALK'] || '127.0.0.1:11300'])
    end

    def push(data)
      @beanstalk.put(data)
    end

    def pop
      @beanstalk.reserve
    end

    def stats
      @beanstalk.stats
    end
  end

  module ResqueAdapter
    def init(queue = nil)
      @queue = queue || ENV['RESQUE_QUEUE'] || 'restalk_queue'
      require 'resque'
      Resque.redis = ENV['REDIS'] || 'localhost:6379'
    end

    def push(data)
      Resque.enqueue_to(@queue, RestalkResqueJob, data)
    end

    def pop
      data = Resque.pop @queue
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