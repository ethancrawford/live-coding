define :slide do |pointer, duration, opt|
  key, finish = *opt.flatten
  var = :"#{pointer}_#{key}"
  start = get(var)
  return if start == finish
  l = (line start, finish, steps: 11, inclusive: true).stretch(2).drop(1).butlast.ramp
  dt = duration / 20.0
  puts "slide #{pointer} #{key} #{var} #{start} #{finish} #{duration}"
  in_thread do
    l.length.times do
      control get(pointer), key => l.tick, (key.to_s+"_slide").to_sym => dt
      sleep dt
      set var, l.look
    end
  end
end

#set initial volume value on first run
defonce :setup, override: true do
  set :growl_level_amp, 1
  set(:pad1_level_amp, 1)
  set(:pad2_level_amp, 1)
  set(:arp_level_amp, 1)
  set(:pulse_level_amp, 1)
  set(:hats_level_amp, 0)
  set(:bd_level_amp, 1)
  set(:twip_level_amp, 1)
  set(:tri_level_amp, 1)
end

live_loop :met do
  sleep 2
end

# sth tri, a 0.5, n a1
# sth dark_a, a 0.3 n a1, no 1, rng 0.2
# fx rm, fq 62, mx 0.8
#   sth dark_a, a 0.3, n d2, no 0, rng 1

live_loop :pad1, sync: :met do
  with_fx :level, amp: get(:pad1_level_amp) do |lv|
    set(:pad1_level, lv)
    with_fx :slicer, phase: 0.125, mix: 0, mix_slide: 32 do |s|
      use_synth_defaults sustain: 64, release: 4
      control s, mix: 0.5
      synth :tri, amp: 0.5, note: :a1
      synth :dark_ambience, amp: 0.3, note: :a1, noise: 1, ring: 0.2
      with_fx :ring_mod, freq: 62, mix: 0.8 do
        synth :dark_ambience, amp: 0.3, note: :d2, noise: 0, ring: 1
      end
      sleep 32
      control s, mix: 0
      sleep 32
    end
  end
end

# sll
#   sth blade a 3, n [d2, g3, a3], at 8, r 8, co 70
#   sl 16
live_loop :pad2, sync: :met do
  with_fx :level, amp: get(:pad2_level_amp) do |lv|
    set(:pad2_level, lv)
    with_fx :level, amp: get(:dm_level_amp) do
      synth :blade, amp: 3, note: [:d2, :g3, :a3], attack: 8, release: 8, cutoff: 70
      sleep 16
    end
  end
end

# sth sine a 0.3, n ns.tick, r 0.125

live_loop :arp, sync: :met do
  with_fx :level, amp: get(:arp_level_amp) do |lv|
    set(:arp_level, lv)
    ns = (ring :d5, :c5, :a4, :d5) +
      (ring :c5, :a4, :g4, :c5) +
      (ring :a4, :g4, :f4, :a4) +
      (ring :g4, :a4, :c5, :e5)
    with_fx :panslicer, phase: 0.25, probability: 0.9, seed: 3837453, pan_min: -0.75, pan_max: 0.75, mix: 0.5 do
      with_fx :echo, phase: 0.25, mix: 0.5, decay: 2, reps: 32 do
        synth :sine, amp: 0.3, note: ns.tick, release: 0.125
        sleep 0.125
      end
    end
  end
end


# sth subpulse, a 1.5, n [d5, d4], at 0.25, r 8, co 70

live_loop :pulse, sync: :met do
  with_fx :level, amp: get(:pulse_level_amp) do |lv|
    set(:pulse_level, lv)
    with_fx :reverb, room: 1 do
      with_fx :rbpf, centre: 60, mix: 1, centre_slide: 0.25 do |b|
        control b, centre: 70
        synth :subpulse, amp: 1.5, note: [:d4, :d5], attack: 0.25, release: 8, cutoff: 70
        sleep 16
      end
    end
  end
end

