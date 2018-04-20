![coq logo][logo]

# Docker/Coq

![dockeri.co][dockericon]

## Summary

This image provides Coq built on Debian image.
Coq is a formal proof management system besed on CIC mathematical system.


## Environment

- working directory /home/coq


## How to use

### coqtop

```sh
$ docker run -it coq:latest coqtop
```


### coqc

For example:
compile your .v file with coqc on the current directory.

```sh
$ ls src
foo.v
$ docker run -it -v `pwd`:/home/coq/src coq:latest coqc src/foo.v
```


## Tags

Provided tags bound to docker images.

- latest(8.8.0)
- 8.8.0
- 8.7.2
- 8.7.1
- 8.7.0
- 8.6pl1
- 8.6
- 8.5pl3
- 8.5pl2
- 8.5pl1
- 8.4pl6
- 8.4pl5
- 8.4pl4
- 8.4pl2
- 8.4pl1
- 8.3


## Links

- [Coq](https://coq.inria.fr/ "Coq")

[logo]: https://coq.inria.fr/files/barron_logo.png "Coq Formal Proof Management System"
[dockericon]: https://dockeri.co/image/eldesh/coq "dockeri.co"

