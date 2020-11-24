# The below line was just a way for me to remind myself about
# which loops to leave running in the transition between pieces
# (loops one5 and one6, out of 7 live_loops in buffer 0)
# Similar lines in the rest of the code mean the same thing.

# 7, one5, one6 ->

# Here is where I used slide to fade out the desired loops
#slide([:one5_lv,:one6_lv], 64, false, amp: 0)

use_bpm 132

live_loop :met do
  sleep 2
end

live_loop :two1, sync: :met do
  #stop
  level(:two1, 0) do
    use_random_seed 45016
    hs = (spread 28, 32).shuffle.pick(7)
    hs = hs + hs.pick(4)
    ss = sample_names(:tabla).pick(5)
    with_fx :ping_pong, phase: 0.75, feedback: 0.9, mix: 0.5 do
      with_fx :tanh, mix: 0.2 do
        hs.length.times do
          tick
          sample ss.look, amp: rrand(0.1, 0.2), on: hs.look, beat_stretch: rrand(0.5, 1), lpf: rrand(80, 120), pan: rrand(-1, 1)
          sleep 0.25
        end
      end
    end
  end
end
##| sync :two1
##| slide(:two1_lv, 64, false, amp: 1)

# s ss.lk(s), a 0.5, on hs.lk, b_s rr(1, 2)
live_loop :two2, sync: :two1 do
  #stop
  level(:two2, 0) do
    use_random_seed 600241
    hs = (bools 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0)
    #hs = (bools 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1)
    ss = sample_names(:bd).pick(4)
    with_random_seed 2345 + look do
      ss = ss.shuffle
    end
    hs.length.times do
      tick
      tick(:s) if hs.look
      sample ss.look(:s), amp: 0.5, on: hs.look, beat_stretch: rrand(1,2)
      sleep 0.25
    end
  end
end
##| sync :two2
##| slide(:two2_lv, 64, false, amp: 1)

# sth dtri, a 0.2, n ns.look, co 80
# sth tri, a 0.4, n ns.look + 19, co 70
# sth tri, a 0.2, n ns.look - 24.1, co 80
# sth sine, a 0.2, n ns.look + 12
# sth hollow, a 5, n ns.look + 19, co 110
live_loop :two3, sync: :two1 do
  #stop
  level(:two3, 0) do
    ns = (ring :fs4)
    ds = (ring 16)
    with_fx :reverb, room: 1 do
      with_fx :rlpf, cutoff: 60, mix: 1, amp: 1.5 do
        with_fx :rbpf, centre: 75, amp: 1.5 do
          use_synth_defaults attack: ds.look / 2.0, release: ds.look / 2.0
          ns.length.times do
            tick
            synth :dtri, amp: 0.2, note: ns.look, cutoff: 80
            synth :tri, amp: 0.4, note: ns.look + 19, cutoff: 70
            synth :tri, amp: 0.2, note: ns.look - 24.1, cutoff: 80
            synth :sine, amp: 0.2, note: ns.look + 12
            synth :hollow, amp: 5, note: ns.look + 19, cutoff: 110
            sleep ds.look
          end
        end
      end
    end
  end
end
##| sync :two3
##| slide(:two3_lv, 64, false, amp: 1)

# s = snth pre_b, a 0.25, n ns.lk, sus ds.lk
live_loop :two4, sync: :two1 do
  #stop
  level(:two4, 0) do
    ns = (ring [:fs2, :cs5], [:fs4, :cs3], :r)
    #ns = (ring [:fs2, :cs5], [:fs4, :e3], :r)
    #ns = (ring [:fs2, :cs5], [:fs3, :b2], :r)
    #ns = (ring [:fs2, :cs5], [:a3, :d2], :r)
    ds = (ring 0.25, 0.25, 15.5)
    with_fx :reverb, room: 1 do
      with_fx :ping_pong, phase: 0.75, feedback: 0.75, mix: 0.75 do
        ns.length.times do
          tick
          s = synth :pretty_bell, amp: 0.25, note: ns.look, sustain: ds.look
          
          control s, cutoff_slide: 0.25, cutoff: 60
          sleep ds.look
        end
      end
    end
  end
end
##| sync :two4
##| slide(:two4_lv, 64, false, amp: 1)

# sth noise, a (ln 0, 1, stps 256, inc true).lk, sus ds.look/3.0, rel 0, co (ln 60,90,stps 256, inc true).lk
live_loop :two5, sync: :two4 do
  #stop
  #sync :two4
  level(:two5, 0) do
    ds = (ring 0.25).stretch(256)
    ds.length.times do
      tick
      synth :noise, amp: (line 0, 1, steps: 256, inclusive: true).look, sustain: ds.look / 3.0, release: 0, cutoff: (line 60, 90, steps: 256, inclusive: true).look
      sleep ds.look
    end
    cue :b
  end
end
##| sync :two5
##| slide(:two5_lv, 64, false, amp: 1)

# The below sync and slide were my attempt to slide the :tanh fx
# in the following live_loop
#sync :two6  #sync slide to a cue
#slide(:two6_th, 64, false, mix: [0,1])

live_loop :two6, sync: :two2 do
  #stop
  level(:two6, 0) do
    # Track which sequence to use in the melody
    seq2 = true
    # Assign notes and durations depending on current sequence
    # Not the best ruby code - I was writing this in a hurry ;p
    # ns = seq1 notes, nss = seq2 notes, ds = durations
    ns, nss2, ds = if seq2 == true
      [
        ns = ((knit :fs2, 11) + (knit :fs2, 10)).mirror,
        nss = (ring :fs2, :fs2, :d2, :fs2, :fs2, :fs2, :a2, :fs2),
        ds = (knit 0.75, 10, 0.5, 1) + (knit 0.75, 9, 1.25, 1) + (knit 0.75, 9, 1.25, 1) + (knit 0.75, 10, 0.5, 1)
      ]
    else
      [
        ns = (knit :fs2, 4, :r, 1).repeat(8),
        nil,
        ds = (knit 0.75, 3, 0.5, 1, 1.25, 1).repeat(8)
      ]
    end
    
    with_fx :ping_pong, phase: 0.375, feedback: 0.75, mix: 0.75 do
      # th m 1, kr 20, a 0.45
      # Set the initial value of the tanh slide variable
      set(:two6_th_mix, 0)
      with_fx :tanh, mix: get(:two6_th_mix) do |th|
        # Store the tanh fx node to manipulate elsewhere
        set(:two6_th, th)
        tick(:s) if look == 0 && look(:s) == 0 && seq2
        ns.length.times do
          tick
          n = seq2 ? nss.look(:s) : ns.look
          s = synth :fm, amp: 0.15, note: n, release: ds.look + 0.5, cutoff: 120, depth: 1, divisor: 2
          s2 = synth :fm, amp: 0.08, note: n+12, release: ds.look + 0.5, cutoff: 120, depth: 1, divisor: 4, pan: -0.5
          s3 = synth :fm, amp: 0.08, note: n+19, release: ds.look + 0.5, cutoff: 120, depth: 1, divisor: 2, pan: 0.5
          if seq2 && look == (ring 10, 20, 30, 41).look(:s)
            tick(:s)
            control s, note_slide: ds.look + 0.5, note: nss.look(:s)
            control s2, note_slide: ds.look + 0.5, note: nss.look(:s) + 12
            control s3, note_slide: ds.look + 0.5, note: nss.look(:s) + 19
          end
          control s, cutoff_slide: 0.25, cutoff: 90
          control s2, cutoff_slide: 0.25, cutoff: 90
          control s3, cutoff_slide: 0.25, cutoff: 90
          sleep ds.look
        end
        tick_reset if seq2 && look(:s) % 4 == 0
        
      end
    end
  end
end
##| sync :two6
##| slide(:two6_lv, 64, false, amp: 1)

# s bd_tek, a 0.5, on hs.lk
live_loop :two7, sync: :two1 do
  #stop
  level(:two7, 0) do
    # Wait for a :b cue if this is the first time this loop has run
    sync :b if look == 0
    
    hs = (bools 1, 0, 0, 0, 1, 0, 0, 0)
    hs.length.times do
      tick
      sample :bd_tek, amp: 0.5, on: hs.look
      sleep 0.25
    end
  end
end
##| sync :two7
##| slide(:two7_lv, 64, false, amp: 1)
