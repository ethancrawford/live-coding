# 7, two1, two7 ->

#slide([:two1_lv,:two7_lv], 64, false, amp: 0)

use_bpm 132

live_loop :met do
  sleep 2
end

# s ss.lk, a rr(0.35, 0.6), on hs.lk, b_s rr(0.5, 1), lp rr(80, 120), pn rr(-1, 1)
live_loop :three1, sync: :met do
  #stop
  level(:three1, 0) do
    use_random_seed 78916#90226#78916#142561
    hs = (spread 28, 32).shuffle
    ss = sample_names(:tabla).pick(3)
    hs.length.times do
      tick
      sample ss.look, amp: rrand(0.35, 0.6), on: hs.look, beat_stretch: rrand(0.5, 1), lpf: rrand(80, 120), pan: rrand(-1, 1)
      sleep 0.25
    end
  end
end
##| sync :three1
##| slide(:three1_lv, 64, false, amp: 1)


# s bd_haus, a 0.5, on hs.lk
live_loop :three2, sync: :three1 do
  #stop
  level(:three2, 0) do
    #use_random_seed 30768
    hs = (bools 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0)
    hs.length.times do
      tick
      sample :bd_haus, amp: 0.5, on: hs.look
      sleep 0.25
    end
  end
end
##| sync :three2
##| slide(:three2_lv, 64, false, amp: 1)

# s drum_cymbal_closed, a 0.5, on hs.lk, hp 105
live_loop :three3, sync: :three1 do
  #stop
  level(:three3, 0) do
    hs = (bools 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0)
    hs.length.times do
      tick
      sample :drum_cymbal_closed, amp: 0.5, on: hs.look, hpf: 105
      sleep 0.25
    end
  end
end
##| sync :three3
##| slide(:three3_lv, 64, false, amp: 1)

# s drum_snare_soft, on hs.lk, rt rr(1, 4)
live_loop :three4, sync: :three1 do
  #stop
  level(:three4, 0) do
    use_random_seed (knit 67260, 3, 43737, 1).tick(:r)
    hs = (spread 10, 16).shuffle
    hs.length.times do
      tick
      sample :drum_snare_soft, on: hs.look, rate: rrand(1, 4)
      sleep 0.25
    end
  end
end
##| sync :three4
##| slide(:three4_lv, 64, false, amp: 1)

# s = sth saw, a 0.5, n ns.look, rel ds.lk, co 100
# s2 = sth sq, a 0.2, n ns.look - 0.1, rel ds.lk, co 70
live_loop :three5, sync: :three1 do
  #stop
  level(:three5, 0) do
    ns = (ring :r, :e4, :b3, :e3, :r)
    ds = (ring 4, 1, 1, 1, 8)
    ns = (scale :d3, :major, num_octaves: 1).shuffle.take(3).repeat(8)
    ds = (ring 0.5)
    with_fx :reverb, room: 1 do
      with_fx :tanh, mix: 0, amp: 0.5 do |th|
        with_fx :echo, phase: 0.75, decay: 8, mix: 0.9 do
          with_fx :rhpf, cutoff: 70, mix: 0.5 do |hp|
            ns.length.times do
              tick
              s = synth :saw, amp: 0.5, note: ns.look, release: ds.look, cutoff: 100
              synth :square, amp: 0.2, note: ns.look - 0.1, release: ds.look, cutoff: 70
              control s, cutoff_slide: 0.25, cutoff: 70
              sleep ds.look
            end
          end
        end
      end
    end
  end
end
##| sync :three5
##| slide(:three5_lv, 64, false, amp: 1)

# sth dark_a, a 1, n ns.lk
# sth holl, a 0.4, n ns.lk + 12, cutoff: 100
# sth subp, a 0.8, n ns.sh.look - 24, pan: -0.25
# sth subp, a 0.5, n ns.sh.look - 12, pan: 0.25
live_loop :three6, sync: :three5 do
  #stop
  level(:three6, 0) do
    ns = (scale :d3, :major).shuffle.pick(3)
    ds = (ring 8)
    use_synth_defaults sustain: ds.look, release: 0
    with_fx :compressor, slope_above: 0.3, slope_below: 1.2, amp: 0.75 do
      with_fx :reverb, room: 1 do
        tick
        synth :dark_ambience, amp: 1, note: ns.look
        synth :hollow, amp: 0.4, note: ns.look + 12, cutoff: 100
        synth :subpulse, amp: 0.8, note: ns.look - 24, pan: -0.25
        synth :subpulse, amp: 0.5, note: ns.look - 12, pan: 0.25
        sleep ds.look
      end
    end
  end
end
##| sync :three6
##| slide(:three6_lv, 64, false, amp: 1)
