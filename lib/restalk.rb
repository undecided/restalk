

class Restalk
  class RestalkBeanstalkException < StandardError; end

  VERSION = '0.1.2'
  def initialize(adapter, server=nil, queue=nil)
    extend BeanstalkAdapter if adapter == :beanstalk
    extend ResqueAdapter if [:resque, :redis].include? adapter
    init server, queue
  end

  def connected?
    !!@current_adapter
  end

  def self.init(*args)
    @current_adapter = self.new *args
  end

  def self.method_missing(sym, *args, &block)
    @current_adapter.send sym, *args, &block
  end

  module BeanstalkAdapter
    def init(server = nil, queue = nil)
      require 'beaneater'
      @beanstalk = Beaneater::Pool.new([server || ENV['BEANSTALK'] || '127.0.0.1:11300'])
      tube = queue || ENV['BEANSTALK_QUEUE'] || 'default'
      @beanstalk = @beanstalk.tubes[tube]
    end

    def push(data)
      @beanstalk.put(data)
    end

    def pop
      @beanstalk.reserve if @beanstalk.peek(:ready)
    end

    def stats
      @beanstalk.stats
    end
  end

  module ResqueAdapter
    def init(server = nil, queue = nil)
      @queue = queue || ENV['RESQUE_QUEUE'] || 'restalk_queue'
      require 'resque'
      Resque.redis = server ||  ENV['REDIS'] || 'localhost:6379'
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