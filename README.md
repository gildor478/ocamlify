ocamlify - Include files in OCaml code
=============================================================

[![OCaml-CI Build Status](https://img.shields.io/endpoint?url=https://ci.ocamllabs.io/badge/gildor478/ocamlify/master&logo=ocaml)](https://ci.ocamllabs.io/github/gildor478/ocamlify)



Installation
------------

The recommended way to install ocaml-gettext is via the [opam package manager][opam]:

```sh
$ opam install ocamlify
```

Examples
--------

Using the following file `test.mlify`:

```
VarString file_ml "file.ml"
```

It is possible to run `ocamlify` to automatically embed the file `file.ml` as a
string into another OCaml file.

```shell
$ ocamlify test.mlify
let file_ml = [...]
```
