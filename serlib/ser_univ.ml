(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2016     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

(************************************************************************)
(* Coq serialization API/Plugin                                         *)
(* Copyright 2016 MINES ParisTech                                       *)
(************************************************************************)
(* Status: Very Experimental                                            *)
(************************************************************************)

open Sexplib.Std

module Names = Ser_names
module Stdlib = Ser_stdlib

module RawLevel = struct

  module UGlobal = struct
    type t = Names.DirPath.t * int
    [@@deriving sexp, yojson]
  end

  type t =
  | SProp
  | Prop
  | Set
  | Level of UGlobal.t
  | Var of int
  [@@deriving sexp, yojson]

end

module Level_ = struct

  type _t =
    { hash : int
    ; data : RawLevel.t
    }
  [@@deriving sexp, yojson]

  type t = Univ.Level.t

  let t_of_sexp sexp  = Obj.magic (_t_of_sexp sexp)
  let sexp_of_t level = sexp_of__t (Obj.magic level)

  let of_yojson json  =
    Ppx_deriving_yojson_runtime.(_t_of_yojson json >|= Obj.magic)
  let to_yojson level = _t_to_yojson (Obj.magic level)

end

module Level = struct
  include Level_
  module Set = Ser_cSet.MakeJ(Univ.Level.Set)(Level_)
end

(* XXX: Think what to do with this  *)
module Universe = struct
  type t = [%import: Univ.Universe.t]

  type _t = (Level.t * int) list
  [@@deriving sexp, yojson]

  let t_of_sexp sexp     = Obj.magic (_t_of_sexp sexp)
  let sexp_of_t universe = sexp_of__t (Obj.magic universe)

  let of_yojson json  =
    Ppx_deriving_yojson_runtime.(_t_of_yojson json >|= Obj.magic)
  let to_yojson level = _t_to_yojson (Obj.magic level)
end

(*************************************************************************)

module Variance = struct

  type t =
    [%import: Univ.Variance.t]
  [@@deriving sexp,yojson]

end

module Instance = struct

type t =
  [%import: Univ.Instance.t]

type _t = Instance of Level.t array
  [@@deriving sexp, yojson]

let _instance_put instance            = Instance (Univ.Instance.to_array instance)
let _instance_get (Instance instance) = Univ.Instance.of_array instance

let t_of_sexp sexp     = _instance_get (_t_of_sexp sexp)
let sexp_of_t instance = sexp_of__t (_instance_put instance)

let of_yojson json  =
  Ppx_deriving_yojson_runtime.(_t_of_yojson json >|= _instance_get)
let to_yojson level = _t_to_yojson (_instance_put level)

end

type constraint_type =
  [%import: Univ.constraint_type]
  [@@deriving sexp, yojson]

type univ_constraint =
  [%import: Univ.univ_constraint]
  [@@deriving sexp, yojson]

module Constraints = Ser_cSet.MakeJ(Univ.Constraints)(struct
    let t_of_sexp = univ_constraint_of_sexp
    let sexp_of_t = sexp_of_univ_constraint
    let of_yojson = univ_constraint_of_yojson
    let to_yojson = univ_constraint_to_yojson
  end)

type 'a constrained =
  [%import: 'a Univ.constrained]
  [@@deriving sexp,yojson]

module UContext = struct

  module I = struct
    type t = Names.Name.t array * Instance.t constrained
    [@@deriving sexp,yojson]

    let to_uc (un, cs) = Univ.UContext.make un cs
    let from_uc uc = Univ.UContext.(names uc, (instance uc, constraints uc))

  end

  type t = Univ.UContext.t

  let t_of_sexp s = I.t_of_sexp s |> I.to_uc
  let sexp_of_t t = I.from_uc t |> I.sexp_of_t

end

module AbstractContext = struct

  type _t = Names.Name.t array constrained
  [@@deriving sexp]
  type t = Univ.AbstractContext.t

  (* XXX: Opaque, so check they are the same *)
  let t_of_sexp x = Obj.magic (_t_of_sexp x)
  let sexp_of_t c = sexp_of__t (Obj.magic c)

end

module ContextSet = struct
  type t =
    [%import: Univ.ContextSet.t]
    [@@deriving sexp, yojson]
end

type 'a in_universe_context =
  [%import: 'a Univ.in_universe_context]
  [@@deriving sexp]

type 'a in_universe_context_set =
  [%import: 'a Univ.in_universe_context_set]
  [@@deriving sexp]

type 'a puniverses =
  [%import: 'a Univ.puniverses]
  [@@deriving sexp, yojson]

type explanation =
  [%import: Univ.explanation]
  [@@deriving sexp]

type univ_inconsistency =
  [%import: Univ.univ_inconsistency]
  [@@deriving sexp]
