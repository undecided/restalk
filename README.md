Restalk
=======

Restalk is an abstraction layer for beanstalk and resque (other queue mechanisms welcome).

It's a quick hack to allow me to quickly and simply move a project from one to the other.

It has a very simple interface:

```ruby
Restalk.new(:resque)  - Create a queue manager (in this case, resque)
Restalk.push()        - Push something onto the queue
Restalk.pop()         - Pop something off the queue
Restalk.stats()       - Statistics (poss. beanstalk only?)
```