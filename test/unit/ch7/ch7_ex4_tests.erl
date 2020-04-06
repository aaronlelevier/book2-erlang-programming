%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2020 6:04 AM
%%%-------------------------------------------------------------------
-module(ch7_ex4_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).

-include_lib("eunit/include/eunit.hrl").

%% perimeter tests

circle_perimeter_test() ->
  Radius = 5,
  Circle = ch7_ex4:circle(Radius),
  Ret = ch7_ex4:perimeter(Circle),
  ?assertEqual(2 * math:pi() * Radius, Ret).

rectangle_perimeter_test() ->
  Length = 3,
  Width = 4,
  Rectangle = ch7_ex4:rectangle(Length, Width),
  Ret = ch7_ex4:perimeter(Rectangle),
  ?assertEqual(14, Ret).

triangle_perimeter_test() ->
  A = 2,
  B = 4,
  C = 5,
  Triangle = ch7_ex4:triangle(A, B, C),
  Ret = ch7_ex4:perimeter(Triangle),
  ?assertEqual(11, Ret).

%% area tests

circle_area_test() ->
  Radius = 1.2,
  Circle = ch7_ex4:circle(Radius),
  Ret = ch7_ex4:area(Circle),
  ?assertEqual(math:pi() * math:pow(Radius, 2), Ret).

rectangle_area_test() ->
  Length = 3,
  Width = 4,
  Rectangle = ch7_ex4:rectangle(Length, Width),
  Ret = ch7_ex4:area(Rectangle),
  ?assertEqual(12, Ret).

triangle_area_test() ->
  A = 5,
  B = 5,
  C = 5,
  Triangle = ch7_ex4:triangle(A, B, C),

  Ret = ch7_ex4:area(Triangle),

  S = (A+B+C)/2,
  Expected = math:sqrt(S * (S-A) * (S-B) * (S-C)),
  ?assertEqual(Expected, Ret).
