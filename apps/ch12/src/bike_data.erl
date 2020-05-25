%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc Module with sample payloads of bike data
%%%
%%% @end
%%% Created : 24. May 2020 4:09 PM
%%%-------------------------------------------------------------------
-module(bike_data).
-author("Aaron Lelevier").
-vsn(1.0).
-export([bike1_data/0, bike2_data/0, bike3_data/0]).


bike1_data() -> #{
  product => "Banshee Phantom V3 Race Bike",
  rear_travel => "115mm"
}.

bike2_data() -> #{
  product => "Commencal Meta AM 29 WC Bike",
  rear_travel => "160mm"
}.

bike3_data() -> #{
  product => "Fezzari Wasatch Peak Comp 29 Bike",
  rear_travel => "Hardtail"
}.