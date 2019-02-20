# 3 s bd_tek, rt rrand(0.5, 2.5), co rrand_i(80, 100) if (spr 3, 9).l
# 1 s elec_flip, rt rrand(1, 1.5), co rrand_i(60, 100) if (spr 5, 9).l
# 2 s elec_plip, rt rrand(1.5, 2), co rrand_i(60, 120) if (spr 14, 16).l


define :bs do |seed|
  use_random_seed seed
  tick_reset
  16.times do
    tick
    sample :bd_tek, rate: rrand(0.5,2.5), lpf: rrand(80, 100) if (spread 3,9).look
    sample :elec_flip, rate: rrand(1,1.5), lpf: rrand(60, 100) if (spread 5,9).look
    sample :elec_plip, rate: rrand(1.5,2), lpf: rrand(60, 120) if (spread 14,16).look
    sleep 0.25
  end
end

live_loop :fd, sync: :m3 do
  use_bpm 100
  stop
  with_fx :echo, phase: 0.25, decay: 4, mix: 0.1 do
    with_fx :distortion, mix: 0.0 do
      with_fx :bitcrusher, sample_rate: 3000, bits: 4.5, cutoff: 100, mix: 0.5 do
        with_fx :ring_mod, freq: 30, mix: 0.5 do
          3.times do
            bs(3300156)
          end
          bs(3300142)
        end
      end
    end
  end
end