#utility functions

# level is used to wrap a section of code with a :level fx in order to easily
# manipulate the volume of all enclosed synths/samples/fx.
# It boils down to giving the fx opts values that are controlled by get & set
# so that every time a new instance of the fx is used, its opts can have
# values set by other parts of the code over time.

# name = name of the live_loop this fx sits in
# init_amp = initial volume of fx
# no_stop = does the enclosing live_loop ignore instructions to stop?
# block = reference to block of code this 'level' wrapper encloses

define :level do |name, init_amp = 0, no_stop = false, &block|
  # This set stop line was intended to allow an easy way to bulk-stop several
  # live_loops at once - but did not really allow individual customisation
  set(:"stop_#{name}", false) if get(:"stop_#{name}").nil?
  # set the variable that holds the amp value to use in the fx
  set(:"#{name}_lv_amp", init_amp) if get(:"#{name}_lv_amp").nil?
  # Here is where we would stop the live_loop if desired
  stop if get(:"stop_#{name}") and !no_stop
  # Actually wrap the code with the level fx, set with the current value
  # of the script controlled volume variable
  with_fx :level, amp: get(:"#{name}_lv_amp") do |lv|
    # Store reference to the fx node so that it can be manipulated elsewhere
    set(:"#{name}_lv", lv)
    # Run the enclosed code
    block.call
  end
end

# slide is a function used to smoothly fade a synth, sample or fx opt's value
# (or multiple opt values at once) from one number to another.
# Note: this must be called *from outside* the live loop in question,
# or opt values will oscillate undesirably.
# Many thanks to [https://github.com/rbnpi](Robin Newman) for sharing the code
# that this is adapted from :-)
# (Originally discussed here:
# [Smooth Parameter Automation](https://in-thread.sonic-pi.net/t/smooth-parameter-automation/1626))

# pointers = references to a synth, sample or fx node, or an array of them
# (for example, as set by the above 'level' function)
# duration = time length in beats to slide over
# snap = whether to 'snap' the value back to the starting value after the slide
# opt = key/value pair describing the opt to manipulate and its new value.
# (can be in the form opt: x, where only the desired end value is given, or
# in the form opt: [a, b], giving the exact start and end values of the slide).

define :slide do |pointers, duration, snap, opt|
  # Allow a single synth/sample/fx node as well as multiple at once if desired
  pointers = [pointers] unless pointers.is_a?(Array)
  pointers.each do |pointer|
    # Extract desired opt slide values
    key, val = *opt.flatten
    var = :"#{pointer}_#{key}"
    # Handle end only value as well as start & end value for slide
    start = mxr(var, val.is_a?(Array) ? val[0] : (duration.positive? ? nil : val))
    finish = val.is_a?(Array) ? val[1] : val
    # Ignore slide if start and end are the same value and sliding over time
    return if start == finish && duration.positive?
    # Set incremental values of slide to use over time, or instantaneous value
    l = if duration.positive?
      (line start, finish, steps: 11, inclusive: true).stretch(2).drop(1).butlast.ramp
    else
      (ring finish)
    end
    # Set time increment of each slide 'slice'
    dt = duration / 20.0
    # Perform sliding in a separate thread to avoid affecting current thread's timing
    in_thread do
      # For each slice of the slide
      l.length.times do
        tick
        # Print debug value
        puts "#{var}: #{l.look}"
        # Retrieve the desired synth/sample/fx node and actually control its opt
        control get(pointer), key => l.look, (key.to_s+"_slide").to_sym => dt
        sleep dt
        # Store the current value of the sliding opt so that it can be used to
        # initialise a new synth/sample/fx if the old one ends before the slide
        # has completed
        set var, l.look
      end
      # 'Snap' the value of the opt to a certain value if asked
      # (Hard coded to 0 here unintentionally)
      control get(pointer), key => start, (key.to_s+"_slide").to_sym => 0 if snap
    end
  end
end

# mxr was created to possibly initialise the variables that stored
# the sliding opt values if they had not already been initialised, or to
# override their values.

# key = opt name
# value = new value

define :mxr do |key, value = nil|
  value ? set(key, value) : (get(key) || set(key, 0))
end

# degs2ns seemed like a reasonable function to convert a list of scale degrees
# and information about a scale into actual note values

# degs = ring or array of scale degrees
# scl = array specifying the scale to use
# (default can be provided by using set(:r, [tonic_note, scale_name]))

define :degs2ns do |degs, scl = get(:r, [:d2, :major])|
  tonic, sc = scl
  degs.map do |deg|
    if rest?(deg)
      :r
    else
      degree(deg, tonic, sc)
    end
  end
end
