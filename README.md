Restalk
=======

Restalk is an abstraction layer for beanstalk and resque (other queue mechanisms welcome).

It's a quick hack to allow me to quickly and simply move a project from one to the other.

It has a very simple interface:

```ruby
Restalk.init(:resque) # Create a connection to the backend (in this case, resque)
Restalk.push("Hello") # Push something onto the queue
datum = Restalk.pop   # Pop something off the queue. Returns instantly. Could be nil.

datum.body if datum   # Get the actual value

Restalk.connected?    # Test whether init has been called
Restalk.stats         # Statistics (whatever the backend gives us - could be gibberish)
```


If you need both services, or different channels, or object orientation, we have you covered:

```ruby
beanie = Restalk.new(:beanstalk, nil, 'jack')       # nil for the server, uses the default
rezzer = Restalk.new(:resque, nil, 'funky_chicken')

item = beanie.pop
rezzer.push(item.body) if item

beanie.connected?
rezzer.stats
```


Configuration
-------------

Servers: Restalk defaults to '127.0.0.1:11300' for beanstalk and 'localhost:6379' for resque.

Queue: Restalk, by default, names the queue, highly imaginatively, 'restalk_queue'.
Beanstalk does not seem to support named queues, so an exception will be raised if you try to set one.

These can be configured easily via environment variables:
  ENV['BEANSTALK'] - Beanstalk server address
  ENV['BEANSTALK_QUEUE'] - Beanstalk tube name

  ENV['REDIS'] - Redis server address
  ENV['RESQUE_QUEUE'] - Resque queue name

All of these can be overridden on a per-instance basis.


Author
------

Matthew Bennett @undecisive [wearepandr.com](http://wearepandr.com)

Got a question? Message me on [Github](http://github.com/undecisive) or add an issue.


License
-------

```
The MIT License (MIT)
Copyright (c) 2012-2013 We are PANDR

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
```