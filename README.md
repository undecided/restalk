Restalk
=======

Restalk is an abstraction layer for beanstalk and resque (other queue mechanisms welcome).

It's a quick hack to allow me to quickly and simply move a project from one to the other.

It has a very simple interface:

```ruby
Restalk.init(:resque) # Create a connection to the backend (in this case, resque)
Restalk.push(object)  # Push something onto the queue
Restalk.pop           # Pop something off the queue

Restalk.connected?    # Test whether init has been called
Restalk.stats         # Statistics (whatever the backend gives us - could be gibberish)
```

Author
------

Matthew Bennett @undecisive [wearepandr.com](http://wearepandr.com)
Got a question? Message me on [Github](http://github.com/undecisive) or add an issue.


License
-------

```
The MIT License (MIT)
Copyright (c) 2012 We are PANDR

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