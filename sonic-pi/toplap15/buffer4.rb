live_loop :met do
  sleep 2
end

# s :glitch_perc1, hp 100 if (spr 5, 8).l
# s :drum_cym_closed, hp: (r 100, 125).t(f) if (b 0, 0, 0, 0, 1, 0, 1, 1).l

live_loop :hats, sync: :met do
  stop
  with_fx :level, amp: get(:hats_level_amp) do |lv|
    set(:hats_level, lv)
    16.times do
      tick
      sample :glitch_perc1, hpf: 100 if (spread 5,8).look
      sample :drum_cymbal_closed, hpf: (ring 100, 125).tick(:f) if (bools 0,0,0,0,1,0,1,1).look
      sleep 0.125
    end
  end
end


# s :bd_boom, a 2 if (b 1, 0, 0, 1, 0, 0, (b 0, 0, 0, 0, 0, 0, 0, 1).str(8).t(b), 0).l

live_loop :bd, sync: :bd_on do
  #sync :bass_prophet
  with_fx :level, amp: 1 do |lv|
    set(:bd_level, lv)
    64.times do
      tick
      sample :bd_boom, amp: 2 if (bools 1,0,0,1,0,0,(bools 0,0,0,0,0,0,0,1).stretch(8).tick(:b),0).look
      sleep 0.125
    end
  end
end


# s :elec_twip if (b 0, 0, 0, 0, 1, 0, 0, 0).l

live_loop :twip, sync: :twip_on do
  stop
  with_fx :level, amp: get(:twip_level_amp) do |lv|
    set(:twip_level, lv)
    16.times do
      tick
      sample :elec_twip if (bools 0,0,0,0,1,0,0,0).look
      sleep 0.125
    end
  end
end


live_loop :seq, sync: :met do
  at 48 do
    puts "--------------------hats on!"
    slide :hats_level, 16, amp: 1
    slide :pad1_level, 16, amp: 0
    slide :pad2_level, 16, amp: 0
    slide :arp_level, 16, amp: 0
    slide :pulse_level, 16, amp: 0
  end
  at 88 do
    puts "--------------------bddddddd on!"
    cue :bd_on
  end
  at 104 do
    cue :twip_on
  end
  at 120 do
    cue :tri
  end
  
  sleep 120
  stop
end

# syn tri, a 0.5, n ns.l - 12, sus ds.l, co 100
# syn sine, a 0.5, n ns2.l + o, sus ds.l

live_loop :tanh_tri, sync: :tri do
  stop
  with_fx :level, amp: get(:tri_level_amp) do |lv|
    set(:tri_level, lv)
    ns = (knit :r, 1, :g4, 5, :r, 1, :f4, 5, :r, 1, :f4, 5, :r, 1, :c4, 5)
    ns2 = (knit :r, 1, :c5, 5, :r, 1, :a4, 5, :r, 1, :a4, 5, :r, 1, :g4, 5)
    
    ds = (knit 0.375, 1, 0.125, 5).repeat(4)
    with_fx :bpf, centre: 80, mix: 0.75, amp: 1.5 do
      with_fx :bpf, centre: 70, mix: 0.92, amp: 2 do |bp|
        
        with_fx :tanh, amp: 0.4, mix: 0.25 do
          o = (ring 0, 12).choose
          puts o
          ns.length.times do
            tick
            #stop hats
            synth :tri, amp: 0.5, note: ns.look - 12, sustain: ds.look, cutoff: 100
            synth :sine, amp: 0.5, note: ns2.look + o, sustain: ds.look
            control bp, centre: (line 70, 110, steps: 5).tick(:l) if ns.look != :r
            sleep ds.look
          end
        end
      end
    end
  end
end
