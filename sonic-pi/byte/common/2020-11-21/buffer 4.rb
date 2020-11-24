#7, four1, four2, four3, four7 ->

#slide([:four1_lv,:four2_lv,:four3_lv, :four7_lv], 64, false, amp: 0)

use_bpm 132

live_loop :met do
  sleep 2
end

# s elec_twang, a 1, hp rr(90, 100), b_s 0.0625, on hs.lk
live_loop :five1, sync: :met do
  #stop
  level(:five1, 0) do
    use_random_seed 351261#65426
    hs = (spread 8, 17).shuffle
    hs.length.times do
      tick
      sample :elec_twang, amp: 1, hpf: rrand(90, 100), beat_stretch: 0.0625, on: hs.look
      sleep 0.25
    end
  end
end
##| sync :five1  #sync slide to a cue
##| slide(:five1_lv, 64, false, amp: [0,1])

# s elec_plip, a rr(1, 1.5), on hs.lk, b_s rr(0.125, 0.5), hp rr(60, 80)
live_loop :five2, sync: :five1 do
  stop
  level(:five2, 0) do
    use_random_seed 476345
    hs = (spread 7, 14).shuffle
    hs.length.times do
      tick
      sample :elec_plip, amp: rrand(1, 1.5), on: hs.look, beat_stretch: rrand(0.125, 0.5), hpf: rrand(60, 80)
      sleep 0.25
    end
  end
end
##| sync :five2
##| slide(:five2_lv, 64, false, amp: [0,1])

# sample elec_lo_snare, a 0.3, on hs.lk, b_s rr(0.125, 0.5), lp rr(60, 100)
live_loop :five3, sync: :five1 do
  stop
  level(:five3, 0) do
    hs = (spread 12, 19)
    with_fx :echo, phase: 1, decay: 8, mix: 0.5 do
      with_fx :tanh, mix: 0.6 do
        hs.length.times do
          tick
          sample :elec_lo_snare, amp: 0.3, on: hs.look, beat_stretch: rrand(0.125, 0.5), lpf: rrand(60, 100)
          sleep 0.25
        end
      end
    end
  end
end
##| sync :five3
##| slide(:five3_lv, 64, false, amp: [0,1])

# set(:r, [:d2, :minor])
# s = sth subpulse, a 0.3, n ns.lk, sus ds.lk / 2.0, rel ds.lk / 2.0, co 100, pn -0.25
# s2 = sth subpulse, a 0.5, n ns.lk - 12, sus ds.lk / 2.0, rel ds.lk / 2.0, co 100, pn 0.25
live_loop :five4, sync: :five1 do
  stop
  level(:five4, 0) do
    ns = degs2ns((ring 8, 11, 7, 5))
    ds = (knit 8, 4)
    ns.length.times do
      tick
      s = synth :subpulse, amp: 0.3, note: ns.look, sustain: ds.look / 2.0, release: ds.look, cutoff: 100, pan: -0.25
      s2 = synth :subpulse, amp: 0.5, note: ns.look - 12, sustain: ds.look / 2.0, release: ds.look / 2.0, cutoff: 100, pan: 0.25
      control s, cutoff_slide: 0.25, cutoff: 70
      control s2, cutoff_slide: 0.25, cutoff: 70
      sleep ds.look
    end
  end
end
##| sync :five4
##| slide(:five4_lv, 64, false, amp: [0,1])

# s bd_haus, a 0.75, lp 90
live_loop :five5, sync: :five1 do
  #stop
  level(:five5, 0) do
    sample :bd_haus, amp: 0.75, lpf: 90
    sleep 1
  end
end
#sync :five5
#slide(:five5_lv, 64, false, amp: [0,1])

# s = sth dtri, a 0.25, n ns.lk, rel ds.lk, co 100, dtn 0.2
live_loop :five6, sync: :five1 do
  stop
  level(:five6, 0) do
    sc = if one_in(3)
      (scale :g3, :minor_pentatonic).choose
    else
      :g3
    end
    ns = (ring sc, :r, sc, :r)
    ds = (ring 0.5, 0.25, 0.5, 6.75)
    with_fx :reverb, room: 1 do
      with_fx :echo, phase: 0.75, decay: 8, mix: 0.5 do
        with_fx :tanh, mix: 0.5 do
          with_fx :flanger, phase: 4, feedback: 0.1, depth: 2 do
            ns.length.times do
              tick
              s = synth :sine, amp: 0.25, note: ns.look, release: ds.look, cutoff: 100, detune: 0.2
              
              control s, cutoff_slide: 0.25, cutoff: 70
              sleep ds.look
            end
          end
        end
      end
    end
  end
end
##| sync :five6
##| slide(:five6_lv, 64, false, amp: [0,1])
