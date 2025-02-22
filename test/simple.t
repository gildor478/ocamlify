Simplest possible cram test
  $ ocamlify simple_file.mlify
  (* Include ./simple_file.ml *)
  let simple_file_ml = 
    "\
    let x = \"foobar\"\n\
    "
  ;;

  $ echo "testing"
  testing
