# 'Teach Yourself Irish Breakbeats'
# Produced on a development build of Sonic Pi 3.3.0
# For the December 2020 edition of the Sonic Pi Monthly Challenge.
# This month's theme: "RPM = BPM" - dedicated to vinyl record speeds.
# The BPM of the composition must be a multiple of a vinyl record speed.
#
# This piece is just a bit of fun messing about with a sample from archive.org,
# from a series of audio recordings on 12" vinyl titled "Teach Yourself Irish".
# The external sample is licensed CC-0 and can be downloaded here:
# https://archive.org/download/Gael-linnAudioRecordingForTeachYourselfIrish1961/Side1_mono.aiff

# The rest of the sounds are from built in synths, samples and fx distributed
# with Sonic Pi.
# Minimum version of Sonic Pi required: v3.0 ? (for 'set'/'get')
# Corresponding audio/visual media:
# An audio recording of this piece can be found on SoundCloud at
# https://soundcloud.com/ethancrawford/teach-yourself-irish-breakbeats.

bpm = 33 # or 45, 78
use_bpm bpm
set(:stop, false)

side1 = "path/to/Side1_mono.aiff" # Change this to match your own path
sample side1, amp: 1.75, finish: 0.005
sleep 3

live_loop :loop do
  stop if get(:stop)

  if tick(:l) == 25
    sleep 8
    cue :mel
  end
  sample :loop_breakbeat, amp: 33.0 / bpm, beat_stretch: 2
  sleep 2
end

sleep 2

live_loop :two do
  stop if get(:stop)

  use_random_seed 6666 + look(:a)
  tick(:sla)
  sla = (ring 1.75, 0.5, 0.25, 0.125).look(:sla)

  with_fx :level, amp: 1.75 do
    8.times do
      tick(:a, step: 40)
      start = rrand(0.005, 0.95)
      finish = start + 0.0032
      if one_in(4) && look(:sla) > 1
        with_fx :echo, phase: 0.375, decay: 8, mix: 1 do |ec|
          sample side1, start: start, finish: finish
        end
      else
        sample side1, start: start, finish: finish
      end
      sleep sla
    end


    use_random_seed 4299398 + look(:b)
    tick(:slb)
    slb = (ring 1, 0.5, 0.25, 0.125).look(:slb)

    2.times do
      tick(:b, step: 60)
      start = rrand(0.005, 0.95)
      finish = start + 0.0016
      if one_in(4) && look(:slb) > 1
        with_fx :echo, phase: 0.375, decay: 8, mix: 1 do |ec|
          sample side1, start: start, finish: finish
        end
      else
        sample side1, start: start, finish: finish
      end
      sleep slb
    end

    use_random_seed 7844842 + look(:c)
    tick(:slc)
    slc = (ring 1, 0.5, 0.25, 0.125).look(:slc)

    5.times do
      tick(:c, step: 80)
      start = rrand(0.005, 0.95)
      finish = start + 0.002
      if one_in(4) && look(:slc) > 1
        with_fx :echo, phase: 0.375, decay: 8, mix: 1 do |ec|
          sample side1, start: start, finish: finish
        end
      else
        sample side1, start: start, finish: finish
      end
      sleep slc
    end
  end
end


live_loop :dr1 do
  stop if get(:stop)

  with_fx :panslicer, pan_min: -1, pan_max: 1, phase: 8, wave: 2 do
    8.times do
      sample :ambi_soft_buzz, amp: 33.0 / bpm, beat_stretch: 2, finish: 0.5, rpitch: -2
      sleep 1
    end
  end
end

live_loop :bass do
  ns = (scale :c1, :minor_pentatonic, num_octaves: 1).shuffle.take(4)
  ds = (ring 8)
  stop if get(:stop)
  with_fx :rhpf, cutoff: 50, res: 0.8, amp: 1.5 do |rh|
    with_fx :tanh, mix: 0.0 do |th|
      control rh, cutoff_slide: 8, cutoff: 90
      control th, mix_slide: 8, mix: 0.6
      1.times do
        tick
        synth :fm, amp: rrand(0.2, 0.4), note: ns.look, sustain: ds.look, release: 0, depth: 1, divisor: 1, cutoff: 110
        synth :tri, amp: rrand(0.1, 0.2), note: ns.look + 0.1, sustain: ds.look, release: 0, cutoff: rrand(50, 80)
        synth :saw, amp: rrand(0.1, 0.2), note: ns.look + 0.2, sustain: ds.look, release: 0, cutoff: rrand(60, 90)
        sleep ds.look
      end
    end
  end
end

live_loop :mel3, sync: :mel do
  with_fx :reverb, room: 1 do
    with_fx :wobble, filter: 1, phase: 8, cutoff_min: 60, cutoff_max: 90, mix: 0.7 do
      with_fx :rbpf, centre: 80, mix: 0.8, amp: 2 do
        8.times do
          ns = ((scale :c3, :minor_pentatonic).take(3) +
                (scale :c4, :minor_pentatonic, num_octaves: 2).take(7).rotate(tick(:r)).take(1))
          ds = (ring 0.25)

          ns.length.times do
            tick
            synth :sine, amp: 0.3, note: ns.look, release: ds.look
            synth :blade, amp: 0.2, note: ns.look, release: ds.look, cutoff: 90
            sleep ds.look
          end
        end
        stop if get(:stop)
      end
    end
  end
end

sleep 100
set(:stop, true)
