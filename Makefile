################################################################################
#  ocamlify: include files in OCaml code                                       #
#                                                                              #
#  Copyright (C) 2009-2010, OCamlCore SARL                                     #
#                                                                              #
#  This library is free software; you can redistribute it and/or modify it     #
#  under the terms of the GNU Lesser General Public License as published by    #
#  the Free Software Foundation; either version 2.1 of the License, or (at     #
#  your option) any later version, with the OCaml static compilation           #
#  exception.                                                                  #
#                                                                              #
#  This library is distributed in the hope that it will be useful, but         #
#  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
#  or FITNESS FOR A PARTICULAR PURPOSE. See the file COPYING for more          #
#  details.                                                                    #
#                                                                              #
#  You should have received a copy of the GNU Lesser General Public License    #
#  along with this library; if not, write to the Free Software Foundation,     #
#  Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA               #
################################################################################

default: build test

build:
	dune build @install

test:
	dune runtest

all:
	dune build @all

install:
	dune install

uninstall:
	dune uninstall

clean:
	dune clean

fmt:
	dune fmt

lint:
	opam-dune-lint
	dune build @fmt

headache:
	find ./ -name _darcs -prune -false -o -name _build -prune \
	  -false -o -type f \
	  | xargs headache -h _header -c _headache.config

git-pre-commit-hook: test lint

deploy: test lint
	dune-release lint
	dune-release tag
	git push --all
	git push --tag
	dune-release

.PHONY: build doc test all install uninstall reinstall clean distclean configure headache lint git-pre-commit-hook deploy
