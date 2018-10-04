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

  with_fx :reverb, room: 1 do
    with_fx :flanger, mix: 0.3 do
      with_fx :tanh, mix: 0.2, reps: 32 do
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
