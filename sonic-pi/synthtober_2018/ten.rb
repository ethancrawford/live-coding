use_bpm 50

live_loop :met do
  sleep 2
end

live_loop :hollow, sync: :met do
  with_fx :reverb, room: 1 do
    with_fx :bitcrusher, bits: 7, sample_rate: 6000, cutoff: 90, mix: 0.5 do
      with_fx :rbpf, centre: 65, res: 0.9, mix: 1, amp: 3 do
        with_fx :distortion, mix: 0.1, distort: 0.4 do
          ns = (ring :f3, :g3, :a3, :e3, :f3, :g3, :d3, :a3)
          tick
          synth :hollow, amp: 2, note: ns.look, sustain: 8, release: 0.25, cutoff: 70
          sleep 8
        end
      end
    end
  end
end

live_loop :bass, sync: :met do
  stop
  ns = (ring :d2, :c2, :d2, :c2, :d2, :c2, :g1, :bb1)
  with_fx :rbpf, centre: 60, res: 0.8, mix: 0.9, amp: 3 do
    with_fx :distortion, distort: 0.6, amp: 0.8 do |d|
      with_fx :rhpf, cutoff: 90, mix: 0.5 do
        tick
        distort = true
        s = synth :square, note: ns.look, amp: 1, sustain: 8, release: 0.05, pan: 0.5, cutoff: 55
        s = synth :tri, note: ns.look, amp: 1, sustain: 8, release: 0.05, pan: 0.5, cutoff: 100
        control d, distort_slide: 2, distort: 0.995 if distort
        sleep 2
        control d, distort_slide: 6, distort: 0.5 if distort
        sleep 6
      end
    end
  end
end

live_loop :organ, sync: :met do
  #stop
  n1s1 = (ring :d4, :g4, :c4, :a4, :g4, :b3, :e4, :c4)
  n1s2 = (ring :d4, :b3, :c4, :d4, :e4, :g4, :d4, :c4)
  n1s3 = (ring :b3, :e4, :d4, :g4, :e4, :g4, :b4, :c5)
  n1s4 = (ring :b4, :g4, :a4, :g4, :a4, :b3, :c4, :d4)
  n1 = n1s1 + n1s2 + n1s3 + n1s4

  n2s1 = (ring :d4, :c4, :d4, :a4, :b4, :e4, :g4, :b3)
  n2s2 = (ring :c4, :e4, :g4, :d4, :e4, :c4, :d4, :b3)
  n2s3 = (ring :e4, :a4, :g4, :d4, :e4, :d4, :g4, :b3)
  n2s4 = (ring :a3, :d4, :e4, :g4, :e4, :a4, :g4, :d4)
  n2 = n2s1 + n2s2 + n2s3 + n2s4

  ns = n1 + n2

  with_fx :level, amp: 0 do |l|
    control l, amp_slide: 32, amp: 1
    with_fx :reverb, room: 1 do
      with_fx :flanger, mix: 0.3 do
        with_fx :tanh, mix: 0.2, reps: (8 * 32) do
          tick
          with_fx :rbpf, centre: 75, res: 0.8, mix: 0.7 do
            s = synth :dtri, amp: 0.25, note: ns.look, release: 0.25, pan: -0.35
            s2 = synth :pretty_bell, amp: 0.25, note: ns.look + 12, attack: 0.01, release: 0.375, pan: -0.35
          end
          sleep 0.125
        end
      end
    end
  end
end

ns1 = (ring :e5, :g5, :r, :d5, :d5, :d5, :r, :d5, :r, :d5, :r, :c5, :d5, :e5, :c5, :d5)
ns2 = (ring :e5, :g5, :r, :d5, :d5, :d5, :r, :d5, :r, :d5, :r, :c5, :c5, :b4, :a4, :b4)
ns3 = (ring :e5, :g5, :d5, :e5, :c5, :d5, :b4, :c5, :a4, :b4, :c5, :d5, :e5, :g5, :a5, :b5)
ns4 = (ring :d5, :e5, :r, :e5, :e5, :a5, :r, :b5, :r, :b5, :r, :b5, :b5, :a5, :a5, :a5)
ns5 = (ring :g5, :g5, :r, :g5, :g5, :g5, :r, :g5, :r, :g5, :r, :g5, :g5, :g5, :g5, :g5)

ns_a = ns1 + ns2 + ns1 + ns3 + ns4 + ns5 + ns4 + ns5
set(:sub_a_ns, ns_a)
set(:sub_a_ds, (ring 0.125))


define :mel do |ns, ds, &block|
  with_fx :echo, phase: 0.5, decay: 4, mix: 0.2 do
    with_fx :rbpf, centre: 75, res: 0.6, mix: 0.8 do
      with_fx :rbpf, centre: 100, cutoff: 90, res: 0.8, mix: 0.9, amp: 1.5 do |b|
        with_fx :tanh, mix: 0.2 do
          with_fx :distortion, distort: 0.95, amp: 0.7 do
            ns.length.times do
              tick
              block.call
              synth :sine, amp: 0.1, note: ns.look - 12, attack: 0.02, release: 0.105, pan: 0.25 if get(:on)
              synth :sine, amp: 0.4, note: ns.look, attack: 0.02, release: 0.105, pan: 0.25 if get(:on)
              control b, centre_slide: 0.125, centre: 80, cutoff_slide: 0.125, res_slide: 0.125, cutoff: 70, res: 0.3 if get(:on)
              control b, centre_slide: 0.05, centre: 100, cutoff_slide: 0.05, cutoff: 90, res_slide: 0.05, res: 0.8 unless get(:on)

              sleep 0.125
            end
          end
        end
      end
    end
  end
end


live_loop :sub1, sync: :met do
  stop
  ns = get(:sub_a_ns)
  ds = get(:sub_a_ds)
  mel(ns, ds) do
    set(:on, look % 2 == 0)
  end
end

live_loop :sub2, sync: :met do
  stop
  ns = get(:sub_a_ns)
  ds = get(:sub_a_ds)
  mel(ns, ds) do
    set(:on, look % 2 == 1)
  end
end

ns6 = (ring :b5, :c6, :r, :c6, :c6, :c6, :r, :c6, :r, :c6, :r, :c6, :c6, :b5, :b5, :b5)
ns_b = ns6 + ns6 + ns6 + ns6
set(:sub_b_ns, ns_b)
set(:sub_b_ds, (ring 0.125))

live_loop :sub3, sync: :met do
  stop
  ns = get(:sub_b_ns)
  ds = get(:sub_b_ds)

  sleep 8
  mel(ns, ds) do
    set(:on, look % 2 == 0)
  end
end

live_loop :sub4, sync: :met do
  stop
  ns = get(:sub_b_ns)
  ds = get(:sub_b_ds)

  sleep 8
  mel(ns, ds) do
    set(:on, look % 2 == 1)
  end
end
