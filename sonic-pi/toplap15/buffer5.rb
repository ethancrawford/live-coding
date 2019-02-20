use_bpm 100

live_loop :met do
  sleep 2
end

slide :bd_level, 16, amp: 0
slide :tri_level, 16, amp: 0
slide :hats_level, 16, amp: 0
slide :twip_level, 16, amp: 0

# sth mod_sine, a 0.5, n ns.look, mod_r 7, mod_ph 1, mod_w 1, at 16, r 16

live_loop :m1, sync: :met do
  stop
  with_fx :reverb, room: 1, mix: 0.8 do
    ns = (ring :e3, :b2)
    tick
    synth :mod_sine, amp: 0.5, note: ns.look, mod_range: 7, mod_phase: 1, attack: 16, release: 16
    sleep 32
  end
end

# sth mod_sine, a 0.5, n ns.look, mod_r 3, mod_ph 1, at 16, r 16

live_loop :m2, sync: :met do
  stop
  with_fx :reverb, room: 1, mix: 0.8 do
    ns = (ring :e2, :b3)
    tick
    synth :mod_sine, amp: 0.5, note: ns.look, mod_range: 3, mod_phase: 1, attack: 16, release: 16
    sleep 32
  end
end

# sth square, a 0.5, n [ns.l, ns.l - 12], r ds.look

live_loop :m3, sync: :m1 do
  stop
  with_fx :reverb, room: 1, mix: 0.8 do
    ns = (ring :e3, :d3, :fs3)
    ds = (ring 28, 8, 28)
    tick
    set(:tri_bass, ns.look == :fs3 ? :b1 : :e1)
    cue :two if ns.look == :e3
    with_fx :bitcrusher, bits: 6, sample_rate: 3000, cutoff: 90, mix: 0.3 do
      with_fx :rlpf, res: 0.7, cutoff: 60 do
        synth :square, amp: 0.5, note: [ns.look, ns.look - 12], release: ds.look
        sleep ds.look
      end
    end
    
  end
end
