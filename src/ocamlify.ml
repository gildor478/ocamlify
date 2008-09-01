
type var_type = 
  | VarString
  | VarStringList
;;

let version = "0.0.1"
;;

let to_ocaml_string str = 
  let ocaml_str = 
    Printf.sprintf "%S" str
  in
    if String.length ocaml_str >= 2 && 
       ocaml_str.[0] = '"' && 
       ocaml_str.[(String.length ocaml_str) - 1] = '"' then
      String.sub ocaml_str 1 ((String.length ocaml_str) - 2) 
    else
      str
;;

let () =

  (* Configuration through command line arguments *)

  let all_var = 
    ref []
  in
  let parse_var vartype = 
    Arg.Tuple
      (
        let varname =
          ref ""
        in
        let file =
          ref ""
        in
          [
            Arg.Set_string varname;
            Arg.Set_string file;
            Arg.Unit (fun () -> all_var := (vartype, !varname, !file) :: !all_var);
          ]
      )
  in
  let output =
    ref None
  in
  let () = 
    Arg.parse
      (
        [
          "--var-string-list",
          parse_var VarStringList,
          "varname file Include file as a list of string, each string \
                        representing a line (without trailing EOL character)";

          "--var-string",
          parse_var VarString,
          "varname file Include file as a string.";

          "--output",
          Arg.String (fun str -> output := Some str),
          "file Output file, default to standard output";
        ]
      )
      (fun str -> raise (Arg.Bad ("Don't know what to do with "^str)))
      (
        "ocamlify v"^version^" by Sylvain Le Gall \n\
        \n\
        Create an OCaml file including other file.\n\
        \n\
        Usage: \n\
        ocamlify [options]\n\
        \n\
        Options: \n"
      )
  in
  let () =
    all_var := List.rev !all_var
  in


  (** Create output file containing variable *)

  let output_var fd vartype varname file =
    let fpf str =
      Printf.fprintf fd str
    in
    let iter_line f =
      let fi = 
        open_in file
      in
        try
          while true do
            f (input_line fi)
          done
        with End_of_file ->
          close_in fi
    in
      fpf "(* Include %s *)\n" file;
      fpf "let %s = \n" varname;
      match vartype with 
        | VarString ->
            fpf "  \"\\\n";
            (
              iter_line 
                (fun str ->
                   let ocaml_str =
                     to_ocaml_string str
                   in
                   let fst_part, lst_part =
                     if String.length ocaml_str > 0 then
                       let last_str = 
                         (String.sub ocaml_str 1 ((String.length ocaml_str) - 1))
                       in
                         match ocaml_str.[0] with 
                           | ' '  -> "\\ ", last_str
                           | '\n' -> "\\n", last_str
                           | '\t' -> "\\t", last_str
                           | '\r' -> "\\r", last_str
                           | c -> "", ocaml_str
                     else
                        "", ocaml_str
                   in
                     fpf "  %s%s\\n\\\n"
                       fst_part 
                       lst_part
                );
              fpf "  \"\n";
              fpf ";;\n";
            )
        | VarStringList ->
            (
              fpf "  [\n";
              iter_line (fpf "    %S;\n");
              fpf "  ]\n";
            )
  in
  let rec output_all_var fd lst =
    match lst with 
      | [] ->
          ()
      | (vartype, varname, file) :: tl ->
          output_var fd vartype varname file;
          output_all_var fd tl
  in
    match !output with
      | Some fl ->
          let fd = 
            open_out fl
          in
            output_all_var fd !all_var;
            close_out fd
      | None ->
          output_all_var stdout !all_var
;;

