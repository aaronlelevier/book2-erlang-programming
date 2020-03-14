%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2020 6:04 AM
%%%-------------------------------------------------------------------
-module(ch7_ex4).
-author("aaron lelevier").

%% constructors
-export([circle/1, rectangle/2, triangle/3]).
%% functions that work over these types
-export([area/1, perimeter/1]).

-record(circle, {radius}).
-record(rectangle, {length, width}).
-record(triangle, {a, b, c}).

%% constructors

circle(Radius) ->
  #circle{radius = Radius}.

rectangle(Length, Width) ->
  #rectangle{length = Length, width = Width}.

triangle(A, B, C) ->
  #triangle{a = A, b = B, c = C}.

%% functions that work over these types

perimeter(#circle{radius = Radius}) ->
  2 * math:pi() * Radius;
perimeter(#rectangle{length = Length, width = Width}) ->
  Length * 2 + Width * 2;
perimeter(#triangle{a = A, b = B, c = C}) ->
  A + B + C.

area(#circle{radius = Radius}) ->
  math:pi() * math:pow(Radius, 2);
area(#rectangle{length = Length, width = Width}) ->
  Length * Width;
area(#triangle{a = A, b = B, c = C}) ->
  S = (A+B+C)/2,
  math:sqrt(S * (S-A) * (S-B) * (S-C)).
