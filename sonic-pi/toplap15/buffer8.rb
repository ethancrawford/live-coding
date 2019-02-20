use_bpm 100


# sth sine, a 0.5, n ns.l, at a, r d - a
# sth saw, a 0.5, n ns2.l, at a, r d - a
# sth chipbass, a 1, n ns3.l, at a, r d - a

live_loop :chord, sync: :fd do
  stop
  use_random_seed 564361
  ns = (ring :d4, :e4, :d4, :c4, :c4)
  ns2 = (ring :f3, :d3, :e3, :f3, :e3)
  ns3 = (ring :g3, :a3, :fs3, :d3, :f3)
  ds = (ring 8)
  at = (ring 0.25, 0.5, 1)
  with_fx :reverb, room: 1 do
    with_fx :rbpf, centre: 50, amp: 2 do |rb|
      5.times do
        d = ds.choose
        a = at.choose
        tick
        set(:n, ns3.look)
        set(:d, d)
        control rb, centre_slide: 1, centre: 70
        synth :sine, amp: 0.5, note: ns.look, attack: a, release: d - a
        synth :saw, amp: 0.5, note: ns2.look, attack: a, release: d - a
        synth :chipbass, amp: 1, note: ns3.look, attack: a, release: d - a
        sleep 1
        control rb, centre_slide: 1, centre: 50
        sleep d - 1
      end
    end
  end
end

# sth square, a 0.5, n ns3.l - 12, r d, co 60

live_loop :sq_bass, sync: :fd do
  stop
  use_random_seed 564361
  ns3 = (ring :g3, :a3, :fs3, :d3, :f3)
  ds = (ring 8)
  at = (ring 0.25, 0.5, 1)
  
  5.times do
    d = ds.choose
    rand_skip
    tick
    synth :square, amp: 0.5, note: ns3.look - 12, release: d, cutoff: 60
    sleep d
  end
end

# sth sine, a 0.12, n ns.l, r ds.l, co 90

live_loop :sine_echoes, sync: :fd do
  stop
  ns = (ring :g4, :b4, :d5, :g5, :r, :e5, :c5, :b4, :a4, :c5)
  ds = (knit 0.25, 4, 2, 1, 1, 1, 0.25, 2, 2.5, 1, 1, 1)
  with_fx :reverb, room: 1, mix: 0.5 do
    with_fx :echo, phase: 0.5, decay: 10, reps: ns.length do
      tick
      synth :sine, amp: 0.12, note: ns.look, release: ds.look, cutoff: 90
      sleep ds.look
    end
  end
end

# sth sine, a 0.5, n ns.l
# sth saw, a 0.3, n ns.l - 0.15, co 60

live_loop :dsawed, sync: :fd do
  stop
  ns = (ring :r, :d4, :d4, :e4, :c4)
  ds = (ring 2, 0.75, 0.75, 0.5, 4)
  with_fx :reverb, room: 0.8 do
    with_fx :flanger, phase: 2, reps: ns.length do
      use_synth_defaults attack: 0.125, decay: 0.125, decay_level: 1, release: ds.look
      tick
      synth :sine, amp: 0.5, note: ns.look
      synth :saw, amp: 0.3, note: ns.look - 0.15, cutoff: 60
      sleep ds.look
    end
  end
end

# sth square, a 0.3, n ns.l, at ds.l*0.25, sus ds.l*0.75, r 0
# sth prophet, a 0.2, n ns.l - 12, at ds.l*0.25, sus ds.l*0.75, r 0

live_loop :crushed_square, sync: :fd do
  stop
  r = (ring :g3, :c4, :a3, :d4, :c4).tick(:r)
  ns = (ring :r, r, r, r)
  ds = (ring 0.75, 0.25, 0.5, 0.5)
  
  with_fx :rbpf, centre: 60, mix: 0.9, amp: 2 do
    with_fx :bitcrusher, sample_rate: 3000, mix: 0.3 do
      16.times do
        tick
        synth :square, amp: 0.3, note: ns.look, attack: ds.look * 0.25, sustain: ds.look * 0.75, release: 0
        synth :prophet, amp: 0.2, note: ns.look - 12, attack: ds.look * 0.25, sustain: ds.look * 0.75, release: 0
        sleep ds.look
      end
    end
  end
end
