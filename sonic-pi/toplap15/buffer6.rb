# sth tri, n ns, r 0.25 if (spr 3, 8).l

use_bpm 100
live_loop :tri_b, sync: :m3 do
  stop
  with_fx :rlpf, cutoff: 70, res: 0.8, cutoff_slide: 0.25 do |r|
    with_fx :echo, decay: 4, phase: 0.25, mix: 0.5 do
      with_fx :tanh, krunch: 10, mix: 0.5, reps: 32 do |t|
        tick
        ns = get(:tri_bass)
        synth :tri, note: ns, release: 0.25 if (spread 3, 8).look
        sleep 0.25
      end
    end
  end
end


# sth square, a 0.3, n ns.ch, r ds + 0.2, co 80

live_loop :bit_sq, sync: :tri_b do
  stop
  with_fx :wobble, phase: 4, cutoff_max: 100 do
    use_random_seed (ring 566272431114, 375436452, 5957425426).tick(:r) #68653661
    with_fx :reverb, room: 1, reps: 12 do
      tick
      ns = (scale :e3, :minor, num_octaves: 2).shuffle.take(5) + (ring :r, :r, :r, :r)
      ds = (ring 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5).choose
      with_fx :bitcrusher, bits: 5, mix: 0.2 do
        synth :square, amp: 0.3, note: ns.choose, release: ds + 0.2, cutoff: 80
        sleep ds
      end
    end
    sleep 12.75
  end
end


# sth sine
# sth dsaw

live_loop :muted_arp, sync: :tri_b do
  stop
  ns = (knit :e3, 1, :g3, 1, :a3, 1, :b3, 1)
  ds = (ring 0.25)
  with_fx :echo, decay: 8, phase: 1 do
    with_fx :reverb, room: 1 do
      with_fx :rlpf, cutoff: 70 do
        with_fx :tanh, krunch: 20, mix: 0.2 do
          with_fx :octaver, mix: 0.2, reps: 4, amp: 0.7 do
            4.times do
              tick
              use_synth_defaults amp: 0.25, attack: 0.05, attack_level: 0.7, decay_level: 0.5, release: ds.look + 0.15, note: ns.look
              synth :sine
              synth :dsaw
              sleep ds.look
            end
            sleep 7
          end
        end
      end
    end
  end
end

# s = sth saw, a 0.2, n ns.l, at 1, r ds.l - 1, co 95
# slp 1
# ctrl s

live_loop :hipad, sync: :tri_b do
  stop
  ns = (ring :fs5)
  ds = (ring 8)
  with_fx :reverb, room: 1 do
    with_fx :wobble, phase: 8, cutoff_max: 100 do
      with_fx :flanger do
        with_fx :bitcrusher, bits: 5, mix: 0.2 do
          tick
          s = synth :saw, amp: 0.2, note: ns.look, attack: 1, release: ds.look - 1, cutoff: 95
          sleep 1
          control s, note_slide: 1, note: ns.look - 2, cutoff_slide: 1, cutoff: 80
          t = (ring 8, 12).choose
          puts t
          sleep t + ds.look - 1
        end
      end
    end
  end
end

# sth dsaw, a 0.2, n ns.l, dcy 0.125, dcy_l 0.5, r 0.25, co 70

live_loop :dsaw, sync: :tri_b do
  stop
  ns = (ring [:e5, :b5])
  ds = (ring 0.25)
  with_fx :echo, phase: 2, decay: 16 do
    with_fx :reverb, room: 1 do
      with_fx :rbpf, centre: 100, mix: 0.95, amp: 2 do
        16.times do
          tick
          synth :dsaw, amp: 0.2, note: ns.look, decay: 0.125, decay_level: 0.5, release: 0.15, cutoff: 70
          sleep 0.25
        end
        sleep 8
      end
    end
  end
end

# sth tri, a 0.3, n ns.l, at 2, r 6, co 80
# w_trns -0.1
#   sth sine, a 0.3, n ns.l, at 2, r 6

live_loop :detuned, sync: :tri_b do
  stop
  ns = (ring [:a5, :fs5], [:fs5, :d5])
  ds = (ring 8)
  with_fx :reverb, room: 1 do
    tick
    synth :tri, amp: 0.3, note: ns.look, attack: 2, release: 6, cutoff: 80
    with_transpose -0.1 do
      synth :sine, amp: 0.3, note: ns.look, attack: 2, release: 6
    end
    sleep ds.look * 2
  end
end

