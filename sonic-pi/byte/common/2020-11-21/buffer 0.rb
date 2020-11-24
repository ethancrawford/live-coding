# The below (commented out) command was purely to bump up the volume
# as a workaround for an apparent limitation with my virtual sound device
#set_mixer_control! amp: 2

use_bpm 132

live_loop :met do
  sleep 2
end

# Used to store scale information for the degs2ns function
set(:r, [:d2, :major])

#s = sth sq, a 0.3, n ns.lk, sus ds.lk, co 70
live_loop :one1, sync: :met do
  #stop
  level(:one1, 0) do
    ##| ns = degs2ns((ring 5, 4, 2, 5))
    ##| ns = degs2ns((ring 1, 2, 6, 8))
    ##| ns = degs2ns((ring 8, 6, 3, 4))
    ##| ds = (knit 8, 4)
    ns = degs2ns((ring 1))
    ds = (ring 32)
    with_fx :reverb, room: 1 do
      with_fx :compressor, slope_above: 0.4, threshold: 0.1, slope_below: 1.2 do
        with_fx :flanger, phase: 8, depth: 1, feedback: 0.5, delay: 10, decay: 5, amp: 1 do
          with_fx :echo, phase: 1, decay: 16, mix: 0.25 do
            with_fx :bitcrusher, sample_rate: 3000, cutoff: 90, mix: 0.5 do
              with_fx :bpf, centre: 90, cutoff: 90, mix: 0.8 do
                ns.length.times do
                  tick
                  s = synth :square, amp: 0.3, note: ns.look, sustain: ds.look, cutoff: 70
                  
                  control s, cutoff_slide: 1, cutoff: 100
                  sleep 1
                  control s, cutoff_slide: 1, cutoff: 80
                  sleep ds.look - 1
                end
              end
            end
          end
        end
      end
    end
  end
end
# (Commented out below):
# As soon as the :one1 live_loop has completed its current loop,
# slide the amp value of the level fx used above (named :one1_lv) over 64 beats
# to a value of 1, and do not 'snap' the value back afterwards.
# (Similar calls like this in the rest of the code follow the same pattern).
##| sync :one1
##| slide(:one1_lv, 64, false, amp: 1)


#s = sth tb, rs 0.4, a 0.3, n ns.lk + 12, sus ds.lk, co 70
live_loop :one2, sync: :one1 do
  #stop
  level(:one2, 0) do
    ns = degs2ns((ring 5, 4, 2, 5))
    ##| ns = degs2ns((ring 1, 2, 6, 8))
    ##| ns = degs2ns((ring 8, 6, 3, 4))
    ds = (knit 8, 4)
    ##| ns = degs2ns((ring 1))
    ##| ds = (ring 32)
    with_fx :reverb, room: 1 do
      with_fx :compressor, slope_above: 0.4, threshold: 0.1, slope_below: 1.2 do
        with_fx :flanger, phase: 8, depth: 1, feedback: 0.5, delay: 10, decay: 5, amp: 1 do
          with_fx :echo, phase: 1, decay: 16, mix: 0.25 do
            with_fx :bpf, centre: 90, cutoff: 90, mix: 0.9 do
              ns.length.times do
                tick
                s = synth :tb303, amp: 0.3, res: 0.4, note: ns.look + 12, sustain: ds.look, cutoff: 70
                
                control s, cutoff_slide: 1, cutoff: 90
                sleep 1
                control s, cutoff_slide: 1, cutoff: 80
                sleep ds.look - 1
              end
            end
          end
        end
      end
    end
  end
end
##| sync :one2
##| slide(:one2_lv, 64, false, amp: 1)

#s = sth saw, a 0.3, n ns.lk + 36, rel ds.lk, co 80
live_loop :one3, sync: :met do
  #stop
  level(:one3, 0) do
    with_fx :reverb, room: 1 do
      with_fx :ping_pong, phase: 0.75, feedback: 0.75, mix: 0.75 do
        ns = degs2ns((ring 3, 1, :r, 2, 3, 1, :r, 3, :r, 4, 1, :r, 3, 5, 2, :r))
        ds = (ring 0.25, 0.25, 0.5, 0.75, 0.25, 0.25, 1, 0.5, 1, 0.25, 0.25, 0.75, 0.25, 0.5, 0.25, 1)
        ns = degs2ns((ring 2, 4, :r, 1, 5, 2, :r, 4, :r, 1, 3, :r, 4, 2, 1, :r))
        ds = (ring 0.25, 0.25, 0.5, 0.75, 0.25, 0.25, 1, 0.5, 1, 0.25, 0.25, 0.75, 0.25, 0.5, 0.25, 1)
        num = rrand(4, ns.length)
        ns = ns.take(num)
        ds = ds.take(num)
        ns.length.times do
          tick
          s = synth :saw, amp: 0.3, note: ns.look + 36, release: ds.look, cutoff: 80
          
          control s, cutoff_slide: 0.25, cutoff: 70
          sleep ds.look
        end
        tick_reset
      end
    end
  end
end
##| sync :one3
##| slide(:one3_lv, 64, false, amp: 1)

# s elec_filt_snare, a 3, at 0.1, b_s 16, hp 110
live_loop :one4, sync: :one1 do
  #stop
  level(:one4, 0) do
    sample :elec_filt_snare, amp: 3, attack: 0.1, beat_stretch: 16, hpf: 110
    sleep 32
  end
end
##| sync :one4
##| slide(:one4_lv, 64, false, amp: 1)

# s loop_mehackit1, a 0.8, on hs.lk, hp rr(60, 100), pn rr(-1, 1), onst pk
live_loop :one5, sync: :one1 do
  #stop
  level(:one5, 0) do
    use_random_seed 5976
    hs = (spread 14, 16).shuffle
    hs.length.times do
      tick
      sample :loop_mehackit1, amp: 0.8, on: hs.look, hpf: rrand(60, 100), pan: rrand(-1, 1), onset: pick
      sleep 0.25
    end
  end
end
##| sync :one5
##| slide(:one5_lv, 64, false, amp: 1)

# s bd_mehackit, a 0.4, on hs.lk, lp rr(60, 90)
live_loop :one6, sync: :one5 do
  #stop
  level(:one6, 0) do
    use_random_seed 2
    hs = (spread 4, 16).shuffle
    with_fx :echo, phase: 1, mix: 0.25 do
      hs.length.times do
        tick
        sample :bd_mehackit, amp: 0.4, on: hs.look, lpf: rrand(60, 90)
        sleep 0.25
      end
    end
  end
end
##| sync :one6
##| slide(:one6_lv, 64, false, amp: 1)

# sth subp, a 0.35, n ns.lk(:n) + 24, rel ds.look, pn 0.25
live_loop :one7, sync: :one5 do
  #stop
  level(:one7, 0) do
    use_random_seed 57537
    # Set a variable to a random value controlled by a seed
    # specific only to the with_random_seed block
    # (so that random values elsewhere in this live_loop are not affected by it)
    f = with_random_seed 4625 + look do
      [2, 4].choose
    end
    ns = degs2ns((ring 3, 1, 6, f).stretch(16))
    ds = (ring 0.25)
    hs = (spread 8, 16).shuffle.repeat(4)
    with_fx :reverb, room: 1 do
      with_fx :echo, phase: 0.75, decay: 16, mix: 0.5 do |ec|
        with_fx :wobble, filter: 1, phase: 16, wave: 2, mix: 0.8, cutoff_min: 60, cutoff_max: 100 do |wb|
          if one_in(3)
            with_random_seed 3457 + look do
              control ec, decay: rrand(4, 16)
              control wb, mix: rrand(0, 1)
              control wb,  cutoff_min: rrand(60, 80), cutoff_max: rrand(90, 100)
              control wb, invert_wave: (ring 0, 1).choose
              control wb, wave: (ring 0, 1, 2, 3).choose
              control wb, phase: (ring 4, 8, 16).choose
            end
          end
          hs.length.times do
            tick
            if hs.look
              tick(:n)
              synth :subpulse, amp: 0.35, note: ns.look(:n) + 24, release: ds.look, pan: 0.25
              
            end
            sleep ds.look
          end
        end
      end
    end
  end
end
##| sync :one7
##| slide(:one7_lv, 64, false, amp: 1)
