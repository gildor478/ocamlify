(lang dune 3.17)

(cram enable)

(name ocamlify)

(generate_opam_files true)

(source
 (github gildor478/ocamlify))

(authors "Sylvain Le Gall")
(maintainers "Sylvain Le Gall <sylvain+ocaml@le-gall.net>")

(license "LGPL-2.1-or-later WITH OCaml-LGPL-linking-exception")

(documentation https://url/to/documentation)

(package
 (name ocamlify)
 (synopsis "Include files in OCaml code")
 (description "")
 (depends
  (ocaml
   (>= 5))
  (camlp-streams
   (>= 5))))
