(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2016     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

(************************************************************************)
(* Coq serialization API/Plugin                                         *)
(* Copyright 2016-2018 MINES ParisTech                                  *)
(************************************************************************)
(* Status: Experimental                                                 *)
(************************************************************************)

type retroknowledge =
  [%import: Retroknowledge.retroknowledge]

let sexp_of_retroknowledge = Serlib_base.sexp_of_opaque ~typ:"Retroknowledge.retroknowledge"
let retroknowledge_of_sexp = Serlib_base.opaque_of_sexp ~typ:"Retroknowledge.retroknowledge"
let python_of_retroknowledge = Serlib_base.python_of_opaque ~typ:"Retroknowledge.retroknowledge"
let retroknowledge_of_python = Serlib_base.opaque_of_python ~typ:"Retroknowledge.retroknowledge"

(* type entry = 
 *   [%import: Retroknowledge.entry] *)

type action = 
  [%import: Retroknowledge.action]

let sexp_of_action = Serlib_base.sexp_of_opaque ~typ:"Retroknowledge.action"
let action_of_sexp = Serlib_base.opaque_of_sexp ~typ:"Retroknowledge.action"