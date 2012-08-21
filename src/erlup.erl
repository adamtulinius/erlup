-module(erlup).
-vsn("0.0.1").
-export([render/1]).


render(Atom)   when is_atom(Atom) -> render({Atom, []});
render({Atom}) when is_atom(Atom) -> render({Atom, []});

render({Atom, Args, []}) when is_atom(Atom) ->
      case Atom of
           br     -> quickclose("br", Args);
           img    -> quickclose("img", Args);
           link   -> quickclose("link", Args);
           Other  -> openclose(atom_to_list(Other), Args)
      end;

render({Elem, Children}) when is_atom(Elem) ->
      render({Elem, [], Children});
render({Elem, Args, Children}) when is_atom(Elem) ->
      open(Elem, Args) ++ render(Children) ++ close(Elem);

render([H|Hs]) when is_tuple(H) ->
      render(H) ++ render(Hs);

render([]) -> "";
render(String) when is_list(String) -> String;
render(Letter) -> [Letter].


open(E, Args) when is_atom(E) -> open(atom_to_list(E), Args);
open(E, Args) when is_list(E) ->
    "<"  ++ E ++ render_args(Args) ++ ">".

close(E) when is_atom(E) -> close(atom_to_list(E));
close(E) when is_list(E) -> "</" ++ E ++ ">".

openclose(E, Args) -> open(E, Args) ++ close(E).

quickclose(E, Args) ->
          "<" ++ E ++ " " ++ render_args(Args) ++ "/>".


render_args(Key, Value) when is_atom(Key), is_list(Value) ->
           " " ++ atom_to_list(Key) ++ "=\"" ++ Value ++ "\"".

render_args([Key, Value]) ->
           render_args(Key, Value);

render_args([]) ->
           "";

render_args([Key, Value|Rest]) ->
           render_args(Key, Value) ++ render_args(Rest).