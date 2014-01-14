PVLB
====

A high performance server load balancing solution

[Youtube presentation video: http://www.youtube.com/watch?v=BK3duo5zAJY](http://www.youtube.com/watch?v=BK3duo5zAJY)

The video contains some slides and a full 30min howto (format: screencast).

PVLB uses open source software:
- Linux (Ubuntu or Redhat both work)
- Nginx (as an HTTP proxy - to redirect vhosts)
- HAProxy (as a load balancer)
- Chef (chef-solo generates configuration)

Combined with any DNS service that can update itself with health checks.

PVLB is a product and a method.
It's an architecture: it tells you how to setup your servers, your DNS.
Through chef-solo, it automates the server setup part, leaving you only a couple command lines to type and a few clicks to set DNS up.

