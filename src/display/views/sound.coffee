# sound controller


audio = new AudioContext() # global lol

createSineWave = (audio, duration) ->
  osc = audio.createOscillator()
  osc.type = "sine"
  osc.start audio.currentTime
  osc.stop audio.currentTime + duration

  osc

chain = (soundNodes) ->
  len = soundNodes.length - 1
  for i in [0...len]
    soundNodes[i].connect soundNodes[i + 1]

# not pure. value is sideefects, returns nothing
rampDown = (audio, value, startValue, duration) ->
  value.setValueAtTime startValue, audio.currentTime
  value.exponentialRampToValueAtTime 0.01, audio.currentTime + duration

createAmplifier = (audio, startValue, duration) ->
  amplifier = audio.createGain()
  rampDown audio, amplifier.gain, startValue, duration

  amplifier


module.exports = (frequency, loudness=0.2) ->
  # gets audio from global durp
  return ->
    duration = 1
    sineWave = createSineWave audio, duration

    sineWave.frequency.value = frequency

    chain [
      sineWave,
      createAmplifier(audio, loudness, duration),
      audio.destination
    ]

