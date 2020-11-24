# 6, five1, five2, five4, leave five5??

#slide([:five5_lv], 64, false, amp: 0)

use_bpm 132

live_loop :met do
  sleep 2
end


# s :elec_blup a 0.75, bs 4 fsh 0.25, l rr(80, 130) if h.look
live_loop :six1, sync: :met do
  #stop
  level(:six1, 0) do
    use_random_seed 642564264
    hs = (bools 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0).shuffle
    with_fx :compressor do
      with_fx :rbpf, centre: 70, amp: 5 do
        hs.length.times do
          tick
          stop if get(:stop)
          sample :elec_blup, amp: 0.75, beat_stretch: 4, finish: 0.25, lpf: rrand(80, 130) if hs.look
          sleep 0.25
        end
      end
    end
  end
end
##| sync :six1
##| slide(:six1_lv, 64, false, amp: 1)

# s :elec_twip, a 0.25, bs 2, fsh 0.25, l rr(80. 90), o: hs.look
live_loop :six2, sync: :six1 do
  #stop
  level(:six2, 0) do
    use_random_seed 96487653
    hs = (bools 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0).shuffle.rotate(1)
    with_fx :panslicer, pan_min: -0.5, pan_max: 0.5, phase: 0.25, mix: 0.5 do
      with_fx :echo, phase: 0.75, decay: 8, mix: 0.3 do
        with_fx :compressor do
          with_fx :rbpf, centre: 85, mix: 0.8, amp: 1.3 do
            with_fx :rlpf, cutoff: (knit 130, 3, 80, 1).tick(:l) do
              with_fx :tanh, mix: 0.5 do
                hs.length.times do
                  tick
                  stop if get(:stop)
                  sample :elec_twip, amp: 0.25, beat_stretch: 2, finish: 0.25, lpf: rrand(80, 90), on: hs.look
                  sleep 0.25
                end
              end
            end
          end
        end
      end
    end
  end
end
##| sync :six2
##| slide(:six2_lv, 64, false, amp: 1)

# Thanks!!

# s1 = sth tri, a (r 0.5, 0.3).t(a), n :a3, sus 4, co 90
#live_loop :six3, sync: :six2 do
#stop
sync :end
level(:six3, 0, true) do
  with_fx :reverb, room: 1 do
    with_fx :echo, phase: 0.75, decay: 30, mix: 1 do
      with_fx :compressor do
        with_fx :ixi_techno, phase: rrand(4, 16), cutoff_min: rrand(60, 120), cutoff_max: rrand(60, 120), phase_offset: rrand(0, 1) do
          with_fx :bpf, centre: rrand(80, 100), res: 0.7, amp: 2, mix: 0.95 do
            sleep 1.25
            s1 = synth :tri, amp: (ring 0.5, 0.3).tick(:a), note: :a3, sustain: 4, cutoff: 90
            stop if get(:stop)
            control s1, note_slide: 4, note: :a1
            sleep (ring 14, 22, 30).choose + 0.75
          end
        end
      end
    end
  end
end
#end
##| sync :six3
##| slide(:six3_lv, 64, false, amp: 1)

# s1 = sth sine, a (r 0.5, 0.25).t(a), n :a3, sus 4
live_loop :six4, sync: :six1 do
  #stop
  level(:six4, 0) do
    with_fx :compressor do
      with_fx :echo, phase: 0.75, decay: 16, mix: 0.8 do
        stop if get(:stop)
        sleep 3.25
        s1 = synth :tri, amp: (ring 0.15, 0.15).tick(:a), note: :a3, sustain: 4
        
        control s1, note_slide: 4, note: :a5
        sleep (ring 12, 20, 28).choose + 0.75
      end
    end
  end
end
##| sync :six4
##| slide(:six4_lv, 64, false, amp: 1)

# s elec_blup, a 0.5, on hs.lk
# sl th mx 1
# ctl ec, mx_sl 2, ph 4, mx 0
live_loop :six5, sync: :six2 do
  #stop
  level(:six5, 0) do
    # fill
    hs = (bools 1, 1, 1, 1, 1, 1, 1, 0)
    ds = (knit 0.25, 8)
    with_fx :reverb, room: 1 do
      with_fx :panslicer, pan_min: -0.5, pan_max: 0.5, phase: 4, mix: 1 do |ps|
        # control ps, phase_slide: 128, phase: 0.5
        with_fx :echo, phase: 0.75, mix: 0 do |ec|
          # control ec, mix_slide: 128, mix: 1
          with_fx :bitcrusher, bits: 7, sample_rate: 8000, mix: 0.5 do
            
            with_fx :distortion, distort: 0.9, amp: 0.1 do
              (hs.length*4).times do
                tick
                stop if get(:stop)
                if one_in(8)
                  control ec, mix_slide: 0, mix: 1
                else
                  control ec, mix_slide: 0.25, mix: 0
                end
                sample :elec_blup, amp: 0.5, on: hs.look
                sleep ds.look
              end
            end
            
          end
        end
      end
    end
  end
end
##| sync :six5
##| slide(:six5_lv, 64, false, amp: 1)

live_loop :six6, sync: :six1 do
  #stop
  level(:six6, 0) do
    stop if get(:stop)
    with_fx :echo, phase: 0.75, decay: 32 do
      sleep 16
      sample :drum_splash_hard, amp: 0.5, hpf: 110, pan: 0.5
      sleep 1
      sample :drum_splash_hard, amp: 0.25, rate: 0.5, hpf: 90, pan: -0.5
      sleep 31
    end
  end
end

# wrap was just a way for me to reduce repetition since a few loops below had
# similar code. It wraps a segment of code.

# ns = notes
# ds = durations
# block = reference to block of code being wrapped

define :wrap do |ns, ds, &block|
  with_fx :rbpf, centre: 85, mix: 0.8, amp: 2.5 do
    ns.length.times do
      tick
      stop if get(:stop)
      synth :tb303, amp: 0.5, note: ns.look, release: ds.look, cutoff: 80, res: 0.7
      sleep ds.look
    end
  end
  # Run the wrapped code
  block.call if block
end

##| set(:six7_lv_amp, 0)
##| set(:six8_lv_amp, 0)
##| set(:six9_lv_amp, 0)
##| set(:six10_lv_amp, 0)

# Which sequence are we in? :rand here
# There was originally also :cons but this was not used.
set(:seq, :rand)

# Variables storing the number of random note hits
# when playing notes in the :rand sequence
set(:rand8, 8) # 2
set(:rand9, 8) # 6

# A bunch of the below code was not used in the end,
# like anything using the cons variables :shrug:
set(:cons8, (ring 4).choose)
set(:cons9, (ring 0, 0.25, 0.5, 0.75, 1, 1.25, 1.5).choose)

# (r d2, r),
# (r 1, 7)
live_loop :six7, sync: :six1 do
  #stop
  level(:six7, 0) do
    ns, ds = case get(:seq)
    when :rand, :cons
      [
        (knit :d2, 1, :r, 7).rotate(dice(8) - 1),
        (ring 1)
      ]
    else
      [
        (ring :d2, :r),
        (ring 1, 7)
      ]
    end
    wrap(ns, ds)
  end
end
##| sync :six7
##| slide(:six7_lv, 64, false, amp: 1)

# (r r, d4, r, d4, r),
# (r 1, 0.25, 1.75, 0.25, 0.75)
live_loop :six8, sync: :six1 do
  #stop
  #sync :six1
  level(:six8, 0) do
    ns, ds = case get(:seq)
    when :rand
      [
        (knit :d4, get(:rand8), :r, 16 - get(:rand8)).shuffle,
        (knit 0.25, 16)
      ]
    when :cons
      [
        (ring :r, :r, :d4, :r, :d4, :r),
        (ring get(:cons8), 1, 0.25, 1.75, 0.25, 0.75)
      ]
    else
      [
        (ring :r, :d4, :r, :d4, :r),
        (ring 1, 0.25, 1.75, 0.25, 0.75)
      ]
    end
    wrap(ns, ds)
  end
end
##| sync :six8
##| slide(:six8_lv, 64, false, amp: 1)

# (kn r, 1, d2, 6, r, 1), #(r r) + (r d2, d3).pk(6) + (r r) if o_i(3)
# (kn 1.5, 1, 0.25, 6, 1, 1)
live_loop :six9, sync: :six1 do
  #stop
  level(:six9, 0) do
    ns, ds = case get(:seq)
    when :rand
      [
        (knit :d2, get(:rand9), :r, 16 - get(:rand9)).shuffle,
        (knit 0.25, 16)
      ]
    when :cons
      [
        (knit :r, 1, :d2, 6, :r, 1), #(ring :r) + (ring :d2, :d3).pick(6) + (ring :r) if one_in(3)
        (knit get(:cons9), 1, 0.25, 6, 2.5 - get(:cons9), 1)
      ]
    else
      [
        (knit :r, 1, :d2, 6, :r, 1), #(ring :r) + (ring :d2, :d3).pick(6) + (ring :r) if one_in(3)
        (knit 1.5, 1, 0.25, 6, 1, 1)
      ]
    end
    wrap(ns, ds)
  end
end
##| sync :six9
##| slide(:six9_lv, 64, false, amp: 1)

live_loop :six10, sync: :six1 do
  #stop
  level(:six10, 0) do
    ns = (ring :r, :b1, :c2, :cs2, :r)
    ds = (knit 7.25, 1, 0.25, 3, 8, 1)
    wrap(ns, ds)
  end
end
##| sync :six10
##| slide(:six10_lv, 64, false, amp: 1)

# s = sth mod_tri, pan: -0.5, cutoff: 90
# s2 = sth mod_sine, pan: 0.5
live_loop :six11, sync: :six1 do
  #stop
  ns = (ring :d2)
  ds = (ring 128)
  with_fx :rbpf, centre: 60, slide: 128, mix: 0 do |rb|
    control rb, centre_slide: 128, centre: 90, mix_slide: 128, mix: 1, amp_slide: 128, amp: 1
    use_synth_defaults amp: 0.3, note: ns.look, sustain: ds.look, mod_phase: 8, mod_wave: 3, mod_range: 0.5
    ns.length.times do
      tick
      s = synth :mod_tri, pan: -0.5, cutoff: 90
      s2 = synth :mod_sine, pan: 0.5
      control s, mod_phase_slide: 64, mod_phase: 0.125, mod_range_slide: 128, mod_range: 24, note_slide: 128, note: ns.look + 24
      control s2, mod_phase_slide: 64, mod_phase: 0.125, mod_range_slide: 128, mod_range: 24, note_slide: 128, note: ns.look + 24
      sleep ds.look
      # Tell other live_loops to stop when they see this value
      set(:stop, true) #!!
      # Trigger the very last sound
      cue :end
      stop
    end
  end
end

