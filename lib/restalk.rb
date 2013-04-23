class Restalk
  class RestalkBeanstalkException < StandardError; end

  VERSION = '0.1.4'
  def initialize(adapter, server=nil, queue=nil)
    extend BeanstalkAdapter if adapter == :beanstalk
    extend ResqueAdapter if [:resque, :redis].include? adapter
    init server, queue
  end

  def self.connected?
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

    def connected?; true; end
  end

  module ResqueAdapter
    def init(server = nil, queue = nil)
      @queue = queue || ENV['RESQUE_QUEUE'] || 'restalk_queue'
      require 'resque'
      server = get_redis_object(server || ENV['REDIS'] || 'localhost:6379')
      Resque.redis = server
    end

    def get_redis_object(url)
      return url unless url['@']
      credentials, url = url.split '@'
      host, port = url.split ':'
      username, password = credentials.split ':'
      Redis.new(:host => host,
                         :port => port,
                         :username => username,
                         :password => password)
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

    def connected?; true; end

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