live_loop :met do
  sleep 2
end

# s :ambi_soft_buzz, a 0.5, bs 2

live_loop :ring_buzz, sync: :met do
  stop
  with_fx :slicer, seed: 49326, probability: 0.9, phase: 0.125, prob_pos: 0.5, mix: 0.8 do
    with_fx :echo, phase: 0.375, mix: 0.5, decay: 8 do
      with_fx :reverb, room: 1 do
        with_fx :ring_mod, freq: 60, mix: 0.5 do
          sample :ambi_soft_buzz, amp: 0.5, beat_stretch: 2
          sleep 4
        end
      end
    end
  end
end

# s :bass_hit_c, a 0.5, rt -1, bs 1, r 2, l 70

live_loop :ring_bass, sync: :met do
  stop
  with_fx :echo, phase: 0.375, decay: 8 do
    with_fx :ring_mod, freq: 60, mix: 0.25 do
      with_fx :tanh do
        sample :bass_hit_c, amp: 0.5, rate: -1, beat_stretch: 1, release: 2, lpf: 70
        sleep 4
      end
    end
  end
end

# s :ambi_dark_woosh, a 0.5, bs 4

live_loop :woosh, sync: :met do
  stop
  with_fx :reverb, room: 1 do
    with_fx :bitcrusher, sample_rate: 3000 do
      sample :ambi_dark_woosh, amp: 0.5, beat_stretch: 4
      sleep 8
    end
  end
end

# s :bd_fat, a 0.5

live_loop :fat, sync: :met do
  stop
  with_fx :bitcrusher do
    sample :bd_fat, amp: 0.5
    sleep 1
  end
end

# s :elec_soft_kick, l 60 if (spr 4, 7).l

live_loop :elec_kick, sync: :met do
  stop
  tick
  sample :elec_soft_kick, lpf: 60 if (spread 4,7).look
  sleep 0.125
end

# s :drum_snare_soft, l 70 if (spr 5, 7).l

live_loop :soft_snare, sync: :met do
  stop
  tick
  sample :drum_snare_soft, lpf: 70 if (spread 5,7).look
  sleep 0.125
end

#  sth growl, a 0.4, n [:e3, :e4], r 16

live_loop :growl1, sync: :met do
  stop
  with_fx :rlpf, cutoff: rrand(60, 100) do
    with_fx :reverb, room: 1, amp: 0.8 do
      with_fx :bitcrusher, bits: 5, mix: 0.5, cutoff: 110 do
        synth :growl, amp: 0.4, note: [:e3, :e4], release: 16
        sleep 16
      end
    end
  end
end
