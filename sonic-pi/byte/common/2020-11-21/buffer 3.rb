# 6, three2, three3, three4 ->

#slide([:three2_lv, :three3_lv, :three4_lv], 64, false, amp: 0)

use_bpm 132

live_loop :met do
  sleep 2
end

live_loop :four1, sync: :met do
  #stop
  level(:four1, 0) do
    use_random_seed 401090#98716#915221
    hs = (spread 14, 16).shuffle
    ss = sample_names(:elec).take(32).shuffle#.take(16)
    with_fx :tanh, mix: 0 do |th|
      hs.length.times do
        tick
        control th, mix: rrand(0.5, 1)
        sample ss.look, amp: 0.15, on: hs.look, lpf: rrand(60, 120), beat_stretch: rrand(0.125, 0.5), pan: -0.5
        sleep 0.25
      end
    end
  end
end
##| sync :four1
##| slide(:four1_lv, 64, false, amp: 1)

live_loop :four2, sync: :four1 do
  #stop
  level(:four2, 0) do
    use_random_seed 401090#93711#60519
    hs = (spread 10, 16).shuffle
    ss = sample_names(:bd).take(32).shuffle#.take(16)
    with_fx :ping_pong, phase: 0.75, feedback: 0.75, mix: 0.5 do
      with_fx :bitcrusher, bits: 5 do
        with_fx :tanh, mix: 0 do |th|
          hs.length.times do
            tick
            control th, mix: 1
            sample ss.look, amp: 0.15, on: hs.look, beat_stretch: rrand(0.25, 0.5), pan: 0.5
            sleep 0.25
          end
        end
      end
    end
  end
end
##| sync :four2  #sync slide to a cue
##| slide(:four2_lv, 64, false, amp: 1)

live_loop :four3, sync: :four1 do
  #stop
  level(:four3, 0) do
    use_random_seed 402190#3830#195230
    hs = (spread 3, 16).shuffle
    ss = sample_names(:sn).take(32).shuffle.take(16)
    with_fx :ping_pong, phase: 0.75, feedback: 0.75, mix: 0.3 do
      with_fx :bitcrusher, bits: 5, mix: 0 do
        with_fx :tanh, mix: 0.5 do |th|
          hs.length.times do
            tick
            #control th, mix: 1
            sample ss.look, amp: 0.15, on: hs.look, beat_stretch: rrand(0.25, 2), pan: -0.5
            sleep 0.25
          end
        end
      end
    end
  end
end
##| sync :four3
##| slide(:four3_lv, 64, false, amp: 1)


# s = sth subp, a as.lk, n ns.lk + 0.1
# s2 = sth tri, a as.lk, n ns.lk
live_loop :four4, sync: :four1 do
  #stop
  level(:four4, 0) do
    ns = (knit :fs3, 3, :fs5, 1, :r, 1, :fs4, 3, :fs6, 1).shuffle + (ring :r)
    ds = (knit 0.25, 4, 0.25, 1, 0.25, 4) + (ring (rrand(13, 29) + 0.75))
    as = (ring 0.3, 0.4, 0.25, 0.5, 1, 0.3, 0.4, 0.25, 0.5, 0)
    use_synth_defaults release: ds.look
    with_fx :reverb, room: 1 do
      with_fx :rbpf, centre: rrand(70, 90), res: rrand(0.5, 0.9), mix: rrand(0.8, 1), amp: 0.7 do
        with_fx :wobble, res: 0.4, phase: 0.5, cutoff_max: 100 do
          with_fx :ring_mod, freq: 60, mix: 0.4 do
            with_fx :echo, phase: 0.75, decay: 16, mix: 0.5, amp: 0.25 do |ec|
              control ec, phase_slide: rrand(4, 8), phase: rrand(0.7, 0.8)
              ns.length.times do
                tick
                synth :subpulse, amp: as.look, note: ns.look + 0.1
                synth :tri, amp: as.look, note: ns.look
                sleep ds.look
              end
            end
          end
        end
      end
    end
  end
end
##| sync :four4  #sync slide to a cue
##| slide(:four4_lv, 64, false, amp: 1)

#s = sth saw, a 0.5, n ns.lk, at ds.lk / 2, rl ds.lk / 2, cu 100
live_loop :four5, sync: :four1 do
  #stop
  level(:four5, 0) do
    ns = (ring :fs2, :e2, :fs2, :b1)
    ds = (ring 8)
    with_fx :reverb, room: 1 do
      with_fx :slicer, phase: 0.25, probability: 0.8, prob_pos: 0.3, seed: 56943 do
        ns.length.times do
          tick
          s = synth :saw, amp: 0.5, note: ns.look, attack: ds.look / 2.0, release: ds.look / 2.0
          
          control s, cutoff_slide: 0.25, cutoff: 90
          sleep ds.look
        end
      end
    end
  end
end
##| sync :four5  #sync slide to a cue
##| slide(:four5_lv, 64, false, amp: 1)

#s = sth saw, a 0.5, n ns.lk, sus ds.lk, cu 100
live_loop :four6, sync: :four1 do
  #stop
  level(:four6, 0) do
    ns = (ring :cs3, :e3, :eb3, :gs3)
    ds = (ring 8)
    with_fx :slicer, phase: 0.25 do
      with_fx :wobble, phase: 32, filter: 1, cutoff_min: 80, cutoff_max: 100, invert_wave: 1, mix: 0.5 do
        #with_fx :tanh, mix: 0.2 do
        ns.length.times do
          tick
          s = synth :saw, amp: 0.5, note: ns.look, sustain: ds.look, cutoff: 100
          
          control s, cutoff_slide: 0.25, cutoff: 85
          sleep ds.look
        end
        #end
      end
    end
  end
end
##| sync :four6  #sync slide to a cue
##| slide(:four6_lv, 64, false, amp: 1)

# sth sine, n ns.lk + 12, pan: -0.5, re ds.lk
# sth sine, n ns.lk, pan: 0.5, re ds.lk
live_loop :four7, sync: :four1 do
  #stop
  level(:four7, 0) do
    ns = (ring :cs4, :e4, :gs4, :fs4, :r) + [(ring :eb4, :e4, :b4), (ring :b4, :fs4, :gs4)].choose + (ring :r, :gs4, :fs4, :e4, :eb4, :r)
    ds = (knit 0.25, 4, 15, 1, 0.5, 1, 0.25, 2, 15, 1, 0.25, 4, 15, 1)
    with_fx :reverb, room: 1 do
      with_fx :ping_pong, phase: 0.75, feedback: 0.85 do
        use_synth_defaults amp: 0.3
        ns.length.times do
          tick
          synth :sine, note: ns.look + 12, pan: -0.5, release: ds.look
          synth :sine, note: ns.look, pan: 0.5, release: ds.look
          
          sleep ds.look
        end
      end
    end
  end
end
##| sync :four1  #sync slide to a cue
##| slide(:four7_lv, 64, false, amp: 1)

