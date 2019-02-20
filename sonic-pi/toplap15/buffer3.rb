set(:root, :c5)
set(:arp_p, (ring 4, 12, 5, 7))

set(:a_slide, 32)
set(:a, 1)

set(:bass_p, (ring 36, 36, 34, 38))

define :arp do |transpose = 0|
  get(:root) + get(:arp_p).look(:n) + transpose
end

define :bass do |transpose = 0|
  get(:root) - get(:bass_p).look(:n) + transpose
end


live_loop :met do
  sleep 2
end


# sth tri, n arp, at 0.125, r 0.125

live_loop :arp1, sync: :met do
  stop
  ds = (ring 0.25, 0.25, 0.25, 0.25)
  with_fx :level, amp: 1, amp_slide: get(:a_slide) do |l|
    control l, amp: get(:a)
    with_fx :rlpf, cutoff: 50, mix: 1, amp: 2, reps: 128 do
      tick(:n)
      synth :tri, note: arp, attack: 0.125, release: 0.125
      sleep ds.look(:n)
    end
  end
end

# sth saw, n g(:arp_p) + g(:root) - 12, sus 8, r 0

live_loop :arp2, sync: :met do
  stop
  with_fx :level, amp: 1, amp_slide: get(:a_slide) do |l|
    control l, amp: get(:a)
    with_fx :tremolo, phase: 0.25, depth: 0.8 do
      with_fx :rlpf, cutoff: 70, reps: 4 do
        synth :saw, note: get(:arp_p) + get(:root) - 12, sustain: 8, release: 0
        sleep 8
      end
    end
  end
end

# fx flanger, fb 0.8, ph 4, mx 0.2
#   sth subpulse, a 0.3, n bass(12), r 8, pn -0.3
# fx rlpf, co 65
#   sth prophet, a 0.3, n bass, sus 6, r 2, pn 0.3

live_loop :bass_prophet, sync: :arp2 do
  stop
  tick(:n)
  with_fx :level, amp: 1 do
    with_fx :reverb, room: 1 do
      with_fx :echo, phase: 0.5, decay: 8, mix: 0.8 do
        with_fx :slicer, seed: 50726423, phase: 0.125, probability: 1, prob_pos: 0.5, mix: 0.3 do
          with_fx :flanger, feedback: 0.8, phase: 4, mix: 0.2 do
            synth :subpulse, amp: 0.3, note: bass(12), release: 8, pan: -0.3
          end
          with_fx :rlpf, cutoff: 65 do
            synth :prophet, amp: 0.3, note: bass, sustain: 6, release: 2, pan: 0.3
          end
        end
        sleep 8
      end
    end
  end
end