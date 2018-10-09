live_loop :met do
  sleep 2
end

define :in_wrapper do |&block|
  with_fx :wobble, phase: 8, reps: 8, mix: 1 do
    block.call
  end
end

live_loop :ehh, sync: :met do
  in_wrapper do
    with_fx :rbpf, centre: 90, mix: 0.9, amp: 2 do
      with_fx :tanh, mix: 0.5 do
        tick
        sample :elec_pop
        sleep 1
      end
    end
  end
end

live_loop :bee, sync: :met do
  in_wrapper do
    with_fx :bitcrusher do
      tick
      sleep 0.5
      sample :bd_tek, rate: 0.5
      sleep 0.5
    end
  end
end

live_loop :sea, sync: :met do
  in_wrapper do
    tick
    sleep 0.625
    sample :tabla_ke2
    sleep 0.375
  end
end

live_loop :dee, sync: :met do
  in_wrapper do
    tick
    sleep 0.75
    sample :elec_twip, beat_stretch: 2
    sleep 0.25
  end
end
