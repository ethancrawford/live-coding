# key: fx sl th
# point_line: 0
# point_index: 5
# --
set(:_th_mix, ) #only needed here for initial or snap values
with_fx :tanh, mix: get(:_th_mix) do |th|
  set(:_th, th)
  
end
#sync :  #sync slide to a cue
slide(:_th, , false, mix: )
