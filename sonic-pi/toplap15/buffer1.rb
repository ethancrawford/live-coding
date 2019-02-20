kck_t = (ring 0, 0.375, 0.5, 1.75)
kck_a = (ring 0.75, 0.75, 0.5, 0.75)

bd_t = (ring 0.25, 0.5, 1.25, 1.5)

sn_t = (ring 0, 0.125, 0.75, 1, 1, 1.375, 1.75)

sn2_t = (ring 0, 16)
sn2_rt = (ring 1, -1)

tom_t = (ring 0, 0.125)

tck_t = (range 0, 8, 0.125)
tck_l = (knit 70, 3, 120, 1, 70, 4)

live_loop :met, sync: :m do
  sleep 2
end


# s :elec_hol_kick, a a, bs 0.125, l 100

live_loop :kck, sync: :met do
  stop
  with_fx :bitcrusher, bits: 8, sample_rate: 3000 do
    at kck_t, kck_a do |a|
      sample :elec_hollow_kick, amp: a, beat_stretch: 0.125, lpf: 100
    end
    sleep 2
  end
end

#       at bd_t
#         s bd_gas, a 0.5
# fx tan
#   at sn_t
#     s elec_mid_snare, a 0.5, bs 0.25, l 70

live_loop :bd_sn, sync: :met do
  stop
  with_fx :lpf, cutoff: 80 do
    with_fx :slicer, phase: 0.125, mix: 0.75 do
      with_fx :tanh, mix: 0.5 do
        at bd_t do
          sample :bd_gas, amp: 0.5
        end
      end
    end
  end
  with_fx :tanh do
    at sn_t do
      sample :elec_mid_snare, amp: 0.5, beat_stretch: 0.25, lpf: 70
    end
  end
  sleep 2
end

# s elec_filt_snare, a 0.5, bs 16, rt rt

live_loop :sn2, sync: :met do
  stop
  with_fx :bitcrusher, sample_rate: 2000, cutoff: 80 do
    with_fx :ring_mod, freq: 30, mix: 0.5 do
      at sn2_t, sn2_rt do |rt|
        sample :elec_filt_snare, amp: 0.5, beat_stretch: 16, rate: rt
      end
    end
  end
  sleep 32
end

# s drum_tom_hi_soft, l 80

live_loop :tom, sync: :met do
  stop
  with_fx :reverb, room: 0.9 do
    with_fx :echo, phase: 0.5, decay: 8, mix: 0.75 do
      with_fx :ring_mod, freq: rrand(30, 90), mix: 0.9 do
        at tom_t do
          sample :drum_tom_hi_soft, lpf: 80
        end
      end
    end
  end
  sleep 4
end

# s elec_tick, a 1, l l, pn rrand(-1, 1)

live_loop :tck, sync: :met do
  stop
  at tck_t, tck_l do |l|
    sample :elec_tick, amp: 1.5, lpf: l, pan: rrand(-1, 1)
  end
  sleep 8
end

# sth tri, n ns.l, rel ds.l, co 100

live_loop :tri, sync: :met do
  stop
  ns = (ring :c1)
  ds = (ring 8)
  tick
  with_fx :wobble, phase: 8, invert_wave: 1 do
    with_fx :bitcrusher, bits: 6, sample_rate: 3000 do
      with_fx :tanh, mix: 0.75 do
        synth :tri, note: ns.look, release: ds.look, cutoff: 100
        sleep ds.look
      end
    end
  end
end