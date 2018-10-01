live_loop :met do
  sleep 2
end

live_loop :one, sync: :met do
  use_random_seed 383654 + look
  ns = (scale :f3, :minor_pentatonic, num_octaves: 2).shuffle.take(5)
  set(:ns, ns)
  ds = (knit 0.25, 4, 3, 1)

  times = (ring 1, 2).choose
  set(:times, times)
  (times * 5).times do
    tick
    s = synth :tri, note: ns.look, release: ds.look, cutoff: 90
    control s, cutoff_slide: 0.125, cutoff: 60
    sleep ds.look
  end
end

live_loop :two, sync: :met do
  use_random_seed 383654 + look
  ns = (ring get(:ns).rotate(2).first, get(:ns).rotate(2).last)

  d = (ring 1, 2, 3).choose
  ds = (ring d, 4 - d)
  times = get(:times)
  with_fx :rlpf, cutoff: 80 do
    with_fx :bitcrusher, sample_rate: 3000 do
      (times * 2).times do
        tick
        n = ns.look - 24
        n += 12 if n < 36
        synth :fm, note: n, sustain: ds.look - 0.5, depth: 2, cutoff: 70
        sleep ds.look
      end
    end
  end
end

live_loop :three, sync: :met do
  ns = get(:ns).rotate(3)
  ds = (ring 4)

  with_fx :reverb, room: 1 do
    with_fx :echo, phase: 0.75, decay: 4 do
      s = synth :prophet, amp: 0.5, note: ns.first, attack: ds.look / 2.0, release: ds.look / 2.0, cutoff: 60
      synth :prophet, amp: 0.5, note: ns.drop(1).take(1).look, release: 0.25, cutoff: 80
      control s, cutoff_slide: 4, cutoff: 120
      sleep ds.look
    end
  end
end
